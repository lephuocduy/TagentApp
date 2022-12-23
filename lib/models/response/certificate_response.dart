import 'dart:convert';

import 'package:it_job_mobile/models/entity/certificate.dart';

class CertificateResponse {
  CertificateResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Certificate? data;

  factory CertificateResponse.fromJson(Map<String, dynamic> json) =>
      CertificateResponse(
        code: json["code"],
        msg: json["msg"],
        data: Certificate.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static CertificateResponse certificateResponseFromJson(String str) =>
      CertificateResponse.fromJson(json.decode(str));

  String certificateResponseToJson(CertificateResponse data) =>
      json.encode(data.toJson());
}
