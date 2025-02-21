import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';
import 'package:tencentcloud_ai_desk_customer/ui/widgets/avatar.dart';

class TencentCloudCustomerMessageHeader extends StatelessWidget {
  final V2TimConversation? conversation;
  final String? headerLabel;

  const TencentCloudCustomerMessageHeader({super.key, this.conversation, this.headerLabel});

  @override
  Widget build(BuildContext context) {
    final option1 = TencentDeskUtils.checkString(conversation?.showName) ??
        TencentDeskUtils.checkString(conversation?.userID) ??
        TDesk_t("智能客服");
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 16,
        right: 10,
        bottom: 20,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 6,
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  "images/arrow_back.png",
                  package: "tencentcloud_ai_desk_customer",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
          if (TencentDeskUtils.checkString(conversation?.faceUrl) != null)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: Avatar(
                borderRadius: BorderRadius.circular(18),
                faceUrl: conversation!.faceUrl!,
                showName: TencentDeskUtils.checkString(conversation?.showName) ??
                    TencentDeskUtils.checkString(conversation?.userID) ??
                    TDesk_t("智能客服"),
              ),
            ),
          Text(
            TencentDeskUtils.checkString(headerLabel) ?? TDesk_t_para("Hi，我是{{option1}}", "Hi，我是$option1")(option1: option1),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
