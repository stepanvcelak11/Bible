import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/bible_content.dart';
import '../application/study_providers.dart';
import 'book_intro_sheet.dart';

/// Přehled všech knih s jednovětým tématem → úvod ke knize.
class BookIntrosScreen extends ConsumerWidget {
  const BookIntrosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final intros = ref.watch(bookIntrosProvider).value ?? const {};
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(S.exploreIntros)),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          for (final category in bookCategories) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(category.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.4,
                      color: palette.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            for (var id = category.first; id <= category.last; id++)
              ListTile(
                title: Text(books[id - 1].name),
                subtitle: Text(
                  intros[id]?.theme ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showBookIntro(context, id),
              ),
          ],
        ],
      ),
    );
  }
}
