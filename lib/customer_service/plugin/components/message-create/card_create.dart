import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TencentCloudChatCardCreate extends StatefulWidget {
  final Function onSendCard;
  final Function onClosed;
  final bool isWide;
  const TencentCloudChatCardCreate({
    super.key,
    required this.onSendCard,
    required this.onClosed,
    required this.isWide,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatCardCreateState();
}

class _TencentCloudChatCardCreateState
    extends State<TencentCloudChatCardCreate> {
  Future<V2TimMsgCreateInfoResult?> sendCardMessage({required data}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(
            data: json.encode({
          'src': CUSTOM_MESSAGE_SRC.PRODUCT_CARD,
          'customerServicePlugin': 0,
          'content': data
        }));
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      widget.onSendCard(messageInfo: messageInfo);
      return messageResult;
    }
    return null;
  }

  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _descriptionInputController = TextEditingController();
  final TextEditingController _pictureInputController = TextEditingController();
  final TextEditingController _jumpInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            Container(
              child: Text(
                TDesk_t("名称"),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              width: 40,
              margin: const EdgeInsets.only(bottom: 10),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              constraints: const BoxConstraints(maxHeight: 36),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 234, 234, 0.612),
                  border: Border.all(color: Colors.grey, width: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                  hintText: TDesk_t("请填写商品名称"),
                  hintStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
                controller: _nameInputController,
              ),
            ))
          ],
        ),
        Row(
          children: [
            Container(
              child: Text(
                TDesk_t("描述"),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              width: 40,
              margin: const EdgeInsets.only(bottom: 10),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              constraints: const BoxConstraints(maxHeight: 36),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 234, 234, 0.612),
                  border: Border.all(color: Colors.grey, width: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                  hintText: TDesk_t("请填写相关描述"),
                  hintStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
                controller: _descriptionInputController,
              ),
            ))
          ],
        ),
        Row(
          children: [
            Container(
              child: Text(
                TDesk_t("图片"),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              width: 40,
              margin: const EdgeInsets.only(bottom: 10),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              constraints: const BoxConstraints(maxHeight: 36),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 234, 234, 0.612),
                  border: Border.all(color: Colors.grey, width: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                  hintText: TDesk_t("请填写图片链接"),
                  hintStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
                controller: _pictureInputController,
              ),
            ))
          ],
        ),
        Row(
          children: [
            SizedBox(
                child: Text(
                  TDesk_t("跳转"),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                width: 40),
            Expanded(
                child: Container(
              constraints: const BoxConstraints(maxHeight: 36),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 234, 234, 0.612),
                  border: Border.all(color: Colors.grey, width: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                  hintText: TDesk_t("请填写跳转地址"),
                  hintStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
                controller: _jumpInputController,
              ),
            ))
          ],
        ),
        Padding(
          padding: widget.isWide
              ? const EdgeInsets.only(top: 30)
              : const EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(TDesk_t("提交商品信息")),
                  ),
                  onPressed: () {
                    sendCardMessage(data: {
                      "header": _nameInputController.text,
                      "desc": _descriptionInputController.text,
                      "pic": _pictureInputController.text,
                      "url": _jumpInputController.text
                    });
                    widget.onClosed();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
