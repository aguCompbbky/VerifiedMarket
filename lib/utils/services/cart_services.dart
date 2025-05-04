import 'dart:convert';
import 'package:foodapp/screens/mainScreen.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/connection.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CartService {
  static const String _cartKey = 'cart';
  static const String _purchaseKey = 'purchase_history';

  // // Sepete ürün ekle
  // static Future<void> addToCart(Product product) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<Product> cart = await getCartItems();

  //   bool exists = cart.any((item) => item.id == product.id);
  //   if (!exists) {
  //     cart.add(product);
  //     await prefs.setString(
  //       _cartKey,
  //       jsonEncode(cart.map((e) => e.toJson()).toList()),
  //     );
  //   }
  // }

  // // Sepete ürün ekle 2. kod
  // static Future<void> addToCart(Product product) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<CartItem> cart = await getCartItems(); // CartItem türünde liste al

  //   bool exists = false;
  //   for (var item in cart) {
  //     if (item.product.id == product.id) {
  //       item.quantity += selectedQuantity; // Sepetteki ürün miktarını artır
  //       exists = true;
  //       break;
  //     }
  //   }

  //   if (!exists) {
  //     cart.add(
  //       CartItem(product: product, quantity: selectedQuantity),
  //     ); // Yeni CartItem ekle
  //   }

  //   await prefs.setString(
  //     _cartKey,
  //     jsonEncode(cart.map((e) => e.toJson()).toList()),
  //   );
  // }

  // // Sepetten ürün sil
  // static Future<void> removeFromCart(int productId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<Product> cart = await getCartItems();
  //   cart.removeWhere((item) => item.id == productId);
  //   await prefs.setString(
  //     _cartKey,
  //     jsonEncode(cart.map((e) => e.toJson()).toList()),
  //   );
  // }

  static Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem?> cart = await getCartItems(); // CartItem türünde liste al

    bool exists = false;
    for (var item in cart) {
      if (item?.product.id == product.id) {
        item?.quantity += selectedQuantity; // Sepetteki ürün miktarını artır
        exists = true;
        break;
      }
    }

    if (!exists) {
      cart.add(
        CartItem(product: product, quantity: selectedQuantity),
      ); // Yeni CartItem ekle
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e?.toJson()).toList()),
    );
  }

  // Sepetten ürün sil
  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem?> cart = await getCartItems();

    for (var item in cart) {
      if (item?.product.id == productId) {
        if (item!.quantity > selectedQuantity) {
          item?.quantity -= selectedQuantity; // Miktarı azalt
        } else {
          cart.remove(item); // Miktar 0'a düştüyse ürünü sepetten sil
        }
        break;
      }
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e?.toJson()).toList()),
    );
  }

  static Future<List<CartItem?>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_cartKey);

    if (jsonString != null) {
      try {
        List<dynamic> decoded = jsonDecode(jsonString);

        // `null` olan öğeleri filtreliyoruz ve doğru türde liste döndürüyoruz
        List<CartItem?> cartItems =
            decoded
                .map((e) {
                  if (e is Map<String, dynamic>) {
                    return CartItem.fromJson(
                      e,
                    ); // Map verisini CartItem'a dönüştür
                  } else {
                    print('Hatalı veri formatı: $e');
                    return null; // Hatalı veriyi `null` olarak döndürüyoruz
                  }
                })
                .where((item) => item != null)
                .toList(); // `null` olan öğeleri filtrele

        return cartItems; // `Future<List<CartItem>>` olarak döndür
      } catch (e) {
        print("JSON çözümleme hatası: $e");
        return []; // JSON hatası durumunda boş liste döndür
      }
    }
    return []; // Eğer `jsonString` null ise, boş liste döndür
  }

  // Sepeti temizle
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode([]));
  }

  // Satın alma işlemi
  static Future<void> purchaseCart(List<Product> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("loggedInEmail") ?? "";

    List<Product> updated = [...cart];
    await prefs.setString(
      _purchaseKey,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );

    for (final product in cart) {
      await recordPurchase(product, email);
    }

    await clearCart();
  }

  static Future<void> recordPurchase(Product product, String email) async {
    final response = await http.post(
      Uri.parse("${Connection.baseUrl}/record_purchase.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "product": product.products,
        "price": product.price,
      }),
    );

    final data = jsonDecode(response.body);
    if (!data['success']) {
      print("Satın alım SQL'e kaydedilemedi: ${data['message']}");
    }
    print("SUNUCU DÖNÜŞ: ${response.body}");
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // CartItem'ı JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  // JSON'dan CartItem oluşturma
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
