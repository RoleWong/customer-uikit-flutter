import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-formSave/formSave-branch.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-formSave/formSave-input.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageFormSave extends StatefulWidget {
  final dynamic payload;
  final Function onSubmitForm;
  const MessageFormSave({super.key, this.payload, required this.onSubmitForm});

  @override
  State<StatefulWidget> createState() => _MessageFormSaveState();
}

class _MessageFormSaveState extends TIMState<MessageFormSave> {
  @override
  Widget timBuild(BuildContext context) {
    int type = widget.payload['type'];
    if (type == 0) {
      return FormSaveInput(
          payload: widget.payload, onSubmitInput: widget.onSubmitForm);
    }
    return FormSaveBranch(
      payload: widget.payload,
      onClickItem: widget.onSubmitForm,
    );
  }
}
