import 'dart:convert';

import '../entity/paging.dart';
import '../entity/store_image.dart';

class AlbumImagesResponse {
  AlbumImagesResponse({
    this.code,
    this.paging,
    this.msg,
    required this.data,
  });

  int? code;
  Paging? paging;
  String? msg;
  List<StoreImage> data;

  factory AlbumImagesResponse.fromJson(Map<String, dynamic> json) =>
      AlbumImagesResponse(
        code: json["code"],
        paging: Paging.fromJson(json["paging"]),
        msg: json["msg"],
        data: List<StoreImage>.from(
            json["data"].map((x) => StoreImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "paging": paging!.toJson(),
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static AlbumImagesResponse albumImagesResponseFromJson(String str) =>
      AlbumImagesResponse.fromJson(json.decode(str));

  String albumImagesResponseToJson(AlbumImagesResponse data) =>
      json.encode(data.toJson());
}
