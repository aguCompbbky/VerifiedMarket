import 'package:flutter/material.dart';
import 'package:foodapp/logic/models/dp_helper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // E-mail girişi
              TextField(
          decoration: InputDecoration(labelText: "Email"),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        SizedBox(height: 24),
              // Giriş yap butonu
              OutlinedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  // Burada email ve şifreyi kullanarak işlem yapabilirsiniz
                  print("Email: $email, Password: $password");
                },
                child: Text("Login"),
              ),
            ],
          );
      
    
  }
}