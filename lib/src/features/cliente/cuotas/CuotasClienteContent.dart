import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteState.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CuotasClienteContent extends StatelessWidget {
  const CuotasClienteContent({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: "S/", locale: "es_PE").format(value);
  }

  String _formatDate(String? fecha) {
    if (fecha == null) return "-";
    try {
      final date = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return fecha;
    }
  }

  Color _estadoColor(String estado) {
    switch (estado) {
      case "PAGADO":
        return Colors.green;
      case "PENDIENTE":
        return Colors.orange;
      case "ATRASADO":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CuotasClienteBloc, CuotasClienteState>(
      builder: (context, state) {
        if (state.status?.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status?.status == Status.error) {
          return Center(child: Text(state.status?.message ?? "Error"));
        }

        if (state.cuotas.isEmpty) {
          return const Center(
            child: Text(
              "No tienes cuotas registradas",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: state.cuotas.length,
          itemBuilder: (context, index) {
            final cuota = state.cuotas[index];
            final colorEstado = _estadoColor(cuota.estado);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 241, 246),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: colorEstado,
                  child: Icon(
                    cuota.estado == "PAGADO"
                        ? Icons.check_circle_outline
                        : Icons.schedule_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                title: Text(
                  _formatCurrency(cuota.montoCuota),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Fecha a pagar: ${_formatDate(cuota.fechaPago)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.event_available_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Fecha pagada: ${_formatDate(cuota.fechaPagada)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Estado: ${cuota.estado}",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: colorEstado,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                trailing: cuota.estado == "PAGADO"
                    ? const Icon(Icons.verified, color: Colors.green)
                    : ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.pagarcuota,
                            arguments: cuota,
                          );
                        },
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text(
                          "Pagar",
                          style: TextStyle(fontSize: 13.5),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
