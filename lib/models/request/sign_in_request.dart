class SignInRequest {
  const SignInRequest({
    required this.phone,
    required this.password,
  });

  final String phone;
  final String password;

  factory SignInRequest.fromJson(Map<String, dynamic> json) => SignInRequest(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
      };
}
