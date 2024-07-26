import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  final String? id;
  final String name;
  final String? activeAgent;
  final String? useCase;
  final String? sideEffect;
  final int takeQuantityPerDay;
  final bool takeMonday;
  final bool takeTuesday;
  final bool takeWednesday;
  final bool takeThursday;
  final bool takeFriday;
  final bool takeSaturday;
  final bool takeSunday;
  final int currentQuantity;
  final String? orderedBy;
  final bool isInCloud;
  final int totalDoses;
  final DateTime lastUpdatedDate;

  Medication({
    this.id,
    required this.name,
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
    required this.currentQuantity,
    this.orderedBy,
    required this.isInCloud,
    required this.totalDoses,
    required this.lastUpdatedDate,
  });

  factory Medication.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Medication(
      id: doc.id,
      name: data['name'] ?? '',
      activeAgent: data['activeAgent'],
      useCase: data['useCase'],
      sideEffect: data['sideEffect'],
      takeQuantityPerDay: data['takeQuantityPerDay'] ?? 0,
      takeMonday: data['takeMonday'] ?? false,
      takeTuesday: data['takeTuesday'] ?? false,
      takeWednesday: data['takeWednesday'] ?? false,
      takeThursday: data['takeThursday'] ?? false,
      takeFriday: data['takeFriday'] ?? false,
      takeSaturday: data['takeSaturday'] ?? false,
      takeSunday: data['takeSunday'] ?? false,
      currentQuantity: data['currentQuantity'] ?? 0,
      orderedBy: data['orderedBy'],
      isInCloud: data['isInCloud'] ?? false,
      totalDoses: data['totalDoses'] ?? 0,
      lastUpdatedDate: (data['lastUpdatedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
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
      'currentQuantity': currentQuantity,
      if (orderedBy != null) 'orderedBy': orderedBy,
      'isInCloud': isInCloud,
      'totalDoses': totalDoses,
      'lastUpdatedDate': Timestamp.fromDate(lastUpdatedDate),
    };
  }
}