import 'package:crediahorro/src/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'app_logo.dart';

class AppSidebar extends StatefulWidget {
  final VoidCallback onClose;
  const AppSidebar({super.key, required this.onClose});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    //vienen de router
    final items = [
      _SidebarItem("home", Icons.dashboard_outlined, AppRouter.dashboard),
      _SidebarItem("Clientes", Icons.people_alt_outlined, AppRouter.clientes),
      _SidebarItem("Reportes", Icons.bar_chart_outlined, AppRouter.reportes),
      _SidebarItem(
        "Configuración",
        Icons.settings_outlined,
        AppRouter.configuracion,
      ),
      _SidebarItem("Pagos", Icons.money_outlined, AppRouter.solicitudpago),
    ];

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          width: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 233, 241, 246),
                Color.fromARGB(255, 129, 188, 224),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "CrediAhorro",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const AppLogo(size: 100),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Tu socio financiero",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return _SidebarTile(item: item, onClose: widget.onClose);
                  },
                  separatorBuilder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.1), Colors.black12],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  itemCount: items.length,
                ),
              ),

              const SizedBox(height: 16),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Cerrar sesión
              ListTile(
                leading: const Icon(Icons.logout_outlined, color: Colors.black),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onTap: () async {
                  await _authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;
  final String route;

  _SidebarItem(this.title, this.icon, this.route);
}

class _SidebarTile extends StatefulWidget {
  final _SidebarItem item;
  final VoidCallback onClose;

  const _SidebarTile({required this.item, required this.onClose});

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _hovered ? Colors.black.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(widget.item.icon, color: Colors.black),
          title: Text(
            widget.item.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: _hovered ? FontWeight.bold : FontWeight.w500,
              fontSize: 15.5,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, widget.item.route);
            if (Navigator.canPop(context)) widget.onClose();
          },
        ),
      ),
    );
  }
}
