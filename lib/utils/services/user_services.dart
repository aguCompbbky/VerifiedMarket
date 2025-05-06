import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "https://agumobile.site";

  static Future<int?> getUserIdFromEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_user_id.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true && data["user_id"] != null) {
          return int.tryParse(data["user_id"].toString());
        }
      }
      return null;
    } catch (e) {
      print("getUserIdFromEmail hatası: $e");
      return null;
    }
  }
}
