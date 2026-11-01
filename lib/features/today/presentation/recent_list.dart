import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/services/bible_content.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

/// Naposledy čtené kapitoly.
class RecentReadingList extends ConsumerWidget {
  const RecentReadingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentReadingProvider).value ?? const [];
    if (recent.isEmpty) return const SizedBox.shrink();
    final books = ref.watch(booksProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(S.recentlyRead),
        Card(
          child: Column(
            children: [
              for (final (i, (ref0, at)) in recent.indexed) ...[
                if (i > 0) const Divider(indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Color(categoryOf(ref0.bookId).color),
                  ),
                  title: Text('${books[ref0.bookId - 1].name} ${ref0.chapter}'),
                  subtitle: Text(_ago(at)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openReaderAt(
                    context,
                    ref,
                    ref0,
                    from: schemeOf(
                      ref.read(translationControllerProvider).primaryId,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _ago(DateTime at) {
    final now = DateTime.now();
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(at.year, at.month, at.day)).inDays;
    return switch (days) {
      0 => 'dnes',
      1 => 'včera',
      < 5 => 'před $days dny',
      _ => '${at.day}. ${at.month}. ${at.year}',
    };
  }
}
