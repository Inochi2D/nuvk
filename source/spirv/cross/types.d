module spirv.cross.types;
import spirv.spv;
import bindbc.loader;

alias SpvcContext = void*;
alias SpvcParsedIr = void*;
alias SpvcCompiler = void*;
alias SpvcCompilerOptions = void*;
alias SpvcResources = void*;
alias SpvcType = const(void)*;
alias SpvcConstant = void*;
alias SpvcSet = const(void)*;

/**
    Shallow alias to uint, Spirv SSA ID.
*/
alias SpvId = uint;

/**
    Type ID,
*/
alias SpvcTypeId = SpvId;

/**
    Variable ID,
*/
alias SpvcVarId = SpvId;

/**
    Constant ID,
*/
alias SpvcConstId = SpvId;

struct SpvcReflectedResource {
	SpvcVarId id;
	SpvcTypeId baseTypeId;
	SpvcTypeId typeId;
	const(char)* name;
}

struct SpvcReflectedBuiltinResource {
	BuiltIn builtIn;
	SpvcTypeId typeId;
	SpvcReflectedResource resource;
}

struct SpvcEntryPoint {
	ExecutionModel executionModel;
	const(char)* name;
}

struct SpvcCombinedImageSampler {
	SpvcVarId combinedId;
	SpvcVarId imageId;
	SpvcVarId samplerId;
}

struct SpvcSpecializationConstant {
	SpvcConstId id;
	uint constantId;
}

struct SpvcBufferRange {
	uint index;
	size_t offset;
	size_t range;
}

struct SpvcHlslRootConstants {
	uint start;
	uint end;
	uint binding;
	uint space;
}

struct SpvcHlslVertexAttributeRemap {
	uint location;
	const(char)* semantic;
}

enum SpvcResult {
	success = 0,
	errorInvalidSpirv = -1,
	errorUnsupportedSpirv = -2,
	errorOutOfMemory = -3,
	errorInvalidArgument = -4,
}

enum SpvcCaptureMode {
	captureModeCopy = 0,
	captureModeTakeOwnership = 1
}

enum SpvcBackend {
	none = 0,
	glsl = 1,
	hlsl = 2,
	msl = 3,
	cpp = 4,
	json = 5
}

enum SpvcResourceType {
	unknown = 0,
	uniformBuffers = 1,
	storageBuffers = 2,
	stageInputs = 3,
	stageOutputs = 4,
	subpassInputs = 5,
	storageImages = 6,
	sampledImages = 7,
	atomicCounter = 8,
	pushConstant = 9,
	separateImages = 10,
	separateSamplers = 11,
	accelerationStructure = 12,
	rayQuery = 13,
	shaderRecordBuffer = 14,
	glPlainUniform = 15,
}

enum SpvcBuiltinResourceType {
	unknown = 0,
	stageInput = 1,
	stageOutput = 2,
}

enum SpvcBaseType {
	unknown = 0,
	void_ = 1,
	boolean = 2,
	int8 = 3,
	uint8 = 4,
	int16 = 5,
	uint16 = 6,
	int32 = 7,
	uint32 = 8,
	int64 = 9,
	uint64 = 10,
	atomicCounter = 11,
	fp16 = 12,
	fp32 = 13,
	fp64 = 14,
	struct_ = 15,
	image = 16,
	sampledImage = 17,
	sampler = 18,
	accelerationStructure = 19,
}

enum COMMON_BIT = 0x1000000;
enum GLSL_BIT = 0x2000000;
enum HLSL_BIT = 0x4000000;
enum MSL_BIT = 0x8000000;
enum LANG_BITS = 0x0f000000;
enum ENUM_BITS = 0xffffff;

enum SPVC_MAKE_MSL_VERSION(uint major, uint minor, uint patch) = (
		(major) * 10_000 + (minor) * 100 + (patch));

enum SpvcMslPlatform {
	iOS = 0,
	macOS = 1,
}

enum SpvcMslIndexType {
	none = 0,
	uint16 = 1,
	uint32 = 2,
}

enum SpvcMslShaderElementFormat {
	other = 0,
	uint8 = 1,
	uint16 = 2,
	any16 = 3,
	any32 = 4,
}

struct SpvcMslVertexAttribute {
	uint location;

	// padding
	private uint[4] padding;

	SpvcMslShaderElementFormat format;
	BuiltIn builtin;
}

struct SpvcMslShaderInterfaceVar {
	uint location;
	SpvcMslShaderElementFormat format;
	BuiltIn builtin;
	uint vecsize;
	SpvcMslShaderVariableRate rate;
}

enum SpvcMslShaderVariableRate {
	perVertex = 0,
	perPrimitive = 1,
	perPatch = 2,
}

struct SpvcMslResourceBinding {
	ExecutionModel stage;
	uint descSet;
	uint binding;
	uint count;
	uint mslBuffer;
	uint mslTexture;
	uint mslSampler;
}

enum SPVC_MSL_PUSH_CONSTANT_DESC_SET = (~(0u));
enum SPVC_MSL_PUSH_CONSTANT_BINDING = (0);
enum SPVC_MSL_SWIZZLE_BUFFER_BINDING = (~(1u));
enum SPVC_MSL_BUFFER_SIZE_BUFFER_BINDING = (~(2u));
enum SPVC_MSL_ARGUMENT_BUFFER_BINDING = (~(3u));

enum SpvcMslSamplerCoord {
	normalized = 0,
	pixel = 1,
}

enum SpvcMslSamplerFilter {
	nearest = 0,
	linear = 1,
}

enum SpvcMslSamplerMipFilter {
	none = 0,
	nearest = 1,
	linear = 2,
}

enum SpvcMslSamplerAddress {
	clampToZero = 0,
	clampToEdge = 1,
	clampToBorder = 2,
	repeat = 3,
	mirroredRepeat = 4,
}

enum SpvcMslSamplerCompareFunc {
	never = 0,
	less = 1,
	lessEqual = 2,
	greater = 3,
	greaterEqual = 4,
	equal = 5,
	notEqual = 6,
	always = 7,
}

enum SpvcMslSamplerBorderColor {
	transparentBlack = 0,
	opaqueBlack = 1,
	opaqueWhite = 2,
}

enum SpvcMslFormatResolution {
	res444 = 0,
	res422,
	res420,
}

enum SpvcMslChromaLocation {
	cositedEven = 0,
	midpoint,
}

enum SpvcMslComponentSwizzle {
	identity = 0,
	zero,
	one,
	r,
	g,
	b,
	a,
}

enum SpvcMslSamplerYcbcrModelConversion {
	rgbIdentity = 0,
	ycbcrIdentity,
	ycbcrBt709,
	ycbcrBt601,
	ycbcrBt2020,
}

enum SpvcMslSamplerYcbcrRange {
	ituFull = 0,
	ituNarrow,
}

struct SpvcMslConstexprSampler {
	SpvcMslSamplerCoord coord;
	SpvcMslSamplerFilter minFilter;
	SpvcMslSamplerFilter magFilter;
	SpvcMslSamplerMipFilter mipFilter;
	SpvcMslSamplerAddress sAddress;
	SpvcMslSamplerAddress tAddress;
	SpvcMslSamplerAddress rAddress;
	SpvcMslSamplerCompareFunc compareFunc;
	SpvcMslSamplerBorderColor borderColor;
	float lodClampMin;
	float lodClampMax;
	int maxAnisotropy;

	bool compareEnable;
	bool lodClampEnable;
	bool anisotropyEnable;
}

struct SpvcMslSamplerYcbcrConversion {
	uint planes;
	SpvcMslFormatResolution resolution;
	SpvcMslSamplerFilter chromaFilter;
	SpvcMslChromaLocation xChromaOffset;
	SpvcMslChromaLocation yChromaOffset;
	SpvcMslComponentSwizzle[4] swizzle;
	SpvcMslSamplerYcbcrModelConversion ycbcrModel;
	SpvcMslSamplerYcbcrRange ycbcrRange;
	uint bpc;
}

enum SpvcHlslBindingFlags {
	autoNoneBit = 0,
	autoPushConstantBit = 1 << 0,
	autoCbvBit = 1 << 1,
	autoSrvBit = 1 << 2,
	autoUavBit = 1 << 3,
	autoSamplerBit = 1 << 4,
	autoAll = 0x7fffffff
}

enum SPVC_HLSL_PUSH_CONSTANT_DESC_SET = (~(0u));
enum SPVC_HLSL_PUSH_CONSTANT_BINDING = (0);

struct SpvcHlslResourceBindingMapping {
	uint registerSpace;
	uint registerBinding;
}

struct SpvcHlslResourceBinding {
	ExecutionModel stage;
	uint descSet;
	uint binding;

	SpvcHlslResourceBindingMapping cbv, uav, srv, sampler;
}

enum SpvcCompilerOption {
	UNKNOWN = 0,

	forceTemporary = 1 | COMMON_BIT,
	flattenMultidimensionalArrays = 2 | COMMON_BIT,
	fixupDepthConvention = 3 | COMMON_BIT,
	flipVertexY = 4 | COMMON_BIT,

	glslSupportNonzeroBaseInstance = 5 | GLSL_BIT,
	glslSeparateShaderObjects = 6 | GLSL_BIT,
	glslEnable420packExtension = 7 | GLSL_BIT,
	glslVersion = 8 | GLSL_BIT,
	glslEs = 9 | GLSL_BIT,
	glslVulkanSemantics = 10 | GLSL_BIT,
	glslEsDefaultFloatPrecisionHighp = 11 | GLSL_BIT,
	glslEsDefaultIntPrecisionHighp = 12 | GLSL_BIT,

	hlslShaderModel = 13 | HLSL_BIT,
	hlslPointSizeCompat = 14 | HLSL_BIT,
	hlslPointCoordCompat = 15 | HLSL_BIT,
	hlslSupportNonzeroBaseVertexBaseInstance = 16 | HLSL_BIT,

	mslVersion = 17 | MSL_BIT,
	mslTexelBufferTextureWidth = 18 | MSL_BIT,

	mslSwizzleBufferIndex = 19 | MSL_BIT,

	mslIndirectParamsBufferIndex = 20 | MSL_BIT,
	mslShaderOutputBufferIndex = 21 | MSL_BIT,
	mslShaderPatchOutputBufferIndex = 22 | MSL_BIT,
	mslShaderTessFactorOutputBufferIndex = 23 | MSL_BIT,
	mslShaderInputWorkgroupIndex = 24 | MSL_BIT,
	mslEnablePointSizeBuiltin = 25 | MSL_BIT,
	mslDisableRasterization = 26 | MSL_BIT,
	mslCaptureOutputToBuffer = 27 | MSL_BIT,
	mslSwizzleTextureSamples = 28 | MSL_BIT,
	mslPadFragmentOutputComponents = 29 | MSL_BIT,
	mslTessDomainOriginLowerLeft = 30 | MSL_BIT,
	mslPlatform = 31 | MSL_BIT,
	mslArgumentBuffers = 32 | MSL_BIT,

	glslEmitPushConstantAsUniformBuffer = 33 | GLSL_BIT,

	mslTextureBufferNative = 34 | MSL_BIT,

	glslEmitUniformBufferAsPlainUniforms = 35 | GLSL_BIT,

	mslBufferSizeBufferIndex = 36 | MSL_BIT,

	emitLineDirectives = 37 | COMMON_BIT,

	mslMultiview = 38 | MSL_BIT,
	mslViewMaskBufferIndex = 39 | MSL_BIT,
	mslDeviceIndex = 40 | MSL_BIT,
	mslViewIndexFromDeviceIndex = 41 | MSL_BIT,
	mslDispatchBase = 42 | MSL_BIT,
	mslDynamicOffsetsBufferIndex = 43 | MSL_BIT,
	mslTexture1dAs2d = 44 | MSL_BIT,
	mslEnableBaseIndexZero = 45 | MSL_BIT,

	mslFramebufferFetchSubpass = 46 | MSL_BIT,

	mslInvariantFpMath = 47 | MSL_BIT,
	mslEmulateCubemapArray = 48 | MSL_BIT,
	mslEnableDecorationBinding = 49 | MSL_BIT,
	mslForceActiveArgumentBufferResources = 50 | MSL_BIT,
	mslForceNativeArrays = 51 | MSL_BIT,

	enableStorageImageQualifierDeduction = 52 | COMMON_BIT,

	hlslForceStorageBufferAsUav = 53 | HLSL_BIT,

	forceZeroInitializedVariables = 54 | COMMON_BIT,

	hlslNonwritableUavTextureAsSrv = 55 | HLSL_BIT,

	mslEnableFragOutputMask = 56 | MSL_BIT,
	mslEnableFragDepthBuiltin = 57 | MSL_BIT,
	mslEnableFragStencilRefBuiltin = 58 | MSL_BIT,
	mslEnableClipDistanceUserVarying = 59 | MSL_BIT,

	hlslEnable16bitTypes = 60 | HLSL_BIT,

	mslMultiPatchWorkgroup = 61 | MSL_BIT,
	mslShaderInputBufferIndex = 62 | MSL_BIT,
	mslShaderIndexBufferIndex = 63 | MSL_BIT,
	mslVertexForTessellation = 64 | MSL_BIT,
	mslVertexIndexType = 65 | MSL_BIT,

	glslForceFlattenedIoBlocks = 66 | GLSL_BIT,

	mslMultiviewLayeredRendering = 67 | MSL_BIT,
	mslArrayedSubpassInput = 68 | MSL_BIT,
	mslR32uiLinearTextureAlignment = 69 | MSL_BIT,
	mslR32uiAlignmentConstantId = 70 | MSL_BIT,

	hlslFlattenMatrixVertexInputSemantics = 71 | HLSL_BIT,

	mslIosUseSimdgroupFunctions = 72 | MSL_BIT,
	mslEmulateSubgroups = 73 | MSL_BIT,
	mslFixedSubgroupSize = 74 | MSL_BIT,
	mslForceSampleRateShading = 75 | MSL_BIT,
	mslIosSupportBaseVertexInstance = 76 | MSL_BIT,

	glslOvrMultiviewViewCount = 77 | GLSL_BIT,

	relaxNanChecks = 78 | COMMON_BIT,

	mslRawBufferTeseInput = 79 | MSL_BIT,
	mslShaderPatchInputBufferIndex = 80 | MSL_BIT,
	mslManualHelperInvocationUpdates = 81 | MSL_BIT,
	mslCheckDiscardedFragStores = 82 | MSL_BIT,

	glslEnableRowMajorLoadWorkaround = 83 | GLSL_BIT,

	mslArgumentBuffersTier = 84 | MSL_BIT,
	mslSampleDrefLodArrayAsGrad = 85 | MSL_BIT,
	mslReadwriteTextureFences = 86 | MSL_BIT,
	mslReplaceRecursiveInputs = 87 | MSL_BIT,
	mslAgxManualCubeGradFixup = 88 | MSL_BIT,
	mslForceFragmentWithSideEffectsExecution = 89 | MSL_BIT,

	hlslUseEntryPointName = 90 | HLSL_BIT,
	hlslPreserveStructuredBuffers = 91 | HLSL_BIT,
}

extern (C) @nogc nothrow:

/* Get notified in a callback when an error triggers. Useful for debugging. */
alias spvc_error_callback_t = void function(void* userdata, const(char)* error);