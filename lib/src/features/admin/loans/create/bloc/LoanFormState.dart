import 'package:equatable/equatable.dart';

class LoanFormState extends Equatable {
  final String monto;
  final String tasa;
  final String cuotas;
  final String tipoCuota;
  final String fechaCreacion;
  final String fechaInicio;
  final bool loading;
  final String? error;
  final bool success;

  const LoanFormState({
    this.monto = "",
    this.tasa = "",
    this.cuotas = "",
    this.tipoCuota = "MENSUAL",
    this.fechaCreacion = "",
    this.fechaInicio = "",
    this.loading = false,
    this.error,
    this.success = false,
  });

  LoanFormState copyWith({
    String? monto,
    String? tasa,
    String? cuotas,
    String? tipoCuota,
    String? fechaCreacion,
    String? fechaInicio,
    bool? loading,
    String? error,
    bool? success,
  }) {
    return LoanFormState(
      monto: monto ?? this.monto,
      tasa: tasa ?? this.tasa,
      cuotas: cuotas ?? this.cuotas,
      tipoCuota: tipoCuota ?? this.tipoCuota,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
    monto,
    tasa,
    cuotas,
    tipoCuota,
    fechaCreacion,
    fechaInicio,
    loading,
    error,
    success,
  ];
}
