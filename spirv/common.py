from typing import *
import json

class SpirvOperandInfo:
    def __init__(self, data: dict[str, str]):
        self.kind = data["kind"]
        
        if "quantifier" in data:
            self.quantifier = data["quantifier"]
        else:
            self.quantifier = None
        
        if "name" in data:
            self.name = data["name"]
        else:
            self.name = None

    def getKind(self) -> str:
        return self.kind

    def getQuantifier(self) -> str:
        return self.quantifier

    def getName(self) -> str:
        return self.name

# Information about a Spirv instruction
class SpirvInstrInfo:
    def __parseOperand(self, operand: dict[str]):
        self.operands.append(SpirvOperandInfo(operand))

    def __init__(self, instr: dict):
        self.opname: str = instr["opname"]
        self.opclass: str = instr["class"]
        self.opcode: int = instr["opcode"]
        self.operands = list[SpirvOperandInfo]()
        if "operands" in instr:
            for operand in instr["operands"]:
                self.__parseOperand(operand)

    def getOpName(self) -> str:
        return self.opname
    
    def getOpCode(self) -> int:
        return self.opcode

    def getClass(self) -> str:
        return self.opclass
    
    def hasResult(self) -> bool:
        for operand in self.operands:
            if operand.getKind() == "IdResult":
                return True
        return False

    def hasResultType(self) -> bool:
        for operand in self.operands:
            if operand.getKind() == "IdResultType":
                return True
        return False

    def getOperands(self) -> list[SpirvOperandInfo]:
        return self.operands

    def getOperandTypes(self) -> list[str]:
        mList = list[str]()

        for operand in self.operands:
            mList.append(operand.getKind())

        return mList

    def getOptionalOperandCount(self) -> int:
        counter = 0

        for operand in self.operands:
            if operand.getQuantifier() != None:
                if operand.getQuantifier() == "*":
                    return 65535
                else:
                    counter += 1
                
        return counter


    def getMinimumSize(self) -> int:
        counter = 0

        for operand in self.operands:
            if operand.getQuantifier() == None:
                counter += 1
                
        return counter
    
    def getMaximumSize(self) -> int:
        counter = 0

        for operand in self.operands:
            if operand.getKind() == "LiteralString":
                return 65535
            elif operand.getKind() == "Decoration":
                return 65535
            elif operand.getQuantifier() != None:
                if operand.getQuantifier() == "*":
                    return 65535
                else:
                    counter += 1
            else:
                counter += 1
                
        return counter

class SpirvClassInfo:
    def __init__(self, klass: dict):
        self.tag = klass["tag"]
        self.desc = klass["heading"]
        self.dName = "c" + toPascalCase(self.tag)

    def getTag(self) -> str:
        return self.tag
    
    def getTagPascalCase(self) -> str:
        return toPascalCase(self.tag)
    
    def getDName(self) -> str:
        return self.dName
    
    def getDescription(self) -> str:
        return self.desc
    
# Spirv grammar scanner
class SpirvGrammarScanner:
    
    """Constructor"""
    def __init__(self, grammarFile: str) -> None:
        
        # Load JSON
        with open(file=grammarFile, mode="r") as file:
            self.grammarJson = json.load(file)
        
        # Scan instruction list
        self.instructions = list[SpirvInstrInfo]()
        self.classes = list[SpirvClassInfo]()

        for klass in self.grammarJson["instruction_printing_class"]:
            if klass["tag"] != "@exclude":
                self.classes.append(SpirvClassInfo(klass))


        # Scan through all instructions and add them.
        # While omitting duplicates.
        for instr in self.grammarJson["instructions"]:
            toAdd = SpirvInstrInfo(instr)
            if (self.findInstruction(toAdd.getOpCode())) == -1:
                self.instructions.append(toAdd)

    def findInstruction(self, opcode: int) -> int:
        for i, instr in enumerate(self.instructions):
            if instr.getOpCode() == opcode:
                return i
        return -1
    
    def getInstructions(self) -> list[SpirvInstrInfo]:
        return self.instructions
    
    def getClasses(self) -> list[SpirvClassInfo]:
        return self.classes    

def toCamelCase(text: str) -> str:
    return text[0].lower() + ''.join(c for c in text.title() if c.isalnum())[1:]

def toPascalCase(text: str) -> str:
    return text[0].upper() + ''.join(c for c in text if c.isalnum())[1:]