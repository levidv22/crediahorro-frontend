import 'package:equatable/equatable.dart';

abstract class LoanEditEvent extends Equatable {
  const LoanEditEvent();

  @override
  List<Object?> get props => [];
}

class LoanEditStarted extends LoanEditEvent {
  final int prestamoId;
  const LoanEditStarted(this.prestamoId);

  @override
  List<Object?> get props => [prestamoId];
}

class LoanMontoChanged extends LoanEditEvent {
  final String monto;
  const LoanMontoChanged(this.monto);

  @override
  List<Object?> get props => [monto];
}

class LoanTasaChanged extends LoanEditEvent {
  final String tasa;
  const LoanTasaChanged(this.tasa);

  @override
  List<Object?> get props => [tasa];
}

class LoanCuotasChanged extends LoanEditEvent {
  final String cuotas;
  const LoanCuotasChanged(this.cuotas);

  @override
  List<Object?> get props => [cuotas];
}

class LoanFechaCreacionChanged extends LoanEditEvent {
  final String fecha;
  const LoanFechaCreacionChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

class LoanFechaInicioChanged extends LoanEditEvent {
  final String fecha;
  const LoanFechaInicioChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

class LoanEstadoChanged extends LoanEditEvent {
  final String estado;
  const LoanEstadoChanged(this.estado);

  @override
  List<Object?> get props => [estado];
}

class LoanEditSubmitted extends LoanEditEvent {}
