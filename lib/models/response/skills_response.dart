import 'dart:convert';

import 'package:it_job_mobile/models/entity/skill.dart';

import '../entity/paging.dart';

class SkillsResponse {
  SkillsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Skill> data;

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Skill>.from(json["data"].map((x) => Skill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
  static SkillsResponse skillsResponseFromJson(String str) =>
      SkillsResponse.fromJson(json.decode(str));

  String skillsResponseToJson(SkillsResponse data) =>
      json.encode(data.toJson());
}
