import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/content_entities.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/content_providers.dart';

/// Karta s textem biblického místa v hlavním překladu; klepnutí otevře
/// čtečku.
class PassageCard extends ConsumerWidget {
  const PassageCard({super.key, required this.passage, this.accent});

  final Passage passage;
  final Color? accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translation = ref.watch(primaryTranslationProvider);
    final book = ref.watch(bookByIdProvider(passage.bookId));
    final verses = ref
        .watch(passageTextProvider((translation.id, passage)))
        .value;
    final color = accent ?? palette.gold;
    final multi = (verses?.length ?? 0) > 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => openReaderAt(context, ref, passage.start),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      passage.label(book.name),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    translation.abbreviation,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (verses == null)
                const LinearProgressIndicator(minHeight: 2)
              else
                Text.rich(
                  TextSpan(
                    children: [
                      for (final v in verses) ...[
                        if (multi)
                          TextSpan(
                            text: '${v.number} ',
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        TextSpan(
                          text:
                              '${v.text.replaceAll('\n', ' ').replaceAll(RegExp(r'\{[^}]*\}'), '')} ',
                        ),
                      ],
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontSize: 17,
                    height: 1.5,
                    color: ReaderColors.of(context).text,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
