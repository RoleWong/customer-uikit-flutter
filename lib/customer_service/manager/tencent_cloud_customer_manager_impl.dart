import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/data/tencent_cloud_customer_data.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/utils/tencent_cloud_customer_logger.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/utils/tencent_cloud_customer_toast.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/widgets/tencent_cloud_customer_message_container.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

typedef TencentCloudCustomerInit = Future<V2TimCallback> Function(
    {TencentCloudCustomerConfig? config, required int sdkAppID, required String userID, required String userSig});
typedef TencentCloudCustomerNavigate = V2TimCallback Function(
    {TencentCloudCustomerConfig? config, required BuildContext context, required String customerServiceID});
typedef TencentCloudCustomerDispose = Future<V2TimCallback> Function();

class TencentCloudCustomerManagerImpl {
  final TCustomerCoreServicesImpl _timCoreInstance = TencentCloudAIDeskCustomer.getIMUIKitInstance();
  late TencentCloudCustomerData _tencentCloudCustomerData;

  V2TimCallback? _initializedFailedRes;

  Future<V2TimCallback> init({
    required int sdkAppID,
    required String userID,
    required String userSig,
    TencentCloudCustomerConfig? config,
  }) async {
    setupIMServiceLocator();
    TencentCloudCustomerLogger().init();

    _tencentCloudCustomerData = serviceLocator<TencentCloudCustomerData>();

    if (sdkAppID.toString().startsWith('1400') || sdkAppID.toString().startsWith('160')) {
      _tencentCloudCustomerData.tDeskDataCenter = TDeskDataCenter.mainlandChina;
    }else{
      _tencentCloudCustomerData.tDeskDataCenter = TDeskDataCenter.international;
    }
    final initRes = await _timCoreInstance.init(
      sdkAppID: sdkAppID,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener(),
      language: config?.language,
      onTUIKitCallbackListener: (TIMCallback callbackValue) {
        switch (callbackValue.type) {
          case TIMCallbackType.INFO:
            // Shows the recommend text for info callback directly
            TencentCloudCustomerToast.toast(callbackValue.infoRecommendText ?? "");
            break;
          case TIMCallbackType.API_ERROR:
            //Prints the API error to console, and shows the error message.
            print("Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
            if (callbackValue.infoRecommendText != null && callbackValue.infoRecommendText!.isNotEmpty) {
              TencentCloudCustomerToast.toast(callbackValue.infoRecommendText ?? "");
            } else {
              TencentCloudCustomerToast.toast(callbackValue.errorMsg ?? callbackValue.errorCode.toString());
            }
            break;

          case TIMCallbackType.FLUTTER_ERROR:
          default:
            // prints the stack trace to console or shows the catch error
            if (callbackValue.catchError != null) {
              TencentCloudCustomerToast.toast(callbackValue.catchError.toString());
            } else {
              print(callbackValue.stackTrace);
            }
        }
      },
    );
    if (initRes ?? false) {
      final loginRes = await _timCoreInstance.login(
        userID: userID,
        userSig: userSig,
      );
      if (loginRes.code == 0) {
        _tencentCloudCustomerData.globalConfig = config ?? _tencentCloudCustomerData.globalConfig;
        _initializedFailedRes = null;
        TencentCloudCustomerLogger().reportLogin(
          sdkAppId: sdkAppID,
          userID: userID,
          userSig: userSig,
        );
      } else {
        _initializedFailedRes = loginRes;
      }
      return loginRes;
    } else {
      _initializedFailedRes = V2TimCallback(
        code: -1,
        desc: 'Init Failed',
      );
      return _initializedFailedRes!;
    }
  }

  V2TimCallback navigate({
    required BuildContext context,
    required String customerServiceID,
    TencentCloudCustomerConfig? config,
  }) {
    if (_initializedFailedRes != null) {
      return _initializedFailedRes!;
    }
    TencentCloudCustomerToast.init(context);
    final targetConfig = _tencentCloudCustomerData.globalConfig.mergeWith(config);
    if(config?.language != null){
      TDeskI18nUtils(null, languageLocaleToString[config?.language]);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TencentCloudCustomerMessageContainer(
          customerServiceUserID: customerServiceID,
          config: targetConfig,
        ),
      ),
    );
    return V2TimCallback(
      code: 0,
      desc: '',
    );
  }

  Future<V2TimCallback> dispose()  {
    _initializedFailedRes = null;
    return _timCoreInstance.logout();
  }
}
