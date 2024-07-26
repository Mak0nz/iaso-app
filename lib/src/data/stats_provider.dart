import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/data/stats_repository.dart';
import 'package:iaso/src/domain/stats.dart';


final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final statsProvider = FutureProvider.autoDispose<Stats?>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final firestoreService = StatsFirestoreService();
  return await firestoreService.fetchStats(selectedDate);
});