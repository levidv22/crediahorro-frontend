import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileOverviewPage extends StatefulWidget {
  const ProfileOverviewPage({super.key});

  @override
  State<ProfileOverviewPage> createState() => _ProfileOverviewPageState();
}

class _ProfileOverviewPageState extends State<ProfileOverviewPage> {
  String? _profileImagePath;
  String _username = "Usuario";
  String _role = "";
  String _profileName = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    String username = "Usuario";
    String role = "";

    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      username = decoded["sub"] ?? "Usuario";
      role = decoded["role"] ?? "";
    }

    setState(() {
      _profileImagePath = prefs.getString('profile_image');
      _username = username;
      _role = role;
      _profileName = prefs.getString('profile_name') ?? username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileAvatar(
              imagePath: _profileImagePath,
              size: 120,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.perfil,
                ).then((_) => _loadProfileData());
              },
            ),
            const SizedBox(height: 15),
            Text(
              "Hola $_profileName",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Espero que logres tu meta, sé que tienes lo necesario para alcanzarla. "
              "¡Confía en ti y sigue avanzando, lo vas a conseguir!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.perfil,
                ).then((_) => _loadProfileData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Editar perfil"),
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Resumen de Préstamos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(value: "6", label: "Préstamos pagados"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(value: "3", label: "Préstamos pendientes"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Finalización de préstamos pagados",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(6, (index) {
                        final height = [
                          60.0,
                          100.0,
                          30.0,
                          80.0,
                          50.0,
                          95.0,
                        ][index];
                        return Container(
                          width: 20,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      initialIndex: 3,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const _InfoCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
