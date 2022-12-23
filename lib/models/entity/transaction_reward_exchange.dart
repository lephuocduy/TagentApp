import 'package:it_job_mobile/models/entity/product.dart';

class TransactionRewardExchange {
  TransactionRewardExchange({
    required this.id,
    required this.total,
    required this.createDate,
    required this.typeOfTransaction,
    required this.createBy,
    required this.walletId,
    required this.productId,
    required this.quantity,
    required this.product,
  });

  String id;
  double total;
  DateTime createDate;
  String typeOfTransaction;
  String createBy;
  String walletId;
  String productId;
  int quantity;
  Product product;

  factory TransactionRewardExchange.fromJson(Map<String, dynamic> json) =>
      TransactionRewardExchange(
        id: json["id"],
        total: json["total"],
        createDate: DateTime.parse(json["create_date"]),
        typeOfTransaction: json["type_of_transaction"],
        createBy: json["create_by"],
        walletId: json["wallet_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "create_date": createDate.toIso8601String(),
        "type_of_transaction": typeOfTransaction,
        "create_by": createBy,
        "wallet_id": walletId,
        "product_id": productId,
        "quantity": quantity,
        "product": product.toJson(),
      };
}
