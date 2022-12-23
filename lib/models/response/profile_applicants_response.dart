import 'dart:convert';

import 'package:it_job_mobile/models/entity/paging.dart';
import 'package:it_job_mobile/models/entity/profile_applicant.dart';

class ProfileApplicantsResponse {
  ProfileApplicantsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<ProfileApplicant> data;

  factory ProfileApplicantsResponse.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<ProfileApplicant>.from(
            json["data"].map((x) => ProfileApplicant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static ProfileApplicantsResponse profileApplicantsResponseFromJson(
          String str) =>
      ProfileApplicantsResponse.fromJson(json.decode(str));

  String profileApplicantsResponseToJson(ProfileApplicantsResponse data) =>
      json.encode(data.toJson());
}
