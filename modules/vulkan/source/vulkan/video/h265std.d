/**
 * vulkan_video_codec_h265std
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h265std;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;

extern (System) @nogc nothrow:

enum STD_VIDEO_H265_CPB_CNT_LIST_SIZE = 32;
enum STD_VIDEO_H265_SUBLAYERS_LIST_SIZE = 7;
enum STD_VIDEO_H265_SCALING_LIST_4X4_NUM_LISTS = 6;
enum STD_VIDEO_H265_SCALING_LIST_4X4_NUM_ELEMENTS = 16;
enum STD_VIDEO_H265_SCALING_LIST_8X8_NUM_LISTS = 6;
enum STD_VIDEO_H265_SCALING_LIST_8X8_NUM_ELEMENTS = 64;
enum STD_VIDEO_H265_SCALING_LIST_16X16_NUM_LISTS = 6;
enum STD_VIDEO_H265_SCALING_LIST_16X16_NUM_ELEMENTS = 64;
enum STD_VIDEO_H265_SCALING_LIST_32X32_NUM_LISTS = 2;
enum STD_VIDEO_H265_SCALING_LIST_32X32_NUM_ELEMENTS = 64;
enum STD_VIDEO_H265_CHROMA_QP_OFFSET_LIST_SIZE = 6;
enum STD_VIDEO_H265_CHROMA_QP_OFFSET_TILE_COLS_LIST_SIZE = 19;
enum STD_VIDEO_H265_CHROMA_QP_OFFSET_TILE_ROWS_LIST_SIZE = 21;
enum STD_VIDEO_H265_PREDICTOR_PALETTE_COMPONENTS_LIST_SIZE = 3;
enum STD_VIDEO_H265_PREDICTOR_PALETTE_COMP_ENTRIES_LIST_SIZE = 128;
enum STD_VIDEO_H265_MAX_NUM_LIST_REF = 15;
enum STD_VIDEO_H265_MAX_CHROMA_PLANES = 2;
enum STD_VIDEO_H265_MAX_SHORT_TERM_REF_PIC_SETS = 64;
enum STD_VIDEO_H265_MAX_DPB_SIZE = 16;
enum STD_VIDEO_H265_MAX_LONG_TERM_REF_PICS_SPS = 32;
enum STD_VIDEO_H265_MAX_LONG_TERM_PICS = 16;
enum STD_VIDEO_H265_MAX_DELTA_POC = 48;
enum STD_VIDEO_H265_NO_REFERENCE_PICTURE = 0xFF;


alias StdVideoH265ChromaFormatIdc = uint;
enum StdVideoH265ChromaFormatIdc
    STD_VIDEO_H265_CHROMA_FORMAT_IDC_MONOCHROME = 0,
    STD_VIDEO_H265_CHROMA_FORMAT_IDC_420 = 1,
    STD_VIDEO_H265_CHROMA_FORMAT_IDC_422 = 2,
    STD_VIDEO_H265_CHROMA_FORMAT_IDC_444 = 3,
    STD_VIDEO_H265_CHROMA_FORMAT_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH265ProfileIdc = uint;
enum StdVideoH265ProfileIdc
    STD_VIDEO_H265_PROFILE_IDC_MAIN = 1,
    STD_VIDEO_H265_PROFILE_IDC_MAIN_10 = 2,
    STD_VIDEO_H265_PROFILE_IDC_MAIN_STILL_PICTURE = 3,
    STD_VIDEO_H265_PROFILE_IDC_FORMAT_RANGE_EXTENSIONS = 4,
    STD_VIDEO_H265_PROFILE_IDC_SCC_EXTENSIONS = 9,
    STD_VIDEO_H265_PROFILE_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH265LevelIdc = uint;
enum StdVideoH265LevelIdc
    STD_VIDEO_H265_LEVEL_IDC_1_0 = 0,
    STD_VIDEO_H265_LEVEL_IDC_2_0 = 1,
    STD_VIDEO_H265_LEVEL_IDC_2_1 = 2,
    STD_VIDEO_H265_LEVEL_IDC_3_0 = 3,
    STD_VIDEO_H265_LEVEL_IDC_3_1 = 4,
    STD_VIDEO_H265_LEVEL_IDC_4_0 = 5,
    STD_VIDEO_H265_LEVEL_IDC_4_1 = 6,
    STD_VIDEO_H265_LEVEL_IDC_5_0 = 7,
    STD_VIDEO_H265_LEVEL_IDC_5_1 = 8,
    STD_VIDEO_H265_LEVEL_IDC_5_2 = 9,
    STD_VIDEO_H265_LEVEL_IDC_6_0 = 10,
    STD_VIDEO_H265_LEVEL_IDC_6_1 = 11,
    STD_VIDEO_H265_LEVEL_IDC_6_2 = 12,
    STD_VIDEO_H265_LEVEL_IDC_INVALID = 0x7FFFFFFF;

alias StdVideoH265SliceType = uint;
enum StdVideoH265SliceType
    STD_VIDEO_H265_SLICE_TYPE_B = 0,
    STD_VIDEO_H265_SLICE_TYPE_P = 1,
    STD_VIDEO_H265_SLICE_TYPE_I = 2,
    STD_VIDEO_H265_SLICE_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoH265PictureType = uint;
enum StdVideoH265PictureType
    STD_VIDEO_H265_PICTURE_TYPE_P = 0,
    STD_VIDEO_H265_PICTURE_TYPE_B = 1,
    STD_VIDEO_H265_PICTURE_TYPE_I = 2,
    STD_VIDEO_H265_PICTURE_TYPE_IDR = 3,
    STD_VIDEO_H265_PICTURE_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoH265AspectRatioIdc = uint;
enum StdVideoH265AspectRatioIdc
    STD_VIDEO_H265_ASPECT_RATIO_IDC_UNSPECIFIED = 0,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_SQUARE = 1,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_12_11 = 2,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_10_11 = 3,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_16_11 = 4,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_40_33 = 5,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_24_11 = 6,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_20_11 = 7,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_32_11 = 8,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_80_33 = 9,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_18_11 = 10,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_15_11 = 11,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_64_33 = 12,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_160_99 = 13,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_4_3 = 14,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_3_2 = 15,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_2_1 = 16,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_EXTENDED_SAR = 255,
    STD_VIDEO_H265_ASPECT_RATIO_IDC_INVALID = 0x7FFFFFFF;

struct StdVideoH265DecPicBufMgr {
    uint[STD_VIDEO_H265_SUBLAYERS_LIST_SIZE] max_latency_increase_plus1;
    ubyte[STD_VIDEO_H265_SUBLAYERS_LIST_SIZE] max_dec_pic_buffering_minus1;
    ubyte[STD_VIDEO_H265_SUBLAYERS_LIST_SIZE] max_num_reorder_pics;
}

struct StdVideoH265SubLayerHrdParameters {
    uint[STD_VIDEO_H265_CPB_CNT_LIST_SIZE] bit_rate_value_minus1;
    uint[STD_VIDEO_H265_CPB_CNT_LIST_SIZE] cpb_size_value_minus1;
    uint[STD_VIDEO_H265_CPB_CNT_LIST_SIZE] cpb_size_du_value_minus1;
    uint[STD_VIDEO_H265_CPB_CNT_LIST_SIZE] bit_rate_du_value_minus1;
    uint cbr_flag;
}

struct StdVideoH265HrdFlags {
    uint nal_hrd_parameters_present_flag:1;
    uint vcl_hrd_parameters_present_flag:1;
    uint sub_pic_hrd_params_present_flag:1;
    uint sub_pic_cpb_params_in_pic_timing_sei_flag:1;
    uint fixed_pic_rate_general_flag:8;
    uint fixed_pic_rate_within_cvs_flag:8;
    uint low_delay_hrd_flag:8;
    mixin DMD20473;
}

struct StdVideoH265HrdParameters {
    StdVideoH265HrdFlags flags;
    ubyte tick_divisor_minus2;
    ubyte du_cpb_removal_delay_increment_length_minus1;
    ubyte dpb_output_delay_du_length_minus1;
    ubyte bit_rate_scale;
    ubyte cpb_size_scale;
    ubyte cpb_size_du_scale;
    ubyte initial_cpb_removal_delay_length_minus1;
    ubyte au_cpb_removal_delay_length_minus1;
    ubyte dpb_output_delay_length_minus1;
    ubyte[STD_VIDEO_H265_SUBLAYERS_LIST_SIZE] cpb_cnt_minus1;
    ushort[STD_VIDEO_H265_SUBLAYERS_LIST_SIZE] elemental_duration_in_tc_minus1;
    ushort[3] reserved;
    const(StdVideoH265SubLayerHrdParameters)* pSubLayerHrdParametersNal;
    const(StdVideoH265SubLayerHrdParameters)* pSubLayerHrdParametersVcl;
}

struct StdVideoH265VpsFlags {
    uint vps_temporal_id_nesting_flag:1;
    uint vps_sub_layer_ordering_info_present_flag:1;
    uint vps_timing_info_present_flag:1;
    uint vps_poc_proportional_to_timing_flag:1;
    mixin DMD20473;
}

struct StdVideoH265ProfileTierLevelFlags {
    uint general_tier_flag:1;
    uint general_progressive_source_flag:1;
    uint general_interlaced_source_flag:1;
    uint general_non_packed_constraint_flag:1;
    uint general_frame_only_constraint_flag:1;
    mixin DMD20473;
}

struct StdVideoH265ProfileTierLevel {
    StdVideoH265ProfileTierLevelFlags flags;
    StdVideoH265ProfileIdc general_profile_idc;
    StdVideoH265LevelIdc general_level_idc;
}

struct StdVideoH265VideoParameterSet {
    StdVideoH265VpsFlags flags;
    ubyte vps_video_parameter_set_id;
    ubyte vps_max_sub_layers_minus1;
    ubyte reserved1;
    ubyte reserved2;
    uint vps_num_units_in_tick;
    uint vps_time_scale;
    uint vps_num_ticks_poc_diff_one_minus1;
    uint reserved3;
    const(StdVideoH265DecPicBufMgr)* pDecPicBufMgr;
    const(StdVideoH265HrdParameters)* pHrdParameters;
    const(StdVideoH265ProfileTierLevel)* pProfileTierLevel;
}

struct StdVideoH265ScalingLists {
    ubyte[STD_VIDEO_H265_SCALING_LIST_4X4_NUM_LISTS][STD_VIDEO_H265_SCALING_LIST_4X4_NUM_ELEMENTS] ScalingList4x4;
    ubyte[STD_VIDEO_H265_SCALING_LIST_8X8_NUM_LISTS][STD_VIDEO_H265_SCALING_LIST_8X8_NUM_ELEMENTS] ScalingList8x8;
    ubyte[STD_VIDEO_H265_SCALING_LIST_16X16_NUM_LISTS][STD_VIDEO_H265_SCALING_LIST_16X16_NUM_ELEMENTS] ScalingList16x16;
    ubyte[STD_VIDEO_H265_SCALING_LIST_32X32_NUM_LISTS][STD_VIDEO_H265_SCALING_LIST_32X32_NUM_ELEMENTS] ScalingList32x32;
    ubyte[STD_VIDEO_H265_SCALING_LIST_16X16_NUM_LISTS] ScalingListDCCoef16x16;
    ubyte[STD_VIDEO_H265_SCALING_LIST_32X32_NUM_LISTS] ScalingListDCCoef32x32;
}

struct StdVideoH265SpsVuiFlags {
    uint aspect_ratio_info_present_flag:1;
    uint overscan_info_present_flag:1;
    uint overscan_appropriate_flag:1;
    uint video_signal_type_present_flag:1;
    uint video_full_range_flag:1;
    uint colour_description_present_flag:1;
    uint chroma_loc_info_present_flag:1;
    uint neutral_chroma_indication_flag:1;
    uint field_seq_flag:1;
    uint frame_field_info_present_flag:1;
    uint default_display_window_flag:1;
    uint vui_timing_info_present_flag:1;
    uint vui_poc_proportional_to_timing_flag:1;
    uint vui_hrd_parameters_present_flag:1;
    uint bitstream_restriction_flag:1;
    uint tiles_fixed_structure_flag:1;
    uint motion_vectors_over_pic_boundaries_flag:1;
    uint restricted_ref_pic_lists_flag:1;
    mixin DMD20473;
}

struct StdVideoH265SequenceParameterSetVui {
    StdVideoH265SpsVuiFlags flags;
    StdVideoH265AspectRatioIdc aspect_ratio_idc;
    ushort sar_width;
    ushort sar_height;
    ubyte video_format;
    ubyte colour_primaries;
    ubyte transfer_characteristics;
    ubyte matrix_coeffs;
    ubyte chroma_sample_loc_type_top_field;
    ubyte chroma_sample_loc_type_bottom_field;
    ubyte reserved1;
    ubyte reserved2;
    ushort def_disp_win_left_offset;
    ushort def_disp_win_right_offset;
    ushort def_disp_win_top_offset;
    ushort def_disp_win_bottom_offset;
    uint vui_num_units_in_tick;
    uint vui_time_scale;
    uint vui_num_ticks_poc_diff_one_minus1;
    ushort min_spatial_segmentation_idc;
    ushort reserved3;
    ubyte max_bytes_per_pic_denom;
    ubyte max_bits_per_min_cu_denom;
    ubyte log2_max_mv_length_horizontal;
    ubyte log2_max_mv_length_vertical;
    const(StdVideoH265HrdParameters)* pHrdParameters;
}

struct StdVideoH265PredictorPaletteEntries {
    ushort[STD_VIDEO_H265_PREDICTOR_PALETTE_COMPONENTS_LIST_SIZE][STD_VIDEO_H265_PREDICTOR_PALETTE_COMP_ENTRIES_LIST_SIZE] PredictorPaletteEntries;
}

struct StdVideoH265SpsFlags {
    uint sps_temporal_id_nesting_flag:1;
    uint separate_colour_plane_flag:1;
    uint conformance_window_flag:1;
    uint sps_sub_layer_ordering_info_present_flag:1;
    uint scaling_list_enabled_flag:1;
    uint sps_scaling_list_data_present_flag:1;
    uint amp_enabled_flag:1;
    uint sample_adaptive_offset_enabled_flag:1;
    uint pcm_enabled_flag:1;
    uint pcm_loop_filter_disabled_flag:1;
    uint long_term_ref_pics_present_flag:1;
    uint sps_temporal_mvp_enabled_flag:1;
    uint strong_intra_smoothing_enabled_flag:1;
    uint vui_parameters_present_flag:1;
    uint sps_extension_present_flag:1;
    uint sps_range_extension_flag:1;
    uint transform_skip_rotation_enabled_flag:1;
    uint transform_skip_context_enabled_flag:1;
    uint implicit_rdpcm_enabled_flag:1;
    uint explicit_rdpcm_enabled_flag:1;
    uint extended_precision_processing_flag:1;
    uint intra_smoothing_disabled_flag:1;
    uint high_precision_offsets_enabled_flag:1;
    uint persistent_rice_adaptation_enabled_flag:1;
    uint cabac_bypass_alignment_enabled_flag:1;
    uint sps_scc_extension_flag:1;
    uint sps_curr_pic_ref_enabled_flag:1;
    uint palette_mode_enabled_flag:1;
    uint sps_palette_predictor_initializers_present_flag:1;
    uint intra_boundary_filtering_disabled_flag:1;
    mixin DMD20473;
}

struct StdVideoH265ShortTermRefPicSetFlags {
    uint inter_ref_pic_set_prediction_flag:1;
    uint delta_rps_sign:1;
    mixin DMD20473;
}

struct StdVideoH265ShortTermRefPicSet {
    StdVideoH265ShortTermRefPicSetFlags flags;
    uint delta_idx_minus1;
    ushort use_delta_flag;
    ushort abs_delta_rps_minus1;
    ushort used_by_curr_pic_flag;
    ushort used_by_curr_pic_s0_flag;
    ushort used_by_curr_pic_s1_flag;
    ushort reserved1;
    ubyte reserved2;
    ubyte reserved3;
    ubyte num_negative_pics;
    ubyte num_positive_pics;
    ushort[STD_VIDEO_H265_MAX_DPB_SIZE] delta_poc_s0_minus1;
    ushort[STD_VIDEO_H265_MAX_DPB_SIZE] delta_poc_s1_minus1;
}

struct StdVideoH265LongTermRefPicsSps {
    uint used_by_curr_pic_lt_sps_flag;
    uint[STD_VIDEO_H265_MAX_LONG_TERM_REF_PICS_SPS] lt_ref_pic_poc_lsb_sps;
}

struct StdVideoH265SequenceParameterSet {
    StdVideoH265SpsFlags flags;
    StdVideoH265ChromaFormatIdc chroma_format_idc;
    uint pic_width_in_luma_samples;
    uint pic_height_in_luma_samples;
    ubyte sps_video_parameter_set_id;
    ubyte sps_max_sub_layers_minus1;
    ubyte sps_seq_parameter_set_id;
    ubyte bit_depth_luma_minus8;
    ubyte bit_depth_chroma_minus8;
    ubyte log2_max_pic_order_cnt_lsb_minus4;
    ubyte log2_min_luma_coding_block_size_minus3;
    ubyte log2_diff_max_min_luma_coding_block_size;
    ubyte log2_min_luma_transform_block_size_minus2;
    ubyte log2_diff_max_min_luma_transform_block_size;
    ubyte max_transform_hierarchy_depth_inter;
    ubyte max_transform_hierarchy_depth_intra;
    ubyte num_short_term_ref_pic_sets;
    ubyte num_long_term_ref_pics_sps;
    ubyte pcm_sample_bit_depth_luma_minus1;
    ubyte pcm_sample_bit_depth_chroma_minus1;
    ubyte log2_min_pcm_luma_coding_block_size_minus3;
    ubyte log2_diff_max_min_pcm_luma_coding_block_size;
    ubyte reserved1;
    ubyte reserved2;
    ubyte palette_max_size;
    ubyte delta_palette_max_predictor_size;
    ubyte motion_vector_resolution_control_idc;
    ubyte sps_num_palette_predictor_initializers_minus1;
    uint conf_win_left_offset;
    uint conf_win_right_offset;
    uint conf_win_top_offset;
    uint conf_win_bottom_offset;
    const(StdVideoH265ProfileTierLevel)* pProfileTierLevel;
    const(StdVideoH265DecPicBufMgr)* pDecPicBufMgr;
    const(StdVideoH265ScalingLists)* pScalingLists;
    const(StdVideoH265ShortTermRefPicSet)* pShortTermRefPicSet;
    const(StdVideoH265LongTermRefPicsSps)* pLongTermRefPicsSps;
    const(StdVideoH265SequenceParameterSetVui)* pSequenceParameterSetVui;
    const(StdVideoH265PredictorPaletteEntries)* pPredictorPaletteEntries;
}

struct StdVideoH265PpsFlags {
    uint dependent_slice_segments_enabled_flag:1;
    uint output_flag_present_flag:1;
    uint sign_data_hiding_enabled_flag:1;
    uint cabac_init_present_flag:1;
    uint constrained_intra_pred_flag:1;
    uint transform_skip_enabled_flag:1;
    uint cu_qp_delta_enabled_flag:1;
    uint pps_slice_chroma_qp_offsets_present_flag:1;
    uint weighted_pred_flag:1;
    uint weighted_bipred_flag:1;
    uint transquant_bypass_enabled_flag:1;
    uint tiles_enabled_flag:1;
    uint entropy_coding_sync_enabled_flag:1;
    uint uniform_spacing_flag:1;
    uint loop_filter_across_tiles_enabled_flag:1;
    uint pps_loop_filter_across_slices_enabled_flag:1;
    uint deblocking_filter_control_present_flag:1;
    uint deblocking_filter_override_enabled_flag:1;
    uint pps_deblocking_filter_disabled_flag:1;
    uint pps_scaling_list_data_present_flag:1;
    uint lists_modification_present_flag:1;
    uint slice_segment_header_extension_present_flag:1;
    uint pps_extension_present_flag:1;
    uint cross_component_prediction_enabled_flag:1;
    uint chroma_qp_offset_list_enabled_flag:1;
    uint pps_curr_pic_ref_enabled_flag:1;
    uint residual_adaptive_colour_transform_enabled_flag:1;
    uint pps_slice_act_qp_offsets_present_flag:1;
    uint pps_palette_predictor_initializers_present_flag:1;
    uint monochrome_palette_flag:1;
    uint pps_range_extension_flag:1;
    mixin DMD20473;
}

struct StdVideoH265PictureParameterSet {
    StdVideoH265PpsFlags flags;
    ubyte pps_pic_parameter_set_id;
    ubyte pps_seq_parameter_set_id;
    ubyte sps_video_parameter_set_id;
    ubyte num_extra_slice_header_bits;
    ubyte num_ref_idx_l0_default_active_minus1;
    ubyte num_ref_idx_l1_default_active_minus1;
    byte init_qp_minus26;
    ubyte diff_cu_qp_delta_depth;
    byte pps_cb_qp_offset;
    byte pps_cr_qp_offset;
    byte pps_beta_offset_div2;
    byte pps_tc_offset_div2;
    ubyte log2_parallel_merge_level_minus2;
    ubyte log2_max_transform_skip_block_size_minus2;
    ubyte diff_cu_chroma_qp_offset_depth;
    ubyte chroma_qp_offset_list_len_minus1;
    byte[STD_VIDEO_H265_CHROMA_QP_OFFSET_LIST_SIZE] cb_qp_offset_list;
    byte[STD_VIDEO_H265_CHROMA_QP_OFFSET_LIST_SIZE] cr_qp_offset_list;
    ubyte log2_sao_offset_scale_luma;
    ubyte log2_sao_offset_scale_chroma;
    byte pps_act_y_qp_offset_plus5;
    byte pps_act_cb_qp_offset_plus5;
    byte pps_act_cr_qp_offset_plus3;
    ubyte pps_num_palette_predictor_initializers;
    ubyte luma_bit_depth_entry_minus8;
    ubyte chroma_bit_depth_entry_minus8;
    ubyte num_tile_columns_minus1;
    ubyte num_tile_rows_minus1;
    ubyte reserved1;
    ubyte reserved2;
    ushort[STD_VIDEO_H265_CHROMA_QP_OFFSET_TILE_COLS_LIST_SIZE] column_width_minus1;
    ushort[STD_VIDEO_H265_CHROMA_QP_OFFSET_TILE_ROWS_LIST_SIZE] row_height_minus1;
    uint reserved3;
    const(StdVideoH265ScalingLists)* pScalingLists;
    const(StdVideoH265PredictorPaletteEntries)* pPredictorPaletteEntries;
}
