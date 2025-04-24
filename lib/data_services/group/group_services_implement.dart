import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/group/group_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/optimize_utils.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_callback.dart';

class TCustomerGroupServicesImpl extends TCustomerGroupServices {
  static List<Function?> groupInfoCallBackList = [];
  final TCustomerCoreServicesImpl _coreService = serviceLocator<TCustomerCoreServicesImpl>();
  final throttleGetGroupInfo = OptimizeUtils.throttle((val) async {
    String groupID = val["groupID"];
    List<String> memberList = val["memberList"];
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMembersInfo(groupID: groupID, memberList: memberList);
    emitGroupCbList(res.data ?? []);
    clearGroupCbList();
  }, 1000);

  static emitGroupCbList(List<V2TimGroupMemberFullInfo?> list) {
    for (var cb in groupInfoCallBackList) {
      cb!(list);
    }
  }

  static clearGroupCbList() {
    groupInfoCallBackList = [];
  }

  @override
  Future<List<V2TimGroupInfoResult>?> getGroupsInfo({
    required List<String> groupIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupsInfo(groupIDList: groupIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorMsg: res.desc,
          errorCode: res.code));
      return null;
    }
  }

  @override
  Future<V2TimValueCallback<V2TimGroupMemberInfoResult>> getGroupMemberList({
    required String groupID,
    required GroupMemberFilterTypeEnum filter,
    required String nextSeq,
    int count = 15,
    int offset = 0,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMemberList(
            groupID: groupID,
            filter: filter,
            nextSeq: nextSeq,
            count: count,
            offset: offset);
    if (res.code != 0) {
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorMsg: res.desc,
          errorCode: res.code));
    }
    return res;
  }

  @override
  Future<void> addGroupListener({
    required V2TimGroupListener listener,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .addGroupListener(listener: listener);
    return result;
  }

  @override
  Future<void> removeGroupListener({
    V2TimGroupListener? listener,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .removeGroupListener(listener: listener);
    return result;
  }
}
