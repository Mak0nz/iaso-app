import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/services/meds/medication.dart';
import 'package:iaso/src/services/meds/repository.dart';

final medRepositoryProvider = Provider((ref) => MedRepository());

final medsProvider = StreamProvider<List<Medication>>((ref) {
  final repository = ref.watch(medRepositoryProvider);
   return repository.getMedications().map((meds) {
    // Sort the medications list by name
    meds.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return meds;
  });
});