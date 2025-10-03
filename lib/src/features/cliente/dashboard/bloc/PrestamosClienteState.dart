import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';

class PrestamosClienteState extends Equatable {
  final List<Prestamo> prestamos;
  final List<Prestamo> anteriores;
  final List<Prestamo> hoy;
  final List<Prestamo> proximos;
  final List<Prestamo> pagados;
  final Resource<dynamic>? status;

  const PrestamosClienteState({
    this.prestamos = const [],
    this.anteriores = const [],
    this.hoy = const [],
    this.proximos = const [],
    this.pagados = const [],
    this.status,
  });

  PrestamosClienteState copyWith({
    List<Prestamo>? prestamos,
    List<Prestamo>? anteriores,
    List<Prestamo>? hoy,
    List<Prestamo>? proximos,
    List<Prestamo>? pagados,
    Resource<dynamic>? status,
  }) {
    return PrestamosClienteState(
      prestamos: prestamos ?? this.prestamos,
      anteriores: anteriores ?? this.anteriores,
      hoy: hoy ?? this.hoy,
      proximos: proximos ?? this.proximos,
      pagados: pagados ?? this.pagados,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
    prestamos,
    anteriores,
    hoy,
    proximos,
    pagados,
    status,
  ];
}
