import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  final int? bpMorningSYS;
  final int? bpMorningDIA;
  final int? bpMorningPulse;
  final double? weight;
  final double? temp;
  final int? bpNightSYS;
  final int? bpNightDIA;
  final int? bpNightPulse;
  final List<double>? bloodSugar;
  final DateTime dateField;

  Stats({
    this.bpMorningSYS,
    this.bpMorningDIA,
    this.bpMorningPulse,
    this.weight,
    this.temp,
    this.bpNightSYS,
    this.bpNightDIA,
    this.bpNightPulse,
    this.bloodSugar,
    required this.dateField,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (bpMorningSYS != null) data['bpMorningSYS'] = bpMorningSYS;
    if (bpMorningDIA != null) data['bpMorningDIA'] = bpMorningDIA;
    if (bpMorningPulse != null) data['bpMorningPulse'] = bpMorningPulse;
    if (weight != null) data['weight'] = weight;
    if (temp != null) data['temp'] = temp;
    if (bpNightSYS != null) data['bpNightSYS'] = bpNightSYS;
    if (bpNightDIA != null) data['bpNightDIA'] = bpNightDIA;
    if (bpNightPulse != null) data['bpNightPulse'] = bpNightPulse;
    if (bloodSugar != null && bloodSugar!.isNotEmpty) data['bloodSugar'] = bloodSugar;
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
      bpNightSYS: json['bpNightSYS'],
      bpNightDIA: json['bpNightDIA'],
      bpNightPulse: json['bpNightPulse'],
      bloodSugar: json['bloodSugar'] != null ? List<double>.from(json['bloodSugar']) : null,
      dateField: (json['dateField'] as Timestamp).toDate(),
    );
  }
}