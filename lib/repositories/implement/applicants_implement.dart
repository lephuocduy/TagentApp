import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/entity/applicant.dart';
import 'package:it_job_mobile/models/request/enable_to_earn_request.dart';
import 'package:it_job_mobile/models/response/applicant_response.dart';
import 'package:it_job_mobile/models/response/applicants_response.dart';
import 'package:it_job_mobile/repositories/interface/applicants_interface.dart';

import '../../constants/toast.dart';
import '../../models/entity/paging.dart';

class ApplicantsImplement implements ApplicantsInterface {
  @override
  Future<ApplicantResponse> getApplicantById(String url, String id) async {
    var result = ApplicantResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result = ApplicantResponse.applicantsResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error getApplicantById: $e');
    }
    return result;
  }

  @override
  Future<ApplicantResponse> putApplicantById(String url, String id,
      Applicant request, File avatar, String accessToken) async {
    var result = ApplicantResponse();
    try {
      String fileName = avatar.path.split('/').last;
      var formData = FormData.fromMap({
        "id": request.id,
        "phone": request.phone,
        "email": request.email,
        "name": request.name,
        "gender": request.gender == 3 ? null : request.gender,
        "dob": request.dob.toIso8601String().contains("1969-01-01")
            ? null
            : request.dob.toIso8601String(),
        "address": request.address,
        "uploadFile": avatar.path.isNotEmpty
            ? await MultipartFile.fromFile(avatar.path, filename: fileName)
            : null,
      });
      Response response = await Dio().put(url + "/" + id,
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = ApplicantResponse.applicantsResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putApplicantById: $e');
    }
    return result;
  }

  @override
  Future<String> deleteAvatar(String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().put(url + "/applicant/id?id=" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteAvatar: $e');
    }
    return result;
  }

  @override
  Future<String> checkPhone(String url, String phone) async {
    var result = "notExist";
    try {
      await Dio().get(url + "/phone?phone=" + phone);
      result = "exist";
    } on DioError catch (e) {
      log('Error checkPhone: $e');
      showToastFail("Số điện thoại này chưa được đăng ký");
    }
    return result;
  }

  @override
  Future<ApplicantResponse> checkPhoneAddFriend(
      String url, String phone) async {
    var result = ApplicantResponse();
    try {
      Response response = await Dio().get(url + "/phone?phone=" + phone);
      result = ApplicantResponse.applicantsResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error checkPhoneAddFriend: $e');
      showToastFail("Số điện thoại này chưa được đăng ký");
    }
    return result;
  }

  @override
  Future<String> enableToEarn(
      String url, EnableToEarnRequest request, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().put(url + "/update?id=" + request.id,
          data: request.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error enableToEarn: $e');
    }
    return result;
  }

  @override
  Future<ApplicantsResponse> getListApplicant(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = ApplicantsResponse.applicantsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ApplicantsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getListApplicant: $e');
      result = ApplicantsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
