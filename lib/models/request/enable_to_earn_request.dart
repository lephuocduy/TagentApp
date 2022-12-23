class EnableToEarnRequest {
  EnableToEarnRequest({
    required this.id,
    required this.earnMoney,
  });

  final String id;
  final int earnMoney;

  factory EnableToEarnRequest.fromJson(Map<String, dynamic> json) =>
      EnableToEarnRequest(
        id: json["id"],
        earnMoney: json["earn_money"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "earn_money": earnMoney,
      };
}
