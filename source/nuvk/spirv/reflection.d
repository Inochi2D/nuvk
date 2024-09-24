module nuvk.spirv.reflection;
import nuvk.spirv.spv;

bool isTypeDeclaration(Op code) @nogc {
    switch(code) {

        case Op.OpTypeVoid:
        case Op.OpTypeBool:
        case Op.OpTypeInt:
        case Op.OpTypeFloat:
        case Op.OpTypeVector:
        case Op.OpTypeMatrix:
        case Op.OpTypeImage:
        case Op.OpTypeSampler:
        case Op.OpTypeSampledImage:
        case Op.OpTypeArray:
        case Op.OpTypeRuntimeArray:
        case Op.OpTypeStruct:
        case Op.OpTypeOpaque:
        case Op.OpTypePointer:
        case Op.OpTypeFunction:
        case Op.OpTypeEvent:
        case Op.OpTypeDeviceEvent:
        case Op.OpTypeReserveId:
        case Op.OpTypeQueue:
        case Op.OpTypePipe:
            return true;

        default:
            return false;
    }

}

bool hasResultType(Op code) @nogc {
    switch(code) {

        case Op.OpUndef:
        case Op.OpSizeOf:
        case Op.OpExtInst:
        case Op.OpMemberName:
        case Op.OpConstantTrue:
        case Op.OpConstantFalse:
        case Op.OpConstant:
        case Op.OpConstantComposite:
        case Op.OpConstantSampler:
        case Op.OpConstantNull:
        case Op.OpSpecConstantTrue:
        case Op.OpSpecConstantFalse:
        case Op.OpSpecConstant:
        case Op.OpSpecConstantComposite:
        case Op.OpSpecConstantOp:
            return true;

        default:
            return false;
    }
}

bool hasResult(Op code) @nogc {
    switch(code) {
        case Op.OpUndef:
        case Op.OpSizeOf:
        case Op.OpString:
        case Op.OpDecorationGroup:
        case Op.OpExtInstImport:
        case Op.OpExtInst:
        case Op.OpTypeVoid:
        case Op.OpTypeBool:
        case Op.OpTypeInt:
        case Op.OpTypeFloat:
        case Op.OpTypeVector:
        case Op.OpTypeMatrix:
        case Op.OpTypeImage:
        case Op.OpTypeSampler:
        case Op.OpTypeSampledImage:
        case Op.OpTypeArray:
        case Op.OpTypeRuntimeArray:
        case Op.OpTypeStruct:
        case Op.OpTypeOpaque:
        case Op.OpTypePointer:
        case Op.OpTypeFunction:
        case Op.OpTypeEvent:
        case Op.OpTypeDeviceEvent:
        case Op.OpTypeReserveId:
        case Op.OpTypeQueue:
        case Op.OpTypePipe:
        case Op.OpConstantTrue:
        case Op.OpConstantFalse:
        case Op.OpConstant:
        case Op.OpConstantComposite:
        case Op.OpConstantSampler:
        case Op.OpConstantNull:
        case Op.OpSpecConstantTrue:
        case Op.OpSpecConstantFalse:
        case Op.OpSpecConstant:
        case Op.OpSpecConstantComposite:
        case Op.OpSpecConstantOp:
            return true;

        default:
            return false;
    }
}