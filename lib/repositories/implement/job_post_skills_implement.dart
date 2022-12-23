import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/job_post_skills_response.dart';

import '../../models/entity/paging.dart';
import '../interface/job_post_skills_interface.dart';

class JobPostSkillsImplement implements JobPostSkillsInterface {
  @override
  Future<JobPostSkillsResponse> getJobPostSkillsById(
      String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?jobPostId=" + id);
      if (response.statusCode == 200) {
        result = JobPostSkillsResponse.jobPostSkillsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = JobPostSkillsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getJobPostSkillsById: $e');
      result = JobPostSkillsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
