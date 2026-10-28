import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../../shell/home_shell.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

/// Seznam aplikačních poznámek podle knih.
class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider).value;
    final books = ref.watch(booksProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final byBook = <int, List<AppNote>>{};
    for (final n in notes ?? const <AppNote>[]) {
      (byBook[n.passage.bookId] ??= []).add(n);
    }
    final bookIds = byBook.keys.toList()..sort();

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.applicationNotes)),
        body: notes == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 32,
                ),
                children: [
                  Text(
                    S.applicationNotesIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _ThreePartsLegend(),
                  for (final b in bookIds) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                      child: Text(
                        books[b - 1].name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: palette.gold,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          for (final (i, n) in byBook[b]!.indexed) ...[
                            if (i > 0) const Divider(height: 1, indent: 16),
                            ListTile(
                              title: Text(n.title),
                              subtitle: Text(
                                n.passage.label(books[b - 1].abbreviation),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => showNoteSheet(context, n),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _ThreePartsLegend extends StatelessWidget {
  const _ThreePartsLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (icon, color, title, text) in _parts)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$title – ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: text),
                          ],
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

const _parts = [
  (
    Icons.menu_book_outlined,
    Color(0xFF3F7CAC),
    S.noteExplanation,
    S.noteExplanationHint,
  ),
  (Icons.link, Color(0xFFB0813B), S.noteBridge, S.noteBridgeHint),
  (
    Icons.directions_walk,
    Color(0xFF2E8B57),
    S.noteApplication,
    S.noteApplicationHint,
  ),
];

/// Aplikační poznámka ve spodním panelu: text, výklad, most, aplikace.
Future<void> showNoteSheet(BuildContext context, AppNote note) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (context, controller) => Consumer(
          builder: (context, ref, _) {
            final theme = Theme.of(context);
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              children: [
                Text(
                  S.applicationNote.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppPalette.of(context).gold,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(note.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                PassageCard(passage: note.passage),
                for (final (i, (icon, color, title, _)) in _parts.indexed)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                [
                                  note.explanation,
                                  note.bridge,
                                  note.application,
                                ][i],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () =>
                      openReaderAt(context, ref, note.passage.start),
                  icon: const Icon(Icons.menu_book),
                  label: const Text(S.readInBible),
                ),
              ],
            );
          },
        ),
      ),
    );
