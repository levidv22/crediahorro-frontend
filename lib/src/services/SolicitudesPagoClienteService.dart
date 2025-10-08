import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:crediahorro/src/services/AuthService.dart';

class SolicitudesPagoClienteService {
  final String baseUrl =
      "https://gateway-production-e6b2.up.railway.app/admin-service/usuarios-solicitudes-pago";

  // 🔹 Enviar comprobante de pago
  Future<void> enviarPagoCuota(
    int cuotaId,
    String tipoSolicitud,
    String mensajeCliente,
    File? comprobante, {
    double? montoParcial,
  }) async {
    final uri = Uri.parse("$baseUrl/$cuotaId/enviar");

    var request = http.MultipartRequest('POST', uri);
    request.fields['tipoSolicitud'] = tipoSolicitud;

    if (mensajeCliente.isNotEmpty) {
      request.fields['mensajeCliente'] = mensajeCliente;
    }

    if (montoParcial != null) {
      request.fields['montoParcial'] = montoParcial.toString();
    }

    if (comprobante != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'comprobante',
          comprobante.path,
          filename: basename(comprobante.path),
        ),
      );
    }

    final token = await AuthService().getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    final response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Pago enviado correctamente");
    } else {
      final body = await response.stream.bytesToString();
      print("❌ Error (${response.statusCode}): $body");
      throw Exception("Error al enviar pago: $body");
    }
  }

  // 🔹 Listar solicitudes del cliente
  Future<List<dynamic>> listarMisSolicitudes() async {
    final uri = Uri.parse("$baseUrl/mis-solicitudes");
    final token = await AuthService().getToken();

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener solicitudes: ${response.statusCode}");
    }
  }
}
