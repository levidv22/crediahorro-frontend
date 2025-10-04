import 'package:crediahorro/src/features/admin/loans/edit/LoanEditPage.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansBloc.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansEvent.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:intl/intl.dart';

class LoansContent extends StatelessWidget {
  final int clienteId;
  const LoansContent({super.key, required this.clienteId});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: 'S/', locale: 'es_PE').format(value);
  }

  String _formatDate(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoansBloc, LoansState>(
      builder: (context, state) {
        if (state.status == LoansStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LoansStatus.failure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        }

        if (state.cliente == null ||
            state.cliente!.prestamos == null ||
            state.cliente!.prestamos!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  "No existen préstamos",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        final cliente = state.cliente!;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: cliente.prestamos!.length,
          itemBuilder: (context, index) {
            final prestamo = cliente.prestamos![index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 241, 246),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text(
                  _formatCurrency(prestamo.monto),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Interés: ${prestamo.tasaInteresMensual}%"),
                    Text("Cuotas: ${prestamo.numeroCuotas}"),
                    Text("Creación: ${_formatDate(prestamo.fechaCreacion)}"),
                    Text(
                      "Estado: ${prestamo.estado ?? "N/A"}",
                      style: TextStyle(
                        color: prestamo.estado == "PAGADO"
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  color: const Color(
                    0xFFf1f5f9,
                  ), // fondo suave igual que clientes
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  onSelected: (value) async {
                    switch (value) {
                      case "verCuotas":
                        Navigator.pushNamed(
                          context,
                          AppRouter.cuotas,
                          arguments: prestamo.id,
                        );
                        break;
                      case "editarPrestamo":
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoanEditPage(
                              clienteId: cliente.id!,
                              prestamoId: prestamo.id!,
                            ),
                          ),
                        );
                        if (result == true && context.mounted) {
                          context.read<LoansBloc>().add(LoansLoaded(clienteId));
                        }
                        break;
                      case "exportarExcel":
                        Navigator.pop(context);
                        // Aquí implementas exportar excel
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "verCuotas",
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.visibility,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("Ver Cuotas"),
                        ],
                      ),
                    ),
                    if (prestamo.estado != "PAGADO")
                      PopupMenuItem(
                        value: "editarPrestamo",
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
                            const Text("Editar Préstamo"),
                          ],
                        ),
                      ),
                    if (prestamo.estado == "PAGADO")
                      PopupMenuItem(
                        value: "exportarExcel",
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.file_present,
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text("Exportar Excel"),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
