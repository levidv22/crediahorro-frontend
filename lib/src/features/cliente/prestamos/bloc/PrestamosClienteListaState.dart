import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';

abstract class PrestamosClienteListaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrestamosClienteListaInitial extends PrestamosClienteListaState {}

class PrestamosClienteListaLoading extends PrestamosClienteListaState {}

class PrestamosClienteListaLoaded extends PrestamosClienteListaState {
  final List<Prestamo> prestamos;
  final List<Prestamo> filtered;

  PrestamosClienteListaLoaded({
    required this.prestamos,
    required this.filtered,
  });

  @override
  List<Object?> get props => [prestamos, filtered];
}

class PrestamosClienteListaError extends PrestamosClienteListaState {
  final String message;
  PrestamosClienteListaError(this.message);

  @override
  List<Object?> get props => [message];
}
