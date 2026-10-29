import 'package:flutter/material.dart';

import '../l10n/strings_cs.dart';
import '../theme/app_theme.dart';
import 'app_install.dart';

/// Nabídka „Nainstalovat aplikaci“ – jen když ji prohlížeč umí provést
/// (Android, Chrome). Po instalaci se aplikace otevírá bez lišty prohlížeče.
class InstallBanner extends StatelessWidget {
  const InstallBanner({super.key, this.padding = EdgeInsets.zero});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppInstall.instance.available,
      builder: (context, available, _) {
        if (!available) return const SizedBox.shrink();
        final theme = Theme.of(context);
        final palette = AppPalette.of(context);
        return Padding(
          padding: padding,
          child: Card(
            margin: EdgeInsets.zero,
            color: palette.gold.withValues(alpha: 0.14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.install_mobile, color: palette.gold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          S.installTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(S.installText, style: theme.textTheme.bodySmall),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: AppInstall.instance.install,
                      icon: const Icon(Icons.add_to_home_screen),
                      label: const Text(S.installAction),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
