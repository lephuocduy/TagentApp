import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_skill/create_profile_skill_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../models/entity/profile_applicant_skill.dart';

class ViewProfileSkill extends StatefulWidget {
  String profileApplicantId;
  int selectedIndex;
  ViewProfileSkill({
    Key? key,
    required this.profileApplicantId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileSkill> createState() => _ViewProfileSkillState();
}

class _ViewProfileSkillState extends State<ViewProfileSkill> {
  bool more = false;

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
                  Iconsax.unlimited,
                  size: 25,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Kỹ năng",
                  style: AppTextStyles.h3Black,
                ),
                Text(
                  "*",
                  style: AppTextStyles.h4Red,
                ),
                SizedBox(
                  width: 3.w,
                ),
                if (detailProfileProvider.listProfileSkill.isNotEmpty &&
                    detailProfileProvider.listProfileSkill.length > 1)
                  more
                      ? Icon(
                          Iconsax.arrow_circle_down,
                          color: AppColor.black,
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
                                (detailProfileProvider.listProfileSkill.length -
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
        if (detailProfileProvider.listProfileSkill.isNotEmpty && more == true)
          for (var list in detailProfileProvider.listProfileSkill)
            InkWell(
              onTap: widget.selectedIndex == 1
                  ? () async {
                      String originalSkillId = list.skillId;
                      ProfileApplicantSkill proSkill = await Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return CreateProfileSkillPage(
                              edit: true,
                              data: list,
                              skills: detailProfileProvider.listSkill,
                              skillsProfile:
                                  detailProfileProvider.listSkillSearch,
                              skillSearch:
                                  detailProfileProvider.listSkillSearch,
                            );
                          })) ??
                          list;
                      if (proSkill.skillId.isNotEmpty) {
                        setState(() {
                          list = proSkill;
                          detailProfileProvider.listSkillIdSearch
                              .add(originalSkillId);
                          detailProfileProvider.listSkillIdSearch
                              .remove(proSkill.skillId);

                          detailProfileProvider.listSkillSearch.clear();

                          for (var item
                              in detailProfileProvider.listSkillIdSearch) {
                            for (var i = 0;
                                i < detailProfileProvider.listSkill.length;
                                i++) {
                              if (item.contains(
                                  detailProfileProvider.listSkill[i].id)) {
                                detailProfileProvider.listSkillSearch
                                    .add(detailProfileProvider.listSkill[i]);
                              }
                            }
                          }
                        });
                      } else {
                        setState(() {
                          detailProfileProvider.listProfileSkill.remove(list);
                          detailProfileProvider.listSkillIdSearch
                              .add(originalSkillId);

                          detailProfileProvider.listSkillSearch.clear();

                          for (var item
                              in detailProfileProvider.listSkillIdSearch) {
                            for (var i = 0;
                                i < detailProfileProvider.listSkill.length;
                                i++) {
                              if (item.contains(
                                  detailProfileProvider.listSkill[i].id)) {
                                detailProfileProvider.listSkillSearch
                                    .add(detailProfileProvider.listSkill[i]);
                              }
                            }
                          }
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
                          for (var i = 0;
                              i < detailProfileProvider.listSkill.length;
                              i++)
                            if (list.skillId ==
                                detailProfileProvider.listSkill[i].id)
                              Text(
                                detailProfileProvider.listSkill[i].name.length <
                                        25
                                    ? detailProfileProvider.listSkill[i].name
                                    : detailProfileProvider.listSkill[i].name
                                            .substring(0, 25) +
                                        "...",
                                style: AppTextStyles.h4Black,
                              ),
                          Text(
                            list.skillLevel.length < 25
                                ? list.skillLevel
                                : list.skillLevel.substring(0, 25) + "...",
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
        if (detailProfileProvider.listProfileSkill.isNotEmpty && more == false)
          InkWell(
            onTap: widget.selectedIndex == 1
                ? () async {
                    String originalSkillId =
                        detailProfileProvider.listProfileSkill[0].skillId;
                    ProfileApplicantSkill proSkill = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return CreateProfileSkillPage(
                            edit: true,
                            data: detailProfileProvider.listProfileSkill[0],
                            skills: detailProfileProvider.listSkill,
                            skillsProfile:
                                detailProfileProvider.listSkillSearch,
                            skillSearch: detailProfileProvider.listSkillSearch,
                          );
                        })) ??
                        detailProfileProvider.listProfileSkill[0];

                    if (proSkill.skillId.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listProfileSkill[0] = proSkill;
                        detailProfileProvider.listSkillIdSearch
                            .add(originalSkillId);
                        detailProfileProvider.listSkillIdSearch
                            .remove(proSkill.skillId);

                        if (detailProfileProvider.listSkillSearch.isNotEmpty) {
                          detailProfileProvider.listSkillSearch.clear();
                        }
                        for (var item
                            in detailProfileProvider.listSkillIdSearch) {
                          for (var i = 0;
                              i < detailProfileProvider.listSkill.length;
                              i++) {
                            if (item.contains(
                                detailProfileProvider.listSkill[i].id)) {
                              detailProfileProvider.listSkillSearch
                                  .add(detailProfileProvider.listSkill[i]);
                            }
                          }
                        }
                      });
                    } else {
                      setState(() {
                        detailProfileProvider.listProfileSkill.removeAt(0);
                        detailProfileProvider.listSkillIdSearch
                            .add(originalSkillId);
                        if (detailProfileProvider.listSkillSearch.isNotEmpty) {
                          detailProfileProvider.listSkillSearch.clear();
                        }
                        for (var item
                            in detailProfileProvider.listSkillIdSearch) {
                          for (var i = 0;
                              i < detailProfileProvider.listSkill.length;
                              i++) {
                            if (item.contains(
                                detailProfileProvider.listSkill[i].id)) {
                              detailProfileProvider.listSkillSearch
                                  .add(detailProfileProvider.listSkill[i]);
                            }
                          }
                        }
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
                        for (var i = 0;
                            i < detailProfileProvider.listSkill.length;
                            i++)
                          if (detailProfileProvider
                                  .listProfileSkill[0].skillId ==
                              detailProfileProvider.listSkill[i].id)
                            Text(
                              detailProfileProvider.listSkill[i].name.length <
                                      25
                                  ? detailProfileProvider.listSkill[i].name
                                  : detailProfileProvider.listSkill[i].name
                                          .substring(0, 25) +
                                      "...",
                              style: AppTextStyles.h4Black,
                            ),
                        Text(
                          detailProfileProvider
                                      .listProfileSkill[0].skillLevel.length <
                                  25
                              ? detailProfileProvider
                                  .listProfileSkill[0].skillLevel
                              : detailProfileProvider
                                      .listProfileSkill[0].skillLevel
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
        if (detailProfileProvider.listProfileSkill.length < 5)
          widget.selectedIndex == 1
              ? InkWell(
                  onTap: () async {
                    ProfileApplicantSkill proSkill = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return CreateProfileSkillPage(
                            data: ProfileApplicantSkill(
                                id: '',
                                profileApplicantId: widget.profileApplicantId,
                                skillId: '',
                                skillLevel: ''),
                            skills: detailProfileProvider.listSkill,
                            skillsProfile:
                                detailProfileProvider.listSkillSearch,
                            skillSearch: detailProfileProvider.listSkillSearch,
                          );
                        })) ??
                        ProfileApplicantSkill(
                            id: '',
                            profileApplicantId: widget.profileApplicantId,
                            skillId: '',
                            skillLevel: '');

                    if (proSkill.skillId.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listProfileSkill.add(proSkill);
                        detailProfileProvider.listSkillIdSearch
                            .remove(proSkill.skillId);

                        detailProfileProvider.listSkillSearch.clear();

                        for (var item
                            in detailProfileProvider.listSkillIdSearch) {
                          for (var i = 0;
                              i < detailProfileProvider.listSkill.length;
                              i++) {
                            if (item.contains(
                                detailProfileProvider.listSkill[i].id)) {
                              detailProfileProvider.listSkillSearch
                                  .add(detailProfileProvider.listSkill[i]);
                            }
                          }
                        }
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
                            "Thêm kỹ năng",
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
              : (detailProfileProvider.listProfileSkill.length != 0)
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
                              "Chưa thêm kỹ năng",
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
