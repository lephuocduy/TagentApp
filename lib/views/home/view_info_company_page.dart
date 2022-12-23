import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/toast.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/repositories/implement/blocks_implement.dart';
import 'package:it_job_mobile/views/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:it_job_mobile/widgets/button/button_share_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_image_path.dart';
import '../../models/entity/company.dart';
import '../../models/entity/featured_job_post.dart';
import '../../models/request/block_request.dart';
import '../../models/request/like_request.dart';
import '../../repositories/implement/likes_implement.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/post_provider.dart';
import '../../constants/url_api.dart';
import '../../shared/applicant_preferences.dart';

class ViewInfoCompanyPage extends StatefulWidget {
  final int typeLike;
  final bool view;
  final FeaturedJobPost companyInformation;
  final Company companyDetail;

  ViewInfoCompanyPage({
    Key? key,
    required this.typeLike,
    required this.view,
    required this.companyInformation,
    required this.companyDetail,
  }) : super(key: key);

  @override
  State<ViewInfoCompanyPage> createState() => _ViewInfoCompanyPageState();
}

class _ViewInfoCompanyPageState extends State<ViewInfoCompanyPage> {
  final controller = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context, listen: false);
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    final List<Widget> imageSliders =
        widget.companyInformation.albumImages.isNotEmpty
            ? widget.companyInformation.albumImages
                .map((item) => Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item.urlImage,
                                  fit: BoxFit.cover, width: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ))
                .toList()
            : [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (imageSliders.isNotEmpty)
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  items: imageSliders,
                ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      widget.companyDetail.name,
                      style: AppTextStyles.h2Black,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                  Image.network(
                    widget.companyDetail.logo,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Giới Thiệu',
                        style: AppTextStyles.h3Black,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90.w,
                        child: Text(
                          widget.companyDetail.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.settings,
                    size: 20,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    widget.companyDetail.companyType == 0
                        ? "Product"
                        : "Outsourcing",
                    style: AppTextStyles.h4Black,
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vị Trí Tuyển Dụng',
                        style: AppTextStyles.h3Black,
                      ),
                      if (widget
                          .companyInformation.jobPosition.name.isNotEmpty) ...[
                        Text(widget.companyInformation.jobPosition.name)
                      ] else ...[
                        for (var i = 0;
                            i < provider.listJobPosition.length;
                            i++)
                          if (widget.companyInformation.jobPositionId ==
                              provider.listJobPosition[i].id)
                            Text(provider.listJobPosition[i].name),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget
                          .companyInformation.workingStyle.name.isNotEmpty) ...[
                        Text(widget.companyInformation.workingStyle.name)
                      ] else ...[
                        for (var i = 0;
                            i < provider.listWorkingStyle.length;
                            i++)
                          if (widget.companyInformation.workingStyleId ==
                              provider.listWorkingStyle[i].id)
                            Text(provider.listWorkingStyle[i].name),
                      ],
                      Text(
                        'Số lượng: ${widget.companyInformation.quantity}',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              if (widget.companyInformation.jobPostSkills.isNotEmpty)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Kỹ Năng Yêu Cầu',
                          style: AppTextStyles.h3Black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    for (var jobPostSkill
                        in widget.companyInformation.jobPostSkills)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var i = 0;
                                  i < provider.listSkill.length;
                                  i++)
                                if (jobPostSkill.skillId ==
                                    provider.listSkill[i].id)
                                  Text(provider.listSkill[i].name),
                              Text(jobPostSkill.skillLevel),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
                      )
                  ],
                ),
              SizedBox(
                height: 1.h,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mô Tả',
                        style: AppTextStyles.h3Black,
                      ),
                      const Icon(Icons.business_center_outlined)
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90.w,
                        child: Html(
                          data: widget.companyInformation.description,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thông Tin Liên Lạc',
                        style: AppTextStyles.h3Black,
                      ),
                      const Icon(Icons.call_outlined)
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Email: ${widget.companyDetail.email}")
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Số điện thoại: ${widget.companyDetail.phone}")
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Website: ${widget.companyDetail.website}")
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Địa chỉ: ${widget.companyInformation.workingPlace}")
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                        onTap: () {
                          _showBlockConfirmDialog(context);
                        },
                        child: Container(
                          height: 5.h,
                          width: 100.w,
                          alignment: Alignment.center,
                          color: AppColor.white,
                          child: Text(
                            "Chặn công ty",
                            style: AppTextStyles.h4Red,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Icon(
                Icons.clear,
                size: 40,
              ),
              style: ButtonStyle(
                elevation: getElevation(),
                shape: getShape(),
                minimumSize: getSize(),
                foregroundColor: getColor(AppColor.red, AppColor.white),
                backgroundColor: getColor(AppColor.white, AppColor.red),
                side: getBorder(AppColor.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.companyInformation.status == 0
                    ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setState) {
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
                                  "Chia Sẻ Bài Tuyển Dụng",
                                  style: AppTextStyles.h3Black,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.search,
                                  controller: controller,
                                  onChanged: (String query) async =>
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
                                    contentPadding: EdgeInsets.only(top: 15),
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
                                              color: AppColor.black,
                                            ),
                                            onTap: () {
                                              name = '';
                                              controller.text = '';
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
                                  return (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                      ? Center(
                                          child: SpinKitCircle(
                                          size: 80,
                                          color: AppColor.black,
                                        ))
                                      : ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            var data = snapshot
                                                .data!.docs[index]
                                                .data() as Map<String, dynamic>;
                                            if (name.isEmpty) {
                                              return ListTile(
                                                title: Text(
                                                  data['name'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyles.h4Black,
                                                ),
                                                leading: ClipOval(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    color: Colors.blueAccent,
                                                    child: ClipOval(
                                                      child: Material(
                                                        color: Colors.black,
                                                        child: Ink.image(
                                                          image: data['urlImage']
                                                                  .contains(
                                                                      'https://')
                                                              ? CachedNetworkImageProvider(
                                                                  data[
                                                                      'urlImage'])
                                                              : const AssetImage(
                                                                      ImagePath
                                                                          .defaultAvatar)
                                                                  as ImageProvider,
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                trailing: ButtonShareWidget(
                                                  chatId: data['chatId'],
                                                  id: data['id'],
                                                  name: data['name'],
                                                  jobPostId: widget
                                                      .companyInformation.id,
                                                ),
                                              );
                                            }
                                            if (data['name']
                                                .toString()
                                                .toLowerCase()
                                                .startsWith(
                                                    name.toLowerCase())) {
                                              return ListTile(
                                                title: Text(
                                                  data['name'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyles.h4Black,
                                                ),
                                                leading: ClipOval(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    color: Colors.blueAccent,
                                                    child: ClipOval(
                                                      child: Material(
                                                        color: Colors.black,
                                                        child: Ink.image(
                                                          image: data['urlImage']
                                                                  .contains(
                                                                      'https://')
                                                              ? CachedNetworkImageProvider(
                                                                  data[
                                                                      'urlImage'])
                                                              : const AssetImage(
                                                                      ImagePath
                                                                          .defaultAvatar)
                                                                  as ImageProvider,
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                trailing: ButtonShareWidget(
                                                  chatId: data['chatId'],
                                                  id: data['id'],
                                                  name: data['name'],
                                                  jobPostId: widget
                                                      .companyInformation.id,
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
                      )
                    : showToastFail("Bài tuyển dụng này đã hết hạn");
              },
              child: const Icon(
                Icons.share_outlined,
                size: 40,
              ),
              style: ButtonStyle(
                elevation: getElevation(),
                shape: getShape(),
                minimumSize: getSize(),
                foregroundColor: getColor(
                  AppColor.blue,
                  AppColor.white,
                ),
                backgroundColor: getColor(
                  AppColor.white,
                  AppColor.blue,
                ),
                side: getBorder(
                  AppColor.blue,
                ),
              ),
            ),
            if (!widget.view)
              ElevatedButton(
                onPressed: () async {
                  final providerApplicant =
                      Provider.of<ApplicantProvider>(context, listen: false);
                  final detailProfileProvider =
                      Provider.of<DetailProfileProvider>(context,
                          listen: false);
                  final provider =
                      Provider.of<PostProvider>(context, listen: false);
                  var check = await LikesImplement().checkLiked(
                      UrlApi.likes,
                      widget.companyInformation.id,
                      detailProfileProvider
                          .profileApplicants[
                              ApplicantPreferences.getCurrentIndexProfileId(0)]
                          .id);
                  if (check.msg == "Not found") {
                    var value = await LikesImplement().like(
                      UrlApi.likes,
                      LikeRequest(
                        jobPostId: widget.companyInformation.id,
                        profileApplicantId: detailProfileProvider
                            .profileApplicants[
                                ApplicantPreferences.getCurrentIndexProfileId(
                                    0)]
                            .id,
                        isProfileApplicantLike: true,
                        //isJobPostLike: false,
                      ),
                      ApplicantPreferences.getToken(''),
                    );

                    if (value.msg != "outOfLikes") {
                      if (widget.typeLike == 0) {
                        if (providerApplicant.applicant.earnMoney == 1) {
                          cancelToast();
                          showToastBonus(
                              "+ ${provider.configuration.earnByLike} Coin");
                        }
                        provider.like();
                        Navigator.pop(context);
                      } else if (widget.typeLike == 1) {
                        if (providerApplicant.applicant.earnMoney == 1) {
                          cancelToast();
                          showToastBonus(
                              "+ ${provider.configuration.earnByMatch} Coin");
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BottomTabBar(
                                      currentIndex: 1,
                                    )),
                            (route) => false);
                      } else if (widget.typeLike == 2) {
                        if (providerApplicant.applicant.earnMoney == 1) {
                          cancelToast();
                          showToastBonus(
                              "+ ${provider.configuration.earnByLike} Coin");
                        }
                        Navigator.pop(context);
                      }
                    } else {
                      showToastFail(
                          "Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
                    }
                  } else {
                    if (check.data[0].match) {
                      showToastFail(
                          "Bạn đã kết nối với bài tuyển dụng này rồi");
                    } else {
                      showToastFail("Bạn đã thích bài tuyển dụng này rồi");
                    }
                  }
                },
                child: const Icon(
                  Icons.thumb_up_alt,
                  size: 40,
                ),
                style: ButtonStyle(
                  elevation: getElevation(),
                  shape: getShape(),
                  minimumSize: getSize(),
                  foregroundColor: getColor(AppColor.success, AppColor.white),
                  backgroundColor: getColor(AppColor.white, AppColor.success),
                  side: getBorder(AppColor.success),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _showBlockConfirmDialog(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Chặn công ty này?",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        final applicantProvider =
            Provider.of<ApplicantProvider>(context, listen: false);
        final provider = Provider.of<PostProvider>(context, listen: false);
        BlocksImplement().block(
          UrlApi.blocks,
          BlockRequest(
            companyId: widget.companyInformation.companyId,
            applicantId: applicantProvider.applicant.id,
            blockBy: applicantProvider.applicant.id,
          ),
          ApplicantPreferences.getToken(''),
        );
        provider.like();
        Navigator.pop(context);
      },
    ).show();
  }

  MaterialStateProperty<double> getElevation() {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return 3;
      } else {
        return 3;
      }
    });
  }

  MaterialStateProperty<OutlinedBorder> getShape() {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return const CircleBorder();
      } else {
        return const CircleBorder();
      }
    });
  }

  MaterialStateProperty<Size> getSize() {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return const Size.square(70);
      } else {
        return const Size.square(70);
      }
    });
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    });
  }

  MaterialStateProperty<BorderSide> getBorder(Color color) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    });
  }
}
