import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/entity/paging.dart';
import 'package:it_job_mobile/models/response/job_position_response.dart';
import 'package:it_job_mobile/models/response/job_positions_response.dart';
import 'package:it_job_mobile/repositories/interface/job_positions_interface.dart';


class JobPositionsImplement implements JobPositionsInterface {
  @override
  Future<JobPositionsResponse> searchJobPositions(
      String url, String query) async {
    var result;
    try {
      Response response =
          await Dio().get(url + "?sort-key=Name&sort-order=ASC&name=" + query);
      if (response.statusCode == 200) {
        result = JobPositionsResponse.jobPositionsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = JobPositionsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error searchJobPositions: $e');
      result = JobPositionsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<JobPositionResponse> getJobPositionById(String url, String id) async {
    var result = JobPositionResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result = JobPositionResponse.jobPositionResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error getJobPositionById: $e');
    }
    return result;
  }

  @override
  Future<JobPositionsResponse> getJobPositions(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = JobPositionsResponse.jobPositionsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = JobPositionsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getJobPositions: $e');
      result = JobPositionsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
