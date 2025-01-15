class MedicationInfo {
  final int id;
  final String? originalId; // OpenFDA ID
  final String? uniqueKey;
  final Map<String, String> names;
  final Map<String, String>? replacementNames;
  final Map<String, String>? activeAgents;
  final Map<String, String>? useCases;
  final Map<String, String>? sideEffects;
  final bool isVerified;
  final int usageCount;

  MedicationInfo({
    required this.id,
    this.originalId,
    this.uniqueKey,
    required this.names,
    this.replacementNames,
    this.activeAgents,
    this.useCases,
    this.sideEffects,
    required this.isVerified,
    required this.usageCount,
  });

  factory MedicationInfo.fromJson(Map<String, dynamic> json) {
    return MedicationInfo(
      id: json['id'],
      originalId: json['original_id'],
      uniqueKey: json['unique_key'],
      names: Map<String, String>.from(json['names']),
      replacementNames: json['replacement_names'] != null
          ? Map<String, String>.from(json['replacement_names'])
          : null,
      activeAgents: json['active_agents'] != null
          ? Map<String, String>.from(json['active_agents'])
          : null,
      useCases: json['use_cases'] != null
          ? Map<String, String>.from(json['use_cases'])
          : null,
      sideEffects: json['side_effects'] != null
          ? Map<String, String>.from(json['side_effects'])
          : null,
      isVerified: json['is_verified'] ?? false,
      usageCount: json['usage_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_id': originalId,
      'unique_key': uniqueKey,
      'names': names,
      'replacement_names': replacementNames,
      'active_agents': activeAgents,
      'use_cases': useCases,
      'side_effects': sideEffects,
      'is_verified': isVerified,
      'usage_count': usageCount,
    };
  }

  String getLocalizedName(String languageCode) {
    return names[languageCode] ?? names['en'] ?? names.values.first;
  }

  String? getLocalizedActiveAgent(String languageCode) {
    if (activeAgents == null) return null;
    return activeAgents![languageCode] ??
        activeAgents!['en'] ??
        activeAgents!.values.first;
  }

  String? getLocalizedUseCase(String languageCode) {
    if (useCases == null) return null;
    return useCases![languageCode] ?? useCases!['en'] ?? useCases!.values.first;
  }

  String? getLocalizedSideEffect(String languageCode) {
    if (sideEffects == null) return null;
    return sideEffects![languageCode] ??
        sideEffects!['en'] ??
        sideEffects!.values.first;
  }

  String? getLocalizedReplacement(String languageCode) {
    if (replacementNames == null) return null;
    return replacementNames![languageCode] ??
        replacementNames!['en'] ??
        replacementNames!.values.first;
  }
}
