import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-form/mobile_form.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageFormInputMobile extends StatefulWidget {
  final dynamic payload;
  final Function({V2TimMessage? messageInfo}) onSubmitForm;

  const MessageFormInputMobile({super.key, required this.payload, required this.onSubmitForm});

  @override
  State<StatefulWidget> createState() => _MessageFormInputStateMobile();
}

class _MessageFormInputStateMobile extends TIMState<MessageFormInputMobile> {
  bool _didSubmitted = false;

  Future<int?> _showBasicModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet<int>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/customer_service/assets/customer_background.png',
              package: "tencentcloud_ai_desk_customer",
            ),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: TencentCloudCustomerMobileForm(
          payload: widget.payload,
          onSubmitForm: ({messageInfo}) {
            widget.onSubmitForm(messageInfo: messageInfo);
            setState(() {
              _didSubmitted = true;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget timBuild(BuildContext context) {
    const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10));
    final nodeStatus = widget.payload['nodeStatus'] ?? 2;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Image(
                      image: AssetImage(
                        "lib/customer_service/assets/formIcon.png",
                        package: "tencentcloud_ai_desk_customer",
                      ),
                      height: 66,
                      width: 66),
                  if (nodeStatus == 2 || _didSubmitted == true)
                    const Positioned(
                      right: 0.6,
                      bottom: 0,
                      child: Image(
                        image: AssetImage(
                          "lib/customer_service/assets/formCheckIcon.png",
                          package: "tencentcloud_ai_desk_customer",
                        ),
                      ),
                      height: 26,
                      width: 26,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (nodeStatus != 1) {
                      _showBasicModalBottomSheet(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C66E5),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      ),
                    ),
                    child: (nodeStatus == 0 && _didSubmitted == false)
                        ? Text(
                            TDesk_t("立即填写"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )
                        : Text(
                            TDesk_t(nodeStatus == 1 ? "不可编辑" : "查看内容"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
