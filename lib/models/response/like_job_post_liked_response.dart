import 'dart:convert';

import 'package:it_job_mobile/models/entity/like_job_post_liked.dart';

class LikeJobPostLikedResponse {
  LikeJobPostLikedResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  LikeJobPostLiked? data;

  factory LikeJobPostLikedResponse.fromJson(Map<String, dynamic> json) =>
      LikeJobPostLikedResponse(
        code: json["code"],
        msg: json["msg"],
        data: LikeJobPostLiked.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static LikeJobPostLikedResponse likeJobPostLikedResponseFromJson(
          String str) =>
      LikeJobPostLikedResponse.fromJson(json.decode(str));

  String likeJobPostLikedResponseToJson(LikeJobPostLikedResponse data) =>
      json.encode(data.toJson());
}
