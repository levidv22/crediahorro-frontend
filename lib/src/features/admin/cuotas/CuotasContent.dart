import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasBloc.dart';
import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasEvent.dart';
import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasState.dart';
import 'package:crediahorro/src/features/admin/cuotas/models/cuota.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CuotasContent extends StatelessWidget {
  final int prestamoId;
  const CuotasContent({super.key, required this.prestamoId});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: 'S/', locale: 'es_PE').format(value);
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

  /// 🔹 Colores según estado o tipoPago
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

  /// 🔹 Texto visible según estado
  String _estadoVisible(String? estado, String? tipoPago) {
    if (tipoPago == "PAGO_INCOMPLETO") return "PAGO INCOMPLETO";
    if (tipoPago == "NO_PAGADA") return "NO PAGADA";
    if (tipoPago == "Pagó Completo" || estado == "PAGADA") return "PAGADA";
    return estado ?? "N/A";
  }

  bool _esPagarHabilitado(List<Cuota> cuotas, int i) {
    final cuota = cuotas[i];
    if (cuota.estado != "PENDIENTE") return false;
    if (i == 0) return true;
    final anterior = cuotas[i - 1];
    return anterior.estado == "PAGADA" ||
        anterior.estado == "ADELANTADO" ||
        anterior.tipoPago == "PAGO_INCOMPLETO";
  }

  /// 🔹 Pago parcial
  void _mostrarDialogoPagoParcial(BuildContext context, Cuota cuota) async {
    final controller = TextEditingController();
    final monto = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.payment, color: Colors.indigo, size: 28),
            SizedBox(width: 10),
            Text(
              "Pago Parcial",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ingrese el monto que desea abonar:",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Ej. 150.00",
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: const Text(
                    "S/",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.indigo.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                Navigator.pop(context, val);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 6, 35, 201),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              "Aceptar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (monto != null) {
      context.read<CuotasBloc>().add(PagoParcialCuota(cuota.id, monto));
      context.read<CuotasBloc>().add(RefreshCuotas(prestamoId));
    }
  }

  /// 🔹 Confirmaciones (pagar / no pagar)
  Future<bool> _mostrarConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
    Color color,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: color, size: 30),
                const SizedBox(width: 10),
                Text(
                  titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            content: Text(mensaje, style: const TextStyle(fontSize: 15)),
            actions: [
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CuotasBloc, CuotasState>(
      builder: (context, state) {
        if (state is CuotasLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CuotasError) {
          return Center(child: Text(state.message));
        } else if (state is CuotasLoaded) {
          final cuotas = state.data.cuotas;
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
            onRefresh: () async =>
                context.read<CuotasBloc>().add(RefreshCuotas(prestamoId)),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                /// 🔹 Card Superior
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
                            Icons.payments_outlined,
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
                                "Tipo de Cuota",
                                style: TextStyle(
                                  color: Colors.indigo.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.data.tipoCuota ?? "-",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
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

                /// 🔹 Lista de cuotas
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
                        horizontal: 16,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: _estadoColor(c.estado, c.tipoPago),
                        child: const Icon(
                          Icons.event_note,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        _formatCurrency(c.montoCuota),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fecha de Pago: ${_formatDate(c.fechaPago)}"),
                            Text("Fecha Pagada: ${_formatDate(c.fechaPagada)}"),
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
                        onSelected: (value) async {
                          switch (value) {
                            case "pagar":
                              if (_esPagarHabilitado(cuotas, i)) {
                                final confirmar = await _mostrarConfirmacion(
                                  context,
                                  "Confirmar Pago",
                                  "¿Deseas marcar esta cuota como pagada?",
                                  Colors.green,
                                );
                                if (confirmar) {
                                  context.read<CuotasBloc>().add(
                                    PagarCuota(c.id),
                                  );
                                  context.read<CuotasBloc>().add(
                                    RefreshCuotas(prestamoId),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "No puedes pagar esta cuota aún.",
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                              break;

                            case "nopagar":
                              final confirmar = await _mostrarConfirmacion(
                                context,
                                "Confirmar Acción",
                                "¿Deseas marcar esta cuota como NO PAGADA?",
                                Colors.redAccent,
                              );
                              if (confirmar) {
                                context.read<CuotasBloc>().add(
                                  NoPagarCuota(c.id),
                                );
                                context.read<CuotasBloc>().add(
                                  RefreshCuotas(prestamoId),
                                );
                              }
                              break;

                            case "parcial":
                              _mostrarDialogoPagoParcial(context, c);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          if (c.estado == "PENDIENTE") ...[
                            const PopupMenuItem(
                              value: "pagar",
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text("Pago Completo"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "parcial",
                              child: Row(
                                children: [
                                  Icon(Icons.payments, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text("Pago Parcial"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "nopagar",
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: Colors.redAccent),
                                  SizedBox(width: 8),
                                  Text("No pagar"),
                                ],
                              ),
                            ),
                          ] else
                            const PopupMenuItem(
                              value: "info",
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.grey),
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

                /// 🔹 Card inferior (resumen)
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
                              "Resumen",
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
                          Icons.payments_outlined,
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
        }
        return const SizedBox();
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
