import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dotted_line/dotted_line.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';

class MessageBranch extends StatefulWidget {
  final dynamic payload;
  final Function onClickItem;
  const MessageBranch(
      {super.key, required this.payload, required this.onClickItem});

  @override
  State<StatefulWidget> createState() => _MessageBranchState();
}

class _MessageBranchState extends TIMState<MessageBranch> {
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
    bool hasReply = false;
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        header != ""
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  header,
                ))
            : Container(),
        header != ""
            ? const DottedLine(
                dashLength: 0.5,
                dashColor: Colors.grey,
              )
            : Container(),
        ...list.map((item) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              item['content'],
                              style: const TextStyle(color: Colors.blue),
                            )),
                            const Expanded(
                                flex: 0,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.blue,
                                ))
                          ],
                        )),
                    onTap: () {
                      if (hasReply) {
                        return;
                      }
                      setState(() {
                        hasReply = true;
                      });
                      clickItem(text: item['content']);
                    }),
                const DottedLine(
                  dashLength: 0.5,
                  dashColor: Colors.grey,
                ),
              ]);
        })
      ]),
    );
  }
}
