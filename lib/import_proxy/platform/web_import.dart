import 'package:tencentcloud_ai_desk_customer/import_proxy/import_proxy.dart';

class WebImport implements ImportProxy {
  @override
  void getFlutterPluginRecord() {
    return;
  }
}

ImportProxy getImportProxy() => WebImport();
