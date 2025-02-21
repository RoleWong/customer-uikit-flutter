import 'package:flutter/cupertino.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/common/utils.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-rating/rating-number.dart';
import 'package:tencentcloud_ai_desk_customer/customer_service/plugin/components/message-rating/rating-star.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class MessageRating extends StatefulWidget {
  final dynamic payload;
  final Function onSubmitRating;
  const MessageRating({super.key, this.payload, required this.onSubmitRating});

  @override
  State<StatefulWidget> createState() => _MessageRatingState();
}

class _MessageRatingState extends TIMState<MessageRating> {
  @override
  Widget timBuild(BuildContext context) {
    int type = widget.payload['type'];
    if (type == RATING_TEMPLATE_TYPE.STAR) {
      return RatingStar(
        payload: widget.payload,
        onSubmitRating: widget.onSubmitRating,
      );
    }
    return RatingNumber(
      payload: widget.payload,
      onSubmitRating: widget.onSubmitRating,
    );
  }
}
