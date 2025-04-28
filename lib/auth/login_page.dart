import 'package:flutter/material.dart';
import 'package:foodapp/auth/register_page.dart';
import 'package:foodapp/screens/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/services/connection.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool isObscure = true;

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
      Connection.loggedInEmail = emailC.text;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("loggedInEmail", emailC.text);
      Navigator.pushReplacement(
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                "      HOŞGELDİNİZ\nHALAL MARKETCAP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passC,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: isObscure,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _handleLogin();
                },

                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 160),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.horizontal(),
                  ),
                  child: Text(
                    "GİRİŞ YAP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Üye değil misin? ", style: TextStyle(fontSize: 15.5)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text("Üye Ol", style: TextStyle(fontSize: 15.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
