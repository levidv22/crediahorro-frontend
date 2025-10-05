import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_sidebar.dart';

class AppScaffoldUsuario extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final int initialIndex;

  const AppScaffoldUsuario({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.initialIndex = 0,
  });

  @override
  State<AppScaffoldUsuario> createState() => _AppScaffoldUsuarioState();
}

class _AppScaffoldUsuarioState extends State<AppScaffoldUsuario> {
  bool _isSidebarOpen = false;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onNavTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.prestamosclientes);
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRouter.prestamosclienteslista,
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRouter.perfiloverview);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRouter.configuracion);
        break;
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      Navigator.pushReplacementNamed(context, AppRouter.prestamosclientes);
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: AppTextStyles.screenTitle.copyWith(
                  color: AppColors.black,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: AppColors.secondary),
                onPressed: _toggleSidebar,
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/appbar.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            body: widget.body,
            floatingActionButton: widget.floatingActionButton,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 113, 108, 108),
                    width: 1,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _onNavTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.grey,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                items: [
                  _buildNavItem(Icons.home_outlined, "Home", 0),
                  _buildNavItem(Icons.attach_money_outlined, "Préstamos", 1),
                  _buildNavItem(Icons.person_outline, "Perfil", 2),
                  _buildNavItem(Icons.settings_outlined, "Ajustes", 3),
                ],
              ),
            ),
          ),
          if (_isSidebarOpen) ...[
            GestureDetector(
              onTap: _toggleSidebar,
              child: Container(color: Colors.black54),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: AppSidebar(onClose: _toggleSidebar),
            ),
          ],
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.grey,
        ),
      ),
      label: label,
      tooltip: label,
    );
  }
}
