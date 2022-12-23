import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/entity/working_experience.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_working_experience/create_profile_working_experience_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../models/response/suggest_search_response.dart';
import '../../../../repositories/implement/suggest_search_implement.dart';
import '../../../../constants/url_api.dart';
import '../../../../shared/applicant_preferences.dart';

class ViewProfileWorkingExperiencePage extends StatefulWidget {
  String profileApplicantId;
  int selectedIndex;
  ViewProfileWorkingExperiencePage({
    Key? key,
    required this.profileApplicantId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileWorkingExperiencePage> createState() =>
      _ViewProfileWorkingExperiencePageState();
}

class _ViewProfileWorkingExperiencePageState
    extends State<ViewProfileWorkingExperiencePage> {
  bool more = false;
  List<SuggestSearchResponse> companies = [];

  @override
  void initState() {
    super.initState();
    SuggestSearchImplement().suggestSearch(UrlApi.company, "").then((value) => {
          companies = value,
        });
  }

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              more = !more;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                const Icon(
                  Iconsax.briefcase,
                  size: 25,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Kinh nghiệm làm việc",
                  style: AppTextStyles.h3Black,
                ),
                SizedBox(
                  width: 3.w,
                ),
                if (detailProfileProvider.listWorkingExperience.isNotEmpty &&
                    detailProfileProvider.listWorkingExperience.length > 1)
                  more
                      ? const Icon(
                          Iconsax.arrow_circle_down,
                        )
                      : Row(children: [
                          Icon(
                            Iconsax.arrow_circle_right,
                            color: AppColor.black,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            "+" +
                                (detailProfileProvider
                                            .listWorkingExperience.length -
                                        1)
                                    .toString(),
                            style: AppTextStyles.h4Red,
                          )
                        ]),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        if (detailProfileProvider.listWorkingExperience.isNotEmpty &&
            more == true)
          for (var list in detailProfileProvider.listWorkingExperience)
            InkWell(
              onTap: widget.selectedIndex == 1
                  ? () async {
                      WorkingExperience exp = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateProfileWorkingExperiencePage(
                              edit: true,
                              data: list,
                              companies: companies,
                              listJobPosition:
                                  detailProfileProvider.listJobPosition,
                            );
                          })) ??
                          list;

                      if (exp.companyName.isNotEmpty) {
                        setState(() {
                          list.companyName = exp.companyName;
                          list.jobPositionId = exp.jobPositionId;
                          list.startDate = exp.startDate;
                          list.endDate = exp.endDate;
                        });
                      } else {
                        setState(() {
                          detailProfileProvider.listWorkingExperience
                              .remove(list);
                        });
                      }
                    }
                  : null,
              child: Column(
                children: [
                  Container(
                    color: AppColor.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        top: 3.w,
                        bottom: 3.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            list.companyName.length < 25
                                ? list.companyName
                                : list.companyName.substring(0, 25) + "...",
                            style: AppTextStyles.h4Black,
                          ),
                          for (var i = 0;
                              i < detailProfileProvider.listJobPosition.length;
                              i++)
                            if (list.jobPositionId ==
                                detailProfileProvider.listJobPosition[i].id)
                              Text(
                                detailProfileProvider
                                            .listJobPosition[i].name.length <
                                        25
                                    ? detailProfileProvider
                                        .listJobPosition[i].name
                                    : detailProfileProvider
                                            .listJobPosition[i].name
                                            .substring(0, 25) +
                                        "...",
                                style: AppTextStyles.h4Black,
                              ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
        if (detailProfileProvider.listWorkingExperience.isNotEmpty &&
            more == false)
          InkWell(
            onTap: widget.selectedIndex == 1
                ? () async {
                    WorkingExperience exp = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileWorkingExperiencePage(
                            edit: true,
                            data:
                                detailProfileProvider.listWorkingExperience[0],
                            companies: companies,
                            listJobPosition:
                                detailProfileProvider.listJobPosition,
                          );
                        })) ??
                        detailProfileProvider.listWorkingExperience[0];

                    if (exp.companyName.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listWorkingExperience[0] = exp;
                      });
                    } else {
                      setState(() {
                        detailProfileProvider.listWorkingExperience.removeAt(0);
                      });
                    }
                  }
                : null,
            child: Column(
              children: [
                Container(
                  color: AppColor.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 3.w,
                      bottom: 3.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          detailProfileProvider.listWorkingExperience[0]
                                      .companyName.length <
                                  25
                              ? detailProfileProvider
                                  .listWorkingExperience[0].companyName
                              : detailProfileProvider
                                      .listWorkingExperience[0].companyName
                                      .substring(0, 25) +
                                  "...",
                          style: AppTextStyles.h4Black,
                        ),
                        for (var i = 0;
                            i < detailProfileProvider.listJobPosition.length;
                            i++)
                          if (detailProfileProvider
                                  .listWorkingExperience[0].jobPositionId ==
                              detailProfileProvider.listJobPosition[i].id)
                            Text(
                              detailProfileProvider
                                          .listJobPosition[i].name.length <
                                      25
                                  ? detailProfileProvider
                                      .listJobPosition[i].name
                                  : detailProfileProvider
                                          .listJobPosition[i].name
                                          .substring(0, 25) +
                                      "...",
                              style: AppTextStyles.h4Black,
                            ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        if (detailProfileProvider.listWorkingExperience.length < 5)
          widget.selectedIndex == 1
              ? InkWell(
                  onTap: () async {
                    WorkingExperience exp = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileWorkingExperiencePage(
                            data: WorkingExperience(
                                id: '',
                                profileApplicantId: widget.profileApplicantId,
                                companyName: '',
                                startDate: DateTime.now(),
                                endDate: DateTime.now(),
                                jobPositionId: ''),
                            companies: companies,
                            listJobPosition:
                                detailProfileProvider.listJobPosition,
                          );
                        })) ??
                        WorkingExperience(
                            id: '',
                            profileApplicantId: widget.profileApplicantId,
                            companyName: '',
                            startDate: DateTime.now(),
                            endDate: DateTime.now(),
                            jobPositionId: '');

                    if (exp.companyName.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listWorkingExperience.add(exp);
                      });
                    }
                  },
                  child: Container(
                    color: AppColor.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        top: 3.w,
                        bottom: 3.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Thêm kinh nghiệm làm việc",
                            style: AppTextStyles.h4Grey,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : (detailProfileProvider.listWorkingExperience.length != 0)
                  ? Container()
                  : Container(
                      color: AppColor.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          top: 3.w,
                          bottom: 3.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chưa thêm kinh nghiệm làm việc",
                              style: AppTextStyles.h4Grey,
                            ),
                          ],
                        ),
                      ),
                    )
      ],
    );
  }
}
