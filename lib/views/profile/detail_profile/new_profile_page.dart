import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_certificate/view_profile_certificate_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_contact/view_profile_contact.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_description/view_profile_description_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_education/view_profile_education_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_image/view_profile_image_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_job_position/view_profile_job_position_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_project/view_profile_project.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_skill/view_profle_skill.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_working_experience/view_profile_working_experience_page.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_working_style/view_profile_working_style_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/detail_profile_provider.dart';

class NewProfilePage extends StatefulWidget {
  bool update;
  NewProfilePage({
    Key? key,
    this.update = true,
  }) : super(key: key);

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 11.h,
            color: AppColor.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: widget.update
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: InkWell(
                          onTap: () {
                            _showDeleteConfirmDialog(context);
                          },
                          child: Text(
                            'Hủy',
                            style: AppTextStyles.h3Black,
                          ),
                        ),
                      )
                    : null,
                centerTitle: true,
                title: Text(
                  'Tạo Hồ Sơ',
                  style: AppTextStyles.h3Black,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: InkWell(
                      onTap: () {
                        if (detailProfileProvider.detailProfile!.jobPositionId.isEmpty ||
                            detailProfileProvider
                                .detailProfile!.jobPositionId.isEmpty ||
                            detailProfileProvider.listProfileSkill.isEmpty) {
                          _showValidationDialog(context,
                              "Kĩ năng, vị trí, hình thức làm việc không được trống");
                          return;
                        } else {
                          _showCreateConfirmChangeProfileDialog(
                              context, widget.update);
                        }
                      },
                      child: Text(
                        'Xong',
                        style: AppTextStyles.h3Black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 90.h,
            child: SingleChildScrollView(
              controller: detailProfileProvider.scrollController,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ViewProfileImagePage(
                    profileApplicantId: detailProfileProvider.detailProfile!.id,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileDescriptionPage(),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileJobPosition(
                    jobPositionId:
                        detailProfileProvider.detailProfile!.jobPositionId,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileWorkingStyle(
                    workingStyleId:
                        detailProfileProvider.detailProfile!.workingStyleId,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileSkill(
                    profileApplicantId: detailProfileProvider.detailProfile!.id,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileCertificate(
                    profileApplicantId: detailProfileProvider.detailProfile!.id,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileWorkingExperiencePage(
                      profileApplicantId:
                          detailProfileProvider.detailProfile!.id),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileProject(
                      profileApplicantId:
                          detailProfileProvider.detailProfile!.id),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileEducation(
                    education: detailProfileProvider.detailProfile!.education,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ViewProfileContact(
                    githubLink: detailProfileProvider.detailProfile!.githubLink,
                    linkedInLink:
                        detailProfileProvider.detailProfile!.linkedInLink,
                    facebookLink:
                        detailProfileProvider.detailProfile!.facebookLink,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_showDeleteConfirmDialog(context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO,
    animType: AnimType.SCALE,
    title: "Xác Nhận",
    desc: "Bạn đồng ý hủy hồ sơ đang tạo",
    btnOkText: "Đồng ý",
    btnCancelText: "Hủy",
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      Navigator.pop(context);
    },
  ).show();
}

_showCreateConfirmChangeProfileDialog(context, bool update) {
  DetailProfileProvider detailProfileProvider =
      Provider.of<DetailProfileProvider>(context, listen: false);
  AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO,
    animType: AnimType.SCALE,
    title: "Xác Nhận",
    desc: "Sau khi Lưu bạn có thể bắt đầu tìm kiếm công việc",
    btnOkText: "Lưu",
    btnCancelText: "Hủy",
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      detailProfileProvider.createProfileApplicant(context, update);
    },
  ).show();
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
