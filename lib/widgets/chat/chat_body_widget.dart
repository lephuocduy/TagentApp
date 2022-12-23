import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/widgets/chat/dismissible_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../models/entity/user.dart';
import '../../providers/firebase_provider.dart';
import '../../views/bottom_tab_bar/bottom_tab_bar.dart';
import '../../views/chat/chat_page.dart';
import '../../providers/applicant_provider.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<User> users;
  const ChatBodyWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
        child: buildChats(),
      ),
    );
  }

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final applicantProvider =
              Provider.of<ApplicantProvider>(context, listen: false);
          final user = users[index];
          return user.statusMessage
              ? DismissibleWidget(
                  item: user,
                  child: InkWell(
                    onTap: () async {
                      await FirebaseProvider.getAllowChat(context, user.chatId)
                          .then((value) => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      allowChat: value!,
                                      urlImage: user.urlImage,
                                      name: user.name,
                                      id: user.id!,
                                      chatId: user.chatId,
                                    ),
                                  ),
                                ),
                              });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                color: Colors.blueAccent,
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.black,
                                    child: Ink.image(
                                      image: user.urlImage.contains('https://')
                                          ? CachedNetworkImageProvider(user.urlImage)
                                          : const AssetImage(
                                                  ImagePath.defaultAvatar)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                      width: 18.w,
                                      height: 18.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: AppTextStyles.h4Black,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (user.lastMessage.isNotEmpty)
                                  user.lastMessageIsJobPost
                                      ? Text(
                                          user.id != user.lastMessageId
                                              ? "Bạn: vừa chia sẻ bài tuyển dụng"
                                              : "Đã chia sẻ bài tuyển dụng cho bạn",
                                          style: AppTextStyles.h5Black,
                                        )
                                      : Text(
                                          user.id != user.lastMessageId
                                              ? ("Bạn: " +
                                                  (user.lastMessage.length < 24
                                                      ? user.lastMessage
                                                      : user.lastMessage
                                                              .substring(
                                                                  0, 24) +
                                                          "..."))
                                              : user.lastMessage.length < 28
                                                  ? user.lastMessage
                                                  : user.lastMessage
                                                          .substring(0, 28) +
                                                      "...",
                                          style: AppTextStyles.h5Black,
                                        ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        ),
                        if (user.lastMessage.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(user.lastMessageTime),
                                style: AppTextStyles.h5Black,
                              ),
                              Text(
                                DateFormat('hh:mm:ss')
                                    .format(user.lastMessageTime),
                                style: AppTextStyles.h5Black,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) => {
                    _showDeleteConfirmDialog(
                      context,
                      applicantProvider.applicant.id,
                      user.id!,
                      user.chatId,
                      direction,
                    )
                  },
                )
              : Container();
        },
      );

  _showDeleteConfirmDialog(context, String id, String userId, String chatId,
      DismissDirection direction) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bạn có đồng ý xoá đoạn tin nhắn này",
      btnOkText: "Xóa",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => BottomTabBar(
                      currentIndex: 2,
                    )),
            (route) => false);
      },
      btnOkOnPress: () {
        FirebaseProvider.deleteMessages(
          context,
          id,
          userId,
          chatId,
          direction,
        );
      },
    ).show();
  }
}
