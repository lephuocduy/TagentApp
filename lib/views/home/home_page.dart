import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_job_mobile/constants/toast.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/repositories/implement/likes_implement.dart';
import 'package:it_job_mobile/repositories/implement/profile_applicants_implement.dart';
import 'package:it_job_mobile/views/home/job_post.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../models/request/like_request.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/post_provider.dart';
import '../../shared/applicant_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool statusProfileApplicant = false;
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    postProvider.getJobPosts(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
    postProvider.getConfigurations();
    ProfileApplicantsImplement()
        .checkDisLike(
            UrlApi.profileApplicants,
            detailProfileProvider
                .profileApplicants[
                    ApplicantPreferences.getCurrentIndexProfileId(0)]
                .id)
        .then((value) => {
              postProvider.countLike = value.data!.countLike,
            });
  }

  @override
  Widget build(BuildContext context) {
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    final provider = Provider.of<PostProvider>(context, listen: true);
    return Container(
      color: AppColor.primary,
      child: Scaffold(
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
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: detailProfileProvider
                        .profileApplicants[
                            ApplicantPreferences.getCurrentIndexProfileId(0)]
                        .status ==
                    0
                ? (provider.isLoadingJobPost
                    ? Center(
                        child: SpinKitRipple(
                        size: 300,
                        color: AppColor.black,
                      ))
                    : (provider.companiesInformation.isEmpty
                        ? Align(
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
                                  "Đã hết bài tuyển dụng phù hợp với bạn, hãy chờ nhé",
                                  style: AppTextStyles.h4Black,
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: buildPosts(),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              buildButtons(),
                            ],
                          )))
                : Center(
                    child: Text(
                      "Hồ sơ của bạn chưa được bật",
                      style: AppTextStyles.h3Black,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPosts() {
    final provider = Provider.of<PostProvider>(context, listen: true);
    final companiesInformation = provider.companiesInformation;
    return Stack(
      children: companiesInformation
          .map((companyInformation) => JobPostPage(
                companyInformation: companyInformation,
                isFront: companiesInformation.last == companyInformation,
              ))
          .toList(),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<PostProvider>(context);
    final companiesInformation = provider.companiesInformation;
    final status = provider.getStatus();
    final isLike = status == PostStatus.like;
    final isDisLike = status == PostStatus.dislike;
    final isInformation = status == PostStatus.information;
    return Stack(children: [
      for (var i = 0; i < companiesInformation.length; i++)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final provider =
                    Provider.of<PostProvider>(context, listen: false);
                final detailProfileProvider =
                    Provider.of<DetailProfileProvider>(context, listen: false);
                if (provider.countLike <
                    provider.configuration.likeDailyLimit) {
                  provider.disLike();
                  if (companiesInformation.length == 1) {
                    provider.getJobPosts(detailProfileProvider
                        .profileApplicants[
                            ApplicantPreferences.getCurrentIndexProfileId(0)]
                        .id);
                  }
                } else {
                  showToastFail(
                      "Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
                }
              },
              child: const Icon(
                Icons.clear,
                size: 40,
              ),
              style: ButtonStyle(
                elevation: getElevation(),
                shape: getShape(),
                minimumSize: getSize(),
                foregroundColor:
                    getColor(AppColor.red, AppColor.white, isDisLike),
                backgroundColor:
                    getColor(AppColor.white, AppColor.red, isDisLike),
                side: getBorder(AppColor.red, isDisLike),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.getJobPostDetail(
                    context, provider.companiesInformation[i], 0, false);
              },
              child: const Icon(
                Icons.info,
                size: 40,
              ),
              style: ButtonStyle(
                elevation: getElevation(),
                shape: getShape(),
                minimumSize: getSize(),
                foregroundColor:
                    getColor(AppColor.blue, AppColor.white, isInformation),
                backgroundColor:
                    getColor(AppColor.white, AppColor.blue, isInformation),
                side: getBorder(AppColor.blue, isInformation),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final providerApplicant =
                    Provider.of<ApplicantProvider>(context, listen: false);
                final provider =
                    Provider.of<PostProvider>(context, listen: false);
                final detailProfileProvider =
                    Provider.of<DetailProfileProvider>(context, listen: false);

                if (provider.countLike <
                    provider.configuration.likeDailyLimit) {
                  provider.like();
                  if (providerApplicant.applicant.earnMoney == 1) {
                    cancelToast();
                    showToastBonus(
                        "+ ${provider.configuration.earnByLike} Coin");
                  }
                  setState(() {
                    provider.countLike++;
                  });
                } else {
                  showToastFail(
                      "Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
                }
                if (companiesInformation.length == 1) {
                  setState(() {
                    provider.isLoadingJobPost = true;
                  });
                }
                LikesImplement()
                    .like(
                      UrlApi.likes,
                      LikeRequest(
                        jobPostId: provider.companiesInformation[i].id,
                        profileApplicantId: detailProfileProvider
                            .profileApplicants[
                                ApplicantPreferences.getCurrentIndexProfileId(
                                    0)]
                            .id,
                        isProfileApplicantLike: true,
                        //isJobPostLike: false,
                      ),
                      ApplicantPreferences.getToken(''),
                    )
                    .then((value) => {
                          if (companiesInformation.length == 0)
                            {
                              provider.getJobPosts(detailProfileProvider
                                  .profileApplicants[ApplicantPreferences
                                      .getCurrentIndexProfileId(0)]
                                  .id),
                            }
                        });
              },
              child: const Icon(
                Icons.thumb_up_alt,
                size: 40,
              ),
              style: ButtonStyle(
                elevation: getElevation(),
                shape: getShape(),
                minimumSize: getSize(),
                foregroundColor:
                    getColor(AppColor.success, AppColor.white, isLike),
                backgroundColor:
                    getColor(AppColor.white, AppColor.success, isLike),
                side: getBorder(AppColor.success, isLike),
              ),
            ),
          ],
        ),
    ]);
  }

  MaterialStateProperty<double> getElevation() {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return 0;
      } else {
        return 0;
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

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    });
  }

  MaterialStateProperty<BorderSide> getBorder(Color color, bool force) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    });
  }
}
