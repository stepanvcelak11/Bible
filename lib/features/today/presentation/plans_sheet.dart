import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

Future<void> showPlansSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => const _PlansSheet(),
);

class _PlansSheet extends ConsumerWidget {
  const _PlansSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(planProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      children: [
        Text(S.readingPlan, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          S.planIntro,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 16),
        Card(
          color: palette.gold.withValues(alpha: 0.12),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
            leading: Icon(Icons.tune, color: palette.gold),
            title: const Text(S.customPlan),
            subtitle: const Text(S.customPlanHint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CustomPlanScreen()),
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (final plan in readingPlans)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                title: Text(plan.name),
                subtitle: Text('${plan.description}\n${plan.days} dní'),
                isThreeLine: true,
                trailing: active?.plan.id == plan.id
                    ? Icon(Icons.check_circle, color: palette.gold)
                    : FilledButton.tonal(
                        onPressed: () async {
                          await ref.read(planProvider.notifier).start(plan.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text(S.startPlan),
                      ),
              ),
            ),
          ),
        if (active != null)
          TextButton.icon(
            onPressed: () async {
              await ref.read(planProvider.notifier).stop();
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text(S.stopPlan),
          ),
      ],
    );
  }
}

/// Vlastní plán: výběr knih a počtu dní.
class CustomPlanScreen extends ConsumerStatefulWidget {
  const CustomPlanScreen({super.key});

  @override
  ConsumerState<CustomPlanScreen> createState() => _CustomPlanScreenState();
}

class _CustomPlanScreenState extends ConsumerState<CustomPlanScreen> {
  final _books = <int>{};
  double _days = 30;

  static List<int> _range(int a, int b) => [for (var i = a; i <= b; i++) i];

  static final _presets = [
    (S.presetNt, _range(40, 66)),
    (S.presetGospels, _range(40, 43)),
    (S.presetPaul, _range(45, 57)),
    (S.presetOt, _range(1, 39)),
    (S.presetTorah, _range(1, 5)),
    (S.presetWisdom, _range(18, 22)),
    (S.presetProphets, _range(23, 39)),
    (S.presetBible, _range(1, 66)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts = ref.watch(chapterCountsProvider(translationId)).value;
    final selected = [
      for (final b in books)
        if (_books.contains(b.id)) b.id,
    ];
    final chapters = counts == null
        ? 0
        : selected.fold<int>(0, (sum, b) => sum + (counts[b] ?? 0));
    final maxDays = chapters.clamp(1, 365);
    final days = _days.round().clamp(1, maxDays);
    final perDay = chapters == 0 ? 0.0 : chapters / days;

    Widget bookChip(Book b) => FilterChip(
      label: Text(b.abbreviation),
      tooltip: b.name,
      selected: _books.contains(b.id),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      onSelected: (on) =>
          setState(() => on ? _books.add(b.id) : _books.remove(b.id)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text(S.customPlan)),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Text(
              S.customPlanIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            const SectionLabel(S.quickChoice),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (label, ids) in _presets)
                  ActionChip(
                    label: Text(label),
                    onPressed: () => setState(
                      () => _books
                        ..clear()
                        ..addAll(ids),
                    ),
                  ),
              ],
            ),
            SectionLabel(
              S.oldTestament,
              action: _books.isEmpty ? null : S.clearSelection,
              onAction: () => setState(_books.clear),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final b in books)
                  if (b.id <= 39) bookChip(b),
              ],
            ),
            const SectionLabel(S.newTestament),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final b in books)
                  if (b.id >= 40) bookChip(b),
              ],
            ),
            const SectionLabel(S.planLength),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: days.toDouble(),
                    min: 1,
                    max: maxDays.toDouble(),
                    divisions: maxDays > 1 ? maxDays - 1 : null,
                    onChanged: chapters == 0
                        ? null
                        : (v) => setState(() => _days = v),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    S.daysCount(days),
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  chapters == 0
                      ? S.customPlanPick
                      : S.customPlanSummary(
                          selected.length,
                          chapters,
                          perDay
                              .toStringAsFixed(perDay < 10 ? 1 : 0)
                              .replaceAll('.', ','),
                        ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: chapters == 0
                  ? null
                  : () async {
                      final navigator = Navigator.of(context);
                      await ref
                          .read(planProvider.notifier)
                          .start(customPlanId(selected, days));
                      navigator.popUntil((r) => r.isFirst);
                    },
              icon: const Icon(Icons.play_arrow),
              label: const Text(S.startPlan),
            ),
          ],
        ),
      ),
    );
  }
}
