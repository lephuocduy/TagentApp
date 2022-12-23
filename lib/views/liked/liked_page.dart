import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/liked/liked_job_post_page.dart';
import 'package:it_job_mobile/providers/liked_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../shared/applicant_preferences.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  List<String> categories = ["Lượt thích", "Đã thích", "Đã kết nối"];
  int selectedIndex = 0;

  @override
  void initState() {
    final provider = Provider.of<LikedProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    super.initState();
    provider.getJobPostLiked(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
    provider.getLiked(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
    provider.getMatching(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LikedProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2.5.h,
          ),
          SizedBox(
            height: 5.h,
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
                      padding: EdgeInsets.symmetric(horizontal: 6.5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          ),
          if (selectedIndex == 0)
            provider.isLoadingJobPostLiked
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Center(
                            child: SpinKitCircle(
                          size: 80,
                          color: AppColor.black,
                        )),
                      ],
                    ),
                  )
                : provider.companiesInformationJobPostLiked.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: GridView.builder(
                              itemCount: provider
                                  .companiesInformationJobPostLiked.length,
                              itemBuilder: (context, index) {
                                return LikedJobPostPage(
                                  companyInformation: provider
                                      .companiesInformationJobPostLiked[index]
                                      .jobPost,
                                  view: false,
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 30.h,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            SvgPicture.asset(
                              ImagePath.jobPostEmpty,
                              fit: BoxFit.cover,
                              width: 50.w,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "Không có bài tuyển dụng nào",
                              style: AppTextStyles.h4Black,
                            )
                          ],
                        ),
                      ),
          if (selectedIndex == 1)
            provider.isLoadingLiked
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Center(
                            child: SpinKitCircle(
                          size: 80,
                          color: AppColor.black,
                        )),
                      ],
                    ),
                  )
                : provider.companiesInformationLiked.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: GridView.builder(
                              itemCount:
                                  provider.companiesInformationLiked.length,
                              itemBuilder: (context, index) {
                                return LikedJobPostPage(
                                  companyInformation: provider
                                      .companiesInformationLiked[index].jobPost,
                                  view: true,
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 30.h,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            SvgPicture.asset(
                              ImagePath.jobPostEmpty,
                              fit: BoxFit.cover,
                              width: 50.w,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "Không có bài tuyển dụng nào",
                              style: AppTextStyles.h4Black,
                            )
                          ],
                        ),
                      ),
          if (selectedIndex == 2)
            provider.isLoadingMatching
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Center(
                            child: SpinKitCircle(
                          size: 80,
                          color: AppColor.black,
                        )),
                      ],
                    ),
                  )
                : provider.companiesInformationMatching.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: GridView.builder(
                              itemCount:
                                  provider.companiesInformationMatching.length,
                              itemBuilder: (context, index) {
                                return LikedJobPostPage(
                                  companyInformation: provider
                                      .companiesInformationMatching[index]
                                      .jobPost,
                                  view: true,
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 30.h,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            SvgPicture.asset(
                              ImagePath.jobPostEmpty,
                              fit: BoxFit.cover,
                              width: 50.w,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "Không có bài tuyển dụng nào",
                              style: AppTextStyles.h4Black,
                            )
                          ],
                        ),
                      ),
        ],
      ),
    );
  }
}
