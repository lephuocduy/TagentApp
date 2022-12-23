import 'dart:convert';

import 'package:it_job_mobile/models/entity/company.dart';

class CompanyResponse {
  CompanyResponse({
    this.code,
    this.msg,
    required this.data,
  });

  int? code;
  String? msg;
  Company data;

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      CompanyResponse(
        code: json["code"],
        msg: json["msg"],
        data: Company.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.toJson(),
      };

  static CompanyResponse companyResponseFromJson(String str) =>
      CompanyResponse.fromJson(json.decode(str));

  String companyResponseToJson(CompanyResponse data) =>
      json.encode(data.toJson());
}
