/**
 * vulkan_video_codec_h265std_encode
 * 
 * Author: 
 * 
 * Copyright:
 *     Copyright © 2015-2025, The Khronos Group Inc.
 * 
 * License: $(LINK2 https://www.apache.org/licenses/LICENSE-2.0, Apache-2.0)
 */
module vulkan.video.h265std_encode;

import numem.core.types : OpaqueHandle;
import vulkan.patches;
import vulkan.loader;
import vulkan.video.common;
import vulkan.video.h265std;

extern (System) @nogc nothrow:

enum VK_STD_VULKAN_VIDEO_CODEC_H265_ENCODE_SPEC_VERSION = VK_STD_VULKAN_VIDEO_CODEC_H265_ENCODE_API_VERSION_1_0_0;
enum VK_STD_VULKAN_VIDEO_CODEC_H265_ENCODE_EXTENSION_NAME = "VK_STD_vulkan_video_codec_h265_encode";


enum VK_STD_VULKAN_VIDEO_CODEC_H265_ENCODE_API_VERSION_1_0_0 = VK_MAKE_VIDEO_STD_VERSION(1, 0, 0);

struct StdVideoEncodeH265WeightTableFlags {
    ushort luma_weight_l0_flag;
    ushort chroma_weight_l0_flag;
    ushort luma_weight_l1_flag;
    ushort chroma_weight_l1_flag;
}

struct StdVideoEncodeH265WeightTable {
    StdVideoEncodeH265WeightTableFlags flags;
    ubyte luma_log2_weight_denom;
    byte delta_chroma_log2_weight_denom;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF] delta_luma_weight_l0;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF] luma_offset_l0;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF][STD_VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_weight_l0;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF][STD_VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_offset_l0;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF] delta_luma_weight_l1;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF] luma_offset_l1;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF][STD_VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_weight_l1;
    byte[STD_VIDEO_H265_MAX_NUM_LIST_REF][STD_VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_offset_l1;
}

struct StdVideoEncodeH265SliceSegmentHeaderFlags {
    uint first_slice_segment_in_pic_flag:1;
    uint dependent_slice_segment_flag:1;
    uint slice_sao_luma_flag:1;
    uint slice_sao_chroma_flag:1;
    uint num_ref_idx_active_override_flag:1;
    uint mvd_l1_zero_flag:1;
    uint cabac_init_flag:1;
    uint cu_chroma_qp_offset_enabled_flag:1;
    uint deblocking_filter_override_flag:1;
    uint slice_deblocking_filter_disabled_flag:1;
    uint collocated_from_l0_flag:1;
    uint slice_loop_filter_across_slices_enabled_flag:1;
    uint reserved:20;
    mixin DMD20473;
}

struct StdVideoEncodeH265SliceSegmentHeader {
    StdVideoEncodeH265SliceSegmentHeaderFlags flags;
    StdVideoH265SliceType slice_type;
    uint slice_segment_address;
    ubyte collocated_ref_idx;
    ubyte MaxNumMergeCand;
    byte slice_cb_qp_offset;
    byte slice_cr_qp_offset;
    byte slice_beta_offset_div2;
    byte slice_tc_offset_div2;
    byte slice_act_y_qp_offset;
    byte slice_act_cb_qp_offset;
    byte slice_act_cr_qp_offset;
    byte slice_qp_delta;
    ushort reserved1;
    const(StdVideoEncodeH265WeightTable)* pWeightTable;
}

struct StdVideoEncodeH265ReferenceListsInfoFlags {
    uint ref_pic_list_modification_flag_l0:1;
    uint ref_pic_list_modification_flag_l1:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoEncodeH265ReferenceListsInfo {
    StdVideoEncodeH265ReferenceListsInfoFlags flags;
    ubyte num_ref_idx_l0_active_minus1;
    ubyte num_ref_idx_l1_active_minus1;
    ubyte[STD_VIDEO_H265_MAX_NUM_LIST_REF] RefPicList0;
    ubyte[STD_VIDEO_H265_MAX_NUM_LIST_REF] RefPicList1;
    ubyte[STD_VIDEO_H265_MAX_NUM_LIST_REF] list_entry_l0;
    ubyte[STD_VIDEO_H265_MAX_NUM_LIST_REF] list_entry_l1;
}

struct StdVideoEncodeH265PictureInfoFlags {
    uint is_reference:1;
    uint IrapPicFlag:1;
    uint used_for_long_term_reference:1;
    uint discardable_flag:1;
    uint cross_layer_bla_flag:1;
    uint pic_output_flag:1;
    uint no_output_of_prior_pics_flag:1;
    uint short_term_ref_pic_set_sps_flag:1;
    uint slice_temporal_mvp_enabled_flag:1;
    uint reserved:23;
    mixin DMD20473;
}

struct StdVideoEncodeH265LongTermRefPics {
    ubyte num_long_term_sps;
    ubyte num_long_term_pics;
    ubyte[STD_VIDEO_H265_MAX_LONG_TERM_REF_PICS_SPS] lt_idx_sps;
    ubyte[STD_VIDEO_H265_MAX_LONG_TERM_PICS] poc_lsb_lt;
    ushort used_by_curr_pic_lt_flag;
    ubyte[STD_VIDEO_H265_MAX_DELTA_POC] delta_poc_msb_present_flag;
    ubyte[STD_VIDEO_H265_MAX_DELTA_POC] delta_poc_msb_cycle_lt;
}

struct StdVideoEncodeH265PictureInfo {
    StdVideoEncodeH265PictureInfoFlags flags;
    StdVideoH265PictureType pic_type;
    ubyte sps_video_parameter_set_id;
    ubyte pps_seq_parameter_set_id;
    ubyte pps_pic_parameter_set_id;
    ubyte short_term_ref_pic_set_idx;
    int PicOrderCntVal;
    ubyte TemporalId;
    ubyte[7] reserved1;
    const(StdVideoEncodeH265ReferenceListsInfo)* pRefLists;
    const(StdVideoH265ShortTermRefPicSet)* pShortTermRefPicSet;
    const(StdVideoEncodeH265LongTermRefPics)* pLongTermRefPics;
}

struct StdVideoEncodeH265ReferenceInfoFlags {
    uint used_for_long_term_reference:1;
    uint unused_for_reference:1;
    uint reserved:30;
    mixin DMD20473;
}

struct StdVideoEncodeH265ReferenceInfo {
    StdVideoEncodeH265ReferenceInfoFlags flags;
    StdVideoH265PictureType pic_type;
    int PicOrderCntVal;
    ubyte TemporalId;
}
