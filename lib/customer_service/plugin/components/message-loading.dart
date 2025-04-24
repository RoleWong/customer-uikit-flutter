import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';


class MessageLoading extends StatefulWidget{
  final dynamic payload;
  final V2TimMessage message;
  const MessageLoading({super.key, this.payload, required this.message});

  @override
  State<MessageLoading> createState() => _MessageLoadingState();
}

class _MessageLoadingState extends State<MessageLoading> {
  int dotAmounts = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _setupTimer();
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
        dotAmounts = (dotAmounts + 1) % 4;
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
