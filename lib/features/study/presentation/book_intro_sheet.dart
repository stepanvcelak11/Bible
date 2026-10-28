import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/entities/content_entities.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/harmony_screen.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/presentation/people_screen.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../shell/home_shell.dart';
import '../application/study_providers.dart';

/// Otevře úvod ke knize jako spodní panel.
Future<void> showBookIntro(BuildContext context, int bookId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) =>
          BookIntroView(bookId: bookId, scrollController: controller),
    ),
  );
}

/// Úvod ke knize: autor, doba vzniku, téma, shrnutí, osnova, klíčové verše.
class BookIntroView extends ConsumerWidget {
  const BookIntroView({super.key, required this.bookId, this.scrollController});

  final int bookId;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    final intro = ref.watch(bookIntrosProvider).value?[bookId];
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final category = categoryOf(bookId);
    final bookNotes = [
      for (final n in ref.watch(notesProvider).value ?? const <AppNote>[])
        if (n.passage.bookId == bookId) n,
    ];
    final profiles = [
      for (final p in ref.watch(peopleProvider).value ?? const <BiblePerson>[])
        if (p.books.contains(bookId)) p,
    ];
    final accent = Color(category.color);

    if (intro == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget fact(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 26, 0, 12),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: accent),
          const SizedBox(width: 10),
          Text(title, style: theme.textTheme.titleLarge),
        ],
      ),
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Text(
          category.name.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: accent,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(book.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          intro.theme,
          style: theme.textTheme.titleMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: palette.muted,
          ),
        ),
        // --- Přehled ---------------------------------------------------
        section(S.overview),
        Text(
          intro.summary,
          style: TextStyle(
            fontFamily: appFontFamily,
            fontSize: 17,
            height: 1.55,
            color: theme.colorScheme.onSurface,
          ),
        ),
        // --- Pozadí, souvislosti, jak číst --------------------------
        for (final (icon, title, text) in [
          (
            Icons.history_edu_outlined,
            S.historicalBackground,
            intro.background,
          ),
          (Icons.link, S.christConnection, intro.connection),
          (Icons.tips_and_updates_outlined, S.howToRead, intro.howToRead),
        ])
          if (text.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(top: 12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 20, color: accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
        // --- Základní údaje -------------------------------------------
        section(S.basicFacts),
        if (intro.purpose.isNotEmpty)
          fact(Icons.flag_outlined, S.purpose, intro.purpose),
        fact(Icons.person_outline, S.author, intro.author),
        if (intro.recipients.isNotEmpty)
          fact(Icons.groups_outlined, S.recipients, intro.recipients),
        fact(Icons.schedule, S.written, intro.date),
        if (intro.setting.isNotEmpty)
          fact(Icons.landscape_outlined, S.setting, intro.setting),
        if (intro.people.isNotEmpty)
          fact(
            Icons.diversity_3_outlined,
            S.keyPeople,
            intro.people.join(', '),
          ),
        if (intro.places.isNotEmpty)
          fact(Icons.place_outlined, S.keyPlaces, intro.places.join(', ')),
        if (intro.features.isNotEmpty)
          fact(Icons.auto_awesome_outlined, S.features, intro.features),
        Text(S.keyVerses, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kv in intro.keyVerses)
              ActionChip(
                label: Text(
                  '${book.abbreviation} ${kv.replaceFirst(':', ',')}',
                ),
                onPressed: () {
                  final ref0 = _parse(bookId, kv);
                  if (ref0 != null) openReaderAt(context, ref, ref0);
                },
              ),
          ],
        ),
        // --- Časová osa ----------------------------------------------
        if (intro.timeline.isNotEmpty) ...[
          section(S.bookTimeline),
          for (final (i, t) in intro.timeline.indexed)
            _TimelineRow(
              date: t.date,
              event: t.event,
              accent: accent,
              last: i == intro.timeline.length - 1,
            ),
          if (intro.timelineNote case final note?)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                note,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
        // --- Osnova ---------------------------------------------------
        section(S.outline),
        for (final item in intro.outline)
          _OutlineRow(item: item, bookId: bookId, accent: accent),
        // --- Hlavní témata --------------------------------------------
        if (intro.themes.isNotEmpty) ...[
          section(S.mainThemes),
          for (final t in intro.themes)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.text,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
        ],
        // --- Aplikační poznámky ------------------------------------------
        if (bookNotes.isNotEmpty) ...[
          section(S.applicationNotes),
          for (final n in bookNotes)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.sticky_note_2_outlined, color: accent),
                title: Text(n.title),
                subtitle: Text(n.passage.label(book.abbreviation)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showNoteSheet(context, n),
              ),
            ),
        ],
        // --- Medailony postav -----------------------------------------
        if (profiles.isNotEmpty) ...[
          section(S.profiles),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in profiles)
                ActionChip(
                  avatar: Icon(Icons.person_outline, size: 18, color: accent),
                  label: Text(p.name),
                  onPressed: () => openPerson(context, p),
                ),
            ],
          ),
        ],
        // --- Mapa a čtení ----------------------------------------------
        const SizedBox(height: 18),
        if (bookId >= 40 && bookId <= 43) ...[
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HarmonyScreen()),
            ),
            icon: const Icon(Icons.view_week_outlined),
            label: const Text(S.harmony),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton.icon(
          onPressed: () => openBookMap(context, bookId),
          icon: const Icon(Icons.map_outlined),
          label: const Text(S.showBookMap),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: () => openReaderAt(context, ref, VerseRef(bookId, 1)),
          icon: const Icon(Icons.menu_book),
          label: const Text(S.readBook),
        ),
      ],
    );
  }

  static VerseRef? _parse(int bookId, String kv) {
    final m = RegExp(r'^(\d+):(\d+)').firstMatch(kv);
    if (m == null) return null;
    return VerseRef(bookId, int.parse(m[1]!), int.parse(m[2]!));
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.date,
    required this.event,
    required this.accent,
    required this.last,
  });

  final String date;
  final String event;
  final Color accent;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: last
                        ? Colors.transparent
                        : accent.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(event, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineRow extends ConsumerWidget {
  const _OutlineRow({
    required this.item,
    required this.bookId,
    required this.accent,
  });

  final String item;
  final int bookId;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // „12–25 Abraham“ → rozsah kapitol + popis.
    final m = RegExp(r'^([\d:–-]+)\s+(.*)$').firstMatch(item);
    final range = m?[1] ?? '';
    final label = m?[2] ?? item;
    final firstChapter = int.tryParse(RegExp(r'^\d+').stringMatch(range) ?? '');
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: firstChapter == null
          ? null
          : () => openReaderAt(context, ref, VerseRef(bookId, firstChapter)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              child: Text(
                range,
                style: theme.textTheme.labelLarge?.copyWith(color: accent),
              ),
            ),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
