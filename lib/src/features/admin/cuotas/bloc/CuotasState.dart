import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/features/admin/cuotas/models/cuota.dart';

abstract class CuotasState extends Equatable {
  const CuotasState();

  @override
  List<Object?> get props => [];
}

class CuotasInitial extends CuotasState {}

class CuotasLoading extends CuotasState {}

class CuotasLoaded extends CuotasState {
  final PrestamoCuotasResponse data;

  const CuotasLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CuotasError extends CuotasState {
  final String message;

  const CuotasError(this.message);

  @override
  List<Object?> get props => [message];
}
