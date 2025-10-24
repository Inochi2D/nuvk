/**
 * vulkan_video_codec_vp9std
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.vp9std;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;

extern (System) @nogc nothrow:

enum STD_VIDEO_VP9_NUM_REF_FRAMES = 8;
enum STD_VIDEO_VP9_REFS_PER_FRAME = 3;
enum STD_VIDEO_VP9_MAX_REF_FRAMES = 4;
enum STD_VIDEO_VP9_LOOP_FILTER_ADJUSTMENTS = 2;
enum STD_VIDEO_VP9_MAX_SEGMENTS = 8;
enum STD_VIDEO_VP9_SEG_LVL_MAX = 4;
enum STD_VIDEO_VP9_MAX_SEGMENTATION_TREE_PROBS = 7;
enum STD_VIDEO_VP9_MAX_SEGMENTATION_PRED_PROB = 3;


alias StdVideoVP9Profile = uint;
enum StdVideoVP9Profile
    STD_VIDEO_VP9_PROFILE_0 = 0,
    STD_VIDEO_VP9_PROFILE_1 = 1,
    STD_VIDEO_VP9_PROFILE_2 = 2,
    STD_VIDEO_VP9_PROFILE_3 = 3,
    STD_VIDEO_VP9_PROFILE_INVALID = 0x7FFFFFFF;

alias StdVideoVP9Level = uint;
enum StdVideoVP9Level
    STD_VIDEO_VP9_LEVEL_1_0 = 0,
    STD_VIDEO_VP9_LEVEL_1_1 = 1,
    STD_VIDEO_VP9_LEVEL_2_0 = 2,
    STD_VIDEO_VP9_LEVEL_2_1 = 3,
    STD_VIDEO_VP9_LEVEL_3_0 = 4,
    STD_VIDEO_VP9_LEVEL_3_1 = 5,
    STD_VIDEO_VP9_LEVEL_4_0 = 6,
    STD_VIDEO_VP9_LEVEL_4_1 = 7,
    STD_VIDEO_VP9_LEVEL_5_0 = 8,
    STD_VIDEO_VP9_LEVEL_5_1 = 9,
    STD_VIDEO_VP9_LEVEL_5_2 = 10,
    STD_VIDEO_VP9_LEVEL_6_0 = 11,
    STD_VIDEO_VP9_LEVEL_6_1 = 12,
    STD_VIDEO_VP9_LEVEL_6_2 = 13,
    STD_VIDEO_VP9_LEVEL_INVALID = 0x7FFFFFFF;

alias StdVideoVP9FrameType = uint;
enum StdVideoVP9FrameType
    STD_VIDEO_VP9_FRAME_TYPE_KEY = 0,
    STD_VIDEO_VP9_FRAME_TYPE_NON_KEY = 1,
    STD_VIDEO_VP9_FRAME_TYPE_INVALID = 0x7FFFFFFF;

alias StdVideoVP9ReferenceName = uint;
enum StdVideoVP9ReferenceName
    STD_VIDEO_VP9_REFERENCE_NAME_INTRA_FRAME = 0,
    STD_VIDEO_VP9_REFERENCE_NAME_LAST_FRAME = 1,
    STD_VIDEO_VP9_REFERENCE_NAME_GOLDEN_FRAME = 2,
    STD_VIDEO_VP9_REFERENCE_NAME_ALTREF_FRAME = 3,
    STD_VIDEO_VP9_REFERENCE_NAME_INVALID = 0x7FFFFFFF;

alias StdVideoVP9InterpolationFilter = uint;
enum StdVideoVP9InterpolationFilter
    STD_VIDEO_VP9_INTERPOLATION_FILTER_EIGHTTAP = 0,
    STD_VIDEO_VP9_INTERPOLATION_FILTER_EIGHTTAP_SMOOTH = 1,
    STD_VIDEO_VP9_INTERPOLATION_FILTER_EIGHTTAP_SHARP = 2,
    STD_VIDEO_VP9_INTERPOLATION_FILTER_BILINEAR = 3,
    STD_VIDEO_VP9_INTERPOLATION_FILTER_SWITCHABLE = 4,
    STD_VIDEO_VP9_INTERPOLATION_FILTER_INVALID = 0x7FFFFFFF;

alias StdVideoVP9ColorSpace = uint;
enum StdVideoVP9ColorSpace
    STD_VIDEO_VP9_COLOR_SPACE_UNKNOWN = 0,
    STD_VIDEO_VP9_COLOR_SPACE_BT_601 = 1,
    STD_VIDEO_VP9_COLOR_SPACE_BT_709 = 2,
    STD_VIDEO_VP9_COLOR_SPACE_SMPTE_170 = 3,
    STD_VIDEO_VP9_COLOR_SPACE_SMPTE_240 = 4,
    STD_VIDEO_VP9_COLOR_SPACE_BT_2020 = 5,
    STD_VIDEO_VP9_COLOR_SPACE_RESERVED = 6,
    STD_VIDEO_VP9_COLOR_SPACE_RGB = 7,
    STD_VIDEO_VP9_COLOR_SPACE_INVALID = 0x7FFFFFFF;

struct StdVideoVP9ColorConfigFlags {
    uint color_range:1;
    uint reserved:31;
    mixin DMD20473;
}

struct StdVideoVP9ColorConfig {
    StdVideoVP9ColorConfigFlags flags;
    ubyte BitDepth;
    ubyte subsampling_x;
    ubyte subsampling_y;
    ubyte reserved1;
    StdVideoVP9ColorSpace color_space;
}

struct StdVideoVP9LoopFilterFlags {
    uint loop_filter_delta_enabled:1;
    uint loop_filter_delta_update:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoVP9LoopFilter {
    StdVideoVP9LoopFilterFlags flags;
    ubyte loop_filter_level;
    ubyte loop_filter_sharpness;
    ubyte update_ref_delta;
    byte[STD_VIDEO_VP9_MAX_REF_FRAMES] loop_filter_ref_deltas;
    ubyte update_mode_delta;
    byte[STD_VIDEO_VP9_LOOP_FILTER_ADJUSTMENTS] loop_filter_mode_deltas;
}

struct StdVideoVP9SegmentationFlags {
    uint segmentation_update_map:1;
    uint segmentation_temporal_update:1;
    uint segmentation_update_data:1;
    uint segmentation_abs_or_delta_update:1;
    uint reserved:28;
    mixin DMD20473;
}

struct StdVideoVP9Segmentation {
    StdVideoVP9SegmentationFlags flags;
    ubyte[STD_VIDEO_VP9_MAX_SEGMENTATION_TREE_PROBS] segmentation_tree_probs;
    ubyte[STD_VIDEO_VP9_MAX_SEGMENTATION_PRED_PROB] segmentation_pred_prob;
    ubyte[STD_VIDEO_VP9_MAX_SEGMENTS] FeatureEnabled;
    short[STD_VIDEO_VP9_MAX_SEGMENTS][STD_VIDEO_VP9_SEG_LVL_MAX] FeatureData;
}
