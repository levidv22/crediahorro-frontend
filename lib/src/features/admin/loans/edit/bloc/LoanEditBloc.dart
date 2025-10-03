import 'package:bloc/bloc.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditEvent.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditState.dart';
import 'package:crediahorro/src/services/LoanService.dart';
import 'package:intl/intl.dart';

class LoanEditBloc extends Bloc<LoanEditEvent, LoanEditState> {
  final LoanService loanService;
  final int clienteId;
  final int prestamoId;

  LoanEditBloc({
    required this.loanService,
    required this.clienteId,
    required this.prestamoId,
  }) : super(const LoanEditState()) {
    on<LoanEditStarted>(_onStarted);
    on<LoanMontoChanged>((e, emit) => emit(state.copyWith(monto: e.monto)));
    on<LoanTasaChanged>((e, emit) => emit(state.copyWith(tasa: e.tasa)));
    on<LoanCuotasChanged>((e, emit) => emit(state.copyWith(cuotas: e.cuotas)));
    on<LoanFechaCreacionChanged>(
      (e, emit) => emit(state.copyWith(fechaCreacion: e.fecha)),
    );
    on<LoanFechaInicioChanged>(
      (e, emit) => emit(state.copyWith(fechaInicio: e.fecha)),
    );
    on<LoanEstadoChanged>((e, emit) => emit(state.copyWith(estado: e.estado)));
    on<LoanEditSubmitted>(_onSubmit);
  }

  Future<void> _onStarted(
    LoanEditStarted event,
    Emitter<LoanEditState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final prestamo = await loanService.getPrestamoById(prestamoId);
      if (prestamo != null) {
        emit(
          state.copyWith(
            prestamo: prestamo,
            monto: prestamo.monto.toString(),
            tasa: prestamo.tasaInteresMensual.toString(),
            cuotas: prestamo.numeroCuotas.toString(),
            tipoCuota: prestamo.tipoCuota,
            estado: prestamo.estado,
            fechaInicio: _formatDateForUI(prestamo.fechaInicio),
            fechaCreacion: _formatDateForUI(prestamo.fechaCreacion),
            loading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(loading: false, error: "No se encontró el préstamo"),
        );
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onSubmit(
    LoanEditSubmitted event,
    Emitter<LoanEditState> emit,
  ) async {
    if (state.prestamo == null) return;

    emit(state.copyWith(loading: true, error: null, success: false));

    try {
      final prestamo = state.prestamo!
        ..monto = double.tryParse(state.monto) ?? state.prestamo!.monto
        ..tasaInteresMensual =
            double.tryParse(state.tasa) ?? state.prestamo!.tasaInteresMensual
        ..numeroCuotas =
            int.tryParse(state.cuotas) ?? state.prestamo!.numeroCuotas
        ..tipoCuota = state.tipoCuota
        ..estado = state.estado
        ..fechaInicio = _formatDateForBackend(state.fechaInicio)
        ..fechaCreacion = _formatDateForBackend(state.fechaCreacion);

      await loanService.actualizarPrestamo(prestamo.id!, prestamo);

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  String _formatDateForUI(String fecha) {
    try {
      final parsed = DateTime.parse(fecha);
      return DateFormat("dd/MM/yyyy").format(parsed);
    } catch (_) {
      return fecha;
    }
  }

  String _formatDateForBackend(String fechaUI) {
    try {
      final parsed = DateFormat("dd/MM/yyyy").parse(fechaUI);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (_) {
      return fechaUI;
    }
  }
}
