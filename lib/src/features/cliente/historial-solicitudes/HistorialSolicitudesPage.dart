import 'package:flutter/material.dart';
import 'package:crediahorro/src/services/SolicitudesPagoClienteService.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';
import 'package:intl/intl.dart';

class HistorialSolicitudesPage extends StatefulWidget {
  const HistorialSolicitudesPage({super.key});

  @override
  State<HistorialSolicitudesPage> createState() =>
      _HistorialSolicitudesPageState();
}

class _HistorialSolicitudesPageState extends State<HistorialSolicitudesPage> {
  late Future<List<dynamic>> _futureSolicitudes;

  @override
  void initState() {
    super.initState();
    _futureSolicitudes = SolicitudesPagoClienteService().listarMisSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldUsuario(
      title: "CREDIAHORRO",
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FB), Color(0xFFEFF3F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<dynamic>>(
          future: _futureSolicitudes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No tienes solicitudes registradas.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            final solicitudes = snapshot.data!;
            return ListView.builder(
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final s = solicitudes[index];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: 1,
                  child: _buildSolicitudCard(context, s),
                );
              },
            );
          },
        ),
      ),
      initialIndex: 2,
    );
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

  Widget _buildSolicitudCard(BuildContext context, dynamic s) {
    final estado = s['estado'] ?? "PENDIENTE";
    final estadoColor = {
      "PENDIENTE": Colors.orange,
      "ACEPTADO": Colors.green,
      "RECHAZADO": Colors.redAccent,
    }[estado]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: estadoColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                estado,
                style: TextStyle(
                  color: estadoColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s['tipoSolicitud'] ?? "Solicitud desconocida",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (s['montoParcial'] != null)
                  _infoRow(
                    "Monto parcial",
                    "S/ ${s['montoParcial']}",
                    icon: Icons.attach_money_rounded,
                  ),
                _infoRow(
                  "Fecha solicitud",
                  _formatearFecha(s['fechaSolicitud']),
                  icon: Icons.calendar_month,
                ),
                if (s['fechaRespuesta'] != null)
                  _infoRow(
                    "Fecha respuesta",
                    _formatearFecha(s['fechaRespuesta']),
                    icon: Icons.mark_email_read,
                  ),

                if (s['mensajeCliente'] != null &&
                    s['mensajeCliente'].toString().isNotEmpty)
                  _infoRow(
                    "Mensaje del cliente",
                    s['mensajeCliente'],
                    icon: Icons.chat_bubble_outline,
                  ),

                if (s['mensajeAdministrador'] != null &&
                    s['mensajeAdministrador'].toString().isNotEmpty)
                  _infoRow(
                    "Respuesta del administrador",
                    s['mensajeAdministrador'],
                    icon: Icons.support_agent,
                  ),

                const SizedBox(height: 10),

                if (s['comprobante'] != null)
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blueAccent.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.blueAccent,
                      ),
                      label: const Text(
                        "Ver comprobante",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => _verComprobante(
                        context,
                        "https://gateway-production-e6b2.up.railway.app/admin-service/comprobantes/${s['id']}",
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 2),
              child: Icon(icon, color: Colors.grey.shade600, size: 18),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verComprobante(BuildContext context, String url) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        return FadeTransition(
          opacity: animation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔹 Fondo translúcido con desenfoque
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),

              // 🔹 Tarjeta flotante con efecto glass
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: Dialog(
                  elevation: 10,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  backgroundColor: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🔹 Encabezado elegante
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image_rounded,
                              color: Colors.blueAccent,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Comprobante de Pago",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Imagen con borde y sombra
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent.withOpacity(0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.network(
                              url,
                              height: 320,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => const Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No se pudo cargar la imagen",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Botones inferiores
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.withOpacity(
                                  0.9,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Descargar",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                // Aquí puedes agregar lógica de descarga si la tienes
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Descarga iniciada..."),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                );
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.withOpacity(
                                  0.9,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Cerrar",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
