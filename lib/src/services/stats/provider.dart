import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/services/stats/firestore_service.dart';
import 'package:iaso/src/services/stats/stats.dart';


final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final statsProvider = FutureProvider.autoDispose<Stats?>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final firestoreService = StatsFirestoreService();
  return await firestoreService.fetchStats(selectedDate);
});