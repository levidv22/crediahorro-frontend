import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansEvent.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/ClienteService.dart';

class LoansBloc extends Bloc<LoansEvent, LoansState> {
  final ClienteService clienteService;

  LoansBloc(this.clienteService) : super(const LoansState()) {
    // Cargar préstamos de un cliente
    on<LoansLoaded>((event, emit) async {
      emit(state.copyWith(status: LoansStatus.loading));
      try {
        final cliente = await clienteService.getClienteById(event.clienteId);
        emit(state.copyWith(cliente: cliente, status: LoansStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: LoansStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    // Recargar préstamos
    on<LoansReloaded>((event, emit) async {
      if (state.cliente == null) return;
      add(LoansLoaded(state.cliente!.id!));
    });
  }
}
