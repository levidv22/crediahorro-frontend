import 'package:equatable/equatable.dart';

abstract class LoansEvent extends Equatable {
  const LoansEvent();

  @override
  List<Object?> get props => [];
}

class LoansLoaded extends LoansEvent {
  final int clienteId;
  const LoansLoaded(this.clienteId);

  @override
  List<Object?> get props => [clienteId];
}

class LoansReloaded extends LoansEvent {
  const LoansReloaded();
}
