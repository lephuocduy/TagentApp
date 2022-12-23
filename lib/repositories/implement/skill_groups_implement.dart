import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/skill_groups_response.dart';
import 'package:it_job_mobile/repositories/interface/skill_groups_interface.dart';

import '../../models/entity/paging.dart';

class SkillGroupsImplement implements SkillGroupsInterface {
  @override
  Future<SkillGroupsResponse> getSkillGroups(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = SkillGroupsResponse.skillGroupsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = SkillGroupsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getSkillGroups: $e');
      result = SkillGroupsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
