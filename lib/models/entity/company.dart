class Company {
  Company({
    required this.id,
    required this.email,
    required this.phone,
    required this.logo,
    required this.website,
    required this.status,
    required this.isPremium,
    required this.name,
    required this.description,
    required this.companyType,
  });

  String id;
  String email;
  String phone;
  String logo;
  String website;
  int status;
  bool isPremium;
  String name;
  String description;
  int companyType;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        logo: json["logo"],
        website: json["website"],
        status: json["status"],
        isPremium: json["is_premium"] ?? false,
        name: json["name"],
        description: json["description"],
        companyType: json["company_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "logo": logo,
        "website": website,
        "status": status,
        "is_premium": isPremium,
        "name": name,
        "description": description,
        "company_type": companyType,
      };
}
