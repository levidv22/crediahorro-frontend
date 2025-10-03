import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/ClienteService.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ClienteService clienteService;

  ClientsBloc(this.clienteService) : super(ClientsInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientsState> emit,
  ) async {
    emit(ClientsLoading());
    try {
      final clientes = await clienteService.getClientes();
      emit(ClientsLoaded(clientes: clientes, filteredClientes: clientes));
    } catch (e) {
      emit(ClientsError("Error cargando clientes: $e"));
    }
  }

  void _onSearchClients(SearchClients event, Emitter<ClientsState> emit) {
    if (state is ClientsLoaded) {
      final current = state as ClientsLoaded;
      final query = event.query.toLowerCase();
      final filtered = current.clientes
          .where(
            (c) =>
                c.nombre.toLowerCase().contains(query) ||
                c.dni.toLowerCase().contains(query),
          )
          .toList();
      emit(
        ClientsLoaded(clientes: current.clientes, filteredClientes: filtered),
      );
    }
  }
}
