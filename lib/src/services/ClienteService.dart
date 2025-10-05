import 'dart:convert';
import 'package:crediahorro/src/services/AuthInterceptor.dart';
import 'package:http/http.dart' as http;
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';

class ClienteService {
  final String baseUrl =
      //"https://gateway-production-7c45.up.railway.app/admin-service/clientes";
      "http://localhost:4040/admin-service/clientes";
  //"https://gateway-production-e6b2.up.railway.app/admin-service/clientes";

  final http.Client _client = AuthInterceptor(http.Client());

  Future<List<Cliente>> getClientes() async {
    final response = await _client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception("Error cargando clientes: ${response.statusCode}");
    }
  }

  Future<Cliente> crearCliente(Cliente cliente) async {
    final response = await _client.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error creando cliente: ${response.statusCode}");
    }
  }

  Future<Cliente> getClienteById(int id) async {
    final response = await _client.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error obteniendo cliente: ${response.statusCode}");
    }
  }

  Future<Cliente> updateCliente(int id, Cliente cliente) async {
    final response = await _client.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error actualizando cliente: ${response.statusCode}");
    }
  }

  Future<void> eliminarCliente(int id) async {
    final response = await _client.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error eliminando cliente: ${response.statusCode}");
    }
  }
}
