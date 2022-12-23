import 'dart:convert';

import 'package:it_job_mobile/models/entity/applicant.dart';

import '../entity/paging.dart';

class ApplicantsResponse {
  ApplicantsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Applicant> data;

  factory ApplicantsResponse.fromJson(Map<String, dynamic> json) =>
      ApplicantsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Applicant>.from(
            json["data"].map((x) => Applicant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static ApplicantsResponse applicantsResponseFromJson(String str) =>
      ApplicantsResponse.fromJson(json.decode(str));

  String applicantsResponseToJson(ApplicantsResponse data) =>
      json.encode(data.toJson());
}
