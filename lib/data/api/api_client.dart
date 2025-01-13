import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iaso/data/api/api_error.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;
  final String languageCode;

  ApiClient({
    required this.baseUrl,
    required this.languageCode,
  });

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': languageCode,
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
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
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
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

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
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

  Future<Map<String, dynamic>> delete(
    String endpoint,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
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
