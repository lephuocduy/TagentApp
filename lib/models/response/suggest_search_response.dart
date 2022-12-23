import 'dart:convert';

class SuggestSearchResponse {
  SuggestSearchResponse({
    this.name,
  });

  String? name;

  factory SuggestSearchResponse.fromJson(Map<String, dynamic> json) =>
      SuggestSearchResponse(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  static List<SuggestSearchResponse> suggestSearchResponseFromJson(
          String str) =>
      List<SuggestSearchResponse>.from(
          json.decode(str).map((x) => SuggestSearchResponse.fromJson(x)));

  String suggestSearchResponseToJson(List<SuggestSearchResponse> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
