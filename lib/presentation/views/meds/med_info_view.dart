import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/domain/medication_info.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/data/provider/med_provider.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/input_med_form.dart';

class MedicationInfoView extends ConsumerStatefulWidget {
  final MedicationInfo? initialMedication;
  final bool isEditing;

  const MedicationInfoView({
    super.key,
    this.initialMedication,
    this.isEditing = false,
  });

  @override
  ConsumerState<MedicationInfoView> createState() => _MedicationInfoViewState();
}

class _MedicationInfoViewState extends ConsumerState<MedicationInfoView> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchResults = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialMedication != null) {
      final language = ref.read(languageProvider);
      _searchController.text =
          widget.initialMedication!.getLocalizedName(language);
      ref.read(selectedMedicationProvider.notifier).state =
          widget.initialMedication;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.length >= 2) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _showSearchResults = true);
          ref.read(medicationSearchQueryProvider.notifier).state = query;
        }
      });
    } else {
      setState(() => _showSearchResults = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageProvider);
    final selectedMedication = ref.watch(selectedMedicationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        InputMedForm(
          controller: _searchController,
          labelText: l10n.translate('med_name'),
          require: true,
          onChanged: _onSearchChanged,
        ),

        // Search results
        if (_showSearchResults)
          Consumer(
            builder: (context, ref, child) {
              final searchQuery = ref.watch(medicationSearchQueryProvider);
              final searchResults = ref.watch(
                medicationSearchResultsProvider(searchQuery),
              );

              return searchResults.when(
                data: (medications) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: medications.isEmpty ? 0 : 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final med = medications[index];
                      return ListTile(
                        title: Text(med.getLocalizedName(language)),
                        subtitle: Text(
                          med.getLocalizedActiveAgent(language) ?? '',
                        ),
                        onTap: () {
                          setState(() => _showSearchResults = false);
                          _searchController.text =
                              med.getLocalizedName(language);
                          ref.read(selectedMedicationProvider.notifier).state =
                              med;
                        },
                      );
                    },
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              );
            },
          ),

        if (selectedMedication != null) ...[
          const SizedBox(height: 20),

          // Medication Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    l10n.translate('med_replacement_name'),
                    selectedMedication.getLocalizedReplacement(language),
                  ),
                  _buildInfoRow(
                    l10n.translate('active_agent'),
                    selectedMedication.getLocalizedActiveAgent(language),
                  ),
                  _buildInfoRow(
                    l10n.translate('use_case'),
                    selectedMedication.getLocalizedUseCase(language),
                  ),
                  _buildInfoRow(
                    l10n.translate('side_effect'),
                    selectedMedication.getLocalizedSideEffect(language),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.subHeading(label),
          Text(value ?? '-'),
        ],
      ),
    );
  }
}
