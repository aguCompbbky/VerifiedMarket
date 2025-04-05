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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Ayarları")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEditableField(
              label: "E-posta",
              controller: emailC,
              isEditing: isEditingEmail,
              onEdit: () => setState(() => isEditingEmail = true),
              onSave: () => _updateField("email"),
            ),
            _buildEditableField(
              label: "Kullanıcı Adı",
              controller: usernameC,
              isEditing: isEditingUsername,
              onEdit: () => setState(() => isEditingUsername = true),
              onSave: () => _updateField("username"),
            ),
            _buildEditableField(
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
}
