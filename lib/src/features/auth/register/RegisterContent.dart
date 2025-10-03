import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/register/bloc/RegisterBloc.dart';
import 'package:crediahorro/src/features/auth/register/bloc/RegisterEvent.dart';
import 'package:crediahorro/src/features/auth/register/bloc/RegisterState.dart';
import 'package:crediahorro/src/routing/app_router.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status?.status == Status.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Registro exitoso")));
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.login,
            (route) => false,
          );
        } else if (state.status?.status == Status.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.status?.message ?? "Error")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/img/login.jpeg", fit: BoxFit.cover),
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

                    const SizedBox(height: 40),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUserField(context),
                              const SizedBox(height: 16),
                              _buildWhatsappField(context),
                              const SizedBox(height: 16),
                              _buildEmailField(context),
                              const SizedBox(height: 16),
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
                          Navigator.pushNamed(context, AppRouter.login);
                        },
                        child: const Text(
                          "¿Ya tienes cuenta? Inicia sesión",
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
      decoration: _inputDecoration("Usuario", Icons.person),
      onChanged: (value) =>
          context.read<RegisterBloc>().add(RegisterUsernameChanged(value)),
    );
  }

  Widget _buildWhatsappField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration("WhatsApp", Icons.phone),
      onChanged: (value) =>
          context.read<RegisterBloc>().add(RegisterWhatsappChanged(value)),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextField(
      decoration: _inputDecoration("Correo electrónico", Icons.email),
      onChanged: (value) =>
          context.read<RegisterBloc>().add(RegisterEmailChanged(value)),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextField(
      obscureText: _obscurePassword,
      decoration: _inputDecoration("Contraseña", Icons.lock).copyWith(
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
      ),
      onChanged: (value) =>
          context.read<RegisterBloc>().add(RegisterPasswordChanged(value)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
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
    );
  }

  Widget _buildArrowButton(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
            context.read<RegisterBloc>().add(const RegisterSubmitted());
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
