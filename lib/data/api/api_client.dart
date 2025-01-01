import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iaso/domain/language.dart';
import 'package:iaso/data/api/api_error.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;

  ApiClient({required this.baseUrl});

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders(Language language) {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': language.code,
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
    Language language,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(language),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiError.fromJson(
        jsonDecode(response.body),
        response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint,
    Language language,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(language),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiError.fromJson(
        jsonDecode(response.body),
        response.statusCode,
      );
    }
  }
}
