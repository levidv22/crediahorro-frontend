import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crediahorro/src/services/AuthService.dart';

class SolicitudPagoAdminService {
  final String baseUrl =
      //"http://localhost:4040/admin-service/admin-solicitudes-pago";
      "https://gateway-production-e6b2.up.railway.app/admin-service/admin-solicitudes-pago";

  Future<List<dynamic>> listarPendientes() async {
    final uri = Uri.parse("$baseUrl/pendientes");
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

  Future<void> responderSolicitud(
    int id, {
    required bool aceptar,
    String? mensajeAdmin,
  }) async {
    final uri = Uri.parse("$baseUrl/$id/responder");
    final token = await AuthService().getToken();

    final response = await http.post(
      uri.replace(
        queryParameters: {
          "aceptar": aceptar.toString(),
          if (mensajeAdmin != null) "mensajeAdmin": mensajeAdmin,
        },
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception("Error al procesar solicitud: ${response.statusCode}");
    }
  }
}
