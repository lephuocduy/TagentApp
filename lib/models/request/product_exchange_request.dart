class ProductExchangeRequest {
  ProductExchangeRequest({
    required this.createBy,
    required this.productId,
    required this.quantity,
  });

  final String createBy;
  final String productId;
  final int quantity;

  factory ProductExchangeRequest.fromJson(Map<String, dynamic> json) =>
      ProductExchangeRequest(
        createBy: json["create_by"],
        productId: json["product_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "create_by": createBy,
        "product_id": productId,
        "quantity": quantity,
      };
}
