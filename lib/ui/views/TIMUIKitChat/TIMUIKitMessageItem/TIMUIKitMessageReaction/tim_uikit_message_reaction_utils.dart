import 'dart:convert';

import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/message/message_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/platform.dart';
import 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';

class MessageReactionUtils {
  static final TCustomerSelfInfoViewModel selfInfoModel =
      serviceLocator<TCustomerSelfInfoViewModel>();
  static final TCustomerMessageService _messageService =
      serviceLocator<TCustomerMessageService>();

  static CloudCustomData getCloudCustomData(V2TimMessage message) {
    CloudCustomData messageCloudCustomData;
    try {
      messageCloudCustomData = CloudCustomData.fromJson(json.decode(
          TencentDeskUtils.checkString(message.cloudCustomData) != null
              ? message.cloudCustomData!
              : "{}"));
    } catch (e) {
      messageCloudCustomData = CloudCustomData();
    }

    return messageCloudCustomData;
  }

  static Map<String, dynamic> getMessageReaction(V2TimMessage message) {
    return getCloudCustomData(message).messageReaction ?? {};
  }

  static Future<V2TimValueCallback<V2TimMessageChangeInfo>> clickOnSticker(
      V2TimMessage message, int sticker) async {
    final CloudCustomData messageCloudCustomData = getCloudCustomData(message);
    final Map<String, dynamic> messageReaction =
        messageCloudCustomData.messageReaction ?? {};
    List targetList = messageReaction["$sticker"] ?? [];
    if (targetList.contains(selfInfoModel.loginInfo!.userID!)) {
      targetList.remove(selfInfoModel.loginInfo!.userID!);
    } else {
      targetList = [selfInfoModel.loginInfo!.userID!, ...targetList];
    }
    messageReaction["$sticker"] = targetList;

    if (PlatformUtils().isWeb) {
      final decodedMessage = jsonDecode(message.messageFromWeb!);
      decodedMessage["cloudCustomData"] =
          jsonEncode(messageCloudCustomData.toMap());
      message.messageFromWeb = jsonEncode(decodedMessage);
    } else {
      message.cloudCustomData = json.encode(messageCloudCustomData.toMap());
    }
    return await _messageService.modifyMessage(message: message);
  }
}
