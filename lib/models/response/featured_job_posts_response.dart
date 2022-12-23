import 'dart:convert';

import 'package:it_job_mobile/models/entity/featured_job_post.dart';

import '../entity/paging.dart';

class FeaturedJobPostsResponse {
  FeaturedJobPostsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<FeaturedJobPost> data;

  factory FeaturedJobPostsResponse.fromJson(Map<String, dynamic> json) =>
      FeaturedJobPostsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<FeaturedJobPost>.from(json["data"].map((x) => FeaturedJobPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static FeaturedJobPostsResponse featuredJobPostsResponseFromJson(String str) =>
      FeaturedJobPostsResponse.fromJson(json.decode(str));

  String featuredJobPostsResponseToJson(FeaturedJobPostsResponse data) =>
      json.encode(data.toJson());
}
