import 'dart:convert';

import 'package:it_job_mobile/models/entity/profile_applicant_skill.dart';

class ProfileApplicantSkillResponse {
  ProfileApplicantSkillResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  ProfileApplicantSkill? data;

  factory ProfileApplicantSkillResponse.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantSkillResponse(
        code: json["code"],
        msg: json["msg"],
        data: ProfileApplicantSkill.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static ProfileApplicantSkillResponse profileApplicantSkillResponseFromJson(
          String str) =>
      ProfileApplicantSkillResponse.fromJson(json.decode(str));

  String profileApplicantSkillResponseToJson(
          ProfileApplicantSkillResponse data) =>
      json.encode(data.toJson());
}
