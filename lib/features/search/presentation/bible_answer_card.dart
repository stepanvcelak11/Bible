import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_entities.dart';
import '../../content/presentation/people_screen.dart';
import '../../content/presentation/situations_screen.dart';
import '../../study/presentation/book_intro_sheet.dart';
import '../../content/presentation/topics_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/courses_screen.dart';
import '../../translations/application/translation_controller.dart';
import '../application/bible_answer.dart';
import '../application/scene_search.dart';

/// Odpověď z Bible na otázku: krátký výklad z vět, které k otázce sedí,
/// verše a kde číst dál. Nic nezobrazí, když k dotazu odpověď nemáme.
class BibleAnswerCard extends ConsumerWidget {
  const BibleAnswerCard({super.key, required this.query, this.onOpen});

  final String query;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final answer = ref
        .watch(bibleAnswerProvider((text: query, translationId: tid)))
        .value;
    if (answer == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    void openSource(AnswerSource s) {
      onOpen?.call();
      switch (s.entity) {
        case final BibleTopic t:
          openTopic(context, t);
        case final Situation st:
          openSituation(context, st);
        case (final StudyCourse c, final CourseLesson l):
          openLesson(context, c, l);
        case final StudyCourse c:
          openCourse(context, c);
        case final BiblePerson p:
          openPerson(context, p);
        case final BibleScene sc:
          openReaderAt(context, ref, sc.passage.start);
        case (final int bookId, _):
          showBookIntro(context, bookId);
      }
    }

    // „Z výkladu“ jen u témat, lekcí, postav… (ne u vlastního výkladu
    // otázky ani odkazu na příběh).
    final usedSources = {
      for (final s in answer.sentences)
        if (s.source.kind != AnswerSourceKind.note &&
            s.source.kind != AnswerSourceKind.scene)
          s.source,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Container(
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.gold.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    palette.gold.withValues(alpha: 0.16),
                    palette.gold.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 16, color: palette.gold),
                      const SizedBox(width: 6),
                      Text(
                        S.answerFromBible.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.gold,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    answer.question,
                    style: theme.textTheme.titleLarge?.copyWith(height: 1.2),
                  ),
                ],
              ),
            ),
            if (answer.sentences.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.sentences.map((s) => s.text).join(' '),
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    if (usedSources.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        S.answerFrom(
                          usedSources.map((s) => s.title).join(' · '),
                        ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (answer.verses.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
                child: Text(
                  S.answerVerses.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              for (final v in answer.verses) _AnswerVerseTile(verse: v),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s
                      in answer.sources
                          .where(
                            (s) =>
                                s.kind != AnswerSourceKind.note &&
                                s.kind != AnswerSourceKind.glossary,
                          )
                          .take(4))
                    ActionChip(
                      avatar: Icon(switch (s.kind) {
                        AnswerSourceKind.topic => Icons.lightbulb_outline,
                        AnswerSourceKind.situation => Icons.favorite_border,
                        AnswerSourceKind.lesson => Icons.school_outlined,
                        AnswerSourceKind.course => Icons.school_outlined,
                        AnswerSourceKind.person => Icons.person_outline,
                        AnswerSourceKind.book => Icons.auto_stories_outlined,
                        AnswerSourceKind.scene => Icons.menu_book_outlined,
                        AnswerSourceKind.note ||
                        AnswerSourceKind.glossary => Icons.info_outline,
                      }, size: 18),
                      label: Text(s.title),
                      onPressed: () => openSource(s),
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

class _AnswerVerseTile extends ConsumerWidget {
  const _AnswerVerseTile({required this.verse});

  final AnswerVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(verse.passage.bookId));
    return InkWell(
      onTap: () => openReaderAt(context, ref, verse.passage.start),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: verse.passage.label(book.name),
                    style: TextStyle(color: palette.gold),
                  ),
                  TextSpan(
                    text: '  ${verse.label}',
                    style: TextStyle(
                      color: palette.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 2),
            Text(
              verse.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
