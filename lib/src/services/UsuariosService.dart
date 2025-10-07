import 'dart:convert';
import 'dart:io';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/services/AuthInterceptor.dart';
import 'package:crediahorro/src/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsuariosService {
  final String baseUrl = //"http://localhost:4040/admin-service/usuarios";
      "https://gateway-production-e6b2.up.railway.app/admin-service/usuarios";
  final http.Client _client = AuthInterceptor(http.Client());

  /// Obtener préstamos del cliente autenticado
  Future<List<Prestamo>> getMisPrestamos() async {
    final response = await _client.get(Uri.parse("$baseUrl/mis-prestamos"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Prestamo.fromJson(e)).toList();
    } else {
      throw Exception("Error cargando préstamos: ${response.statusCode}");
    }
  }

  Future<List<Cuota>> getMisCuotas(int prestamoId) async {
    final response = await _client.get(
      Uri.parse("$baseUrl/mis-cuotas/$prestamoId"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Cuota.fromJson(e)).toList();
    } else {
      throw Exception("Error cargando cuotas: ${response.statusCode}");
    }
  }

  Future<Map<String, int>> contarPrestamosPorEstado() async {
    final response = await _client.get(Uri.parse("$baseUrl/mis-prestamos"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      int pagados = 0;
      int activos = 0;

      for (var e in data) {
        final estado = (e['estado'] ?? '').toString().toUpperCase();
        if (estado == 'PAGADO') pagados++;
        if (estado == 'ACTIVO') activos++;
      }

      return {"pagados": pagados, "activos": activos};
    } else {
      throw Exception("Error al contar préstamos: ${response.statusCode}");
    }
  }

  Future<void> enviarPagoCuota(
    int cuotaId,
    String tipoSolicitud,
    String mensajeCliente,
    File? comprobante, {
    double? montoParcial,
  }) async {
    final uri = Uri.parse(
      //"http://localhost:4040/admin-service/usuarios-solicitudes-pago/$cuotaId/enviar",
      "https://gateway-production-e6b2.up.railway.app/admin-service/usuarios-solicitudes-pago/$cuotaId/enviar",
    );

    var request = http.MultipartRequest('POST', uri);
    request.fields['tipoSolicitud'] = tipoSolicitud;
    request.fields['mensajeCliente'] = mensajeCliente;

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

    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception("Error al enviar pago (${response.statusCode}): $body");
    }
  }
}
