import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String username;
  final String whatsapp;
  final String email;
  final String password;
  final Resource<void>? status;

  const RegisterState({
    this.username = '',
    this.whatsapp = '',
    this.email = '',
    this.password = '',
    this.status,
  });

  RegisterState copyWith({
    String? username,
    String? whatsapp,
    String? email,
    String? password,
    Resource<void>? status,
  }) {
    return RegisterState(
      username: username ?? this.username,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status,
    );
  }

  @override
  List<Object?> get props => [username, whatsapp, email, password, status];
}
