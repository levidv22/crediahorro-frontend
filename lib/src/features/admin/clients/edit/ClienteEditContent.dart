import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditBloc.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditEvent.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClienteEditContent extends StatelessWidget {
  final ClienteEditState state;
  const ClienteEditContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClienteEditBloc>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              initialValue: state.nombre,
              label: "Nombre",
              onChanged: (v) => bloc.add(NombreChanged(v)),
            ),
            _buildTextField(
              initialValue: state.dni,
              label: "DNI",
              onChanged: (v) => bloc.add(DniChanged(v)),
            ),
            _buildTextField(
              initialValue: state.direccion,
              label: "Dirección",
              onChanged: (v) => bloc.add(DireccionChanged(v)),
            ),
            _buildTextField(
              initialValue: state.whatsapp,
              label: "WhatsApp",
              keyboard: TextInputType.phone,
              onChanged: (v) => bloc.add(WhatsappChanged(v)),
            ),
            _buildCorreoField(
              initialValue: state.correo,
              onChanged: (v) => bloc.add(CorreoChanged(v)),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => bloc.add(UpdateClienteSubmitted()),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Actualizar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Campos (obligatorios)
  Widget _buildTextField({
    required String initialValue,
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty ? "Ingrese $label" : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }

  /// Campo correo (opcional)
  Widget _buildCorreoField({
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          if (!emailRegex.hasMatch(value)) {
            return "Ingrese un correo válido";
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: "Correo Electrónico (opcional)",
          hintText: "ejemplo@correo.com",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }
}
