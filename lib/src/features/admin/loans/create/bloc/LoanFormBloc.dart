import 'package:bloc/bloc.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormEvent.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormState.dart';
import 'package:crediahorro/src/features/admin/loans/models/loans.dart';
import 'package:crediahorro/src/services/LoanService.dart';
import 'package:intl/intl.dart';

class LoanFormBloc extends Bloc<LoanFormEvent, LoanFormState> {
  final LoanService loanService;
  final int clienteId;

  LoanFormBloc({required this.loanService, required this.clienteId})
    : super(
        LoanFormState(
          fechaCreacion: DateFormat("dd/MM/yyyy").format(DateTime.now()),
        ),
      ) {
    on<LoanMontoChanged>((e, emit) => emit(state.copyWith(monto: e.monto)));
    on<LoanTasaChanged>((e, emit) => emit(state.copyWith(tasa: e.tasa)));
    on<LoanCuotasChanged>((e, emit) => emit(state.copyWith(cuotas: e.cuotas)));
    on<LoanTipoCuotaChanged>(
      (e, emit) => emit(state.copyWith(tipoCuota: e.tipo)),
    );
    on<LoanFechaCreacionChanged>(
      (e, emit) => emit(state.copyWith(fechaCreacion: e.fecha)),
    );
    on<LoanFechaInicioChanged>(
      (e, emit) => emit(state.copyWith(fechaInicio: e.fecha)),
    );

    on<LoanFormSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
    LoanFormSubmitted event,
    Emitter<LoanFormState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null, success: false));

    try {
      final prestamo = Prestamo(
        monto: double.tryParse(state.monto) ?? 0,
        tasaInteresMensual: double.tryParse(state.tasa) ?? 0,
        numeroCuotas: int.tryParse(state.cuotas) ?? 0,
        tipoCuota: state.tipoCuota,
        fechaInicio: _convertirFecha(state.fechaInicio),
        fechaCreacion: _convertirFecha(state.fechaCreacion),
      );

      await loanService.crearPrestamo(clienteId, prestamo);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  String _convertirFecha(String fechaDDMMYYYY) {
    if (fechaDDMMYYYY.trim().isEmpty) return fechaDDMMYYYY;
    try {
      final DateTime parsed = DateFormat("dd/MM/yyyy").parse(fechaDDMMYYYY);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (_) {
      return fechaDDMMYYYY;
    }
  }
}
