import 'dart:convert';
import 'package:crediahorro/src/features/admin/cuotas/models/cuota.dart';
import 'package:crediahorro/src/services/AuthInterceptor.dart';
import 'package:http/http.dart' as http;

class CuotaService {
  final String baseUrl =
      //"https://gateway-production-7c45.up.railway.app/admin-service/cuotas";
      //"http://localhost:4040/admin-service/cuotas";
      "https://gateway-production-e6b2.up.railway.app/admin-service/cuotas";

  final http.Client _client = AuthInterceptor(http.Client());

  Future<PrestamoCuotasResponse> getCuotasByPrestamo(int prestamoId) async {
    final response = await _client.get(
      Uri.parse("$baseUrl/prestamo/$prestamoId"),
    );
    if (response.statusCode == 200) {
      return PrestamoCuotasResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al obtener cuotas");
    }
  }

  Future<void> pagarCuota(int cuotaId) async {
    final res = await _client.post(Uri.parse("$baseUrl/$cuotaId/pagar"));
    if (res.statusCode != 200) throw Exception("Error al pagar cuota");
  }

  Future<void> marcarCuotaNoPagada(int cuotaId) async {
    final res = await _client.post(Uri.parse("$baseUrl/$cuotaId/no-pagar"));
    if (res.statusCode != 200) throw Exception("Error al marcar no pagada");
  }

  Future<void> pagarCuotaParcial(int cuotaId, double monto) async {
    final res = await _client.post(
      Uri.parse("$baseUrl/$cuotaId/pago-parcial?monto=$monto"),
    );
    if (res.statusCode != 200) throw Exception("Error al pagar parcial");
  }
}
