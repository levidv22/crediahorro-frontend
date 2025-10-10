import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/services/SolicitudesPagoClienteService.dart';
import 'package:intl/intl.dart';

class PagarCuotaPage extends StatefulWidget {
  final Cuota cuota;
  const PagarCuotaPage({super.key, required this.cuota});

  @override
  State<PagarCuotaPage> createState() => _PagarCuotaPageState();
}

class _PagarCuotaPageState extends State<PagarCuotaPage> {
  final _mensajeCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  File? _imagenComprobante;
  bool _enviando = false;
  String _tipoSeleccionado = "PAGO_COMPLETO";

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imagenComprobante = File(picked.path));
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '-';
    try {
      final DateTime fechaParseada = DateTime.parse(fecha);
      return DateFormat('dd MMM yyyy, hh:mm a', 'es_ES').format(fechaParseada);
    } catch (e) {
      return fecha;
    }
  }

  Future<void> _enviarPago() async {
    if (_tipoSeleccionado != "NO_PAGAR" && _imagenComprobante == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, sube tu comprobante de pago")),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      await SolicitudesPagoClienteService().enviarPagoCuota(
        widget.cuota.id!,
        _tipoSeleccionado,
        _mensajeCtrl.text,
        _imagenComprobante,
        montoParcial: _tipoSeleccionado == "PAGO_PARCIAL"
            ? double.tryParse(_montoCtrl.text)
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Solicitud de pago enviada: $_tipoSeleccionado"),
          backgroundColor: Colors.green.shade600,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al enviar pago: $e"),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuota = widget.cuota;

    return AppScaffoldUsuario(
      title: "CREDIAHORRO",
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9F4FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🧾 Card de información del pago
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 8,
                shadowColor: Colors.blue.withOpacity(0.2),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFF1565C0),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Detalles de la Cuota",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "💰 Monto a pagar: S/ ${cuota.montoCuota}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "📅 Fecha límite: ${_formatearFecha(cuota.fechaPago)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 💳 Card QR y número Yape
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                shadowColor: Colors.blueAccent.withOpacity(0.2),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/img/qr_yape.jpeg",
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Número Yape",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "928 581 983",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ⚙️ Tipo de pago
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tipo de pago",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100, width: 1.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButton<String>(
                  value: _tipoSeleccionado,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: "PAGO_COMPLETO",
                      child: Text("Pago completo"),
                    ),
                    DropdownMenuItem(
                      value: "PAGO_PARCIAL",
                      child: Text("Pago parcial"),
                    ),
                    DropdownMenuItem(
                      value: "NO_PAGAR",
                      child: Text("No pagar"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _tipoSeleccionado = value!);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // 💰 Campo monto si es parcial
              if (_tipoSeleccionado == "PAGO_PARCIAL")
                TextField(
                  controller: _montoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Monto a pagar (S/)",
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 💬 Mensaje opcional
              TextField(
                controller: _mensajeCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Mensaje (opcional)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 📷 Subida de comprobante
              if (_tipoSeleccionado != "NO_PAGAR")
                _imagenComprobante == null
                    ? OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.blue.shade600,
                            width: 1.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _seleccionarImagen,
                        icon: const Icon(
                          Icons.upload_rounded,
                          color: Color(0xFF1565C0),
                        ),
                        label: const Text(
                          "Subir comprobante de pago",
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _imagenComprobante!,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: _seleccionarImagen,
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Color(0xFF1565C0),
                            ),
                            label: const Text(
                              "Cambiar imagen",
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

              const SizedBox(height: 35),

              // 🚀 Botón enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: const Color(0xFF1565C0),
                    elevation: 4,
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                  ),
                  icon: _enviando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: _enviando ? null : _enviarPago,
                  label: const Text(
                    "Enviar solicitud",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
