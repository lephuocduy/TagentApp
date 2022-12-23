import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/entity/project.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_project/create_profile_project_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';

class ViewProfileProject extends StatefulWidget {
  String profileApplicantId;
  int selectedIndex;
  ViewProfileProject({
    Key? key,
    required this.profileApplicantId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileProject> createState() => _ViewProfileProjectState();
}

class _ViewProfileProjectState extends State<ViewProfileProject> {
  bool more = false;

  @override
  void initState() {
    super.initState();
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
                  "Dự án",
                  style: AppTextStyles.h3Black,
                ),
                SizedBox(
                  width: 3.w,
                ),
                if (detailProfileProvider.listProject.isNotEmpty &&
                    detailProfileProvider.listProject.length > 1)
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
                                (detailProfileProvider.listProject.length - 1)
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
        if (detailProfileProvider.listProject.isNotEmpty && more == true)
          for (var list in detailProfileProvider.listProject)
            InkWell(
              onTap: widget.selectedIndex == 1
                  ? () async {
                      Project pro = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateProfileProjectPage(
                              edit: true,
                              data: list,
                            );
                          })) ??
                          list;
                      if (pro.name.isNotEmpty) {
                        setState(() {
                          list.name = pro.name;
                          list.link = pro.link;
                          list.description = pro.description;
                          list.startTime = pro.startTime;
                          list.endTime = pro.endTime;
                          list.skill = pro.skill;
                          list.jobPosition = pro.jobPosition;
                        });
                      } else {
                        setState(() {
                          detailProfileProvider.listProject.remove(list);
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
                            list.name,
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
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
        if (detailProfileProvider.listProject.isNotEmpty && more == false)
          InkWell(
            onTap: widget.selectedIndex == 1
                ? () async {
                    Project pro = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileProjectPage(
                            edit: true,
                            data: detailProfileProvider.listProject[0],
                          );
                        })) ??
                        detailProfileProvider.listProject[0];

                    if (pro.name.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listProject[0] = pro;
                      });
                    } else {
                      setState(() {
                        detailProfileProvider.listProject.removeAt(0);
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
                          detailProfileProvider.listProject[0].name,
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
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        if (detailProfileProvider.listProject.length < 5)
          widget.selectedIndex == 1
              ? InkWell(
                  onTap: () async {
                    Project pro = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileProjectPage(
                              data: Project(
                            id: '',
                            name: '',
                            link: '',
                            description: '',
                            startTime: DateTime.now(),
                            endTime: DateTime.now(),
                            skill: '',
                            jobPosition: '',
                            profileApplicantId: widget.profileApplicantId,
                          ));
                        })) ??
                        Project(
                          id: '',
                          name: '',
                          link: '',
                          description: '',
                          startTime: DateTime.now(),
                          endTime: DateTime.now(),
                          skill: '',
                          jobPosition: '',
                          profileApplicantId: widget.profileApplicantId,
                        );

                    if (pro.name.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listProject.add(pro);
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
                            "Thêm dự án",
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
              : (detailProfileProvider.listProject.length != 0)
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
                              "Chưa thêm dự án",
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
