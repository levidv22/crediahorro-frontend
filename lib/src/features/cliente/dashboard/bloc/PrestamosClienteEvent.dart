import 'package:equatable/equatable.dart';

abstract class PrestamosClienteEvent extends Equatable {
  const PrestamosClienteEvent();

  @override
  List<Object?> get props => [];
}

class LoadPrestamosCliente extends PrestamosClienteEvent {}
