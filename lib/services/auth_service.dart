import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl = 'http://localhost:8080';

  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/usuarios/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      try {

        final body = jsonDecode(response.body);

        throw Exception(
          body['erro'] ?? 'Erro ao realizar login',
        );

      } catch (e) {

        throw Exception(
          'Erro ao conectar na API: $e',
        );
      }
    }
  }
}