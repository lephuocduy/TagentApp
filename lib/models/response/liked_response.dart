import 'dart:convert';

import 'package:it_job_mobile/models/entity/Liked.dart';

import '../entity/paging.dart';

class LikedResponse {
  LikedResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Liked> data;

  factory LikedResponse.fromJson(Map<String, dynamic> json) => LikedResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Liked>.from(json["data"].map((x) => Liked.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static LikedResponse likedResponseFromJson(String str) =>
      LikedResponse.fromJson(json.decode(str));

  String likedResponseToJson(LikedResponse data) => json.encode(data.toJson());
}
