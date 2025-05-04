import 'package:flutter/material.dart';
import '../utils/services/connection.dart';
import '../profile/update_strategy.dart';

class ProfileSettingsPageWidget extends StatefulWidget {
  @override
  State<ProfileSettingsPageWidget> createState() =>
      _ProfileSettingsPageWidgetState();
}

class _ProfileSettingsPageWidgetState extends State<ProfileSettingsPageWidget> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool isEditingEmail = false;
  bool isEditingUsername = false;
  bool isEditingPassword = false;

  String loggedInEmail = Connection.loggedInEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await Connection.getUser();
      setState(() {
        emailC.text = user['email'];
        usernameC.text = user['username'];
        passwordC.text = "";
        // Global değişkenleri de güncelle
        Connection.loggedInEmail = emailC.text;
        Connection.loggedInUsername = usernameC.text;
      });
    } catch (e) {
      print("Kullanıcı bilgisi yüklenemedi: $e");
    }
  }

  Future<void> _updateField(String field) async {
    late UpdateStrategy strategy;
    String value;

    switch (field) {
      case "email":
        strategy = EmailUpdateStrategy();
        value = emailC.text;
        break;
      case "username":
        strategy = UsernameUpdateStrategy();
        value = usernameC.text;
        break;
      case "password":
        strategy = PasswordUpdateStrategy();
        value = passwordC.text;
        break;
      default:
        return;
    }

    final success = await strategy.update(loggedInEmail, value);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$field başarıyla güncellendi.')));
      setState(() {
        if (field == "email") {
          isEditingEmail = false;
          loggedInEmail = emailC.text;
          Connection.loggedInEmail = emailC.text;
        }
        if (field == "username") {
          isEditingUsername = false;
          Connection.loggedInUsername = usernameC.text;
        }
        if (field == "password") {
          isEditingPassword = false;
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$field güncellenemedi.')));
    }
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    bool obscureText = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enabled: isEditing,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),

        SizedBox(width: 8),
        ElevatedButton(
          onPressed: isEditing ? onSave : onEdit,
          child: Text(isEditing ? "Değiştir" : "Düzenle"),
        ),
      ],
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Profil Ayarları"),
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileTile(
              icon: Icons.email_outlined,
              label: loggedInEmail,
              controller: emailC,
              hintText: "E-posta",
              isEditing: isEditingEmail,
              onEdit: () => setState(() => isEditingEmail = true),
              onSave: () => _updateField("email"),
            ),
            SizedBox(height: 12),
            _buildProfileTile(
              icon: Icons.person_outline,
              label: usernameC.text,
              controller: usernameC,
              hintText: "Username",
              isEditing: isEditingUsername,
              onEdit: () => setState(() => isEditingUsername = true),
              onSave: () => _updateField("username"),
              obscureText: false,
            ),
            SizedBox(height: 12),
            _buildProfileTile(
              icon: Icons.lock_outline,
              label: "Şifre",
              controller: passwordC,
              hintText: 'Password',
              isEditing: isEditingPassword,
              onEdit: () => setState(() => isEditingPassword = true),
              onSave: () => _updateField("password"),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    bool obscureText = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                enabled: isEditing,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
            TextButton(
              onPressed: isEditing ? onSave : onEdit,
              child: Text(
                isEditing ? "Kaydet" : "Düzenle",
                style: TextStyle(
                  color: isEditing ? Colors.green : Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
