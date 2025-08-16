import 'package:flutter/material.dart';
import 'package:iaso/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/data/stats_provider.dart';
import 'package:iaso/domain/stats.dart';
import 'package:iaso/presentation/views/stats/modal.dart';
import 'package:iaso/presentation/views/stats/stats_display.dart';
import 'package:iaso/presentation/widgets/appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.stats,
      ),
      floatingActionButton: StatsModal(selectedDate: selectedDate),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Landscape layout
            return Row(
              children: [
                SizedBox(
                  width: 400,
                  child: _buildScrollableContent(
                    child: _buildCalendar(l10n, selectedDate, ref),
                  ),
                ),
                Expanded(
                  child: _buildScrollableContent(
                    child: _buildStatsDisplay(l10n, statsAsync),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout
            return _buildScrollableContent(
              child: Column(
                children: [
                  _buildCalendar(l10n, selectedDate, ref),
                  _buildStatsDisplay(l10n, statsAsync),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildScrollableContent({required Widget child}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            edgeInset, kToolbarHeight + 24, edgeInset, 0),
        child: child,
      ),
    );
  }

  Widget _buildCalendar(
      AppLocalizations l10n, DateTime selectedDate, WidgetRef ref) {
    return TableCalendar(
      locale: l10n.localeName,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableGestures: AvailableGestures.all,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: selectedDate,
      firstDay: DateTime(2024),
      lastDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(selectedDateProvider.notifier).state = selectedDay;
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade300,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade400,
        ),
      ),
    );
  }

  Widget _buildStatsDisplay(
      AppLocalizations l10n, AsyncValue<Stats?> statsAsync) {
    return statsAsync.when(
      data: (stats) => Skeletonizer(
        enabled: false,
        child: StatsDisplay(stats: stats),
      ),
      loading: () => const Skeletonizer(
        enabled: true,
        child: StatsDisplay(stats: null),
      ),
      error: (error, _) => Text('${l10n.error} \n $error'),
    );
  }
}
