import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteState.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
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
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: StatefulBuilder(
          builder: (context, setStateSB) {
            bool expanded = false;

            return ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              trailing: const SizedBox.shrink(),
              onExpansionChanged: (isOpen) {
                setStateSB(() {
                  expanded = isOpen;
                });
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.folder_special_outlined,
                        color: AppColors.surface,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.black,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          "${prestamos.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Color(0xFF1565C0),
                      size: 26,
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
            );
          },
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
            const SizedBox(height: 25),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.prestamosclienteslista,
                ),
                child: const Text(
                  "Verifique todos los prestamos",
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
