import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ClienteService clienteService;

  ClientsBloc(this.clienteService) : super(ClientsInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
    on<SortClients>(_onSortClients);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientsState> emit,
  ) async {
    emit(ClientsLoading());
    try {
      final clientes = await clienteService.getClientes();

      // Orden inicial: alfabético ascendente
      final sorted = [...clientes]
        ..sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );

      emit(ClientsLoaded(clientes: sorted, filteredClientes: sorted));
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

  void _onSortClients(SortClients event, Emitter<ClientsState> emit) {
    if (state is ClientsLoaded) {
      final current = state as ClientsLoaded;
      final sorted = [...current.filteredClientes];

      switch (event.sortType) {
        case SortType.nameAsc:
          sorted.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
          );
          break;
        case SortType.nameDesc:
          sorted.sort(
            (a, b) => b.nombre.toLowerCase().compareTo(a.nombre.toLowerCase()),
          );
          break;
        case SortType.dateAsc:
          sorted.sort(
            (a, b) => (a.fechaCreacion ?? '').compareTo(b.fechaCreacion ?? ''),
          );
          break;
        case SortType.dateDesc:
          sorted.sort(
            (a, b) => (b.fechaCreacion ?? '').compareTo(a.fechaCreacion ?? ''),
          );
          break;
      }

      emit(ClientsLoaded(clientes: current.clientes, filteredClientes: sorted));
    }
  }
}
