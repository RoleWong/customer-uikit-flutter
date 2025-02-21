import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/manager/tencent_cloud_customer_manager_impl.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

class TencentCloudCustomerManager {
  static final TencentCloudCustomerManager _instance = TencentCloudCustomerManager._internal();

  TencentCloudCustomerManager._internal();

  factory TencentCloudCustomerManager() {
    return _instance;
  }

  final TencentCloudCustomerManagerImpl _tencentCloudCustomerManagerImpl = TencentCloudCustomerManagerImpl();

  Future<V2TimCallback> init({
    required int sdkAppID,
    required String userID,
    required String userSig,
    TencentCloudCustomerConfig? config,
  }) async {
    return _tencentCloudCustomerManagerImpl.init(
      sdkAppID: sdkAppID,
      userID: userID,
      userSig: userSig,
      config: config,
    );
  }

  V2TimCallback navigate({
    required BuildContext context,
    required String customerServiceID,
    TencentCloudCustomerConfig? config,
  }) {
    return _tencentCloudCustomerManagerImpl.navigate(
      customerServiceID: customerServiceID,
      config: config,
      context: context,
    );
  }

  Future<V2TimCallback> dispose(){
    return _tencentCloudCustomerManagerImpl.dispose();
  }
}
