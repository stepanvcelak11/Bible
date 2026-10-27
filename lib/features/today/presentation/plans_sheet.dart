import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/bible_content.dart';
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
