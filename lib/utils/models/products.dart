class Product {
  final int? id;
  final String? brand;
  final String? product;
  final String? category;
  final String? description;
  final int? quantityIdentifier;
  final String? locationName;
  final String? price;
  final int? stock;
  final String? currentOwner;

  final String? photo;

  Product({
    this.id,
    this.brand,
    this.product,
    this.category,
    this.description,
    this.quantityIdentifier,
    this.locationName,
    this.price,
    this.stock,
    this.currentOwner,
    this.photo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      brand: json["brand"],
      category: json["category"],
      product: json["products"],
      description: json["description"],
      quantityIdentifier:
          json["quantityIdentifier"] is int
              ? json["quantityIdentifier"]
              : int.tryParse(json["quantityIdentifier"].toString()),
      price: json["price"]?.toString(),
      stock:
          json["stock"] is int
              ? json["stock"]
              : int.tryParse(json["stock"].toString()),
      photo: json["photo"],
      currentOwner: json["currentOwner"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "brand": brand,
      "products": product,
      "category": category,
      "description": description,
      "quantityIdentifier": quantityIdentifier,
      "stock": stock,
      "currentOwner": currentOwner,
      "locationName": locationName,
      "price": price,
      "photo": photo,
    };
  }
}
