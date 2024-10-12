from common import *
from d_emit import *
import io

# Redefine them for completion
scanner: SpirvGrammarScanner = scanner
file: io.FileIO = file

module = ModuleEmitter("reflection")
module.add(BodyEmitter("import numem.all;"))

# Helpers
returnTrue = BodyEmitter("return true;")
returnFalse = BodyEmitter("return false;")
returnZero = BodyEmitter("return 0;")
returnEmptyArr = BodyEmitter("return vector!(uint).init;")

# isTypeDeclaration
isTypeDeclarationFunc = FuncEmitter("bool", "isTypeDeclaration", [FuncParameter("Op", "code")]).setComment("Gets whether [Op] is a type declaration.")
isTypeDeclarationSwitch = SwitchEmitter("code", "Op").setDefault(returnFalse)
isTypeDeclarationFunc.add(isTypeDeclarationSwitch)

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
getIDRefIndicesFunc = FuncEmitter("vector!uint", "getIDRefIndicesFunc", [FuncParameter("Op", "code")]).setComment("Gets the indices for reference IDs for [Op]")
getIDRefIndicesFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnEmptyArr)
getIDRefIndicesFunc.add(getIDRefIndicesFuncSwitch)


# getOptionalIDRefIndices
getOptionalIDRefIndicesFunc = FuncEmitter("vector!uint", "getOptionalIDRefIndices", [FuncParameter("Op", "code")]).setComment("Gets the indices for reference IDs for [Op]")
getOptionalIDRefIndicesFuncSwitch = SwitchEmitter("code", "Op").setDefault(returnEmptyArr)
getOptionalIDRefIndicesFunc.add(getOptionalIDRefIndicesFuncSwitch)

for instruction in scanner.getInstructions():
    if (instruction.getClass() == "Type-Declaration"):
        isTypeDeclarationSwitch.addCase(instruction.getOpName(), returnTrue)
    
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
            elif(operand.getQuantifier() == "?"):
                opt_idrefs.append(i)
    if len(idrefs) > 0:
        refstr = ", ".join(map(str, idrefs))
        code = f"uint[{len(idrefs)}] tmp = [{refstr}];\nreturn vector!uint(tmp);"
        getIDRefIndicesFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(code))
    if len(opt_idrefs) > 0:
        refstr = ", ".join(map(str, opt_idrefs))
        code = f"uint[{len(opt_idrefs)}] tmp = [{refstr}];\nreturn vector!uint(tmp);"
        getOptionalIDRefIndicesFuncSwitch.addCase(instruction.getOpName(), BodyEmitter(code))

module.add(isTypeDeclarationFunc)
module.add(hasResultFunc)
module.add(hasResultTypeFunc)
module.add(getMinLengthFunc)
module.add(getMaxLengthFunc)
module.add(getIDRefIndicesFunc)
module.add(getOptionalIDRefIndicesFunc)

file.write(module.emit())