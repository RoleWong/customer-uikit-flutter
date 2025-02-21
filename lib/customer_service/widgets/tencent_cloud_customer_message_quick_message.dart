import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/model/tencent_cloud_customer_qucik_message.dart';

class TencentCloudCustomerMessageQuickMessage extends StatelessWidget {
  final TencentCloudCustomerQuickMessage quickMessage;

  const TencentCloudCustomerMessageQuickMessage({
    super.key,
    required this.quickMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(28),
        right: Radius.circular(28),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: quickMessage.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (quickMessage.icon != null)
                  Container(
                    child: quickMessage.icon!,
                    margin: const EdgeInsets.only(
                      right: 8,
                    ),
                  ),
                Text(quickMessage.label, style: const TextStyle(fontSize: 13),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
