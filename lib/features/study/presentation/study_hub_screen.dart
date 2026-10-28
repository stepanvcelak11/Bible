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
import '../../search/application/reference_parser.dart';
import '../../today/presentation/plans_sheet.dart';
import '../../today/presentation/timeline_screen.dart';
import '../../translations/presentation/library_screen.dart';
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
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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

    Widget group(List<_Entry> entries) => Card(
      child: Column(
        children: [
          for (final (i, e) in entries.indexed) ...[
            if (i > 0) const Divider(height: 1, indent: 72),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: e.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(e.icon, color: e.color),
              ),
              title: Text(e.title, style: theme.textTheme.titleMedium),
              subtitle: Text(e.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: e.onTap,
            ),
          ],
        ],
      ),
    );

    final q = foldCzech(_query.trim());

    return Scaffold(
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            insets.top + 14,
            16,
            insets.bottom + 110,
          ),
          children: [
            Text(S.tabStudy, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              S.studyHubIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: S.studySearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: palette.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: palette.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: palette.cardBorder),
                ),
              ),
            ),
            if (q.isNotEmpty)
              StudySearchResults(query: q)
            else ...[
              // --- Pro život ---------------------------------------------
              header(S.studyForLife),
              _SituationsCard(
                featured: situations.take(8).toList(),
                count: situations.length,
                onAll: () => _push(const SituationsScreen()),
              ),
              const SizedBox(height: 12),
              group([
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
                  Icons.lightbulb_outline,
                  const Color(0xFFB0603A),
                  S.topics,
                  topicsCount == null
                      ? S.topicsHint
                      : S.topicsCount(topicsCount),
                  () => _push(const TopicsScreen()),
                ),
              ]),
              // --- Lidé a příběhy -----------------------------------------
              header(S.studyPeopleStories),
              group([
                _Entry(
                  Icons.diversity_3_outlined,
                  const Color(0xFF8C4A6B),
                  S.people,
                  peopleCount == null
                      ? S.peopleHint
                      : S.peopleCount(peopleCount),
                  () => _push(const PeopleScreen()),
                ),
                _Entry(
                  Icons.view_week_outlined,
                  const Color(0xFF2E8B57),
                  S.harmony,
                  S.harmonyHint,
                  () => _push(const HarmonyScreen()),
                ),
                _Entry(
                  Icons.view_timeline_outlined,
                  const Color(0xFFB0603A),
                  S.timeline,
                  S.timelineHint,
                  () => _push(const TimelineScreen()),
                ),
              ]),
              // --- Knihy Bible --------------------------------------------
              header(S.studyBooks),
              group([
                _Entry(
                  Icons.auto_stories_outlined,
                  const Color(0xFFB0813B),
                  S.exploreIntros,
                  S.introsHint,
                  () => _push(const BookIntrosScreen()),
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
                  tablesCount == null
                      ? S.tablesHint
                      : S.tablesCount(tablesCount),
                  () => _push(const TablesScreen()),
                ),
              ]),
              // --- Mapy, jazyky, čtení ----------------------------------
              header(S.studyMore),
              group([
                _Entry(
                  Icons.map_outlined,
                  const Color(0xFF3F7CAC),
                  S.exploreMaps,
                  S.exploreMapsHint,
                  () => openMaps(context),
                ),
                _Entry(
                  Icons.history_edu,
                  const Color(0xFF8C6BA8),
                  S.exploreStudy,
                  S.exploreStudyHint,
                  () => _push(const StudyPackScreen()),
                ),
                _Entry(
                  Icons.event_note_outlined,
                  const Color(0xFF5B7A3A),
                  S.readingPlans,
                  S.readingPlansHint,
                  () => showPlansSheet(context),
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
