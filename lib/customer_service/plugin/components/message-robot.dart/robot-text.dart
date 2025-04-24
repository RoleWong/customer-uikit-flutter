import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';


class RobotText extends StatefulWidget {
  final dynamic payload;
  const RobotText({super.key, this.payload});

  @override
  State<StatefulWidget> createState() => _RobotTextState();
}

class _RobotTextState extends TIMState<RobotText> {
  @override
  Widget timBuild(BuildContext context) {
    return const Placeholder();
  }
}
