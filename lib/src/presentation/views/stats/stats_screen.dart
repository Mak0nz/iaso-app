import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/data/stats_provider.dart';
import 'package:iaso/src/presentation/views/stats/modal.dart';
import 'package:iaso/src/presentation/views/stats/stats_display.dart';
import 'package:iaso/src/presentation/widgets/appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.stats,
      ),
      floatingActionButton: StatsModal(selectedDate: selectedDate),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: edgeInset),
          child: Column(children: [
            const SizedBox(height: kToolbarHeight*1.25,),
            TableCalendar(
              locale: AppLocalizations.of(context)!.localeName,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
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
                todayDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade300),
                selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade400),
              ),
            ),
          
            statsAsync.when(
              data: (stats) => Skeletonizer(
                enabled: false,
                child: StatsDisplay(stats: stats),
              ),
              loading: () => const Skeletonizer(
                enabled: true,
                child: StatsDisplay(stats: null),
              ),
              error: (error, _) => Text('${AppLocalizations.of(context)!.error} \n $error'),
            ),
            
          ],
              ),
        ),
      ),);
  }
}