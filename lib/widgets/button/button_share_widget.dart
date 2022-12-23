import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/models/request/share_job_post_request.dart';
import 'package:it_job_mobile/providers/post_provider.dart';
import 'package:it_job_mobile/repositories/implement/job_posts_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/toast.dart';
import '../../constants/app_text_style.dart';
import '../../providers/firebase_provider.dart';
import '../../shared/applicant_preferences.dart';
import '../../providers/applicant_provider.dart';

class ButtonShareWidget extends StatefulWidget {
  String chatId;
  String id;
  String name;
  String jobPostId;

  ButtonShareWidget({
    Key? key,
    required this.chatId,
    required this.id,
    required this.name,
    required this.jobPostId,
  }) : super(key: key);

  @override
  State<ButtonShareWidget> createState() => _ButtonShareWidgetState();
}

class _ButtonShareWidgetState extends State<ButtonShareWidget> {
  bool shareJobPost = true;
  @override
  Widget build(BuildContext context) {
    final providerApplicant =
        Provider.of<ApplicantProvider>(context, listen: false);
    final providerPost = Provider.of<PostProvider>(context, listen: false);
    return SizedBox(
      width: 100,
      height: 3.h,
      child: ElevatedButton(
        onPressed: shareJobPost
            ? () async {
                await FirebaseProvider.getAllowChat(context, widget.chatId)
                    .then((value) async => {
                          if (value!.allow)
                            {
                              JobPostsImplement()
                                  .shareJobPost(
                                    UrlApi.transactionJobPosts,
                                    ShareJobPostRequest(
                                      jobPostId: widget.jobPostId,
                                      createBy: Jwt.parseJwt(
                                              ApplicantPreferences.getToken(
                                                  ''))['Id']
                                          .toString(),
                                      receiver: widget.id,
                                    ),
                                    ApplicantPreferences.getToken(''),
                                  )
                                  .then((value) async => {
                                        if (value.msg != "outOfShares")
                                          {
                                            FirebaseProvider.uploadMessage(
                                              context,
                                              widget.id,
                                              widget.chatId,
                                              widget.jobPostId,
                                              value.data!.messageId,
                                              true,
                                            ),
                                            FirebaseProvider.getTokenChatUser(
                                                    context, widget.id)
                                                .then((value) => {
                                                      FirebaseProvider
                                                          .postNotification(
                                                        value!.token!,
                                                        "Đã chia sẻ bài tuyển dụng với bạn",
                                                        widget.name,
                                                      ),
                                                    }),
                                            if (providerApplicant
                                                    .applicant.earnMoney ==
                                                1)
                                              {
                                                cancelToast(),
                                                showToastBonus(
                                                    "+ ${providerPost.configuration.earnByShare} Coin"),
                                              },
                                            setState(() {
                                              shareJobPost = false;
                                            }),
                                          }
                                      }),
                            }
                          else
                            {
                              showToastFail("Bạn chưa thể gửi tin nhắn"),
                            }
                        });
              }
            : null,
        child: Text(
          shareJobPost ? 'Chia sẻ' : 'Đã gửi',
          style: AppTextStyles.h4White,
        ),
        style: ElevatedButton.styleFrom(
          primary: AppColor.black,
          onSurface: AppColor.black,
        ),
      ),
    );
  }
}
