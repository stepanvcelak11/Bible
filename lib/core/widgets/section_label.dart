import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Nadpis sekce: malý, prostrkaný verzálkami – stejný na všech
/// přehledových obrazovkách (Dnes, Studium). Volitelně odkaz vpravo.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 26, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: palette.muted,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}
