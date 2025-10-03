import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteState.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PrestamosClienteContent extends StatelessWidget {
  const PrestamosClienteContent({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: "S/", locale: "es_PE").format(value);
  }

  String _formatDate(String fecha) {
    try {
      final parsed = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(parsed);
    } catch (_) {
      return fecha;
    }
  }

  Widget _buildSection(
    String title,
    List<Prestamo> prestamos,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.white), // ← aquí
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          trailing: const SizedBox.shrink(),
          title: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          children: prestamos.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Sin préstamos en esta sección",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              : prestamos
                    .map(
                      (prestamo) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 241, 246),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.cuotasclientes,
                              arguments: prestamo.id,
                            );
                          },
                          leading: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
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
                              Text(
                                "Interés: ${prestamo.tasaInteresMensual.toStringAsFixed(2)}%",
                              ),
                              Text("Cuotas: ${prestamo.numeroCuotas}"),
                              Text(
                                "Creación: ${_formatDate(prestamo.fechaCreacion)}",
                              ),
                              Text(
                                "Estado: ${prestamo.estado ?? '-'}",
                                style: TextStyle(
                                  color: prestamo.estado == "PAGADO"
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black54,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                    .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrestamosClienteBloc, PrestamosClienteState>(
      builder: (context, state) {
        if (state.status?.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status?.status == Status.error) {
          return Center(child: Text(state.status?.message ?? "Error"));
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildSection("Hoy", state.hoy, context),
            _buildSection("Próximos", state.proximos, context),
            _buildSection("Anteriores", state.anteriores, context),
            _buildSection("Pagados", state.pagados, context),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
