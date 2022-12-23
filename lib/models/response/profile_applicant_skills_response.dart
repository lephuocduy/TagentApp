import 'dart:convert';

import 'package:it_job_mobile/models/entity/profile_applicant_skill.dart';

import '../entity/paging.dart';

class ProfileApplicantSkillsResponse {
  ProfileApplicantSkillsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<ProfileApplicantSkill> data;

  factory ProfileApplicantSkillsResponse.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantSkillsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<ProfileApplicantSkill>.from(
            json["data"].map((x) => ProfileApplicantSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static ProfileApplicantSkillsResponse profileApplicantSkillsResponseFromJson(
          String str) =>
      ProfileApplicantSkillsResponse.fromJson(json.decode(str));

  String profileApplicantSkillsResponseToJson(
          ProfileApplicantSkillsResponse data) =>
      json.encode(data.toJson());
}
