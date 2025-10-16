/**
 * vulkan_video_codec_h264std_encode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h264std_encode;

import numem.core.types : OpaqueHandle;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.h264std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h264_encode";


enum VK_STD_VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoEncodeH264WeightTableFlags {
    uint luma_weight_l0_flag;
    uint chroma_weight_l0_flag;
    uint luma_weight_l1_flag;
    uint chroma_weight_l1_flag;
}

struct StdVideoEncodeH264WeightTable {
    StdVideoEncodeH264WeightTableFlags flags;
    ubyte luma_log2_weight_denom;
    ubyte chroma_log2_weight_denom;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_weight_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_offset_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_weight_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_offset_l0;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_weight_l1;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] luma_offset_l1;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_weight_l1;
    byte[STD_VIDEO_H264_MAX_NUM_LIST_REF] chroma_offset_l1;
}

struct StdVideoEncodeH264SliceHeaderFlags {
    uint direct_spatial_mv_pred_flag;
    uint num_ref_idx_active_override_flag;
    uint reserved;
}

struct StdVideoEncodeH264PictureInfoFlags {
    uint IdrPicFlag;
    uint is_reference;
    uint no_output_of_prior_pics_flag;
    uint long_term_reference_flag;
    uint adaptive_ref_pic_marking_mode_flag;
    uint reserved;
}

struct StdVideoEncodeH264ReferenceInfoFlags {
    uint used_for_long_term_reference;
    uint reserved;
}

struct StdVideoEncodeH264ReferenceListsInfoFlags {
    uint ref_pic_list_modification_flag_l0;
    uint ref_pic_list_modification_flag_l1;
    uint reserved;
}

struct StdVideoEncodeH264RefListModEntry {
    StdVideoH264ModificationOfPicNumsIdc modification_of_pic_nums_idc;
    ushort abs_diff_pic_num_minus1;
    ushort long_term_pic_num;
}

struct StdVideoEncodeH264RefPicMarkingEntry {
    StdVideoH264MemMgmtControlOp memory_management_control_operation;
    ushort difference_of_pic_nums_minus1;
    ushort long_term_pic_num;
    ushort long_term_frame_idx;
    ushort max_long_term_frame_idx_plus1;
}

struct StdVideoEncodeH264ReferenceListsInfo {
    StdVideoEncodeH264ReferenceListsInfoFlags flags;
    ubyte num_ref_idx_l0_active_minus1;
    ubyte num_ref_idx_l1_active_minus1;
    ubyte RefPicList0;
    ubyte RefPicList1;
    ubyte refList0ModOpCount;
    ubyte refList1ModOpCount;
    ubyte refPicMarkingOpCount;
    ubyte reserved1;
    const(StdVideoEncodeH264RefListModEntry)* pRefList0ModOperations;
    const(StdVideoEncodeH264RefListModEntry)* pRefList1ModOperations;
    const(StdVideoEncodeH264RefPicMarkingEntry)* pRefPicMarkingOperations;
}

struct StdVideoEncodeH264PictureInfo {
    StdVideoEncodeH264PictureInfoFlags flags;
    ubyte seq_parameter_set_id;
    ubyte pic_parameter_set_id;
    ushort idr_pic_id;
    StdVideoH264PictureType primary_pic_type;
    uint frame_num;
    int PicOrderCnt;
    ubyte temporal_id;
    ubyte reserved1;
    const(StdVideoEncodeH264ReferenceListsInfo)* pRefLists;
}

struct StdVideoEncodeH264ReferenceInfo {
    StdVideoEncodeH264ReferenceInfoFlags flags;
    StdVideoH264PictureType primary_pic_type;
    uint FrameNum;
    int PicOrderCnt;
    ushort long_term_pic_num;
    ushort long_term_frame_idx;
    ubyte temporal_id;
}

struct StdVideoEncodeH264SliceHeader {
    StdVideoEncodeH264SliceHeaderFlags flags;
    uint first_mb_in_slice;
    StdVideoH264SliceType slice_type;
    byte slice_alpha_c0_offset_div2;
    byte slice_beta_offset_div2;
    byte slice_qp_delta;
    ubyte reserved1;
    StdVideoH264CabacInitIdc cabac_init_idc;
    StdVideoH264DisableDeblockingFilterIdc disable_deblocking_filter_idc;
    const(StdVideoEncodeH264WeightTable)* pWeightTable;
}
