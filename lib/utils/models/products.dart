class Product {
  final int? id;
  final String? brand;
  final String? products;
  final String? category;
  final String? description;
  final int? quantityIdentifier;
  final int? stock;
  final String? currentOwner;
  final String? locationName;
  final String? price;
  final String? photo;

  Product({
    this.id,
    this.brand,
    this.products,
    this.category,
    this.description,
    this.quantityIdentifier,
    this.stock,
    this.currentOwner,
    this.locationName,
    this.price,
    this.photo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      brand: json["brand"],
      products: json["products"],
      category: json["category"],
      description: json["description"],
      quantityIdentifier: json["quantityIdentifier"] is int
          ? json["quantityIdentifier"]
          : int.tryParse(json["quantityIdentifier"].toString()),
      stock: json["stock"] is int
          ? json["stock"]
          : int.tryParse(json["stock"].toString()),
      currentOwner: json["currentOwner"],
      locationName: json["locationName"],
      price: json["price"]?.toString(),
      photo: json["photo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "brand": brand,
      "products": products,
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
