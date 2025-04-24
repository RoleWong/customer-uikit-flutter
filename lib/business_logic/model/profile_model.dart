import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

class UserProfile {
  late V2TimFriendInfo? friendInfo;
  late V2TimConversation? conversation;

  UserProfile({required this.friendInfo, required this.conversation});
}
