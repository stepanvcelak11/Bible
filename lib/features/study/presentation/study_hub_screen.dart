import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../prep/presentation/prep_screen.dart';
import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/harmony_screen.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/presentation/people_screen.dart';
import '../../content/presentation/situations_screen.dart';
import '../../content/presentation/tables_screen.dart';
import '../../content/presentation/topics_screen.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../plans/presentation/plans_screen.dart';
import '../../memory/application/memory_controller.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../prayer/presentation/prayers_view.dart';
import '../../connections/presentation/connections_screen.dart';
import '../../content/presentation/church_year_screen.dart';
import '../../content/presentation/quiz_screen.dart';
import '../../today/presentation/plan_card.dart';
import '../../today/presentation/plans_sheet.dart';
import '../../today/application/today_providers.dart';
import '../application/course_progress.dart';
import '../../today/presentation/timeline_screen.dart';
import '../../content/presentation/family_tree_screen.dart';
import '../../prayer/presentation/lectio_screen.dart';
import '../../translations/presentation/library_screen.dart';
import 'book_intros_screen.dart';
import 'courses_screen.dart';
import 'study_pack_screen.dart';

/// Záložka „Studium“ – všechny studijní materiály na jednom místě
/// a hledání napříč nimi.
class StudyHubScreen extends ConsumerStatefulWidget {
  const StudyHubScreen({super.key});

  @override
  ConsumerState<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends ConsumerState<StudyHubScreen> {
  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final insets = MediaQuery.paddingOf(context);
    final peopleCount = ref.watch(peopleProvider).value?.length;
    final situations =
        ref.watch(situationsProvider).value?.$2 ?? const <Situation>[];
    final topicsCount = ref.watch(topicsProvider).value?.$2.length;
    final memory = ref.watch(memoryProvider);
    final memoryCount = memory.length;
    final memoryLearned = memory.where((m) => m.learned).length;

    Widget header(String title) => SectionLabel(title);

    // Barevné dlaždice: na telefonu dva sloupce, na tabletu tři až čtyři.
    final width = MediaQuery.sizeOf(context).width;
    final maxColumns = width >= 1100
        ? 4
        : width >= 700
        ? 3
        : 2;
    Widget tile(_Entry e, {bool wide = false}) => Material(
      color: palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: palette.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: e.onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                e.color.withValues(alpha: 0.16),
                e.color.withValues(alpha: 0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: wide
              ? Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: e.color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: e.color.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(e.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.subtitle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: palette.muted,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: e.color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: e.color.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(e.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      e.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );

    Widget group(List<_Entry> entries) {
      // Počet sloupců, se kterým skupina vyjde do celých řádků (na tabletu
      // např. 2 dlaždice vedle sebe místo 1 + prázdných míst).
      var columns = maxColumns;
      for (var c = maxColumns; c >= 2; c--) {
        if (entries.length % c == 0) {
          columns = c;
          break;
        }
      }
      // Když dlaždice nevyjdou do celých řádků, první je přes celou šířku.
      final wide = entries.length % columns == 0 ? 0 : 1;
      final rest = entries.sublist(wide);
      return Column(
        children: [
          if (wide == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: tile(entries.first, wide: true),
              ),
            ),
          for (var i = 0; i < rest.length; i += columns)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var j = i; j < i + columns; j++) ...[
                      if (j > i) const SizedBox(width: 10),
                      Expanded(
                        child: j < rest.length
                            ? tile(rest[j])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      );
    }

    // Méně častá místa: kompaktní mřížka ikon s krátkým popiskem.
    final more = <_Entry>[
      _Entry(
        Icons.hub_outlined,
        const Color(0xFFB0603A),
        S.connections,
        '',
        () => openConnections(context),
      ),
      _Entry(
        Icons.account_tree_outlined,
        const Color(0xFF2E8B57),
        S.familyTree,
        '',
        () => openFamilyTree(context),
      ),
      _Entry(
        Icons.account_balance_outlined,
        const Color(0xFF8C6BA8),
        S.plans,
        '',
        () => openPlans(context),
      ),
      _Entry(
        Icons.view_week_outlined,
        const Color(0xFF2E8B57),
        S.harmony,
        '',
        () => _push(const HarmonyScreen()),
      ),
      _Entry(
        Icons.table_chart_outlined,
        const Color(0xFF5B7A3A),
        S.tables,
        '',
        () => _push(const TablesScreen()),
      ),
      _Entry(
        Icons.sticky_note_2_outlined,
        const Color(0xFF3F7CAC),
        S.applicationNotes,
        '',
        () => _push(const NotesScreen()),
      ),
      _Entry(
        Icons.event_note_outlined,
        const Color(0xFF5B7A3A),
        S.readingPlans,
        '',
        () => showPlansSheet(context),
      ),
      _Entry(
        Icons.emoji_events_outlined,
        const Color(0xFFC08A2E),
        S.quiz,
        '',
        () => openQuiz(context),
      ),
      _Entry(
        Icons.psychology_outlined,
        const Color(0xFF8C6BA8),
        S.memory,
        memoryCount == 0 ? '' : '$memoryLearned/$memoryCount',
        () => openMemory(context),
      ),
      _Entry(
        Icons.volunteer_activism_outlined,
        const Color(0xFF3E8E5E),
        S.prayers,
        '',
        () => openPrayers(context),
      ),
      _Entry(
        Icons.spa_outlined,
        const Color(0xFF4E8A9A),
        S.lectio,
        '',
        () => openLectio(context),
      ),
      _Entry(
        Icons.donut_large,
        const Color(0xFF7A55A8),
        S.churchYear,
        '',
        () => openChurchYear(context),
      ),
      _Entry(
        Icons.edit_note,
        const Color(0xFFB07A2A),
        S.prepsShort,
        '',
        () => openPreps(context),
      ),
      _Entry(
        Icons.history_edu,
        const Color(0xFF8C6BA8),
        S.exploreStudy,
        '',
        () => _push(const StudyPackScreen()),
      ),
      _Entry(
        Icons.translate,
        const Color(0xFF4E9A8A),
        S.exploreTranslations,
        '',
        () => _push(const LibraryScreen()),
      ),
    ];
    final iconColumns = width >= 700 ? 5 : 3;
    Widget mini(_Entry e) => InkWell(
      onTap: e.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: e.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(e.icon, color: e.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              e.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(height: 1.2),
            ),
            if (e.subtitle.isNotEmpty)
              Text(
                e.subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                ),
              ),
          ],
        ),
      ),
    );

    final course = currentCourse(
      ref.watch(coursesProvider).value ?? const <StudyCourse>[],
      ref.watch(courseProgressProvider),
    );
    final hasPlan = ref.watch(planProvider).value != null;

    return Scaffold(
      body: ReadableWidth(
        maxWidth: 1240,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            insets.top + (isCompactHeight(context) ? 8 : 14),
            16,
            insets.bottom + 110,
          ),
          children: [
            if (!isCompactHeight(context)) ...[
              Text(S.tabStudy, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                S.studyHubIntro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
            ],
            // --- Rozečtené: jen když něco opravdu běží ---------------------
            if (course != null || hasPlan) ...[
              header(S.studyContinue),
              if (course != null) const CourseContinueCard(),
              if (course != null && hasPlan) const SizedBox(height: 10),
              if (hasPlan) const PlanCard(),
            ],
            // --- Kurzy ---------------------------------------------------
            SectionLabel(
              S.studyStepByStep,
              action: S.all,
              onAction: () => openCourses(context),
            ),
            const CoursesShelf(),
            // --- Hlavní místa ke čtení a objevování ------------------------
            header(S.studyExplore),
            group([
              _Entry(
                Icons.lightbulb_outline,
                const Color(0xFFB0603A),
                S.topics,
                topicsCount == null ? S.topicsHint : S.topicsCount(topicsCount),
                () => _push(const TopicsScreen()),
              ),
              _Entry(
                Icons.auto_stories_outlined,
                const Color(0xFFB0813B),
                S.exploreIntros,
                S.introsShort,
                () => _push(const BookIntrosScreen()),
              ),
              _Entry(
                Icons.diversity_3_outlined,
                const Color(0xFF8C4A6B),
                S.people,
                peopleCount == null ? S.peopleHint : S.peopleCount(peopleCount),
                () => _push(const PeopleScreen()),
              ),
              _Entry(
                Icons.favorite_border,
                const Color(0xFFC0504D),
                S.situations,
                situations.isEmpty
                    ? S.situationsShort
                    : S.allSituationsCount(situations.length),
                () => _push(const SituationsScreen()),
              ),
              _Entry(
                Icons.map_outlined,
                const Color(0xFF3F7CAC),
                S.exploreMaps,
                S.mapsShort,
                () => openMaps(context),
              ),
              _Entry(
                Icons.view_timeline_outlined,
                const Color(0xFF6B7A3A),
                S.timeline,
                S.timelineShort,
                () => _push(const TimelineScreen()),
              ),
            ]),
            // --- Všechno ostatní jako ikony ------------------------------
            header(S.studyMoreTools),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    for (var i = 0; i < more.length; i += iconColumns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var j = i; j < i + iconColumns; j++)
                            Expanded(
                              child: j < more.length
                                  ? mini(more[j])
                                  : const SizedBox.shrink(),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Entry {
  const _Entry(this.icon, this.color, this.title, this.subtitle, this.onTap);

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
