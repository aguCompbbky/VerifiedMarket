import 'dart:convert';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/connection.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CartService {
  static const String _cartKey = 'cart';
  static const String _purchaseKey = 'purchase_history';

  // Sepete ürün ekle
  static Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<Product> cart = await getCartItems();

    bool exists = cart.any((item) => item.id == product.id);
    if (!exists) {
      cart.add(product);
      await prefs.setString(_cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
    }
  }

  // Sepetten ürün sil
  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Product> cart = await getCartItems();
    cart.removeWhere((item) => item.id == productId);
    await prefs.setString(_cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  // Sepeti getir
  static Future<List<Product>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Product.fromJson(e)).toList();
    }
    return [];
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
    await prefs.setString(_purchaseKey, jsonEncode(updated.map((e) => e.toJson()).toList()));

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
      "product": product.product,
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