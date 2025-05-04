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
  final String? photo;
  final String? currentOwner;

  Product({
    this.id,
    this.brand,
    this.category,
    this.product,
    this.description,
    this.quantityIdentifier,
    this.locationName,
    this.price,
    this.stock,
    this.photo,
    this.currentOwner,
  });

  /// **JSON'dan Nesneye Dönüştürme (Factory Constructor)**
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      brand: json["brand"],
      category: json["category"],
      product: json["products"],
      description: json["description"],
      quantityIdentifier:
          json["quantityIdentifier"] is int
              ? json["stock"]
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

  /// **Nesneyi JSON'a Dönüştürme**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category": category, // 'catagory' yerine düzeltildi
      "products": product,
      "description": description,
      "price": price,
      "stock": stock,
      "photo": photo,
      "currentOwner": currentOwner,
    };
  }
}
