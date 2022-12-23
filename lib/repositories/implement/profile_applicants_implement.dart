import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/request/profile_applicant_request.dart';
import 'package:it_job_mobile/models/response/profile_applicant_response.dart';
import 'package:it_job_mobile/models/entity/profile_applicant.dart';
import 'package:it_job_mobile/models/response/profile_applicants_response.dart';
import 'package:it_job_mobile/repositories/interface/profile_applicants_interface.dart';

import '../../models/entity/paging.dart';
import '../../models/response/check_dislike_response.dart';

class ProfileApplicantsImplement implements ProfileApplicantsInterface {
  @override
  Future<ProfileApplicantResponse> postProfileApplicant(
      String url, ProfileApplicantRequest request, String accessToken) async {
    var result = ProfileApplicantResponse();
    try {
      Response response = await Dio().post(url,
          data: request.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = ProfileApplicantResponse.profileApplicantResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postProfileApplicant: $e');
    }
    return result;
  }

  @override
  Future<ProfileApplicantResponse> putProfileApplicant(String url, String id,
      ProfileApplicant request, String accessToken) async {
    var result = ProfileApplicantResponse();
    try {
      Response response = await Dio().put(url + "/id?id=" + id,
          data: request.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = ProfileApplicantResponse.profileApplicantResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putProfileApplicant: $e');
    }
    return result;
  }

  @override
  Future<ProfileApplicantResponse> getProfileApplicantById(
      String url, String id) async {
    var result = ProfileApplicantResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result = ProfileApplicantResponse.profileApplicantResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error getProfileApplicantById: $e');
    }
    return result;
  }

  @override
  Future<ProfileApplicantsResponse> getProfileApplicantsById(
      String url, String id) async {
    var result;
    try {
      Response response = await Dio()
          .get(url + "?sort-key=CreateDate&sort-order=ASC&applicantId=" + id);
      if (response.statusCode == 200) {
        result = ProfileApplicantsResponse.profileApplicantsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ProfileApplicantsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getProfileApplicantsById: $e');
      result = ProfileApplicantsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<String> deleteProfileApplicantById(
      String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteProfileApplicantById: $e');
    }
    return result;
  }

  @override
  Future<CheckDislikeResponse> checkDisLike(String url, String id) async {
    var result = CheckDislikeResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result = CheckDislikeResponse.checkDislikeResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error checkDisLike: $e');
    }
    return result;
  }
}
