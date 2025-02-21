import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/model/tencent_cloud_customer_config.dart';

enum TDeskDataCenter {
  mainlandChina,
  international,
}

class TencentCloudCustomerData extends ChangeNotifier {
  TencentCloudCustomerConfig globalConfig = TencentCloudCustomerConfig();

  TDeskDataCenter tDeskDataCenter = TDeskDataCenter.international;
}
