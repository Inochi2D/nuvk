/**
 * vulkan_video_codec_h264std
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h264std;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.video.common;

extern (System) @nogc nothrow:

enum STD_VIDEO_H264_CPB_CNT_LIST_SIZE = 32;
enum STD_VIDEO_H264_SCALING_LIST_4X4_NUM_LISTS = 6;
enum STD_VIDEO_H264_SCALING_LIST_4X4_NUM_ELEMENTS = 16;
enum STD_VIDEO_H264_SCALING_LIST_8X8_NUM_LISTS = 6;
enum STD_VIDEO_H264_SCALING_LIST_8X8_NUM_ELEMENTS = 64;
enum STD_VIDEO_H264_MAX_NUM_LIST_REF = 32;
enum STD_VIDEO_H264_MAX_CHROMA_PLANES = 2;
enum STD_VIDEO_H264_NO_REFERENCE_PICTURE = 0xFF;


enum StdVideoH264ChromaFormatIdc {
    MONOCHROME = 0,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_420 = 1,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_422 = 2,
    STD_VIDEO_H264_CHROMA_FORMAT_IDC_444 = 3,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_CHROMA_FORMAT_IDC_MONOCHROME = StdVideoH264ChromaFormatIdc.MONOCHROME;
enum STD_VIDEO_H264_CHROMA_FORMAT_IDC_420 = StdVideoH264ChromaFormatIdc.STD_VIDEO_H264_CHROMA_FORMAT_IDC_420;
enum STD_VIDEO_H264_CHROMA_FORMAT_IDC_422 = StdVideoH264ChromaFormatIdc.STD_VIDEO_H264_CHROMA_FORMAT_IDC_422;
enum STD_VIDEO_H264_CHROMA_FORMAT_IDC_444 = StdVideoH264ChromaFormatIdc.STD_VIDEO_H264_CHROMA_FORMAT_IDC_444;
enum STD_VIDEO_H264_CHROMA_FORMAT_IDC_INVALID = StdVideoH264ChromaFormatIdc.INVALID;

enum StdVideoH264ProfileIdc {
    BASELINE = 66,
    MAIN = 77,
    HIGH = 100,
    HIGH_444_PREDICTIVE = 244,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_PROFILE_IDC_BASELINE = StdVideoH264ProfileIdc.BASELINE;
enum STD_VIDEO_H264_PROFILE_IDC_MAIN = StdVideoH264ProfileIdc.MAIN;
enum STD_VIDEO_H264_PROFILE_IDC_HIGH = StdVideoH264ProfileIdc.HIGH;
enum STD_VIDEO_H264_PROFILE_IDC_HIGH_444_PREDICTIVE = StdVideoH264ProfileIdc.HIGH_444_PREDICTIVE;
enum STD_VIDEO_H264_PROFILE_IDC_INVALID = StdVideoH264ProfileIdc.INVALID;

enum StdVideoH264LevelIdc {
    STD_VIDEO_H264_LEVEL_IDC_1_0 = 0,
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
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_LEVEL_IDC_1_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_1_0;
enum STD_VIDEO_H264_LEVEL_IDC_1_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_1_1;
enum STD_VIDEO_H264_LEVEL_IDC_1_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_1_2;
enum STD_VIDEO_H264_LEVEL_IDC_1_3 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_1_3;
enum STD_VIDEO_H264_LEVEL_IDC_2_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_2_0;
enum STD_VIDEO_H264_LEVEL_IDC_2_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_2_1;
enum STD_VIDEO_H264_LEVEL_IDC_2_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_2_2;
enum STD_VIDEO_H264_LEVEL_IDC_3_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_3_0;
enum STD_VIDEO_H264_LEVEL_IDC_3_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_3_1;
enum STD_VIDEO_H264_LEVEL_IDC_3_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_3_2;
enum STD_VIDEO_H264_LEVEL_IDC_4_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_4_0;
enum STD_VIDEO_H264_LEVEL_IDC_4_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_4_1;
enum STD_VIDEO_H264_LEVEL_IDC_4_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_4_2;
enum STD_VIDEO_H264_LEVEL_IDC_5_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_5_0;
enum STD_VIDEO_H264_LEVEL_IDC_5_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_5_1;
enum STD_VIDEO_H264_LEVEL_IDC_5_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_5_2;
enum STD_VIDEO_H264_LEVEL_IDC_6_0 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_6_0;
enum STD_VIDEO_H264_LEVEL_IDC_6_1 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_6_1;
enum STD_VIDEO_H264_LEVEL_IDC_6_2 = StdVideoH264LevelIdc.STD_VIDEO_H264_LEVEL_IDC_6_2;
enum STD_VIDEO_H264_LEVEL_IDC_INVALID = StdVideoH264LevelIdc.INVALID;

enum StdVideoH264PocType {
    STD_VIDEO_H264_POC_TYPE_0 = 0,
    STD_VIDEO_H264_POC_TYPE_1 = 1,
    STD_VIDEO_H264_POC_TYPE_2 = 2,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_POC_TYPE_0 = StdVideoH264PocType.STD_VIDEO_H264_POC_TYPE_0;
enum STD_VIDEO_H264_POC_TYPE_1 = StdVideoH264PocType.STD_VIDEO_H264_POC_TYPE_1;
enum STD_VIDEO_H264_POC_TYPE_2 = StdVideoH264PocType.STD_VIDEO_H264_POC_TYPE_2;
enum STD_VIDEO_H264_POC_TYPE_INVALID = StdVideoH264PocType.INVALID;

enum StdVideoH264AspectRatioIdc {
    UNSPECIFIED = 0,
    SQUARE = 1,
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
    EXTENDED_SAR = 255,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_ASPECT_RATIO_IDC_UNSPECIFIED = StdVideoH264AspectRatioIdc.UNSPECIFIED;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_SQUARE = StdVideoH264AspectRatioIdc.SQUARE;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_12_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_12_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_10_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_10_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_16_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_16_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_40_33 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_40_33;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_24_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_24_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_20_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_20_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_32_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_32_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_80_33 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_80_33;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_18_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_18_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_15_11 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_15_11;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_64_33 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_64_33;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_160_99 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_160_99;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_4_3 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_4_3;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_3_2 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_3_2;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_2_1 = StdVideoH264AspectRatioIdc.STD_VIDEO_H264_ASPECT_RATIO_IDC_2_1;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_EXTENDED_SAR = StdVideoH264AspectRatioIdc.EXTENDED_SAR;
enum STD_VIDEO_H264_ASPECT_RATIO_IDC_INVALID = StdVideoH264AspectRatioIdc.INVALID;

enum StdVideoH264WeightedBipredIdc {
    DEFAULT = 0,
    EXPLICIT = 1,
    IMPLICIT = 2,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_DEFAULT = StdVideoH264WeightedBipredIdc.DEFAULT;
enum STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_EXPLICIT = StdVideoH264WeightedBipredIdc.EXPLICIT;
enum STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_IMPLICIT = StdVideoH264WeightedBipredIdc.IMPLICIT;
enum STD_VIDEO_H264_WEIGHTED_BIPRED_IDC_INVALID = StdVideoH264WeightedBipredIdc.INVALID;

enum StdVideoH264ModificationOfPicNumsIdc {
    SHORT_TERM_SUBTRACT = 0,
    SHORT_TERM_ADD = 1,
    LONG_TERM = 2,
    END = 3,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_SHORT_TERM_SUBTRACT = StdVideoH264ModificationOfPicNumsIdc.SHORT_TERM_SUBTRACT;
enum STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_SHORT_TERM_ADD = StdVideoH264ModificationOfPicNumsIdc.SHORT_TERM_ADD;
enum STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_LONG_TERM = StdVideoH264ModificationOfPicNumsIdc.LONG_TERM;
enum STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_END = StdVideoH264ModificationOfPicNumsIdc.END;
enum STD_VIDEO_H264_MODIFICATION_OF_PIC_NUMS_IDC_INVALID = StdVideoH264ModificationOfPicNumsIdc.INVALID;

enum StdVideoH264MemMgmtControlOp {
    END = 0,
    UNMARK_SHORT_TERM = 1,
    UNMARK_LONG_TERM = 2,
    MARK_LONG_TERM = 3,
    SET_MAX_LONG_TERM_INDEX = 4,
    UNMARK_ALL = 5,
    MARK_CURRENT_AS_LONG_TERM = 6,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_END = StdVideoH264MemMgmtControlOp.END;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_SHORT_TERM = StdVideoH264MemMgmtControlOp.UNMARK_SHORT_TERM;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_LONG_TERM = StdVideoH264MemMgmtControlOp.UNMARK_LONG_TERM;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_MARK_LONG_TERM = StdVideoH264MemMgmtControlOp.MARK_LONG_TERM;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_SET_MAX_LONG_TERM_INDEX = StdVideoH264MemMgmtControlOp.SET_MAX_LONG_TERM_INDEX;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_UNMARK_ALL = StdVideoH264MemMgmtControlOp.UNMARK_ALL;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_MARK_CURRENT_AS_LONG_TERM = StdVideoH264MemMgmtControlOp.MARK_CURRENT_AS_LONG_TERM;
enum STD_VIDEO_H264_MEM_MGMT_CONTROL_OP_INVALID = StdVideoH264MemMgmtControlOp.INVALID;

enum StdVideoH264CabacInitIdc {
    STD_VIDEO_H264_CABAC_INIT_IDC_0 = 0,
    STD_VIDEO_H264_CABAC_INIT_IDC_1 = 1,
    STD_VIDEO_H264_CABAC_INIT_IDC_2 = 2,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_CABAC_INIT_IDC_0 = StdVideoH264CabacInitIdc.STD_VIDEO_H264_CABAC_INIT_IDC_0;
enum STD_VIDEO_H264_CABAC_INIT_IDC_1 = StdVideoH264CabacInitIdc.STD_VIDEO_H264_CABAC_INIT_IDC_1;
enum STD_VIDEO_H264_CABAC_INIT_IDC_2 = StdVideoH264CabacInitIdc.STD_VIDEO_H264_CABAC_INIT_IDC_2;
enum STD_VIDEO_H264_CABAC_INIT_IDC_INVALID = StdVideoH264CabacInitIdc.INVALID;

enum StdVideoH264DisableDeblockingFilterIdc {
    DISABLED = 0,
    ENABLED = 1,
    PARTIAL = 2,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_DISABLED = StdVideoH264DisableDeblockingFilterIdc.DISABLED;
enum STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_ENABLED = StdVideoH264DisableDeblockingFilterIdc.ENABLED;
enum STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_PARTIAL = StdVideoH264DisableDeblockingFilterIdc.PARTIAL;
enum STD_VIDEO_H264_DISABLE_DEBLOCKING_FILTER_IDC_INVALID = StdVideoH264DisableDeblockingFilterIdc.INVALID;

enum StdVideoH264SliceType {
    P = 0,
    B = 1,
    I = 2,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_SLICE_TYPE_P = StdVideoH264SliceType.P;
enum STD_VIDEO_H264_SLICE_TYPE_B = StdVideoH264SliceType.B;
enum STD_VIDEO_H264_SLICE_TYPE_I = StdVideoH264SliceType.I;
enum STD_VIDEO_H264_SLICE_TYPE_INVALID = StdVideoH264SliceType.INVALID;

enum StdVideoH264PictureType {
    P = 0,
    B = 1,
    I = 2,
    IDR = 5,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_PICTURE_TYPE_P = StdVideoH264PictureType.P;
enum STD_VIDEO_H264_PICTURE_TYPE_B = StdVideoH264PictureType.B;
enum STD_VIDEO_H264_PICTURE_TYPE_I = StdVideoH264PictureType.I;
enum STD_VIDEO_H264_PICTURE_TYPE_IDR = StdVideoH264PictureType.IDR;
enum STD_VIDEO_H264_PICTURE_TYPE_INVALID = StdVideoH264PictureType.INVALID;

enum StdVideoH264NonVclNaluType {
    SPS = 0,
    PPS = 1,
    AUD = 2,
    PREFIX = 3,
    END_OF_SEQUENCE = 4,
    END_OF_STREAM = 5,
    PRECODED = 6,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_SPS = StdVideoH264NonVclNaluType.SPS;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_PPS = StdVideoH264NonVclNaluType.PPS;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_AUD = StdVideoH264NonVclNaluType.AUD;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_PREFIX = StdVideoH264NonVclNaluType.PREFIX;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_END_OF_SEQUENCE = StdVideoH264NonVclNaluType.END_OF_SEQUENCE;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_END_OF_STREAM = StdVideoH264NonVclNaluType.END_OF_STREAM;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_PRECODED = StdVideoH264NonVclNaluType.PRECODED;
enum STD_VIDEO_H264_NON_VCL_NALU_TYPE_INVALID = StdVideoH264NonVclNaluType.INVALID;

struct StdVideoH264SpsVuiFlags {
    uint aspect_ratio_info_present_flag;
    uint overscan_info_present_flag;
    uint overscan_appropriate_flag;
    uint video_signal_type_present_flag;
    uint video_full_range_flag;
    uint color_description_present_flag;
    uint chroma_loc_info_present_flag;
    uint timing_info_present_flag;
    uint fixed_frame_rate_flag;
    uint bitstream_restriction_flag;
    uint nal_hrd_parameters_present_flag;
    uint vcl_hrd_parameters_present_flag;
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
    uint constraint_set0_flag;
    uint constraint_set1_flag;
    uint constraint_set2_flag;
    uint constraint_set3_flag;
    uint constraint_set4_flag;
    uint constraint_set5_flag;
    uint direct_8x8_inference_flag;
    uint mb_adaptive_frame_field_flag;
    uint frame_mbs_only_flag;
    uint delta_pic_order_always_zero_flag;
    uint separate_colour_plane_flag;
    uint gaps_in_frame_num_value_allowed_flag;
    uint qpprime_y_zero_transform_bypass_flag;
    uint frame_cropping_flag;
    uint seq_scaling_matrix_present_flag;
    uint vui_parameters_present_flag;
}

struct StdVideoH264ScalingLists {
    ushort scaling_list_present_mask;
    ushort use_default_scaling_matrix_mask;
    ubyte[STD_VIDEO_H264_SCALING_LIST_4X4_NUM_LISTS] ScalingList4x4;
    ubyte[STD_VIDEO_H264_SCALING_LIST_8X8_NUM_LISTS] ScalingList8x8;
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
    uint transform_8x8_mode_flag;
    uint redundant_pic_cnt_present_flag;
    uint constrained_intra_pred_flag;
    uint deblocking_filter_control_present_flag;
    uint weighted_pred_flag;
    uint bottom_field_pic_order_in_frame_present_flag;
    uint entropy_coding_mode_flag;
    uint pic_scaling_matrix_present_flag;
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
