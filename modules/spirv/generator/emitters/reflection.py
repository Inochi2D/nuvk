from common import *
from d_emit import *
import io

# Redefine them for completion
scanner: SpirvGrammarScanner = scanner
file: io.FileIO = file

module = ModuleEmitter("reflection")
module.add(BodyEmitter("import nulib.collections;"))
module.add(BodyEmitter("import numem;"))

# Spirv OpClass
spirvClasses = EnumEmitter("OpClass")
for klass in scanner.getClasses():
    spirvClasses.add(klass.getDName())
spirvClasses.add("unknown")
module.add(spirvClasses)

# Helpers
returnTrue = BodyEmitter("return true;")
returnFalse = BodyEmitter("return false;")
returnClassUnk = BodyEmitter("return OpClass.unknown;")
returnEmptyArr = BodyEmitter("return vector!(uint).init;")
returnZero = BodyEmitter("return 0;")

getClassFunc = FuncEmitter("OpClass", "getClass", [FuncParameter("Op", "code")]).setComment("Gets whether [Op] is of the specified opcode class.")
getClassSwitch = SwitchEmitter("code", "Op").setDefault(returnClassUnk)
getClassFunc.add(getClassSwitch)
classBodies = dict[str, BodyEmitter]()

for klass in scanner.getClasses():
    classBodies[klass.getTag()] = BodyEmitter(f"return OpClass.{klass.getDName()};")
    getClassSwitch.addCaseBody(classBodies[klass.getTag()])

    # isTypeDeclaration
    isXClassFunc = FuncEmitter("bool", f"is{klass.getTagPascalCase()}", [FuncParameter("Op", "code")]).setComment(f"Gets whether [Op] is of the {klass.getDescription()} class.")
    isXClassFunc.add(BodyEmitter(f"return getClass(code) == OpClass.{klass.getDName()};"))
    module.add(isXClassFunc)
    
# hasResult
hasResultFunc = FuncEmitter("bool", "hasResult", [FuncParameter("Op", "code")]).setComment("Gets whether [Op] returns a result.")
hasResultSwitch = SwitchEmitter("code", "Op").setDefault(returnFalse)
hasResultFunc.add(hasResultSwitch)

# hasResultType
hasResultTypeFunc = FuncEmitter("bool", "hasResultType", [FuncParameter("Op", "code")]).setComment("Gets whether [Op] returns a result type.")
hasResultTypeSwitch = SwitchEmitter("code", "Op").setDefault(returnFalse)
hasResultTypeFunc.add(hasResultTypeSwitch)

# getMinLength
getMinLengthFunc = FuncEmitter("uint", "getMinLength", [FuncParameter("Op", "code")]).setComment("Gets the minimum number of operands for [Op]")
getMinLengthFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnZero)
getMinLengthFunc.add(getMinLengthFuncSwitch)

# getMaxLength
getMaxLengthFunc = FuncEmitter("uint", "getMaxLength", [FuncParameter("Op", "code")]).setComment("Gets the maximum number of operands for [Op]")
getMaxLengthFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnZero)
getMaxLengthFunc.add(getMaxLengthFuncSwitch)

# getIDRefIndices
getIDRefIndicesFunc = FuncEmitter("vector!uint", "getIDRefIndices", [FuncParameter("Op", "code")]).setComment("Gets the indices for reference IDs for [Op]")
getIDRefIndicesFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnEmptyArr)
getIDRefIndicesFunc.add(getIDRefIndicesFuncSwitch)

# getOptionalIDRefIndices
getOptionalIDRefIndicesFunc = FuncEmitter("vector!uint", "getOptionalIDRefIndices", [FuncParameter("Op", "code")]).setComment("Gets the indices for reference IDs for [Op]")
getOptionalIDRefIndicesFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnEmptyArr)
getOptionalIDRefIndicesFunc.add(getOptionalIDRefIndicesFuncSwitch)

# getHasArbitraryRefIndices
getHasArbitraryRefIndicesFunc = FuncEmitter("bool", "getHasArbitraryRefIndices", [FuncParameter("Op", "code")]).setComment("Gets whether [Op] ends with a list of arbitrary id refs.")
getHasArbitraryRefIndicesSwitch = SwitchEmitter("code", "Op").setDefault(returnFalse)
getHasArbitraryRefIndicesFunc.add(getHasArbitraryRefIndicesSwitch)


for instruction in scanner.getInstructions():
    opclass = instruction.getClass()
    if opclass in classBodies:
        getClassSwitch.addCase(instruction.getOpName(), classBodies[opclass])
    
    if instruction.hasResult():
        hasResultSwitch.addCase(instruction.getOpName(), returnTrue)

    if instruction.hasResultType():
        hasResultTypeSwitch.addCase(instruction.getOpName(), returnTrue)
    
    getMinLengthFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(f"return {instruction.getMinimumSize()};"))
    getMaxLengthFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(f"return {instruction.getMaximumSize()};"))

    idrefs = list[int]()
    opt_idrefs = list[int]()
    for i, operand in enumerate(instruction.getOperands()):
        if (operand.getKind() == "IdRef"):
            if (operand.getQuantifier() == None):
                idrefs.append(i)
            elif (operand.getQuantifier() == "?"):
                opt_idrefs.append(i)
            elif (operand.getQuantifier() == "*"):
                getHasArbitraryRefIndicesSwitch.addCase(instruction.getOpName(), returnTrue)
    if len(idrefs) > 0:
        refstr = ", ".join(map(str, idrefs))
        code = f"uint[{len(idrefs)}] tmp = [{refstr}];\nreturn vector!uint(tmp);"
        getIDRefIndicesFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(code))
    if len(opt_idrefs) > 0:
        refstr = ", ".join(map(str, opt_idrefs))
        code = f"uint[{len(opt_idrefs)}] tmp = [{refstr}];\nreturn vector!uint(tmp);"
        getOptionalIDRefIndicesFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(code))

module.add(getClassFunc)
module.add(hasResultFunc)
module.add(hasResultTypeFunc)
module.add(getMinLengthFunc)
module.add(getMaxLengthFunc)
module.add(getIDRefIndicesFunc)
module.add(getOptionalIDRefIndicesFunc)
module.add(getHasArbitraryRefIndicesFunc)

file.write(module.emit())