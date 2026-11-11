import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/versification.dart';
import '../../content/application/content_providers.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/scene_search.dart';
import '../application/thought_search.dart';
import 'bible_answer_card.dart';

/// Výsledky hledání podle myšlenky: rozpoznané pojmy (dají se vypnout),
/// klíčová místa k tématu a verše s podobnou myšlenkou. Klepnutí otevře
/// verš v Bibli; s [onAdd] má každý výsledek tlačítko „přidat“.
class ThoughtResults extends ConsumerStatefulWidget {
  const ThoughtResults({super.key, required this.text, this.onAdd});

  final String text;

  /// Přidat místo (kanonické číslování) – např. do přípravy.
  final ValueChanged<Passage>? onAdd;

  @override
  ConsumerState<ThoughtResults> createState() => _ThoughtResultsState();
}

class _ThoughtResultsState extends ConsumerState<ThoughtResults> {
  final Set<String> _excluded = {};

  @override
  void didUpdateWidget(ThoughtResults old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) _excluded.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final result = ref.watch(
      thoughtSearchProvider((
        text: widget.text,
        translationId: tid,
        excluded: (_excluded.toList()..sort()).join(','),
      )),
    );
    Widget label(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 4),
      child: Text(
        t.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: palette.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
    final onAdd = widget.onAdd;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: result.when(
        loading: () => [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
        ],
        error: (e, _) => [Text('$e')],
        data: (r) => [
          if (onAdd == null) BibleAnswerCard(query: widget.text),
          if (r.scenes.isNotEmpty) ...[
            label(S.thoughtMaybe),
            for (final h in r.scenes)
              _SceneTile(
                hit: h,
                onAdd: onAdd == null ? null : () => onAdd(h.item.passage),
              ),
          ],
          if (r.concepts.isEmpty && r.scenes.isEmpty)
            Text(
              S.prepThoughtNone,
              style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
            )
          else if (r.concepts.isNotEmpty) ...[
            label(S.prepThoughtUnderstood),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final c in r.concepts)
                  FilterChip(
                    label: Text(c.label),
                    selected: !_excluded.contains(c.id),
                    onSelected: (on) => setState(
                      () => on ? _excluded.remove(c.id) : _excluded.add(c.id),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                S.prepThoughtToggle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ),
          ],
          if (r.keyPassages.isNotEmpty) ...[
            label(S.prepKeyPassages),
            for (final k in r.keyPassages)
              _KeyPassageTile(
                item: k,
                onAdd: onAdd == null ? null : () => onAdd(k.passage),
              ),
          ],
          if (r.hits.isNotEmpty) ...[
            label(S.prepSimilar),
            for (final h in r.hits)
              _ThoughtHitTile(
                hit: h,
                onAdd: onAdd == null
                    ? null
                    : () {
                        final v = h.hit.verse;
                        final c = Versification.toCanonical(
                          v.ref,
                          v.translationId,
                        );
                        onAdd(Passage(c.bookId, c.chapter, c.verse, c.verse));
                      },
              ),
          ] else if (r.keyPassages.isEmpty && r.scenes.isEmpty)
            const Text(S.searchNoResults),
        ],
      ),
    );
  }
}

Widget? _addButton(VoidCallback? onAdd) => onAdd == null
    ? null
    : IconButton.filledTonal(
        tooltip: S.prepAddToPrep,
        icon: const Icon(Icons.add, size: 20),
        onPressed: onAdd,
      );

class _KeyPassageTile extends ConsumerWidget {
  const _KeyPassageTile({required this.item, this.onAdd});

  final KeyPassage item;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final t = ref.watch(primaryTranslationProvider);
    final verses = ref.watch(passageTextProvider((t.id, item.passage))).value;
    final book = ref.watch(bookByIdProvider(item.passage.bookId));
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => openReaderAt(context, ref, item.passage.start),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: item.passage.label(book.name),
              style: TextStyle(color: palette.gold),
            ),
            TextSpan(
              text: '  ${item.label.isEmpty ? item.source : item.label}',
              style: TextStyle(
                color: palette.muted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text(
        verses?.map((v) => v.text.replaceAll('\n', ' ')).join(' ') ?? '…',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _addButton(onAdd),
    );
  }
}

class _ThoughtHitTile extends ConsumerWidget {
  const _ThoughtHitTile({required this.hit, this.onAdd});

  final ThoughtHit hit;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final verse = hit.hit.verse;
    final book = ref.watch(bookByIdProvider(verse.ref.bookId));
    final spans = <TextSpan>[];
    var bold = false;
    for (final part in hit.hit.snippet.split(
      RegExp('[${SearchHit.matchStart}${SearchHit.matchEnd}]'),
    )) {
      spans.add(
        TextSpan(
          text: part.replaceAll('\n', ' '),
          style: bold
              ? TextStyle(fontWeight: FontWeight.w700, color: palette.gold)
              : null,
        ),
      );
      bold = !bold;
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => openReaderAt(
        context,
        ref,
        verse.ref,
        from: schemeOf(verse.translationId),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${book.name} ${verse.ref.chapter},${verse.ref.verse}',
              style: TextStyle(color: palette.gold),
            ),
            if (hit.concepts.length > 1)
              TextSpan(
                text: '  ${hit.concepts.join(' · ')}',
                style: TextStyle(
                  color: palette.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text.rich(TextSpan(children: spans)),
      trailing: _addButton(onAdd),
    );
  }
}

/// Scéna, kterou myšlenka nejspíš popisuje: zvýrazněná karta s názvem,
/// druhem, odkazem a textem verše.
class _SceneTile extends ConsumerWidget {
  const _SceneTile({required this.hit, this.onAdd});

  final SceneHit hit;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final scene = hit.item;
    final t = ref.watch(primaryTranslationProvider);
    final verses = ref.watch(passageTextProvider((t.id, scene.passage))).value;
    final book = ref.watch(bookByIdProvider(scene.passage.bookId));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => openReaderAt(context, ref, scene.passage.start),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: palette.gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  switch (scene.kind) {
                    SceneKind.miracle => Icons.auto_awesome_outlined,
                    SceneKind.parable => Icons.lightbulb_outline,
                    SceneKind.verse => Icons.format_quote_outlined,
                    SceneKind.story => Icons.auto_stories_outlined,
                  },
                  color: palette.gold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scene.title, style: theme.textTheme.titleSmall),
                    Text(
                      '${scene.kind.label} · ${scene.passage.label(book.name)}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.gold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      verses
                              ?.map((v) => v.text.replaceAll('\n', ' '))
                              .join(' ') ??
                          '…',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              ?_addButton(onAdd),
            ],
          ),
        ),
      ),
    );
  }
}
