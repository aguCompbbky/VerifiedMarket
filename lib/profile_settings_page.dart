import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileSettingsPageWidget extends StatefulWidget {
  const ProfileSettingsPageWidget({super.key});

  @override
  _ProfileSettingsPageWidgetState createState() =>
      _ProfileSettingsPageWidgetState();
}


class _ProfileSettingsPageWidgetState extends State<ProfileSettingsPageWidget> {
  Map<String, dynamic>? userData;


  TextEditingController studentIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEditingStudentID = false;
  bool isValidStudentID = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Ayarları"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 39, 113, 148),
          Color.fromARGB(255, 255, 255, 255),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: userData == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Profil Fotoğrafı
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: (userData!['image_url'] != null &&
                                  userData!['image_url'] != "")
                              ? NetworkImage(userData!['image_url'])
                              : null,
                          child: (userData!['image_url'] == null ||
                                  userData!['image_url'] == "")
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          right: -15,
                          bottom: -15,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // İsim ve Soyisim
                    Text(
                      '${userData!['name']} ${userData!['surname']}',
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20, color: Colors.black),
                    Text(userData!['email']),
                    const SizedBox(height: 20),

                    // Okul Numarası (Editable)
                    TextFormField(
                      controller: studentIdController,
                      readOnly: !isEditingStudentID,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Okul Numarası",
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  isEditingStudentID = true;
                                });
                              },
                            ),
                           
                          ],
                        ),
                      ),
                      onChanged: (value) {
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  }