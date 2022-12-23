class Product {
  String id;
  String name;
  double price;
  int quantity;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
      };
}
