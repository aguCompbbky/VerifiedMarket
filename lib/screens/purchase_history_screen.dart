import 'package:flutter/material.dart';
import 'package:foodapp/utils/models/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/services/connection.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late Future<List<Product>> _purchases;

  @override
  void initState() {
    super.initState();
    _purchases = getPurchaseHistory();
  }

  Future<List<Product>> getPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("loggedInEmail") ?? "";
    prefs.setString("loggedInEmail", email);

    final response = await http.post(
      Uri.parse("${Connection.baseUrl}/get_purchase_history.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    if (!data['success']) throw Exception(data['message']);

    final List<dynamic> items = data['history'];
    return items.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Satın Alım Geçmişi"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Product>>(
        future: _purchases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Satın alım geçmişi boş."));
          }

          final purchases = snapshot.data!;

          return ListView.builder(
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final product = purchases[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(product.product ?? "Belirsiz"),
                  subtitle: Text(
                    product.price != null ? "${product.price} TL" : "",
                  ),
                  leading:
                      product.photo != null
                          ? Image.network(
                            product.photo!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.shopping_bag),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
