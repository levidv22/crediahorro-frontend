import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasEvent.dart';
import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/CuotaService.dart';

class CuotasBloc extends Bloc<CuotasEvent, CuotasState> {
  final CuotaService service;

  CuotasBloc(this.service) : super(CuotasInitial()) {
    on<LoadCuotas>(_onLoadCuotas);
    on<RefreshCuotas>(_onRefreshCuotas);
    on<PagarCuota>(_onPagarCuota);
    on<NoPagarCuota>(_onNoPagarCuota);
    on<PagoParcialCuota>(_onPagoParcialCuota);
  }

  Future<void> _onLoadCuotas(
    LoadCuotas event,
    Emitter<CuotasState> emit,
  ) async {
    emit(CuotasLoading());
    try {
      final data = await service.getCuotasByPrestamo(event.prestamoId);
      emit(CuotasLoaded(data));
    } catch (e) {
      emit(CuotasError("Error cargando cuotas: $e"));
    }
  }

  Future<void> _onRefreshCuotas(
    RefreshCuotas event,
    Emitter<CuotasState> emit,
  ) async {
    try {
      final data = await service.getCuotasByPrestamo(event.prestamoId);
      emit(CuotasLoaded(data));
    } catch (e) {
      emit(CuotasError("Error refrescando cuotas: $e"));
    }
  }

  Future<void> _onPagarCuota(
    PagarCuota event,
    Emitter<CuotasState> emit,
  ) async {
    try {
      await service.pagarCuota(event.cuotaId);
      final data = await service.getCuotasByPrestamo(
        (state as CuotasLoaded).data.prestamoId,
      );
      emit(CuotasLoaded(data));
    } catch (e) {
      emit(CuotasError("Error pagando cuota: $e"));
    }
  }

  Future<void> _onNoPagarCuota(
    NoPagarCuota event,
    Emitter<CuotasState> emit,
  ) async {
    try {
      await service.marcarCuotaNoPagada(event.cuotaId);
      final data = await service.getCuotasByPrestamo(
        (state as CuotasLoaded).data.prestamoId,
      );
      emit(CuotasLoaded(data));
    } catch (e) {
      emit(CuotasError("Error marcando como no pagada: $e"));
    }
  }

  Future<void> _onPagoParcialCuota(
    PagoParcialCuota event,
    Emitter<CuotasState> emit,
  ) async {
    try {
      await service.pagarCuotaParcial(event.cuotaId, event.monto);
      final data = await service.getCuotasByPrestamo(
        (state as CuotasLoaded).data.prestamoId,
      );
      emit(CuotasLoaded(data));
    } catch (e) {
      emit(CuotasError("Error en pago parcial: $e"));
    }
  }
}
