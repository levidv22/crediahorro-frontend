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

  Color _estadoColor(String? estado) {
    switch (estado) {
      case "PAGADA":
        return Colors.green;
      case "PENDIENTE":
        return Colors.orange;
      case "ADELANTADO":
        return Colors.blue;
      case "NO_PAGADA":
        return Colors.red;
      default:
        return Colors.grey;
    }
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

          // Calcular totales
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
            onRefresh: () async {
              context.read<CuotasBloc>().add(RefreshCuotas(prestamoId));
            },
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ícono decorativo a la izquierda
                          Container(
                            padding: const EdgeInsets.all(12),
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
                          const SizedBox(width: 16),

                          // Texto principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tipo de Cuota",
                                  style: TextStyle(
                                    color: Colors.indigo.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.data.tipoCuota ?? "-",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule_outlined,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Cuotas pendientes: $cuotasPendientes",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...cuotas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final c = entry.value;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 241, 246),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: _estadoColor(c.estado),
                        child: const Icon(
                          Icons.event_note,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        _formatCurrency(c.montoCuota),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de Pago: ${_formatDate(c.fechaPago)}"),
                          Text("Fecha Pagada: ${_formatDate(c.fechaPagada)}"),
                          Text(
                            "Estado: ${c.estado ?? "N/A"}",
                            style: TextStyle(
                              color: _estadoColor(c.estado),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        color: const Color(
                          0xFFf1f5f9,
                        ), // Fondo gris-azulado suave
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        onSelected: (value) async {
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
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: color,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          titulo,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      mensaje,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          "Cancelar",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: color,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
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

                          switch (value) {
                            case "pagar":
                              if (_esPagarHabilitado(cuotas, i)) {
                                final confirmar = await _mostrarConfirmacion(
                                  context,
                                  "Confirmar Pago",
                                  "¿Estás seguro de que deseas marcar esta cuota como pagada?",
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
                            PopupMenuItem(
                              value: "pagar",
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.payment,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Pagar"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "nopagar",
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("No pagar"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "parcial",
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.money_off,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Pago Parcial"),
                                ],
                              ),
                            ),
                          ] else
                            PopupMenuItem(
                              value: "info",
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.info,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Esta cuota ya fue gestionada"),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const Divider(),
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildResumenRow(
                                icon: Icons.attach_money_outlined,
                                label: "Total a pagar:",
                                value: _formatCurrency(totalAPagar),
                                color: Colors.indigo,
                              ),
                              const SizedBox(height: 8),
                              _buildResumenRow(
                                icon: Icons.payments_outlined,
                                label: "Total pagado:",
                                value: _formatCurrency(totalPagado),
                                color: Colors.green,
                              ),
                              const SizedBox(height: 8),
                              _buildResumenRow(
                                icon: Icons.warning_amber_outlined,
                                label: "Falta pagar:",
                                value: _formatCurrency(faltaPagar),
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
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

  Widget _buildResumenRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
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
