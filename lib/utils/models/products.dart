class Product {
  final String? category;
  final String? product;
  final String? description;
  final String? price;
  final int? stock;
  final String? photo;

  Product({
    this.category,
    this.product,
    this.description,
    this.price,
    this.stock,
    this.photo,
  });

  /// **JSON'dan Nesneye Dönüştürme (Factory Constructor)**
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json["category"], // 'catagory' düzeltilmiş hali
      product: json["product"],
      description: json["description"],
      price:
          json["price"]
              ?.toString(), // Fiyat integer gelebilir, string'e çevrildi
      stock:
          json["stock"] is int
              ? json["stock"]
              : int.tryParse(json["stock"].toString()),
      photo: json["photo"],
    );
  }

  /// **Nesneyi JSON'a Dönüştürme**
  Map<String, dynamic> toJson() {
    return {
      "category": category, // 'catagory' yerine düzeltildi
      "product": product,
      "description": description,
      "price": price,
      "stock": stock,
      "photo": photo,
    };
  }
}
