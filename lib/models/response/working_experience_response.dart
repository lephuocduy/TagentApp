import 'dart:convert';

import 'package:it_job_mobile/models/entity/working_experience.dart';

class WorkingExperienceResponse {
  WorkingExperienceResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  WorkingExperience? data;

  factory WorkingExperienceResponse.fromJson(Map<String, dynamic> json) =>
      WorkingExperienceResponse(
        code: json["code"],
        msg: json["msg"],
        data: WorkingExperience.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static WorkingExperienceResponse workingExperienceResponseFromJson(
          String str) =>
      WorkingExperienceResponse.fromJson(json.decode(str));

  String workingExperienceResponseToJson(WorkingExperienceResponse data) =>
      json.encode(data.toJson());
}
