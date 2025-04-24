import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/theme/tui_theme.dart';
import 'package:tencentcloud_ai_desk_customer/theme/color.dart';

class TUIThemeViewModel extends ChangeNotifier {
  TUITheme _theme = CommonColor.defaultTheme;

  TUITheme get theme {
    return _theme;
  }

  set theme(TUITheme theme) {
    _theme = theme;
    notifyListeners();
  }
}
