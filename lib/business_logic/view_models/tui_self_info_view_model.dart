import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';

class TCustomerSelfInfoViewModel extends ChangeNotifier {
  V2TimUserFullInfo? _loginInfo;
  TIMUIKitConfig? _globalConfig;

  TIMUIKitConfig? get globalConfig => _globalConfig;

  set globalConfig(TIMUIKitConfig? value) {
    _globalConfig = value;
    notifyListeners();
  }

  V2TimUserFullInfo? get loginInfo {
    return _loginInfo;
  }

  setLoginInfo(V2TimUserFullInfo? value) {
    _loginInfo = value;
    notifyListeners();
  }
}
