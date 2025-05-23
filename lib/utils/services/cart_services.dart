import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/utils/services/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp/utils/models/products.dart'; // Burada Product ve CartItem modellerini kullanıyoruz.
import 'package:foodapp/utils/services/wallet_services.dart'; // Bakiyeyi kontrol etmek için

class CartService {
  static const String _cartKey =
      'cart'; // Sepet verilerini SharedPreferences'de saklamak için anahtar
  static const String _purchaseKey =
      'purchase_history'; // Satın alma geçmişini saklamak için anahtar

  // Sepete ürün ekleme
  static Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cart =
        await getCartItems(); // Mevcut sepete ürünleri alıyoruz

    bool exists = false;
    for (var item in cart) {
      if (item.product.id == product.id) {
        item.quantity += 1; // Eğer ürün zaten sepette varsa, miktarını artır
        exists = true;
        break;
      }
    }

    if (!exists) {
      cart.add(
        CartItem(product: product, quantity: 1),
      ); // Ürün yoksa yeni bir item ekle
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(
        cart.map((e) => e.toJson()).toList(),
      ), // Sepeti SharedPreferences'e kaydet
    );
  }

  static void showAddToCartMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sepete 1 adet eklendi. Miktarı değiştirmek için sepetinizi kontrol edin.',
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  // Ürün miktarını azaltma
  static Future<void> decreaseQuantity(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cart = await getCartItems();

    for (var i = 0; i < cart.length; i++) {
      if (cart[i].product.id == productId) {
        if (cart[i].quantity > 1) {
          cart[i].quantity -= 1; // Bir azalt
        } else {
          cart.removeAt(i); // Miktar zaten 1 ise tamamen kaldır
        }
        break;
      }
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e.toJson()).toList()),
    );
  }

  // Sepetten ürün çıkarma
  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cart = await getCartItems(); // Sepeti alıyoruz

    cart.removeWhere(
      (item) => item.product.id == productId,
    ); // Ürünü sepette bulup çıkarıyoruz

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e.toJson()).toList()), // Yeni sepeti kaydet
    );
  }

  // Sepetteki tüm ürünleri alma
  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_cartKey);

    if (jsonString != null) {
      try {
        List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print("JSON çözümleme hatası: $e");
        return [];
      }
    }
    return [];
  }

  // Sepeti temizleme
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode([])); // Sepeti boşalt
  }

  // Sepet ürünlerini satın alma işlemi
  Future<void> purchaseCart(List<CartItem> cart, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final email =
        prefs.getString("loggedInEmail") ??
        ""; // Kullanıcı e-posta bilgisi alınıyor

    // Sepet ürünlerinin toplam fiyatını hesapla
    double totalPrice = cart.fold(0.0, (sum, item) {
      double price =
          double.tryParse(
            item.product.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "0",
          ) ??
          0.0;
      return sum + price * item.quantity; // Miktar ile fiyatı çarp
    });

  // Kullanıcı bakiyesini al
  final userId = prefs.getInt("loggedInUserId");
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı bilgisi bulunamadı.")));
    return;
  }

  // Bakiyeyi double türünde alıyoruz
  double balance = (await WalletService.getBalance(userId)).toDouble(); // Bakiyeyi al

// Eğer yeterli bakiye varsa
if (balance >= totalPrice) {

// satın alma geçmişine ekle
  for (var item in cart) {
  await recordPurchase(item.product, email);
}

  //stock güncelle 
 for (var item in cart) {
  print("Stok güncelleme isteği gönderiliyor: productId=${item.product.id}, quantity=${item.quantity}");
  bool stockUpdated = await updateProductStock(item.product.id ?? 0, item.quantity);
  print("Stok güncelleme sonucu: $stockUpdated");
}

  // Bakiyeyi güncelle
  bool success = await WalletService.updateBalance(userId, (-totalPrice).toInt()); // Bakiyeyi int olarak azaltma
 // Bakiyeyi azaltma

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Satın alma tamamlandı ✅")));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bakiye güncellenirken hata oluştu.")));
  }
} else {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yetersiz bakiye 💸")));
}


}

Future<bool> updateProductStock(int productId, int quantityPurchased) async {
  try {
    final response = await http.post(
      Uri.parse("${Connection.baseUrl}/update_stock.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_id': productId,
        'quantity_purchased': quantityPurchased,
      }),
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  } catch (e) {
    print("Stok güncellenirken hata: $e");
    return false;
  }
}


  // Satın alma işlemi kaydetme
static Future<void> recordPurchase(Product product, String email) async {
  final response = await http.post(
    Uri.parse("${Connection.baseUrl}/record_purchase.php"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "email": email,
      "productId": product.id,
      "productName": product.product,
      "productPrice": product.price,
    }),
  );

  final data = jsonDecode(response.body);
  print("recordPurchase response: $data");

  if (data['success'] != true) {
    print("Satın alım SQL'e kaydedilemedi: ${data['message']}");
  }
}



}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
