import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageRobotWelcome extends StatefulWidget {
  final dynamic payload;
  final Function onClickItem;

  const MessageRobotWelcome({
    super.key,
    required this.payload,
    required this.onClickItem,
  });

  @override
  State<StatefulWidget> createState() => _MessageRobotWelcomeState();
}

class _MessageRobotWelcomeState extends TIMState<MessageRobotWelcome> {
  int page = 0;
  static const int itemsPerPage = 4;

  List<dynamic> get paginatedItems {
    final items = widget.payload['items'] ?? [];
    final startIndex = page * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, items.length);
    return items.sublist(startIndex, endIndex);
  }

  int get totalPages {
    final items = widget.payload['items'] ?? [];
    return (items.length / itemsPerPage).ceil();
  }

  void _nextPage() {
    setState(() {
      page = (page + 1) % totalPages;
    });
  }

  Widget _buildMessageItem(dynamic item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF006EFF).withOpacity(0.3),
          width: 0.5,
        ),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _onClickItem(text: item['content']);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['content'],
                    style: const TextStyle(
                      color: Color(0xFF006EFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<V2TimMsgCreateInfoResult?> _onClickItem({required String text}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: text);
    if (res.code == 0) {
      final messageResult = res.data;
      final messageInfo = messageResult?.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult?.id;
      }
      widget.onClickItem(messageInfo: messageInfo);
      return messageResult;
    }
    return null;
  }

  @override
  Widget timBuild(BuildContext context) {
    final title = widget.payload['title'] ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (totalPages > 1)
                  GestureDetector(
                    onTap: _nextPage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          TDesk_t("换一换"),
                          style: const TextStyle(
                            color: Color(0xFF006EFF),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.refresh,
                          color: Color(0xFF006EFF),
                          size: 22,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ...paginatedItems.map(_buildMessageItem).toList(),
      ],
    );
  }
}
