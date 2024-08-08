import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  final String? id;
  final String name;
  final String? nameReplacement;
  final String? activeAgent;
  final String? useCase;
  final String? sideEffect;
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

  Medication({
    this.id,
    required this.name,
    this.nameReplacement,
    this.activeAgent,
    this.useCase,
    this.sideEffect,
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
  });

  Medication copyWith({
    String? id,
    String? name,
    String? nameReplacement,
    String? activeAgent,
    String? useCase,
    String? sideEffect,
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
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      nameReplacement: nameReplacement ?? this.nameReplacement,
      activeAgent: activeAgent ?? this.activeAgent,
      useCase: useCase ?? this.useCase,
      sideEffect: sideEffect ?? this.sideEffect,
      takeQuantityPerDay: takeQuantityPerDay ?? this.takeQuantityPerDay,
      takeMonday: takeMonday ?? this.takeMonday,
      takeTuesday: takeTuesday ?? this.takeTuesday,
      takeWednesday: takeWednesday ?? this.takeWednesday,
      takeThursday: takeThursday ?? this.takeThursday,
      takeFriday: takeFriday ?? this.takeFriday,
      takeSaturday: takeSaturday ?? this.takeSaturday,
      takeSunday: takeSunday ?? this.takeSunday,
      isAlternatingSchedule: isAlternatingSchedule ?? this.isAlternatingSchedule,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      orderedBy: orderedBy ?? this.orderedBy,
      isInCloud: isInCloud ?? this.isInCloud,
      totalDoses: totalDoses ?? this.totalDoses,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
    );
  }

 factory Medication.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Medication(
      id: doc.id,
      name: data['name'] ?? '',
      nameReplacement: data['nameReplacement'],
      activeAgent: data['activeAgent'],
      useCase: data['useCase'],
      sideEffect: data['sideEffect'],
      takeQuantityPerDay: (data['takeQuantityPerDay'] ?? 0).toDouble(),
      takeMonday: data['takeMonday'] ?? false,
      takeTuesday: data['takeTuesday'] ?? false,
      takeWednesday: data['takeWednesday'] ?? false,
      takeThursday: data['takeThursday'] ?? false,
      takeFriday: data['takeFriday'] ?? false,
      takeSaturday: data['takeSaturday'] ?? false,
      takeSunday: data['takeSunday'] ?? false,
      isAlternatingSchedule: data['isAlternatingSchedule'] ?? false,
      currentQuantity: (data['currentQuantity'] ?? 0).toDouble(),
      orderedBy: data['orderedBy'],
      isInCloud: data['isInCloud'] ?? false,
      totalDoses: (data['totalDoses'] ?? 0).toDouble(),
      lastUpdatedDate: (data['lastUpdatedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      if (nameReplacement != null) 'nameReplacement': nameReplacement,
      if (activeAgent != null) 'activeAgent': activeAgent,
      if (useCase != null) 'useCase': useCase,
      if (sideEffect != null) 'sideEffect': sideEffect,
      'takeQuantityPerDay': takeQuantityPerDay,
      'takeMonday': takeMonday,
      'takeTuesday': takeTuesday,
      'takeWednesday': takeWednesday,
      'takeThursday': takeThursday,
      'takeFriday': takeFriday,
      'takeSaturday': takeSaturday,
      'takeSunday': takeSunday,
      'isAlternatingSchedule': isAlternatingSchedule,
      'currentQuantity': currentQuantity,
      if (orderedBy != null) 'orderedBy': orderedBy,
      'isInCloud': isInCloud,
      'totalDoses': totalDoses,
      'lastUpdatedDate': Timestamp.fromDate(lastUpdatedDate),
    };
  }
}