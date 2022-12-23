import 'dart:convert';

class CheckDislikeResponse {
  CheckDislikeResponse({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  Data? data;

  factory CheckDislikeResponse.fromJson(Map<String, dynamic> json) =>
      CheckDislikeResponse(
        code: json["code"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data!.toJson(),
      };

  static CheckDislikeResponse checkDislikeResponseFromJson(String str) =>
      CheckDislikeResponse.fromJson(json.decode(str));

  String checkDislikeResponseToJson(CheckDislikeResponse data) =>
      json.encode(data.toJson());
}

class Data {
  Data({
    required this.countLike,
  });

  int countLike;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        countLike: json["count_like"],
      );

  Map<String, dynamic> toJson() => {
        "count_like": countLike,
      };
}
