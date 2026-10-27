import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/strings_cs.dart';
import 'features/reader/presentation/reader_screen.dart';

const _czech = Locale('cs', 'CZ');

/// Přibalené písmo – funguje offline i na webu.
const _font = 'Literata';

/// Kořenový widget aplikace. Motivy (světlý / tmavý / sépie) a typografie
/// se plně rozpracují v kroku 2.
class BibleApp extends StatelessWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6B5B45); // teplá hnědá – klidný „papírový“ tón
    return MaterialApp(
      title: S.appName,
      debugShowCheckedModeBanner: false,
      locale: _czech,
      supportedLocales: const [_czech],
      // Systémové texty (kopírovat/vložit, dialogy…) také česky.
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.light,
        fontFamily: _font,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        fontFamily: _font,
      ),
      home: const ReaderScreen(),
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
      theme: ThemeData(fontFamily: _font),
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
