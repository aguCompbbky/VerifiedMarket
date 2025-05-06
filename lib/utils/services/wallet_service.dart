import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletService {
  static const String baseUrl = 'http://agumobile.site';  // Sunucu URL'niz

  // Bakiye çekme
  Future<double> getBalance(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_balance.php?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return double.parse(data['balance'].toString());
      } else {
        throw Exception('Bakiye alınırken hata oluştu: ${data['error']}');
      }
    } else {
      throw Exception('Bakiye alınırken ağ hatası');
    }
  }

  // Bakiye güncelleme
 Future<bool> updateBalance(int userId, double amount) async {
  try {
    final response = await http.post(
      Uri.parse("http://your-api-url/wallet_update.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'amount': amount,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['success']) {
      print("Bakiye başarıyla güncellendi.");
      return true; // Başarılı
    } else {
      print("Bakiye güncellenirken hata oluştu: ${data['error']}");
      return false; // Hata durumunda false döndür
    }
  } catch (e) {
    print("Bakiye güncellenirken bir hata oluştu: $e");
    return false; // Hata durumunda false döndür
  }
}


}
