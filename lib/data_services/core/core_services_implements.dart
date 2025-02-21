// ignore_for_file: avoid_print

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_setting_model.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/common_utils.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/logger.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/screen_utils.dart';
import 'package:tencent_desk_i18n_tool/language_json/strings.g.dart';
import 'package:tencent_desk_i18n_tool/tools/i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/listener_model/tui_group_listener_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/tim_uikit_config.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/platform.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/web_support/uikit_web_support.dart'
    if (dart.library.html) 'package:tencentcloud_ai_desk_customer/data_services/core/web_support/uikit_web_support_implement.dart';

typedef EmptyAvatarBuilder = Widget Function(BuildContext context);

class LoginInfo {
  final String userID;
  final String userSig;
  final int sdkAppID;
  final V2TimUserFullInfo? loginUser;

  LoginInfo(
      {this.sdkAppID = 0, this.userSig = "", this.userID = "", this.loginUser});
}

class TCustomerCoreServicesImpl implements CoreServices {
  V2TimUserFullInfo? _loginInfo;
  late int _sdkAppID;
  late String _userID;
  late String _userSig;
  ValueChanged<TIMCallback>? onCallback;
  VoidCallback? webLoginSuccess;
  bool isLoginSuccess = false;

  V2TimUserFullInfo? get loginUserInfo {
    return _loginInfo;
  }

  LoginInfo get loginInfo {
    return LoginInfo(
        sdkAppID: _sdkAppID,
        userID: _userID,
        userSig: _userSig,
        loginUser: _loginInfo);
  }

  EmptyAvatarBuilder? _emptyAvatarBuilder;

  EmptyAvatarBuilder? get emptyAvatarBuilder {
    return _emptyAvatarBuilder;
  }

  setEmptyAvatarBuilder(EmptyAvatarBuilder builder) {
    _emptyAvatarBuilder = builder;
  }

  setGlobalConfig(TIMUIKitConfig? config) {
    final TCustomerSelfInfoViewModel selfInfoViewModel =
        serviceLocator<TCustomerSelfInfoViewModel>();
    final TCustomerSettingModel settingModel = serviceLocator<TCustomerSettingModel>();
    selfInfoViewModel.globalConfig = config;
    settingModel.init();
  }

  addIdentifier() {
    TUIKitWebSupport.addSetterToWindow();
    TUIKitWebSupport.addIdentifierToWindow();
  }

  @override
  Future<bool?> init(
      {
      /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
      ValueChanged<TIMCallback>? onTUIKitCallbackListener,
      required int sdkAppID,
      required LogLevelEnum loglevel,
      required V2TimSDKListener listener,
        TDeskAppLocale? language,
      String? extraLanguage,
      TIMUIKitConfig? config,

      /// Specify the current device platform, mobile or desktop, based on your needs.
      /// TUIKit will automatically determine the platform if no specification is provided. DeviceType? platform,
      DeviceType? platform,
      String? uikitLogPath,
      VoidCallback? onWebLoginSuccess}) async {
    if (platform != null) {
      TUIKitScreenUtils.deviceType = platform;
    }
    addIdentifier();
    if (extraLanguage != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        TDeskI18nUtils(null, extraLanguage);
      });
    } else if (language != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        TDeskI18nUtils(null, languageLocaleToString[language]);
      });
    }
    if (onTUIKitCallbackListener != null) {
      onCallback = onTUIKitCallbackListener;
    }
    setGlobalConfig(config);
    _sdkAppID = sdkAppID;
    webLoginSuccess = onWebLoginSuccess;
    final result = await TencentImSDKPlugin.v2TIMManager.initSDK(
        sdkAppID: sdkAppID,
        loglevel: loglevel,
        listener: V2TimSDKListener(
            onConnectFailed: listener.onConnectFailed,
            onConnectSuccess: () {
              if (PlatformUtils().isWeb) {
                didLoginSuccess();
                if (onWebLoginSuccess != null) {
                  onWebLoginSuccess();
                }
              }
              listener.onConnectSuccess();
            },
            onConnecting: listener.onConnecting,
            onKickedOffline: listener.onKickedOffline,
            onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
              listener.onUserStatusChanged(userStatusList);
            },
            onSelfInfoUpdated: (V2TimUserFullInfo info) {
              listener.onSelfInfoUpdated(info);
              serviceLocator<TCustomerSelfInfoViewModel>().setLoginInfo(info);
              _loginInfo = info;
            },
            onUserSigExpired: listener.onUserSigExpired));
    return result.data;
  }

  /// This method is used for init the TUIKit after you initialized the IM SDK from Native SDK.
  @override
  Future<void> setDataFromNative({
    /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
    ValueChanged<TIMCallback>? onTUIKitCallbackListener,
    TDeskAppLocale? language,
    TIMUIKitConfig? config,
    String? extraLanguage,
    required String userId,
  }) async {
    _userID = userId;
    if (extraLanguage != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        TDeskI18nUtils(null, extraLanguage);
      });
    } else if (language != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        TDeskI18nUtils(null, languageLocaleToString[language]);
      });
    }
    if (onTUIKitCallbackListener != null) {
      onCallback = onTUIKitCallbackListener;
    }
    setGlobalConfig(config);
    if (!PlatformUtils().isWeb) {
      didLoginSuccess();
    }
  }

  void addInitListener() {
    final TCustomerConversationViewModel tuiConversationViewModel =
        serviceLocator<TCustomerConversationViewModel>();
    final TCustomerChatGlobalModel tuiChatViewModel =
        serviceLocator<TCustomerChatGlobalModel>();
    final TCustomerGroupListenerModel tuiGroupListenerModel =
        serviceLocator<TCustomerGroupListenerModel>();

    tuiConversationViewModel.setConversationListener();
    tuiChatViewModel.addAdvancedMsgListener();
    tuiGroupListenerModel.setGroupListener();
  }

  void removeListener() {
    final TCustomerConversationViewModel tuiConversationViewModel =
        serviceLocator<TCustomerConversationViewModel>();
    final TCustomerChatGlobalModel tuiChatViewModel =
        serviceLocator<TCustomerChatGlobalModel>();
    final TCustomerGroupListenerModel tuiGroupListenerModel =
        serviceLocator<TCustomerGroupListenerModel>();

    tuiConversationViewModel.removeConversationListener();
    tuiChatViewModel.removeAdvanceMsgListener();
    tuiGroupListenerModel.removeGroupListener();
  }

  callOnCallback(TIMCallback callbackValue) {
    if (onCallback != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        onCallback!(callbackValue);
      });
    } else {
      outputLogger.i(
          "TUIKit Callback: ${callbackValue.type} - ${callbackValue.stackTrace}");
    }
  }

  initDataModel() {
    final TCustomerConversationViewModel tuiConversationViewModel =
        serviceLocator<TCustomerConversationViewModel>();

    tuiConversationViewModel.initConversation();
  }

  clearData() {
    final TCustomerConversationViewModel tuiConversationViewModel =
        serviceLocator<TCustomerConversationViewModel>();
    final TCustomerChatGlobalModel tuiChatViewModel =
        serviceLocator<TCustomerChatGlobalModel>();

    tuiConversationViewModel.clearData();
    tuiChatViewModel.clearData();
  }

  @override
  Future<V2TimCallback> login({
    required String userID,
    required String userSig,
  }) async {
    _userID = userID;
    _userSig = userSig;
    V2TimCallback result = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userID, userSig: userSig);
    if (!PlatformUtils().isWeb) {
      didLoginSuccess();
    }
    if (result.code != 0) {
      callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorCode: result.code,
          errorMsg: result.desc));
    }
    return result;
  }

  void didLoginSuccess() async {
    if (isLoginSuccess == true) {
      return;
    }
    isLoginSuccess = true;
    addInitListener();
    initDataModel();

    if (TencentDeskUtils.checkString(_userID) == null) {
      V2TimValueCallback<String> getLoginUserRes =
          await TencentImSDKPlugin.v2TIMManager.getLoginUser();
      if (getLoginUserRes.code == 0) {
        _userID = getLoginUserRes.data ?? "";
      }
    }

    getUsersInfoWithRetry();
  }

  void getUsersInfoWithRetry() async {
    V2TimValueCallback<List<V2TimUserFullInfo>>? res;
    bool success = false;

    while (!success) {
      res = await getUsersInfo(userIDList: [_userID]);
      if (res.code == 0 &&
          res.data != null &&
          res.data!.isNotEmpty &&
          res.data!.firstWhereOrNull((element) => element.userID == _userID) !=
              null) {
        success = true;
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    _loginInfo =
        res?.data!.firstWhereOrNull((element) => element.userID == _userID);
    final TCustomerSelfInfoViewModel selfInfoViewModel =
        serviceLocator<TCustomerSelfInfoViewModel>();
    if (_loginInfo != null) {
      selfInfoViewModel.setLoginInfo(_loginInfo);
    }
  }

  // Deprecated
  void didLoginOut() {
    removeListener();
    clearData();
    _loginInfo = null;
    serviceLocator<TCustomerSelfInfoViewModel>().setLoginInfo(_loginInfo);
  }

  @override
  Future<V2TimCallback> logout() async {
    final result = await TencentImSDKPlugin.v2TIMManager.logout();
    isLoginSuccess = false;
    removeListener();
    clearData();
    serviceLocator<TCustomerSelfInfoViewModel>().setLoginInfo(null);
    return result;
  }

  @override
  Future<V2TimCallback> logoutWithoutClearData() async {
    final result = await TencentImSDKPlugin.v2TIMManager.logout();
    isLoginSuccess = false;
    removeListener();
    serviceLocator<TCustomerSelfInfoViewModel>().setLoginInfo(null);
    return result;
  }

  @override
  Future unInit() async {
    final result = await TencentImSDKPlugin.v2TIMManager.unInitSDK();
    return result;
  }

  @override
  Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({
    required List<String> userIDList,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: userIDList);
  }

  @override
  Future<V2TimCallback> setOfflinePushConfig({
    required String token,
    bool isTPNSToken = false,
    int? businessID,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .getOfflinePushManager()
        .setOfflinePushConfig(
          businessID: businessID?.toDouble() ?? 0,
          token: token,
          isTPNSToken: isTPNSToken,
        );
  }

  @override
  Future<V2TimCallback> setSelfInfo({
    required V2TimUserFullInfo userFullInfo,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .setSelfInfo(userFullInfo: userFullInfo);
  }

  @override
  setTheme({required TUITheme theme}) {
    // 合并传入Theme和默认Theme
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    Map<String, Color?> jsonMap = Map.from(CommonColor.defaultTheme.toJson());
    Map<String, Color?> jsonInputThemeMap = Map.from(theme.toJson());

    jsonInputThemeMap.forEach((key, value) {
      if (value != null) {
        jsonMap.update(key, (v) => value);
      }
    });
    _theme.theme = TUITheme.fromJson(jsonMap);
  }

  @override
  setDarkTheme() {
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    _theme.theme = TUITheme.dark; //Dark
  }

  @override
  setLightTheme() {
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    _theme.theme = TUITheme.light; //Light
  }

  @override
  Future<V2TimCallback> setOfflinePushStatus(
      {required AppStatus status, int? totalCount}) {
    if (status == AppStatus.foreground) {
      return TencentImSDKPlugin.v2TIMManager
          .getOfflinePushManager()
          .doForeground();
    } else {
      return TencentImSDKPlugin.v2TIMManager
          .getOfflinePushManager()
          .doBackground(unreadCount: totalCount ?? 0);
    }
  }

  @override
  setDeviceType(DeviceType deviceType) {
    TUIKitScreenUtils.deviceType = deviceType;
  }
}
