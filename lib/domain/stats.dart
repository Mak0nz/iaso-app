import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (bpMorningSYS != null) data['bpMorningSYS'] = bpMorningSYS;
    if (bpMorningDIA != null) data['bpMorningDIA'] = bpMorningDIA;
    if (bpMorningPulse != null) data['bpMorningPulse'] = bpMorningPulse;
    if (weight != null) data['weight'] = weight;
    if (temp != null) data['temp'] = temp;
    if (nightTemp != null) data['nightTemp'] = nightTemp;
    if (bpNightSYS != null) data['bpNightSYS'] = bpNightSYS;
    if (bpNightDIA != null) data['bpNightDIA'] = bpNightDIA;
    if (bpNightPulse != null) data['bpNightPulse'] = bpNightPulse;
    if (bloodSugar != null && bloodSugar!.isNotEmpty) {
      data['bloodSugar'] = bloodSugar;
    }
    if (urine != null && urine!.isNotEmpty) data['urine'] = urine;
    data['dateField'] = dateField;
    return data;
  }

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      bpMorningSYS: json['bpMorningSYS'],
      bpMorningDIA: json['bpMorningDIA'],
      bpMorningPulse: json['bpMorningPulse'],
      weight: json['weight'],
      temp: json['temp'],
      nightTemp: json['nightTemp'],
      bpNightSYS: json['bpNightSYS'],
      bpNightDIA: json['bpNightDIA'],
      bpNightPulse: json['bpNightPulse'],
      bloodSugar: json['bloodSugar'] != null
          ? List<double>.from(json['bloodSugar'])
          : null,
      urine: json['urine'] != null ? List<double>.from(json['urine']) : null,
      dateField: (json['dateField'] as Timestamp).toDate(),
    );
  }
}
