// To parse this JSON data, do
//
//     final configurationResponse = configurationResponseFromJson(jsonString);

import 'dart:convert';

class ConfigurationResponse {
  ConfigurationResponse({
    required this.likeDailyLimit,
    required this.shareDailyLimit,
    required this.earnByLike,
    required this.earnByShare,
    required this.earnByMatch,
  });

  int likeDailyLimit;
  int shareDailyLimit;
  int earnByLike;
  int earnByShare;
  int earnByMatch;

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) =>
      ConfigurationResponse(
        likeDailyLimit: json["like_daily_limit"],
        shareDailyLimit: json["share_daily_limit"],
        earnByLike: json["earn_by_like"],
        earnByShare: json["earn_by_share"],
        earnByMatch: json["earn_by_match"],
      );

  Map<String, dynamic> toJson() => {
        "like_daily_limit": likeDailyLimit,
        "share_daily_limit": shareDailyLimit,
        "earn_by_like": earnByLike,
        "earn_by_share": earnByShare,
        "earn_by_match": earnByMatch,
      };

  static ConfigurationResponse configurationResponseFromJson(String str) =>
      ConfigurationResponse.fromJson(json.decode(str));

  String configurationResponseToJson(ConfigurationResponse data) =>
      json.encode(data.toJson());
}
