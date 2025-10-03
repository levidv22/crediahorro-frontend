import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormBloc.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormEvent.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanFormContent extends StatelessWidget {
  const LoanFormContent({super.key});

  Future<void> _seleccionarFecha(
    BuildContext context,
    void Function(String) onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      final fechaFormateada =
          "${picked.day.toString().padLeft(2, "0")}/${picked.month.toString().padLeft(2, "0")}/${picked.year}";
      onChanged(fechaFormateada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanFormBloc, LoanFormState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Préstamo creado con éxito")),
          );
          Navigator.pop(context, true);
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        }
      },
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Controladores para reflejar las fechas actualizadas
        final fechaCreacionController = TextEditingController(
          text: state.fechaCreacion,
        );
        final fechaInicioController = TextEditingController(
          text: state.fechaInicio,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Datos del Préstamo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Tipo de cuota
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Mensual"),
                      value: "MENSUAL",
                      groupValue: state.tipoCuota,
                      onChanged: (v) => context.read<LoanFormBloc>().add(
                        LoanTipoCuotaChanged(v!),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Diario"),
                      value: "DIARIO",
                      groupValue: state.tipoCuota,
                      onChanged: (v) => context.read<LoanFormBloc>().add(
                        LoanTipoCuotaChanged(v!),
                      ),
                    ),
                  ),
                ],
              ),

              _buildField(
                label: "Monto del préstamo",
                value: state.monto,
                keyboard: TextInputType.number,
                onChanged: (v) =>
                    context.read<LoanFormBloc>().add(LoanMontoChanged(v)),
              ),
              _buildField(
                label: "Tasa de interés mensual (%)",
                value: state.tasa,
                keyboard: TextInputType.number,
                onChanged: (v) =>
                    context.read<LoanFormBloc>().add(LoanTasaChanged(v)),
              ),
              _buildField(
                label: "Número de cuotas",
                value: state.cuotas,
                keyboard: TextInputType.number,
                onChanged: (v) =>
                    context.read<LoanFormBloc>().add(LoanCuotasChanged(v)),
              ),

              // Fecha creación
              GestureDetector(
                onTap: () => _seleccionarFecha(
                  context,
                  (fecha) => context.read<LoanFormBloc>().add(
                    LoanFechaCreacionChanged(fecha),
                  ),
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
                onTap: () => _seleccionarFecha(
                  context,
                  (fecha) => context.read<LoanFormBloc>().add(
                    LoanFechaInicioChanged(fecha),
                  ),
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
                  onPressed: () =>
                      context.read<LoanFormBloc>().add(LoanFormSubmitted()),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField({
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
        onChanged: onChanged,
        keyboardType: keyboard,
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
}
