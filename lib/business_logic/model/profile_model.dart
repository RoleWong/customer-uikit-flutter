import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

class UserProfile {
  late V2TimFriendInfo? friendInfo;
  late V2TimConversation? conversation;

  UserProfile({required this.friendInfo, required this.conversation});
}
