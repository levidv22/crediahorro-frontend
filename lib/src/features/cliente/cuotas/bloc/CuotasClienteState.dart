import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';

class CuotasClienteState extends Equatable {
  final List<Cuota> cuotas;
  final Resource<dynamic>? status;

  const CuotasClienteState({this.cuotas = const [], this.status});

  CuotasClienteState copyWith({
    List<Cuota>? cuotas,
    Resource<dynamic>? status,
  }) {
    return CuotasClienteState(cuotas: cuotas ?? this.cuotas, status: status);
  }

  @override
  List<Object?> get props => [cuotas, status];
}
