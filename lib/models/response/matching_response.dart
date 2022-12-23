import 'dart:convert';

import 'package:it_job_mobile/models/entity/matching.dart';

import '../entity/paging.dart';

class MatchingResponse {
  MatchingResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Matching> data;

  factory MatchingResponse.fromJson(Map<String, dynamic> json) =>
      MatchingResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data:
            List<Matching>.from(json["data"].map((x) => Matching.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static MatchingResponse matchingResponseFromJson(String str) =>
      MatchingResponse.fromJson(json.decode(str));

  String matchingResponseToJson(MatchingResponse data) =>
      json.encode(data.toJson());
}
