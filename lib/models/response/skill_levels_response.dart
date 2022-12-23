import 'dart:convert';

import 'package:it_job_mobile/models/entity/skill_level.dart';

import '../entity/paging.dart';

class SkillLevelsResponse {
  SkillLevelsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<SkillLevel> data;

  factory SkillLevelsResponse.fromJson(Map<String, dynamic> json) =>
      SkillLevelsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<SkillLevel>.from(
            json["data"].map((x) => SkillLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static SkillLevelsResponse skillLevelsResponseFromJson(String str) =>
      SkillLevelsResponse.fromJson(json.decode(str));

  String skillLevelsResponseToJson(SkillLevelsResponse data) =>
      json.encode(data.toJson());
}
