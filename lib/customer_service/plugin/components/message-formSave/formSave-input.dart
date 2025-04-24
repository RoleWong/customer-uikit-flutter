import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';


class FormSaveInput extends StatefulWidget {
  final dynamic payload;
  final Function onSubmitInput;
  const FormSaveInput(
      {super.key, required this.payload, required this.onSubmitInput});

  @override
  State<StatefulWidget> createState() => _FormSaveInputState();
}

class _FormSaveInputState extends TIMState<FormSaveInput> {
  final TextEditingController _inputController = TextEditingController();
  bool hasReply = false;
  Future<V2TimMsgCreateInfoResult?> clickItem({required String text}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(text: text);
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      widget.onSubmitInput(messageInfo: messageInfo);
      return messageResult;
    }
    return null;
  }

  @override
  Widget timBuild(BuildContext context) {
    final header = widget.payload['header'] ?? "";

    try {
      if (widget.payload['selected'] != null) {
        if (widget.payload['selected']['content'] != null) {
          hasReply = true;
          _inputController.text = widget.payload['selected']['content'];
        }
      }
    } catch (e) {}
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text(header),
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              constraints: const BoxConstraints(maxHeight: 36),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(10))),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(0),
                ),
                controller: _inputController,
              ),
            )),
            Expanded(
                flex: 0,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 36),
                  decoration: BoxDecoration(
                      color: hasReply ? Colors.grey : Colors.blue,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius:
                          const BorderRadius.horizontal(right: Radius.circular(10))),
                  child: IconButton(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (hasReply) {
                        return;
                      }
                      setState(() {
                        hasReply = true;
                      });
                      clickItem(text: _inputController.text);
                    },
                  ),
                ))
          ],
        )
      ]),
    );
  }
}
