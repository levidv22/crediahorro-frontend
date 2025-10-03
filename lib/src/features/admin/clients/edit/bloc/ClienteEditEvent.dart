import 'package:equatable/equatable.dart';

abstract class ClienteEditEvent extends Equatable {
  const ClienteEditEvent();

  @override
  List<Object?> get props => [];
}

class LoadClienteById extends ClienteEditEvent {
  final int clienteId;
  const LoadClienteById(this.clienteId);

  @override
  List<Object?> get props => [clienteId];
}

class NombreChanged extends ClienteEditEvent {
  final String nombre;
  const NombreChanged(this.nombre);

  @override
  List<Object?> get props => [nombre];
}

class DniChanged extends ClienteEditEvent {
  final String dni;
  const DniChanged(this.dni);

  @override
  List<Object?> get props => [dni];
}

class DireccionChanged extends ClienteEditEvent {
  final String direccion;
  const DireccionChanged(this.direccion);

  @override
  List<Object?> get props => [direccion];
}

class WhatsappChanged extends ClienteEditEvent {
  final String whatsapp;
  const WhatsappChanged(this.whatsapp);

  @override
  List<Object?> get props => [whatsapp];
}

class CorreoChanged extends ClienteEditEvent {
  final String correo;
  const CorreoChanged(this.correo);

  @override
  List<Object?> get props => [correo];
}

class UpdateClienteSubmitted extends ClienteEditEvent {}
