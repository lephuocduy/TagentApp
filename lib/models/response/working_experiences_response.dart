import 'dart:convert';

import 'package:it_job_mobile/models/entity/paging.dart';
import 'package:it_job_mobile/models/entity/working_experience.dart';

class WorkingExperiencesResponse {
  WorkingExperiencesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<WorkingExperience> data;

  factory WorkingExperiencesResponse.fromJson(Map<String, dynamic> json) =>
      WorkingExperiencesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<WorkingExperience>.from(
            json["data"].map((x) => WorkingExperience.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static WorkingExperiencesResponse workingExperiencesResponseFromJson(
          String str) =>
      WorkingExperiencesResponse.fromJson(json.decode(str));

  String workingExperiencesResponseToJson(WorkingExperiencesResponse data) =>
      json.encode(data.toJson());
}
