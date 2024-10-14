import itertools
import datetime
import common

class Emitter:
    def __indent(self, indentation: int = 0):
        self.code += "    " * indentation
    
    def __init__(self):
        self.code: str = ""
        self.indentation: int = 0
        pass

    def clear(self):
        self.code = ""

    def add(self, text: str = ""):
        self.code += text
    
    def addLines(self, source: str = "", extra_indentation: int = 0):
        for line in source.splitlines(False):
            self.addLine(line, extra_indentation)

    def addLine(self, line: str = "", extra_indentation: int = 0) -> None:
        if len(line) == 0:
            self.__indent(self.indentation + extra_indentation)
            self.code += "\n"
        
        for l in line.splitlines(True):
            self.__indent(self.indentation + extra_indentation)
            self.code += l + "\n"

    def beginScope(self, newLine: bool = True) -> None:
        self.__indent()
        if newLine:
            self.code += "\n"
        self.indentation += 1

    def endScope(self) -> None:
        self.indentation -= 1
        self.__indent()
    
    def finish(self) -> str:
        return self.code

class Emitable:
    def __init__(self):
        self.emitters: list[Emitable] = list[Emitable]()
        self.emitter = Emitter()

    def add(self, emitter: 'Emitable') -> 'Emitable':
        self.emitters.append(emitter)
        return self

    def clear(self):
        self.emitter.clear()

    def emit(self) -> str:
        for emitter in self.emitters:
            emitter.clear()
            self.emitter.addLines(emitter.emit())
        return self.emitter.finish()
    
class DocCommentEmitter(Emitable):

    def __init__(self, comment: str):
        super().__init__()
        self.comment = comment

    def emit(self) -> str:
        self.clear()
        self.emitter.add("/**")
        self.emitter.beginScope()
        self.emitter.addLines(self.comment)
        self.emitter.endScope()
        self.emitter.addLine("*/")
        return self.emitter.finish()

class ModuleEmitter(Emitable):

    def __init__(self, module_name: str):
        super().__init__()
        self.module_name = module_name

    def clear(self):
        self.emitter.addLines(f'''
/*
    Copyright © {datetime.date.today().year}, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen

    This code is auto-generated by gen-spv-reflection, do not edit manually.
*/
module spirv.{self.module_name};
import spirv.spv;
''')

    def emit(self) -> str:
        self.clear()
        self.emitter.addLine()
        for emitter in self.emitters:
            for line in emitter.emit().splitlines(False):
                self.emitter.addLine(line)
            self.emitter.addLine()
        return self.emitter.finish()

class FuncParameter(Emitable):
    def __init__(self, type: str, name: str):
        self.type = type;
        self.name = name;

    def emit(self) -> str:
        return f"{self.type} {self.name}"

class FuncEmitter(Emitable):
    def __init__(self, returnType: str, name: str, params: list[FuncParameter]):
        super().__init__()
        self.name = name;
        self.returnType = returnType
        self.params = params
        self.comment = None

    def add(self, emitter: 'Emitable') -> 'FuncEmitter':
        return super().add(emitter)

    def setComment(self, comment: str) -> 'FuncEmitter':
        self.comment = DocCommentEmitter(comment)
        return self

    def emit(self) -> str:
        self.clear()
        if self.comment != None:
            self.emitter.add(self.comment.emit())
        
        self.emitter.add(f"{self.returnType} {self.name}(")
        for i, param in enumerate(self.params):
            self.emitter.add(param.emit())
            if (i+1 != len(self.params)):
                self.emitter.add(", ")
        self.emitter.add(") @nogc {\n")
        self.emitter.beginScope(False)
        super().emit()
        self.emitter.endScope()
        self.emitter.addLine("}")
        return self.emitter.finish()

class IfEmitter(Emitable):
    def __init__(self):
        super().__init__()
        self.conditions = list[str]()

    def addBranch(self, condition: str, body: Emitable) -> 'IfEmitter':
        self.conditions.append(condition)
        self.emitters.append(body)
        return self
    
    def addElse(self, body: Emitable) -> 'IfEmitter':
        self.conditions.append("else")
        self.emitters.append(body)
        return self

    def emit(self) -> str:
        self.clear()
        crange = list(zip(self.conditions, self.emitters))
        for i, (condition, emitable) in enumerate(crange):
            if i+1 == len(crange) and condition == "else":
                self.emitter.addLine(f"{{")
            elif i == 0 or condition != "else":
                self.emitter.addLine(f"if ({condition}) {{")
                
            
            self.emitter.beginScope()
            self.emitter.addLines(emitable.emit())
            self.emitter.endScope()
            self.emitter.add("}")

            if i+1 < len(crange):
                self.emitter.add(" else ")
                

        return self.emitter.finish()

class SwitchEmitter(Emitable):
    def __init__(self, caseArg: str, prefix: str):
        super().__init__()
        self.caseArg = caseArg
        self.prefix = prefix
        self.cases: dict[Emitter, list[str]] = dict[Emitter, list[str]]()
        self.default: Emitter = None

    def addCaseBody(self, to: 'Emitter') -> 'SwitchEmitter':
        if to not in self.cases:
            self.cases[to] = list[str]()

    def addCase(self, case: str, to: 'Emitter') -> 'SwitchEmitter':
        if to not in self.cases:
            self.cases[to] = list[str]()
        
        self.cases[to].append(case)
        return self
    
    def setDefault(self, to: 'Emitter') -> 'SwitchEmitter':
        self.default = to
        return self
    
    def emit_case(self, case: str, to: 'Emitter'):
        
        if len(case) > 0:
            if case == "default":
                self.emitter.addLine("default:")
            elif len(self.prefix) > 0:
                self.emitter.addLine(f"case {self.prefix}.{case}:")
            else:
                self.emitter.addLine(f"case {case}:")
            
        if to != None:
            self.emitter.beginScope(False)
            self.emitter.addLines(to.emit())
            self.emitter.endScope()

    def emit(self) -> str:
        self.clear()
        if self.default == None:
            self.emitter.add("final ")
        self.emitter.addLine(f"switch ({self.caseArg}) {{")
        self.emitter.beginScope(False)
        if self.default != None:
            self.emit_case("default", self.default)
            self.emitter.addLine()
        
        for body, keys in self.cases.items():
            for key in keys:
                self.emit_case(key, None)
            self.emit_case("", body)


        self.emitter.endScope()
        self.emitter.addLine("}")
        return self.emitter.finish()

class BodyEmitter(Emitable):
    def __init__(self, body: str):
        super().__init__()
        self.emitter.addLines(body)
        self.body = self.emitter.finish()
    
    def emit(self) -> str:
        return self.body


class EnumEmitter(Emitable):

    def __init__(self, name: str):
        super().__init__()
        self.name = common.toPascalCase(name);
        self.elements = list[tuple[str, str]]()
    
    def add(self, name: str, convertCase: bool = False):
        toInsert = (common.toCamelCase(name) if convertCase else name, None)
        self.elements.append(toInsert)
    
    def addKV(self, name: str, value: any, convertCase: bool = False):
        toInsert = (common.toCamelCase(name) if convertCase else name, str(value))
        self.elements.append(toInsert)

    def emit(self) -> str:
        self.clear()
        self.emitter.addLine(f"enum {self.name} {{")
        self.emitter.beginScope()
        for element in self.elements:
            if element[1] != None:
                self.emitter.addLine(f"{element[0]} = {element[1]},")
            else:
                self.emitter.addLine(f"{element[0]},")
        self.emitter.endScope()
        self.emitter.addLine("}")
        return self.emitter.finish()