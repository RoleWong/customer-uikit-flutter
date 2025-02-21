import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageOrderCard extends StatefulWidget {
  final dynamic payload;
  const MessageOrderCard({super.key, this.payload});
  @override
  State<StatefulWidget> createState() => _MessageOrderCardState();
}

class _MessageOrderCardState extends TIMState<MessageOrderCard> {
  @override
  Widget timBuild(BuildContext context) {
    String guide = widget.payload['guide'] ?? '';
    String name = widget.payload['name'] ?? '';
    String desc = widget.payload['desc'] ?? '';
    String pic = widget.payload['pic'] ?? '';

    return Container(
      constraints: const BoxConstraints(maxWidth: 230),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(guide, style: const TextStyle(color: Colors.black, fontSize: 18)),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  pic,
                  height: 88,
                  width: 88.0,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {

                    return Container(
                      alignment: Alignment.center,
                      child: const Image(
                          image: AssetImage(
                            "lib/customer_service/assets/fail.png",
                            package:
                                "tencentcloud_ai_desk_customer",
                          ),
                          height: 88,
                          width: 88.0),
                      width: 88,
                      height: 88,
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  constraints: const BoxConstraints(minHeight: 88),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: const TextStyle(fontSize: 18),
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        style:
                            const TextStyle(fontSize: 16, color: Colors.deepOrange),
                        desc,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
