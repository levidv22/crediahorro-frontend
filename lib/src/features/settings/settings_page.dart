import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_logo.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
      _SettingItem(
        title: "Cerrar Sesión",
        icon: Icons.logout_outlined,
        onTap: () async {
          await _authService.logout(); // limpia el token
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.login,
            (route) => false, // elimina todas las rutas anteriores
          );
        },
      ),
    ];

    return AppScaffold(
      title: "CREDIAHORRO",
      body: Column(
        children: [
          const SizedBox(height: 20),
          const AppLogo(size: 80),
          const SizedBox(height: 10),
          Text(
            "Opciones de Configuración",
            style: AppTextStyles.screenTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
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
              separatorBuilder: (_, _) => const Divider(),
            ),
          ),
        ],
      ),
      initialIndex: 4,
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SettingItem({required this.title, required this.icon, required this.onTap});
}
