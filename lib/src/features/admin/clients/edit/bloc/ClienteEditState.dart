import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:equatable/equatable.dart';

class ClienteEditState extends Equatable {
  final Cliente? cliente;

  final String nombre;
  final String dni;
  final String direccion;
  final String whatsapp;
  final String correo;

  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ClienteEditState({
    this.cliente,
    this.nombre = '',
    this.dni = '',
    this.direccion = '',
    this.whatsapp = '',
    this.correo = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ClienteEditState copyWith({
    Cliente? cliente,
    String? nombre,
    String? dni,
    String? direccion,
    String? whatsapp,
    String? correo,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return ClienteEditState(
      cliente: cliente ?? this.cliente,
      nombre: nombre ?? this.nombre,
      dni: dni ?? this.dni,
      direccion: direccion ?? this.direccion,
      whatsapp: whatsapp ?? this.whatsapp,
      correo: correo ?? this.correo,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    cliente,
    nombre,
    dni,
    direccion,
    whatsapp,
    correo,
    isLoading,
    isSuccess,
    error,
  ];
}
