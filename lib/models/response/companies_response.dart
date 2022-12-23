import 'dart:convert';

import 'package:it_job_mobile/models/entity/company.dart';

import '../entity/paging.dart';

class CompaniesResponse {
  CompaniesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Company> data;

  factory CompaniesResponse.fromJson(Map<String, dynamic> json) =>
      CompaniesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Company>.from(json["data"].map((x) => Company.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static CompaniesResponse companiesResponseFromJson(String str) =>
      CompaniesResponse.fromJson(json.decode(str));

  String companiesResponseToJson(CompaniesResponse data) =>
      json.encode(data.toJson());
}
