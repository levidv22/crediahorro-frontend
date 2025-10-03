import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginBloc.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginEvent.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginState.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState(); //muestra contenido
}

class _LoginContentState extends State<LoginContent> {
  bool _obscurePassword = true; //ojito de contraseña

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status != null) {
          if (state.status!.status == Status.success) {
            final route = state.status!.data;
            Navigator.pushNamedAndRemoveUntil(
              context,
              route,
              (route) => false, //borra la ruta anterior
            );
          } else if (state.status!.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.status!.message ?? 'Error')),
            );
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/login.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    const Center(
                      child: Text(
                        "CREDIAHORRO",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUserField(context),
                              const SizedBox(height: 20),
                              _buildPasswordField(context),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        _buildArrowButton(context),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.register);
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate aquí",
                          style: TextStyle(color: Color(0xFF0052CC)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Usuario",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      onChanged: (value) {
        context.read<LoginBloc>().add(LoginUsernameChanged(value));
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextField(
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "*************",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      onChanged: (value) {
        context.read<LoginBloc>().add(LoginPasswordChanged(value));
      },
    );
  }

  Widget _buildArrowButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status?.status == Status.loading) {
          return const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
            ),
          );
        }
        return InkWell(
          onTap: () {
            context.read<LoginBloc>().add(const LoginSubmitted());
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0052CC),
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        );
      },
    );
  }
}
