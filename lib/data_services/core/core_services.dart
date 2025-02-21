import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/screen_utils.dart';
import 'package:tencent_desk_i18n_tool/language_json/strings.g.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/tim_uikit_config.dart';


enum AppStatus { foreground, background }

// enum TDeskLanguageEnum {
//   /// Chinese, Traditional
//   zhHant,
//
//   /// Chinese, Simplified
//   zhHans,
//
//   /// English
//   en,
//
//   /// Korean
//   // ko,
//
//   /// Japanese
//   ja,
//
//   /// Indonesian
//   id,
// }

const languageLocaleToString = {
  TDeskAppLocale.zhHant: "zh-Hant",
  TDeskAppLocale.zhHans: "zh-Hans",
  TDeskAppLocale.en: "en",
  TDeskAppLocale.ja: "ja",
  // LanguageEnum.ko: "ko",
  TDeskAppLocale.id: "id",
};

const languageLocaleToDeskString = {
  TDeskAppLocale.zhHant: "zh-TW",
  TDeskAppLocale.zhHans: "zh",
  TDeskAppLocale.en: "en",
  TDeskAppLocale.ja: "ja",
  // LanguageEnum.ko: "ko",
  TDeskAppLocale.id: "id",
};

abstract class CoreServices {
  Future<bool?> init({
    required int sdkAppID,
    required LogLevelEnum loglevel,
    required V2TimSDKListener listener,

    /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
    ValueChanged<TIMCallback>? onTUIKitCallbackListener,
    TIMUIKitConfig? config,

    /// only support "en" and "zh" temporally
    TDeskAppLocale? language,
  });

  Future<void> setDataFromNative({
    required String userId,

    /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
    ValueChanged<TIMCallback>? onTUIKitCallbackListener,
    TIMUIKitConfig? config,

    /// only support "en" and "zh" temporally
    TDeskAppLocale? language,
  });

  Future login({
    required String userID,
    required String userSig,
  });

  Future logout();

  Future logoutWithoutClearData();

  Future unInit();

  Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({
    required List<String> userIDList,
  });

  // 注意：uikit的离线推送不支持TPNS
  // Note: uikit's offline push do not supports TPNS
  Future<V2TimCallback> setOfflinePushConfig({
    bool isTPNSToken = false,
    int businessID,
    required String token,
  });

  Future<V2TimCallback> setSelfInfo({
    required V2TimUserFullInfo userFullInfo,
  });

  Future<V2TimCallback> setOfflinePushStatus({
    required AppStatus status,
    int? totalCount,
  });

  setTheme({required TUITheme theme});

  setDarkTheme();

  setLightTheme();

  setDeviceType(DeviceType deviceType);
}
