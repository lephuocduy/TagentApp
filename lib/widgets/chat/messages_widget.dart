import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:provider/provider.dart';

import '../../constants/app_color.dart';
import '../../models/entity/allow_chat.dart';
import '../../models/entity/message.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/firebase_provider.dart';
import 'message_widget.dart';

class MessagesWidget extends StatefulWidget {
  AllowChat allowChat;
  final String myId;
  final String myName;
  final String userName;
  final String userId;
  final String chatId;

  MessagesWidget({
    required this.allowChat,
    required this.myId,
    required this.myName,
    required this.userName,
    required this.userId,
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseProvider.getMessages(widget.myId, widget.chatId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: SpinKitCircle(
                size: 80,
                color: AppColor.black,
              ));
            default:
              if (!widget.allowChat.allow &&
                  widget.myId == widget.allowChat.chatById) {
                return buildText('Bạn chưa thể gửi tin nhắn khi chưa được ' +
                    widget.userName +
                    ' cho phép');
              } else if (!widget.allowChat.allow &&
                  widget.myId != widget.allowChat.chatById) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nếu bạn bấm ",
                          style: AppTextStyles.h3Black,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseProvider.uploadAllowChat(
                              context,
                              widget.userId,
                              widget.chatId,
                            );
                            AllowChat allow;
                            await FirebaseProvider.getAllowChat(
                                    context, widget.chatId)
                                .then((value) => {
                                      allow = value!,
                                      setState(() {
                                        widget.allowChat = allow;
                                      }),
                                    });
                            await FirebaseProvider.getTokenChatUser(
                                    context, widget.userId)
                                .then((value) => {
                                      FirebaseProvider.postNotification(
                                        value!.token!,
                                        "Vừa chấp nhận cuộc trò chuyện với bạn",
                                        widget.myName,
                                      ),
                                    });
                          },
                          child: Text(
                            "Chấp Nhận",
                            style: AppTextStyles.h3DarkBlue,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Bạn và " +
                          widget.userName +
                          " có thể trò chuyện với nhau",
                      style: AppTextStyles.h3Black,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return buildText('Đã xảy ra sai sót, hãy thử lại sau');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final applicantProvider =
                              Provider.of<ApplicantProvider>(context,
                                  listen: false);
                          final message = messages[index];

                          return MessageWidget(
                            message: message,
                            isMe: message.applicantId ==
                                applicantProvider.applicant.id,
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: AppTextStyles.h3Black,
          textAlign: TextAlign.center,
        ),
      );
}
