
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_callback.dart';

class TIMUIKitClass {
  static final TCustomerCoreServicesImpl _coreServices =
      serviceLocator<TCustomerCoreServicesImpl>();

  static void onTIMCallback(TIMCallback callbackValue) {
    _coreServices.callOnCallback(callbackValue);
  }
}
