import 'package:flutter_bloc/flutter_bloc.dart';
import 'PrestamosClienteEvent.dart';
import 'PrestamosClienteState.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';

class PrestamosClienteBloc
    extends Bloc<PrestamosClienteEvent, PrestamosClienteState> {
  final UsuariosService usuariosService;

  PrestamosClienteBloc(this.usuariosService)
    : super(const PrestamosClienteState()) {
    on<LoadPrestamosCliente>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));
      try {
        final prestamos = await usuariosService.getMisPrestamos();
        final clasificadas = _clasificarPrestamos(prestamos);

        emit(
          state.copyWith(
            prestamos: prestamos,
            anteriores: clasificadas["anteriores"]!,
            hoy: clasificadas["hoy"]!,
            proximos: clasificadas["proximos"]!,
            pagados: clasificadas["pagados"]!,
            status: Resource.success("Préstamos cargados"),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: Resource.error("Error: $e")));
      }
    });
  }

  Map<String, List<Prestamo>> _clasificarPrestamos(List<Prestamo> prestamos) {
    final hoy = DateTime.now();
    final hoyDate = DateTime(hoy.year, hoy.month, hoy.day);

    final anteriores = <Prestamo>[];
    final hoyList = <Prestamo>[];
    final proximos = <Prestamo>[];
    final pagados = <Prestamo>[];

    for (final prestamo in prestamos) {
      if (prestamo.estado == "PAGADO") {
        pagados.add(prestamo);
        continue;
      }

      if (prestamo.cuotas == null || prestamo.cuotas!.isEmpty) continue;

      for (final cuota in prestamo.cuotas!) {
        if (cuota.estado != "PENDIENTE") continue;

        final fecha = DateTime.tryParse(cuota.fechaPago);
        if (fecha == null) continue;

        final fechaPago = DateTime(fecha.year, fecha.month, fecha.day);
        final diferencia = fechaPago.difference(hoyDate).inDays;

        if (fechaPago.isAtSameMomentAs(hoyDate)) {
          hoyList.add(prestamo);
          break;
        } else if (diferencia > 0 && diferencia <= 3) {
          proximos.add(prestamo);
          break;
        } else if (fechaPago.isBefore(hoyDate)) {
          anteriores.add(prestamo);
          break;
        }
      }
    }

    return {
      "anteriores": anteriores,
      "hoy": hoyList,
      "proximos": proximos,
      "pagados": pagados,
    };
  }
}
