import 'dart:convert';

import 'package:it_job_mobile/models/entity/share_job_post.dart';

class ShareJobPostResponse {
  ShareJobPostResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  ShareJobPost? data;

  factory ShareJobPostResponse.fromJson(Map<String, dynamic> json) =>
      ShareJobPostResponse(
        code: json["code"],
        msg: json["msg"],
        data: ShareJobPost.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static ShareJobPostResponse shareJobPostResponseFromJson(String str) =>
      ShareJobPostResponse.fromJson(json.decode(str));

  String shareJobPostResponseToJson(ShareJobPostResponse data) =>
      json.encode(data.toJson());
}
