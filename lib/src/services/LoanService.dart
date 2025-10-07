import 'dart:convert';
import 'package:crediahorro/src/features/admin/loans/models/loans.dart';
import 'package:crediahorro/src/services/AuthInterceptor.dart';
import 'package:http/http.dart' as http;

class LoanService {
  final String baseUrl =
      //"https://gateway-production-7c45.up.railway.app/admin-service/prestamos";
      //"http://localhost:4040/admin-service/prestamos";
      "https://gateway-production-e6b2.up.railway.app/admin-service/prestamos";

  final http.Client _client = AuthInterceptor(http.Client());

  // 👇 MÉTODO NUEVO: obtener todos los préstamos
  Future<List<dynamic>> obtenerTodosLosPrestamos() async {
    final response = await _client.get(Uri.parse("$baseUrl/all"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Error al obtener préstamos (admin): ${response.statusCode}",
      );
    }
  }

  Future<Prestamo> getPrestamoById(int id) async {
    final response = await _client.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return Prestamo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al obtener préstamo: ${response.statusCode}");
    }
  }

  Future<void> crearPrestamo(int clienteId, Prestamo prestamo) async {
    final response = await _client.post(
      Uri.parse("$baseUrl/cliente/$clienteId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(prestamo.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear préstamo: ${response.statusCode}");
    }
  }

  Future<void> actualizarPrestamo(int id, Prestamo prestamo) async {
    final response = await _client.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(prestamo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Error al actualizar préstamo: ${response.statusCode}");
    }
  }
}
