import 'dart:convert';

import '../entity/like.dart';
import '../entity/paging.dart';

class LikesResponse {
  LikesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Like> data;

  factory LikesResponse.fromJson(Map<String, dynamic> json) => LikesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Like>.from(json["data"].map((x) => Like.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static LikesResponse likesResponseFromJson(String str) =>
      LikesResponse.fromJson(json.decode(str));

  String likesResponseToJson(LikesResponse data) => json.encode(data.toJson());
}
