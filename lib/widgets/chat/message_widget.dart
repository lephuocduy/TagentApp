import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_image_path.dart';
import '../../models/entity/message.dart';
import '../../providers/post_provider.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            radius: 16,
            backgroundImage: message.urlImage.contains('https://')
                ? CachedNetworkImageProvider(message.urlImage)
                : const AssetImage(ImagePath.defaultAvatar) as ImageProvider,
          ),
        message.isJobPost
            ? InkWell(
                onTap: () {
                  postProvider.getJobPostShare(context, message.message);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: width * 3 / 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: isMe
                        ? borderRadius
                            .subtract(BorderRadius.only(bottomRight: radius))
                        : borderRadius
                            .subtract(BorderRadius.only(bottomLeft: radius)),
                  ),
                  child: buildMessageShare(),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: width * 3 / 4),
                decoration: BoxDecoration(
                  color: isMe ? Colors.grey[100] : Colors.green[100],
                  borderRadius: isMe
                      ? borderRadius
                          .subtract(BorderRadius.only(bottomRight: radius))
                      : borderRadius
                          .subtract(BorderRadius.only(bottomLeft: radius)),
                ),
                child: buildMessage(),
              ),
      ],
    );
  }

  Widget buildMessageShare() {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isMe
              ? "Bạn vừa chia sẻ bài tuyển dụng"
              : "Đã chia sẻ bài tuyển dụng cho bạn",
          style: TextStyle(
            color: AppColor.white,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
        SizedBox(
          height: 1.h,
        ),
        SvgPicture.asset(
          ImagePath.jobPostEmpty,
          fit: BoxFit.cover,
          width: 30.w,
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          "Bấm vào để xem",
          style: TextStyle(
            color: AppColor.white,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        )
      ],
    );
  }

  Widget buildMessage() {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message.message,
          style: TextStyle(
            color: isMe ? AppColor.black : AppColor.white,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        )
      ],
    );
  }
}
