class SignUpRequest {
  const SignUpRequest({
    required this.phone,
    required this.password,
    required this.email,
  });

  final String phone;
  final String password;
  final String email;

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
        phone: json["phone"],
        password: json["password"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
        "email": email,
      };
}
