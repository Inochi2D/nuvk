/**
 * vulkan_video_codec_av1std_decode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.av1std_decode;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.av1std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_AV1_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_AV1_DECODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_AV1_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_av1_decode";


enum VK_STD_VULKAN_VIDEO_CODEC_AV1_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoDecodeAV1PictureInfoFlags {
    uint error_resilient_mode:1;
    uint disable_cdf_update:1;
    uint use_superres:1;
    uint render_and_frame_size_different:1;
    uint allow_screen_content_tools:1;
    uint is_filter_switchable:1;
    uint force_integer_mv:1;
    uint frame_size_override_flag:1;
    uint buffer_removal_time_present_flag:1;
    uint allow_intrabc:1;
    uint frame_refs_short_signaling:1;
    uint allow_high_precision_mv:1;
    uint is_motion_mode_switchable:1;
    uint use_ref_frame_mvs:1;
    uint disable_frame_end_update_cdf:1;
    uint allow_warped_motion:1;
    uint reduced_tx_set:1;
    uint reference_select:1;
    uint skip_mode_present:1;
    uint delta_q_present:1;
    uint delta_lf_present:1;
    uint delta_lf_multi:1;
    uint segmentation_enabled:1;
    uint segmentation_update_map:1;
    uint segmentation_temporal_update:1;
    uint segmentation_update_data:1;
    uint UsesLr:1;
    uint usesChromaLr:1;
    uint apply_grain:1;
    uint reserved:3;
    mixin DMD20473;
}

import vulkan.video.av1std : StdVideoAV1FrameType, StdVideoAV1InterpolationFilter, StdVideoAV1TxMode, StdVideoAV1TileInfo, StdVideoAV1Quantization, StdVideoAV1Segmentation, StdVideoAV1LoopFilter, StdVideoAV1CDEF, StdVideoAV1LoopRestoration, StdVideoAV1GlobalMotion, StdVideoAV1FilmGrain;
struct StdVideoDecodeAV1PictureInfo {
    StdVideoDecodeAV1PictureInfoFlags flags;
    StdVideoAV1FrameType frame_type;
    uint current_frame_id;
    ubyte OrderHint;
    ubyte primary_ref_frame;
    ubyte refresh_frame_flags;
    ubyte reserved1;
    StdVideoAV1InterpolationFilter interpolation_filter;
    StdVideoAV1TxMode TxMode;
    ubyte delta_q_res;
    ubyte delta_lf_res;
    ubyte[STD_VIDEO_AV1_SKIP_MODE_FRAMES] SkipModeFrame;
    ubyte coded_denom;
    ubyte[3] reserved2;
    ubyte[STD_VIDEO_AV1_NUM_REF_FRAMES] OrderHints;
    uint[STD_VIDEO_AV1_NUM_REF_FRAMES] expectedFrameId;
    const(StdVideoAV1TileInfo)* pTileInfo;
    const(StdVideoAV1Quantization)* pQuantization;
    const(StdVideoAV1Segmentation)* pSegmentation;
    const(StdVideoAV1LoopFilter)* pLoopFilter;
    const(StdVideoAV1CDEF)* pCDEF;
    const(StdVideoAV1LoopRestoration)* pLoopRestoration;
    const(StdVideoAV1GlobalMotion)* pGlobalMotion;
    const(StdVideoAV1FilmGrain)* pFilmGrain;
}

struct StdVideoDecodeAV1ReferenceInfoFlags {
    uint disable_frame_end_update_cdf:1;
    uint segmentation_enabled:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoDecodeAV1ReferenceInfo {
    StdVideoDecodeAV1ReferenceInfoFlags flags;
    ubyte frame_type;
    ubyte RefFrameSignBias;
    ubyte OrderHint;
    ubyte[STD_VIDEO_AV1_NUM_REF_FRAMES] SavedOrderHints;
}
