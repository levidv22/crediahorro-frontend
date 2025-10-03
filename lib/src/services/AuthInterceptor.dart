import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//envia token
class AuthInterceptor extends http.BaseClient {
  final http.Client _client;

  AuthInterceptor(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _client.send(request);
  }
}
