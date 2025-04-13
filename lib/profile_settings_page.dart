import 'package:flutter/material.dart';
import '../utils/services/connection.dart';

class ProfileSettingsPageWidget extends StatefulWidget {
  @override
  State<ProfileSettingsPageWidget> createState() => _ProfileSettingsPageWidgetState();
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
        passwordC.text = ""; // güvenlik için boş başlatılır
      });
    } catch (e) {
      print("Kullanıcı bilgisi yüklenemedi: $e");
    }
  }

  Future<void> _updateField(String field) async {
    String value;
    switch (field) {
      case "email":
        value = emailC.text;
        break;
      case "username":
        value = usernameC.text;
        break;
      case "password":
        value = passwordC.text;
        break;
      default:
        return;
    }

    final success = await Connection.updateUserField(loggedInEmail, field, value);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field başarıyla güncellendi.')),
      );
      setState(() {
        if (field == "email") isEditingEmail = false;
        if (field == "username") isEditingUsername = false;
        if (field == "password") isEditingPassword = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field güncellenemedi.')),
      );
    }
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
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
            decoration: InputDecoration(labelText: label),
            enabled: isEditing,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: isEditing ? onSave : onEdit,
          child: Text(isEditing ? "Değiştir" : "Düzenle"),
        )
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
            label: "E-posta",
            controller: emailC,
            isEditing: isEditingEmail,
            onEdit: () => setState(() => isEditingEmail = true),
            onSave: () => _updateField("email"),
          ),
          SizedBox(height: 12),
          _buildProfileTile(
            icon: Icons.person_outline,
            label: "Kullanıcı Adı",
            controller: usernameC,
            isEditing: isEditingUsername,
            onEdit: () => setState(() => isEditingUsername = true),
            onSave: () => _updateField("username"),
          ),
          SizedBox(height: 12),
          _buildProfileTile(
            icon: Icons.lock_outline,
            label: "Şifre",
            controller: passwordC,
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
                labelText: label,
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
