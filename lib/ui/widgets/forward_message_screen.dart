import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_state.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

import 'package:tencentcloud_ai_desk_customer/ui/utils/message.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/screen_utils.dart';
import 'package:tencentcloud_ai_desk_customer/ui/widgets/recent_conversation_list.dart';

import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_base.dart';

GlobalKey<_ForwardMessageScreenState> forwardMessageScreenKey = GlobalKey();

class ForwardMessageScreen extends StatefulWidget {
  final bool isMergerForward;
  final ConvType conversationType;
  final TUIChatSeparateViewModel model;
  final VoidCallback? onClose;

  const ForwardMessageScreen(
      {Key? key,
      this.isMergerForward = false,
      required this.conversationType,
      required this.model,
      this.onClose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends TIMUIKitState<ForwardMessageScreen> {
  final TCustomerChatGlobalModel model = serviceLocator<TCustomerChatGlobalModel>();
  final TCustomerSelfInfoViewModel _selfInfoViewModel =
      serviceLocator<TCustomerSelfInfoViewModel>();
  List<V2TimConversation> _conversationList = [];
  bool isMultiSelect = false;

  String _getMergerMessageTitle() {
    if (widget.conversationType == ConvType.c2c) {
      final option1 = (_selfInfoViewModel.loginInfo?.nickName != null &&
              _selfInfoViewModel.loginInfo!.nickName!.isNotEmpty)
          ? _selfInfoViewModel.loginInfo?.nickName
          : _selfInfoViewModel.loginInfo?.userID;
      // Chat History for xx
      return TDesk_t_para("{{option1}}的聊天记录", "$option1的聊天记录")(option1: option1);
    } else {
      return TDesk_t("群聊的聊天记录");
    }
  }

  List<String> _getAbstractList() {
    return widget.model.getSelectedMessageList().map((e) {
      final sender = (e.nickName != null && e.nickName!.isNotEmpty)
          ? e.nickName
          : e.sender;
      return "$sender: ${model.abstractMessageBuilder != null ? model.abstractMessageBuilder!(e) : MessageUtils.getAbstractMessageAsync(e, [])}";
    }).toList();
  }

  handleForwardMessage() async {
    var confirmResult = await _showConfirmForwardDialog(context);
    if (confirmResult == null) {
      return;
    }

    if (widget.isMergerForward) {
      await widget.model.sendMergerMessage(
        conversationList: _conversationList,
        title: _getMergerMessageTitle(),
        abstractList: _getAbstractList(),
        context: context,
      );
    } else {
      await widget.model
          .sendForwardMessage(conversationList: _conversationList);
    }
    widget.model.updateMultiSelectStatus(false);

    if (widget.onClose != null) {
      // widget.onClose!();
    } else {
      Navigator.pop(context);
    }
  }

  // 弹出转发确认对话框
  Future<bool?> _showConfirmForwardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(TDesk_t("您确定进行转发吗？")),
          actions: [
            CupertinoDialogAction(
              child: Text(TDesk_t("确定")),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text(TDesk_t("取消")),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.updateMultiSelectStatus(false);
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final TUITheme theme = value.theme;
    if (isDesktopScreen) {
      isMultiSelect = true;
      return RecentForwardList(
        isMultiSelect: isMultiSelect,
        onChanged: (conversationList) {
          _conversationList = conversationList;

          if (!isMultiSelect) {
            handleForwardMessage();
          }
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isMultiSelect ? TDesk_t("选择多个会话") : TDesk_t("选择一个会话"),
          style: TextStyle(
            color: theme.appbarTextColor,
            fontSize: 17,
          ),
        ),
        shadowColor: theme.weakBackgroundColor,
        backgroundColor: theme.appbarBgColor ?? theme.primaryColor,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            if (isMultiSelect) {
              setState(() {
                isMultiSelect = false;
                _conversationList = [];
              });
            } else {
              widget.model.updateMultiSelectStatus(false);
              if (widget.onClose != null) {
                widget.onClose!();
              } else {
                Navigator.pop(context);
              }
            }
          },
          child: Text(
            TDesk_t("取消"),
            style: TextStyle(
              color: theme.appbarTextColor,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!isMultiSelect) {
                setState(() {
                  isMultiSelect = true;
                });
              } else {
                handleForwardMessage();
              }
            },
            child: Text(
              !isMultiSelect ? TDesk_t("多选") : TDesk_t("完成"),
              style: TextStyle(
                color: theme.appbarTextColor,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: RecentForwardList(
        isMultiSelect: isMultiSelect,
        onChanged: (conversationList) {
          _conversationList = conversationList;

          if (!isMultiSelect) {
            handleForwardMessage();
          }
        },
      ),
    );
  }
}
