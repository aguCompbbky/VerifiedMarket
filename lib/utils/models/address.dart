class Address {
  final int? id;
  final String? ownerAddress;
  final String? name;
  final String? location;
  final int? addressType;
  final int? status;

  Address({
    this.id,
    this.ownerAddress,
    this.name,
    this.location,
    this.addressType,
    this.status,
  });

  /// **JSON'dan Nesneye Dönüştürme (Factory Constructor)**
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      ownerAddress: json["ownerAddress"],
      name: json["name"],
      location: json["location"],

      addressType:
          json["addressType"] is int
              ? json["addressType"]
              : int.tryParse(json["addressType"].toString()),
      status:
          json["status"] is int
              ? json["status"]
              : int.tryParse(json["status"].toString()),
    );
  }

  /// **Nesneyi JSON'a Dönüştürme**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ownerAddress": ownerAddress,
      "name": name,
      "location": location,
      "addressType": addressType,
      "status": status,
    };
  }
}
