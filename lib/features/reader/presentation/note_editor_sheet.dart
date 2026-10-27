import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/citation.dart';

/// Otevře editor poznámky – novou (`ref` + `verseEnd`) nebo existující.
Future<void> showNoteEditor(
  BuildContext context, {
  Note? existing,
  VerseRef? ref,
  int? verseEnd,
}) {
  assert(existing != null || ref != null);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => NoteEditorSheet(
      existing: existing,
      start: existing?.ref ?? ref!,
      end: existing?.verseEnd ?? verseEnd ?? ref!.verse,
    ),
  );
}

class NoteEditorSheet extends ConsumerStatefulWidget {
  const NoteEditorSheet({
    super.key,
    required this.start,
    required this.end,
    this.existing,
  });

  final VerseRef start;
  final int end;
  final Note? existing;

  @override
  ConsumerState<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends ConsumerState<NoteEditorSheet> {
  late final _controller = TextEditingController(text: widget.existing?.body);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final body = _controller.text.trim();
    final repo = ref.read(userDataRepositoryProvider);
    final navigator = Navigator.of(context);
    if (body.isEmpty) {
      // Prázdná poznámka = smazání existující.
      if (widget.existing != null) await repo.deleteNote(widget.existing!.id);
    } else {
      await repo.saveNote(
        id: widget.existing?.id,
        ref: widget.start,
        verseEnd: widget.end,
        body: body,
      );
    }
    navigator.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(S.deleteNoteQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(S.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(S.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final navigator = Navigator.of(context);
    await ref.read(userDataRepositoryProvider).deleteNote(widget.existing!.id);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookByIdProvider(widget.start.bookId));
    final verses = [for (var v = widget.start.verse; v <= widget.end; v++) v];
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.existing == null ? S.addNote : S.editNote,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 2),
          Text(
            Citation.range(book.name, widget.start.chapter, verses),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 4,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: S.notePlaceholder,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.existing != null)
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(S.delete),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              const Spacer(),
              FilledButton(onPressed: _save, child: const Text(S.save)),
            ],
          ),
        ],
      ),
    );
  }
}
