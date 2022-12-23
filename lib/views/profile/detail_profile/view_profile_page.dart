import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';

import 'package:it_job_mobile/views/profile/detail_profile/profile_certificate/view_profile_certificate_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_contact/view_profile_contact.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_description/view_profile_description_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_education/view_profile_education_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_image/view_profile_image_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_job_position/view_profile_job_position_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_project/view_profile_project.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_skill/view_profle_skill.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_status_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_working_experience/view_profile_working_experience_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_working_style/view_profile_working_style_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  List<String> categories = ["Xem chi tiết", "Chỉnh sửa"];
  int selectedIndex = 0;
  @override
  void initState() {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    detailProfileProvider.status =
        detailProfileProvider.detailProfile!.status == 0 ? true : false;
    detailProfileProvider.statusValue = detailProfileProvider.status!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                height: 16.h,
                color: AppColor.primary,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Hủy',
                              style: AppTextStyles.h3Black,
                            ),
                          ),
                        ),
                        centerTitle: true,
                        title: ProfileStatusPage(),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: InkWell(
                              onTap: () {
                                if (detailProfileProvider.detailProfile!.jobPositionId.isEmpty ||
                                    detailProfileProvider
                                        .detailProfile!.jobPositionId.isEmpty ||
                                    detailProfileProvider
                                        .listProfileSkill.isEmpty) {
                                  _showValidationDialog(context,
                                      "Kĩ năng, vị trí, hình thức làm việc không được trống");
                                  return;
                                } else {
                                  detailProfileProvider.updateDetailProfile(
                                    detailProfileProvider.detailProfile!.id,
                                    detailProfileProvider
                                        .detailProfile!.createDate,
                                    detailProfileProvider
                                        .detailProfile!.education,
                                    detailProfileProvider
                                        .detailProfile!.githubLink,
                                    detailProfileProvider
                                        .detailProfile!.linkedInLink,
                                    detailProfileProvider
                                        .detailProfile!.facebookLink,
                                    detailProfileProvider
                                        .detailProfile!.jobPositionId,
                                    detailProfileProvider
                                        .detailProfile!.workingStyleId,
                                    detailProfileProvider.detailProfile!.status,
                                    context,
                                  );
                                }
                              },
                              child: Text(
                                'Lưu',
                                style: AppTextStyles.h3Black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 4.h,
                          child: Row(
                            children: [
                              for (var i = 0; i < categories.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = i;
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 11.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          categories[i],
                                          style: selectedIndex == i
                                              ? AppTextStyles.h3Black
                                              : AppTextStyles.h3Grey,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          height: 2,
                                          width: 30,
                                          color: selectedIndex == i
                                              ? AppColor.black
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 85.h,
                child: SingleChildScrollView(
                    controller: detailProfileProvider.scrollController,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ViewProfileImagePage(
                          profileApplicantId:
                              detailProfileProvider.detailProfile!.id,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileDescriptionPage(
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileJobPosition(
                          jobPositionId: detailProfileProvider
                              .detailProfile!.jobPositionId,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileWorkingStyle(
                          workingStyleId: detailProfileProvider
                              .detailProfile!.workingStyleId,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileSkill(
                          profileApplicantId:
                              detailProfileProvider.detailProfile!.id,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileCertificate(
                          profileApplicantId:
                              detailProfileProvider.detailProfile!.id,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileWorkingExperiencePage(
                          profileApplicantId:
                              detailProfileProvider.detailProfile!.id,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileProject(
                          profileApplicantId:
                              detailProfileProvider.detailProfile!.id,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileEducation(
                          education:
                              detailProfileProvider.detailProfile!.education,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ViewProfileContact(
                          githubLink:
                              detailProfileProvider.detailProfile!.githubLink,
                          linkedInLink:
                              detailProfileProvider.detailProfile!.linkedInLink,
                          facebookLink:
                              detailProfileProvider.detailProfile!.facebookLink,
                          selectedIndex: selectedIndex,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    )),
              ),
            ],
          ),
          if (detailProfileProvider.isLoading)
            Container(
              color: AppColor.primary,
              child: Center(
                child: SpinKitCircle(
                  size: 140,
                  color: AppColor.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _showValidationDialog(context, String textValidationError) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: "Thông tin chưa đúng yêu cầu",
      desc: textValidationError,
      btnOkText: "Chỉnh sửa",
      btnOkOnPress: () {
        detailProfileProvider.scrollValidation();
      },
    ).show();
  }
}
