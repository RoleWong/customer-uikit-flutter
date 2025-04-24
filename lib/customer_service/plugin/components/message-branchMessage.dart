import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';
import 'package:tencentcloud_ai_desk_customer/theme/tui_theme.dart';


class MessageBranchNew extends StatefulWidget {
  final TUITheme theme;
  final dynamic payload;
  final Function onClickItem;
  final EdgeInsetsGeometry? textPadding;
  final Color? messageBackgroundColor;
  final BorderRadius? messageBorderRadius;

  const MessageBranchNew({
    super.key,
    required this.payload,
    required this.onClickItem,
    this.textPadding,
    this.messageBackgroundColor,
    this.messageBorderRadius,
    required this.theme,
  });

  @override
  State<StatefulWidget> createState() => _MessageBranchNewState();
}

class _MessageBranchNewState extends TIMState<MessageBranchNew> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();

    // Set the initial state based on payload status
    final status = widget.payload['status'] ?? 0;
    if (status != 0) {
      _selected = true;
    }
  }

  /// Handles the item click event
  Future<V2TimMsgCreateInfoResult?> _onClickItem({required String text}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: text);
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult?.messageInfo;

      // Special handling for non-web platforms
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult?.id;
      }

      // Trigger the onClickItem callback
      widget.onClickItem(messageInfo: messageInfo);

      return messageResult;
    }
    return null;
  }

  /// Builds the list of selectable questions
  Widget _buildQuestionsList(List<dynamic> list) {
    if (_selected) return Container(); // Return an empty container if already selected

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map<Widget>((item) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: GestureDetector(
            onTap: () {
              _onClickItem(text: item['content']);
              setState(() {
                _selected = true;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: widget.messageBackgroundColor ?? widget.theme.weakBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF006EFF).withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                item['content'],
                style: const TextStyle(color: Color(0xFF1C66E5), fontSize: 15),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget timBuild(BuildContext context) {
    final header = widget.payload['header'] ?? ""; // Message header
    final list = widget.payload['items'] ?? []; // List of selectable items
    final backgroundColor = widget.messageBackgroundColor ?? widget.theme.weakBackgroundColor;

    // Header decoration
    const defaultBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(2),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display message header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: widget.messageBorderRadius ?? defaultBorderRadius,
            ),
            child: Text(
              header,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          // Display selectable questions
          if(widget.payload["status"] == 0) _buildQuestionsList(list),
        ],
      ),
    );
  }
}
