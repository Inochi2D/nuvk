/**
 * vulkan_video_codec_vp9std_decode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.vp9std_decode;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.vp9std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_vp9_decode";


enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoDecodeVP9PictureInfoFlags {
    uint error_resilient_mode:1;
    uint intra_only:1;
    uint allow_high_precision_mv:1;
    uint refresh_frame_context:1;
    uint frame_parallel_decoding_mode:1;
    uint segmentation_enabled:1;
    uint show_frame:1;
    uint UsePrevFrameMvs:1;
    uint reserved:24;
    mixin DMD20473;
}

struct StdVideoDecodeVP9PictureInfo {
    StdVideoDecodeVP9PictureInfoFlags flags;
    StdVideoVP9Profile profile;
    StdVideoVP9FrameType frame_type;
    ubyte frame_context_idx;
    ubyte reset_frame_context;
    ubyte refresh_frame_flags;
    ubyte ref_frame_sign_bias_mask;
    StdVideoVP9InterpolationFilter interpolation_filter;
    ubyte base_q_idx;
    byte delta_q_y_dc;
    byte delta_q_uv_dc;
    byte delta_q_uv_ac;
    ubyte tile_cols_log2;
    ubyte tile_rows_log2;
    ushort[3] reserved1;
    const(StdVideoVP9ColorConfig)* pColorConfig;
    const(StdVideoVP9LoopFilter)* pLoopFilter;
    const(StdVideoVP9Segmentation)* pSegmentation;
}
