import 'dart:convert';

import 'package:it_job_mobile/models/entity/project.dart';

class ProjectResponse {
  ProjectResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Project? data;

  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      ProjectResponse(
        code: json["code"],
        msg: json["msg"],
        data: Project.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static ProjectResponse projectResponseFromJson(String str) =>
      ProjectResponse.fromJson(json.decode(str));

  String projectResponseToJson(ProjectResponse data) =>
      json.encode(data.toJson());
}
