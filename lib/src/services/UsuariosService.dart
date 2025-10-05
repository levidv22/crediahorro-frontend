import 'dart:convert';
import 'package:crediahorro/src/features/cliente/dashboard/models/prestamos.dart';
import 'package:crediahorro/src/services/AuthInterceptor.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  final String baseUrl = "http://localhost:4040/admin-service/usuarios";
  //"https://gateway-production-e6b2.up.railway.app/admin-service/usuarios";
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
}
