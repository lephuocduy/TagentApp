import 'dart:convert';

import 'package:it_job_mobile/models/entity/like.dart';

class LikeResponse {
  LikeResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Like? data;

  factory LikeResponse.fromJson(Map<String, dynamic> json) => LikeResponse(
        code: json["code"],
        msg: json["msg"],
        data: Like.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static LikeResponse likeResponseFromJson(String str) =>
      LikeResponse.fromJson(json.decode(str));

  String likeResponseToJson(LikeResponse data) => json.encode(data.toJson());
}
