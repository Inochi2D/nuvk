/**
 * vulkan_video_codec_av1std_encode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.av1std_encode;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.av1std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_AV1_ENCODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_AV1_ENCODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_AV1_ENCODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_av1_encode";


enum VK_STD_VULKAN_VIDEO_CODEC_AV1_ENCODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoEncodeAV1DecoderModelInfo {
    ubyte buffer_delay_length_minus_1;
    ubyte buffer_removal_time_length_minus_1;
    ubyte frame_presentation_time_length_minus_1;
    ubyte reserved1;
    uint num_units_in_decoding_tick;
}

struct StdVideoEncodeAV1ExtensionHeader {
    ubyte temporal_id;
    ubyte spatial_id;
}

struct StdVideoEncodeAV1OperatingPointInfoFlags {
    uint decoder_model_present_for_this_op;
    uint low_delay_mode_flag;
    uint initial_display_delay_present_for_this_op;
    uint reserved;
}

struct StdVideoEncodeAV1OperatingPointInfo {
    StdVideoEncodeAV1OperatingPointInfoFlags flags;
    ushort operating_point_idc;
    ubyte seq_level_idx;
    ubyte seq_tier;
    uint decoder_buffer_delay;
    uint encoder_buffer_delay;
    ubyte initial_display_delay_minus_1;
}

struct StdVideoEncodeAV1PictureInfoFlags {
    uint error_resilient_mode;
    uint disable_cdf_update;
    uint use_superres;
    uint render_and_frame_size_different;
    uint allow_screen_content_tools;
    uint is_filter_switchable;
    uint force_integer_mv;
    uint frame_size_override_flag;
    uint buffer_removal_time_present_flag;
    uint allow_intrabc;
    uint frame_refs_short_signaling;
    uint allow_high_precision_mv;
    uint is_motion_mode_switchable;
    uint use_ref_frame_mvs;
    uint disable_frame_end_update_cdf;
    uint allow_warped_motion;
    uint reduced_tx_set;
    uint skip_mode_present;
    uint delta_q_present;
    uint delta_lf_present;
    uint delta_lf_multi;
    uint segmentation_enabled;
    uint segmentation_update_map;
    uint segmentation_temporal_update;
    uint segmentation_update_data;
    uint UsesLr;
    uint usesChromaLr;
    uint show_frame;
    uint showable_frame;
    uint reserved;
}

struct StdVideoEncodeAV1PictureInfo {
    StdVideoEncodeAV1PictureInfoFlags flags;
    StdVideoAV1FrameType frame_type;
    uint frame_presentation_time;
    uint current_frame_id;
    ubyte order_hint;
    ubyte primary_ref_frame;
    ubyte refresh_frame_flags;
    ubyte coded_denom;
    ushort render_width_minus_1;
    ushort render_height_minus_1;
    StdVideoAV1InterpolationFilter interpolation_filter;
    StdVideoAV1TxMode TxMode;
    ubyte delta_q_res;
    ubyte delta_lf_res;
    ubyte[STD_VIDEO_AV1_NUM_REF_FRAMES] ref_order_hint;
    byte[STD_VIDEO_AV1_REFS_PER_FRAME] ref_frame_idx;
    ubyte reserved1;
    uint[STD_VIDEO_AV1_REFS_PER_FRAME] delta_frame_id_minus_1;
    const(StdVideoAV1TileInfo)* pTileInfo;
    const(StdVideoAV1Quantization)* pQuantization;
    const(StdVideoAV1Segmentation)* pSegmentation;
    const(StdVideoAV1LoopFilter)* pLoopFilter;
    const(StdVideoAV1CDEF)* pCDEF;
    const(StdVideoAV1LoopRestoration)* pLoopRestoration;
    const(StdVideoAV1GlobalMotion)* pGlobalMotion;
    const(StdVideoEncodeAV1ExtensionHeader)* pExtensionHeader;
    const(uint)* pBufferRemovalTimes;
}

struct StdVideoEncodeAV1ReferenceInfoFlags {
    uint disable_frame_end_update_cdf;
    uint segmentation_enabled;
    uint reserved;
}

struct StdVideoEncodeAV1ReferenceInfo {
    StdVideoEncodeAV1ReferenceInfoFlags flags;
    uint RefFrameId;
    StdVideoAV1FrameType frame_type;
    ubyte OrderHint;
    ubyte reserved1;
    const(StdVideoEncodeAV1ExtensionHeader)* pExtensionHeader;
}
