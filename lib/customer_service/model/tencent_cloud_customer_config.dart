import 'package:tencentcloud_ai_desk_customer/customer_service/model/tencent_cloud_customer_qucik_message.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services.dart';
import 'package:tencent_desk_i18n_tool/language_json/strings.g.dart';

class TencentCloudCustomerConfig {
  /// Sets the UI and conversation language for the customer service chat interface,
  /// affecting page labels, chatbot interactions, and other related elements.
  /// Supports English, Simplified Chinese, Traditional Chinese, Japanese, and Indonesian.
  /// Defaults to the system language if not specified.
  ///
  /// 设置客服聊天界面的界面语言和沟通语言，
  /// 影响页面标签、机器人交互等相关内容。
  /// 支持英语、简体中文、繁体中文、日语和印尼语。
  /// 若未指定，则默认使用系统语言。
  TDeskAppLocale? language;

  /// Determines whether the message read receipt feature is enabled.
  /// If you wish to enable this feature, ensure that your Chat application is on the Premium Edition.
  ///
  /// 是否启用消息已读回执能力。
  /// 如需使用该能力，请确保 IM 应用为旗舰版。
  bool? useMessageReadReceipt;

  /// Determines whether the default quick message button, 'Human Service' is enabled.
  ///
  /// 是否启用默认的 "人工服务" 快捷语按钮。
  bool? showTransferToHumanButton;

  List<TencentCloudCustomerQuickMessage>? additionalQuickMessages;

  TencentCloudCustomerConfig({
    this.language,
    this.useMessageReadReceipt,
    this.showTransferToHumanButton,
    List<TencentCloudCustomerQuickMessage>? additionalQuickMessages,
  });

  TencentCloudCustomerConfig mergeWith(TencentCloudCustomerConfig? other) {
    return TencentCloudCustomerConfig(
      language: other?.language ?? language,
      useMessageReadReceipt: other?.useMessageReadReceipt ?? useMessageReadReceipt ?? false,
      showTransferToHumanButton: other?.showTransferToHumanButton ?? showTransferToHumanButton ?? true,
      additionalQuickMessages: other?.additionalQuickMessages ?? additionalQuickMessages ?? const [],
    );
  }
}
