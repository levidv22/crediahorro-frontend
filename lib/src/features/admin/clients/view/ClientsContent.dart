import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsBloc.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsState.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class ClientsContent extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ClientsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Buscador
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            onChanged: (value) =>
                context.read<ClientsBloc>().add(SearchClients(value)),
            decoration: InputDecoration(
              hintText: "Buscar cliente...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Lista de clientes
        Expanded(
          child: BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) {
              if (state is ClientsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClientsError) {
                return Center(child: Text(state.message));
              } else if (state is ClientsLoaded) {
                if (state.filteredClientes.isEmpty) {
                  return _emptyList();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.filteredClientes.length,
                  itemBuilder: (_, index) {
                    final cliente = state.filteredClientes[index];
                    return _clienteTile(context, cliente);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _clienteTile(BuildContext context, Cliente cliente) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          cliente.telefonoWhatsapp,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: PopupMenuButton<String>(
          color: const Color(
            0xFFf1f5f9,
          ), // Fondo personalizado gris-azulado suave
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          onSelected: (value) async {
            switch (value) {
              case "editar":
                Navigator.pop(context);
                final result = await Navigator.pushNamed(
                  context,
                  AppRouter.clienteEdit,
                  arguments: cliente.id,
                );
                if (result == true && context.mounted) {
                  context.read<ClientsBloc>().add(LoadClients());
                }
                break;
              case "prestamos":
                Navigator.pop(context);
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
                    child: const Icon(
                      Icons.share,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Enviar a WhatsApp"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  ],
                ),
                const SizedBox(height: 12),
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
                  ],
                ),
                const SizedBox(height: 20),
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

  Future<void> _compartirWhatsapp(Cliente cliente) async {
    final mensaje =
        """
Hola ${cliente.nombre}, aquí tienes tus credenciales de acceso:
👤 Usuario: ${cliente.username}
🔑 Contraseña: ${cliente.passwordTemporal}
""";

    const miNumero = "+51928581983"; // tu número fijo
    final url = Uri.parse(
      "https://wa.me/$miNumero?text=${Uri.encodeComponent(mensaje)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir WhatsApp';
    }
  }

  Widget _emptyList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people_outline, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No se encontraron clientes",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
