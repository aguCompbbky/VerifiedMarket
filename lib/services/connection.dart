import 'dart:convert';
import 'package:http/http.dart' as http;

class Connection {
  static const String baseUrl = "http://10.0.2.2/api"; // XAMPP için

  static Future<String> register(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    return data['message'];
  }

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    return data['message'];
  }
}
