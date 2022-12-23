import 'dart:convert';

import 'package:it_job_mobile/models/entity/block.dart';

class BlockResponse {
  BlockResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Block? data;

  factory BlockResponse.fromJson(Map<String, dynamic> json) => BlockResponse(
        code: json["code"],
        msg: json["msg"],
        data: Block.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static BlockResponse blockResponseFromJson(String str) =>
      BlockResponse.fromJson(json.decode(str));

  String blockResponseToJson(BlockResponse data) => json.encode(data.toJson());
}
