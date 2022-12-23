import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_post.dart';

class JobPostResponse {
  JobPostResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  JobPost? data;

  factory JobPostResponse.fromJson(Map<String, dynamic> json) =>
      JobPostResponse(
        code: json["code"],
        msg: json["msg"],
        data: JobPost.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static JobPostResponse jobPostResponseFromJson(String str) =>
      JobPostResponse.fromJson(json.decode(str));

  String jobPostResponseToJson(JobPostResponse data) =>
      json.encode(data.toJson());
}
