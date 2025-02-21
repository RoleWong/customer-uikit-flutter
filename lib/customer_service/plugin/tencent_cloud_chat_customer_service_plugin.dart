import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/utils/tencent_cloud_customer_toast.dart';


class TencentCloudChatCustomerServicePlugin {
  static final V2TIMManager imManager = TencentImSDKPlugin.v2TIMManager;

  static late String currentUser;
  static bool hasInited = false;
  static List<String> srcWhiteList = [
    CUSTOM_MESSAGE_SRC.MENU,
    CUSTOM_MESSAGE_SRC.FROM_INPUT,
    CUSTOM_MESSAGE_SRC.PRODUCT_CARD,
    CUSTOM_MESSAGE_SRC.BRANCH,
    CUSTOM_MESSAGE_SRC.ORDER_CARD,
    CUSTOM_MESSAGE_SRC.ROBOT_WELCOME_CARD,
    CUSTOM_MESSAGE_SRC.RICH_TEXT,
    CUSTOM_MESSAGE_SRC.STREAM_TEXT,
    CUSTOM_MESSAGE_SRC.BRANCH_MESSAGE,
    CUSTOM_MESSAGE_SRC.FORM_SAVE,
  ];
  static List<String> rowWhiteList = [
    CUSTOM_MESSAGE_SRC.MENU,
  ];
  static List<String> typingWhiteList = [
    CUSTOM_MESSAGE_SRC.TYPING_STATE,
  ];

  static Future<String> _getCurrentLoginUser() async {
    V2TimValueCallback<String> ruseres = await imManager.getLoginUser();
    return ruseres.data ?? "";
  }

  static initPlugin() async {
    final res = await TencentImSDKPlugin.v2TIMManager.checkAbility();
    if (res.code == 0) {
      hasInited = true;
      return;
    }
    hasInited = false;
    return;
  }

  static getCustomerServiceInfo(customerServiceUserList) async {
    List<V2TimUserFullInfo> customerServiceInfoList = [];
    V2TimValueCallback<List<V2TimUserFullInfo>> getUsersInfoRes =
        await TencentImSDKPlugin.v2TIMManager
            .getUsersInfo(userIDList: customerServiceUserList); //需要查询的用户id列表
    if (getUsersInfoRes.code == 0) {
      // 查询成功
      getUsersInfoRes.data?.forEach((element) {
        customerServiceInfoList.add(element);
      });
    }
    return customerServiceInfoList;
  }

  static bool isCustomerServiceMessage(V2TimMessage message) {
    bool isCustomerService = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["customerServicePlugin"] == 0) {
            isCustomerService = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isCustomerService;
  }

  static bool isCustomerServiceMessageInvisible(V2TimMessage message) {
    bool invisible = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (!srcWhiteList.contains(mapData["src"])) {
            invisible = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return invisible;
  }

  static bool isCanSendEvaluate(V2TimMessage message) {
    bool isCanSendEvaluate = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData['content']['menuSendRuleFlag'] >> 2 == 1) {
            isCanSendEvaluate = true;
          } else {
            isCanSendEvaluate = false;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isCanSendEvaluate;
  }

  static bool isCanSendEvaluateMessage(V2TimMessage message) {
    bool isCanSendEvaluateMessage = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["src"] == CUSTOM_MESSAGE_SRC.SATISFACTION_CON) {
            isCanSendEvaluateMessage = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isCanSendEvaluateMessage;
  }

  static bool isRowCustomerServiceMessage(V2TimMessage message) {
    bool isRow = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (rowWhiteList.contains(mapData["src"])) {
            isRow = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isRow;
  }

  static bool isTypingCustomerServiceMessage(V2TimMessage message) {
    bool isTyping = false;
    V2TimCustomElem? custom = message.customElem;
    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (typingWhiteList.contains(mapData["src"])) {
            isTyping = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isTyping;
  }

  static void getEvaluateMessage(Function sendMessage) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(
            data: json.encode({
          'src': CUSTOM_MESSAGE_SRC.USER_SATISFACTION,
          'customerServicePlugin': 0,
        }));
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      sendMessage(messageInfo: messageInfo, onlineUserOnly: true);
    }
  }

  static void sendCustomerServiceStartMessage(Function sendMessage, String language) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(
            data: json.encode({
          'src': CUSTOM_MESSAGE_SRC.MINI_APP_AUTO,
          'customerServicePlugin': 0,
          "triggeredContent": {"language": language}
        }));
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      sendMessage(messageInfo: messageInfo, onlineUserOnly: true);
    }
  }

  static void sendCustomerServiceEndSessionMessage(Function sendMessage) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(
            data: json.encode({
          'src': CUSTOM_MESSAGE_SRC.USER_ENDSESSION,
          'customerServicePlugin': 0,
        }));
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      sendMessage(messageInfo: messageInfo, onlineUserOnly: true);
    }
  }

  static bool isInSession(V2TimMessage message) {
    bool isInSession = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData['content']['content'] == "inSeat") {
            isInSession = true;
          } else {
            isInSession = false;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isInSession;
  }

  static bool isInSessionMessage(V2TimMessage message) {
    bool isInSessionMessage = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["src"] == CUSTOM_MESSAGE_SRC.USER_IN_SESSION) {
            isInSessionMessage = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isInSessionMessage;
  }
}
