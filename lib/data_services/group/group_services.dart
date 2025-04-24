import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';

abstract class TCustomerGroupServices {
  Future<List<V2TimGroupInfoResult>?> getGroupsInfo({
    required List<String> groupIDList,
  });

  Future<V2TimValueCallback<V2TimGroupMemberInfoResult>> getGroupMemberList({
    required String groupID,
    required GroupMemberFilterTypeEnum filter,
    required String nextSeq,
    int count = 15,
    int offset = 0,
  });

  Future<void> addGroupListener({
    required V2TimGroupListener listener,
  });

  Future<void> removeGroupListener({
    V2TimGroupListener? listener,
  });
}
