import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';

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

  Future<void> _enviarPago() async {
    if (_tipoSeleccionado != "NO_PAGAR" && _imagenComprobante == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, sube tu comprobante de pago")),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      await UsuariosService().enviarPagoCuota(
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
      title: "Pago de Cuota",
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Card de información del pago
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: Colors.lightBlue.shade200,
                    width: 1.5,
                  ),
                ),
                elevation: 6,
                shadowColor: Colors.cyan.shade100,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // 🔹 Centra horizontalmente
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // 🔹 Centra el icono y el título
                        children: const [
                          Icon(Icons.receipt_long, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text(
                            "Detalles de la Cuota",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "💰 Monto a pagar: S/ ${cuota.montoCuota}",
                        textAlign: TextAlign.center, // 🔹 Centra el texto
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "📅 Fecha límite: ${cuota.fechaPago}",
                        textAlign: TextAlign.center, // 🔹 Centra el texto
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 💳 Card QR y número Yape
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: Colors.lightBlue.shade200,
                      width: 1.5,
                    ),
                  ),
                  color: Colors.blue.shade50,
                  elevation: 6,
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // 🔹 Ajusta el tamaño al contenido
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // 🔹 Centra el contenido interno
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/img/qr_yape.jpeg",
                            height:
                                260, // 📸 Imagen un poco más grande para destacar
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "Número Yape",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 17,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "928 581 983",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ⚙️ Tipo de pago
              const Text(
                "Tipo de pago",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.lightBlue.shade200,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
              ),
              const SizedBox(height: 20),

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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(
                            color: Colors.blue.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _seleccionarImagen,
                        icon: const Icon(
                          Icons.upload_rounded,
                          color: Colors.blueAccent,
                        ),
                        label: const Text(
                          "Subir comprobante de pago",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _imagenComprobante!,
                              height: 240, // 📸 Imagen más grande
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _seleccionarImagen,
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.blueAccent,
                            ),
                            label: const Text(
                              "Cambiar imagen",
                              style: TextStyle(color: Colors.blueAccent),
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
                    backgroundColor: Colors.blueAccent.shade700,
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
