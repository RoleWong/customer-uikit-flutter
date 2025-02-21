library tencentcloud_ai_desk_customer;

import 'package:tencentcloud_ai_desk_customer/customer_service/manager/tencent_cloud_customer_manager.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/manager/tencent_cloud_customer_manager_impl.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'data_services/core/core_services_implements.dart';
export 'data_services/core/core_services_implements.dart';
export 'package:tencent_im_base/theme/tui_theme.dart';
export 'package:tencent_im_base/theme/color.dart';

// Sticker
export 'package:tim_ui_kit_sticker_plugin/tim_ui_kit_sticker_plugin.dart';

// Widgets
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/tim_uikit_chat.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
export 'package:tencentcloud_ai_desk_customer/ui/widgets/unread_message.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_more_panel.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_controller.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKitAppBar/tim_uikit_appbar.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list.dart';
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field.dart';
export 'package:tencent_im_base/tencent_im_base.dart';
export 'package:tencentcloud_ai_desk_customer/ui/widgets/link_preview/models/link_preview_content.dart';
export 'package:tencentcloud_ai_desk_customer/ui/widgets/column_menu.dart';

// Enum
export 'package:tencentcloud_ai_desk_customer/ui/theme/tim_uikit_message_theme.dart';

// Config
export 'package:tencentcloud_ai_desk_customer/ui/views/TIMUIKitChat/tim_uikit_chat_config.dart';
export 'package:permission_handler/permission_handler.dart';

// Utils
export 'package:tencentcloud_ai_desk_customer/ui/utils/common_utils.dart';
export 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

// Customer
export 'package:tencentcloud_ai_desk_customer/customer_service/model/tencent_cloud_customer_config.dart';

// I18N
export 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';

/// Tencent Cloud AI Desk Customer Integration Class
/// [TencentCloudCustomer] has been renamed to [TencentCloudAIDeskCustomer] for naming consistency
class TencentCloudAIDeskCustomer {
  static TencentCloudCustomerManager get _manager => TencentCloudCustomerManager();
  static TencentCloudCustomerInit get init => _manager.init;
  static TencentCloudCustomerNavigate get navigate => _manager.navigate;
  static TencentCloudCustomerDispose get dispose => _manager.dispose;

  /// Initializes and retrieves the core Chat service implementation instance
  /// Requires prior initialization of the service locator
  static TCustomerCoreServicesImpl getIMUIKitInstance() {
    setupIMServiceLocator();
    return serviceLocator<TCustomerCoreServicesImpl>();
  }

  /// Provides direct access to the underlying V2TIMManager instance
  /// from Tencent Chat SDK plugin
  static V2TIMManager getIMSDKInstance() {
    return TencentImSDKPlugin.v2TIMManager;
  }
}

/// @deprecated [TencentCloudCustomer] is obsolete and scheduled for removal.
/// Migrate to [TencentCloudAIDeskCustomer] immediately.
@Deprecated('This class will be decommissioned in Q2 2025. Use TencentCloudAIDeskCustomer instead.')
class TencentCloudCustomer {
  @Deprecated('Access through TencentCloudAIDeskCustomer.init instead.')
  static TencentCloudCustomerInit get init => TencentCloudAIDeskCustomer.init;

  @Deprecated('Access through  TencentCloudAIDeskCustomer.navigate instead.')
  static TencentCloudCustomerNavigate get navigate => TencentCloudAIDeskCustomer.navigate;

  @Deprecated('Access through TencentCloudAIDeskCustomer.dispose.')
  static TencentCloudCustomerDispose get dispose => TencentCloudAIDeskCustomer.dispose;
}
