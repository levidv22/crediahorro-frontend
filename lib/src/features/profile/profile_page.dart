import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _savedImagePath;
  String? _tempImagePath;
  String _username = "";
  String _email = "";
  String _whatsapp = "";

  final _profileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    String username = "";
    String email = "";
    String whatsapp = "";

    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      username = decoded["sub"] ?? "Usuario";
      email = decoded["email"] ?? "No disponible";
      whatsapp = decoded["whatsapp"] ?? "No disponible";
    }

    setState(() {
      _savedImagePath = prefs.getString('profile_image');
      _username = username;
      _email = email;
      _whatsapp = whatsapp;
      _profileNameController.text = prefs.getString('profile_name') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _tempImagePath = picked.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'profile_image',
      _tempImagePath ?? _savedImagePath ?? '',
    );
    await prefs.setString('profile_name', _profileNameController.text);

    setState(() {
      _savedImagePath = _tempImagePath ?? _savedImagePath;
      _tempImagePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado correctamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _tempImagePath ?? _savedImagePath;

    return Scaffold(
      backgroundColor: const Color(0xFF4C3A3A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Editar perfil",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Toda la información que ingreses en tu perfil se\nmantendrá privada y solo estará disponible para ti",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ProfileAvatar(
                  imagePath: displayImage,
                  size: 120,
                  onTap: _pickImage,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cambiar foto",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField("Nombre de perfil", _profileNameController),
              const SizedBox(height: 15),
              _buildTextField(
                "Nombre de usuario",
                TextEditingController(text: _username),
                readOnly: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "Correo Electrónico",
                TextEditingController(text: _email),
                readOnly: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "Whatsapp",
                TextEditingController(text: _whatsapp),
                readOnly: true,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Listo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2E2A2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
