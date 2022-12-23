import 'dart:convert';

import 'package:it_job_mobile/models/entity/paging.dart';
import 'package:it_job_mobile/models/entity/product.dart';

class ProductsResponse {
  int? code;
  Paging? paging;
  String? msg;
  List<Product> data;

  ProductsResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static ProductsResponse productsResponseFromJson(String str) =>
      ProductsResponse.fromJson(json.decode(str));

  String productsResponseToJson(ProductsResponse data) =>
      json.encode(data.toJson());
}
