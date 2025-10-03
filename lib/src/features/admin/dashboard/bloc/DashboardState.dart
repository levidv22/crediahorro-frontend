import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

class DashboardState extends Equatable {
  final List<Cliente> clientes;
  final List<Cliente> anteriores;
  final List<Cliente> hoy;
  final List<Cliente> proximos;
  final Resource<dynamic>? status;

  const DashboardState({
    this.clientes = const [],
    this.anteriores = const [],
    this.hoy = const [],
    this.proximos = const [],
    this.status,
  });

  DashboardState copyWith({
    List<Cliente>? clientes,
    List<Cliente>? anteriores,
    List<Cliente>? hoy,
    List<Cliente>? proximos,
    Resource<dynamic>? status,
  }) {
    return DashboardState(
      clientes: clientes ?? this.clientes,
      anteriores: anteriores ?? this.anteriores,
      hoy: hoy ?? this.hoy,
      proximos: proximos ?? this.proximos,
      status: status,
    );
  }

  @override
  List<Object?> get props => [clientes, anteriores, hoy, proximos, status];
}
