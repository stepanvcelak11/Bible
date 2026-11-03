import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../shell/home_shell.dart';
import '../application/content_providers.dart';
import 'people_screen.dart';

/// Osoba v rodokmenu mimo hlavní linii (manželka, další dítě).
class FamilyLink {
  const FamilyLink(this.name, {this.person, this.ref, this.note});

  final String name;

  /// Id medailonu v people.json (pokud existuje).
  final String? person;
  final VerseRef? ref;
  final String? note;
}

/// Člen hlavní linie rodokmenu (od Adama k Ježíši).
class FamilyNode {
  const FamilyNode(
    this.name,
    this.ref, {
    this.person,
    this.note,
    this.spouses = const [],
    this.children = const [],
    this.section,
  });

  final String name;

  /// Kde je v Bibli (kanonické číslování).
  final VerseRef ref;
  final String? person;
  final String? note;
  final List<FamilyLink> spouses;

  /// Další děti (sourozenci dalšího člena linie).
  final List<FamilyLink> children;

  /// Nadpis oddílu, který touto osobou začíná.
  final String? section;
}

/// Linie zaslíbení od Adama k Ježíši (Gn 5; Gn 11; Rt 4; 1Pa 1–3; Mt 1).
/// Vlastní zpracování aplikace.
const familyLine = [
  FamilyNode(
    'Adam',
    VerseRef(1, 5, 1),
    person: 'adam',
    section: 'Od Adama k Noemovi (Gn 5)',
    note: 'První člověk, stvořený k Božímu obrazu.',
    spouses: [FamilyLink('Eva', person: 'eva', ref: VerseRef(1, 3, 20))],
    children: [
      FamilyLink('Kain', person: 'kain', ref: VerseRef(1, 4, 1)),
      FamilyLink('Ábel', person: 'abel', ref: VerseRef(1, 4, 2)),
    ],
  ),
  FamilyNode('Šét', VerseRef(1, 5, 3), note: 'Narozen místo Ábela.'),
  FamilyNode(
    'Enóš',
    VerseRef(1, 5, 6),
    note: 'Tehdy se začalo vzývat Hospodinovo jméno (Gn 4,26).',
  ),
  FamilyNode('Kénan', VerseRef(1, 5, 9)),
  FamilyNode('Mahalalel', VerseRef(1, 5, 12)),
  FamilyNode('Jered', VerseRef(1, 5, 15)),
  FamilyNode(
    'Henoch',
    VerseRef(1, 5, 18),
    person: 'henoch',
    note: 'Chodil s Bohem a Bůh ho vzal k sobě (Gn 5,24).',
  ),
  FamilyNode(
    'Metúšelach',
    VerseRef(1, 5, 21),
    note: 'Nejdelší věk v Bibli – 969 let.',
  ),
  FamilyNode('Lámech', VerseRef(1, 5, 25)),
  FamilyNode(
    'Noe',
    VerseRef(1, 5, 29),
    person: 'noe',
    note: 'Zachráněn s rodinou z potopy; Bůh s ním uzavřel smlouvu.',
    children: [
      FamilyLink('Cham', ref: VerseRef(1, 9, 18)),
      FamilyLink('Jefet', ref: VerseRef(1, 9, 18)),
    ],
  ),
  FamilyNode(
    'Šém',
    VerseRef(1, 11, 10),
    section: 'Od Noema k Abrahamovi (Gn 11)',
    note: 'Praotec Semitů.',
  ),
  FamilyNode('Arpakšad', VerseRef(1, 11, 12)),
  FamilyNode('Šelach', VerseRef(1, 11, 14)),
  FamilyNode(
    'Eber',
    VerseRef(1, 11, 16),
    note: 'Od jeho jména se odvozuje slovo „Hebrej“.',
  ),
  FamilyNode(
    'Peleg',
    VerseRef(1, 11, 18),
    note: 'Za jeho dnů byla země rozdělena (Gn 10,25).',
  ),
  FamilyNode('Reú', VerseRef(1, 11, 20)),
  FamilyNode('Serug', VerseRef(1, 11, 22)),
  FamilyNode('Náchor', VerseRef(1, 11, 24)),
  FamilyNode(
    'Terach',
    VerseRef(1, 11, 26),
    note: 'Odešel s rodinou z Kaldejského Uru do Cháranu.',
    children: [
      FamilyLink('Náchor', ref: VerseRef(1, 11, 27)),
      FamilyLink('Háran', ref: VerseRef(1, 11, 27), note: 'Otec Lota'),
      FamilyLink('Lot', person: 'lot', ref: VerseRef(1, 11, 27), note: 'vnuk'),
    ],
  ),
  FamilyNode(
    'Abraham',
    VerseRef(1, 12, 1),
    person: 'abraham',
    section: 'Praotcové',
    note: 'Otec víry; v něm budou požehnány všechny národy.',
    spouses: [
      FamilyLink('Sára', person: 'sara', ref: VerseRef(1, 17, 15)),
      FamilyLink('Hagar', person: 'hagar', ref: VerseRef(1, 16, 1)),
    ],
    children: [
      FamilyLink(
        'Izmael',
        person: 'izmael',
        ref: VerseRef(1, 16, 15),
        note: 'syn Hagar',
      ),
    ],
  ),
  FamilyNode(
    'Izák',
    VerseRef(1, 21, 3),
    person: 'izak',
    note: 'Syn zaslíbení, narozený Sáře ve stáří.',
    spouses: [FamilyLink('Rebeka', person: 'rebeka', ref: VerseRef(1, 24, 67))],
    children: [
      FamilyLink(
        'Ezau',
        person: 'ezau',
        ref: VerseRef(1, 25, 25),
        note: 'dvojče',
      ),
    ],
  ),
  FamilyNode(
    'Jákob (Izrael)',
    VerseRef(1, 25, 26),
    person: 'jakob',
    note: 'Otec dvanácti synů – praotců izraelských kmenů.',
    spouses: [
      FamilyLink('Lea', person: 'lea', ref: VerseRef(1, 29, 23)),
      FamilyLink('Ráchel', person: 'rachel', ref: VerseRef(1, 29, 28)),
    ],
    children: [
      FamilyLink('Ruben', ref: VerseRef(1, 29, 32)),
      FamilyLink('Simeon', ref: VerseRef(1, 29, 33)),
      FamilyLink(
        'Lévi',
        ref: VerseRef(1, 29, 34),
        note: 'kmen kněží – z něj Mojžíš a Áron',
      ),
      FamilyLink('Dan', ref: VerseRef(1, 30, 6)),
      FamilyLink('Neftalí', ref: VerseRef(1, 30, 8)),
      FamilyLink('Gád', ref: VerseRef(1, 30, 11)),
      FamilyLink('Ašer', ref: VerseRef(1, 30, 13)),
      FamilyLink('Isachar', ref: VerseRef(1, 30, 18)),
      FamilyLink('Zabulón', ref: VerseRef(1, 30, 20)),
      FamilyLink('Dína', ref: VerseRef(1, 30, 21), note: 'dcera'),
      FamilyLink('Josef', person: 'josef', ref: VerseRef(1, 30, 24)),
      FamilyLink('Benjamín', ref: VerseRef(1, 35, 18)),
    ],
  ),
  FamilyNode(
    'Juda',
    VerseRef(1, 29, 35),
    person: 'juda',
    note: 'Z jeho kmene vzejde vladař (Gn 49,10).',
    spouses: [
      FamilyLink(
        'Támar',
        person: 'tamar',
        ref: VerseRef(1, 38, 6),
        note: 'matka Pereca',
      ),
    ],
    children: [FamilyLink('Zerach', ref: VerseRef(1, 38, 30), note: 'dvojče')],
  ),
  FamilyNode(
    'Peres',
    VerseRef(1, 38, 29),
    section: 'Judův rod až k Davidovi (Rt 4)',
  ),
  FamilyNode('Chesron', VerseRef(8, 4, 18)),
  FamilyNode('Rám', VerseRef(8, 4, 19)),
  FamilyNode('Amínadab', VerseRef(8, 4, 19)),
  FamilyNode(
    'Nachšon',
    VerseRef(8, 4, 20),
    note: 'Předák Judova kmene na poušti (Nu 1,7).',
  ),
  FamilyNode(
    'Salmón',
    VerseRef(8, 4, 20),
    spouses: [
      FamilyLink(
        'Rachab',
        person: 'rachab',
        ref: VerseRef(40, 1, 5),
        note: 'z Jericha',
      ),
    ],
  ),
  FamilyNode(
    'Bóaz',
    VerseRef(8, 4, 21),
    person: 'boaz',
    note: 'Vykupitel, který se ujal Rút a Noemi.',
    spouses: [
      FamilyLink('Rút', person: 'rut', ref: VerseRef(8, 4, 13), note: 'Moábka'),
    ],
  ),
  FamilyNode('Obéd', VerseRef(8, 4, 17)),
  FamilyNode('Jišaj', VerseRef(8, 4, 22), note: 'Betlémský hospodář.'),
  FamilyNode(
    'David',
    VerseRef(8, 4, 22),
    person: 'david',
    section: 'Davidův královský rod',
    note: 'Bůh mu zaslíbil trůn navěky (2S 7).',
    spouses: [
      FamilyLink('Batšeba', person: 'batseba', ref: VerseRef(10, 11, 3)),
      FamilyLink('Mikal', person: 'mikal', ref: VerseRef(9, 18, 27)),
      FamilyLink('Abigail', person: 'abigail', ref: VerseRef(9, 25, 42)),
    ],
    children: [
      FamilyLink(
        'Nátan',
        ref: VerseRef(10, 5, 14),
        note: 'jeho linií vede rodokmen u Lukáše',
      ),
      FamilyLink('Abšalóm', person: 'absalom', ref: VerseRef(10, 3, 3)),
      FamilyLink('Amnón', ref: VerseRef(10, 3, 2)),
      FamilyLink('Adonijáš', ref: VerseRef(10, 3, 4)),
    ],
  ),
  FamilyNode(
    'Šalomoun',
    VerseRef(10, 12, 24),
    person: 'salomoun',
    note: 'Postavil chrám.',
  ),
  FamilyNode(
    'Rechabeám',
    VerseRef(11, 11, 43),
    person: 'rechabeam',
    note: 'Za něj se království rozdělilo.',
  ),
  FamilyNode('Abijáš', VerseRef(11, 15, 1)),
  FamilyNode('Ása', VerseRef(11, 15, 9), person: 'asa'),
  FamilyNode('Jóšafat', VerseRef(11, 22, 41), person: 'josafat'),
  FamilyNode(
    'Jóram',
    VerseRef(12, 8, 16),
    note:
        'Matouš odtud vynechává tři krále (Achazjáše, Jóaše a Amasjáše) – '
        'rodokmen nemusí jmenovat každou generaci.',
  ),
  FamilyNode('Uzijáš', VerseRef(14, 26, 1), person: 'uzijas'),
  FamilyNode('Jótam', VerseRef(12, 15, 32)),
  FamilyNode('Achaz', VerseRef(12, 16, 1)),
  FamilyNode(
    'Chizkijáš',
    VerseRef(12, 18, 1),
    person: 'chizkijas',
    note: 'Bůh zachránil Jeruzalém před Asyřany.',
  ),
  FamilyNode('Menases', VerseRef(12, 21, 1), person: 'menases'),
  FamilyNode('Amón', VerseRef(12, 21, 19)),
  FamilyNode(
    'Jóšijáš',
    VerseRef(12, 22, 1),
    person: 'josijas',
    note: 'Obnovil smlouvu. Matouš vynechává jeho syna Jójakíma.',
  ),
  FamilyNode(
    'Jekonjáš (Jójakín)',
    VerseRef(12, 24, 8),
    note: 'Odveden do Babylóna roku 597 př. Kr.',
  ),
  FamilyNode(
    'Šealtíel',
    VerseRef(15, 3, 2),
    section: 'Po babylonském zajetí (Mt 1)',
  ),
  FamilyNode(
    'Zerubábel',
    VerseRef(15, 3, 2),
    person: 'zerubabel',
    note: 'Vedl navrátilce a stavbu druhého chrámu.',
  ),
  FamilyNode(
    'Abíhud',
    VerseRef(40, 1, 13),
    note: 'Další jména známe jen z Matoušova rodokmenu.',
  ),
  FamilyNode('Eljakím', VerseRef(40, 1, 13)),
  FamilyNode('Azór', VerseRef(40, 1, 13)),
  FamilyNode('Sádok', VerseRef(40, 1, 14)),
  FamilyNode('Achím', VerseRef(40, 1, 14)),
  FamilyNode('Elíhud', VerseRef(40, 1, 14)),
  FamilyNode('Eleazar', VerseRef(40, 1, 15)),
  FamilyNode('Matan', VerseRef(40, 1, 15)),
  FamilyNode('Jákob', VerseRef(40, 1, 15)),
  FamilyNode(
    'Josef',
    VerseRef(40, 1, 16),
    person: 'josef-nt',
    section: 'Ježíš',
    note: 'Muž Marie; Ježíšův zákonný otec.',
    spouses: [FamilyLink('Marie', person: 'marie', ref: VerseRef(40, 1, 16))],
    children: [
      FamilyLink(
        'Jakub',
        person: 'jakub-bratr',
        ref: VerseRef(41, 6, 3),
        note: 'Ježíšův bratr',
      ),
      FamilyLink(
        'Juda',
        person: 'juda-bratr',
        ref: VerseRef(41, 6, 3),
        note: 'Ježíšův bratr',
      ),
      FamilyLink('Josef a Šimon', ref: VerseRef(41, 6, 3), note: 'bratři'),
    ],
  ),
  FamilyNode(
    'Ježíš Kristus',
    VerseRef(40, 1, 1),
    person: 'jezis',
    note: 'Syn Davidův, syn Abrahamův (Mt 1,1) – Syn Boží.',
  ),
];

/// Kapitoly s rodokmenem (kanonicky), u kterých čtečka nabídne rodokmen.
const familyChapters = {
  (1, 5),
  (1, 10),
  (1, 11),
  (8, 4),
  (13, 1),
  (13, 2),
  (13, 3),
  (40, 1),
  (42, 3),
};

void openFamilyTree(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const FamilyTreeScreen()));

/// Rodokmen: linie zaslíbení od Adama po Ježíše, s manželkami a dalšími
/// dětmi po stranách. Klepnutí otevře medailon postavy nebo verš.
class FamilyTreeScreen extends ConsumerWidget {
  const FamilyTreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final people = {
      for (final p in ref.watch(peopleProvider).value ?? const <BiblePerson>[])
        p.id: p,
    };
    void open(String? person, VerseRef? verse) {
      final p = people[person];
      if (p != null) {
        openPerson(context, p);
      } else if (verse != null) {
        openReaderAt(context, ref, verse);
      }
    }

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.familyTree)),
        body: ListView.builder(
          padding: EdgeInsets.fromLTRB(
            12,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          itemCount: familyLine.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                child: Text(
                  S.familyTreeIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                ),
              );
            }
            final n = familyLine[i - 1];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (n.section != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 18, 0, 8),
                    child: Text(
                      n.section!.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.gold,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                _NodeRow(
                  node: n,
                  generation: i,
                  last: i == familyLine.length,
                  linked: people.containsKey(n.person),
                  onOpen: open,
                  linkedIds: people.keys.toSet(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NodeRow extends ConsumerWidget {
  const _NodeRow({
    required this.node,
    required this.generation,
    required this.last,
    required this.linked,
    required this.onOpen,
    required this.linkedIds,
  });

  final FamilyNode node;
  final int generation;
  final bool last;
  final bool linked;
  final void Function(String?, VerseRef?) onOpen;
  final Set<String> linkedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final key =
        node.person == 'adam' ||
        node.person == 'abraham' ||
        node.person == 'david' ||
        node.person == 'jezis';
    String cite(VerseRef r) =>
        '${books[r.bookId - 1].abbreviation} ${r.chapter},${r.verse}';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Linie rodu s pořadím generace.
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: key ? 30 : 24,
                  height: key ? 30 : 24,
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: key ? palette.gold : palette.card,
                    border: Border.all(color: palette.gold, width: 1.5),
                  ),
                  child: Text(
                    '$generation',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: key ? palette.card : palette.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: last
                        ? Colors.transparent
                        : palette.gold.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                shape: key
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: palette.gold, width: 1.5),
                      )
                    : null,
                child: InkWell(
                  onTap: () => onOpen(node.person, node.ref),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                node.name,
                                style:
                                    (key
                                            ? theme.textTheme.titleLarge
                                            : theme.textTheme.titleMedium)
                                        ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Text(
                              cite(node.ref),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                            Icon(
                              linked
                                  ? Icons.person_outline
                                  : Icons.chevron_right,
                              size: 18,
                              color: palette.muted,
                            ),
                          ],
                        ),
                        if (node.note != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              node.note!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.muted,
                                height: 1.35,
                              ),
                            ),
                          ),
                        if (node.spouses.isNotEmpty || node.children.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final s in node.spouses)
                                  _LinkChip(
                                    link: s,
                                    icon: Icons.favorite_border,
                                    color: const Color(0xFFC0603F),
                                    linked: linkedIds.contains(s.person),
                                    onTap: () => onOpen(s.person, s.ref),
                                  ),
                                for (final c in node.children)
                                  _LinkChip(
                                    link: c,
                                    icon: Icons.subdirectory_arrow_right,
                                    color: palette.muted,
                                    linked: linkedIds.contains(c.person),
                                    onTap: () => onOpen(c.person, c.ref),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({
    required this.link,
    required this.icon,
    required this.color,
    required this.linked,
    required this.onTap,
  });

  final FamilyLink link;
  final IconData icon;
  final Color color;
  final bool linked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Tooltip(
      message: link.note ?? '',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: linked ? color.withValues(alpha: 0.6) : palette.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(link.name, style: theme.textTheme.labelMedium),
              if (link.note != null)
                Text(
                  ' · ${link.note}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
