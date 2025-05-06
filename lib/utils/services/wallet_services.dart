import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletService {
  static const String baseUrl = "https://agumobile.site";

  static Future<int> getBalance(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_balance.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return int.tryParse(data['balance'].toString()) ?? 0;
      } else {
        throw Exception("Sunucudan geçerli cevap alınamadı.");
      }
    } catch (e) {
      print("getBalance Hatası: $e");
      return 0;
    }
  }

  static Future<bool> updateBalance(int userId, int amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet_update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": userId, "amount": amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("updateBalance Hatası: $e");
      return false;
    }
  }
}
