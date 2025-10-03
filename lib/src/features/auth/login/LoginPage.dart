import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/features/auth/login/LoginContent.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginBloc.dart';
import 'package:crediahorro/src/services/AuthService.dart';

//muestra
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(AuthService()),
      child: const Scaffold(body: LoginContent()),
    );
  }
}
