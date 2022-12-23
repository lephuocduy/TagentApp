import 'dart:convert';

import 'package:it_job_mobile/models/entity/transaction_reward_exchange.dart';

import '../entity/paging.dart';

class TransactionRewardExchangesResponse {
  TransactionRewardExchangesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<TransactionRewardExchange> data;

  factory TransactionRewardExchangesResponse.fromJson(
          Map<String, dynamic> json) =>
      TransactionRewardExchangesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<TransactionRewardExchange>.from(
            json["data"].map((x) => TransactionRewardExchange.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static TransactionRewardExchangesResponse
      transactionRewardExchangesResponseFromJson(String str) =>
          TransactionRewardExchangesResponse.fromJson(json.decode(str));

  String transactionRewardExchangesResponseToJson(
          TransactionRewardExchangesResponse data) =>
      json.encode(data.toJson());
}
