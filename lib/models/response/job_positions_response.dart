import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_position.dart';

import '../entity/paging.dart';

class JobPositionsResponse {
  JobPositionsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<JobPosition> data;

  factory JobPositionsResponse.fromJson(Map<String, dynamic> json) =>
      JobPositionsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<JobPosition>.from(
            json["data"].map((x) => JobPosition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static JobPositionsResponse jobPositionsResponseFromJson(String str) =>
      JobPositionsResponse.fromJson(json.decode(str));

  String jobPositionsResponseToJson(JobPositionsResponse data) =>
      json.encode(data.toJson());
}
