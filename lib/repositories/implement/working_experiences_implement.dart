import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/entity/working_experience.dart';
import 'package:it_job_mobile/models/request/working_experience_request.dart';
import 'package:it_job_mobile/models/response/working_experience_response.dart';
import 'package:it_job_mobile/models/response/working_experiences_response.dart';

import '../../models/entity/paging.dart';
import '../interface/working_experiences_interface.dart';

class WorkingExperiencesImplement implements WorkingExperiencesInterface {
  @override
  Future<WorkingExperiencesResponse> getWorkingExperiencesById(
      String url, String id) async {
    var result;
    try {
      Response response =
          await Dio().get(url + "?sort-order=ASC&profileApplicantId=" + id);
      if (response.statusCode == 200) {
        result = WorkingExperiencesResponse.workingExperiencesResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = WorkingExperiencesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getWorkingExperiencesById: $e');
      result = WorkingExperiencesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<WorkingExperienceResponse> postWorkingExperience(
      String url, WorkingExperienceRequest request, String accessToken) async {
    var result = WorkingExperienceResponse();
    try {
      Response response = await Dio().post(url,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = WorkingExperienceResponse.workingExperienceResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postWorkingExperience: $e');
    }
    return result;
  }

  @override
  Future<WorkingExperienceResponse> putWorkingExperienceById(
      String url, String id, WorkingExperience request, String accessToken) async {
    var result = WorkingExperienceResponse();
    try {
      Response response = await Dio().put(url + "?id=" + id,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = WorkingExperienceResponse.workingExperienceResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putWorkingExperienceById: $e');
    }
    return result;
  }

  @override
  Future<String> deleteWorkingExperienceById(String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteWorkingExperienceById: $e');
    }
    return result;
  }
}
