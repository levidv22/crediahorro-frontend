import 'package:equatable/equatable.dart';

abstract class CuotasEvent extends Equatable {
  const CuotasEvent();

  @override
  List<Object?> get props => [];
}

class LoadCuotas extends CuotasEvent {
  final int prestamoId;
  const LoadCuotas(this.prestamoId);

  @override
  List<Object?> get props => [prestamoId];
}

class RefreshCuotas extends CuotasEvent {
  final int prestamoId;
  const RefreshCuotas(this.prestamoId);

  @override
  List<Object?> get props => [prestamoId];
}

class PagarCuota extends CuotasEvent {
  final int cuotaId;
  const PagarCuota(this.cuotaId);

  @override
  List<Object?> get props => [cuotaId];
}

class NoPagarCuota extends CuotasEvent {
  final int cuotaId;
  const NoPagarCuota(this.cuotaId);

  @override
  List<Object?> get props => [cuotaId];
}

class PagoParcialCuota extends CuotasEvent {
  final int cuotaId;
  final double monto;
  const PagoParcialCuota(this.cuotaId, this.monto);

  @override
  List<Object?> get props => [cuotaId, monto];
}
