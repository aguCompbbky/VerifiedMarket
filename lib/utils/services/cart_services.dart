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

  static Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cart = await getCartItems();

    bool exists = false;
    for (var item in cart) {
      if (item.product.id == product.id) {
        item.quantity += 1; // miktarı 1 artır
        exists = true;
        break;
      }
    }

    if (!exists) {
      cart.add(CartItem(product: product, quantity: 1));
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cart = await getCartItems();

    for (var item in cart) {
      if (item.product.id == productId) {
        if (item.quantity > 1) {
          item.quantity -= 1; // miktarı 1 azalt
        } else {
          cart.remove(item); // miktar 1 ise tamamen sil
        }
        break;
      }
    }

    await prefs.setString(
      _cartKey,
      jsonEncode(cart.map((e) => e.toJson()).toList()),
    );
  }

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

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode([]));
  }

  static Future<void> purchaseCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("loggedInEmail") ?? "";

    await prefs.setString(
      _purchaseKey,
      jsonEncode(cart.map((e) => e.toJson()).toList()),
    );

    for (final item in cart) {
      await recordPurchase(
        item.product,
        email,
      ); // <- ürün doğru şekilde çekiliyor
    }

    await clearCart();
  }

  static Future<void> recordPurchase(Product product, String email) async {
    final response = await http.post(
      Uri.parse("${Connection.baseUrl}/record_purchase.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "product": product.product,
        "price": product.price,
      }),
    );

    final data = jsonDecode(response.body);
    if (!data['success']) {
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
