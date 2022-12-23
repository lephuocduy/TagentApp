class Transaction {
  Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.total,
    required this.createDate,
  });

  String id;
  String type;
  String description;
  String total;
  DateTime createDate;
}