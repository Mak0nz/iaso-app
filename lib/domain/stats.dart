class Stats {
  final int? bpMorningSYS;
  final int? bpMorningDIA;
  final int? bpMorningPulse;
  final double? weight;
  final double? temp;
  final double? nightTemp;
  final int? bpNightSYS;
  final int? bpNightDIA;
  final int? bpNightPulse;
  final List<double>? bloodSugar;
  final List<double>? urine;
  final DateTime dateField;

  Stats({
    this.bpMorningSYS,
    this.bpMorningDIA,
    this.bpMorningPulse,
    this.weight,
    this.temp,
    this.nightTemp,
    this.bpNightSYS,
    this.bpNightDIA,
    this.bpNightPulse,
    this.bloodSugar,
    this.urine,
    required this.dateField,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (bpMorningSYS != null) data['bp_morning_sys'] = bpMorningSYS;
    if (bpMorningDIA != null) data['bp_morning_dia'] = bpMorningDIA;
    if (bpMorningPulse != null) data['bp_morning_pulse'] = bpMorningPulse;
    if (weight != null) data['weight'] = weight;
    if (temp != null) data['temp'] = temp;
    if (nightTemp != null) data['night_temp'] = nightTemp;
    if (bpNightSYS != null) data['bp_night_sys'] = bpNightSYS;
    if (bpNightDIA != null) data['bp_night_dia'] = bpNightDIA;
    if (bpNightPulse != null) data['bp_night_pulse'] = bpNightPulse;
    if (bloodSugar != null && bloodSugar!.isNotEmpty) {
      data['blood_sugar'] = bloodSugar;
    }
    if (urine != null && urine!.isNotEmpty) data['urine'] = urine;
    data['date_field'] = dateField.toIso8601String();
    return data;
  }

  factory Stats.fromJson(Map<String, dynamic> json) {
    List<double>? parseDoubleList(dynamic value) {
      if (value == null) return null;
      return (value as List).map((e) => (e as num).toDouble()).toList();
    }

    return Stats(
      bpMorningSYS: json['bp_morning_sys'],
      bpMorningDIA: json['bp_morning_dia'],
      bpMorningPulse: json['bp_morning_pulse'],
      weight: json['weight']?.toDouble(),
      temp: json['temp']?.toDouble(),
      nightTemp: json['night_temp']?.toDouble(),
      bpNightSYS: json['bp_night_sys'],
      bpNightDIA: json['bp_night_dia'],
      bpNightPulse: json['bp_night_pulse'],
      bloodSugar: parseDoubleList(json['blood_sugar']),
      urine: parseDoubleList(json['urine']),
      dateField: DateTime.parse(json['date_field']),
    );
  }

  Stats copyWith({
    int? bpMorningSYS,
    int? bpMorningDIA,
    int? bpMorningPulse,
    double? weight,
    double? temp,
    double? nightTemp,
    int? bpNightSYS,
    int? bpNightDIA,
    int? bpNightPulse,
    List<double>? bloodSugar,
    List<double>? urine,
    DateTime? dateField,
  }) {
    return Stats(
      bpMorningSYS: bpMorningSYS ?? this.bpMorningSYS,
      bpMorningDIA: bpMorningDIA ?? this.bpMorningDIA,
      bpMorningPulse: bpMorningPulse ?? this.bpMorningPulse,
      weight: weight ?? this.weight,
      temp: temp ?? this.temp,
      nightTemp: nightTemp ?? this.nightTemp,
      bpNightSYS: bpNightSYS ?? this.bpNightSYS,
      bpNightDIA: bpNightDIA ?? this.bpNightDIA,
      bpNightPulse: bpNightPulse ?? this.bpNightPulse,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      urine: urine ?? this.urine,
      dateField: dateField ?? this.dateField,
    );
  }
}
