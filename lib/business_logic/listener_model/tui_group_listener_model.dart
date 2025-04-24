// ignore_for_file: unnecessary_getters_setters


import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/group/group_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_change_info_type.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';

enum UpdateType { groupInfo, memberList, joinApplicationList, groupDismissed, kickedFromGroup }

class NeedUpdate {
  final String groupID;
  final UpdateType updateType;
  final String extraData;
  int? groupInfoSubType;
  String? ownerID;

  NeedUpdate(this.groupID, this.updateType, this.extraData);
}

class TCustomerGroupListenerModel extends ChangeNotifier {
  final TCustomerGroupServices _groupServices = serviceLocator<TCustomerGroupServices>();
  V2TimGroupListener? _groupListener;
  NeedUpdate? _needUpdate;
  final TCustomerChatGlobalModel chatViewModel = serviceLocator<TCustomerChatGlobalModel>();
  late TCustomerCoreServicesImpl coreInstance = TencentCloudAIDeskCustomer.getIMUIKitInstance();
  late V2TIMManager sdkInstance = TencentCloudAIDeskCustomer.getIMSDKInstance();

  NeedUpdate? get needUpdate => _needUpdate;

  set needUpdate(NeedUpdate? value) {
    Future.delayed(const Duration(seconds: 0), () {
      _needUpdate = value;
    });
  }

  TCustomerGroupListenerModel() {
    _groupListener = V2TimGroupListener(
      onMemberInvited: (groupID, opUser, memberList) {
        _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
        notifyListeners();
      },
      onMemberKicked: (groupID, opUser, memberList) async {
        if (_isLoginUserKickedFromGroup(groupID, memberList)) {
          _deleteGroupConversation(groupID);

          final groupName = await _getGroupName(groupID);
          _needUpdate = NeedUpdate(groupID, UpdateType.kickedFromGroup, groupName);
          notifyListeners();
        }
      },
      onMemberEnter: (String groupID, List<V2TimGroupMemberInfo> memberList) {
        _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
        notifyListeners();
      },
      onMemberLeave: (String groupID, V2TimGroupMemberInfo member) {
        _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
        notifyListeners();
      },
      onGroupInfoChanged: (groupID, changeInfos) {
        _needUpdate = NeedUpdate(groupID, UpdateType.groupInfo, "");
        for (V2TimGroupChangeInfo info in changeInfos) {
          if (info.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER) {
            _needUpdate!.groupInfoSubType = GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER;
            _needUpdate!.ownerID = info.value;
          }
        }
        notifyListeners();
      },
      onGroupDismissed: (String groupID, V2TimGroupMemberInfo opUser) async {
        _deleteGroupConversation(groupID);
        final groupName = await _getGroupName(groupID);
        _needUpdate = NeedUpdate(groupID, UpdateType.groupDismissed, groupName);
        notifyListeners();
      }
    );
  }

  setGroupListener() {
    _groupServices.addGroupListener(listener: _groupListener!);
  }

  removeGroupListener() {
    _groupServices.removeGroupListener(listener: _groupListener!);
  }

  Future<String> _getGroupName(String groupID) async {
    final groupInfoList = await sdkInstance.getGroupManager().getGroupsInfo(groupIDList: [groupID]);
    String groupName = TDesk_t("群组");
    if (groupInfoList.data != null) {
      groupName = groupInfoList.data!.first.groupInfo!.groupName!;
    }
    return groupName;
  }

  void _deleteGroupConversation(String groupID) async {
    sdkInstance.getConversationManager().deleteConversation(conversationID: "group_${groupID}");
  }

  bool _isLoginUserKickedFromGroup(String groupID, List<V2TimGroupMemberInfo> memberList) {
    final loginUserInfo = coreInstance.loginInfo;
    int index = memberList.indexWhere((element) => element.userID == loginUserInfo.userID);
    if (index > -1) {
      return true;
    }
    return false;
  }
}



