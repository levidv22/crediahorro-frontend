import 'package:equatable/equatable.dart';

abstract class ClienteFormEvent extends Equatable {
  const ClienteFormEvent();

  @override
  List<Object?> get props => [];
}

// Nombre
class NombreChanged extends ClienteFormEvent {
  final String nombre;
  const NombreChanged(this.nombre);

  @override
  List<Object?> get props => [nombre];
}

// DNI
class DniChanged extends ClienteFormEvent {
  final String dni;
  const DniChanged(this.dni);

  @override
  List<Object?> get props => [dni];
}

// Dirección
class DireccionChanged extends ClienteFormEvent {
  final String direccion;
  const DireccionChanged(this.direccion);

  @override
  List<Object?> get props => [direccion];
}

// WhatsApp
class WhatsappChanged extends ClienteFormEvent {
  final String whatsapp;
  const WhatsappChanged(this.whatsapp);

  @override
  List<Object?> get props => [whatsapp];
}

// Correo electrónico
class CorreoChanged extends ClienteFormEvent {
  final String correo;
  const CorreoChanged(this.correo);

  @override
  List<Object?> get props => [correo];
}

// Monto del préstamo
class MontoChanged extends ClienteFormEvent {
  final double monto;
  const MontoChanged(this.monto);

  @override
  List<Object?> get props => [monto];
}

// Tasa de interés
class TasaChanged extends ClienteFormEvent {
  final double tasa;
  const TasaChanged(this.tasa);

  @override
  List<Object?> get props => [tasa];
}

// Número de cuotas
class CuotasChanged extends ClienteFormEvent {
  final int cuotas;
  const CuotasChanged(this.cuotas);

  @override
  List<Object?> get props => [cuotas];
}

// Fecha creación
class FechaCreacionChanged extends ClienteFormEvent {
  final DateTime fecha;
  const FechaCreacionChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

// Fecha inicio
class FechaInicioChanged extends ClienteFormEvent {
  final DateTime fecha;
  const FechaInicioChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

// Tipo de cuota
class TipoCuotaChanged extends ClienteFormEvent {
  final String tipo;
  const TipoCuotaChanged(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

// Guardar
class GuardarClienteSubmitted extends ClienteFormEvent {}
