import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Para emulador Android: use 'http://10.0.2.2:3000'
  // Para dispositivo físico: use 'http://192.168.1.101:3000' (seu IP atual)
  // Para iOS Simulator/Chrome: use 'http://localhost:3000'
  static const String baseUrl =
      'http://192.168.1.101:3000'; // Dispositivo físico
  // static const String baseUrl = 'http://localhost:3000'; // Chrome/Web
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Emulador Android
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> pushRecords(
      List<Map<String, dynamic>> records) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sync/push'),
      headers: _headers,
      body: jsonEncode({'records': records}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer push: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> pullRecords(String since) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sync/pull?since=$since'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer pull: ${response.body}');
    }
  }
}
