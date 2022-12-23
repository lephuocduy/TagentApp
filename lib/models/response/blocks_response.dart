import 'dart:convert';

import 'package:it_job_mobile/models/entity/block.dart';

import '../entity/paging.dart';

class BlocksResponse {
  BlocksResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Block> data;

  factory BlocksResponse.fromJson(Map<String, dynamic> json) => BlocksResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Block>.from(json["data"].map((x) => Block.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static BlocksResponse blocksResponseFromJson(String str) =>
      BlocksResponse.fromJson(json.decode(str));

  String blocksResponseToJson(BlocksResponse data) =>
      json.encode(data.toJson());
}
