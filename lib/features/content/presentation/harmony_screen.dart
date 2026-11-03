import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

const _gospels = ['Mt', 'Mk', 'L', 'J'];
const _gospelColors = [
  Color(0xFFB0813B),
  Color(0xFF3F7CAC),
  Color(0xFF2E8B57),
  Color(0xFF8C4A6B),
];

/// Harmonie evangelií – Ježíšův život v časovém pořadí.
class HarmonyScreen extends ConsumerWidget {
  const HarmonyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(harmonyProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    var number = 0;
    return ReadableWidth(
      maxWidth: 860,
      child: Scaffold(
        appBar: AppBar(title: const Text(S.harmony)),
        body: periods == null
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
                    S.harmonyIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  for (final period in periods) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
                      child: Text(
                        period.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: palette.gold,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final e in period.events)
                      _EventCard(number: ++number, event: e),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.number, required this.event});

  final int number;
  final HarmonyEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '$number',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(event.title, style: theme.textTheme.titleSmall),
                ),
                if (event.refs.whereType<Passage>().length > 1)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: S.parallelOpen,
                    icon: Icon(Icons.view_column_outlined, color: palette.gold),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GospelParallelScreen(event: event),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const SizedBox(width: 30),
                for (final (i, p) in event.refs.indexed)
                  Expanded(
                    child: p == null
                        ? Center(
                            child: Text(
                              '—',
                              style: TextStyle(
                                color: palette.muted.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _RefChip(
                              gospel: _gospels[i],
                              color: _gospelColors[i],
                              passage: p,
                            ),
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

class _RefChip extends StatelessWidget {
  const _RefChip({
    required this.gospel,
    required this.color,
    required this.passage,
  });

  final String gospel;
  final Color color;
  final Passage passage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showPassageSheet(context, passage),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            children: [
              Text(
                gospel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  passage.shortLabel,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Událost ve všech evangeliích vedle sebe. Slova, která má jen jedno
/// z nich, jsou vyznačena jeho barvou – rozdíly jsou vidět na první
/// pohled.
class GospelParallelScreen extends ConsumerStatefulWidget {
  const GospelParallelScreen({super.key, required this.event});

  final HarmonyEvent event;

  @override
  ConsumerState<GospelParallelScreen> createState() =>
      _GospelParallelScreenState();
}

class _GospelParallelScreenState extends ConsumerState<GospelParallelScreen> {
  bool _marks = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translation = ref.watch(primaryTranslationProvider);
    final columns = [
      for (final (i, p) in widget.event.refs.indexed)
        if (p != null) (i, p),
    ];
    final texts = [
      for (final (_, p) in columns)
        ref.watch(passageTextProvider((translation.id, p))).value,
    ];
    final loaded = texts.every((t) => t != null);
    // Kmeny slov každého evangelia.
    final stems = [
      for (final t in texts)
        {for (final v in t ?? const <Verse>[]) ...wordStems(v.text)},
    ];
    Set<String> unique(int k) => {
      for (final w in stems[k])
        if (!stems.indexed.any((e) => e.$1 != k && e.$2.contains(w))) w,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        actions: [
          IconButton(
            tooltip: S.parallelMarks,
            isSelected: _marks,
            icon: const Icon(Icons.format_color_text_outlined),
            selectedIcon: const Icon(Icons.format_color_text),
            onPressed: () => setState(() => _marks = !_marks),
          ),
        ],
      ),
      body: !loaded
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, c) {
                const minWidth = 250.0;
                final fits = c.maxWidth / columns.length >= minWidth;
                final colWidth = fits
                    ? (c.maxWidth - 16) / columns.length
                    : minWidth;
                final row = Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (k, (i, p)) in columns.indexed)
                      SizedBox(
                        width: colWidth,
                        child: _GospelColumn(
                          gospel: _gospelNames[i],
                          color: _gospelColors[i],
                          passage: p,
                          verses: texts[k]!,
                          unique: _marks ? unique(k) : const {},
                        ),
                      ),
                  ],
                );
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    8,
                    0,
                    8,
                    MediaQuery.paddingOf(context).bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                        child: Text(
                          _marks ? S.parallelHint : S.parallelHintPlain,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                      ),
                      if (fits)
                        row
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: row,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

const _gospelNames = ['Matouš', 'Marek', 'Lukáš', 'Jan'];

class _GospelColumn extends ConsumerWidget {
  const _GospelColumn({
    required this.gospel,
    required this.color,
    required this.passage,
    required this.verses,
    required this.unique,
  });

  final String gospel;
  final Color color;
  final Passage passage;
  final List<Verse> verses;
  final Set<String> unique;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final settings = ref.watch(readerSettingsProvider);
    final style = TextStyle(
      fontFamily: settings.readingFont.family,
      fontSize: 16,
      height: 1.55,
      color: theme.colorScheme.onSurface,
    );
    final mark = color.withValues(alpha: 0.2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => openReaderAt(context, ref, passage.start),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: color, width: 3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gospel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          passage.shortLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 16, color: color),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                for (final v in verses) ...[
                  TextSpan(
                    text: '${v.number} ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  for (final part in RegExp(r'\S+|\s+').allMatches(v.text))
                    TextSpan(
                      text: part.group(0),
                      style:
                          unique.isNotEmpty &&
                              wordStems(part.group(0)!).any(unique.contains)
                          ? TextStyle(backgroundColor: mark)
                          : null,
                    ),
                  const TextSpan(text: ' '),
                ],
              ],
            ),
            style: style,
          ),
        ],
      ),
    );
  }
}

const _plain = {
  'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e', 'í': 'i', 'ň': 'n', //
  'ó': 'o', 'ř': 'r', 'š': 's', 'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y', //
  'ž': 'z',
};

/// Častá slova bez obsahu (spojky, zájmena, „řekl“…) – rozdíly v nich
/// nic neříkají.
const _stop = {
  'jest', 'jsou', 'jsem', 'jste', 'jsme', 'bude', 'budou', 'byl', 'byla', //
  'bylo', 'byli', 'byly', 'tedy', 'tehdy', 'kdyz', 'jemu', 'nemu', 'jeho', //
  'jejich', 'jeji', 'nebo', 'nebot', 'abych', 'abychom', 'ktery', 'ktera', //
  'ktere', 'kterez', 'kteryz', 'tento', 'tato', 'toto', 'tentot', 'tomu', //
  'takto', 'take', 'vsak', 'totiz', 'onen', 'mezi', 'jako', 'proto', //
  'svuj', 'svym', 'sveho', 'svou', 'sve', 'mnou', 'tobe', 'tebe', 'sobe', //
  'nami', 'vami', 'jemuz', 'nimz', 'nich', 'nimi', 'rekl', 'rekla', 'rekli', //
  'rkouci', 'rekouci', 'rkuce', 'odpovidaje', 'odpovedel', 'odpovedeli', //
  'pravi', 'pravil', 'vsecko', 'vsecky', 'vsickni', 'velmi', 'hned', 'ihned', //
  'potom', 'nyni', 'kdez', 'kterak', 'kdyby', 'aneb', 'ackoli', //
  'tez', 'tehdaz', 'jenz', 'jez', 'kteriz', 'tuto', 'teto', 'tech', 'techto',
};

/// Zjednodušené kmeny slov pro porovnání evangelií: malá písmena bez
/// diakritiky, prvních pět písmen (čeština skloňuje), krátká slova
/// (spojky, předložky) se vynechají.
Iterable<String> wordStems(String text) sync* {
  for (final m in RegExp(r'\p{L}+', unicode: true).allMatches(text)) {
    final w = m.group(0)!.toLowerCase().split('').map((c) => _plain[c] ?? c);
    final plain = w.join();
    if (plain.length < 4 || _stop.contains(plain)) continue;
    yield plain.length > 5 ? plain.substring(0, 5) : plain;
  }
}
