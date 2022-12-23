import 'dart:math';

import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/toast.dart';
import 'package:it_job_mobile/models/entity/featured_job_post.dart';
import 'package:it_job_mobile/models/entity/job_post_skill.dart';
import 'package:it_job_mobile/models/entity/store_image.dart';
import 'package:it_job_mobile/models/entity/job_post.dart';
import 'package:it_job_mobile/models/entity/working_style.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/repositories/implement/album_images_implement.dart';
import 'package:it_job_mobile/repositories/implement/companies_implement.dart';
import 'package:it_job_mobile/repositories/implement/job_post_skills_implement.dart';
import 'package:it_job_mobile/repositories/implement/job_posts_implement.dart';
import 'package:it_job_mobile/repositories/implement/skills_implement.dart';
import 'package:it_job_mobile/repositories/implement/working_styles_implement.dart';
import 'package:provider/provider.dart';

import '../../models/entity/company.dart';
import '../../models/entity/job_position.dart';
import '../../models/entity/skill.dart';
import '../../models/request/like_request.dart';
import '../../repositories/implement/likes_implement.dart';
import '../../views/home/view_info_company_page.dart';
import '../../constants/url_api.dart';
import '../models/response/configuration_response.dart';
import '../repositories/implement/job_positions_implement.dart';
import '../repositories/implement/wallet_implement.dart';
import '../shared/applicant_preferences.dart';
import 'applicant_provider.dart';

enum PostStatus { like, dislike, information }

class PostProvider extends ChangeNotifier {
  List<JobPost> jobPosts = [];
  List<Company> companies = [];
  List<StoreImage> albumImages = [];
  List<JobPosition> listJobPosition = [];
  List<WorkingStyle> listWorkingStyle = [];
  List<Skill> listSkill = [];
  List<JobPostSkill> listJobPostSkill = [];
  List<FeaturedJobPost> companiesInformation = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  int countLike = 0;
  void endPosition(BuildContext context, FeaturedJobPost companyInformation) {
    final providerApplicant =
        Provider.of<ApplicantProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case PostStatus.like:
        if (countLike < configuration.likeDailyLimit) {
          like();
          if (providerApplicant.applicant.earnMoney == 1) {
            cancelToast();
            showToastBonus("+ ${configuration.earnByLike} Coin");
          }
          countLike++;
          notifyListeners();
        } else {
          showToastFail("Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
        }
        if (companiesInformation.length == 1) {
          isLoadingJobPost = true;
          notifyListeners();
        }
        LikesImplement()
            .like(
              UrlApi.likes,
              LikeRequest(
                jobPostId: companyInformation.id,
                profileApplicantId: detailProfileProvider
                    .profileApplicants[
                        ApplicantPreferences.getCurrentIndexProfileId(0)]
                    .id,
                isProfileApplicantLike: true,
                //isJobPostLike: false,
              ),
              ApplicantPreferences.getToken(''),
            )
            .then((value) => {
                  if (companiesInformation.length == 0)
                    {
                      getJobPosts(detailProfileProvider
                          .profileApplicants[
                              ApplicantPreferences.getCurrentIndexProfileId(0)]
                          .id),
                    }
                });
        break;
      case PostStatus.dislike:
        if (countLike < configuration.likeDailyLimit) {
          disLike();
          if (companiesInformation.length == 1) {
            getJobPosts(detailProfileProvider
                .profileApplicants[
                    ApplicantPreferences.getCurrentIndexProfileId(0)]
                .id);
          }
        } else {
          showToastFail("Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
        }
        break;
      case PostStatus.information:
        information(context, companyInformation);
        break;
      default:
        resetPosition();
    }

    resetPosition();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  PostStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceInformation = x.abs() < 20;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return PostStatus.like;
      } else if (x <= -delta) {
        return PostStatus.dislike;
      } else if (y <= -delta / 2 && forceInformation) {
        return PostStatus.information;
      }
    } else {
      final delta = 20;

      if (y <= -delta * 2 && forceInformation) {
        return PostStatus.information;
      } else if (x >= delta) {
        return PostStatus.like;
      } else if (x <= -delta) {
        return PostStatus.dislike;
      }
    }
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextPost();

    notifyListeners();
  }

  void disLike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextPost();

    notifyListeners();
  }

  void information(BuildContext context, FeaturedJobPost companyInformation) {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);

    notifyListeners();
    getJobPostDetail(context, companyInformation, 0, false);
  }

  Future _nextPost() async {
    if (companiesInformation.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    if (companiesInformation.isNotEmpty) {
      companiesInformation.removeLast();
    }

    resetPosition();
  }

  bool isLoadingJobPost = true;
  //List<FeaturedJobPost> companiesInformationTmp = [];
  void getJobPosts(String idProfile) async {
    isLoadingJobPost = true;
    JobPositionsImplement()
        .getJobPositions(UrlApi.jobPositions)
        .then((value) => {listJobPosition = value.data});
    WorkingStyleImplement()
        .getWorkingStyles(UrlApi.workingStyles)
        .then((value) => {listWorkingStyle = value.data});
    SkillsImplement()
        .getSkills(UrlApi.skills)
        .then((value) => {listSkill = value.data});
    await JobPostsImplement()
        .getJobPostsByIdProfile(
          UrlApi.jobPosts,
          idProfile,
        )
        .then((value) => {
              companiesInformation = value.data,
              //companiesInformationTmp = value.data
            });
    isLoadingJobPost = false;
    notifyListeners();
  }

  void getJobPostShare(BuildContext context, String jobPostId) async {
    FeaturedJobPost companyInformationShare;
    JobPostSkillsImplement()
        .getJobPostSkillsById(UrlApi.jobPostSkills, jobPostId)
        .then((value) => {listJobPostSkill = value.data});
    AlbumImagesImplement()
        .getAlbumImagesByJobPostId(
          UrlApi.albumImages,
          jobPostId,
        )
        .then((value) => {albumImages = value.data});
    JobPostsImplement()
        .getJobPostById(UrlApi.jobPosts, jobPostId)
        .then((value) => {
              companyInformationShare = FeaturedJobPost(
                id: value.data!.id,
                title: value.data!.title,
                description: value.data!.description,
                quantity: value.data!.quantity,
                status: value.data!.status,
                companyId: value.data!.companyId,
                jobPositionId: value.data!.jobPositionId,
                workingStyleId: value.data!.workingStyleId,
                workingPlace: value.data!.workingPlace,
                jobPosition:
                    JobPosition(id: value.data!.jobPositionId, name: ''),
                workingStyle:
                    WorkingStyle(id: value.data!.workingStyleId, name: ''),
                albumImages: albumImages,
                jobPostSkills: listJobPostSkill,
              ),
              CompaniesImplement()
                  .getCompanyById(
                    UrlApi.companies,
                    value.data!.companyId,
                  )
                  .then((value) => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewInfoCompanyPage(
                            typeLike: 2,
                            view: false,
                            companyInformation: companyInformationShare,
                            companyDetail: value.data,
                          );
                        }))
                      }),
            });
  }

  void getJobPostDetail(BuildContext context,
      FeaturedJobPost companyInformation, int typeLike, bool view) async {
    var value = await CompaniesImplement().getCompanyById(
      UrlApi.companies,
      companyInformation.companyId,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewInfoCompanyPage(
        typeLike: typeLike,
        view: view,
        companyInformation: companyInformation,
        companyDetail: value.data,
      );
    }));
  }

  ConfigurationResponse configuration = ConfigurationResponse(
    likeDailyLimit: 10,
    shareDailyLimit: 5,
    earnByLike: 5,
    earnByShare: 5,
    earnByMatch: 50,
  );

  void getConfigurations() {
    WalletImplement()
        .configuration(UrlApi.configurations)
        .then((value) => {configuration = value});
  }
}
