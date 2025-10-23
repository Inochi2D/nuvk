/**
 * vulkan_video_codec_av1std
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.av1std;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;

extern (System) @nogc nothrow:

enum STD_VIDEO_AV1_NUM_REF_FRAMES = 8;
enum STD_VIDEO_AV1_REFS_PER_FRAME = 7;
enum STD_VIDEO_AV1_TOTAL_REFS_PER_FRAME = 8;
enum STD_VIDEO_AV1_MAX_TILE_COLS = 64;
enum STD_VIDEO_AV1_MAX_TILE_ROWS = 64;
enum STD_VIDEO_AV1_MAX_SEGMENTS = 8;
enum STD_VIDEO_AV1_SEG_LVL_MAX = 8;
enum STD_VIDEO_AV1_PRIMARY_REF_NONE = 7;
enum STD_VIDEO_AV1_SELECT_INTEGER_MV = 2;
enum STD_VIDEO_AV1_SELECT_SCREEN_CONTENT_TOOLS = 2;
enum STD_VIDEO_AV1_SKIP_MODE_FRAMES = 2;
enum STD_VIDEO_AV1_MAX_LOOP_FILTER_STRENGTHS = 4;
enum STD_VIDEO_AV1_LOOP_FILTER_ADJUSTMENTS = 2;
enum STD_VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS = 8;
enum STD_VIDEO_AV1_MAX_NUM_PLANES = 3;
enum STD_VIDEO_AV1_GLOBAL_MOTION_PARAMS = 6;
enum STD_VIDEO_AV1_MAX_NUM_Y_POINTS = 14;
enum STD_VIDEO_AV1_MAX_NUM_CB_POINTS = 10;
enum STD_VIDEO_AV1_MAX_NUM_CR_POINTS = 10;
enum STD_VIDEO_AV1_MAX_NUM_POS_LUMA = 24;
enum STD_VIDEO_AV1_MAX_NUM_POS_CHROMA = 25;


alias StdVideoAV1Profile = uint;
enum StdVideoAV1Profile
    STD_VIDEO_AV1_PROFILE_MAIN = 0,
    STD_VIDEO_AV1_PROFILE_HIGH = 1,
    STD_VIDEO_AV1_PROFILE_PROFESSIONAL = 2,
    STD_VIDEO_AV1_PROFILE_INVALID = 0x7FFFFFFF;

alias StdVideoAV1Level = uint;
enum StdVideoAV1Level
    STD_VIDEO_AV1_LEVEL_2_0 = 0,
    STD_VIDEO_AV1_LEVEL_2_1 = 1,
    STD_VIDEO_AV1_LEVEL_2_2 = 2,
    STD_VIDEO_AV1_LEVEL_2_3 = 3,
    STD_VIDEO_AV1_LEVEL_3_0 = 4,
    STD_VIDEO_AV1_LEVEL_3_1 = 5,
    STD_VIDEO_AV1_LEVEL_3_2 = 6,
    STD_VIDEO_AV1_LEVEL_3_3 = 7,
    STD_VIDEO_AV1_LEVEL_4_0 = 8,
    STD_VIDEO_AV1_LEVEL_4_1 = 9,
    STD_VIDEO_AV1_LEVEL_4_2 = 10,
    STD_VIDEO_AV1_LEVEL_4_3 = 11,
    STD_VIDEO_AV1_LEVEL_5_0 = 12,
    STD_VIDEO_AV1_LEVEL_5_1 = 13,
    STD_VIDEO_AV1_LEVEL_5_2 = 14,
    STD_VIDEO_AV1_LEVEL_5_3 = 15,
    STD_VIDEO_AV1_LEVEL_6_0 = 16,
    STD_VIDEO_AV1_LEVEL_6_1 = 17,
    STD_VIDEO_AV1_LEVEL_6_2 = 18,
    STD_VIDEO_AV1_LEVEL_6_3 = 19,
    STD_VIDEO_AV1_LEVEL_7_0 = 20,
    STD_VIDEO_AV1_LEVEL_7_1 = 21,
    STD_VIDEO_AV1_LEVEL_7_2 = 22,
    STD_VIDEO_AV1_LEVEL_7_3 = 23,
    STD_VIDEO_AV1_LEVEL_INVALID = 0x7FFFFFFF;

alias StdVideoAV1FrameType = uint;
enum StdVideoAV1FrameType
    STD_VIDEO_AV1_FRAME_TYPE_KEY = 0,
    STD_VIDEO_AV1_FRAME_TYPE_INTER = 1,
    STD_VIDEO_AV1_FRAME_TYPE_INTRA_ONLY = 2,
    STD_VIDEO_AV1_FRAME_TYPE_SWITCH = 3,
    STD_VIDEO_AV1_FRAME_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoAV1ReferenceName = uint;
enum StdVideoAV1ReferenceName
    STD_VIDEO_AV1_REFERENCE_NAME_INTRA_FRAME = 0,
    STD_VIDEO_AV1_REFERENCE_NAME_LAST_FRAME = 1,
    STD_VIDEO_AV1_REFERENCE_NAME_LAST2_FRAME = 2,
    STD_VIDEO_AV1_REFERENCE_NAME_LAST3_FRAME = 3,
    STD_VIDEO_AV1_REFERENCE_NAME_GOLDEN_FRAME = 4,
    STD_VIDEO_AV1_REFERENCE_NAME_BWDREF_FRAME = 5,
    STD_VIDEO_AV1_REFERENCE_NAME_ALTREF2_FRAME = 6,
    STD_VIDEO_AV1_REFERENCE_NAME_ALTREF_FRAME = 7,
    STD_VIDEO_AV1_REFERENCE_NAME_INVALID = 0x7FFFFFFF;

alias StdVideoAV1InterpolationFilter = uint;
enum StdVideoAV1InterpolationFilter
    STD_VIDEO_AV1_INTERPOLATION_FILTER_EIGHTTAP = 0,
    STD_VIDEO_AV1_INTERPOLATION_FILTER_EIGHTTAP_SMOOTH = 1,
    STD_VIDEO_AV1_INTERPOLATION_FILTER_EIGHTTAP_SHARP = 2,
    STD_VIDEO_AV1_INTERPOLATION_FILTER_BILINEAR = 3,
    STD_VIDEO_AV1_INTERPOLATION_FILTER_SWITCHABLE = 4,
    STD_VIDEO_AV1_INTERPOLATION_FILTER_INVALID = 0x7FFFFFFF;

alias StdVideoAV1TxMode = uint;
enum StdVideoAV1TxMode
    STD_VIDEO_AV1_TX_MODE_ONLY_4X4 = 0,
    STD_VIDEO_AV1_TX_MODE_LARGEST = 1,
    STD_VIDEO_AV1_TX_MODE_SELECT = 2,
    STD_VIDEO_AV1_TX_MODE_INVALID = 0x7FFFFFFF;

alias StdVideoAV1FrameRestorationType = uint;
enum StdVideoAV1FrameRestorationType
    STD_VIDEO_AV1_FRAME_RESTORATION_TYPE_NONE = 0,
    STD_VIDEO_AV1_FRAME_RESTORATION_TYPE_WIENER = 1,
    STD_VIDEO_AV1_FRAME_RESTORATION_TYPE_SGRPROJ = 2,
    STD_VIDEO_AV1_FRAME_RESTORATION_TYPE_SWITCHABLE = 3,
    STD_VIDEO_AV1_FRAME_RESTORATION_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoAV1ColorPrimaries = uint;
enum StdVideoAV1ColorPrimaries
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_709 = 1,
    STD_VIDEO_AV1_COLOR_PRIMARIES_UNSPECIFIED = 2,
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_UNSPECIFIED = STD_VIDEO_AV1_COLOR_PRIMARIES_UNSPECIFIED,
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_470_M = 4,
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_470_B_G = 5,
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_601 = 6,
    STD_VIDEO_AV1_COLOR_PRIMARIES_SMPTE_240 = 7,
    STD_VIDEO_AV1_COLOR_PRIMARIES_GENERIC_FILM = 8,
    STD_VIDEO_AV1_COLOR_PRIMARIES_BT_2020 = 9,
    STD_VIDEO_AV1_COLOR_PRIMARIES_XYZ = 10,
    STD_VIDEO_AV1_COLOR_PRIMARIES_SMPTE_431 = 11,
    STD_VIDEO_AV1_COLOR_PRIMARIES_SMPTE_432 = 12,
    STD_VIDEO_AV1_COLOR_PRIMARIES_EBU_3213 = 22,
    STD_VIDEO_AV1_COLOR_PRIMARIES_INVALID = 0x7FFFFFFF;

alias StdVideoAV1TransferCharacteristics = uint;
enum StdVideoAV1TransferCharacteristics
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_RESERVED_0 = 0,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_709 = 1,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_UNSPECIFIED = 2,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_RESERVED_3 = 3,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_470_M = 4,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_470_B_G = 5,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_601 = 6,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_SMPTE_240 = 7,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_LINEAR = 8,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_LOG_100 = 9,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_LOG_100_SQRT10 = 10,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_IEC_61966 = 11,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_1361 = 12,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_SRGB = 13,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_2020_10_BIT = 14,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_BT_2020_12_BIT = 15,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_SMPTE_2084 = 16,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_SMPTE_428 = 17,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_HLG = 18,
    STD_VIDEO_AV1_TRANSFER_CHARACTERISTICS_INVALID = 0x7FFFFFFF;

alias StdVideoAV1MatrixCoefficients = uint;
enum StdVideoAV1MatrixCoefficients
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_IDENTITY = 0,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_BT_709 = 1,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_UNSPECIFIED = 2,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_RESERVED_3 = 3,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_FCC = 4,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_BT_470_B_G = 5,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_BT_601 = 6,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_SMPTE_240 = 7,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_SMPTE_YCGCO = 8,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_BT_2020_NCL = 9,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_BT_2020_CL = 10,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_SMPTE_2085 = 11,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_CHROMAT_NCL = 12,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_CHROMAT_CL = 13,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_ICTCP = 14,
    STD_VIDEO_AV1_MATRIX_COEFFICIENTS_INVALID = 0x7FFFFFFF;

alias StdVideoAV1ChromaSamplePosition = uint;
enum StdVideoAV1ChromaSamplePosition
    STD_VIDEO_AV1_CHROMA_SAMPLE_POSITION_UNKNOWN = 0,
    STD_VIDEO_AV1_CHROMA_SAMPLE_POSITION_VERTICAL = 1,
    STD_VIDEO_AV1_CHROMA_SAMPLE_POSITION_COLOCATED = 2,
    STD_VIDEO_AV1_CHROMA_SAMPLE_POSITION_RESERVED = 3,
    STD_VIDEO_AV1_CHROMA_SAMPLE_POSITION_INVALID = 0x7FFFFFFF;

struct StdVideoAV1ColorConfigFlags {
    uint mono_chrome:1;
    uint color_range:1;
    uint separate_uv_delta_q:1;
    uint color_description_present_flag:1;
    uint reserved:28;
    mixin DMD20473;
}

struct StdVideoAV1ColorConfig {
    StdVideoAV1ColorConfigFlags flags;
    ubyte BitDepth;
    ubyte subsampling_x;
    ubyte subsampling_y;
    ubyte reserved1;
    StdVideoAV1ColorPrimaries color_primaries;
    StdVideoAV1TransferCharacteristics transfer_characteristics;
    StdVideoAV1MatrixCoefficients matrix_coefficients;
    StdVideoAV1ChromaSamplePosition chroma_sample_position;
}

struct StdVideoAV1TimingInfoFlags {
    uint equal_picture_interval:1;
    uint reserved:31;
    mixin DMD20473;
}

struct StdVideoAV1TimingInfo {
    StdVideoAV1TimingInfoFlags flags;
    uint num_units_in_display_tick;
    uint time_scale;
    uint num_ticks_per_picture_minus_1;
}

struct StdVideoAV1LoopFilterFlags {
    uint loop_filter_delta_enabled:1;
    uint loop_filter_delta_update:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoAV1LoopFilter {
    StdVideoAV1LoopFilterFlags flags;
    ubyte[STD_VIDEO_AV1_MAX_LOOP_FILTER_STRENGTHS] loop_filter_level;
    ubyte loop_filter_sharpness;
    ubyte update_ref_delta;
    byte[STD_VIDEO_AV1_TOTAL_REFS_PER_FRAME] loop_filter_ref_deltas;
    ubyte update_mode_delta;
    byte[STD_VIDEO_AV1_LOOP_FILTER_ADJUSTMENTS] loop_filter_mode_deltas;
}

struct StdVideoAV1QuantizationFlags {
    uint using_qmatrix:1;
    uint diff_uv_delta:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoAV1Quantization {
    StdVideoAV1QuantizationFlags flags;
    ubyte base_q_idx;
    byte DeltaQYDc;
    byte DeltaQUDc;
    byte DeltaQUAc;
    byte DeltaQVDc;
    byte DeltaQVAc;
    ubyte qm_y;
    ubyte qm_u;
    ubyte qm_v;
}

struct StdVideoAV1Segmentation {
    ubyte[STD_VIDEO_AV1_MAX_SEGMENTS] FeatureEnabled;
    short[STD_VIDEO_AV1_MAX_SEGMENTS][STD_VIDEO_AV1_SEG_LVL_MAX] FeatureData;
}

struct StdVideoAV1TileInfoFlags {
    uint uniform_tile_spacing_flag:1;
    uint reserved:31;
    mixin DMD20473;
}

struct StdVideoAV1TileInfo {
    StdVideoAV1TileInfoFlags flags;
    ubyte TileCols;
    ubyte TileRows;
    ushort context_update_tile_id;
    ubyte tile_size_bytes_minus_1;
    ubyte[7] reserved1;
    const(ushort)* pMiColStarts;
    const(ushort)* pMiRowStarts;
    const(ushort)* pWidthInSbsMinus1;
    const(ushort)* pHeightInSbsMinus1;
}

struct StdVideoAV1CDEF {
    ubyte cdef_damping_minus_3;
    ubyte cdef_bits;
    ubyte[STD_VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_y_pri_strength;
    ubyte[STD_VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_y_sec_strength;
    ubyte[STD_VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_uv_pri_strength;
    ubyte[STD_VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_uv_sec_strength;
}

struct StdVideoAV1LoopRestoration {
    StdVideoAV1FrameRestorationType[STD_VIDEO_AV1_MAX_NUM_PLANES] FrameRestorationType;
    ushort[STD_VIDEO_AV1_MAX_NUM_PLANES] LoopRestorationSize;
}

struct StdVideoAV1GlobalMotion {
    ubyte[STD_VIDEO_AV1_NUM_REF_FRAMES] GmType;
    int[STD_VIDEO_AV1_NUM_REF_FRAMES][STD_VIDEO_AV1_GLOBAL_MOTION_PARAMS] gm_params;
}

struct StdVideoAV1FilmGrainFlags {
    uint chroma_scaling_from_luma:1;
    uint overlap_flag:1;
    uint clip_to_restricted_range:1;
    uint update_grain:1;
    uint reserved:28;
    mixin DMD20473;
}

struct StdVideoAV1FilmGrain {
    StdVideoAV1FilmGrainFlags flags;
    ubyte grain_scaling_minus_8;
    ubyte ar_coeff_lag;
    ubyte ar_coeff_shift_minus_6;
    ubyte grain_scale_shift;
    ushort grain_seed;
    ubyte film_grain_params_ref_idx;
    ubyte num_y_points;
    ubyte[STD_VIDEO_AV1_MAX_NUM_Y_POINTS] point_y_value;
    ubyte[STD_VIDEO_AV1_MAX_NUM_Y_POINTS] point_y_scaling;
    ubyte num_cb_points;
    ubyte[STD_VIDEO_AV1_MAX_NUM_CB_POINTS] point_cb_value;
    ubyte[STD_VIDEO_AV1_MAX_NUM_CB_POINTS] point_cb_scaling;
    ubyte num_cr_points;
    ubyte[STD_VIDEO_AV1_MAX_NUM_CR_POINTS] point_cr_value;
    ubyte[STD_VIDEO_AV1_MAX_NUM_CR_POINTS] point_cr_scaling;
    byte[STD_VIDEO_AV1_MAX_NUM_POS_LUMA] ar_coeffs_y_plus_128;
    byte[STD_VIDEO_AV1_MAX_NUM_POS_CHROMA] ar_coeffs_cb_plus_128;
    byte[STD_VIDEO_AV1_MAX_NUM_POS_CHROMA] ar_coeffs_cr_plus_128;
    ubyte cb_mult;
    ubyte cb_luma_mult;
    ushort cb_offset;
    ubyte cr_mult;
    ubyte cr_luma_mult;
    ushort cr_offset;
}

struct StdVideoAV1SequenceHeaderFlags {
    uint still_picture:1;
    uint reduced_still_picture_header:1;
    uint use_128x128_superblock:1;
    uint enable_filter_intra:1;
    uint enable_intra_edge_filter:1;
    uint enable_interintra_compound:1;
    uint enable_masked_compound:1;
    uint enable_warped_motion:1;
    uint enable_dual_filter:1;
    uint enable_order_hint:1;
    uint enable_jnt_comp:1;
    uint enable_ref_frame_mvs:1;
    uint frame_id_numbers_present_flag:1;
    uint enable_superres:1;
    uint enable_cdef:1;
    uint enable_restoration:1;
    uint film_grain_params_present:1;
    uint timing_info_present_flag:1;
    uint initial_display_delay_present_flag:1;
    uint reserved:13;
    mixin DMD20473;
}

struct StdVideoAV1SequenceHeader {
    StdVideoAV1SequenceHeaderFlags flags;
    StdVideoAV1Profile seq_profile;
    ubyte frame_width_bits_minus_1;
    ubyte frame_height_bits_minus_1;
    ushort max_frame_width_minus_1;
    ushort max_frame_height_minus_1;
    ubyte delta_frame_id_length_minus_2;
    ubyte additional_frame_id_length_minus_1;
    ubyte order_hint_bits_minus_1;
    ubyte seq_force_integer_mv;
    ubyte seq_force_screen_content_tools;
    ubyte[5] reserved1;
    const(StdVideoAV1ColorConfig)* pColorConfig;
    const(StdVideoAV1TimingInfo)* pTimingInfo;
}
