import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-show.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageRichText extends StatefulWidget {
  final dynamic payload;
  final Function? onTapLink;
  const MessageRichText({super.key, this.payload, this.onTapLink});
  @override
  State<StatefulWidget> createState() => _MessageRichTextState();
}

class _MessageRichTextState extends TIMState<MessageRichText> {
  List<String> imageList = [];
  String a = '';

  @override
  initState() {
    super.initState();
    a = widget.payload.toString();
    a = a.substring(1, a.length - 1);
    a = a.replaceAll('\\n', '\n');
    a = a.replaceAll('\\*', '*');
  }

  defaultTapLink(href) {
    final Uri _url = Uri.parse(href ?? '');

    canLaunchUrl(_url).then((a) {
      launchUrl(_url);
    }).catchError((e) {
    });
  }

  @override
  Widget timBuild(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 350),
        child: MarkdownBody(
            blockSyntaxes: const [],
            onTapLink: (text, href, title) {
              FocusScope.of(context).unfocus();
              if (widget.onTapLink == null) {
                defaultTapLink(href);
              } else {
                widget.onTapLink!(text, href, title);
              }
            },
            imageBuilder: (uri, title, alt) {
              imageList.add(uri.toString());
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      ZoomPageRoute(builder: (BuildContext context) {
                        return ImageMessageViewer(
                          imageList: imageList,
                          currentIndex: imageList.indexOf(uri.toString()),
                        );
                      }),
                    );
                  },
                  child: Image.network(width: 120, uri.toString()));
            },
            data: a));
  }
}
