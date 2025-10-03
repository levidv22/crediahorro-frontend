import 'package:equatable/equatable.dart';

class ClienteFormState extends Equatable {
  final String nombre;
  final String dni;
  final String direccion;
  final String whatsapp;
  final String correo;
  final double monto;
  final double tasa;
  final int cuotas;
  final String tipoCuota;
  final DateTime? fechaInicio;
  final DateTime? fechaCreacion;

  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ClienteFormState({
    this.nombre = '',
    this.dni = '',
    this.direccion = '',
    this.whatsapp = '',
    this.correo = '',
    this.monto = 0,
    this.tasa = 0,
    this.cuotas = 0,
    this.tipoCuota = 'MENSUAL',
    this.fechaInicio,
    this.fechaCreacion,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ClienteFormState copyWith({
    String? nombre,
    String? dni,
    String? direccion,
    String? whatsapp,
    String? correo,
    double? monto,
    double? tasa,
    int? cuotas,
    String? tipoCuota,
    DateTime? fechaInicio,
    DateTime? fechaCreacion,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return ClienteFormState(
      nombre: nombre ?? this.nombre,
      dni: dni ?? this.dni,
      direccion: direccion ?? this.direccion,
      whatsapp: whatsapp ?? this.whatsapp,
      correo: correo ?? this.correo,
      monto: monto ?? this.monto,
      tasa: tasa ?? this.tasa,
      cuotas: cuotas ?? this.cuotas,
      tipoCuota: tipoCuota ?? this.tipoCuota,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    nombre,
    dni,
    direccion,
    whatsapp,
    correo,
    monto,
    tasa,
    cuotas,
    tipoCuota,
    fechaInicio,
    fechaCreacion,
    isLoading,
    isSuccess,
    error,
  ];
}
