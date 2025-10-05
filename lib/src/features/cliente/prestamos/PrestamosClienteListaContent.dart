import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaBloc.dart';
import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaEvent.dart';
import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class PrestamosClienteListaContent extends StatefulWidget {
  const PrestamosClienteListaContent({super.key});

  @override
  State<PrestamosClienteListaContent> createState() =>
      _PrestamosClienteListaContentState();
}

class _PrestamosClienteListaContentState
    extends State<PrestamosClienteListaContent> {
  final TextEditingController searchController = TextEditingController();
  bool showFilterMenu = false;

  String _formatCurrency(double value) =>
      NumberFormat.currency(symbol: "S/", locale: "es_PE").format(value);

  String _formatDate(String fecha) {
    try {
      return DateFormat("dd/MM/yyyy").format(DateTime.parse(fecha));
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                onChanged: (value) => context
                    .read<PrestamosClienteListaBloc>()
                    .add(SearchPrestamosClienteLista(value)),
                decoration: InputDecoration(
                  hintText: "Buscar préstamo...",
                  prefixIcon: const Icon(Icons.search_outlined),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => setState(() => showFilterMenu = !showFilterMenu),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.filter_list_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Filtros",
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        showFilterMenu
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child:
                  BlocBuilder<
                    PrestamosClienteListaBloc,
                    PrestamosClienteListaState
                  >(
                    builder: (context, state) {
                      if (state is PrestamosClienteListaLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PrestamosClienteListaError) {
                        return Center(child: Text(state.message));
                      } else if (state is PrestamosClienteListaLoaded) {
                        if (state.filtered.isEmpty) {
                          return const Center(child: Text("No hay préstamos"));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.filtered.length,
                          itemBuilder: (_, index) {
                            final p = state.filtered[index];
                            return _prestamoTile(context, p);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ],
        ),

        if (showFilterMenu)
          Positioned(
            top: 110,
            right: 25,
            child: Material(
              elevation: 10,
              color: Colors.transparent,
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _filterItem(
                      "Monto (menor a mayor)",
                      SortPrestamoType.montoAsc,
                    ),
                    _filterItem(
                      "Monto (mayor a menor)",
                      SortPrestamoType.montoDesc,
                    ),
                    _filterItem(
                      "Fecha (antiguos primero)",
                      SortPrestamoType.fechaAsc,
                    ),
                    _filterItem(
                      "Fecha (recientes primero)",
                      SortPrestamoType.fechaDesc,
                    ),
                    _filterItem("Estado", SortPrestamoType.estado),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _filterItem(String text, SortPrestamoType type) {
    return InkWell(
      onTap: () {
        context.read<PrestamosClienteListaBloc>().add(
          SortPrestamosClienteLista(type),
        );
        setState(() => showFilterMenu = false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.tune, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _prestamoTile(BuildContext context, Prestamo p) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 241, 246),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          AppRouter.cuotasclientes,
          arguments: p.id,
        ),
        leading: const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.attach_money, color: Colors.white),
        ),
        title: Text(
          _formatCurrency(p.monto),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Interés: ${p.tasaInteresMensual.toStringAsFixed(2)}%"),
            Text("Cuotas: ${p.numeroCuotas}"),
            Text("Creación: ${_formatDate(p.fechaCreacion)}"),
            Text(
              "Estado: ${p.estado ?? '-'}",
              style: TextStyle(
                color: p.estado == "PAGADO" ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
