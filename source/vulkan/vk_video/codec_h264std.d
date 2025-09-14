/**
    VK_STD_vulkan_video_codec_h264
    VK_STD_vulkan_video_codec_h264_encode
    VK_STD_vulkan_video_codec_h264_decode
    
    Copyright:
        Copyright © 2015-2025, The Khronos Group Inc.

    License:    $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
*/
module vulkan.vk_video.codec_h264std;
import vulkan.vk_video.common;
import vulkan.khr_video_queue;
import vulkan.core;

extern (System) @nogc nothrow:

enum string VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h264_encode";
enum string VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h264_decode";

enum uint VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION!(1, 0, 0);
enum uint VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION!(1, 0, 0);

enum uint VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0;
enum uint VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0;
enum uint STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE = 2U;

enum uint STD_VIDEO_H264_CPB_CNT_LIST_SIZE = 32U;
enum uint STD_VIDEO_H264_SCALING_LIST_4X4_NUM_LISTS = 6U;
enum uint STD_VIDEO_H264_SCALING_LIST_4X4_NUM_ELEMENTS = 16U;
enum uint STD_VIDEO_H264_SCALING_LIST_8X8_NUM_LISTS = 6U;
enum uint STD_VIDEO_H264_SCALING_LIST_8X8_NUM_ELEMENTS = 64U;
enum uint STD_VIDEO_H264_MAX_NUM_LIST_REF = 32U;
enum uint STD_VIDEO_H264_MAX_CHROMA_PLANES = 2U;
enum uint STD_VIDEO_H264_NO_REFERENCE_PICTURE = 0xFFU;

alias StdVideoH264ChromaFormatIdc = uint;
enum StdVideoH264ChromaFormatIdc STD_VIDEO_H264_CHROMA_FORMAT_IDC_MONOCHROME = 0,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_420 = 1,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_422 = 2,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_444 = 3,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264ProfileIdc = uint;
enum StdVideoH264ProfileIdc STD_VIDEO_H264_PROFILE_IDC_BASELINE = 66,
    STD_VIDEO_H264_PROFILE_IDC_MAIN = 77,
    STD_VIDEO_H264_PROFILE_IDC_HIGH = 100,
    STD_VIDEO_H264_PROFILE_IDC_HIGH_444_PREDICTIVE = 244,
    STD_VIDEO_H264_PROFILE_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264LevelIdc = uint;
enum StdVideoH264LevelIdc STD_VIDEO_H264_LEVEL_IDC_1_0 = 0,
    STD_VIDEO_H264_LEVEL_IDC_1_1 = 1,
    STD_VIDEO_H264_LEVEL_IDC_1_2 = 2,
    STD_VIDEO_H264_LEVEL_IDC_1_3 = 3,
    STD_VIDEO_H264_LEVEL_IDC_2_0 = 4,
    STD_VIDEO_H264_LEVEL_IDC_2_1 = 5,
    STD_VIDEO_H264_LEVEL_IDC_2_2 = 6,
    STD_VIDEO_H264_LEVEL_IDC_3_0 = 7,
    STD_VIDEO_H264_LEVEL_IDC_3_1 = 8,
    STD_VIDEO_H264_LEVEL_IDC_3_2 = 9,
    STD_VIDEO_H264_LEVEL_IDC_4_0 = 10,
    STD_VIDEO_H264_LEVEL_IDC_4_1 = 11,
    STD_VIDEO_H264_LEVEL_IDC_4_2 = 12,
    STD_VIDEO_H264_LEVEL_IDC_5_0 = 13,
    STD_VIDEO_H264_LEVEL_IDC_5_1 = 14,
    STD_VIDEO_H264_LEVEL_IDC_5_2 = 15,
    STD_VIDEO_H264_LEVEL_IDC_6_0 = 16,
    STD_VIDEO_H264_LEVEL_IDC_6_1 = 17,
    STD_VIDEO_H264_LEVEL_IDC_6_2 = 18,
    STD_VIDEO_H264_LEVEL_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264PocType = uint;
enum StdVideoH264PocType STD_VIDEO_H264_POC_TYPE_0 = 0,
    STD_VIDEO_H264_POC_TYPE_1 = 1,
    STD_VIDEO_H264_POC_TYPE_2 = 2,
    STD_VIDEO_H264_POC_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoH264AspectRatioIdc = uint;
enum StdVideoH264AspectRatioIdc STD_VIDEO_H264_ASPECT_RATIO_IDC_UNSPECIFIED = 0,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_SQUARE = 1,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_12_11 = 2,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_10_11 = 3,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_16_11 = 4,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_40_33 = 5,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_24_11 = 6,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_20_11 = 7,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_32_11 = 8,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_80_33 = 9,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_18_11 = 10,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_15_11 = 11,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_64_33 = 12,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_160_99 = 13,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_4_3 = 14,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_3_2 = 15,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_2_1 = 16,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_EXTENDED_SAR = 255,
    STD_VIDEO_H264_ASPECT_RATIO_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264WeightedBipredIdc = uint;
enum StdVideoH264WeightedBipredIdc STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_DEFAULT = 0,
    STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_EXPLICIT = 1,
    STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_IMPLICIT = 2,
    STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264ModificationOfPicNumsIdc = uint;
enum StdVideoH264ModificationOfPicNumsIdc STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_SHORT_TERM_SUBTRACT = 0,
    STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_SHORT_TERM_ADD = 1,
    STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_LONG_TERM = 2,
    STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_END = 3,
    STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264MemMgmtControlOp = uint;
enum StdVideoH264MemMgmtControlOp STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_END = 0,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_SHORT_TERM = 1,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_LONG_TERM = 2,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_MARK_LONG_TERM = 3,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_SET_MAX_LONG_TERM_INDEX = 4,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_ALL = 5,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_MARK_CURRENT_AS_LONG_TERM = 6,
    STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_INVALID = 0x7FFFFFFF;

alias StdVideoH264CabacInitIdc = uint;
enum StdVideoH264CabacInitIdc STD_VIDEO_H264_CABAC_INIT_IDC_0 = 0,
    STD_VIDEO_H264_CABAC_INIT_IDC_1 = 1,
    STD_VIDEO_H264_CABAC_INIT_IDC_2 = 2,
    STD_VIDEO_H264_CABAC_INIT_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264DisableDeblockingFilterIdc = uint;
enum StdVideoH264DisableDeblockingFilterIdc STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_DISABLED = 0,
    STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_ENABLED = 1,
    STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_PARTIAL = 2,
    STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH264SliceType = uint;
enum StdVideoH264SliceType STD_VIDEO_H264_SLICE_TYPE_P = 0,
    STD_VIDEO_H264_SLICE_TYPE_B = 1,
    STD_VIDEO_H264_SLICE_TYPE_I = 2,
    STD_VIDEO_H264_SLICE_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoH264PictureType = uint;
enum StdVideoH264PictureType STD_VIDEO_H264_PICTURE_TYPE_P = 0,
    STD_VIDEO_H264_PICTURE_TYPE_B = 1,
    STD_VIDEO_H264_PICTURE_TYPE_I = 2,
    STD_VIDEO_H264_PICTURE_TYPE_IDR = 5,
    STD_VIDEO_H264_PICTURE_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoH264NonVclNaluType = uint;
enum StdVideoH264NonVclNaluType STD_VIDEO_H264_NON_VCL_NALU_TYPE_SPS = 0,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_PPS = 1,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_AUD = 2,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_PREFIX = 3,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_END_OF_SEQUENCE = 4,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_END_OF_STREAM = 5,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_PRECODED = 6,
    STD_VIDEO_H264_NON_VCL_NALU_TYPE_INVALID = 0x7FFFFFFF;

struct StdVideoH264SpsVuiFlags {
    uint aspect_ratio_info_present_flag : 1;
    uint overscan_info_present_flag : 1;
    uint overscan_appropriate_flag : 1;
    uint video_signal_type_present_flag : 1;
    uint video_full_range_flag : 1;
    uint color_description_present_flag : 1;
    uint chroma_loc_info_present_flag : 1;
    uint timing_info_present_flag : 1;
    uint fixed_frame_rate_flag : 1;
    uint bitstream_restriction_flag : 1;
    uint nal_hrd_parameters_present_flag : 1;
    uint vcl_hrd_parameters_present_flag : 1;
}

struct StdVideoH264HrdParameters {
    ubyte cpb_cnt_minus1;
    ubyte bit_rate_scale;
    ubyte cpb_size_scale;
    ubyte reserved1;
    uint[STD_VIDEO_H264_CPB_CNT_LIST_SIZE] bit_rate_value_minus1;
    uint[STD_VIDEO_H264_CPB_CNT_LIST_SIZE] cpb_size_value_minus1;
    ubyte[STD_VIDEO_H264_CPB_CNT_LIST_SIZE] cbr_flag;
    uint initial_cpb_removal_delay_length_minus1;
    uint cpb_removal_delay_length_minus1;
    uint dpb_output_delay_length_minus1;
    uint time_offset_length;
}

struct StdVideoH264SequenceParameterSetVui {
    StdVideoH264SpsVuiFlags flags;
    StdVideoH264AspectRatioIdc aspect_ratio_idc;
    ushort sar_width;
    ushort sar_height;
    ubyte video_format;
    ubyte colour_primaries;
    ubyte transfer_characteristics;
    ubyte matrix_coefficients;
    uint num_units_in_tick;
    uint time_scale;
    ubyte max_num_reorder_frames;
    ubyte max_dec_frame_buffering;
    ubyte chroma_sample_loc_type_top_field;
    ubyte chroma_sample_loc_type_bottom_field;
    uint reserved1;
    const(StdVideoH264HrdParameters)* pHrdParameters;
}

struct StdVideoH264SpsFlags {
    uint constraint_set0_flag : 1;
    uint constraint_set1_flag : 1;
    uint constraint_set2_flag : 1;
    uint constraint_set3_flag : 1;
    uint constraint_set4_flag : 1;
    uint constraint_set5_flag : 1;
    uint direct_8x8_inference_flag : 1;
    uint mb_adaptive_frame_field_flag : 1;
    uint frame_mbs_only_flag : 1;
    uint delta_pic_order_always_zero_flag : 1;
    uint separate_colour_plane_flag : 1;
    uint gaps_in_frame_num_value_allowed_flag : 1;
    uint qpprime_y_zero_transform_bypass_flag : 1;
    uint frame_cropping_flag : 1;
    uint seq_scaling_matrix_present_flag : 1;
    uint vui_parameters_present_flag : 1;
}

struct StdVideoH264ScalingLists {
    ushort scaling_list_present_mask;
    ushort use_default_scaling_matrix_mask;
    ubyte[STD_VIDEO_H264_SCALING_LIST_4X4_NUM_ELEMENTS][STD_VIDEO_H264_SCALING_LIST_4X4_NUM_LISTS] ScalingList4x4;
    ubyte[STD_VIDEO_H264_SCALING_LIST_8X8_NUM_ELEMENTS][STD_VIDEO_H264_SCALING_LIST_8X8_NUM_LISTS] ScalingList8x8;
}

struct StdVideoH264SequenceParameterSet {
    StdVideoH264SpsFlags flags;
    StdVideoH264ProfileIdc profile_idc;
    StdVideoH264LevelIdc level_idc;
    StdVideoH264ChromaFormatIdc chroma_format_idc;
    ubyte seq_parameter_set_id;
    ubyte bit_depth_luma_minus8;
    ubyte bit_depth_chroma_minus8;
    ubyte log2_max_frame_num_minus4;
    StdVideoH264PocType pic_order_cnt_type;
    int offset_for_non_ref_pic;
    int offset_for_top_to_bottom_field;
    ubyte log2_max_pic_order_cnt_lsb_minus4;
    ubyte num_ref_frames_in_pic_order_cnt_cycle;
    ubyte max_num_ref_frames;
    ubyte reserved1;
    uint pic_width_in_mbs_minus1;
    uint pic_height_in_map_units_minus1;
    uint frame_crop_left_offset;
    uint frame_crop_right_offset;
    uint frame_crop_top_offset;
    uint frame_crop_bottom_offset;
    uint reserved2;
    const(int)* pOffsetForRefFrame;
    const(StdVideoH264ScalingLists)* pScalingLists;
    const(StdVideoH264SequenceParameterSetVui)* pSequenceParameterSetVui;
}

struct StdVideoH264PpsFlags {
    uint transform_8x8_mode_flag : 1;
    uint redundant_pic_cnt_present_flag : 1;
    uint constrained_intra_pred_flag : 1;
    uint deblocking_filter_control_present_flag : 1;
    uint weighted_pred_flag : 1;
    uint bottom_field_pic_order_in_frame_present_flag : 1;
    uint entropy_coding_mode_flag : 1;
    uint pic_scaling_matrix_present_flag : 1;
}

struct StdVideoH264PictureParameterSet {
    StdVideoH264PpsFlags flags;
    ubyte seq_parameter_set_id;
    ubyte pic_parameter_set_id;
    ubyte num_ref_idx_l0_default_active_minus1;
    ubyte num_ref_idx_l1_default_active_minus1;
    StdVideoH264WeightedBipredIdc weighted_bipred_idc;
    byte pic_init_qp_minus26;
    byte pic_init_qs_minus26;
    byte chroma_qp_index_offset;
    byte second_chroma_qp_index_offset;
    const(StdVideoH264ScalingLists)* pScalingLists;
}

struct StdVideoEncodeH264WeightTableFlags {
    uint luma_weight_l0_flag;
    uint chroma_weight_l0_flag;
    uint luma_weight_l1_flag;
    uint chroma_weight_l1_flag;
}

struct StdVideoEncodeH264WeightTable {
    StdVideoEncodeH264WeightTableFlags flags;
    ubyte luma_log2_weight_denom;
    ubyte chroma_log2_weight_denom;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_weight_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_offset_l0;
    byte[STD_VIDEO_H264_MAX_CHROMA_PLANES][STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_weight_l0;
    byte[STD_VIDEO_H264_MAX_CHROMA_PLANES][STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_offset_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_weight_l1;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_offset_l1;
    byte[STD_VIDEO_H264_MAX_CHROMA_PLANES][STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_weight_l1;
    byte[STD_VIDEO_H264_MAX_CHROMA_PLANES][STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_offset_l1;
}

struct StdVideoEncodeH264SliceHeaderFlags {
    uint direct_spatial_mv_pred_flag : 1;
    uint num_ref_idx_active_override_flag : 1;
    uint reserved : 30;
}

struct StdVideoEncodeH264PictureInfoFlags {
    uint IdrPicFlag : 1;
    uint is_reference : 1;
    uint no_output_of_prior_pics_flag : 1;
    uint long_term_reference_flag : 1;
    uint adaptive_ref_pic_marking_mode_flag : 1;
    uint reserved : 27;
}

struct StdVideoEncodeH264ReferenceInfoFlags {
    uint used_for_long_term_reference : 1;
    uint reserved : 31;
}

struct StdVideoEncodeH264ReferenceListsInfoFlags {
    uint ref_pic_list_modification_flag_l0 : 1;
    uint ref_pic_list_modification_flag_l1 : 1;
    uint reserved : 30;
}

struct StdVideoEncodeH264RefListModEntry {
    StdVideoH264ModificationOfPicNumsIdc modification_of_pic_nums_idc;
    ushort abs_diff_pic_num_minus1;
    ushort long_term_pic_num;
}

struct StdVideoEncodeH264RefPicMarkingEntry {
    StdVideoH264MemMgmtControlOp memory_management_control_operation;
    ushort difference_of_pic_nums_minus1;
    ushort long_term_pic_num;
    ushort long_term_frame_idx;
    ushort max_long_term_frame_idx_plus1;
}

struct StdVideoEncodeH264ReferenceListsInfo {
    StdVideoEncodeH264ReferenceListsInfoFlags flags;
    ubyte num_ref_idx_l0_active_minus1;
    ubyte num_ref_idx_l1_active_minus1;
    ubyte[STD_VIDEO_H264_MAX_NUM_LIST_REF] RefPicList0;
    ubyte[STD_VIDEO_H264_MAX_NUM_LIST_REF] RefPicList1;
    ubyte refList0ModOpCount;
    ubyte refList1ModOpCount;
    ubyte refPicMarkingOpCount;
    ubyte[7] reserved1;
    const(StdVideoEncodeH264RefListModEntry)* pRefList0ModOperations;
    const(StdVideoEncodeH264RefListModEntry)* pRefList1ModOperations;
    const(StdVideoEncodeH264RefPicMarkingEntry)* pRefPicMarkingOperations;
}

struct StdVideoEncodeH264PictureInfo {
    StdVideoEncodeH264PictureInfoFlags flags;
    ubyte seq_parameter_set_id;
    ubyte pic_parameter_set_id;
    ushort idr_pic_id;
    StdVideoH264PictureType primary_pic_type;
    uint frame_num;
    int PicOrderCnt;
    ubyte temporal_id;
    ubyte[3] reserved1;
    const(StdVideoEncodeH264ReferenceListsInfo)* pRefLists;
}

struct StdVideoEncodeH264ReferenceInfo {
    StdVideoEncodeH264ReferenceInfoFlags flags;
    StdVideoH264PictureType primary_pic_type;
    uint FrameNum;
    int PicOrderCnt;
    ushort long_term_pic_num;
    ushort long_term_frame_idx;
    ubyte temporal_id;
}

struct StdVideoEncodeH264SliceHeader {
    StdVideoEncodeH264SliceHeaderFlags flags;
    uint first_mb_in_slice;
    StdVideoH264SliceType slice_type;
    byte slice_alpha_c0_offset_div2;
    byte slice_beta_offset_div2;
    byte slice_qp_delta;
    ubyte reserved1;
    StdVideoH264CabacInitIdc cabac_init_idc;
    StdVideoH264DisableDeblockingFilterIdc disable_deblocking_filter_idc;
    const(StdVideoEncodeH264WeightTable)* pWeightTable;
}

alias StdVideoDecodeH264FieldOrderCount = uint;
enum StdVideoDecodeH264FieldOrderCount STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_TOP = 0,
    STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_BOTTOM = 1,
    STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_INVALID = 0x7FFFFFFF;

struct StdVideoDecodeH264PictureInfoFlags {
    uint field_pic_flag : 1;
    uint is_intra : 1;
    uint IdrPicFlag : 1;
    uint bottom_field_flag : 1;
    uint is_reference : 1;
    uint complementary_field_pair : 1;
}

struct StdVideoDecodeH264PictureInfo {
    StdVideoDecodeH264PictureInfoFlags flags;
    ubyte seq_parameter_set_id;
    ubyte pic_parameter_set_id;
    ubyte reserved1;
    ubyte reserved2;
    ushort frame_num;
    ushort idr_pic_id;
    int[STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE] PicOrderCnt;
}

struct StdVideoDecodeH264ReferenceInfoFlags {
    uint top_field_flag : 1;
    uint bottom_field_flag : 1;
    uint used_for_long_term_reference : 1;
    uint is_non_existing : 1;
}

struct StdVideoDecodeH264ReferenceInfo {
    StdVideoDecodeH264ReferenceInfoFlags flags;
    ushort FrameNum;
    ushort reserved;
    int[STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE] PicOrderCnt;
}
