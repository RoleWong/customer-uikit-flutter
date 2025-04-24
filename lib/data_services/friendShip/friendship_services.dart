import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';

abstract class TCustomerFriendshipServices {
  Future<List<V2TimFriendInfoResult>?> getFriendsInfo({
    required List<String> userIDList,
  });

  Future<List<V2TimUserFullInfo>?> getUsersInfo({
    required List<String> userIDList,
  });

  Future<List<V2TimFriendInfo>?> getFriendList();


  Future<List<V2TimFriendCheckResult>?> checkFriend({
    required List<String> userIDList,
    required FriendTypeEnum checkType,
  });

  Future<void> addFriendListener({
    required V2TimFriendshipListener listener,
  });

  Future<void> removeFriendListener({
    V2TimFriendshipListener? listener,
  });

}
