import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteEvent.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteState.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
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

  Color _estadoColor(String? estado, String? tipoPago) {
    final valor = (tipoPago?.isNotEmpty ?? false) ? tipoPago : estado;
    switch (valor) {
      case "PAGADA":
      case "Pagó Completo":
        return Colors.green;
      case "PENDIENTE":
        return Colors.orange;
      case "ADELANTADO":
        return Colors.blue;
      case "PAGO_INCOMPLETO":
        return Colors.blueGrey;
      case "NO_PAGADA":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String _estadoVisible(String? estado, String? tipoPago) {
    if (tipoPago == "PAGO_INCOMPLETO") return "PAGO INCOMPLETO";
    if (tipoPago == "NO_PAGADA") return "NO PAGADA";
    if (tipoPago == "Pagó Completo" || estado == "PAGADA") return "PAGADA";
    return estado ?? "N/A";
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

        final cuotas = state.cuotas;
        final totalAPagar = cuotas.fold(0.0, (s, c) => s + c.montoCuota);
        final totalPagado = cuotas
            .where((c) => c.estado == "PAGADA")
            .fold(0.0, (s, c) => s + c.montoCuota);
        final faltaPagar = cuotas
            .where((c) => c.estado == "PENDIENTE")
            .fold(0.0, (s, c) => s + c.montoCuota);
        final cuotasPendientes = cuotas
            .where((c) => c.estado == "PENDIENTE")
            .length;

        return RefreshIndicator(
          onRefresh: () async => context.read<CuotasClienteBloc>(),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              /// 🔹 CARD SUPERIOR
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.indigo.withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.shade50,
                        Colors.indigo.shade100.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.indigo,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Resumen de Cuotas",
                              style: TextStyle(
                                color: Colors.indigo.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Cuotas pendientes: $cuotasPendientes",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 LISTA DE CUOTAS
              ...cuotas.asMap().entries.map((entry) {
                final i = entry.key;
                final c = entry.value;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: _estadoColor(c.estado, c.tipoPago),
                      child: const Icon(Icons.event_note, color: Colors.white),
                    ),
                    title: Text(
                      _formatCurrency(c.montoCuota),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha a pagar: ${_formatDate(c.fechaPago)}"),
                          Text("Fecha pagada: ${_formatDate(c.fechaPagada)}"),
                          Text(
                            _estadoVisible(c.estado, c.tipoPago),
                            style: TextStyle(
                              color: _estadoColor(c.estado, c.tipoPago),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == "pagar") {
                          Navigator.pushNamed(
                            context,
                            AppRouter.pagarcuota,
                            arguments: c,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        if (c.estado == "PENDIENTE")
                          const PopupMenuItem(
                            value: "pagar",
                            child: Row(
                              children: [
                                Icon(Icons.payment, color: Colors.indigo),
                                SizedBox(width: 8),
                                Text("Pagar Cuota"),
                              ],
                            ),
                          )
                        else
                          const PopupMenuItem(
                            value: "gestionada",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Text("Cuota ya gestionada"),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const Divider(),

              /// 🔹 CARD INFERIOR (RESUMEN)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.indigo.withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.shade50,
                        Colors.indigo.shade100.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.analytics_outlined,
                              color: Colors.indigo,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Resumen de Pagos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildResumenRow(
                        Icons.attach_money_outlined,
                        "Total a pagar:",
                        _formatCurrency(totalAPagar),
                        Colors.indigo,
                      ),
                      const SizedBox(height: 8),
                      _buildResumenRow(
                        Icons.check_circle_outline,
                        "Total pagado:",
                        _formatCurrency(totalPagado),
                        Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildResumenRow(
                        Icons.warning_amber_outlined,
                        "Falta pagar:",
                        _formatCurrency(faltaPagar),
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResumenRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
