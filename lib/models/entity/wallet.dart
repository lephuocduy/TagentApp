class Wallet {
  Wallet({
    required this.id,
    required this.balance,
    required this.status,
    required this.createDate,
    required this.applicantId,
  });

  String id;
  double balance;
  int status;
  DateTime createDate;
  String applicantId;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        balance: json["balance"],
        status: json["status"],
        createDate: DateTime.parse(json["create_date"]),
        applicantId: json["applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "status": status,
        "create_date": createDate.toIso8601String(),
        "applicant_id": applicantId,
      };
}
