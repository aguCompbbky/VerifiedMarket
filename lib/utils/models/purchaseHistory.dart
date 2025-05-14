class Purchasehistory {
  final int? id;
  final int? productId;
  final String? email;
  final String? productName;
  final double? price;
  final DateTime? purchase_history;

  Purchasehistory({
    this.id,
    this.productId,
    this.email,
    this.productName,
    this.price,
    this.purchase_history,
  });

  /// JSON'dan Nesneye Dönüştürme (Factory Constructor)
  factory Purchasehistory.fromJson(Map<String, dynamic> json) {
    return Purchasehistory(
      id: json["id"],
      productId: json["productId"],
      email: json["email"],
      productName: json["productName"],
      price: json["productPrice"] is double
          ? json["productPrice"]
          : double.tryParse(json["productPrice"].toString()),
      purchase_history: json["purchase_date"] != null
          ? DateTime.parse(json["purchase_date"])
          : null,
    );
  }

  /// Nesneyi JSON'a Dönüştürme
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "email": email,
      "productName": productName,
      "productPrice": price,
      "purchase_date": purchase_history?.toIso8601String(),
    };
  }
}
