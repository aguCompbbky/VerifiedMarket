import 'package:flutter/material.dart';

import 'package:foodapp/utils/models/purchaseHistory.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/services/connection.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late Future<List<Purchasehistory>> _purchases;

@override
void initState() {
  super.initState();
  initializeDateFormatting('tr_TR', null).then((_) {
    setState(() {
      // Artık tarih formatlama hazır
    });
  });

  _purchases = getPurchaseHistory();
}

  Future<List<Purchasehistory>> getPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("loggedInEmail") ?? "";

    final response = await http.get(
      Uri.parse("${Connection.baseUrl}/get_purchase_history.php?email=$email"),
    );

    if (response.statusCode != 200) {
      throw Exception("Sunucu hatası: ${response.statusCode}");
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((e) => Purchasehistory.fromJson(e)).toList();
  }

String formatDate(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat('dd MMMM yyyy - HH:mm', 'tr_TR').format(dateTime);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Satın Alım Geçmişi"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Purchasehistory>>(
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
    title: Text(product.productName?? "Belirsiz"),
        subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("${product.price} TL"),
      Text("Tarih: ${formatDate(product.purchase_history)}"),

    ],
  ),
  leading: const Icon(Icons.shopping_bag),
)
              );
            },
          );
        },
     ),
);
}
}