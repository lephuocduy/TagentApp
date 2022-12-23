import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_post_skill.dart';

import '../entity/paging.dart';

class JobPostSkillsResponse {
  JobPostSkillsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<JobPostSkill> data;

  factory JobPostSkillsResponse.fromJson(Map<String, dynamic> json) =>
      JobPostSkillsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<JobPostSkill>.from(
            json["data"].map((x) => JobPostSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static JobPostSkillsResponse jobPostSkillsResponseFromJson(String str) =>
      JobPostSkillsResponse.fromJson(json.decode(str));

  String jobPostSkillsResponseToJson(JobPostSkillsResponse data) =>
      json.encode(data.toJson());
}
