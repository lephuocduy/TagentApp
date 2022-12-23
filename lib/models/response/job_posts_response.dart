import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_post.dart';

import '../entity/paging.dart';

class JobPostsResponse {
  JobPostsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<JobPost> data;

  factory JobPostsResponse.fromJson(Map<String, dynamic> json) =>
      JobPostsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<JobPost>.from(json["data"].map((x) => JobPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static JobPostsResponse jobPostsResponseFromJson(String str) =>
      JobPostsResponse.fromJson(json.decode(str));

  String jobPostsResponseToJson(JobPostsResponse data) =>
      json.encode(data.toJson());
}
