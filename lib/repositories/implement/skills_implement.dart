import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/skill_response.dart';
import 'package:it_job_mobile/models/response/skills_response.dart';

import '../../models/entity/paging.dart';
import '../../models/entity/skill.dart';
import '../interface/skills_interface.dart';

class SkillsImplement implements SkillsInterface {
  @override
  Future<List<Skill>> searchSkills(List<Skill> listSkill, String query) async {
    if (listSkill.isNotEmpty) {
      return listSkill.where((element) {
        final nameLower = element.name.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<SkillsResponse> getSkills(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result =
            SkillsResponse.skillsResponseFromJson(jsonEncode(response.data));
      } else {
        result = SkillsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getSkills: $e');
      result = SkillsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<SkillResponse> getSkillById(String url, String id) async {
    var result = SkillResponse();
    try {
      Response response = await Dio().get(url + "/" + id);
      result = SkillResponse.skillResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error getSkillById: $e');
    }
    return result;
  }
}
