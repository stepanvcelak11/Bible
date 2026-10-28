import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';

/// Otázky k zamyšlení nad přečtenou kapitolou.
const reflectionQuestions = [
  'Co mě v kapitole nejvíc oslovilo nebo překvapilo?',
  'Co se tu dozvídám o Bohu (o Ježíši)?',
  'Co se tu dozvídám o člověku – a o sobě?',
  'Co s tím udělám? Za co se chci pomodlit?',
];

/// Otevře zamyšlení nad kapitolou [chapter] (číslování hlavního překladu).
Future<void> showReflectionSheet(
  BuildContext context, {
  required int bookId,
  required int chapter,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _ReflectionSheet(bookId: bookId, chapter: chapter),
);

class _ReflectionSheet extends ConsumerStatefulWidget {
  const _ReflectionSheet({required this.bookId, required this.chapter});

  final int bookId;
  final int chapter;

  @override
  ConsumerState<_ReflectionSheet> createState() => _ReflectionSheetState();
}

class _ReflectionSheetState extends ConsumerState<_ReflectionSheet> {
  final _controllers = [
    for (final _ in reflectionQuestions) TextEditingController(),
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _hasText => _controllers.any((c) => c.text.trim().isNotEmpty);

  Future<void> _save() async {
    final book = ref.read(bookByIdProvider(widget.bookId)).name;
    final translationId = ref.read(translationControllerProvider).primaryId;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final body = [
      S.reflectionTitle(book, widget.chapter),
      for (final (i, q) in reflectionQuestions.indexed)
        if (_controllers[i].text.trim().isNotEmpty)
          '$q\n${_controllers[i].text.trim()}',
    ].join('\n\n');
    await ref
        .read(userDataRepositoryProvider)
        .saveNote(
          ref: Versification.toCanonical(
            VerseRef(widget.bookId, widget.chapter, 1),
            translationId,
          ),
          body: body,
        );
    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text(S.reflectionSaved),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(widget.bookId)).name;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(
            S.reflectionTitle(book, widget.chapter),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            S.reflectionIntro,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 16),
          for (final (i, q) in reflectionQuestions.indexed) ...[
            Text(q, style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _controllers[i],
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: S.reflectionHint,
                filled: true,
                fillColor: palette.card,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: palette.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: palette.cardBorder),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          FilledButton.icon(
            onPressed: _hasText ? _save : null,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text(S.reflectionSave),
          ),
        ],
      ),
    );
  }
}

/// Konec kapitoly: zamyšlení a přechod na další kapitolu.
class ChapterFooter extends StatelessWidget {
  const ChapterFooter({
    super.key,
    required this.bookId,
    required this.chapter,
    required this.onNext,
  });

  final int bookId;
  final int chapter;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          Container(width: 48, height: 2, color: palette.gold),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
              leading: Icon(Icons.self_improvement, color: palette.gold),
              title: const Text(S.reflection),
              subtitle: const Text(S.reflectionHintShort),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showReflectionSheet(
                context,
                bookId: bookId,
                chapter: chapter,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(S.nextChapter, style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}
