import 'package:tencent_im_base/base_widgets/tim_callback.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/core/core_services_implements.dart';
import 'package:tencentcloud_ai_desk_customer/data_services/services_locatar.dart';

class TIMUIKitClass {
  static final TCustomerCoreServicesImpl _coreServices =
      serviceLocator<TCustomerCoreServicesImpl>();

  static void onTIMCallback(TIMCallback callbackValue) {
    _coreServices.callOnCallback(callbackValue);
  }
}
