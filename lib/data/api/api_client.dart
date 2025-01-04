import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/l10n/l10n.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;

  ApiClient({required this.baseUrl});

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders(String languageCode) {
    // Validate the language code and fallback to 'en' if not supported
    final validLanguageCode =
        L10n.isSupported(languageCode) ? languageCode : 'en';

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': validLanguageCode,
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
    String languageCode,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(languageCode),
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
    String languageCode,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(languageCode),
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
