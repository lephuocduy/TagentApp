import 'dart:convert';

import 'package:it_job_mobile/models/entity/wallet.dart';

import '../entity/paging.dart';

class WalletResponse {
  WalletResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Wallet> data;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Wallet>.from(json["data"].map((x) => Wallet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static WalletResponse walletResponseFromJson(String str) =>
      WalletResponse.fromJson(json.decode(str));

  String walletResponseToJson(WalletResponse data) =>
      json.encode(data.toJson());
}
