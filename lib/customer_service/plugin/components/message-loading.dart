import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/message/message_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';

class MessageLoading extends StatefulWidget{
  final dynamic payload;
  final V2TimMessage message;
  const MessageLoading({super.key, this.payload, required this.message});

  @override
  State<MessageLoading> createState() => _MessageLoadingState();
}

class _MessageLoadingState extends State<MessageLoading> {
  final TCustomerMessageService _messageService = serviceLocator<TCustomerMessageService>();
  late AnimationController _controller;
  late Animation<int> _dotAnimation;
  int dotAmounts = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // _setLoadingDisappear();
    _setupTimer();
  }

  _setLoadingDisappear() {
    int? messageTimeStamp = widget.message.timestamp;
    if (messageTimeStamp != null && messageTimeStamp > 0) {
      int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      int diff = 60 - (currentTime - messageTimeStamp);

      if (diff > 0) {
        Future.delayed(Duration(seconds: min(0, 60)), () {
          widget.payload["thinkingStatus"] = 1;
          widget.message.customElem?.data = json.encode(widget.payload);
          _messageService.modifyMessage(message: widget.message);
        });
      }
    }
  }

  _endTimer(){
    if(_timer != null){
      _timer?.cancel();
      _timer = null;
    }
  }

  _setupTimer(){
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() {
        dotAmounts = (dotAmounts + 1) % 4; // 循环 0~3
        print("dotAmounts - $dotAmounts");
      });
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    _endTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(dotAmounts, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == 2 ? 0 : 2.0),
            child: SvgPicture.asset(
              'lib/customer_service/assets/loading_message.svg',
              package: "tencentcloud_ai_desk_customer",
              width: 14,
              height: 14,
            ),
          );
        }),
      ),
    );
  }
}
