import 'package:iaso/l10n/l10n.dart';

class ApiError implements Exception {
  final String code;
  final int statusCode;
  final Map<String, List<String>>? validationErrors;

  ApiError({
    required this.code,
    required this.statusCode,
    this.validationErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json, int statusCode) {
    return ApiError(
      code: json['code'] as String? ?? 'unknown_error',
      statusCode: statusCode,
      validationErrors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map((key, value) => MapEntry(
                    key,
                    (value as List).map((e) => e.toString()).toList(),
                  )),
            )
          : null,
    );
  }

  String getTranslatedMessage(AppLocalizations l10n) {
    return l10n.translate(code);
  }

  String? getValidationError(String field) {
    if (validationErrors == null || !validationErrors!.containsKey(field)) {
      return null;
    }
    return validationErrors![field]!.first;
  }

  List<String> getAllValidationErrors() {
    if (validationErrors == null) {
      return [];
    }
    return validationErrors!.values.expand((list) => list).toList();
  }

  String getFirstValidationError(AppLocalizations l10n) {
    if (validationErrors == null || validationErrors!.isEmpty) {
      return getTranslatedMessage(l10n);
    }
    return validationErrors!.values.first.first;
  }
}
