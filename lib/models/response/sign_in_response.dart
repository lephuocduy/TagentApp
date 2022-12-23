import 'dart:convert';

class SignInResponse {
  SignInResponse({
    this.token,
  });

  final String? token;

  SignInResponse copy({
    String? token,
  }) =>
      SignInResponse(token: token ?? this.token);

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };

  static SignInResponse signInResponseFromJson(String str) =>
      SignInResponse.fromJson(json.decode(str));

  String signInResponseToJson(SignInResponse data) =>
      json.encode(data.toJson());
}
