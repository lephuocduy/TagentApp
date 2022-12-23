import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/request/share_job_post_request.dart';
import 'package:it_job_mobile/models/response/job_post_response.dart';
import 'package:it_job_mobile/models/response/share_job_post_response.dart';

import '../../constants/toast.dart';
import '../../models/entity/paging.dart';
import '../../models/response/featured_job_posts_response.dart';
import '../interface/job_posts_interface.dart';

class JobPostsImplement implements JobPostsInterface {
  @override
  Future<JobPostResponse> getJobPostById(String url, String id) async {
    var result = JobPostResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result =
          JobPostResponse.jobPostResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error getJobPostSkillsById: $e');
    }
    return result;
  }

  @override
  Future<FeaturedJobPostsResponse> getJobPostsByIdProfile(
      String url, String id) async {
    var result;
    try {
      Response response =
          await Dio().get(url + "/profileApplicantId?profileApplicantId=" + id);
      if (response.statusCode == 200) {
        result = FeaturedJobPostsResponse.featuredJobPostsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = FeaturedJobPostsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getJobPostsByIdProfile: $e');
      result = FeaturedJobPostsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<ShareJobPostResponse> shareJobPost(
      String url, ShareJobPostRequest request, String accessToken) async {
    var result = ShareJobPostResponse();
    try {
      Response response = await Dio().post(url,
          data: request.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = ShareJobPostResponse.shareJobPostResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error shareJobPost: $e');
      if (e.response?.data["detail"] ==
          "This job post has been shared before") {
        showToastFail("Bạn từng chia sẻ cho người này rồi");
      }
      if (e.response?.data["detail"] ==
          "You've run out of shares. Please wait another 24 hours !!! ") {
        showToastFail("Bạn đã hết lượt chia sẻ\n Vui lòng chờ qua ngày mới");
        return result = ShareJobPostResponse(msg: 'outOfShares');
      }
    }
    return result;
  }
}
