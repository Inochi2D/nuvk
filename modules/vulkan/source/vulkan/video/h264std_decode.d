/**
 * vulkan_video_codec_h264std_decode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h264std_decode;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.h264std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h264_decode";
enum STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE = 2;


enum VK_STD_VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

enum StdVideoDecodeH264FieldOrderCount {
    TOP = 0,
    BOTTOM = 1,
    INVALID = 0x7FFFFFFF,
}

enum STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_TOP = StdVideoDecodeH264FieldOrderCount.TOP;
enum STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_BOTTOM = StdVideoDecodeH264FieldOrderCount.BOTTOM;
enum STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_INVALID = StdVideoDecodeH264FieldOrderCount.INVALID;

struct StdVideoDecodeH264PictureInfoFlags {
    uint field_pic_flag;
    uint is_intra;
    uint IdrPicFlag;
    uint bottom_field_flag;
    uint is_reference;
    uint complementary_field_pair;
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
    uint top_field_flag;
    uint bottom_field_flag;
    uint used_for_long_term_reference;
    uint is_non_existing;
}

struct StdVideoDecodeH264ReferenceInfo {
    StdVideoDecodeH264ReferenceInfoFlags flags;
    ushort FrameNum;
    ushort reserved;
    int[STD_VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE] PicOrderCnt;
}
