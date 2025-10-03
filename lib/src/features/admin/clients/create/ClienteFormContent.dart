import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormBloc.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormEvent.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClienteFormContent extends StatelessWidget {
  final ClienteFormState state;
  const ClienteFormContent({super.key, required this.state});

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClienteFormBloc>();

    // Controladores para fechas (se actualizan con el estado)
    final fechaCreacionController = TextEditingController(
      text: state.fechaCreacion != null
          ? DateFormat("dd/MM/yyyy").format(state.fechaCreacion!)
          : "",
    );
    final fechaInicioController = TextEditingController(
      text: state.fechaInicio != null
          ? DateFormat("dd/MM/yyyy").format(state.fechaInicio!)
          : "",
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Datos del Cliente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildTextField(
              label: "Nombre",
              value: state.nombre,
              onChanged: (v) => bloc.add(NombreChanged(v)),
            ),
            _buildTextField(
              label: "DNI",
              value: state.dni,
              onChanged: (v) => bloc.add(DniChanged(v)),
            ),
            _buildTextField(
              label: "Dirección",
              value: state.direccion,
              onChanged: (v) => bloc.add(DireccionChanged(v)),
            ),
            _buildTextField(
              label: "WhatsApp",
              value: state.whatsapp,
              onChanged: (v) => bloc.add(WhatsappChanged(v)),
              keyboard: TextInputType.phone,
            ),
            _buildEmailField(
              value: state.correo,
              onChanged: (v) => bloc.add(CorreoChanged(v)),
            ),

            const SizedBox(height: 20),
            const Text(
              "Préstamo Inicial",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Mensual"),
                    value: "MENSUAL",
                    groupValue: state.tipoCuota,
                    onChanged: (v) => bloc.add(TipoCuotaChanged(v!)),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Diario"),
                    value: "DIARIO",
                    groupValue: state.tipoCuota,
                    onChanged: (v) => bloc.add(TipoCuotaChanged(v!)),
                  ),
                ),
              ],
            ),

            _buildNumberField(
              label: "Monto del préstamo",
              value: state.monto.toString(),
              onChanged: (v) => bloc.add(MontoChanged(double.tryParse(v) ?? 0)),
            ),
            _buildNumberField(
              label: "Tasa de interés mensual",
              value: state.tasa.toString(),
              onChanged: (v) => bloc.add(TasaChanged(double.tryParse(v) ?? 0)),
            ),
            _buildNumberField(
              label: "Número de cuotas",
              value: state.cuotas.toString(),
              onChanged: (v) => bloc.add(CuotasChanged(int.tryParse(v) ?? 0)),
            ),

            // Fecha creación
            GestureDetector(
              onTap: () => _selectDate(
                context,
                state.fechaCreacion,
                (d) => bloc.add(FechaCreacionChanged(d)),
              ),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: fechaCreacionController,
                  decoration: InputDecoration(
                    labelText: "Fecha de creación",
                    hintText: "dd/MM/yyyy",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Fecha inicio
            GestureDetector(
              onTap: () => _selectDate(
                context,
                state.fechaInicio,
                (d) => bloc.add(FechaInicioChanged(d)),
              ),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: fechaInicioController,
                  decoration: InputDecoration(
                    labelText: "Fecha de inicio",
                    hintText: "dd/MM/yyyy",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
              ),
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
                onPressed: () => bloc.add(GuardarClienteSubmitted()),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboard,
        onChanged: onChanged,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? "Ingrese $label" : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return _buildTextField(
      label: label,
      value: value,
      onChanged: onChanged,
      keyboard: TextInputType.number,
    );
  }

  Widget _buildEmailField({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged,
        validator: (v) {
          if (v == null || v.trim().isEmpty) return null;
          final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          if (!regex.hasMatch(v.trim())) return "Ingrese un correo válido";
          return null;
        },
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
