import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/models/entity/user.dart';
import 'package:it_job_mobile/providers/firebase_provider.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/toast.dart';
import '../../constants/app_image_path.dart';
import '../../models/entity/applicant.dart';
import '../../providers/applicant_provider.dart';
import '../../repositories/implement/applicants_implement.dart';
import '../../constants/url_api.dart';
import '../../widgets/chat/chat_body_widget.dart';
import '../../widgets/chat/chat_header_widget.dart';
import 'chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Applicant applicant = Applicant(
      id: '',
      phone: '',
      email: '',
      name: '',
      avatar: '',
      gender: 2,
      dob: DateTime.now(),
      address: '',
      earnMoney: 0,
    );
    String phone = '';
    String name = '';

    Timer? debouncer;

    @override
    void dispose() {
      debouncer?.cancel();
      super.dispose();
    }

    void debounce(
      VoidCallback callback, {
      Duration duration = const Duration(milliseconds: 1000),
    }) {
      if (debouncer != null) {
        debouncer!.cancel();
      }

      debouncer = Timer(duration, callback);
    }

    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              ImagePath.logo,
              fit: BoxFit.fill,
              width: 10.w,
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              "Tagent",
              style: AppTextStyles.h2Black,
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(top: 15, right: 20),
              child: IconButton(
                icon: Icon(
                  Iconsax.user_add,
                  color: AppColor.black,
                ),
                splashRadius: 20,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: AppColor.primary,
                        insetPadding: EdgeInsets.all(20),
                        titlePadding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 20,
                        ),
                        title: Text(
                          "Thêm bạn",
                          style: AppTextStyles.h3Black,
                        ),
                        content: SizedBox(
                          height: applicant.id.isNotEmpty ? 140 : 80,
                          width: 100.w,
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.search,
                                  controller: controller,
                                  onChanged: (value) {
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value != null && value.length != 10) {
                                      return "Số điện thoại phải là 10 số";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: 15,
                                      left: 20,
                                    ),
                                    prefixIcon: Icon(
                                      Iconsax.search_normal,
                                      color: phone.isEmpty
                                          ? AppColor.darkGrey
                                          : AppColor.black,
                                      size: 20,
                                    ),
                                    suffixIcon: phone.isNotEmpty
                                        ? GestureDetector(
                                            child: Icon(
                                              Icons.close,
                                              color: AppColor.black,
                                            ),
                                            onTap: () {
                                              phone = '';
                                              controller.text = '';
                                              controller.clear();
                                            },
                                          )
                                        : null,
                                    hintText: "Nhập số điện thoại",
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              if (applicant.id.isNotEmpty)
                                Container(
                                  color: AppColor.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                color: Colors.blueAccent,
                                                child: ClipOval(
                                                  child: Material(
                                                    color: Colors.black,
                                                    child: Ink.image(
                                                      image: applicant.avatar
                                                              .contains(
                                                                  'https://')
                                                          ? CachedNetworkImageProvider(applicant.avatar)
                                                          : const AssetImage(
                                                                  ImagePath
                                                                      .defaultAvatar)
                                                              as ImageProvider,
                                                      fit: BoxFit.cover,
                                                      width: 10.w,
                                                      height: 10.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              applicant.name,
                                              style: AppTextStyles.h4Black,
                                            ),
                                          ],
                                        ),
                                        ButtonDefault(
                                          width: 110,
                                          height: 3.h,
                                          content: "Thêm bạn",
                                          textStyle: AppTextStyles.h4White,
                                          backgroundBtn: AppColor.black,
                                          voidCallBack: () async {
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            await FirebaseProvider
                                                .addFriendChat(
                                              applicantProvider.applicant,
                                              applicant,
                                            );
                                            try {
                                              await FirebaseProvider
                                                      .getTokenChatUser(
                                                          context, applicant.id)
                                                  .then((value) => {
                                                        FirebaseProvider
                                                            .postNotification(
                                                          value!.token!,
                                                          "Vừa kết bạn với bạn",
                                                          applicantProvider
                                                              .applicant.name,
                                                        ),
                                                      });
                                            } catch (e) {}

                                            showToastSuccess(
                                                "Thêm bạn thành công");
                                            Navigator.pop(
                                              context,
                                            );
                                            setState(() {
                                              phone = '';
                                              controller.clear();
                                              applicant = Applicant(
                                                id: '',
                                                phone: '',
                                                email: '',
                                                name: '',
                                                avatar: '',
                                                gender: 2,
                                                dob: DateTime.now(),
                                                address: '',
                                                earnMoney: 0,
                                              );
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                var snapshot;

                                final isValidForm =
                                    formKey.currentState!.validate();
                                if (isValidForm) {
                                  ApplicantsImplement()
                                      .checkPhoneAddFriend(
                                          UrlApi.applicant, controller.text)
                                      .then((value) async => {
                                            if (value.msg != "notExist")
                                              {
                                                if (value.data!.id !=
                                                    applicantProvider
                                                        .applicant.id)
                                                  {
                                                    snapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'users/${applicantProvider.applicant.id}/user')
                                                            .doc(value.data!.id)
                                                            .get(),
                                                    if (snapshot.exists)
                                                      {
                                                        showToastFail(
                                                            "Đã có trong danh sách chat"),
                                                      }
                                                    else
                                                      {
                                                        setState(() {
                                                          applicant =
                                                              value.data!;
                                                        })
                                                      }
                                                  }
                                                else
                                                  {
                                                    showToastFail(
                                                        "Không thể kết bạn với chính mình"),
                                                  }
                                              }
                                          });
                                }
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Text(
                                "Tìm",
                                style: AppTextStyles.h4Black,
                              )),
                        ],
                      );
                    }),
                  );
                },
              )),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder<List<User>>(
        stream: FirebaseProvider.getUsers(applicantProvider.applicant.id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: SpinKitCircle(
                size: 80,
                color: AppColor.black,
              ));
            default:
              if (snapshot.hasError) {
                return buildText('Đã xảy ra sai sót, hãy thử lại sau');
              } else {
                final users = snapshot.data;
                return users!.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Danh sách trò chuyện",
                                  style: AppTextStyles.h3Black,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: AppColor.primary,
                                          insetPadding: EdgeInsets.all(20),
                                          titlePadding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          title: Column(
                                            children: [
                                              Text(
                                                "Tìm Bạn Bè Trong Danh Sách",
                                                style: AppTextStyles.h3Black,
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              TextFormField(
                                                autofocus: true,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                textInputAction:
                                                    TextInputAction.search,
                                                controller: controller,
                                                onChanged:
                                                    (String query) async =>
                                                        debounce(() async {
                                                  try {
                                                    setState(() {
                                                      name = query;
                                                    });
                                                  } catch (e) {
                                                    //
                                                  }
                                                }),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(top: 15),
                                                  prefixIcon: Icon(
                                                    Iconsax.search_normal,
                                                    color: name.isEmpty
                                                        ? AppColor.darkGrey
                                                        : AppColor.black,
                                                    size: 20,
                                                  ),
                                                  suffixIcon: name.isNotEmpty
                                                      ? GestureDetector(
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                                AppColor.black,
                                                          ),
                                                          onTap: () {
                                                            name = '';
                                                            controller.text =
                                                                '';
                                                            controller.clear();
                                                          },
                                                        )
                                                      : null,
                                                  hintText: "Tìm bạn bè",
                                                  filled: true,
                                                  fillColor: AppColor.white,
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 100.h,
                                            width: 100.w,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      'users/${applicantProvider.applicant.id}/user')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return (snapshot
                                                            .connectionState ==
                                                        ConnectionState.waiting)
                                                    ? Center(
                                                        child: SpinKitCircle(
                                                        size: 80,
                                                        color: AppColor.black,
                                                      ))
                                                    : ListView.builder(
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var data = snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .data()
                                                              as Map<String,
                                                                  dynamic>;
                                                          if (name.isEmpty) {
                                                            return ListTile(
                                                              title: Text(
                                                                data['name'],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    AppTextStyles
                                                                        .h4Black,
                                                              ),
                                                              leading: ClipOval(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(1),
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .black,
                                                                      child: Ink
                                                                          .image(
                                                                        image: data['urlImage'].contains('https://')
                                                                            ? CachedNetworkImageProvider(data['urlImage'])
                                                                            : const AssetImage(ImagePath.defaultAvatar)
                                                                                as ImageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              trailing:
                                                                  ButtonDefault(
                                                                width: 105,
                                                                height: 3.h,
                                                                content:
                                                                    "Nhắn tin",
                                                                textStyle:
                                                                    AppTextStyles
                                                                        .h4White,
                                                                backgroundBtn:
                                                                    AppColor
                                                                        .black,
                                                                voidCallBack:
                                                                    () async {
                                                                  await FirebaseProvider.getAllowChat(
                                                                          context,
                                                                          data[
                                                                              'chatId'])
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                Navigator.of(context).push(
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => ChatPage(
                                                                                      allowChat: value!,
                                                                                      urlImage: data['urlImage'],
                                                                                      name: data['name'],
                                                                                      id: data['id'],
                                                                                      chatId: data['chatId'],
                                                                                      searchFriend: true,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              });
                                                                },
                                                              ),
                                                            );
                                                          }
                                                          if (data['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .startsWith(name
                                                                  .toLowerCase())) {
                                                            return ListTile(
                                                              title: Text(
                                                                data['name'],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    AppTextStyles
                                                                        .h4Black,
                                                              ),
                                                              leading: ClipOval(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(1),
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .black,
                                                                      child: Ink
                                                                          .image(
                                                                        image: data['urlImage'].contains('https://')
                                                                            ? CachedNetworkImageProvider(data['urlImage'])
                                                                            : const AssetImage(ImagePath.defaultAvatar)
                                                                                as ImageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              trailing:
                                                                  ButtonDefault(
                                                                width: 105,
                                                                height: 3.h,
                                                                content:
                                                                    "Nhắn tin",
                                                                textStyle:
                                                                    AppTextStyles
                                                                        .h4White,
                                                                backgroundBtn:
                                                                    AppColor
                                                                        .black,
                                                                voidCallBack:
                                                                    () async {
                                                                  await FirebaseProvider.getAllowChat(
                                                                          context,
                                                                          data[
                                                                              'chatId'])
                                                                      .then(
                                                                          (value) =>
                                                                              {
                                                                                Navigator.of(context).push(
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => ChatPage(
                                                                                      allowChat: value!,
                                                                                      urlImage: data['urlImage'],
                                                                                      name: data['name'],
                                                                                      id: data['id'],
                                                                                      chatId: data['chatId'],
                                                                                      searchFriend: true,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              });
                                                                },
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        });
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Thoát",
                                                  style: AppTextStyles.h4Black,
                                                )),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                  icon: Icon(
                                    Iconsax.search_normal,
                                    color: AppColor.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ChatHeaderWidget(users: users),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tin nhắn",
                                  style: AppTextStyles.h3Black,
                                ),
                              ],
                            ),
                          ),
                          ChatBodyWidget(users: users),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Chưa có cuộc trò chuyện nào",
                          style: AppTextStyles.h3Black,
                        ),
                      );
              }
          }
        },
      )),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: AppTextStyles.h3Black,
        ),
      );
}
