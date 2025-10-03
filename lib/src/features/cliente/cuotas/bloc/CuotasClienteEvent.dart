import 'package:equatable/equatable.dart';

abstract class CuotasClienteEvent extends Equatable {
  const CuotasClienteEvent();

  @override
  List<Object?> get props => [];
}

class LoadCuotasCliente extends CuotasClienteEvent {
  final int prestamoId;

  const LoadCuotasCliente(this.prestamoId);

  @override
  List<Object?> get props => [prestamoId];
}
