class TransactionJobPost {
  TransactionJobPost({
    required this.id,
    required this.createDate,
    required this.total,
    required this.quantity,
    required this.typeOfTransaction,
    required this.jobPostId,
    required this.transactionId,
    required this.createBy,
    required this.receiver,
  });

  String id;
  DateTime createDate;
  double total;
  int quantity;
  String typeOfTransaction;
  String jobPostId;
  String transactionId;
  String createBy;
  String receiver;

  factory TransactionJobPost.fromJson(Map<String, dynamic> json) =>
      TransactionJobPost(
        id: json["id"],
        createDate: DateTime.parse(json["create_date"]),
        total: json["total"],
        quantity: json["quantity"] ?? 0,
        typeOfTransaction: json["type_of_transaction"],
        jobPostId: json["job_post_id"],
        transactionId: json["transaction_id"],
        createBy: json["create_by"],
        receiver: json["receiver"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_date": createDate.toIso8601String(),
        "total": total,
        "quantity": quantity,
        "type_of_transaction": typeOfTransaction,
        "job_post_id": jobPostId,
        "transaction_id": transactionId,
        "create_by": createBy,
        "receiver": receiver,
      };
}
