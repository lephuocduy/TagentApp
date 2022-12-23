import 'dart:convert';

class StoreImageResponse {
  StoreImageResponse({
    required this.id,
    required this.urlImage,
    required this.profileApplicantId,
    required this.createDate,
  });

  String id;
  String urlImage;
  String profileApplicantId;
  DateTime createDate;

  factory StoreImageResponse.fromJson(Map<String, dynamic> json) =>
      StoreImageResponse(
        id: json["id"],
        urlImage: json["url_image"],
        profileApplicantId: json["profile_applicant_id"],
        createDate: DateTime.parse(json["create_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url_image": urlImage,
        "profile_applicant_id": profileApplicantId,
        "create_date": createDate.toIso8601String(),
      };

  static StoreImageResponse storeImageResponseFromJson(String str) =>
      StoreImageResponse.fromJson(json.decode(str));

  String storeImageResponseToJson(StoreImageResponse data) =>
      json.encode(data.toJson());
  
  static List<StoreImageResponse> storeImagesResponseFromJson(String str) => List<StoreImageResponse>.from(json.decode(str).map((x) => StoreImageResponse.fromJson(x)));

  String storeImagesResponseToJson(List<StoreImageResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
