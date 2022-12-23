import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/like_response.dart';

import '../../constants/toast.dart';
import '../../models/entity/paging.dart';
import '../../models/request/like_request.dart';
import '../../models/response/matching_response.dart';
import '../interface/likes_interface.dart';

class LikesImplement implements LikesInterface {
  @override
  Future<LikeResponse> like(
      String url, LikeRequest request, String accessToken) async {
    var result;
    try {
      Response response = await Dio().post(
        url,
        data: request.toJson(),
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}),
      );
      result = LikeResponse.likeResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      if (e.response?.data["detail"] ==
          "You've run out of likes. Please wait another 24 hours !!! ") {
        //showToastFail("Bạn đã hết lượt thích\n Vui lòng chờ qua ngày mới");
        return result = LikeResponse(msg: "outOfLikes");
      }
      result = LikeResponse(msg: "");
      log('Error like: $e');
    }
    return result;
  }

  @override
  Future<MatchingResponse> getLiked(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url +
          "?page=1&page-size=6&sort-key=CreateDate&sort-order=DESC&profileApplicantId=" +
          id +
          "&isProfileApplicantLike=1");
      if (response.statusCode == 200) {
        result = MatchingResponse.matchingResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = MatchingResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getLiked: $e');
      result = MatchingResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<MatchingResponse> getMatching(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url +
          "?page=1&page-size=6&profileApplicantId=" +
          id +
          "&match=1");
      if (response.statusCode == 200) {
        result = MatchingResponse.matchingResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = MatchingResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getMatching: $e');
      result = MatchingResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<MatchingResponse> checkLiked(
      String url, String jobPostId, String profileApplicantId) async {
    var result;
    try {
      Response response = await Dio().get(url +
          "?jobPostId=" +
          jobPostId +
          "&profileApplicantId=" +
          profileApplicantId +
          "&isProfileApplicantLike=1");
      if (response.statusCode == 200) {
        result = MatchingResponse.matchingResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = MatchingResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getMatching: $e');
      result = MatchingResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<MatchingResponse> getJobPostLiked(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url +
          "?page=1&page-size=6&sort-key=CreateDate&sort-order=DESC&profileApplicantId=" +
          id +
          "&isProfileApplicantLike=0");
      if (response.statusCode == 200) {
        result = MatchingResponse.matchingResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = MatchingResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getJobPostLiked: $e');
      result = MatchingResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
