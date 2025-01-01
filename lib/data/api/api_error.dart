class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;

  ApiError({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json, int statusCode) {
    if (json.containsKey('errors') && json['errors'] is Map) {
      return ApiError(
        message: json['message'] ?? 'Validation failed',
        statusCode: statusCode,
        validationErrors: Map<String, List<String>>.from(
          json['errors'].map((key, value) => MapEntry(
                key,
                (value as List).map((e) => e.toString()).toList(),
              )),
        ),
      );
    }

    return ApiError(
      message: json['message'] ?? 'Unknown error occurred',
      statusCode: statusCode,
    );
  }

  String getFirstError() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      final firstError = validationErrors!.values.first;
      if (firstError.isNotEmpty) {
        return firstError.first;
      }
    }
    return message;
  }
}
