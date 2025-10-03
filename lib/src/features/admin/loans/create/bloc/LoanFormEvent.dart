import 'package:equatable/equatable.dart';

abstract class LoanFormEvent extends Equatable {
  const LoanFormEvent();

  @override
  List<Object?> get props => [];
}

class LoanMontoChanged extends LoanFormEvent {
  final String monto;
  const LoanMontoChanged(this.monto);

  @override
  List<Object?> get props => [monto];
}

class LoanTasaChanged extends LoanFormEvent {
  final String tasa;
  const LoanTasaChanged(this.tasa);

  @override
  List<Object?> get props => [tasa];
}

class LoanCuotasChanged extends LoanFormEvent {
  final String cuotas;
  const LoanCuotasChanged(this.cuotas);

  @override
  List<Object?> get props => [cuotas];
}

class LoanTipoCuotaChanged extends LoanFormEvent {
  final String tipo;
  const LoanTipoCuotaChanged(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

class LoanFechaCreacionChanged extends LoanFormEvent {
  final String fecha;
  const LoanFechaCreacionChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

class LoanFechaInicioChanged extends LoanFormEvent {
  final String fecha;
  const LoanFechaInicioChanged(this.fecha);

  @override
  List<Object?> get props => [fecha];
}

class LoanFormSubmitted extends LoanFormEvent {}
