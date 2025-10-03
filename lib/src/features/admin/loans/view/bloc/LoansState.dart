import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

enum LoansStatus { initial, loading, success, failure }

class LoansState extends Equatable {
  final Cliente? cliente;
  final LoansStatus status;
  final String? errorMessage;

  const LoansState({
    this.cliente,
    this.status = LoansStatus.initial,
    this.errorMessage,
  });

  LoansState copyWith({
    Cliente? cliente,
    LoansStatus? status,
    String? errorMessage,
  }) {
    return LoansState(
      cliente: cliente ?? this.cliente,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [cliente, status, errorMessage];
}
