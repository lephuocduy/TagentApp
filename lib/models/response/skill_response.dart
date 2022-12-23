import 'dart:convert';

import 'package:it_job_mobile/models/entity/skill.dart';

class SkillResponse {
  SkillResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Skill? data;

  factory SkillResponse.fromJson(Map<String, dynamic> json) => SkillResponse(
        code: json["code"],
        msg: json["msg"],
        data: Skill.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };
  static SkillResponse skillResponseFromJson(String str) =>
      SkillResponse.fromJson(json.decode(str));

  String skillResponseToJson(SkillResponse data) => json.encode(data.toJson());
}
