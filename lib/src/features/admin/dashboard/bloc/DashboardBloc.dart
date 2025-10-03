import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/admin/dashboard/bloc/DashboardEvent.dart';
import 'package:crediahorro/src/features/admin/dashboard/bloc/DashboardState.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClienteService clienteService;

  DashboardBloc(this.clienteService) : super(const DashboardState()) {
    on<DashboardLoadClientes>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));
      try {
        final data = await clienteService.getClientes();
        final clasificadas = _clasificarClientes(data);
        emit(
          state.copyWith(
            status: Resource.success("Clientes cargados"),
            clientes: data,
            anteriores: clasificadas["anteriores"]!,
            hoy: clasificadas["hoy"]!,
            proximos: clasificadas["proximos"]!,
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: Resource.error("Error: $e")));
      }
    });
  }

  Map<String, List<Cliente>> _clasificarClientes(List<Cliente> clientes) {
    final hoy = DateTime.now();
    final hoyDate = DateTime(hoy.year, hoy.month, hoy.day);

    final anteriores = <Cliente>[];
    final hoyList = <Cliente>[];
    final proximos = <Cliente>[];

    for (final cliente in clientes) {
      if (cliente.prestamos == null || cliente.prestamos!.isEmpty) continue;

      for (final prestamo in cliente.prestamos!) {
        if (prestamo.cuotas == null) continue;

        for (final cuota in prestamo.cuotas!) {
          if (cuota.estado != "PENDIENTE") continue;

          final fecha = DateTime.tryParse(cuota.fechaPago);
          if (fecha == null) continue;

          final fechaPago = DateTime(fecha.year, fecha.month, fecha.day);
          final diferencia = fechaPago.difference(hoyDate).inDays;

          if (fechaPago.isAtSameMomentAs(hoyDate)) {
            hoyList.add(cliente);
            break;
          } else if (diferencia > 0 && diferencia <= 3) {
            proximos.add(cliente);
            break;
          } else if (fechaPago.isBefore(hoyDate)) {
            anteriores.add(cliente);
            break;
          }
        }
      }
    }

    return {"anteriores": anteriores, "hoy": hoyList, "proximos": proximos};
  }
}
