import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-branch.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-branchMessage.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-form/message-form.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-formSave/message-formSave.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-productCard.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-rating/message-rating.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-richText.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-robot-welcome.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-stream.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-orderCard.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageCustomerService extends StatefulWidget {
  final TUITheme theme;
  final V2TimMessage message;
  final bool isShowJumpState;
  final EdgeInsetsGeometry? textPadding;
  final Color? messageBackgroundColor;
  final BorderRadius? messageBorderRadius;
  final Function sendMessage;
  final Function? onTapLink;
  const MessageCustomerService(
      {super.key,
      required this.theme,
      required this.message,
      this.isShowJumpState = false,
      required this.sendMessage,
      this.textPadding,
      this.messageBackgroundColor,
      this.messageBorderRadius,
      this.onTapLink});

  @override
  State<StatefulWidget> createState() => _MessageCustomerServiceState();
}

class _MessageCustomerServiceState extends State<MessageCustomerService> {
  @override
  Widget build(BuildContext context) {
    var messageSrc;
    var payload;
    Map<String, dynamic> mapData = {};
    V2TimCustomElem? custom = widget.message.customElem;

    final isFromSelf = widget.message.isSelf ?? true;
    final borderRadius = isFromSelf
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10))
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10));

    final defaultStyle = isFromSelf
        ? widget.theme.lightPrimaryMaterialColor.shade50
        : widget.theme.weakBackgroundColor;
    final backgroundColor = widget.isShowJumpState
        ? const Color.fromRGBO(245, 166, 35, 1)
        : defaultStyle;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          mapData = json.decode(data);
          messageSrc = mapData["src"];
        } catch (err) {
          // err
        }
      }
    }
    switch (messageSrc) {
      case CUSTOM_MESSAGE_SRC.MENU:
        try {
          payload = mapData["menuContent"];
        } catch (err) {
          // err
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            child: MessageRating(
              payload: payload,
              onSubmitRating: widget.sendMessage,
            ));
      case CUSTOM_MESSAGE_SRC.FROM_INPUT:
        try {
          payload = mapData["content"];
        } catch (err) {
          // err
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageFormSave(
              payload: payload,
              onSubmitForm: widget.sendMessage,
            ));
      case CUSTOM_MESSAGE_SRC.PRODUCT_CARD:
        try {
          payload = mapData["content"];
        } catch (err) {
          // err
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageProductCard(payload: payload));
      case CUSTOM_MESSAGE_SRC.BRANCH:
        try {
          payload = mapData["content"];
        } catch (err) {
          // err
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageBranch(
              payload: payload,
              onClickItem: widget.sendMessage,
            ));
      case CUSTOM_MESSAGE_SRC.ORDER_CARD:
        try {
          payload = mapData["content"];
        } catch (err) {
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageOrderCard(
              payload: payload,
            ));
      case CUSTOM_MESSAGE_SRC.ROBOT_WELCOME_CARD:
        try {
          payload = mapData["content"];
        } catch (err) {
        }
        return Container(
            padding: (const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageRobotWelcome(
              payload: payload,
              onClickItem: widget.sendMessage,
            ));
      case CUSTOM_MESSAGE_SRC.RICH_TEXT:
        try {
          payload = jsonEncode(mapData["content"]);
        } catch (err) {
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageRichText(
              payload: payload,
              onTapLink: widget.onTapLink,
            ));
      case CUSTOM_MESSAGE_SRC.STREAM_TEXT:
        try {
          payload = mapData;
        } catch (err) {
        }
        return Container(
            padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageStream(
              payload: payload,
            ));
      case CUSTOM_MESSAGE_SRC.BRANCH_MESSAGE:
        try {
          payload = mapData["content"];
          payload["status"] = mapData["status"];
        } catch (err) {
        }
        return MessageBranchNew(
          payload: payload,
          onClickItem: widget.sendMessage,
          theme: widget.theme,
          textPadding: widget.textPadding,
          messageBackgroundColor: widget.messageBackgroundColor,
          messageBorderRadius: widget.messageBorderRadius,
        );
      case CUSTOM_MESSAGE_SRC.FORM_SAVE:
        return Container(
            // padding: (widget.textPadding ?? const EdgeInsets.all(10)),
            decoration: BoxDecoration(
              // color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
            child: MessageForm(
              payload: mapData,
              onClickItem: ({V2TimMessage? messageInfo}) => widget.sendMessage(messageInfo: messageInfo),
            ));
    }

    return Container();
  }
}
