import 'dart:convert';

import 'package:it_job_mobile/models/entity/certificate.dart';

import '../entity/paging.dart';

class CertificatesResponse {
  CertificatesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<Certificate> data;

  factory CertificatesResponse.fromJson(Map<String, dynamic> json) =>
      CertificatesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Certificate>.from(
            json["data"].map((x) => Certificate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static CertificatesResponse certificateResponseFromJson(String str) =>
      CertificatesResponse.fromJson(json.decode(str));

  String certificateResponseToJson(CertificatesResponse data) =>
      json.encode(data.toJson());
}
