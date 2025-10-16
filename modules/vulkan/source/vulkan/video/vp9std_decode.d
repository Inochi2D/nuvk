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
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.vp9std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_vp9_decode";


enum VK_STD_VULKAN_VIDEO_CODEC_VP9_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoDecodeVP9PictureInfoFlags {
    uint error_resilient_mode;
    uint intra_only;
    uint allow_high_precision_mv;
    uint refresh_frame_context;
    uint frame_parallel_decoding_mode;
    uint segmentation_enabled;
    uint show_frame;
    uint UsePrevFrameMvs;
    uint reserved;
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
    ushort reserved1;
    const(StdVideoVP9ColorConfig)* pColorConfig;
    const(StdVideoVP9LoopFilter)* pLoopFilter;
    const(StdVideoVP9Segmentation)* pSegmentation;
}
