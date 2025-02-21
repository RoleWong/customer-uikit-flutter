import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class IntlCameraPickerTextDelegate extends CameraPickerTextDelegate {
  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  @override
  String get confirm => TDesk_t('确认');

  /// Tips string above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字
  @override
  String get shootingTips => TDesk_t('轻触拍照，长按摄像');

  /// Tips string above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字
  @override
  String get shootingWithRecordingTips => TDesk_t('轻触拍照，长按摄像');

  /// Load failed string for item.
  /// 资源加载失败时的字段
  @override
  String get loadFailed => TDesk_t('加载失败');

  /// Default loading string for the dialog.
  /// 加载中弹窗的默认文字
  @override
  String get loading => TDesk_t('加载中…');

  /// Saving string for the dialog.
  /// 保存中弹窗的默认文字
  @override
  String get saving => TDesk_t('保存中…');

  /// Semantics fields.
  ///
  /// Fields below are only for semantics usage. For customizable these fields,
  /// head over to [EnglishCameraPickerTextDelegate] for better understanding.
  @override
  String get sActionManuallyFocusHint => TDesk_t('手动聚焦');

  @override
  String get sActionPreviewHint => TDesk_t('预览');

  @override
  String get sActionRecordHint => TDesk_t('录像');

  @override
  String get sActionShootHint => TDesk_t('拍照');

  @override
  String get sActionShootingButtonTooltip => TDesk_t('拍照按钮');

  @override
  String get sActionStopRecordingHint => TDesk_t('停止录像');

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) {
    switch (value) {
      case CameraLensDirection.front:
        return TDesk_t('前置');
      case CameraLensDirection.back:
        return TDesk_t('后置');
      case CameraLensDirection.external:
        return TDesk_t('外置');
    }
  }

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    final option1 = sCameraLensDirectionLabel(value);
    return TDesk_t_para("{{option1}} 画面预览", "$option1 画面预览")(option1: option1);
  }

  @override
  String sFlashModeLabel(FlashMode mode) {
    final String _modeString;
    switch (mode) {
      case FlashMode.off:
        _modeString = TDesk_t('关闭');
        break;
      case FlashMode.auto:
        _modeString = TDesk_t('自动');
        break;
      case FlashMode.always:
        _modeString = TDesk_t('拍照时闪光');
        break;
      case FlashMode.torch:
        _modeString = TDesk_t('始终闪光');
        break;
    }
    final option2 = _modeString;
    return TDesk_t_para("闪光模式: {{option2}}", "闪光模式: $option2")(option2: option2);
  }

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) {
    final option3 = sCameraLensDirectionLabel(value);
    return TDesk_t_para("切换至 {{option3}} 摄像头", "切换至 $option3 摄像头")(
        option3: option3);
  }
}
