import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditBloc.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditEvent.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanEditContent extends StatelessWidget {
  const LoanEditContent({super.key});

  Future<void> _selectDate(
    BuildContext context,
    void Function(String) onChanged,
    String initialValue,
  ) async {
    final initialDate =
        DateTime.tryParse(initialValue.split("/").reversed.join("-")) ??
        DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      final formatted =
          "${picked.day.toString().padLeft(2, "0")}/${picked.month.toString().padLeft(2, "0")}/${picked.year}";
      onChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanEditBloc, LoanEditState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Préstamo actualizado con éxito")),
          );
          Navigator.pop(context, true);
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        }
      },
      builder: (context, state) {
        if (state.loading && state.prestamo == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildField(
                label: "Monto del préstamo",
                value: state.monto,
                onChanged: (v) =>
                    context.read<LoanEditBloc>().add(LoanMontoChanged(v)),
              ),
              _buildField(
                label: "Interés mensual (%)",
                value: state.tasa,
                onChanged: (v) =>
                    context.read<LoanEditBloc>().add(LoanTasaChanged(v)),
              ),
              _buildField(
                label: "Número de cuotas",
                value: state.cuotas,
                onChanged: (v) =>
                    context.read<LoanEditBloc>().add(LoanCuotasChanged(v)),
              ),

              // Tipo de cuota solo lectura
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Mensual"),
                      value: "MENSUAL",
                      groupValue: state.tipoCuota,
                      onChanged: null,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Diario"),
                      value: "DIARIO",
                      groupValue: state.tipoCuota,
                      onChanged: null,
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () => _selectDate(
                  context,
                  (fecha) => context.read<LoanEditBloc>().add(
                    LoanFechaCreacionChanged(fecha),
                  ),
                  state.fechaCreacion,
                ),
                child: AbsorbPointer(
                  child: _buildField(
                    label: "Fecha de creación",
                    value: state.fechaCreacion,
                    hint: "dd/MM/yyyy",
                    onChanged: (_) {},
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(
                  context,
                  (fecha) => context.read<LoanEditBloc>().add(
                    LoanFechaInicioChanged(fecha),
                  ),
                  state.fechaInicio,
                ),
                child: AbsorbPointer(
                  child: _buildField(
                    label: "Fecha de inicio",
                    value: state.fechaInicio,
                    hint: "dd/MM/yyyy",
                    onChanged: (_) {},
                  ),
                ),
              ),

              DropdownButtonFormField<String>(
                value: state.estado,
                items: const [
                  DropdownMenuItem(value: "ACTIVO", child: Text("ACTIVO")),
                  DropdownMenuItem(value: "PAGADO", child: Text("PAGADO")),
                ],
                onChanged: null, // solo lectura
                decoration: InputDecoration(
                  labelText: "Estado",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
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
                    context.read<LoanEditBloc>().add(LoanEditSubmitted()),
                icon: const Icon(Icons.update, color: Colors.white),
                label: const Text(
                  "Actualizar",
                  style: TextStyle(color: Colors.white),
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
    final controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboard,
        readOnly: false,
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
