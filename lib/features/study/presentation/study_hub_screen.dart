import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/timeline.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/harmony_screen.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/presentation/people_screen.dart';
import '../../content/presentation/situations_screen.dart';
import '../../content/presentation/tables_screen.dart';
import '../../content/presentation/topics_screen.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../memory/application/memory_controller.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../prayer/presentation/prayers_view.dart';
import '../../connections/presentation/connections_screen.dart';
import '../../content/presentation/church_year_screen.dart';
import '../../content/presentation/quiz_screen.dart';
import '../../search/application/reference_parser.dart';
import '../../today/presentation/plans_sheet.dart';
import '../../today/presentation/timeline_screen.dart';
import '../../translations/presentation/library_screen.dart';
import '../../shell/home_shell.dart';
import 'book_intro_sheet.dart';
import 'book_intros_screen.dart';
import 'study_pack_screen.dart';

/// Záložka „Studium“ – všechny studijní materiály na jednom místě
/// a hledání napříč nimi.
class StudyHubScreen extends ConsumerStatefulWidget {
  const StudyHubScreen({super.key});

  @override
  ConsumerState<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends ConsumerState<StudyHubScreen> {
  final _wholeKey = GlobalKey();
  final _lifeKey = GlobalKey();
  final _booksKey = GlobalKey();
  final _toolsKey = GlobalKey();

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
    final notesCount = ref.watch(notesProvider).value?.length;
    final tablesCount = ref.watch(tablesProvider).value?.length;
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

    final sections = [
      (S.connectionsWhole, Icons.hub_outlined, _wholeKey),
      (S.studyForLife, Icons.favorite_border, _lifeKey),
      (S.studyBooksPeople, Icons.auto_stories_outlined, _booksKey),
      (S.studyTools, Icons.handyman_outlined, _toolsKey),
    ];

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
              const SizedBox(height: 14),
            ],
            // Jedno hledání pro celou aplikaci – v záložce Hledat.
            Material(
              color: palette.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: palette.cardBorder),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onTap: () =>
                    ref.read(shellTabProvider.notifier).select(AppTab.search),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: palette.muted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          S.studySearchHint,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Rychlé skoky na oddíly.
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final (title, icon, key) in sections)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        avatar: Icon(icon, size: 18, color: palette.gold),
                        label: Text(title),
                        onPressed: () {
                          final c = key.currentContext;
                          if (c != null) {
                            Scrollable.ensureVisible(
                              c,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            // --- Bible jako celek ----------------------------------------
            KeyedSubtree(key: _wholeKey, child: header(S.connectionsWhole)),
            const ConnectionsHeroCard(),
            const SizedBox(height: 10),
            group([
              _Entry(
                Icons.view_timeline_outlined,
                const Color(0xFFB0603A),
                S.timeline,
                S.timelineHint,
                () => _push(const TimelineScreen()),
              ),
              _Entry(
                Icons.map_outlined,
                const Color(0xFF3F7CAC),
                S.exploreMaps,
                S.exploreMapsHint,
                () => openMaps(context),
              ),
            ]),
            // --- Pro život -----------------------------------------------
            KeyedSubtree(key: _lifeKey, child: header(S.studyForLife)),
            _SituationsCard(
              featured: situations.take(8).toList(),
              count: situations.length,
              onAll: () => _push(const SituationsScreen()),
            ),
            const SizedBox(height: 10),
            group([
              _Entry(
                Icons.lightbulb_outline,
                const Color(0xFFB0603A),
                S.topics,
                topicsCount == null ? S.topicsHint : S.topicsCount(topicsCount),
                () => _push(const TopicsScreen()),
              ),
              _Entry(
                Icons.psychology_outlined,
                const Color(0xFF8C6BA8),
                S.memory,
                memoryCount == 0
                    ? S.memoryHint
                    : S.memoryProgress(memoryLearned, memoryCount),
                () => openMemory(context),
              ),
              _Entry(
                Icons.volunteer_activism_outlined,
                const Color(0xFF3E8E5E),
                S.prayers,
                S.prayerHint,
                () => openPrayers(context),
              ),
              _Entry(
                Icons.emoji_events_outlined,
                const Color(0xFFC08A2E),
                S.quiz,
                S.quizHint,
                () => openQuiz(context),
              ),
              _Entry(
                Icons.donut_large,
                const Color(0xFF7A55A8),
                S.churchYear,
                S.churchYearHint,
                () => openChurchYear(context),
              ),
              _Entry(
                Icons.event_note_outlined,
                const Color(0xFF5B7A3A),
                S.readingPlans,
                S.readingPlansHint,
                () => showPlansSheet(context),
              ),
            ]),
            // --- Knihy a postavy -----------------------------------------
            KeyedSubtree(key: _booksKey, child: header(S.studyBooksPeople)),
            group([
              _Entry(
                Icons.auto_stories_outlined,
                const Color(0xFFB0813B),
                S.exploreIntros,
                S.introsHint,
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
                Icons.sticky_note_2_outlined,
                const Color(0xFF3F7CAC),
                S.applicationNotes,
                notesCount == null
                    ? S.applicationNotesHint
                    : S.notesCount(notesCount),
                () => _push(const NotesScreen()),
              ),
              _Entry(
                Icons.table_chart_outlined,
                const Color(0xFF5B7A3A),
                S.tables,
                tablesCount == null ? S.tablesHint : S.tablesCount(tablesCount),
                () => _push(const TablesScreen()),
              ),
              _Entry(
                Icons.view_week_outlined,
                const Color(0xFF2E8B57),
                S.harmony,
                S.harmonyHint,
                () => _push(const HarmonyScreen()),
              ),
            ]),
            // --- Nástroje ------------------------------------------------
            KeyedSubtree(key: _toolsKey, child: header(S.studyTools)),
            group([
              _Entry(
                Icons.history_edu,
                const Color(0xFF8C6BA8),
                S.exploreStudy,
                S.exploreStudyHint,
                () => _push(const StudyPackScreen()),
              ),
              _Entry(
                Icons.translate,
                const Color(0xFF4E9A8A),
                S.exploreTranslations,
                S.exploreTranslationsHint,
                () => _push(const LibraryScreen()),
              ),
            ]),
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

/// Velká karta „Verše do situací“ s nejčastějšími situacemi.
class _SituationsCard extends StatelessWidget {
  const _SituationsCard({
    required this.featured,
    required this.count,
    required this.onAll,
  });

  final List<Situation> featured;
  final int count;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.heroStart, palette.heroEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border, color: palette.onHero),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.situations,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: palette.onHero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            S.situationsCardHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.onHero.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in featured)
                Material(
                  color: palette.onHero.withValues(alpha: 0.14),
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => openSituation(context, s),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            situationIcons[s.icon],
                            size: 18,
                            color: palette.onHero,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            s.title,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: palette.onHero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAll,
              style: TextButton.styleFrom(foregroundColor: palette.onHero),
              icon: const Icon(Icons.arrow_forward),
              label: Text(S.allSituationsCount(count)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Výsledky hledání ve studijních materiálech (postavy, situace, knihy,
/// tabulky, poznámky, harmonie, časová osa).
class StudySearchResults extends ConsumerWidget {
  const StudySearchResults({
    super.key,
    required this.query,
    this.compact = false,
  });

  /// Dotaz bez diakritiky, malými písmeny.
  final String query;

  /// V běžném hledání: jen několik výsledků s nadpisem, bez hlášky
  /// „nic nenalezeno“.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    bool hit(String s) => foldCzech(s).contains(query);
    void push(Widget page) =>
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page));

    final results = <(IconData, String, String, VoidCallback)>[
      for (final s
          in ref.watch(situationsProvider).value?.$2 ?? const <Situation>[])
        if (hit(s.title) || hit(s.intro))
          (
            situationIcons[s.icon] ?? Icons.favorite_border,
            s.title,
            S.situations,
            () => openSituation(context, s),
          ),
      for (final t
          in ref.watch(topicsProvider).value?.$2 ?? const <BibleTopic>[])
        if (hit(t.title))
          (
            situationIcons[t.icon] ?? Icons.lightbulb_outline,
            t.title,
            S.topics,
            () => openTopic(context, t),
          ),
      for (final p in ref.watch(peopleProvider).value ?? const <BiblePerson>[])
        if (hit(p.name) || hit(p.role))
          (
            Icons.person_outline,
            p.name,
            '${S.profile} · ${p.role}',
            () => openPerson(context, p),
          ),
      for (final b in ref.watch(booksProvider))
        if (hit(b.name))
          (
            Icons.auto_stories_outlined,
            b.name,
            S.bookIntro,
            () => showBookIntro(context, b.id),
          ),
      for (final t in ref.watch(tablesProvider).value ?? const <ContentTable>[])
        if (hit(t.title))
          (
            Icons.table_chart_outlined,
            t.title,
            S.tables,
            () => openTable(context, t),
          ),
      for (final n in ref.watch(notesProvider).value ?? const <AppNote>[])
        if (hit(n.title))
          (
            Icons.sticky_note_2_outlined,
            n.title,
            S.applicationNotes,
            () => showNoteSheet(context, n),
          ),
      for (final per
          in ref.watch(harmonyProvider).value ?? const <HarmonyPeriod>[])
        for (final e in per.events)
          if (hit(e.title))
            (
              Icons.view_week_outlined,
              e.title,
              S.harmony,
              () => push(const HarmonyScreen()),
            ),
      for (final e in timelineEvents)
        if (hit(e.title))
          (
            Icons.view_timeline_outlined,
            e.title,
            '${S.timeline} · ${e.date}',
            () => push(const TimelineScreen()),
          ),
    ];

    if (compact) {
      if (results.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
            child: Text(
              S.fromStudy,
              style: theme.textTheme.labelLarge?.copyWith(color: palette.muted),
            ),
          ),
          Card(
            child: Column(
              children: [
                for (final (i, (icon, title, subtitle, onTap))
                    in results.take(4).indexed) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  ListTile(
                    dense: true,
                    leading: Icon(icon, color: palette.gold),
                    title: Text(title),
                    subtitle: Text(subtitle, maxLines: 1),
                    onTap: onTap,
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          S.studyNoResults,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Column(
          children: [
            for (final (i, (icon, title, subtitle, onTap))
                in results.take(60).indexed) ...[
              if (i > 0) const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(icon, color: palette.gold),
                title: Text(title),
                subtitle: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
