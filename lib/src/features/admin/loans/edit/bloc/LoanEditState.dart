import 'package:crediahorro/src/features/admin/loans/models/loans.dart';
import 'package:equatable/equatable.dart';

class LoanEditState extends Equatable {
  final Prestamo? prestamo;
  final String monto;
  final String tasa;
  final String cuotas;
  final String tipoCuota;
  final String fechaCreacion;
  final String fechaInicio;
  final String? estado;
  final bool loading;
  final bool success;
  final String? error;

  const LoanEditState({
    this.prestamo,
    this.monto = "",
    this.tasa = "",
    this.cuotas = "",
    this.tipoCuota = "MENSUAL",
    this.fechaCreacion = "",
    this.fechaInicio = "",
    this.estado,
    this.loading = false,
    this.success = false,
    this.error,
  });

  LoanEditState copyWith({
    Prestamo? prestamo,
    String? monto,
    String? tasa,
    String? cuotas,
    String? tipoCuota,
    String? fechaCreacion,
    String? fechaInicio,
    String? estado,
    bool? loading,
    bool? success,
    String? error,
  }) {
    return LoanEditState(
      prestamo: prestamo ?? this.prestamo,
      monto: monto ?? this.monto,
      tasa: tasa ?? this.tasa,
      cuotas: cuotas ?? this.cuotas,
      tipoCuota: tipoCuota ?? this.tipoCuota,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      estado: estado ?? this.estado,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    prestamo,
    monto,
    tasa,
    cuotas,
    tipoCuota,
    fechaCreacion,
    fechaInicio,
    estado,
    loading,
    success,
    error,
  ];
}
