import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../memory/application/memory_controller.dart';
import '../application/prayer_controller.dart';

String _date(DateTime d) => '${d.day}. ${d.month}. ${d.year}';

void openPrayers(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PrayersScreen()));

/// Samostatná obrazovka modlitebního seznamu (ze Studia).
class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) => ReadableWidth(
    child: Scaffold(
      appBar: AppBar(title: const Text(S.prayerList)),
      body: const PrayersView(),
    ),
  );
}

/// Modlitební seznam: souhrnná karta, aktivní a vyslyšené modlitby.
class PrayersView extends ConsumerWidget {
  const PrayersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayers = ref.watch(prayerProvider);
    final active = [
      for (final p in prayers)
        if (!p.isAnswered) p,
    ];
    final answered = [
      for (final p in prayers)
        if (p.isAnswered) p,
    ]..sort((a, b) => b.answered!.compareTo(a.answered!));

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 110,
      ),
      children: [
        _HeroCard(active: active, answered: answered.length),
        if (prayers.isEmpty) ...[
          const SectionLabel(S.prayerSuggestions),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final idea in S.prayerIdeas)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(idea),
                  onPressed: () => showPrayerEditor(context, initial: idea),
                ),
            ],
          ),
        ],
        if (active.isNotEmpty) ...[
          SectionLabel('${S.prayerActive} (${active.length})'),
          for (final p in active) _PrayerCard(prayer: p),
        ],
        if (answered.isNotEmpty) ...[
          SectionLabel('${S.prayerAnsweredSection} (${answered.length})'),
          for (final p in answered) _PrayerCard(prayer: p),
        ],
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.active, required this.answered});

  final List<Prayer> active;
  final int answered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final on = palette.onHero;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.heroEnd, palette.heroStart],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volunteer_activism, color: on, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.prayerList,
                  style: theme.textTheme.titleLarge?.copyWith(color: on),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            active.isEmpty && answered == 0
                ? S.prayerIntro
                : S.prayerSummary(active.length, answered),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: on.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (active.isNotEmpty)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: on,
                    foregroundColor: palette.heroStart,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      fullscreenDialog: true,
                      builder: (_) =>
                          PrayerTimeScreen(ids: [for (final p in active) p.id]),
                    ),
                  ),
                  icon: const Icon(Icons.self_improvement),
                  label: const Text(S.prayerTime),
                ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: on,
                  side: BorderSide(color: on.withValues(alpha: 0.5)),
                ),
                onPressed: () => showPrayerEditor(context),
                icon: const Icon(Icons.add),
                label: const Text(S.prayerAdd),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerCard extends ConsumerWidget {
  const _PrayerCard({required this.prayer});

  final Prayer prayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    const green = Color(0xFF3E8E5E);
    final p = prayer;
    final meta = [
      if (p.isAnswered)
        S.prayerAnsweredOn(_date(p.answered!))
      else
        S.prayerAddedOn(_date(p.created)),
      if (p.prayed > 0) S.prayerPrayedTimes(p.prayed),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          onTap: () => showPrayerEditor(context, existing: p),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (p.isAnswered ? green : palette.gold).withValues(
                      alpha: 0.15,
                    ),
                  ),
                  child: Icon(
                    p.isAnswered ? Icons.check : Icons.favorite_outline,
                    size: 20,
                    color: p.isAnswered ? green : palette.gold,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.text, style: theme.textTheme.bodyLarge),
                      if (p.answer.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          p.answer,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: green,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        meta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!p.isAnswered)
                  IconButton(
                    tooltip: S.prayerPrayed,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(prayerProvider.notifier).markPrayed(p.id);
                    },
                    icon: Icon(Icons.done_all, color: palette.muted),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Editor modlitby: text, u existující i „vyslyšeno“ a smazání.
Future<void> showPrayerEditor(
  BuildContext context, {
  Prayer? existing,
  String? initial,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _PrayerEditor(existing: existing, initial: initial),
);

class _PrayerEditor extends ConsumerStatefulWidget {
  const _PrayerEditor({this.existing, this.initial});

  final Prayer? existing;
  final String? initial;

  @override
  ConsumerState<_PrayerEditor> createState() => _PrayerEditorState();
}

class _PrayerEditorState extends ConsumerState<_PrayerEditor> {
  late final _text = TextEditingController(
    text: widget.existing?.text ?? widget.initial ?? '',
  );
  late final _answer = TextEditingController(
    text: widget.existing?.answer ?? '',
  );
  late bool _answered = widget.existing?.isAnswered ?? false;

  @override
  void dispose() {
    _text.dispose();
    _answer.dispose();
    super.dispose();
  }

  void _save() {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final ctl = ref.read(prayerProvider.notifier);
    final existing = widget.existing;
    if (existing == null) {
      ctl.add(text);
    } else {
      ctl.replace(existing.copyWith(text: text));
      ctl.setAnswered(
        existing.id,
        answered: _answered,
        answer: _answered ? _answer.text.trim() : existing.answer,
      );
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    final existing = widget.existing!;
    final messenger = ScaffoldMessenger.of(context);
    final ctl = ref.read(prayerProvider.notifier)..remove(existing.id);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(S.deleted),
          action: SnackBarAction(
            label: S.undo,
            onPressed: () => ctl.restore(existing),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final existing = widget.existing;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            existing == null ? S.prayerAdd : S.prayerEdit,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _text,
            autofocus: existing == null,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: S.prayerTextHint,
              border: OutlineInputBorder(),
            ),
          ),
          if (existing != null) ...[
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.check_circle_outline),
              title: const Text(S.prayerAnswered),
              value: _answered,
              onChanged: (v) => setState(() => _answered = v),
            ),
            if (_answered)
              TextField(
                controller: _answer,
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: S.prayerAnswerHint,
                  border: OutlineInputBorder(),
                ),
              ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              if (existing != null)
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(S.prayerDelete),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              const Spacer(),
              FilledButton(onPressed: _save, child: const Text(S.prayerSave)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Klidné procházení modliteb jedna po druhé; „Pomodleno“ zvýší počítadlo.
class PrayerTimeScreen extends ConsumerStatefulWidget {
  const PrayerTimeScreen({super.key, required this.ids});

  final List<int> ids;

  @override
  ConsumerState<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends ConsumerState<PrayerTimeScreen> {
  var _index = 0;

  void _next() {
    HapticFeedback.lightImpact();
    ref.read(prayerProvider.notifier).markPrayed(widget.ids[_index]);
    setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final on = palette.onHero;
    final prayers = ref.watch(prayerProvider);
    final n = widget.ids.length;
    final done = _index >= n;
    final current = done
        ? null
        : prayers.where((p) => p.id == widget.ids[_index]).firstOrNull;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.heroStart, palette.heroEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: on),
                    ),
                    Expanded(
                      child: Text(
                        S.prayerTime,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(color: on),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        done ? '' : S.prayerStep(_index + 1, n),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: on.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: n == 0 ? 1 : _index / n,
                      minHeight: 4,
                      color: on,
                      backgroundColor: on.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: done
                        ? const _PrayerDone(key: ValueKey('done'))
                        : Center(
                            key: ValueKey(_index),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_outline,
                                    color: on.withValues(alpha: 0.6),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    current?.text ?? '',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(color: on, height: 1.35),
                                  ),
                                  if (current != null &&
                                      current.prayed > 0) ...[
                                    const SizedBox(height: 14),
                                    Text(
                                      S.prayerPrayedTimes(current.prayed),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: on.withValues(alpha: 0.65),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: on,
                      foregroundColor: palette.heroStart,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    onPressed: done ? () => Navigator.of(context).pop() : _next,
                    child: Text(done ? S.close : S.prayerNext),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Závěr modlitby s veršem Fp 4,6–7 v hlavním překladu.
class _PrayerDone extends ConsumerWidget {
  const _PrayerDone({super.key});

  static const _verse = MemoryVerse(VerseRef(50, 4, 6), 7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final on = AppPalette.of(context).onHero;
    final text = ref.watch(memoryTextProvider(_verse)).value;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(Icons.wb_sunny_outlined, color: on, size: 40),
            const SizedBox(height: 14),
            Text(
              S.prayerDoneTitle,
              style: theme.textTheme.displaySmall?.copyWith(color: on),
            ),
            const SizedBox(height: 8),
            Text(
              S.prayerDoneBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: on.withValues(alpha: 0.85),
              ),
            ),
            if (text != null) ...[
              const SizedBox(height: 28),
              Text(
                '„$text“',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: on,
                  fontFamily: appFontFamily,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Filipským 4,6–7',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: on.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
