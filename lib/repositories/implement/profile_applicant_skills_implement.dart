import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/profile_applicant_skill_response.dart';
import 'package:it_job_mobile/models/request/profile_applicant_skill_request.dart';
import 'package:it_job_mobile/models/entity/profile_applicant_skill.dart';
import 'package:it_job_mobile/models/response/profile_applicant_skills_response.dart';
import 'package:it_job_mobile/repositories/interface/profile_applicant_skills_interface.dart';

import '../../models/entity/paging.dart';

class ProfileApplicantSkillsImplement
    implements ProfileApplicantSkillsInterface {
  @override
  Future<ProfileApplicantSkillsResponse> getProfileApplicantSkillsById(
      String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?profileApplicantId=" + id);
      if (response.statusCode == 200) {
        result = ProfileApplicantSkillsResponse
            .profileApplicantSkillsResponseFromJson(jsonEncode(response.data));
      } else {
        result = ProfileApplicantSkillsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getProfileApplicantSkillsById: $e');
      result = ProfileApplicantSkillsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<ProfileApplicantSkillResponse> postProfileApplicantSkill(String url,
      ProfileApplicantSkillRequest request, String accessToken) async {
    var result = ProfileApplicantSkillResponse();
    try {
      Response response = await Dio().post(url,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result =
          ProfileApplicantSkillResponse.profileApplicantSkillResponseFromJson(
              jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postProfileApplicantSkill: $e');
    }
    return result;
  }

  @override
  Future<ProfileApplicantSkillResponse> putProfileApplicantSkillById(String url,
      String id, ProfileApplicantSkill request, String accessToken) async {
    var result = ProfileApplicantSkillResponse();
    try {
      Response response = await Dio().put(url + "/" + id,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result =
          ProfileApplicantSkillResponse.profileApplicantSkillResponseFromJson(
              jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putProfileApplicantSkillById: $e');
    }
    return result;
  }

  @override
  Future<String> deleteProfileApplicantSkillById(
      String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteProfileApplicantSkillById: $e');
    }
    return result;
  }
}
