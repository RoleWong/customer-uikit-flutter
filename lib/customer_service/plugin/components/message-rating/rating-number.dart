import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class RatingNumber extends StatefulWidget {
  final dynamic payload;
  final Function onSubmitRating;
  const RatingNumber({super.key, this.payload, required this.onSubmitRating});

  @override
  State<StatefulWidget> createState() => _RatingNumberState();
}

class _RatingNumberState extends TIMState<RatingNumber> {
  int selectIndex = -1;
  bool hasReply = false;
  bool isExpired = false;
  Future<V2TimMsgCreateInfoResult?> submitRating({required data}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(
            data: json.encode({
          'src': CUSTOM_MESSAGE_SRC.MENU_SELECTED,
          'menuSelected': data,
          'customerServicePlugin': 0,
        }));
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      widget.onSubmitRating(messageInfo: messageInfo, onlineUserOnly: true);
      return messageResult;
    }
    return null;
  }

  @override
  Widget timBuild(BuildContext context) {
    String header = widget.payload['head'];
    String tail = widget.payload['tail'];
    String sessionId = widget.payload['sessionId'];
    int expireTime = widget.payload['expireTime'];
    final List menu = widget.payload['menu'];
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    int timestampInSeconds = timestamp ~/ 1000;
    if (expireTime < timestampInSeconds) {
      isExpired = true;
    }

    try {
      if (widget.payload['selected'] != null) {
        for (int i = 0; i < menu.length; i++) {
          if (menu[i]['id'] == widget.payload['selected']['id']) {
            hasReply = true;
            selectIndex = i;
          }
        }
      }
    } catch (e) {}

    return Column(children: [
      Container(
        child: Text(
          header,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 21),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 0),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Column(children: [
          Container(
            child: Text(header),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          ),
          Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: menu.asMap().entries.map((e) {
                print(e);
                return GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      child: Text(
                        (e.key + 1).toString(),
                        style: TextStyle(
                            color: e.key == selectIndex
                                ? Colors.white
                                : Colors.blue),
                      ),
                      decoration: e.key == selectIndex
                          ? BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.white, width: 0),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            )
                          : BoxDecoration(
                              color: const Color.fromARGB(20, 0, 110, 255),
                              border: Border.all(color: Colors.white, width: 0),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                    ),
                    onTap: () {
                      print(e.key);
                      setState(() {
                        selectIndex = e.key;
                        print(selectIndex);
                      });
                    });
              }).toList()),
          const Padding(padding: EdgeInsets.only(top: 10)),
          selectIndex != -1 ? Text(menu[selectIndex]['content']) : Text(header),
          Container(
            child: ElevatedButton(
              style: (hasReply || isExpired)
                  ? ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.grey),
                    )
                  : null,
              child: Text(TDesk_t("确认")),
              onPressed: () {
                if (hasReply || isExpired) {
                  return;
                }
                DateTime now = DateTime.now();
                int timestamp = now.millisecondsSinceEpoch;
                int timestampInSeconds = timestamp ~/ 1000;
                if (expireTime < timestampInSeconds) {
                  setState(() {
                    hasReply = true;
                  });
                  return;
                }
                setState(() {
                  hasReply = true;
                });
                submitRating(data: {
                  'id': menu[selectIndex]['id'],
                  "content": menu[selectIndex]['content'],
                  "sessionId": sessionId
                });
              },
            ),
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          ),
        ]),
      ),
      hasReply
          ? Container(
              child: Text(
                tail,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
            )
          : Container(),
    ]);
  }
}
