import 'package:flutter/material.dart';
import 'package:crediahorro/src/services/SolicitudPagoService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/constants/app_colors.dart';

class SolicitudesPagoAdminPage extends StatefulWidget {
  const SolicitudesPagoAdminPage({super.key});

  @override
  State<SolicitudesPagoAdminPage> createState() =>
      _SolicitudesPagoAdminPageState();
}

class _SolicitudesPagoAdminPageState extends State<SolicitudesPagoAdminPage> {
  final _service = SolicitudPagoService();
  bool _cargando = true;
  List<dynamic> _solicitudes = [];

  @override
  void initState() {
    super.initState();
    _cargarSolicitudes();
  }

  Future<void> _cargarSolicitudes() async {
    try {
      final data = await _service.listarPendientes();
      setState(() {
        _solicitudes = data;
        _cargando = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => _cargando = false);
    }
  }

  Future<void> _verComprobante(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el comprobante.")),
      );
    }
  }

  Future<void> _responderSolicitud(int id, bool aceptar) async {
    final mensajeCtrl = TextEditingController();

    if (!aceptar) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(Icons.cancel_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                "Rechazar Solicitud",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Por favor, indica el motivo del rechazo:",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mensajeCtrl,
                decoration: InputDecoration(
                  hintText: "Escribe aquí el motivo...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              label: const Text("Cancelar"),
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.thumb_down_alt_rounded,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _service.responderSolicitud(
                  id,
                  aceptar: false,
                  mensajeAdmin: mensajeCtrl.text,
                );
                _cargarSolicitudes();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Solicitud rechazada correctamente"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              label: const Text(
                "Rechazar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      await _service.responderSolicitud(id, aceptar: true);
      _cargarSolicitudes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Solicitud aprobada correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Solicitudes de Pago",
      initialIndex: 2,
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _solicitudes.isEmpty
          ? const Center(
              child: Text(
                "No hay solicitudes pendientes 💤",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargarSolicitudes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _solicitudes.length,
                itemBuilder: (context, i) {
                  final s = _solicitudes[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.request_page_outlined,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Solicitud #${s['id']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _infoRow("Cliente", s['clienteNombre']),
                          _infoRow("Tipo de solicitud", s['tipoSolicitud']),
                          if (s['tipoSolicitud'] == 'PAGO_PARCIAL')
                            _infoRow(
                              "Monto parcial ingresado",
                              "S/ ${s['montoParcial'] ?? '-'}",
                            ),

                          _infoRow(
                            "Monto cuota",
                            "S/ ${s['montoCuota'] ?? '-'}",
                          ),
                          _infoRow("Fecha pago", s['fechaPago'] ?? "-"),
                          const SizedBox(height: 8),
                          Text(
                            "Mensaje del cliente:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            s['mensajeCliente'] ?? '-',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 12),

                          // Comprobante
                          if (s['comprobanteUrl'] != null)
                            GestureDetector(
                              onTap: () => _verComprobante(s['comprobanteUrl']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.receipt_long,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Ver Comprobante",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 18),

                          // Botones de acción
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      158,
                                      247,
                                      161,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _responderSolicitud(s['id'], true),
                                  icon: const Icon(Icons.check),
                                  label: const Text("Aprobar"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      240,
                                      151,
                                      151,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _responderSolicitud(s['id'], false),
                                  icon: const Icon(Icons.close),
                                  label: const Text("Rechazar"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
