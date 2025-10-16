/**
 * vulkan_video_codec_h265std_decode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h265std_decode;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.h265std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_H265_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H265_DECODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_H265_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h265_decode";
enum STD_VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE = 8;


enum VK_STD_VULKAN_VIDEO_CODEC_H265_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoDecodeH265PictureInfoFlags {
    uint IrapPicFlag:1;
    uint IdrPicFlag:1;
    uint IsReference:1;
    uint short_term_ref_pic_set_sps_flag:1;
    mixin DMD20473;
}

struct StdVideoDecodeH265PictureInfo {
    StdVideoDecodeH265PictureInfoFlags flags;
    ubyte sps_video_parameter_set_id;
    ubyte pps_seq_parameter_set_id;
    ubyte pps_pic_parameter_set_id;
    ubyte NumDeltaPocsOfRefRpsIdx;
    int PicOrderCntVal;
    ushort NumBitsForSTRefPicSetInSlice;
    ushort reserved;
    ubyte[STD_VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] RefPicSetStCurrBefore;
    ubyte[STD_VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] RefPicSetStCurrAfter;
    ubyte[STD_VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] RefPicSetLtCurr;
}

struct StdVideoDecodeH265ReferenceInfoFlags {
    uint used_for_long_term_reference:1;
    uint unused_for_reference:1;
    mixin DMD20473;
}

struct StdVideoDecodeH265ReferenceInfo {
    StdVideoDecodeH265ReferenceInfoFlags flags;
    int PicOrderCntVal;
}
