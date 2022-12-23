import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/allow_chat.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../providers/applicant_provider.dart';
import '../../widgets/chat/messages_widget.dart';
import '../../widgets/chat/new_message_widget.dart';
import '../bottom_tab_bar/bottom_tab_bar.dart';

class ChatPage extends StatelessWidget {
  final AllowChat allowChat;
  final String urlImage;
  final String name;
  final String id;
  final String chatId;
  bool searchFriend;

  ChatPage({
    Key? key,
    required this.allowChat,
    required this.urlImage,
    required this.name,
    required this.id,
    required this.chatId,
    this.searchFriend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    String myId = applicantProvider.applicant.id;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: BackButton(
          color: AppColor.black,
          onPressed: searchFriend
              ? () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => BottomTabBar(
                                currentIndex: 2,
                              )),
                      (route) => false);
                }
              : () {
                  Navigator.pop(context);
                },
        ),
        centerTitle: true,
        title: Column(children: [
          ClipOval(
            child: Container(
              padding: const EdgeInsets.all(1),
              color: Colors.blueAccent,
              child: ClipOval(
                child: Material(
                  color: Colors.black,
                  child: Ink.image(
                    image: urlImage.contains('https://')
                        ? CachedNetworkImageProvider(urlImage)
                        : const AssetImage(ImagePath.defaultAvatar)
                            as ImageProvider,
                    fit: BoxFit.cover,
                    width: 8.w,
                    height: 8.w,
                  ),
                ),
              ),
            ),
          ),
          Text(
            name,
            style: AppTextStyles.h3Black,
          ),
        ]),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: MessagesWidget(
                  allowChat: allowChat,
                  myId: myId,
                  myName: applicantProvider.applicant.name,
                  userName: name,
                  userId: id,
                  chatId: chatId,
                ),
              ),
            ),
            NewMessageWidget(
              name: name,
              id: id,
              chatId: chatId,
            ),
          ],
        ),
      ),
    );
  }
}
