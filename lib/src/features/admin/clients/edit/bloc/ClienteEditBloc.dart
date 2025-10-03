import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditEvent.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditState.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClienteEditBloc extends Bloc<ClienteEditEvent, ClienteEditState> {
  final ClienteService clienteService;

  ClienteEditBloc(this.clienteService) : super(const ClienteEditState()) {
    on<LoadClienteById>(_onLoadCliente);
    on<NombreChanged>((e, emit) => emit(state.copyWith(nombre: e.nombre)));
    on<DniChanged>((e, emit) => emit(state.copyWith(dni: e.dni)));
    on<DireccionChanged>(
      (e, emit) => emit(state.copyWith(direccion: e.direccion)),
    );
    on<WhatsappChanged>(
      (e, emit) => emit(state.copyWith(whatsapp: e.whatsapp)),
    );
    on<CorreoChanged>((e, emit) => emit(state.copyWith(correo: e.correo)));

    on<UpdateClienteSubmitted>(_onUpdateCliente);
  }

  Future<void> _onLoadCliente(
    LoadClienteById event,
    Emitter<ClienteEditState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cliente = await clienteService.getClienteById(event.clienteId);
      emit(
        state.copyWith(
          cliente: cliente,
          nombre: cliente.nombre,
          dni: cliente.dni,
          direccion: cliente.direccion,
          whatsapp: cliente.telefonoWhatsapp,
          correo: cliente.correoElectronico,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateCliente(
    UpdateClienteSubmitted event,
    Emitter<ClienteEditState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedCliente = Cliente(
        id: state.cliente!.id,
        nombre: state.nombre,
        dni: state.dni,
        direccion: state.direccion,
        telefonoWhatsapp: state.whatsapp,
        correoElectronico: state.correo,
        prestamos: state.cliente!.prestamos,
      );
      await clienteService.updateCliente(state.cliente!.id!, updatedCliente);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
