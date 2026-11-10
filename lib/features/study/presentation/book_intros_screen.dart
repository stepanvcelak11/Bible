import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../application/study_providers.dart';
import 'book_intro_sheet.dart';

/// Přehled knih jako barevné dlaždice po oddílech (zkratka, název,
/// jednovětné téma) → úvod ke knize.
class BookIntrosScreen extends ConsumerStatefulWidget {
  const BookIntrosScreen({super.key});

  @override
  ConsumerState<BookIntrosScreen> createState() => _BookIntrosScreenState();
}

class _BookIntrosScreenState extends ConsumerState<BookIntrosScreen> {
  Testament _testament = Testament.oldTestament;

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final intros = ref.watch(bookIntrosProvider).value ?? const {};
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final width = MediaQuery.sizeOf(context).width.clamp(0, 900);
    final columns = width >= 700 ? 3 : 2;

    Widget tile(int id, Color color) => Material(
      color: palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: palette.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showBookIntro(context, id),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.16),
                color.withValues(alpha: 0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                books[id - 1].abbreviation,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                books[id - 1].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                intros[id]?.theme ?? '',
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

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.exploreIntros)),
        body: books.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 24,
                ),
                children: [
                  Text(
                    S.introsIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<Testament>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: Testament.oldTestament,
                        label: Text(S.oldTestament),
                      ),
                      ButtonSegment(
                        value: Testament.newTestament,
                        label: Text(S.newTestament),
                      ),
                    ],
                    selected: {_testament},
                    onSelectionChanged: (v) =>
                        setState(() => _testament = v.single),
                  ),
                  for (final category in bookCategories)
                    if (category.testament == _testament) ...[
                      SectionLabel(category.name),
                      for (
                        var i = category.first;
                        i <= category.last;
                        i += columns
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var j = i; j < i + columns; j++) ...[
                                  if (j > i) const SizedBox(width: 10),
                                  Expanded(
                                    child: j <= category.last
                                        ? tile(j, Color(category.color))
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                ],
              ),
      ),
    );
  }
}
