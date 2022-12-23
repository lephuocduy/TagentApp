import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/working_styles_response.dart';

import '../../models/entity/paging.dart';
import '../interface/working_styles_interface.dart';

class WorkingStyleImplement implements WorkingStylesInterface {
  @override
  Future<WorkingStylesResponse> getWorkingStyles(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = WorkingStylesResponse.workingStylesResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = WorkingStylesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getWorkingStyles: $e');
      result = WorkingStylesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
