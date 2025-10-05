import 'package:flutter/material.dart';
import 'package:crediahorro/src/services/AuthService.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crediahorro/src/common_widgets/role_scaffold_builder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _role = "";

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      setState(() => _role = decoded["role"] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final List<_SettingItem> items = [
      _SettingItem(
        title: "Perfil",
        icon: Icons.person_outline,
        onTap: () => Navigator.pushNamed(context, AppRouter.perfil),
      ),
      _SettingItem(
        title: "Notificaciones",
        icon: Icons.notifications_outlined,
        onTap: () {},
      ),
      _SettingItem(title: "Seguridad", icon: Icons.lock_outline, onTap: () {}),
      _SettingItem(title: "Temas", icon: Icons.palette_outlined, onTap: () {}),
      _SettingItem(
        title: "Cerrar Sesión",
        icon: Icons.logout_outlined,
        onTap: () async {
          await _authService.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.login,
            (route) => false,
          );
        },
      ),
    ];

    return buildRoleBasedScaffold(
      role: _role,
      title: "CREDIAHORRO",
      viewName: "settings",
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return ListTile(
            leading: Icon(item.icon, color: AppColors.primary),
            title: Text(item.title),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
            ),
            onTap: item.onTap,
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _SettingItem({required this.title, required this.icon, required this.onTap});
}
