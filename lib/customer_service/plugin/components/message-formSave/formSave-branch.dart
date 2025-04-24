import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';


class FormSaveBranch extends StatefulWidget {
  final dynamic payload;
  final Function onClickItem;
  const FormSaveBranch({super.key, this.payload, required this.onClickItem});

  @override
  State<StatefulWidget> createState() => _FormSaveBranchState();
}

class _FormSaveBranchState extends TIMState<FormSaveBranch> {
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
      widget.onClickItem(messageInfo: messageInfo);
      return messageResult;
    }
    return null;
  }

  @override
  Widget timBuild(BuildContext context) {
    final header = widget.payload['header'] ?? "";
    final list = widget.payload['items'] ?? [];

    print(widget.payload);
    print('widget.payload');
    print('widget.payload');

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text(header),
        ),
        ...list.map((item) {
          return GestureDetector(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                child: Text(
                  item['content'],
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                )),
            onTap: () {
              if (hasReply) {
                return;
              }
              hasReply = true;
              clickItem(text: item['content']);
            },
          );
        })
      ]),
    );
  }
}
