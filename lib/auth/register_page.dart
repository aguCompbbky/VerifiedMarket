import 'package:flutter/material.dart';
import 'package:foodapp/logic/models/dp_helper.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  // TextEditingController'ları burada oluşturuyoruz
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController, 
          decoration: InputDecoration(labelText: "Email"),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController, 
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true, 
        ),
        SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            // TextField'den alınan değerler
            String email = _emailController.text;
            String password = _passwordController.text;

            // Email ve şifrenin boş olup olmadığını kontrol ediyoruz
            if (email.isNotEmpty && password.isNotEmpty) {
              // Veritabanı işlemi için MySql sınıfı ile bağlantı kuruyoruz
              MySql db = MySql();
              db.setUser(email, password);  // Veritabanına kullanıcıyı ekliyoruz
              print("Registration successful for: $email");

              // Kayıt sonrası input alanlarını temizliyoruz
              _emailController.clear();
              _passwordController.clear();

              // Kullanıcıya başarılı bir kayıt mesajı gösteriyoruz
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User registered successfully!")),
              );
            } else {
              // Eğer alanlar boşsa hata mesajı gösteriyoruz
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill out all fields")),
              );
            }
          },
          child: Text("Register"),
        ),
      ],
    );
  }
}
