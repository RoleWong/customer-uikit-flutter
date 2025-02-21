import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_base.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_ui_kit_state.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/message/message_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/ui/constants/history_message_constant.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/platform.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/sound_record.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'TIMUIKitMessageReaction/tim_uikit_message_reaction_show_panel.dart';

class TIMUIKitSoundElem extends StatefulWidget {
  final V2TimMessage message;
  final V2TimSoundElem soundElem;
  final String msgID;
  final bool isFromSelf;
  final int? localCustomInt;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final TextStyle? fontStyle;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? textPadding;
  final bool? isShowMessageReaction;
  final TUIChatSeparateViewModel chatModel;

  const TIMUIKitSoundElem(
      {Key? key,
      required this.soundElem,
      required this.msgID,
      required this.isFromSelf,
      this.isShowJump = false,
      this.clearJump,
      this.localCustomInt,
      this.fontStyle,
      this.borderRadius,
      this.backgroundColor,
      this.textPadding,
      required this.message,
      this.isShowMessageReaction,
      required this.chatModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitSoundElemState();
}

class _TIMUIKitSoundElemState extends TIMUIKitState<TIMUIKitSoundElem> {
  final int charLen = 8;
  bool isPlaying = false;
  StreamSubscription<Object>? subscription;
  bool isShowJumpState = false;
  bool isShining = false;
  final TCustomerChatGlobalModel globalModel = serviceLocator<TCustomerChatGlobalModel>();
  final TCustomerMessageService _messageService = serviceLocator<TCustomerMessageService>();
  late V2TimSoundElem stateElement = widget.message.soundElem!;

  _playSound() async {
    if (!SoundPlayer.isInit) {
      SoundPlayer.initSoundPlayer();
    }
    if (widget.localCustomInt == null || widget.localCustomInt != HistoryMessageDartConstant.read) {
      globalModel.setLocalCustomInt(widget.msgID, HistoryMessageDartConstant.read, widget.chatModel.conversationID);
    }
    if (isPlaying) {
      SoundPlayer.stop();
      widget.chatModel.currentPlayedMsgId = "";
    } else {
      SoundPlayer.play(url: stateElement.url!);
      widget.chatModel.currentPlayedMsgId = widget.msgID;

      setState(() {
        isPlaying = widget.chatModel.currentPlayedMsgId != '' && widget.chatModel.currentPlayedMsgId == widget.msgID;
      });
    }
  }

  downloadMessageDetailAndSave() async {
    if (widget.message.msgID != null && widget.message.msgID != '') {
      if (widget.message.soundElem!.url == null || widget.message.soundElem!.url == '') {
        final response = await _messageService.getMessageOnlineUrl(msgID: widget.message.msgID!);
        if (response.data != null) {
          widget.message.soundElem = response.data!.soundElem;
          Future.delayed(const Duration(microseconds: 10), () {
            setState(() => stateElement = response.data!.soundElem!);
          });
        }
      }
      if (!PlatformUtils().isWeb) {
        if (widget.message.soundElem!.localUrl == null || widget.message.soundElem!.localUrl == '') {
          _messageService.downloadMessage(
              msgID: widget.message.msgID!, messageType: 4, imageType: 0, isSnapshot: false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    subscription = SoundPlayer.playStateListener(listener: (PlayerState state) {
      if (state.processingState == ProcessingState.completed) {
        widget.chatModel.currentPlayedMsgId = "";
        setState(() {
          isPlaying = false;
        });
      }
    });

    downloadMessageDetailAndSave();
  }

  @override
  void dispose() {
    if (isPlaying) {
      SoundPlayer.stop();
      widget.chatModel.currentPlayedMsgId = "";
    }
    subscription?.cancel();
    super.dispose();
  }

  double _getSoundLen() {
    double soundLen = 32;
    if (stateElement.duration != null) {
      final realSoundLen = stateElement.duration!;
      int sdLen = 32;
      if (realSoundLen > 10) {
        sdLen = 12 * charLen + ((realSoundLen - 10) * charLen / 0.5).floor();
      } else if (realSoundLen > 2) {
        sdLen = 2 * charLen + realSoundLen * charLen;
      }
      sdLen = min(sdLen, 20 * charLen);
      soundLen = sdLen.toDouble();
    }

    return soundLen;
  }

  _showJumpColor() {
    if ((widget.chatModel.jumpMsgID != widget.message.msgID) && (widget.message.msgID?.isNotEmpty ?? true)) {
      return;
    }
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    widget.clearJump!();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;

    final backgroundColor = widget.isFromSelf
        ? (theme.chatMessageItemFromSelfBgColor ?? theme.lightPrimaryMaterialColor.shade50)
        : (Colors.white);

    final borderRadius = widget.isFromSelf
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
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        if ((widget.chatModel.jumpMsgID == widget.message.msgID) && (widget.message.msgID?.isNotEmpty ?? false)) {
          widget.clearJump!();
        }
      }
    }
    return GestureDetector(
      onTap: () => _playSound(),
      child: Container(
        padding: widget.textPadding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isShowJumpState ? const Color.fromRGBO(245, 166, 35, 1) : (widget.isFromSelf ? null : backgroundColor),
          gradient: (widget.isFromSelf && !isShowJumpState)
              ? LinearGradient(
                  colors: [hexToColor("009FEF"), hexToColor("006EE1")],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
              : null,
          borderRadius: widget.borderRadius ?? borderRadius,
        ),
        constraints: const BoxConstraints(maxWidth: 240),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.isFromSelf
                  ? [
                      Container(width: _getSoundLen()),
                      Text(
                        "''${stateElement.duration} ",
                        style: TextStyle(
                          color: widget.isFromSelf ? Colors.white : null,
                        ),
                      ),
                SenderVoiceAnimationWidget(isPlaying: isPlaying),
                    ]
                  : [
                      isPlaying
                          ? Image.asset(
                              'images/play_voice_receive.gif',
                              package: 'tencentcloud_ai_desk_customer',
                              width: 16,
                              height: 16,
                            )
                          : Image.asset(
                              'images/voice_receive.png',
                              width: 16,
                              height: 16,
                              package: 'tencentcloud_ai_desk_customer',
                            ),
                      Text(
                        " ${stateElement.duration}''",
                        style: TextStyle(
                          color: widget.isFromSelf ? Colors.white : null,
                        ),
                      ),
                      Container(width: _getSoundLen()),
                    ],
            ),
            if (widget.isShowMessageReaction ?? true)
              TIMUIKitMessageReactionShowPanel(
                message: widget.message,
              )
          ],
        ),
      ),
    );
  }
}

class SenderVoiceAnimationWidget extends StatefulWidget {
  final bool isPlaying;

  const SenderVoiceAnimationWidget({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<SenderVoiceAnimationWidget> createState() => _SenderVoiceAnimationWidgetState();
}

class _SenderVoiceAnimationWidgetState extends State<SenderVoiceAnimationWidget> {
  final List<String> _frames = [
    'images/play_voice_send_1.png',
    'images/play_voice_send_2.png',
    'images/play_voice_send_3.png',
  ];
  int _currentFrameIndex = 2;
  Timer? _timer;

  @override
  void didUpdateWidget(covariant SenderVoiceAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && _timer == null) {
      _startAnimation();
    } else if (!widget.isPlaying && _timer != null) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _currentFrameIndex = (_currentFrameIndex + 1) % _frames.length;
      });
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _currentFrameIndex = _frames.length - 1;
    });
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _frames[_currentFrameIndex],
      package: 'tencentcloud_ai_desk_customer',
      width: 16,
      height: 16,
    );
  }
}
