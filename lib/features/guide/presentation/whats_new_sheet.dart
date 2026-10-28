import 'package:flutter/material.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import 'guide_screen.dart';

/// Verze přehledu novinek – zvýšit při další velké aktualizaci.
const whatsNewVersion = 5;

const _items = [
  (
    Icons.donut_large,
    'Církevní rok',
    'Kruh roku s adventem, Vánocemi, postem a Velikonocemi, nejbližší '
        'svátek na stránce Dnes a čtení ke každé době i svátku.',
  ),
  (
    Icons.event_note_outlined,
    'Sezónní plány čtení',
    'Advent (24 dní), Postní doba (40 dní) a Velikonoce (50 dní) – '
        'najdete je v plánech i v Církevním roce.',
  ),
  (
    Icons.text_fields,
    'Ozdobná iniciála',
    'Kapitola začíná velkým písmenem jako v tištěné Bibli, text ho '
        'obtéká. Vypnout jde v Nastavení.',
  ),
  (
    Icons.manage_search,
    'Hledání v Deníku',
    'Lupa v Deníku najde záložky, poznámky i zvýraznění podle knihy, '
        'odkazu nebo textu poznámky. Zvýraznění filtrujete podle barvy.',
  ),
  (
    Icons.translate,
    'Verš ve všech překladech',
    'Klepněte na verš → Studovat → Překlady: verš ve všech stažených '
        'překladech pod sebou (podržením zkopírujete).',
  ),
  (
    Icons.style_outlined,
    'Opakování veršů nazpaměť',
    'Doporučené verše přidáte jedním klepnutím, „Opakovat vše“ vás '
        'vyzkouší jako kartičky.',
  ),
  (
    Icons.event_available_outlined,
    'Plán čtení',
    'Karta plánu ukazuje, zda jste napřed, nebo pozadu, a odškrtává už '
        'přečtené kapitoly.',
  ),
  (
    Icons.today_outlined,
    'Na dnešek',
    'Na stránce Dnes otázka dne z kvízu a připomínka veršů k opakování '
        'a modliteb.',
  ),
  (
    Icons.diversity_1_outlined,
    'Související postavy',
    'V medailonu postavy klepnete na příbuzné a přejdete na jejich '
        'medailon.',
  ),
  (
    Icons.palette_outlined,
    'Barvy aplikace',
    'V Nastavení si vyberte barvu: zlatou, olivovou, modrou, švestkovou '
        'nebo terakotu.',
  ),
  (
    Icons.volunteer_activism_outlined,
    'Modlitební seznam',
    'V Deníku zapisujte, za co se modlíte, a označujte vyslyšené '
        'modlitby. „Čas modlitby“ vás jimi provede jednu po druhé.',
  ),
  (
    Icons.emoji_events_outlined,
    'Biblický kvíz',
    '77 otázek ve Studiu – po každé odpovědi uvidíte verš, kde je '
        'odpověď.',
  ),
  (
    Icons.timer_outlined,
    'Délka kapitoly',
    'V záhlaví kapitoly počet veršů, odhad času čtení a značka '
        '„přečteno“.',
  ),
  (
    Icons.playlist_add_check,
    'Označení přečteného',
    'Co jste četli dřív mimo aplikaci, si odškrtnete v Mém pokroku – '
        'po kapitolách, knihách i celých oddílech.',
  ),
  (
    Icons.landscape_outlined,
    'Nový vzhled',
    'Stránka Dnes s krajinou podle denní doby, Studium jako barevné '
        'dlaždice.',
  ),
  (
    Icons.insights,
    'Můj pokrok',
    'Kalendář čtení, odznaky a mapa přečtené Bible. Klepněte na '
        'statistiky na stránce Dnes.',
  ),
  (
    Icons.tab_outlined,
    'Čtecí karty',
    'Víc míst v Bibli najednou – každá karta i v jiném překladu.',
  ),
  (
    Icons.psychology_outlined,
    'Verše nazpaměť',
    'Klepněte na verš a zvolte „Učit se“.',
  ),
  (
    Icons.lightbulb_outline,
    'Biblická témata',
    '38 témat víry a života se shrnutím a klíčovými místy.',
  ),
  (
    Icons.self_improvement,
    'Zamyšlení nad kapitolou',
    'Na konci každé kapitoly čtyři otázky; odpovědi se uloží do Deníku.',
  ),
  (
    Icons.event_note_outlined,
    'Plány čtení',
    'Vlastní plán z vybraných knih, Bible v kostce a další.',
  ),
  (
    Icons.diversity_3_outlined,
    'Víc studijního obsahu',
    '160 medailonů postav, 128 aplikačních poznámek, 15 tabulek.',
  ),
];

Future<void> showWhatsNew(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (sheet) {
    final theme = Theme.of(sheet);
    final palette = AppPalette.of(sheet);
    return SizedBox(
      height: MediaQuery.sizeOf(sheet).height * 0.9,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              children: [
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [palette.gold, palette.heroEnd],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  S.whatsNew,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  S.whatsNewIntro,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                ),
                const SizedBox(height: 16),
                for (final (icon, title, text) in _items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: palette.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: palette.gold),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: theme.textTheme.titleSmall),
                              const SizedBox(height: 2),
                              Text(
                                text,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: palette.muted,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Tlačítka vždy vidět, bez posouvání.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(sheet).pop();
                      openGuide(context);
                    },
                    child: const Text(S.guide),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(sheet).pop(),
                    child: const Text(S.letsGo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
