
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/ui/widgets/link_preview/common/utils.dart';
import 'package:extended_text/extended_text.dart';

class HttpText extends SpecialText {
  HttpText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, flag, textStyle, onTap: onTap);
  static const String flag = '!@TURL#*&\$';
  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();

    return SpecialTextSpan(
        text: text,
        actualText: toString(),
        start: start!,

        ///caret can move into special text
        deleteAll: true,
        style: TextStyle(color: LinkUtils.hexToColor("015fff")),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTap != null) {
              onTap!(toString());
            }
          });
  }
}
