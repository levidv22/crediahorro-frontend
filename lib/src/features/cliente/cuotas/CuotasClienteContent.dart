import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteState.dart';
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

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cuota.estado == "PAGADO"
                      ? Colors.green
                      : Colors.orange,
                  child: Icon(
                    cuota.estado == "PAGADO" ? Icons.check : Icons.schedule,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  _formatCurrency(cuota.montoCuota),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fecha a Pagar: ${_formatDate(cuota.fechaPago)}"),
                    Text("Fecha Pagada: ${_formatDate(cuota.fechaPagada)}"),
                    Text(
                      "Estado: ${cuota.estado}",
                      style: TextStyle(
                        color: cuota.estado == "PAGADO"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: cuota.estado == "PAGADO"
                    ? const Icon(Icons.verified, color: Colors.green)
                    : const Icon(Icons.pending_actions, color: Colors.orange),
              ),
            );
          },
        );
      },
    );
  }
}
