import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../models/entity/user.dart';
import '../../providers/firebase_provider.dart';
import '../../views/chat/chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;
  const ChatHeaderWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 12.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return buildImage(context, users[index]);
            }),
      ),
    );
  }

  Widget buildImage(BuildContext context, User user) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
              child: Container(
                height: 20.w,
                width: 18.w,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: AppColor.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Ink.image(
                  image: user.urlImage.contains('https://')
                      ? CachedNetworkImageProvider(user.urlImage)
                      : const AssetImage(ImagePath.defaultAvatar)
                          as ImageProvider,
                  fit: BoxFit.cover,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          _showDeleteConfirmDialog(
                            context,
                            user,
                            user.chatId,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.grey,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColor.white,
                            child: Icon(
                              Icons.cancel,
                              color: AppColor.black,
                              size: 20,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
          Text(
            user.name,
            style: AppTextStyles.h5Black,
          ),
        ],
      );

  _showDeleteConfirmDialog(context, User user, String chatId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bạn có đồng ý xoá liên hệ này",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await FirebaseProvider.deleteFriend(context, user, chatId);
      },
    ).show();
  }
}
