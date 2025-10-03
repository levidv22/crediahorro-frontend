import 'package:equatable/equatable.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final Resource<dynamic>? status;

  const LoginState({this.username = '', this.password = '', this.status});

  LoginState copyWith({
    String? username,
    String? password,
    Resource<dynamic>? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status,
    );
  }

  @override
  List<Object?> get props => [username, password, status];
}
