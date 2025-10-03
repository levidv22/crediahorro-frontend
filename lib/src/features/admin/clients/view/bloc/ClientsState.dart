import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

abstract class ClientsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<Cliente> clientes;
  final List<Cliente> filteredClientes;

  ClientsLoaded({required this.clientes, required this.filteredClientes});

  @override
  List<Object?> get props => [clientes, filteredClientes];
}

class ClientsError extends ClientsState {
  final String message;
  ClientsError(this.message);

  @override
  List<Object?> get props => [message];
}
