import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_statelesswidget.dart';

import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKItMessageList/TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';

class TencentCloudCustomerTongueItem extends TIMUIKitStatelessWidget {
  /// the callback after clicking
  final VoidCallback onClick;

  /// the value type currently
  final MessageListTongueType valueType;

  /// unread amount currently
  final int unreadCount;

  /// total amount of messages at me
  final String atNum;

  final int previousCount;

  TencentCloudCustomerTongueItem({
    Key? key,
    required this.onClick,
    required this.valueType,
    required this.previousCount,
    required this.unreadCount,
    required this.atNum,
  }) : super(key: key);

  Map<MessageListTongueType, String> textType(BuildContext context) {
    final option1 = unreadCount.toString();
    final option2 = atNum.toString();
    // final option3 = previousCount.toString();
    final String atMeString = option2 != ""
        ? TDesk_t_para("有{{option2}}条@我消息", "有$option2条@我消息")(option2: option2)
        : TDesk_t("有人@我");

    return {
      // MessageListTongueType.showPrevious:
      //     TDesk_t_para("{{option3}}条未读消息", "$option3条未读消息")(option3: option3),
      MessageListTongueType.toLatest: TDesk_t("回到最新位置"),
      MessageListTongueType.showUnread:
          TDesk_t_para("{{option1}}条新消息", "$option1条新消息")(option1: option1),
      MessageListTongueType.atMe: atMeString,
      MessageListTongueType.atAll: TDesk_t("@所有人"),
    };
  }

  final Map<MessageListTongueType, IconData> iconType = {
    MessageListTongueType.toLatest: Icons.keyboard_double_arrow_down,
    MessageListTongueType.showUnread: Icons.keyboard_double_arrow_down,
    MessageListTongueType.atMe: Icons.keyboard_double_arrow_up_outlined,
    MessageListTongueType.atAll: Icons.keyboard_double_arrow_up_outlined,
    MessageListTongueType.showPrevious: Icons.keyboard_double_arrow_up_outlined,
  };

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: hexToColor("46628C").withOpacity(0.08),
                offset: const Offset(0.0, 0.0),
                blurRadius: 10,
                spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.all(10),
        // width: 112,
        // height: 37,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: Icon(
                iconType[valueType],
                color: Colors.black.withOpacity(0.35),
                size: 16,
              ),
            ),
            Text(
              textType(context)[valueType] ?? "",
              style: TextStyle(
                  color: hexToColor("1C66E5"),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
