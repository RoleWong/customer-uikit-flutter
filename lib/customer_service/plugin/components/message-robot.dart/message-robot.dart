import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-robot.dart/robot-card.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-robot.dart/robot-text.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageRobot extends StatefulWidget {
  final dynamic payload;
  const MessageRobot({super.key, this.payload});

  @override
  State<StatefulWidget> createState() => _MessageRobotState();
}

class _MessageRobotState extends TIMState<MessageRobot> {
  @override
  Widget timBuild(BuildContext context) {
    String type = widget.payload.content.type;
    if (type == ROBOT_MESSAGE_TYPE.QUESTION_LIST) {
      return RobotCard(
        payload: widget.payload.content,
        onClickItem: () => {},
      );
    }
    return RobotText(
      payload: widget.payload.content,
    );
  }
}
