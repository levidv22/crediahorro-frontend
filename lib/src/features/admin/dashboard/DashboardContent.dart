import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:crediahorro/src/features/admin/dashboard/bloc/DashboardBloc.dart';
import 'package:crediahorro/src/features/admin/dashboard/bloc/DashboardEvent.dart';
import 'package:crediahorro/src/features/admin/dashboard/bloc/DashboardState.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoadClientes());
  }

  /// --- POPUP MENU (tres puntitos) ---
  Widget _menuAccionesCliente(BuildContext context, Cliente cliente) {
    return PopupMenuButton<String>(
      color: const Color(0xFFf1f5f9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      onSelected: (value) async {
        switch (value) {
          case "editar":
            final result = await Navigator.pushNamed(
              context,
              AppRouter.clienteEdit,
              arguments: cliente.id,
            );
            if (result == true && context.mounted) {
              context.read<DashboardBloc>().add(DashboardLoadClientes());
            }
            break;
          case "prestamos":
            Navigator.pushNamed(
              context,
              AppRouter.prestamos,
              arguments: cliente.id,
            );
            break;
          case "verCredenciales":
            _mostrarCredenciales(context, cliente);
            break;
          case "whatsapp":
            _compartirWhatsapp(cliente);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "editar",
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text("Editar Cliente"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "prestamos",
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text("Ver Préstamos"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: "verCredenciales",
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.lock, size: 18, color: Colors.blue),
              ),
              const SizedBox(width: 10),
              const Text("Ver credenciales"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "whatsapp",
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.share, size: 18, color: Colors.green),
              ),
              const SizedBox(width: 10),
              const Text("Enviar a WhatsApp"),
            ],
          ),
        ),
      ],
    );
  }

  /// --- DIALOG CREDENCIALES ---
  void _mostrarCredenciales(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFe3f2fd), Color(0xFFbbdefb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Credenciales de acceso",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),

                // --- Usuario ---
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Usuario: ${cliente.username ?? '-'}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blueAccent),
                      tooltip: "Copiar usuario",
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: cliente.username ?? ''),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario copiado al portapapeles'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // --- Contraseña ---
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.green.withOpacity(0.2),
                      child: const Icon(Icons.key, color: Colors.green),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Contraseña: ${cliente.passwordTemporal ?? '-'}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.green),
                      tooltip: "Copiar contraseña",
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: cliente.passwordTemporal ?? ''),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contraseña copiada al portapapeles'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // --- Botón cerrar ---
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "Cerrar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// --- WHATSAPP ---
  Future<void> _compartirWhatsapp(Cliente cliente) async {
    final mensaje =
        """
Hola ${cliente.nombre}, aquí tienes tus credenciales de acceso:
👤 Usuario: ${cliente.username}
🔑 Contraseña: ${cliente.passwordTemporal}
""";

    // Número al que se enviará (debe incluir el código de país, sin espacios ni +)
    const miNumero = "51928581983"; // Perú: +51 928581983

    final uri = Uri.parse(
      "whatsapp://send?phone=$miNumero&text=${Uri.encodeComponent(mensaje)}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 👈 Esto es esencial
      );
    } else {
      // En caso de que no funcione (por ejemplo, si WhatsApp no está instalado)
      final fallback = Uri.parse(
        "https://wa.me/$miNumero?text=${Uri.encodeComponent(mensaje)}",
      );
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  /// --- SECCIÓN CLIENTES ---
  Widget _buildSection(String title, List<Cliente> clientes) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.transparent,
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        hoverColor: AppColors.transparent,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setStateSB) {
            bool expanded = true;
            return ExpansionTile(
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: AppColors.surface,
              collapsedBackgroundColor: AppColors.surface,
              trailing: const SizedBox.shrink(),
              onExpansionChanged: (isOpen) {
                setStateSB(() {
                  expanded = isOpen;
                });
              },
              title: Row(
                children: [
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              children: clientes.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.people_outline,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Sin clientes en esta sección",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : clientes
                        .map(
                          (cliente) => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 233, 241, 246),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(
                                cliente.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                cliente.telefonoWhatsapp,
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: _menuAccionesCliente(context, cliente),
                            ),
                          ),
                        )
                        .toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status?.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status?.status == Status.error) {
          return Center(child: Text(state.status?.message ?? "Error"));
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildSection("Anterior", state.anteriores),
            _buildSection("Hoy", state.hoy),
            _buildSection("Próximo", state.proximos),
            const SizedBox(height: 25),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRouter.clientes),
                child: const Text(
                  "Verifique todos los clientes",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
