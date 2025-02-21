import 'package:get_it/get_it.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/listener_model/tui_group_listener_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/separate_models/tui_chat_model_tools.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_setting_model.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/data/tencent_cloud_customer_data.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/conversation/conversation_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/conversation/conversation_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/friendShip/friendship_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/friendShip/friendship_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/group/group_services.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/group/group_services_implement.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/message/message_service_implement.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/message/message_services.dart';
import 'package:tencentcloud_ai_desk_customer/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_im_base/theme/tui_theme_view_model.dart';

final serviceLocator = GetIt.instance;
bool boolIsInitailized = false;

void setupIMServiceLocator() {
  if (!boolIsInitailized) {
    // setting
    serviceLocator.registerSingleton<TCustomerSettingModel>(TCustomerSettingModel());

    // services
    serviceLocator.registerSingleton<TCustomerCoreServicesImpl>(TCustomerCoreServicesImpl());
    serviceLocator
        .registerSingleton<TCustomerSelfInfoViewModel>(TCustomerSelfInfoViewModel());
    serviceLocator
        .registerSingleton<TCustomerConversationService>(TCustomerConversationServicesImpl());
    serviceLocator.registerSingleton<TCustomerMessageService>(TCustomerMessageServiceImpl());
    serviceLocator
        .registerSingleton<TCustomerFriendshipServices>(TCustomerFriendshipServicesImpl());
    serviceLocator.registerSingleton<TCustomerGroupServices>(TCustomerGroupServicesImpl());

    // view models
    serviceLocator.registerSingleton<TCustomerChatGlobalModel>(TCustomerChatGlobalModel());
    serviceLocator.registerSingleton<TCustomerChatModelTools>(TCustomerChatModelTools());
    serviceLocator.registerSingleton<TCustomerConversationViewModel>(
        TCustomerConversationViewModel());

    try{
      if (!serviceLocator.isRegistered<TUIThemeViewModel>()) {
        serviceLocator.registerSingleton<TUIThemeViewModel>(TUIThemeViewModel());
      }
    }catch(e){
      print('TUIThemeViewModel already registered: $e');
    }

    // listener models
    serviceLocator
        .registerSingleton<TCustomerGroupListenerModel>(TCustomerGroupListenerModel());

    // Desk Data
    serviceLocator
        .registerSingleton<TencentCloudCustomerData>(TencentCloudCustomerData());

    boolIsInitailized = true;
  }
}
