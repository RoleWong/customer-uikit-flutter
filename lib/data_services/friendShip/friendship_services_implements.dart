import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/friendShip/friendship_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_callback.dart';

class TCustomerFriendshipServicesImpl implements TCustomerFriendshipServices {
  final TCustomerCoreServicesImpl _coreService = serviceLocator<TCustomerCoreServicesImpl>();

  @override
  Future<List<V2TimFriendInfoResult>?> getFriendsInfo({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .getFriendsInfo(userIDList: userIDList);
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
  Future<List<V2TimUserFullInfo>?> getUsersInfo({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getUsersInfo(userIDList: userIDList);
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
  Future<List<V2TimFriendInfo>?> getFriendList() async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .getFriendList();
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
  Future<List<V2TimFriendCheckResult>?> checkFriend({
    required List<String> userIDList,
    required FriendTypeEnum checkType,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .checkFriend(userIDList: userIDList, checkType: checkType);
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
  Future<void> addFriendListener({
    required V2TimFriendshipListener listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .addFriendListener(listener: listener);
  }

  @override
  Future<void> removeFriendListener({
    V2TimFriendshipListener? listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .removeFriendListener(listener: listener);
  }
}
