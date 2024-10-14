module spirv.cross.funcs;
import spirv.cross.types;
import spirv.spv;
import bindbc.loader;

extern (C) @nogc nothrow:

struct BindAs {
    string as;
}

@BindAs("spvc_context_create")
SpvcResult function(SpvcContext* context) spvcContextCreate;

/** Frees all memory allocations and objects associated with the context and its child objects. */
@BindAs("spvc_context_destroy")
void function(SpvcContext context) spvcContextDestroy;

/** Frees all memory allocations and objects associated with the context and its child objects, but keeps the context alive. */
@BindAs("spvc_context_release_allocations")
void function(SpvcContext context) spvcContextReleaseAllocations;

/** Get the string for the last error which was logged. */
@BindAs("spvc_context_get_last_error_string")
const(char)* function(SpvcContext context) spvcContextGetLastErrorString;

@BindAs("spvc_context_set_error_callback")
void function(SpvcContext context, spvc_error_callback_t cb, void* userdata) spvcContextSetErrorCallback;

/** SPIR-V parsing interface. Maps to Parser which then creates a ParsedIR, and that IR is extracted into the handle. */
@BindAs("spvc_context_parse_spirv")
SpvcResult function(SpvcContext context, const SpvId* spirv, size_t word_count, SpvcParsedIr* parsed_ir) spvcContextParseSpirv;

/**
    Create a compiler backend. Capture mode controls if we construct by copy or move semantics.
    It is always recommended to use SPVC_CAPTURE_MODE_TAKE_OWNERSHIP if you only intend to cross-compile the IR once.
*/
@BindAs("spvc_context_create_compiler")
SpvcResult function(SpvcContext context, SpvcBackend backend, SpvcParsedIr parsed_ir, SpvcCaptureMode mode, SpvcCompiler* compiler) spvcContextCreateCompiler;

/** Maps directly to C++ API. */
@BindAs("spvc_compiler_get_current_id_bound")
uint function(SpvcCompiler compiler) spvcCompilerGetCurrentIdBound;

/** Create compiler options, which will initialize defaults. */
@BindAs("spvc_compiler_create_compiler_options")
SpvcResult function(SpvcCompiler compiler, SpvcCompilerOptions* options) spvcCompilerCreateCompilerOptions;

/** Override options. Will return error if e.g. MSL options are used for the HLSL backend, etc. */
@BindAs("spvc_compiler_options_set_bool")
SpvcResult function(SpvcCompilerOptions options, SpvcCompilerOption option, bool value) spvcCompilerOptionsSetBool;

@BindAs("spvc_compiler_options_set_uint")
SpvcResult function(SpvcCompilerOptions options, SpvcCompilerOption option, uint value) spvcCompilerOptionsSetUint;

/** Set compiler options. */
@BindAs("spvc_compiler_install_compiler_options")
SpvcResult function(SpvcCompiler compiler, SpvcCompilerOptions options) spvcCompilerInstallCompilerOptions;

/** Compile IR into a string. *source is owned by the context, and caller must not free it themselves. */
@BindAs("spvc_compiler_compile")
SpvcResult function(SpvcCompiler compiler, const(char)** source) spvcCompilerCompile;

/** Maps to C++ API. */
@BindAs("spvc_compiler_add_header_line")
SpvcResult function(SpvcCompiler compiler, const(char)* line) spvcCompilerAddHeaderLine;

@BindAs("spvc_compiler_require_extension")
SpvcResult function(SpvcCompiler compiler, const(char)* ext) spvcCompilerRequireExtension;

@BindAs("spvc_compiler_get_num_required_extensions")
size_t function(SpvcCompiler compiler) spvcCompilerGetNumRequiredExtensions;

@BindAs("spvc_compiler_get_required_extension")
const(char)* function(SpvcCompiler compiler, size_t index) spvcCompilerGetRequiredExtension;

@BindAs("spvc_compiler_flatten_buffer_block")
SpvcResult function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerFlattenBufferBlock;

@BindAs("spvc_compiler_variable_is_depth_or_compare")
bool function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerVariableIsDepthOrCompare;

@BindAs("spvc_compiler_mask_stage_output_by_location")
SpvcResult function(SpvcCompiler compiler, uint location, uint component) spvcCompilerMaskStageOutputByLocation;

@BindAs("spvc_compiler_mask_stage_output_by_builtin")
SpvcResult function(SpvcCompiler compiler, BuiltIn builtin) spvcCompilerMaskStageOutputByBuiltin;

/*
 * HLSL specifics.
 * Maps to C++ API.
 */

@BindAs("spvc_compiler_hlsl_set_root_constants_layout")
SpvcResult function(SpvcCompiler compiler, const(SpvcHlslRootConstants)* constant_info, size_t count) spvcCompilerHlslSetRootConstantsLayout;

@BindAs("spvc_compiler_hlsl_add_vertex_attribute_remap")
SpvcResult function(SpvcCompiler compiler, const(SpvcHlslVertexAttributeRemap)* remap, size_t remaps) spvcCompilerHlslAddVertexAttributeRemap;

@BindAs("spvc_compiler_hlsl_remap_num_workgroups_builtin")
SpvcVarId function(SpvcCompiler compiler) spvcCompilerHlslRemapNumWorkgroupsBuiltin;

@BindAs("spvc_compiler_hlsl_set_resource_binding_flags")
SpvcResult function(SpvcCompiler compiler, SpvcHlslBindingFlags flags) spvcCompilerHlslSetResourceBindingFlags;

@BindAs("spvc_compiler_hlsl_add_resource_binding")
SpvcResult function(SpvcCompiler compiler, const(SpvcHlslResourceBinding)* binding) spvcCompilerHlslAddResourceBinding;

@BindAs("spvc_compiler_hlsl_is_resource_used")
bool function(SpvcCompiler compiler, ExecutionModel model, uint set, uint binding) spvcCompilerHlslIsResourceUsed;

/*
 * MSL specifics.
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_msl_is_rasterization_disabled")
bool function(SpvcCompiler compiler) spvcCompilerMslIsRasterizationDisabled;

@BindAs("spvc_compiler_msl_needs_swizzle_buffer")
bool function(SpvcCompiler compiler) spvcCompilerMslNeedsSwizzleBuffer;

@BindAs("spvc_compiler_msl_needs_buffer_size_buffer")
bool function(SpvcCompiler compiler) spvcCompilerMslNeedsBufferSizeBuffer;

@BindAs("spvc_compiler_msl_needs_output_buffer")
bool function(SpvcCompiler compiler) spvcCompilerMslNeedsOutputBuffer;

@BindAs("spvc_compiler_msl_needs_patch_output_buffer")
bool function(SpvcCompiler compiler) spvcCompilerMslNeedsPatchOutputBuffer;

@BindAs("spvc_compiler_msl_needs_inputhreadgroup_mem")
bool function(SpvcCompiler compiler) spvcCompilerMslNeedsInputhreadgroupMem;

@BindAs("spvc_compiler_msl_add_vertex_attribute")
SpvcResult function(SpvcCompiler compiler, const(SpvcMslVertexAttribute)* attrs) spvcCompilerMslAddVertexAttribute;

@BindAs("spvc_compiler_msl_add_resource_binding_2")
SpvcResult function(SpvcCompiler compiler, const(SpvcMslResourceBinding)* binding) spvcCompilerMslAddResourceBinding;

@BindAs("spvc_compiler_msl_add_shader_input_2")
SpvcResult function(SpvcCompiler compiler, const(SpvcMslShaderInterfaceVar)* input) spvcCompilerMslAddShaderInput;

@BindAs("spvc_compiler_msl_add_shader_output_2")
SpvcResult function(SpvcCompiler compiler, const(SpvcMslShaderInterfaceVar)* output) spvcCompilerMslAddShaderOutput;
    
@BindAs("spvc_compiler_msl_add_discrete_descriptor_set")
SpvcResult function(SpvcCompiler compiler, uint desc_set) spvcCompilerMslAddDiscreteDescriptorSet;

@BindAs("spvc_compiler_msl_set_argument_buffer_device_address_space")
SpvcResult function(SpvcCompiler compiler, uint desc_set, bool device_address) spvcCompilerMslSetArgumentBufferDeviceAddressSpace;

@BindAs("spvc_compiler_msl_is_shader_input_used")
bool function(SpvcCompiler compiler, uint location) spvcCompilerMslIsShaderInputUsed;

@BindAs("spvc_compiler_msl_is_shader_output_used")
bool function(SpvcCompiler compiler, uint location) spvcCompilerMslIsShaderOutputUsed;

@BindAs("spvc_compiler_msl_is_resource_used")
bool function(SpvcCompiler compiler, ExecutionModel model, uint set, uint binding) spvcCompilerMslIsResourceUsed;

@BindAs("spvc_compiler_msl_remap_constexpr_sampler")
SpvcResult function(SpvcCompiler compiler, SpvcVarId id, const(SpvcMslConstexprSampler)* sampler) spvcCompilerMslRemapConstexprSampler;

@BindAs("spvc_compiler_msl_remap_constexpr_sampler_by_binding")
SpvcResult function(SpvcCompiler compiler, uint desc_set, uint binding, const(SpvcMslConstexprSampler)* sampler) spvcCompilerMslRemapConstexprSamplerByBinding;

@BindAs("spvc_compiler_msl_remap_constexpr_sampler_ycbcr")
SpvcResult function(SpvcCompiler compiler, SpvcVarId id, const(SpvcMslConstexprSampler)* sampler, const(SpvcMslSamplerYcbcrConversion)* conv) spvcCompilerMslRemapConstexprSamplerYcbcr;

@BindAs("spvc_compiler_msl_remap_constexpr_sampler_by_binding_ycbcr")
SpvcResult function(SpvcCompiler compiler, uint desc_set, uint binding, const(SpvcMslConstexprSampler)* sampler, const(SpvcMslSamplerYcbcrConversion)* conv) spvcCompilerMslRemapConstexprSamplerByBindingYcbcr;

@BindAs("spvc_compiler_msl_set_fragment_output_components")
SpvcResult function(SpvcCompiler compiler, uint location, uint components) spvcCompilerMslSetFragmentOutputComponents;

@BindAs("spvc_compiler_msl_get_automatic_resource_binding")
uint function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerMslGetAutomaticResourceBinding;

@BindAs("spvc_compiler_msl_get_automatic_resource_binding_secondary")
uint function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerMslGetAutomaticResourceBindingSecondary;

@BindAs("spvc_compiler_msl_add_dynamic_buffer")
SpvcResult function(SpvcCompiler compiler, uint desc_set, uint binding, uint index) spvcCompilerMslAddDynamicBuffer;

@BindAs("spvc_compiler_msl_add_inline_uniform_block")
SpvcResult function(SpvcCompiler compiler, uint desc_set, uint binding) spvcCompilerMslAddInlineUniformBlock;

@BindAs("spvc_compiler_msl_set_combined_sampler_suffix")
SpvcResult function(SpvcCompiler compiler, const(char)* suffix) spvcCompilerMslSetCombinedSamplerSuffix;

@BindAs("spvc_compiler_msl_get_combined_sampler_suffix")
const(char)* function(SpvcCompiler compiler) spvcCompilerMslGetCombinedSamplerSuffix;

/*
 * Reflect resources.
 * Maps almost 1:1 to C++ API.
 */
@BindAs("spvc_compiler_get_active_interface_variables")
SpvcResult function(SpvcCompiler compiler, SpvcSet* set) spvcCompilerGetActiveInterfaceVariables;

@BindAs("spvc_compiler_set_enabled_interface_variables")
SpvcResult function(SpvcCompiler compiler, SpvcSet set) spvcCompilerSetEnabledInterfaceVariables;

@BindAs("spvc_compiler_create_shader_resources")
SpvcResult function(SpvcCompiler compiler, SpvcResources* resources) spvcCompilerCreateShaderResources;

@BindAs("spvc_compiler_create_shader_resources_for_active_variables")
SpvcResult function(SpvcCompiler compiler, SpvcResources* resources, SpvcSet active) spvcCompilerCreateShaderResourcesForActiveVariables;

@BindAs("spvc_resources_get_resource_list_for_type")
SpvcResult function(SpvcResources resources, SpvcResourceType type, const(SpvcReflectedResource)** resourceList, size_t* resourceSize) spvcResourcesGetResourceListForType;

@BindAs("spvc_resources_get_builtin_resource_list_for_type")
SpvcResult function(SpvcResources resources, SpvcBuiltinResourceType type, const(SpvcReflectedBuiltinResource)** resourceList, size_t* resourceSize) spvcResourcesGetBuiltinResourceListForType;

/*
 * Decorations.
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_set_decoration")
void function(SpvcCompiler compiler, SpvId id, Decoration decoration, uint argument) spvcCompilerSetDecoration;

@BindAs("spvc_compiler_set_decoration_string")
void function(SpvcCompiler compiler, SpvId id, Decoration decoration, const(char)* argument) spvcCompilerSetDecorationString;

@BindAs("spvc_compiler_set_name")
void function(SpvcCompiler compiler, SpvId id, const(char)* argument) spvcCompilerSetName;

@BindAs("spvc_compiler_set_member_decoration")
void function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration, uint argument) spvcCompilerSetMemberDecoration;

@BindAs("spvc_compiler_set_member_decoration_string")
void function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration, const(char)* argument) spvcCompilerSetMemberDecorationString;
    
@BindAs("spvc_compiler_set_member_name")
void function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, const(char)* argument) spvcCompilerSetMemberName;

@BindAs("spvc_compiler_unset_decoration")
void function(SpvcCompiler compiler, SpvId id, Decoration decoration) spvcCompilerUnsetDecoration;

@BindAs("spvc_compiler_unset_member_decoration")
void function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration) spvcCompilerUnsetMemberDecoration;

@BindAs("spvc_compiler_has_decoration")
bool function(SpvcCompiler compiler, SpvId id, Decoration decoration) spvcCompilerHasDecoration;

@BindAs("spvc_compiler_has_member_decoration")
bool function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration) spvcCompilerHasMemberDecoration;

@BindAs("spvc_compiler_get_name")
const(char)* function(SpvcCompiler compiler, SpvId id) spvcCompilerGetName;

@BindAs("spvc_compiler_get_decoration")
uint function(SpvcCompiler compiler, SpvId id, Decoration decoration) spvcCompilerGetDecoration;

@BindAs("spvc_compiler_get_decoration_string")
const(char)* function(SpvcCompiler compiler, SpvId id, Decoration decoration) spvcCompilerGetDecorationString;

@BindAs("spvc_compiler_get_member_decoration")
uint function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration) spvcCompilerGetMemberDecoration;

@BindAs("spvc_compiler_get_member_decoration_string")
const(char)* function(SpvcCompiler compiler, SpvcTypeId id, uint member_index, Decoration decoration) spvcCompilerGetMemberDecorationString;

@BindAs("spvc_compiler_get_member_name")
const(char)* function(SpvcCompiler compiler, SpvcTypeId id, uint member_index) spvcCompilerGetMemberName;

/*
 * Entry points.
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_get_entry_points")
SpvcResult function(SpvcCompiler compiler, const(SpvcEntryPoint)** entry_points, size_t* num_entry_points) spvcCompilerGetEntryPoints;

@BindAs("spvc_compiler_set_entry_point")
SpvcResult function(SpvcCompiler compiler, const(char)* name, ExecutionModel model) spvcCompilerSetEntryPoint;

@BindAs("spvc_compiler_rename_entry_point")
SpvcResult function(SpvcCompiler compiler, const(char)* old_name, const(char)* new_name, ExecutionModel model) spvcCompilerRenameEntryPoint;

@BindAs("spvc_compiler_get_cleansed_entry_point_name")
const(char)* function(SpvcCompiler compiler, const(char)* name, ExecutionModel model) spvcCompilerGetCleansedEntryPointName;

@BindAs("spvc_compiler_set_execution_mode")
void function(SpvcCompiler compiler, ExecutionMode mode) spvcCompilerSetExecutionMode;

@BindAs("spvc_compiler_unset_execution_mode")
void function(SpvcCompiler compiler, ExecutionMode mode) spvcCompilerUnsetExecutionMode;

@BindAs("spvc_compiler_set_execution_mode_with_arguments")
void function(SpvcCompiler compiler, ExecutionMode mode, uint arg0, uint arg1, uint arg2) spvcCompilerSetExecutionModeWithArguments;

@BindAs("spvc_compiler_get_execution_modes")
SpvcResult function(SpvcCompiler compiler, const ExecutionMode** modes, size_t* num_modes) spvcCompilerGetExecutionModes;

@BindAs("spvc_compiler_get_execution_mode_argument")
uint function(SpvcCompiler compiler, ExecutionMode mode) spvcCompilerGetExecutionModeArgument;

@BindAs("spvc_compiler_get_execution_mode_argument_by_index")
uint function(SpvcCompiler compiler, ExecutionMode mode, uint index) spvcCompilerGetExecutionModeArgumentByIndex;

@BindAs("spvc_compiler_get_execution_model")
ExecutionModel function(SpvcCompiler compiler) spvcCompilerGetExecutionModel;

@BindAs("spvc_compiler_update_active_builtins")
void function(SpvcCompiler compiler) spvcCompilerUpdateActiveBuiltins;

@BindAs("spvc_compiler_has_active_builtin")
bool function(SpvcCompiler compiler, BuiltIn builtin, StorageClass storage) spvcCompilerHasActiveBuiltin;

/*
 * Type query interface.
 * Maps to C++ API, except it's read-only.
 */
@BindAs("spvc_compiler_get_type_handle")
SpvcType function(SpvcCompiler compiler, SpvcTypeId id) spvcCompilerGetTypeHandle;

/** Pulls out SPIRType::self. This effectively gives the type ID without array or pointer qualifiers.
 * This is necessary when reflecting decoration/name information on members of a struct,
 * which are placed in the base type, not the qualified type.
 * This is similar to spvc_reflected_resource::base_type_id. */
@BindAs("spvc_type_get_base_type_id")
SpvcTypeId function(SpvcType type) spvcTypeGetBaseTypeId;


@BindAs("spvc_type_get_basetype")
SpvcBaseType function(SpvcType type) spvcTypeGetBaseType;

@BindAs("spvc_type_get_bit_width")
uint function(SpvcType type) spvcTypeGetBitWidth;

@BindAs("spvc_type_get_vector_size")
uint function(SpvcType type) spvcTypeGetVectorSize;

@BindAs("spvc_type_get_columns")
uint function(SpvcType type) spvcTypeGetColumns;

@BindAs("spvc_type_get_num_array_dimensions")
uint function(SpvcType type) spvcTypeGetNumArrayDimensions;

@BindAs("spvc_type_array_dimension_is_literal")
bool function(SpvcType type, uint dimension) spvcTypeArrayDimensionIsLiteral;

@BindAs("spvc_type_get_array_dimension")
SpvId function(SpvcType type, uint dimension) spvcTypeGetArrayDimension;

@BindAs("spvc_type_get_num_member_types")
uint function(SpvcType type) spvcTypeGetNumMemberTypes;

@BindAs("spvc_type_get_member_type")
SpvcTypeId function(SpvcType type, uint index) spvcTypeGetMemberType;

@BindAs("spvc_type_get_storage_class")
StorageClass function(SpvcType type) spvcTypeGetStorageClass;

/** Image type query. */

@BindAs("spvc_type_get_image_sampled_type")
SpvcTypeId function(SpvcType type) spvcTypeGetImageSampledType;

@BindAs("spvc_type_get_image_dimension")
Dim function(SpvcType type) spvcTypeGetImageDimension;

@BindAs("spvc_type_get_image_is_depth")
bool function(SpvcType type) spvcTypeGetImageIsDepth;

@BindAs("spvc_type_get_image_arrayed")
bool function(SpvcType type) spvcTypeGetImageArrayed;

@BindAs("spvc_type_get_image_multisampled")
bool function(SpvcType type) spvcTypeGetImageMultisampled;

@BindAs("spvc_type_get_image_is_storage")
bool function(SpvcType type) spvcTypeGetImageIsStorage;

@BindAs("spvc_type_get_image_storage_format")
ImageFormat function(SpvcType type) spvcTypeGetImageStorageFormat;

@BindAs("spvc_type_get_image_access_qualifier")
AccessQualifier function(SpvcType type) spvcTypeGetImageAccessQualifier;

/*
 Buffer * function layout query.
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_get_declared_struct_size")
SpvcResult function(SpvcCompiler compiler, SpvcType structype, size_t* size) spvcCompilerGetDeclaredStructSize;

@BindAs("spvc_compiler_get_declared_struct_size_runtime_array")
SpvcResult function(SpvcCompiler compiler, SpvcType structype, size_t array_size, size_t* size) spvcCompilerGetDeclaredStructSizeRuntimeArray;

@BindAs("spvc_compiler_get_declared_struct_member_size")
SpvcResult function(SpvcCompiler compiler, SpvcType type, uint index, size_t* size) spvcCompilerGetDeclaredStructMemberSize;

@BindAs("spvc_compiler_type_struct_member_offset")
SpvcResult function(SpvcCompiler compiler, SpvcType type, uint index, uint* offset) spvcCompilerTypeStructMemberOffset;

@BindAs("spvc_compiler_type_struct_member_array_stride")
SpvcResult function(SpvcCompiler compiler, SpvcType type, uint index, uint* stride) spvcCompilerTypeStructMemberArrayStride;

@BindAs("spvc_compiler_type_struct_member_matrix_stride")
SpvcResult function(SpvcCompiler compiler, SpvcType type, uint index, uint* stride) spvcCompilerTypeStructMemberMatrixStride;

/*
 * Workaround helper functions.
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_build_dummy_sampler_for_combined_images")
SpvcResult function(
    SpvcCompiler compiler, SpvcVarId* id) spvcCompilerBuildDummySamplerForCombinedImages;

@BindAs("spvc_compiler_build_combined_image_samplers")
SpvcResult function(SpvcCompiler compiler) spvcCompilerBuildCombinedImageSamplers;

@BindAs("spvc_compiler_get_combined_image_samplers")
SpvcResult function(SpvcCompiler compiler, const(SpvcCombinedImageSampler)** samplers, size_t* num_samplers) spvcCompilerGetCombinedImageSamplers;

/*
 * Constants
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_get_specialization_constants")
SpvcResult function(SpvcCompiler compiler, const(SpvcSpecializationConstant)** constants, size_t* num_constants) spvcCompilerGetSpecializationConstants;

@BindAs("spvc_compiler_get_constant_handle")
SpvcConstant function(SpvcCompiler compiler, SpvcConstId id) spvcCompilerGetConstantHandle;

@BindAs("spvc_compiler_get_work_group_size_specialization_constants")
SpvcConstId function(SpvcCompiler compiler, SpvcSpecializationConstant* x, SpvcSpecializationConstant* y, SpvcSpecializationConstant* z) spvcCompilerGetWorkGroupSizeSpecializationConstants;

/*
 * Buffer ranges
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_get_active_buffer_ranges")
SpvcResult function(SpvcCompiler compiler,
    SpvcVarId id,
    const(SpvcBufferRange)** ranges,
    size_t* num_ranges) spvcCompilerGetActiveBufferRanges;

/*
 * No stdint.h until C99, sigh :(
 * For smaller types, the result is sign or zero-extended as appropriate.
 * Maps to C++ API.
 * TODO: The SPIRConstant query interface and modification interface is not quite complete.
 */

@BindAs("spvc_constant_get_scalar_fp16")
float function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarFp16;

@BindAs("spvc_constant_get_scalar_fp32")
float function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarFp32;

@BindAs("spvc_constant_get_scalar_fp64")
double function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarFp64;

@BindAs("spvc_constant_get_scalar_u32")
uint function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarU32;

@BindAs("spvc_constant_get_scalar_i32")
int function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarI32;

@BindAs("spvc_constant_get_scalar_u16")
uint function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarU16;

@BindAs("spvc_constant_get_scalar_i16")
int function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarI16;

@BindAs("spvc_constant_get_scalar_u8")
uint function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarU8;

@BindAs("spvc_constant_get_scalar_i8")
int function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarI8;

@BindAs("spvc_constant_get_subconstants")
void function(SpvcConstant constant, const(SpvcConstId)** constituents, size_t* count) spvcConstantGetSubconstants;

@BindAs("spvc_constant_get_scalar_u64")
ulong function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarU64;

@BindAs("spvc_constant_get_scalar_i64")
long function(SpvcConstant constant, uint column, uint row) spvcConstantGetScalarI64;

@BindAs("spvc_constant_get_type")
SpvcTypeId function(SpvcConstant constant) spvcConstantGetype;

/*
 * C implementation of the C++ api.
 */

@BindAs("spvc_constant_set_scalar_fp16")
void function(SpvcConstant constant, uint column, uint row, ushort value) spvcConstantSetScalarFp16;

@BindAs("spvc_constant_set_scalar_fp32")
void function(SpvcConstant constant, uint column, uint row, float value) spvcConstantSetScalarFp32;

@BindAs("spvc_constant_set_scalar_fp64")
void function(SpvcConstant constant, uint column, uint row, double value) spvcConstantSetScalarFp64;

@BindAs("spvc_constant_set_scalar_u32")
void function(SpvcConstant constant, uint column, uint row, uint value) spvcConstantSetScalarU32;

@BindAs("spvc_constant_set_scalar_i32")
void function(SpvcConstant constant, uint column, uint row, int value) spvcConstantSetScalarI32;

@BindAs("spvc_constant_set_scalar_u64")
void function(SpvcConstant constant, uint column, uint row, ulong value) spvcConstantSetScalarU64;

@BindAs("spvc_constant_set_scalar_i64")
void function(SpvcConstant constant, uint column, uint row, long value) spvcConstantSetScalarI64;

@BindAs("spvc_constant_set_scalar_u16")
void function(SpvcConstant constant, uint column, uint row, ushort value) spvcConstantSetScalarU16;

@BindAs("spvc_constant_set_scalar_i16")
void function(SpvcConstant constant, uint column, uint row, short value) spvcConstantSetScalarI16;

@BindAs("spvc_constant_set_scalar_u8")
void function(SpvcConstant constant, uint column, uint row, ubyte value) spvcConstantSetScalarU8;

@BindAs("spvc_constant_set_scalar_i8")
void function(SpvcConstant constant, uint column, uint row, byte value) spvcConstantSetScalarI8;

/*
 * Misc reflection
 * Maps to C++ API.
 */
@BindAs("spvc_compiler_get_binary_offset_for_decoration")
bool function(SpvcCompiler compiler, SpvcVarId id, Decoration decoration, uint* word_offset) spvcCompilerGetBinaryOffsetForDecoration;

@BindAs("spvc_compiler_buffer_is_hlsl_counter_buffer")
bool function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerBufferIsHlslCounterBuffer;

@BindAs("spvc_compiler_buffer_get_hlsl_counter_buffer")
bool function(SpvcCompiler compiler, SpvcVarId id, SpvcVarId* counter_id) spvcCompilerBufferGetHlslCounterBuffer;

@BindAs("spvc_compiler_get_declared_capabilities")
SpvcResult function(SpvcCompiler compiler, const(Capability)** capabilities, size_t* num_capabilities) spvcCompilerGetDeclaredCapabilities;

@BindAs("spvc_compiler_get_declared_extensions")
SpvcResult function(SpvcCompiler compiler, const(char)*** extensions, size_t* num_extensions) spvcCompilerGetDeclaredExtensions;

@BindAs("spvc_compiler_get_remapped_declared_block_name")
const(char)* function(SpvcCompiler compiler, SpvcVarId id) spvcCompilerGetRemappedDeclaredBlockName;

@BindAs("spvc_compiler_get_buffer_block_decorations")
SpvcResult function(SpvcCompiler compiler, SpvcVarId id, const Decoration** decorations, size_t* num_decorations) spvcCompilerGetBufferBlockDecorations;
