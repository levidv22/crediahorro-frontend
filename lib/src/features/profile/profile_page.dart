import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _savedImagePath;
  String? _tempImagePath;

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedImagePath = prefs.getString('profile_image');
      _nameController.text = prefs.getString('profile_name') ?? '';
      _lastnameController.text = prefs.getString('profile_lastname') ?? '';
      _usernameController.text = prefs.getString('profile_username') ?? '';
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
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_lastname', _lastnameController.text);
    await prefs.setString('profile_username', _usernameController.text);

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
                  "Toda la información que ingreses en tu perfil se\n"
                  "mantendrá privada y solo estará disponible para ti",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),

              // Avatar
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

              // Campos
              _buildTextField("Nombre", _nameController),
              const SizedBox(height: 15),
              _buildTextField("Apellido", _lastnameController),
              const SizedBox(height: 15),
              _buildTextField("Nombre de usuario", _usernameController),

              const SizedBox(height: 30),

              // Botón guardar
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2E2A2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
