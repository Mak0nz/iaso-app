import 'package:iaso/domain/medication_info.dart';

class UserMedication {
  final String? id;
  final int medicationId;
  final MedicationInfo medicationInfo;
  final double takeQuantityPerDay;
  final bool takeMonday;
  final bool takeTuesday;
  final bool takeWednesday;
  final bool takeThursday;
  final bool takeFriday;
  final bool takeSaturday;
  final bool takeSunday;
  final bool isAlternatingSchedule;
  final double currentQuantity;
  final String? orderedBy;
  final bool isInCloud;
  final double totalDoses;
  final DateTime lastUpdatedDate;
  final DateTime? runOutDate;

  UserMedication({
    this.id,
    required this.medicationId,
    required this.medicationInfo,
    required this.takeQuantityPerDay,
    required this.takeMonday,
    required this.takeTuesday,
    required this.takeWednesday,
    required this.takeThursday,
    required this.takeFriday,
    required this.takeSaturday,
    required this.takeSunday,
    this.isAlternatingSchedule = false,
    required this.currentQuantity,
    this.orderedBy,
    required this.isInCloud,
    required this.totalDoses,
    required this.lastUpdatedDate,
    this.runOutDate,
  });

  factory UserMedication.fromJson(Map<String, dynamic> json) {
    return UserMedication(
      id: json['id']?.toString(),
      medicationId: json['medication_id'],
      medicationInfo: MedicationInfo.fromJson(json['medication']),
      takeQuantityPerDay: (json['take_quantity_per_day'] as num).toDouble(),
      takeMonday: json['take_monday'] ?? true,
      takeTuesday: json['take_tuesday'] ?? true,
      takeWednesday: json['take_wednesday'] ?? true,
      takeThursday: json['take_thursday'] ?? true,
      takeFriday: json['take_friday'] ?? true,
      takeSaturday: json['take_saturday'] ?? true,
      takeSunday: json['take_sunday'] ?? true,
      isAlternatingSchedule: json['is_alternating_schedule'] ?? false,
      currentQuantity: (json['current_quantity'] as num).toDouble(),
      orderedBy: json['ordered_by'],
      isInCloud: json['is_in_cloud'] ?? true,
      totalDoses: (json['total_doses'] as num).toDouble(),
      lastUpdatedDate: DateTime.parse(json['last_updated_date']),
      runOutDate: json['run_out_date'] != null
          ? DateTime.parse(json['run_out_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'medication_id': medicationId,
      'medication': medicationInfo.toJson(),
      'take_quantity_per_day': takeQuantityPerDay,
      'take_monday': takeMonday,
      'take_tuesday': takeTuesday,
      'take_wednesday': takeWednesday,
      'take_thursday': takeThursday,
      'take_friday': takeFriday,
      'take_saturday': takeSaturday,
      'take_sunday': takeSunday,
      'is_alternating_schedule': isAlternatingSchedule,
      'current_quantity': currentQuantity,
      'ordered_by': orderedBy,
      'is_in_cloud': isInCloud,
      'total_doses': totalDoses,
      'last_updated_date': lastUpdatedDate.toIso8601String(),
      if (runOutDate != null) 'run_out_date': runOutDate!.toIso8601String(),
    };
  }

  UserMedication copyWith({
    String? id,
    int? medicationId,
    MedicationInfo? medicationInfo,
    double? takeQuantityPerDay,
    bool? takeMonday,
    bool? takeTuesday,
    bool? takeWednesday,
    bool? takeThursday,
    bool? takeFriday,
    bool? takeSaturday,
    bool? takeSunday,
    bool? isAlternatingSchedule,
    double? currentQuantity,
    String? orderedBy,
    bool? isInCloud,
    double? totalDoses,
    DateTime? lastUpdatedDate,
    DateTime? runOutDate,
  }) {
    return UserMedication(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationInfo: medicationInfo ?? this.medicationInfo,
      takeQuantityPerDay: takeQuantityPerDay ?? this.takeQuantityPerDay,
      takeMonday: takeMonday ?? this.takeMonday,
      takeTuesday: takeTuesday ?? this.takeTuesday,
      takeWednesday: takeWednesday ?? this.takeWednesday,
      takeThursday: takeThursday ?? this.takeThursday,
      takeFriday: takeFriday ?? this.takeFriday,
      takeSaturday: takeSaturday ?? this.takeSaturday,
      takeSunday: takeSunday ?? this.takeSunday,
      isAlternatingSchedule:
          isAlternatingSchedule ?? this.isAlternatingSchedule,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      orderedBy: orderedBy ?? this.orderedBy,
      isInCloud: isInCloud ?? this.isInCloud,
      totalDoses: totalDoses ?? this.totalDoses,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      runOutDate: runOutDate ?? this.runOutDate,
    );
  }
}
