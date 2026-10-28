import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/repositories/reading_progress_repository.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../translations/application/translation_controller.dart';

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>(
  (ref) => ReadingProgressRepository(ref.watch(userDatabaseProvider)),
);

/// `bookId → přečtené kapitoly`.
final readChaptersProvider = StreamProvider<Map<int, Set<int>>>(
  (ref) => ref.watch(readingProgressRepositoryProvider).watchReadChapters(),
);

/// Kolik kapitol bylo přečteno v jednotlivých dnech.
final dailyReadingProvider = StreamProvider<Map<DateTime, int>>(
  (ref) => ref.watch(readingProgressRepositoryProvider).watchDailyCounts(),
);

final recentReadingProvider = StreamProvider<List<(VerseRef, DateTime)>>(
  (ref) => ref.watch(readingProgressRepositoryProvider).watchRecent(),
);

final readingStatsProvider = StreamProvider<ReadingStats>(
  (ref) => ref.watch(readingProgressRepositoryProvider).watchStats(),
);

/// Verš dne v hlavním překladu.
final verseOfDayProvider = FutureProvider<Verse?>((ref) async {
  final translationId = ref.watch(
    translationControllerProvider.select((s) => s.primaryId),
  );
  final target = Versification.fromCanonical(
    verseOfDay(DateTime.now()),
    translationId,
  );
  return ref.watch(bibleRepositoryProvider).getVerse(translationId, target);
});

// --- Plán čtení --------------------------------------------------------------

@immutable
class PlanState {
  const PlanState({
    required this.plan,
    required this.schedule,
    required this.done,
    required this.start,
  });

  final ReadingPlan plan;
  final List<List<VerseRef>> schedule;
  final Set<int> done;
  final DateTime start;

  /// První nesplněný den (0-based), nebo `null`, když je plán hotový.
  int? get nextDay {
    for (var d = 0; d < schedule.length; d++) {
      if (!done.contains(d)) return d;
    }
    return null;
  }

  double get progress => schedule.isEmpty ? 0 : done.length / schedule.length;

  /// Kolik dní podle kalendáře uplynulo od začátku (pro „jste napřed/pozadu“).
  int get calendarDay => DateTime.now().difference(start).inDays;
}

class PlanController extends AsyncNotifier<PlanState?> {
  @override
  Future<PlanState?> build() async {
    final prefs = ref.read(appPreferencesProvider);
    final id = prefs.planId;
    if (id == null) return null;
    final plan = planById(id);
    if (plan == null) return null;
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts = await ref.watch(chapterCountsProvider(translationId).future);
    return PlanState(
      plan: plan,
      schedule: plan.schedule(counts),
      done: prefs.planDone,
      start: prefs.planStart ?? DateTime.now(),
    );
  }

  Future<void> start(String planId) async {
    await ref.read(appPreferencesProvider).setPlan(planId);
    ref.invalidateSelf();
  }

  Future<void> stop() async {
    await ref.read(appPreferencesProvider).setPlan(null);
    ref.invalidateSelf();
  }

  Future<void> toggleDay(int day) async {
    final s = state.value;
    if (s == null) return;
    final done = {...s.done};
    if (!done.remove(day)) done.add(day);
    await ref.read(appPreferencesProvider).setPlanDone(done);
    state = AsyncData(
      PlanState(plan: s.plan, schedule: s.schedule, done: done, start: s.start),
    );
  }
}

final planProvider = AsyncNotifierProvider<PlanController, PlanState?>(
  PlanController.new,
);
