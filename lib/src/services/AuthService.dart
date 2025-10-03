import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String
  _baseUrl = //conecta con los microservicios mediante un api
      //'https://gateway-production-7c45.up.railway.app/auth-service/auth'; //railway/path/controller
      'http://localhost:4040/auth-service/auth';

  // LOGINaccestoken mediante el auth interceptor
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['accessToken'];

      if (token == null) {
        throw Exception("Token no recibido: ${response.body}");
      }

      // 🔑 Decodificar el JWT y obtener el role
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final role = decodedToken["role"] ?? "";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token);
      await prefs.setString('role', role); // guardamos el role
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // REGISTER
  Future<void> register(
    String username,
    String password,
    String whatsapp,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'whatsapp': whatsapp,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // VALIDAR TOKEN
  Future<bool> validateToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/jwt'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }

  // OBTENER TOKEN
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // LOGOUT
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
  }
}
