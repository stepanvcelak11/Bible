import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/services/citation.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/memory_controller.dart';

void openMemory(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const MemoryScreen()));

String _citation(WidgetRef ref, MemoryVerse m) {
  final book = ref.watch(bookByIdProvider(m.start.bookId)).name;
  return Citation.range(book, m.start.chapter, [
    for (var v = m.start.verse; v <= m.end; v++) v,
  ]);
}

/// Seznam veršů, které se učím nazpaměť.
class MemoryScreen extends ConsumerWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(memoryProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final learned = list.where((m) => m.learned).length;
    return Scaffold(
      appBar: AppBar(title: const Text(S.memory)),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Text(
              S.memoryIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            const SizedBox(height: 14),
            if (list.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        size: 40,
                        color: palette.gold,
                      ),
                      const SizedBox(height: 10),
                      const Text(S.memoryEmpty, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context).popUntil((r) => r.isFirst);
                          ref
                              .read(shellTabProvider.notifier)
                              .select(AppTab.bible);
                        },
                        child: const Text(S.openBible),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Text(
                S.memoryProgress(learned, list.length),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    for (final (i, m) in list.indexed) ...[
                      if (i > 0) const Divider(height: 1, indent: 16),
                      Dismissible(
                        key: ValueKey(m.encode()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: theme.colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_outline),
                        ),
                        onDismissed: (_) =>
                            ref.read(memoryProvider.notifier).remove(m),
                        child: ListTile(
                          title: Text(_citation(ref, m)),
                          subtitle: _MemoryPreview(m),
                          trailing: _LevelDots(m.level),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => PracticeScreen(verse: m),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                S.memorySwipeHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemoryPreview extends ConsumerWidget {
  const _MemoryPreview(this.verse);

  final MemoryVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(memoryTextProvider(verse)).value ?? '…';
    return Text(text, maxLines: 2, overflow: TextOverflow.ellipsis);
  }
}

class _LevelDots extends StatelessWidget {
  const _LevelDots(this.level);

  final int level;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    if (level >= MemoryVerse.maxLevel) {
      return Icon(Icons.verified, color: palette.gold);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < MemoryVerse.maxLevel; i++)
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < level
                  ? palette.gold
                  : palette.muted.withValues(alpha: 0.25),
            ),
          ),
      ],
    );
  }
}

/// Které slovo se na daném kroku skryje.
bool _hidden(int index, int level) => switch (level) {
  0 => false,
  1 => index % 4 == 3,
  2 => index % 2 == 1,
  _ => true,
};

/// Procvičování: slova se postupně skrývají, klepnutím je lze odkrýt.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key, required this.verse});

  final MemoryVerse verse;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  late int _level = widget.verse.level.clamp(0, MemoryVerse.maxLevel - 1);
  final _revealed = <int>{};
  bool _showAll = false;

  void _go(int level) {
    HapticFeedback.selectionClick();
    final next = level.clamp(0, MemoryVerse.maxLevel);
    ref.read(memoryProvider.notifier).setLevel(widget.verse, next);
    if (next >= MemoryVerse.maxLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(S.memoryLearned),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _level = next;
      _revealed.clear();
      _showAll = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final text = ref.watch(memoryTextProvider(widget.verse)).value;
    final translation = ref.watch(primaryTranslationProvider).abbreviation;
    final words = text?.split(RegExp(r'\s+')) ?? const <String>[];
    return Scaffold(
      appBar: AppBar(title: Text(_citation(ref, widget.verse))),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Row(
              children: [
                Text(
                  S.memoryStep(_level + 1, MemoryVerse.maxLevel),
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    S.memoryStepHint[_level],
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_level + 1) / MemoryVerse.maxLevel,
                minHeight: 6,
                color: palette.gold,
                backgroundColor: palette.gold.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: text == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 8,
                            children: [
                              for (final (i, w) in words.indexed)
                                _Word(
                                  word: w,
                                  level: _level,
                                  hidden:
                                      !_showAll &&
                                      _hidden(i, _level) &&
                                      !_revealed.contains(i),
                                  onTap: () => setState(() => _revealed.add(i)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_citation(ref, widget.verse)} · $translation',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: palette.muted,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            if (_level > 0)
              Text(
                S.memoryTapHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    icon: Icon(
                      _showAll ? Icons.visibility_off : Icons.visibility,
                    ),
                    label: Text(_showAll ? S.memoryHide : S.memoryShow),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _level == 0 ? null : () => _go(_level - 1),
                    child: const Text(S.memoryEasier),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _go(_level + 1),
                    icon: const Icon(Icons.check),
                    label: const Text(S.memoryKnow),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Word extends StatelessWidget {
  const _Word({
    required this.word,
    required this.level,
    required this.hidden,
    required this.onTap,
  });

  final String word;
  final int level;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 21,
      height: 1.4,
      color: Theme.of(context).colorScheme.onSurface,
    );
    if (!hidden) return Text(word, style: style);
    final palette = AppPalette.of(context);
    // Interpunkce zůstává vidět; na kroku 4 i první písmeno.
    final m = RegExp(r'^([„"(]*)(.*?)([.,;:!?“")…]*)$').firstMatch(word)!;
    final core = m.group(2)!;
    final hint = level == 3 && core.isNotEmpty ? core.characters.first : '';
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(m.group(1)!, style: style),
          Container(
            constraints: BoxConstraints(
              minWidth: 14.0 + core.characters.length * 9,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: palette.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(6),
              border: Border(bottom: BorderSide(color: palette.gold, width: 2)),
            ),
            child: Text(hint, style: style.copyWith(color: palette.gold)),
          ),
          Text(m.group(3)!, style: style),
        ],
      ),
    );
  }
}
