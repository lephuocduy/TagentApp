import 'dart:convert';

import 'package:it_job_mobile/models/entity/working_style.dart';

import '../entity/paging.dart';

class WorkingStylesResponse {
  WorkingStylesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<WorkingStyle> data;

  factory WorkingStylesResponse.fromJson(Map<String, dynamic> json) =>
      WorkingStylesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<WorkingStyle>.from(
            json["data"].map((x) => WorkingStyle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static WorkingStylesResponse workingStylesResponseFromJson(String str) =>
      WorkingStylesResponse.fromJson(json.decode(str));

  String workingStylesResponseToJson(WorkingStylesResponse data) =>
      json.encode(data.toJson());
}
