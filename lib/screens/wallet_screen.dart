import 'package:flutter/material.dart';
import 'package:foodapp/utils/services/wallet_services.dart';


class WalletPage extends StatefulWidget {
  final int userId;
  const WalletPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int balance = 0;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
  try {
    final result = await WalletService.getBalance(widget.userId);
    setState(() {
      balance = result;
    });
  } catch (e) {
    print("Bakiye yüklenirken hata oluştu: $e");
  }
}


  Future<void> _updateBalance(int amount) async {
    final success = await WalletService.updateBalance(widget.userId, amount);
    if (success) {
      _amountController.clear();
      _loadBalance();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("İşlem başarısız.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Cüzdanım", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bakiye Kartı
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.black,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Toplam Bakiye", style: TextStyle(color: Colors.white60, fontSize: 14)),
                    SizedBox(height: 8),
                    Text("₺$balance", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Tutar Girişi
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tutar (₺)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Butonlar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final amount = int.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) _updateBalance(amount);
                    },
                    icon: Icon(Icons.download),
                    label: Text("Para Yükle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final amount = int.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) _updateBalance(-amount);
                    },
                    icon: Icon(Icons.upload),
                    label: Text("Para Çek"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
