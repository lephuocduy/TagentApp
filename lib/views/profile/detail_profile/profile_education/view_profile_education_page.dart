import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/response/suggest_search_response.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_education/create_profile_education_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../repositories/implement/suggest_search_implement.dart';
import '../../../../constants/url_api.dart';
import '../../../../shared/applicant_preferences.dart';

class ViewProfileEducation extends StatefulWidget {
  String education;
  int selectedIndex;
  ViewProfileEducation({
    Key? key,
    required this.education,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileEducation> createState() => _ViewProfileEducationState();
}

class _ViewProfileEducationState extends State<ViewProfileEducation> {
  List<SuggestSearchResponse> educations = [];
  @override
  void initState() {
    super.initState();
    SuggestSearchImplement()
        .suggestSearch(UrlApi.educations, "")
        .then((value) => {
              educations = value,
            });
  }

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    detailProfileProvider.education = widget.education;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Row(
            children: [
              const Icon(
                Iconsax.teacher,
                size: 25,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                "Trường",
                style: AppTextStyles.h3Black,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        InkWell(
          onTap: widget.selectedIndex == 1
              ? () async {
                  String edu = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateProfileEducationPage(
                          query: widget.education,
                          edit: widget.education.isNotEmpty ? true : false,
                          educations: educations,
                        );
                      })) ??
                      widget.education;
                  setState(() {
                    widget.education = edu;
                    detailProfileProvider.detailProfile!.education =
                        widget.education;
                  });
                }
              : null,
          child: Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
                top: 3.w,
                bottom: 3.w,
              ),
              child: widget.education.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedIndex == 1
                              ? "Thêm trường"
                              : "Chưa thêm trường",
                          style: AppTextStyles.h4Grey,
                        ),
                        if (widget.selectedIndex == 1)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.grey,
                          )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.education.length < 40
                              ? widget.education
                              : widget.education.substring(0, 40) + "...",
                          style: AppTextStyles.h4Black,
                        ),
                        if (widget.selectedIndex == 1)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.black,
                          )
                      ],
                    ),
            ),
          ),
        )
      ],
    );
  }
}
