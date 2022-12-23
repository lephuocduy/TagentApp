import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_position.dart';

class JobPositionResponse {
  JobPositionResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  JobPosition? data;

  factory JobPositionResponse.fromJson(Map<String, dynamic> json) =>
      JobPositionResponse(
        code: json["code"],
        msg: json["msg"],
        data: JobPosition.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static JobPositionResponse jobPositionResponseFromJson(String str) =>
      JobPositionResponse.fromJson(json.decode(str));

  String jobPositionResponseToJson(JobPositionResponse data) =>
      json.encode(data.toJson());
}
