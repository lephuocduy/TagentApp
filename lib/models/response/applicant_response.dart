import 'dart:convert';

import 'package:it_job_mobile/models/entity/applicant.dart';

class ApplicantResponse {
  const ApplicantResponse({
    this.code,
    this.msg,
    this.data,
  });

  final int? code;
  final String? msg;
  final Applicant? data;

  factory ApplicantResponse.fromJson(Map<String, dynamic> json) =>
      ApplicantResponse(
        code: json["code"],
        msg: json["msg"],
        data: Applicant.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static ApplicantResponse applicantsResponseFromJson(String str) =>
      ApplicantResponse.fromJson(json.decode(str));

  String applicantsResponseToJson(ApplicantResponse data) =>
      json.encode(data.toJson());
}
