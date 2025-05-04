class SupplyStep {
  final int? id;
  final int? productId;
  final String? fromAddress;
  final String? toAddress;
  final int? timestamp;
  final String? name;
  final String? location;
  final int? addressType;

  SupplyStep({
    this.id,
    this.productId,
    this.fromAddress,
    this.toAddress,
    this.timestamp,
    this.name,
    this.location,
    this.addressType,
  });

  /// **JSON'dan Nesneye Dönüştürme (Factory Constructor)**
  factory SupplyStep.fromJson(Map<String, dynamic> json) {
    return SupplyStep(
      id: json["id"],
      productId: json["productId"],
      fromAddress: json["fromAddress"],
      toAddress: json["toAddress"],

      timestamp:
          json["timestamp"] is int
              ? json["timestamp"]
              : int.tryParse(json["timestamp"].toString()),
      name: json["name"],
      location: json["location"],
      addressType:
          json["addressType"] is int
              ? json["addressType"]
              : int.tryParse(json["addressType"].toString()),
    );
  }

  /// **Nesneyi JSON'a Dönüştürme**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "fromAddress": fromAddress,
      "toAddress": toAddress,
      "timestamp": timestamp,
      "name": name,
      "location": location,
      "addressType": addressType,
    };
  }
}
