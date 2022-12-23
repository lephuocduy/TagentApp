import 'dart:convert';

import 'package:it_job_mobile/models/entity/transaction_job_post.dart';

import '../entity/paging.dart';

class TransactionJobPostsResponse {
  TransactionJobPostsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<TransactionJobPost> data;

  factory TransactionJobPostsResponse.fromJson(Map<String, dynamic> json) =>
      TransactionJobPostsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<TransactionJobPost>.from(
            json["data"].map((x) => TransactionJobPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static TransactionJobPostsResponse transactionJobPostsResponseFromJson(
          String str) =>
      TransactionJobPostsResponse.fromJson(json.decode(str));

  String transactionJobPostsResponseToJson(TransactionJobPostsResponse data) =>
      json.encode(data.toJson());
}
