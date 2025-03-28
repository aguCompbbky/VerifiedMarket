import 'package:flutter/material.dart';

import 'register_page.dart'; // Kayıt ekranınızı buraya import edin
import 'login_page.dart'; // Giriş ekranınızı buraya import edin


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}



class _AuthScreenState extends State<AuthScreen> {
  bool _isRegistered = false; // Kullanıcının kaydının olup olmadığına göre durum belirleme


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 226, 140),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ekran başlığı
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              // Hesap olup olmadığını soran metin
              Text(
                _isRegistered ?  "Do not you have an account?" : "Already have an account?",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              // Giriş ya da kayıt olma butonu
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isRegistered = !_isRegistered; // Durum değiştirerek ekranı güncelle
                  });
                },
                child: Text(_isRegistered ? "No" : "Yes"),
              ),
              SizedBox(height: 32),
              // Giriş ya da kayıt olma widget'ı göster
              if (_isRegistered)
                LoginPage() // Giriş widget'ı
              else
                RegisterPage(), // Kayıt widget'ı
            ],
          ),
        ),
      ),
    );
  }
}
