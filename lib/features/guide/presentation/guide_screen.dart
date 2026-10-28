import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../shell/home_shell.dart';

/// Jedna část průvodce: záložka aplikace a co v ní najdu.
class _GuidePart {
  const _GuidePart(this.tab, this.icon, this.color, this.title, this.points);

  /// `null` = Nastavení (nejsou samostatnou záložkou).
  final AppTab? tab;
  final IconData icon;
  final Color color;
  final String title;
  final List<String> points;
}

const _parts = [
  _GuidePart(AppTab.today, Icons.wb_sunny_outlined, Color(0xFFE0782F), 'Dnes', [
    'Verš dne – klepnutím na sdílení z něj uděláte obrázek.',
    'Moje čtení – pokračování tam, kde jste skončili, statistiky '
        'a plán čtení.',
    'Na dnešek – otázka dne, verše k opakování a modlitby.',
    'Verše pro tuto chvíli a církevní rok s nejbližším svátkem.',
  ]),
  _GuidePart(
    AppTab.bible,
    Icons.menu_book_outlined,
    Color(0xFFB0813B),
    'Bible',
    [
      'Kapitoly listujete přejetím prstem do stran.',
      'Název kapitoly nahoře → výběr knihy a kapitoly.',
      'Klepnutí na verš → zvýraznit, záložka, poznámka, kopírovat, '
          'sdílet, studium (původní text, slovník, souvislosti) a „Učit se“ '
          '– verš nazpaměť.',
      'Zkratka překladu (např. BKR) → jiný překlad, nebo dva překlady '
          'vedle sebe.',
      'Ikona karet → víc otevřených míst najednou; každá karta může mít '
          'i jiný překlad, takže překlady porovnáte přepnutím karty.',
      'Tlačítka nad kapitolou → úvod ke knize, aplikační poznámky, '
          'medailony postav a místa na mapě.',
      'Na konci kapitoly → zamyšlení krok za krokem s otázkami přímo '
          'k této kapitole (uloží se do Deníku) a další kapitola.',
      'Menu ⋮ → předčítání nahlas, místa v kapitole, překlady, nastavení.',
    ],
  ),
  _GuidePart(
    AppTab.study,
    Icons.school_outlined,
    Color(0xFF8C4A6B),
    'Studium',
    [
      'Čtyři oddíly – skočíte na ně štítky nahoře:',
      'Bible jako celek – strom Bible, velký příběh, červené nitě, mapa '
          'odkazů, časová osa a mapy.',
      'Pro život – verše do situací, témata, verše nazpaměť, modlitby, '
          'kvíz, církevní rok a plány čtení.',
      'Knihy a postavy – úvody ke knihám, medailony, aplikační poznámky, '
          'tabulky a harmonie evangelií.',
      'Nástroje – původní text se slovníkem a překlady.',
    ],
  ),
  _GuidePart(AppTab.search, Icons.search, Color(0xFF3F7CAC), 'Hledat', [
    'Diakritiku psát nemusíte – „laska“ najde i „láska“.',
    'Přesnou frázi dejte do uvozovek, odkaz napište jako J 3,16.',
    'Jedno hledání pro celou aplikaci – verše i postavy, témata, '
        'situace a úvody ke knihám.',
  ]),
  _GuidePart(
    AppTab.journal,
    Icons.bookmarks_outlined,
    Color(0xFF5B7A3A),
    'Deník',
    [
      'Vaše záložky, poznámky a zvýraznění na jednom místě; lupa '
          'v nich hledá.',
      'Nahoře rychlé odkazy: Můj pokrok, Verše nazpaměť a Plán čtení; '
          'vpravo nastavení.',
      'Modlitby – zapisujte prosby, označujte vyslyšené; „Čas modlitby“ '
          'vás jimi provede.',
      'Položku smažete přejetím doleva (lze vrátit).',
      'Zálohu uložíte v Nastavení.',
    ],
  ),
  _GuidePart(null, Icons.tune, Color(0xFF4E9A8A), 'Nastavení', [
    'Najdete je vpravo nahoře na stránce Dnes.',
    'Vzhled (světlý, sépie, tmavý), barva, pozadí, písmo a řádkování.',
    'Stažení dalších překladů (B21, ČEP, ČSP…) a studijního balíčku.',
    'Záloha a obnovení dat.',
  ]),
];

/// Průvodce aplikací: co je kde a jak se to ovládá.
class GuideScreen extends ConsumerWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    void go(_GuidePart part) {
      final navigator = Navigator.of(context);
      if (part.tab case final tab?) {
        navigator.popUntil((r) => r.isFirst);
        ref.read(shellTabProvider.notifier).select(tab);
      } else {
        navigator.pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text(S.guide)),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Text(
                S.guideIntro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
            ),
            for (final part in _parts)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: part.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(part.icon, color: part.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              part.title,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          TextButton(
                            onPressed: () => go(part),
                            child: const Text(S.guideOpen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final p in part.points)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 8, 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: part.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  p,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void openGuide(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const GuideScreen()));
