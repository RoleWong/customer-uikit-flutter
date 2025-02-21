import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:tencentcloud_ai_desk_customer/import_proxy/import_proxy.dart';

class NativeImport implements ImportProxy {
  @override
  FlutterPluginRecord? getFlutterPluginRecord() {
    return FlutterPluginRecord();
  }
}

ImportProxy getImportProxy() => NativeImport();
