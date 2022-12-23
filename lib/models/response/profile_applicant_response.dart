import 'dart:convert';

import 'package:it_job_mobile/models/entity/profile_applicant.dart';

class ProfileApplicantResponse {
  ProfileApplicantResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  ProfileApplicant? data;

  factory ProfileApplicantResponse.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantResponse(
        code: json["code"],
        msg: json["msg"],
        data: ProfileApplicant.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static ProfileApplicantResponse profileApplicantResponseFromJson(
          String str) =>
      ProfileApplicantResponse.fromJson(json.decode(str));

  String profileApplicantResponseToJson(ProfileApplicantResponse data) =>
      json.encode(data.toJson());
}
