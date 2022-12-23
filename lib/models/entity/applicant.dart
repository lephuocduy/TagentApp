class Applicant {
  const Applicant({
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.avatar,
    required this.gender,
    required this.dob,
    required this.address,
    required this.earnMoney,
  });

  final String id;
  final String phone;
  final String email;
  final String name;
  final String avatar;
  final int gender;
  final DateTime dob;
  final String address;
  final int earnMoney;

  Applicant copy({
    String? id,
    String? phone,
    String? email,
    String? name,
    String? avatar,
    int? gender,
    DateTime? dob,
    String? address,
    int? earnMoney,
  }) =>
      Applicant(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender,
        dob: dob ?? this.dob,
        address: address ?? this.address,
        earnMoney: earnMoney ?? this.earnMoney,
      );

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        name: json["name"] ?? "",
        avatar: json["avatar"] ?? "",
        gender: json["gender"] ?? 3,
        dob: DateTime.parse(json["dob"] ?? "1969-01-01").toLocal(),
        address: json["address"] ?? "",
        earnMoney: json["earn_money"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "email": email,
        "name": name,
        "avatar": avatar,
        "gender": gender,
        "dob": dob.toIso8601String(),
        "address": address,
        "earn_money": earnMoney,
      };
}
