import 'package:flutter/material.dart';
import 'package:foodapp/mainScreen.dart';
import '../services/connection.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

   void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }

  Future<void> _handleRegister() async {
    String message = await Connection.register(emailC.text, passC.text);
    if (message == "Kayıt başarılı.") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MarketApp()),
      );
    } else {
      _showDialog(message);
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
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
          onPressed: _handleRegister,
          child: Text("Kayıt Ol"),
        ),
      ],
    );
  }
}
