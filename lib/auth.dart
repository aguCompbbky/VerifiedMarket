// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final _firebase = FirebaseAuth.instance;

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() {
//     return _AuthScreenState();
//   }
// }

// class _AuthScreenState extends State<AuthScreen> {

//   final _form = GlobalKey<FormState>();

//   var _isLogin = true;
//   var _enteredEmail = '';
//   var _enteredPassword = '';
//   var _enteredUsername = '';
//   // File? _selectedImage;
//   var _isAuthenticating = false;
//   bool _rememberMe = false; // Checkbox için durum değişkeni

//   void _submit() async {
//     final isValid = _form.currentState!.validate();

//     // if (!isValid || (!_isLogin && _selectedImage == null)) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('Please complete all required fields.')),
//     //   );
//     //   return;
//     // }

//     _form.currentState!.save();

//     try {
//       setState(() {
//         _isAuthenticating = true;
//       });

//       if (_isLogin) {
//         // Kullanıcı giriş yapıyor
//         await _firebase.signInWithEmailAndPassword(
//           email: _enteredEmail,
//           password: _enteredPassword,
//         );


//         // Giriş sonrası anasayfaya yönlendirme
//         Navigator.of(context).pushReplacementNamed('/home');
//       } else {
//         // Yeni hesap oluşturuluyor
//         final userCredential = await _firebase.createUserWithEmailAndPassword(
//           email: _enteredEmail,
//           password: _enteredPassword,
//         );

//         // Profil resmi yükleme
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('user_images')
//             .child('${userCredential.user!.uid}.jpg');

//         // await storageRef.putFile(_selectedImage!);
//         // final imageUrl = await storageRef.getDownloadURL();

//         // Firestore'a kullanıcı bilgileri ekleme
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set({
//           'username': _enteredUsername,
//           'email': _enteredEmail,
//           // 'image_url': imageUrl,
//         });

//         // Yeni hesap oluşturulduğunda da anasayfaya yönlendirme
//         Navigator.of(context).pushReplacementNamed('/home');
//       }

//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('Account created successfully!')),
//       // );
//     } on FirebaseAuthException catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error.message ?? 'Authentication failed.')),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $error')),
//       );
//     } finally {
//       setState(() {
//         _isAuthenticating = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Theme.of(context).colorScheme.primary,
//       resizeToAvoidBottomInset: true,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(
//                   top: 30,
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                 ),
//                 //width: 700,
//                 width: MediaQuery.of(context).size.width * 0.7, // Ekranın %80'i
//                 //child: Image.asset('assets/images/agu_kilit_ekrani.jpg'),
//               ),
//               Container(
//                 height:
//                     MediaQuery.of(context).size.height * 0.8, // Ekranın %80'i
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: [
//                   const Color.fromARGB(255, 255, 255, 255),
//                   Color.fromARGB(255, 204, 28, 28),
//                   Colors.white,
//                 ], stops: [
//                   0.01,
//                   1,
//                   1,
//                 ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 120), // Card'ın üstüne 180 piksel boşluk
//                   child: Card(
//                     elevation: 0,
//                     color: const Color.fromARGB(0, 255, 255,
//                         255), // Card'ın arka plan rengini şeffaf yap
//                     margin: const EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Form(
//                           key: _form,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               // if (!_isLogin)
                                
//                               TextFormField(
//                                 initialValue:
//                                     _enteredEmail, // Kaydedilen e-posta
//                                 decoration: InputDecoration(
//                                   labelText: 'Email Address',
//                                   labelStyle: TextStyle(color: Colors.black),
//                                 ),
//                                 style: TextStyle(color: Colors.black),
//                                 keyboardType: TextInputType.emailAddress,
//                                 autocorrect: false,
//                                 textCapitalization: TextCapitalization.none,
//                                 validator: (value) {
//                                   if (value == null ||
//                                       value.trim().isEmpty ||
//                                       !value.contains('@')) {
//                                     return 'Please enter a valid email address.';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) {
//                                   _enteredEmail = value!;
//                                 },
//                               ),
//                               if (!_isLogin)
//                                 TextFormField(
//                                   style: TextStyle(color: Colors.black),
//                                   decoration: const InputDecoration(
//                                     labelText: 'Username',
//                                     labelStyle: TextStyle(color: Colors.black),
//                                   ),
//                                   enableSuggestions: false,
//                                   validator: (value) {
//                                     if (value == null ||
//                                         value.isEmpty ||
//                                         value.trim().length < 4) {
//                                       return 'Please enter a valid username ( at least 4 characters)';
//                                     }
//                                     return null;
//                                   },
//                                   onSaved: (value) {
//                                     _enteredUsername = value!;
//                                   },
//                                 ),
//                               TextFormField(
//                                 initialValue:
//                                     _enteredPassword, // Kaydedilen şifre
//                                 style: TextStyle(color: Colors.black),
//                                 decoration: InputDecoration(
//                                   labelText: 'Password',
//                                   labelStyle: TextStyle(color: Colors.black),
//                                 ),
//                                 obscureText: true,
//                                 validator: (value) {
//                                   if (value == null ||
//                                       value.trim().length < 6) {
//                                     return 'Password must be at least 6 characters long';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) {
//                                   _enteredPassword = value!;
//                                 },
//                               ),
//                               const SizedBox(height: 12),
//                               if (_isAuthenticating)
//                                 const CircularProgressIndicator(),
//                               if (!_isAuthenticating)
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 35,
//                                     ),
//                                     Checkbox(
//                                       value: _rememberMe,
//                                       onChanged: (newValue) {
//                                         setState(() {
//                                           _rememberMe = newValue!;
//                                         });
//                                       },
//                                     ),
//                                     const Text(
//                                       'Beni Hatırla',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     SizedBox(
//                                       width: 45,
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: _submit,
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.white),
//                                       child: Text(
//                                         _isLogin ? 'Login' : 'Signup',
//                                         style: TextStyle(color: Colors.black),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               if (!_isAuthenticating)
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _isLogin = !_isLogin;
//                                     });
//                                   },
//                                   child: Text(
//                                     _isLogin
//                                         ? 'Create an account'
//                                         : 'I already have an account',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
                             
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
