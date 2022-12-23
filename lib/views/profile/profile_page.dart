//import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_image_path.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/profile_common/edit_profile_page.dart';
import 'package:it_job_mobile/views/profile/profile_setting/profile_change_password/change_password_page.dart';
import 'package:it_job_mobile/views/profile/profile_setting/transactions/transaction_page.dart';
import 'package:it_job_mobile/views/wallet/introduce_page.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../../models/entity/applicant.dart';
import '../../providers/block_provider.dart';
import '../../shared/applicant_preferences.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/profile/profile_widget.dart';
import '../sign_in/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool value = true;
  bool isPasswordVisible = true;
  int? selectedProfile;

  @override
  void initState() {
    super.initState();
    final providerApplicant =
        Provider.of<ApplicantProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);

    providerApplicant.getApplicant();
    providerApplicant.getWallet();
    detailProfileProvider.getProfileApplicant();
    selectedProfile = ApplicantPreferences.getCurrentIndexProfileId(0);
  }

  @override
  Widget build(BuildContext context) {
    final providerApplicant = Provider.of<ApplicantProvider>(context);
    final detailProfileProvider = Provider.of<DetailProfileProvider>(context);
    final applicant = ApplicantPreferences.getUser(providerApplicant.applicant);
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Hồ Sơ',
              style: AppTextStyles.h3Black,
            ),
            toolbarHeight: 50,
            leadingWidth: 50,
            leading: Padding(
              padding: const EdgeInsets.all(5),
              child: PopupSelectProfile(
                menuList: [
                  if (providerApplicant.applicant.earnMoney == 1)
                    PopupMenuItem(
                      onTap: () async {
                        final productProvider = Provider.of<ProductProvider>(
                            context,
                            listen: false);
                        final providerApplicant =
                            Provider.of<ApplicantProvider>(context,
                                listen: false);
                        providerApplicant.getWalletAsync();
                        productProvider.getProducts(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.gift,
                            color: AppColor.black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Đổi thưởng",
                            style: AppTextStyles.h4Black,
                          )
                        ],
                      ),
                    ),
                  if (providerApplicant.applicant.earnMoney == 1)
                    PopupMenuItem(
                      onTap: () {
                        Future.delayed(
                            Duration.zero,
                            () => {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return TransactionPage();
                                  })),
                                });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.card_coin,
                            color: AppColor.black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Lịch sử giao dịch",
                            style: AppTextStyles.h4Black,
                          )
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    onTap: () {
                      final provider =
                          Provider.of<BlockProvider>(context, listen: false);
                      provider.getBlockedList(
                          context,
                          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id']
                              .toString());
                    },
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.buildings4,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Công ty đã chặn",
                          style: AppTextStyles.h4Black,
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Future.delayed(
                          Duration.zero,
                          () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChangePasswordPage();
                                })),
                              });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.key,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Đổi mật khẩu",
                          style: AppTextStyles.h4Black,
                        )
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: () async {
                      FirebaseMessaging.instance.unsubscribeFromTopic(
                          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id']
                              .toString());
                      // FirebaseMessaging.instance
                      //     .getToken()
                      //     .then((token) async => {
                      //           await FirebaseFirestore.instance
                      //               .collection("userTokens")
                      //               .doc(Jwt.parseJwt(
                      //                       ApplicantPreferences.getToken(
                      //                           ''))['Id']
                      //                   .toString())
                      //               .set({'token': ''}),
                      //         });
                      FirebaseFirestore.instance
                          .collection("userTokens")
                          .doc(Jwt.parseJwt(
                                  ApplicantPreferences.getToken(''))['Id']
                              .toString())
                          .delete();
                      final applicantProvider = Provider.of<ApplicantProvider>(
                          context,
                          listen: false);
                      final detailProfileProvider =
                          Provider.of<DetailProfileProvider>(context,
                              listen: false);
                      applicantProvider.applicant = Applicant(
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
                      detailProfileProvider.profileApplicants = [];
                      ApplicantPreferences.clear();
                      Future.delayed(
                          Duration.zero,
                          () async => {
                                await Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()),
                                    (route) => false),
                              });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Đăng xuất",
                          style: AppTextStyles.h4Black,
                        )
                      ],
                    ),
                  ),
                ],
                icon: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grey,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Icon(
                          Iconsax.more,
                          size: 18,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              if (providerApplicant.applicant.earnMoney == 2) Container(),
              if (providerApplicant.applicant.earnMoney == 1)
                Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () async => {
                                  if (isPasswordVisible)
                                    {
                                      await providerApplicant.getWalletAsync(),
                                    },
                                  setState(() =>
                                      isPasswordVisible = !isPasswordVisible)
                                },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColor.black,
                              size: 22,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 5,
                              left: 5,
                            ),
                            child: SizedBox(
                              width: 22.w,
                              height: 25,
                              child: Row(
                                mainAxisAlignment: isPasswordVisible
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isPasswordVisible) ...[
                                    Text(
                                      "*****",
                                      style: AppTextStyles.h3White,
                                      textAlign: TextAlign.center,
                                    ),
                                  ] else ...[
                                    Text(
                                      providerApplicant.wallet
                                          .toString()
                                          .substring(
                                              0,
                                              providerApplicant.wallet
                                                      .toString()
                                                      .length -
                                                  2),
                                      style: AppTextStyles.h4White,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Iconsax.buy_crypto,
                                      color: AppColor.white,
                                      size: 20,
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              if (providerApplicant.applicant.earnMoney == 0)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      icon: Icon(
                        Iconsax.card_coin,
                        color: AppColor.black,
                        size: 25,
                      ),
                      splashRadius: 1,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => IntroducePage()),
                        );
                      }),
                ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          ProfileWidget(
            imagePath: applicant.avatar,
            onClicked: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return EditProfilePage(
                  applicant: applicant,
                );
              }));
              setState(() {});
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    applicant.name,
                    style: AppTextStyles.h2Black,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Icon(
                    Iconsax.verify,
                    color: providerApplicant.applicant.earnMoney == 1
                        ? AppColor.blue
                        : AppColor.grey,
                    size: 30,
                  )
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
          SizedBox(
            height: 70.h,
            child: ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.top,
                list: [
                  BezierCurveSection(
                    start: Offset(100.w, 0),
                    top: Offset(50.w, 30),
                    end: Offset(0, 0),
                  ),
                ],
              ),
              child: Container(
                color: AppColor.primary,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    if (detailProfileProvider.profileApplicants.length <= 2)
                      GestureDetector(
                        onTap: () {
                          final detailProfileProvider =
                              Provider.of<DetailProfileProvider>(context,
                                  listen: false);
                          detailProfileProvider.newProfileApplicant(
                              context, true);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColor.white.withOpacity(0),
                                  width: 2),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade100,
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tạo Hồ Sơ Mới",
                                style: AppTextStyles.h4Black,
                              ),
                              Image.asset(
                                ImagePath.createProfile,
                                width: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: detailProfileProvider.isLoadListProfile
                          ? Center(
                              child: SpinKitCircle(
                              size: 80,
                              color: AppColor.black,
                            ))
                          : ListView.builder(
                              itemCount: detailProfileProvider
                                  .profileApplicants.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedProfile = index;
                                      ApplicantPreferences
                                          .setCurrentIndexProfile(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0,
                                    ),
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                        color: detailProfileProvider
                                                    .profileApplicants[index]
                                                    .status ==
                                                0
                                            ? AppColor.white
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: selectedProfile == index
                                                ? (detailProfileProvider
                                                            .profileApplicants[
                                                                index]
                                                            .status ==
                                                        0
                                                    ? AppColor.blue
                                                    : AppColor.personLogo)
                                                : AppColor.white.withOpacity(0),
                                            width: 2),
                                        boxShadow: [
                                          selectedProfile == index
                                              ? BoxShadow(
                                                  color: Colors.blue.shade100,
                                                  offset: Offset(0, 3),
                                                  blurRadius: 10)
                                              : BoxShadow(
                                                  color: Colors.grey.shade100,
                                                  offset: Offset(0, 3),
                                                  blurRadius: 10)
                                        ]),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final detailProfileProvider =
                                                Provider.of<
                                                        DetailProfileProvider>(
                                                    context,
                                                    listen: false);
                                            detailProfileProvider
                                                .viewDetailProfile(
                                              context,
                                              detailProfileProvider
                                                  .profileApplicants[index].id,
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              selectedProfile == index
                                                  ? Image.asset(
                                                      ImagePath.selectedPerson,
                                                      width: 100,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 21,
                                                        left: 21,
                                                        top: 11,
                                                        bottom: 11,
                                                      ),
                                                      child: Image.asset(
                                                        ImagePath.person,
                                                        width: 60,
                                                      ),
                                                    ),
                                              Positioned(
                                                bottom: selectedProfile == index
                                                    ? 4
                                                    : 2,
                                                right: selectedProfile == index
                                                    ? 10
                                                    : 12,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColor.grey,
                                                        blurRadius: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipOval(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      color: AppColor.white,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  AppColor.grey,
                                                              blurRadius: 5,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipOval(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            color: AppColor
                                                                .personLogo,
                                                            child: Icon(
                                                              Iconsax.edit,
                                                              color:
                                                                  Colors.white,
                                                              size: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Hồ Sơ ${index + 1}",
                                                style: AppTextStyles.h3Black,
                                              ),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              if (detailProfileProvider
                                                      .profileApplicants[index]
                                                      .status ==
                                                  1)
                                                Text(
                                                  "(đang được ẩn)",
                                                  style: AppTextStyles.h4Black,
                                                ),
                                            ],
                                          ),
                                        ),
                                        selectedProfile == index
                                            ? Icon(Icons.check_circle,
                                                color: detailProfileProvider
                                                            .profileApplicants[
                                                                index]
                                                            .status ==
                                                        0
                                                    ? AppColor.blue
                                                    : AppColor.white)
                                            : Container()
                                      ],
                                    ),
                                  ),
                                );
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDeleteConfirmDialog(context, String id, DismissDirection direction) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bạn có đồng ý xoá hồ sơ này",
      btnOkText: "Xóa",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {
        detailProfileProvider.getProfileApplicant();
      },
      btnOkOnPress: () {
        detailProfileProvider.deleteProfileById(context, id, direction);
      },
    ).show();
  }
}

class PopupSelectProfile extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const PopupSelectProfile({
    Key? key,
    required this.menuList,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      itemBuilder: ((context) => menuList),
      child: icon,
    );
  }
}
