import 'package:flutter/material.dart';
import 'package:foodapp/mainScreen.dart';
import '../services/connection.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();


  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }

Future<void> _handleLogin() async {
  String email = emailC.text.trim();
  String password = passC.text.trim();

  if (email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text("Boş alan bırakmayın.")),
    );
    return;
  }

  String message = await Connection.login(email, password);
  if (message == "Giriş başarılı.") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MarketApp()),
      );
    } else {
      _showDialog(message);
    }

  print("Email: $email");
  print("Password: $password");

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailC,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: passC,
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleLogin,
          child: Text("Giriş Yap"),
        ),
      ],
    );
  }
}
