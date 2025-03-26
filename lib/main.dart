
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/auth.dart';

import 'package:foodapp/firebase_options.dart';
import 'package:foodapp/screens/mainScreen.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  AuthScreen(),  // Your LoginPage widget here

       initialRoute: '/',
      routes: {
       
         '/home': (context) => MarketApp(), // 'home' rotası, anasayfa
      },

    );
  }
  }

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
  
}