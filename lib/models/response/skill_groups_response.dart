import 'dart:convert';

import 'package:it_job_mobile/models/entity/skill_group.dart';

import '../entity/paging.dart';

class SkillGroupsResponse {
  SkillGroupsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<SkillGroup> data;

  factory SkillGroupsResponse.fromJson(Map<String, dynamic> json) =>
      SkillGroupsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<SkillGroup>.from(
            json["data"].map((x) => SkillGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static SkillGroupsResponse skillGroupsResponseFromJson(String str) =>
      SkillGroupsResponse.fromJson(json.decode(str));

  String skillGroupsResponseToJson(SkillGroupsResponse data) =>
      json.encode(data.toJson());
}
