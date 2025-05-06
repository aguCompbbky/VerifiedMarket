class Purchasehistory {
  final int? id;
  final int? productId;
  final String? email;
  final String? productName;
  final int? price;
  final String? pruchaseHistory;

  Purchasehistory({
    this.id,
    this.productId,
    this.email,
    this.productName,
    this.price,
    this.pruchaseHistory,
  });

  /// **JSON'dan Nesneye Dönüştürme (Factory Constructor)**
  factory Purchasehistory.fromJson(Map<String, dynamic> json) {
    return Purchasehistory(
      id: json["id"],
      productId: json["productId"],
      email: json["email"],
      productName: json["productName"],

      price:
          json["price"] is int
              ? json["price"]
              : int.tryParse(json["price"].toString()),
      pruchaseHistory: json["pruchaseHistory"],
    );
  }

  /// **Nesneyi JSON'a Dönüştürme**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "email": email,
      "productName": productName,
      "price": price,
      "pruchaseHistory": pruchaseHistory,
    };
  }
}
