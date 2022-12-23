import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/skill_levels_response.dart';
import 'package:it_job_mobile/repositories/interface/skill_levels_interface.dart';

import '../../models/entity/paging.dart';

class SkillLevelsImplement implements SkillLevelsInterface {
  @override
  Future<SkillLevelsResponse> getLevelById(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?skillGroupId=" + id);
      if (response.statusCode == 200) {
        result = SkillLevelsResponse.skillLevelsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = SkillLevelsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getLevelById: $e');
      result = SkillLevelsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
