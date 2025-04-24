

import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencentcloud_ai_desk_customer/ui/utils/platform.dart';

final outputLogger = TencentCloudChatLog();

class TencentCloudChatLog{
  void i(String text){
    if(!PlatformUtils().isWeb){
      TencentImSDKPlugin.v2TIMManager
          .uikitTrace(trace: text);
    }
  }
}