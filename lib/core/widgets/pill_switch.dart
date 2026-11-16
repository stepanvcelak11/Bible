import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Jedna volba přepínače [PillSwitch].
@immutable
class PillOption<T> {
  const PillOption(this.value, this.label, {this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Přepínač několika voleb v jedné liště: vybraná volba leží na světlé
/// „pilulce“, která se k nové volbě plynule přesune. Jednotný vzhled pro
/// celou aplikaci (místo různých segmentových tlačítek).
class PillSwitch<T> extends StatelessWidget {
  const PillSwitch({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<PillOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final index = options.indexWhere((o) => o.value == value);
    final n = options.length;
    final compact = n > 3;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          if (index >= 0)
            Positioned.fill(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment(n == 1 ? 0 : -1 + 2 * index / (n - 1), 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / n,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: palette.gold.withValues(alpha: 0.45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              for (final (i, o) in options.indexed)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == index,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onChanged(o.value),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (o.icon case final icon?) ...[
                              Icon(
                                icon,
                                size: 18,
                                color: i == index
                                    ? palette.gold
                                    : palette.muted,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Flexible(
                              child: Text(
                                o.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    (compact
                                            ? theme.textTheme.labelMedium
                                            : theme.textTheme.labelLarge)
                                        ?.copyWith(
                                          color: i == index
                                              ? theme.colorScheme.onSurface
                                              : palette.muted,
                                          fontWeight: i == index
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
