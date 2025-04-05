import 'dart:convert';
import 'package:http/http.dart' as http;

class Connection {
  static const String baseUrl = "http://10.0.2.2/api"; // XAMPP için

  static String loggedInEmail = "";



  static Future<String> register(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email, 
        "password": password, 
        "username":username,
        }),
    );
    print("YANIT: ${response.body}");

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





  static Future<Map<String, dynamic>> getUser() async {
    final response = await http.post(
      Uri.parse("$baseUrl/get_user.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": loggedInEmail}),
    );

    final data = jsonDecode(response.body);
    return data; // email, username, password gibi alanlar olacak
  }

static Future<bool> updateUserField(String email, String field, String value) async {
  final response = await http.post(
    Uri.parse("$baseUrl/update_user.php"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "email": email,
      "field": field,
      "value": value,
    }),
  );

  final data = jsonDecode(response.body);
  return data['success'] == true;
}


}
