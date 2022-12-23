import 'dart:convert';

class TokenChatResponse {
  TokenChatResponse({
    this.token,
  });

  final String? token;

  TokenChatResponse copy({
    String? token,
  }) =>
      TokenChatResponse(token: token ?? this.token);

  factory TokenChatResponse.fromJson(Map<String, dynamic> json) =>
      TokenChatResponse(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };

  static TokenChatResponse tokenChatResponseFromJson(String str) =>
      TokenChatResponse.fromJson(json.decode(str));

  String tokenChatResponseToJson(TokenChatResponse data) =>
      json.encode(data.toJson());
}
