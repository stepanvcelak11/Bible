import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/install/browser_chrome.dart';
import 'core/l10n/strings_cs.dart';
import 'core/theme/app_background.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/reader_settings.dart';
import 'features/shell/home_shell.dart';
import 'features/settings/application/reader_settings_controller.dart';

const _czech = Locale('cs', 'CZ');

/// Kořenový widget aplikace. Motiv (systém / světlý / sépie / tmavý) se
/// mění plynule podle nastavení.
class BibleApp extends ConsumerWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(readerSettingsProvider.select((s) => s.themeMode));
    final accent = ref.watch(readerSettingsProvider.select((s) => s.accent));
    return MaterialApp(
      title: S.appName,
      debugShowCheckedModeBanner: false,
      locale: _czech,
      supportedLocales: const [_czech],
      // Systémové texty (kopírovat/vložit, dialogy…) také česky.
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: withAppBackground(AppTheme.forMode(mode, accent)),
      darkTheme: withAppBackground(AppTheme.dark(accent)),
      themeMode: switch (mode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.dark => ThemeMode.dark,
        _ => ThemeMode.light,
      },
      themeAnimationDuration: const Duration(milliseconds: 350),
      builder: (context, child) {
        // Stavový řádek nainstalované aplikace v barvě pozadí.
        final color = Theme.of(context).colorScheme.surface;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => setBrowserThemeColor(color),
        );
        return child!;
      },
      home: const HomeShell(),
    );
  }
}

/// Náhradní aplikace pro případ, že se nepodaří připravit data.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.dataMissing, this.error});

  final bool dataMissing;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: _czech,
      supportedLocales: const [_czech],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataMissing ? S.dataMissingTitle : S.errorTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                SelectableText(dataMissing ? S.dataMissingBody : '$error'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
