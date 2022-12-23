import 'dart:convert';

import 'package:it_job_mobile/models/entity/project.dart';

import '../entity/paging.dart';

class ProjectsResponse {
  ProjectsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Project> data;

  factory ProjectsResponse.fromJson(Map<String, dynamic> json) =>
      ProjectsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Project>.from(json["data"].map((x) => Project.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static ProjectsResponse projectsResponseFromJson(String str) =>
      ProjectsResponse.fromJson(json.decode(str));

  String projectsResponseToJson(ProjectsResponse data) =>
      json.encode(data.toJson());
}
