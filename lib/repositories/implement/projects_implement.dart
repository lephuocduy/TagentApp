import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/project_response.dart';
import 'package:it_job_mobile/models/request/project_request.dart';
import 'package:it_job_mobile/models/entity/project.dart';
import 'package:it_job_mobile/models/response/projects_response.dart';

import '../../models/entity/paging.dart';
import '../interface/projects_interface.dart';

class ProjectsImplement implements ProjectsInterface {
  @override
  Future<ProjectsResponse> getProjectsById(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?profileApplicantId=" + id);
      if (response.statusCode == 200) {
        result = ProjectsResponse.projectsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ProjectsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getProjectsById: $e');
      result = ProjectsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<ProjectResponse> postProject(
      String url, ProjectRequest request, String accessToken) async {
    var result = ProjectResponse();
    try {
      Response response = await Dio().post(url,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result =
          ProjectResponse.projectResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postProject: $e');
    }
    return result;
  }

  @override
  Future<ProjectResponse> putProjectById(
      String url, String id, Project request, String accessToken) async {
    var result = ProjectResponse();
    try {
      Response response = await Dio().put(url + "?id=" + id,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result =
          ProjectResponse.projectResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putProjectById: $e');
    }
    return result;
  }

  @override
  Future<String> deleteProjectById(
      String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteProjectById: $e');
    }
    return result;
  }
}
