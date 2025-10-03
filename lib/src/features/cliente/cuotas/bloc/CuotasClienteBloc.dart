import 'package:flutter_bloc/flutter_bloc.dart';
import 'CuotasClienteEvent.dart';
import 'CuotasClienteState.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';

class CuotasClienteBloc extends Bloc<CuotasClienteEvent, CuotasClienteState> {
  final UsuariosService usuariosService;

  CuotasClienteBloc(this.usuariosService) : super(const CuotasClienteState()) {
    on<LoadCuotasCliente>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));
      try {
        final cuotas = await usuariosService.getMisCuotas(event.prestamoId);
        emit(
          state.copyWith(
            cuotas: cuotas,
            status: Resource.success("Cuotas cargadas"),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: Resource.error("Error: $e")));
      }
    });
  }
}
