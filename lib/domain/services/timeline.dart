import '../entities/bible_entities.dart';

/// Jak jistá je datace události.
enum DatingCertainty {
  /// Biblické vyprávění bez možnosti historického datování.
  undated,

  /// Tradiční (biblická) chronologie; odborníci se v dataci liší.
  traditional,

  /// Přibližné datum, na kterém se většina historiků shoduje.
  approximate,

  /// Doloženo i mimobiblickými prameny (např. asyrské a babylonské
  /// kroniky, římští autoři).
  documented,
}

/// Období biblických dějin (barevné odlišení na časové ose).
enum TimelineEra {
  beginnings('Počátky', 0xFF8C6D46),
  patriarchs('Praotcové', 0xFFB7792F),
  exodus('Exodus a země', 0xFF3F7CAC),
  kingdom('Království', 0xFF8C4A6B),
  exile('Zajetí a návrat', 0xFF4E6E81),
  between('Mezi Starým a Novým zákonem', 0xFF7A7A6A),
  jesus('Ježíš', 0xFFB0813B),
  church('První církev', 0xFF2E8B57);

  const TimelineEra(this.label, this.color);

  final String label;
  final int color;
}

/// Událost na časové ose.
class TimelineEvent {
  const TimelineEvent({
    required this.era,
    required this.title,
    required this.date,
    required this.certainty,
    required this.description,
    required this.refs,
    this.chapters = const [],
  }) : world = false;

  /// Událost ze světových dějin (pro souvislosti, bez biblických odkazů
  /// nebo jen s nepřímým odkazem).
  const TimelineEvent.world({
    required this.era,
    required this.title,
    required this.date,
    required this.certainty,
    required this.description,
    this.refs = const [],
  }) : world = true,
       chapters = const [];

  final bool world;
  final TimelineEra era;
  final String title;

  /// Datum tak, jak se zobrazí („cca 1010–970 př. Kr.“).
  final String date;
  final DatingCertainty certainty;
  final String description;

  /// Hlavní biblická místa (kanonické číslování).
  final List<VerseRef> refs;

  /// Kapitoly, jejichž děj (nebo vznik) do této události patří –
  /// podle nich čtečka ukazuje, kde v dějinách čtenář je.
  final List<ChapterSpan> chapters;
}

/// Úsek kapitol jedné knihy (kanonické číslování). [note] upřesní
/// souvislost, např. kdy a kde vznikl list.
class ChapterSpan {
  const ChapterSpan(this.bookId, this.from, [int? to, this.note])
    : to = to ?? from;

  /// Celá kniha.
  const ChapterSpan.book(this.bookId, [this.note]) : from = 1, to = 999;

  final int bookId;
  final int from;
  final int to;
  final String? note;

  bool contains(int book, int chapter) =>
      book == bookId && chapter >= from && chapter <= to;

  int get length => to - from + 1;
}

/// Místo kapitoly na časové ose.
class TimelinePlace {
  const TimelinePlace(this.index, this.event, this.span);

  /// Index události v [timelineEvents].
  final int index;
  final TimelineEvent event;
  final ChapterSpan span;

  /// Poloha na celé ose (0 = počátky, 1 = konec).
  double get position => index / (timelineEvents.length - 1);
}

/// Do které události patří kapitola (kanonické číslování). Vybere se
/// nejužší úsek – např. žalm 51 patří k Davidovi, ostatní žalmy ke
/// zpěvníku obecně.
TimelinePlace? timelinePlaceOf(int bookId, int chapter) {
  TimelinePlace? best;
  for (final (i, e) in timelineEvents.indexed) {
    for (final span in e.chapters) {
      if (!span.contains(bookId, chapter)) continue;
      if (best == null || span.length < best.span.length) {
        best = TimelinePlace(i, e, span);
      }
    }
  }
  if (best == null && psalterSpan.contains(bookId, chapter)) {
    // Ostatní žalmy: zpěvník vznikal hlavně v době království.
    final david = timelineEvents.indexWhere((e) => e.title == 'Král David');
    return TimelinePlace(david, timelineEvents[david], psalterSpan);
  }
  return best;
}

/// Hlavní události biblických dějin.
///
/// Datace vycházejí z běžně používané chronologie studijních Biblí
/// a odborné literatury; u nejistých období jsou uvedeny rozsahy nebo
/// alternativy. Vlastní text aplikace.
const timelineEvents = [
  // --- Počátky ---------------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.beginnings,
    title: 'Stvoření',
    date: 'Bez datace',
    certainty: DatingCertainty.undated,
    description:
        'Bůh tvoří nebe, zemi a člověka ke svému obrazu a svěřuje mu péči '
        'o stvoření. Vyprávění Gn 1–11 nepodává historickou chronologii.',
    refs: [VerseRef(1, 1), VerseRef(1, 2)],
    chapters: [ChapterSpan(1, 1, 2)],
  ),
  TimelineEvent(
    era: TimelineEra.beginnings,
    title: 'Pád člověka a první rodiny',
    date: 'Bez datace',
    certainty: DatingCertainty.undated,
    description:
        'Adam a Eva neposlechnou Boha, Kain zabije Ábela. Hřích se šíří, '
        'ale Bůh dává první příslib vítězství nad zlem (Gn 3,15).',
    refs: [VerseRef(1, 3), VerseRef(1, 4), VerseRef(1, 5)],
    chapters: [ChapterSpan(1, 3, 5)],
  ),
  TimelineEvent(
    era: TimelineEra.beginnings,
    title: 'Potopa a Noemova smlouva',
    date: 'Bez datace',
    certainty: DatingCertainty.undated,
    description:
        'Bůh zachraňuje Noema a jeho rodinu v arše a uzavírá smlouvu se vším '
        'živým, jejímž znamením je duha.',
    refs: [VerseRef(1, 6), VerseRef(1, 9, 13)],
    chapters: [ChapterSpan(1, 6, 10)],
  ),
  TimelineEvent(
    era: TimelineEra.beginnings,
    title: 'Babylonská věž',
    date: 'Bez datace',
    certainty: DatingCertainty.undated,
    description:
        'Lidé chtějí stavbou věže dosáhnout nebe a udělat si jméno. Bůh '
        'zmate jejich jazyky a rozptýlí je. Rodokmen pak vede k Abramovi.',
    refs: [VerseRef(1, 11)],
    chapters: [ChapterSpan(1, 11)],
  ),
  TimelineEvent.world(
    era: TimelineEra.beginnings,
    title: 'Vznik písma',
    date: 'cca 3200 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'V Mezopotámii vzniká klínové písmo a v Egyptě hieroglyfy – začínají '
        'psané dějiny.',
  ),
  TimelineEvent.world(
    era: TimelineEra.beginnings,
    title: 'Velká pyramida v Gíze',
    date: 'cca 2560 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Stavba Chufuovy pyramidy v Egyptě – stála už staletí, když do Egypta '
        'přišel Abraham.',
  ),

  // --- Praotcové -------------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.patriarchs,
    title: 'Abrahamovo povolání',
    date: 'tradičně 2091 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Abram (narozen tradičně r. 2166 př. Kr.) odchází v 75 letech '
        'z Cháranu do Kenaanu a přijímá zaslíbení země, potomstva a požehnání '
        'pro všechny národy. Tradiční data vycházejí z věků v Bibli; mnozí '
        'badatelé kladou praotce do let cca 2000–1700 př. Kr.',
    refs: [VerseRef(1, 12), VerseRef(1, 15), VerseRef(1, 22)],
    chapters: [ChapterSpan(1, 12, 25)],
  ),
  TimelineEvent(
    era: TimelineEra.patriarchs,
    title: 'Izák a Jákob',
    date: 'tradičně 2066–1900 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Izák se narodil tradičně r. 2066, Jákob 2006 př. Kr. Jákob utíká '
        'před Ezauem, v Bét-elu vidí žebřík do nebe a u Jaboku zápasí '
        's Bohem. Dostává jméno Izrael a je praotcem dvanácti kmenů.',
    refs: [VerseRef(1, 28), VerseRef(1, 32, 23)],
    chapters: [ChapterSpan(1, 26, 36)],
  ),
  TimelineEvent(
    era: TimelineEra.patriarchs,
    title: 'Josef v Egyptě',
    date: 'tradičně 1898–1805 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Bratři prodají Josefa do otroctví, v Egyptě se však stává správcem '
        'země. Za hladu přivede celou Jákobovu rodinu do Egypta (tradičně '
        '1876 př. Kr.).',
    refs: [VerseRef(1, 37), VerseRef(1, 45), VerseRef(1, 50, 20)],
    chapters: [ChapterSpan(1, 37, 50)],
  ),
  TimelineEvent(
    era: TimelineEra.patriarchs,
    title: 'Příběh Joba',
    date: 'bez přesné datace',
    certainty: DatingCertainty.undated,
    description:
        'Kniha nezmiňuje Izrael ani Zákon; svět Joba (bohatství ve stádech, '
        'oběti otce rodiny) připomíná dobu praotců. Kdy byla kniha sepsána, '
        'není známo.',
    refs: [VerseRef(18, 1), VerseRef(18, 38), VerseRef(18, 42)],
    chapters: [ChapterSpan.book(18)],
  ),
  TimelineEvent.world(
    era: TimelineEra.patriarchs,
    title: 'Chammurapiho zákoník',
    date: 'cca 1750 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Babylonský král Chammurapi dává vytesat sbírku zákonů – ukazuje '
        'právní svět doby praotců.',
  ),

  // --- Exodus a země ---------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Útlak v Egyptě a povolání Mojžíše',
    date: '15. nebo 13. stol. př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Izraelci jsou v Egyptě otroky. Mojžíš je zachráněn z Nilu, vyroste '
        'u faraonova dvora a Bůh ho u hořícího keře posílá vyvést lid.',
    refs: [VerseRef(2, 1), VerseRef(2, 3)],
    chapters: [ChapterSpan(2, 1, 4)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Vyvedení z Egypta',
    date: '15. nebo 13. stol. př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Deset ran, první Pesach a průchod Rákosovým mořem. Odborníci se '
        'dělí mezi dřívější (cca 1446) a pozdější (cca 1260) dataci.',
    refs: [VerseRef(2, 12), VerseRef(2, 14), VerseRef(2, 15)],
    chapters: [ChapterSpan(2, 5, 15)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exodus,
    title: 'Ramesse II. vládne Egyptu',
    date: '1279–1213 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Nejslavnější faraon Nové říše; zastánci pozdní datace exodu ho '
        'považují za faraona útlaku.',
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Cestou k Sínaji',
    date: 'první měsíce po exodu',
    certainty: DatingCertainty.traditional,
    description:
        'Hořká voda v Maře, mana a křepelky, voda ze skály a vítězství nad '
        'Amálekem. Bůh se o lid stará den po dni.',
    refs: [VerseRef(2, 16), VerseRef(2, 17)],
    chapters: [ChapterSpan(2, 16, 18)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Smlouva na Sínaji a svatostánek',
    date: 'krátce po exodu',
    certainty: DatingCertainty.traditional,
    description:
        'Bůh uzavírá s Izraelem smlouvu a dává Desatero i Zákon. Lid staví '
        'svatostánek a necelý rok tábořá pod horou.',
    refs: [VerseRef(2, 19), VerseRef(2, 20), VerseRef(2, 40, 34)],
    chapters: [
      ChapterSpan(2, 19, 40),
      ChapterSpan.book(3),
      ChapterSpan(4, 1, 10),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Čtyřicet let na poušti',
    date: '40 let po exodu',
    certainty: DatingCertainty.traditional,
    description:
        'Lid odmítne vstoupit do země a putuje pouští, dokud nevymře '
        'nevěřící generace. Bůh je přesto vede v oblaku a ohni.',
    refs: [VerseRef(4, 13), VerseRef(4, 14), VerseRef(4, 21, 8)],
    chapters: [
      ChapterSpan(4, 11, 36),
      ChapterSpan(19, 90, 90, 'Žalm připisovaný Mojžíšovi'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Mojžíšovy řeči v Moábu',
    date: 'konec putování',
    certainty: DatingCertainty.traditional,
    description:
        'Na prahu země Mojžíš znovu vykládá Zákon nové generaci, vyzývá '
        'k lásce k Bohu celým srdcem a umírá na hoře Nebó.',
    refs: [VerseRef(5, 6, 4), VerseRef(5, 30, 19), VerseRef(5, 34)],
    chapters: [ChapterSpan.book(5)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Vstup do země pod vedením Jozua',
    date: 'cca 1400 nebo 1200 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Přechod Jordánu, pád Jericha a boje o zemi. Datace závisí na '
        'dataci exodu.',
    refs: [VerseRef(6, 1), VerseRef(6, 3), VerseRef(6, 6)],
    chapters: [ChapterSpan(6, 1, 12)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Rozdělení země mezi kmeny',
    date: 'cca 1400 nebo 1200 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Jozue losem rozděluje zemi, zřizuje útočištná města a v Šekemu '
        'vyzývá lid: „Já a můj dům budeme sloužit Hospodinu.“',
    refs: [VerseRef(6, 20), VerseRef(6, 24, 15)],
    chapters: [ChapterSpan(6, 13, 24)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exodus,
    title: 'Merenptahova stéla',
    date: 'cca 1208 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Nejstarší mimobiblická zmínka o „Izraeli“ – lidu žijícím v Kenaanu. '
        'Nápis faraona Merenptaha.',
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Doba soudců',
    date: 'cca 1200–1050 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Kmenová společnost bez krále. Opakuje se kruh odpadnutí, útlaku, '
        'volání k Bohu a vysvobození – Debora, Gedeón, Samson.',
    refs: [VerseRef(7, 2), VerseRef(7, 4), VerseRef(7, 6)],
    chapters: [ChapterSpan.book(7)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Rút a Noemi',
    date: 'v době soudců, cca 1100 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Moábka Rút zůstane věrná své tchyni a v Betlémě se provdá za Bóaza. '
        'Stane se prababičkou krále Davida.',
    refs: [VerseRef(8, 1, 16), VerseRef(8, 4, 17)],
    chapters: [ChapterSpan.book(8)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exodus,
    title: 'Konec doby bronzové, příchod Pelištejců',
    date: 'cca 1200 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Rozpad velkých říší; „mořské národy“, mezi nimi Pelištejci, se usazují '
        'na pobřeží Kenaanu.',
    refs: [VerseRef(7, 13), VerseRef(9, 17)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Prorok Samuel',
    date: 'cca 1100–1050 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Chana vyprosí syna Samuela, který vyrůstá u svatostánku v Šílu. '
        'Pelištejci ukořistí truhlu smlouvy; Samuel vede lid jako soudce '
        'a prorok.',
    refs: [VerseRef(9, 1), VerseRef(9, 3), VerseRef(9, 7)],
    chapters: [ChapterSpan(9, 1, 7)],
  ),

  // --- Království ------------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Saul, první izraelský král',
    date: 'cca 1050–1010 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Prorok Samuel na žádost lidu pomaže Saula za krále. Saul však '
        'Boha neposlouchá a je zavržen.',
    refs: [VerseRef(9, 8), VerseRef(9, 10), VerseRef(9, 15)],
    chapters: [ChapterSpan(9, 8, 15)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Mladý David a Saul',
    date: 'cca 1025–1010 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Samuel pomaže pastýře Davida, ten porazí Goliáše. Žárlivý Saul '
        'ho pronásleduje, David však Saulovi dvakrát ušetří život. Saul '
        'umírá v bitvě na Gilbóe.',
    refs: [VerseRef(9, 16), VerseRef(9, 17), VerseRef(9, 24)],
    chapters: [
      ChapterSpan(9, 16, 31),
      ChapterSpan(19, 34, 34, 'Žalm z doby Davidova útěku'),
      ChapterSpan(19, 52, 52, 'Žalm z doby Davidova útěku'),
      ChapterSpan(19, 54, 54, 'Žalm z doby Davidova útěku'),
      ChapterSpan(19, 56, 57, 'Žalm z doby Davidova útěku'),
      ChapterSpan(19, 59, 59, 'Žalm z doby Davidova útěku'),
      ChapterSpan(19, 142, 142, 'Žalm z doby Davidova útěku'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Král David',
    date: 'cca 1010–970 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'David sjednocuje kmeny a činí Jeruzalém hlavním městem. Bůh mu '
        'zaslibuje trvalý královský rod. „Dům Davidův“ zmiňuje i nápis '
        'z Tel Danu (9. stol. př. Kr.).',
    refs: [VerseRef(10, 5), VerseRef(10, 7), VerseRef(19, 51)],
    chapters: [
      ChapterSpan.book(10),
      ChapterSpan(13, 10, 29),
      ChapterSpan(19, 3, 3, 'Davidův žalm z útěku před Abšalómem'),
      ChapterSpan(19, 51, 51, 'Davidův žalm po hříchu s Batšebou'),
      ChapterSpan(19, 4, 9, _davidPsalm),
      ChapterSpan(19, 11, 32, _davidPsalm),
      ChapterSpan(19, 35, 41, _davidPsalm),
      ChapterSpan(19, 53, 53, _davidPsalm),
      ChapterSpan(19, 55, 55, _davidPsalm),
      ChapterSpan(19, 58, 58, _davidPsalm),
      ChapterSpan(19, 60, 65, _davidPsalm),
      ChapterSpan(19, 68, 70, _davidPsalm),
      ChapterSpan(19, 86, 86, _davidPsalm),
      ChapterSpan(19, 101, 101, _davidPsalm),
      ChapterSpan(19, 103, 103, _davidPsalm),
      ChapterSpan(19, 108, 110, _davidPsalm),
      ChapterSpan(19, 122, 122, _davidPsalm),
      ChapterSpan(19, 124, 124, _davidPsalm),
      ChapterSpan(19, 131, 131, _davidPsalm),
      ChapterSpan(19, 133, 133, _davidPsalm),
      ChapterSpan(19, 138, 141, _davidPsalm),
      ChapterSpan(19, 143, 145, _davidPsalm),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Šalomoun a stavba chrámu',
    date: 'cca 970–931 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Šalomoun prosí o moudrost a staví v Jeruzalémě chrám. Jeho vláda '
        'je dobou rozkvětu, ale i útlaku a modloslužby. K jeho jménu se '
        'váže moudrostní literatura.',
    refs: [VerseRef(11, 3), VerseRef(11, 6), VerseRef(11, 8)],
    chapters: [
      ChapterSpan(11, 1, 11),
      ChapterSpan(14, 1, 9),
      ChapterSpan.book(20, 'Přísloví spojená se Šalomounem'),
      ChapterSpan.book(21, 'Tradičně připisováno Šalomounovi'),
      ChapterSpan.book(22, 'Píseň spojená se Šalomounem'),
      ChapterSpan(19, 72, 72, 'Žalm o Šalomounovi'),
      ChapterSpan(19, 127, 127, 'Žalm připisovaný Šalomounovi'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Rozdělení království',
    date: 'cca 931 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Po Šalomounově smrti se deset severních kmenů odtrhne: vzniká '
        'Izrael (Samaří) a Juda (Jeruzalém). Jarobeám staví zlatá telata '
        'v Bét-elu a Danu.',
    refs: [VerseRef(11, 12), VerseRef(14, 10)],
    chapters: [ChapterSpan(11, 12, 16), ChapterSpan(14, 10, 16)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Prorok Eliáš a král Achab',
    date: 'cca 874–850 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Eliáš se na Karmelu staví proti Baalovým prorokům. Achaba zmiňují '
        'i asyrské záznamy (bitva u Karkaru 853 př. Kr.). V Judsku vládne '
        'zbožný Jóšafat.',
    refs: [VerseRef(11, 17), VerseRef(11, 18), VerseRef(11, 19)],
    chapters: [
      ChapterSpan(11, 17, 22),
      ChapterSpan(12, 1, 2),
      ChapterSpan(14, 17, 20),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Elíša a Jehú',
    date: 'cca 850–800 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Elíša koná zázraky pro chudé i cizince (Naamán). Jehú vyhladí '
        'Achabův rod; jeho poklonu asyrskému králi zobrazuje Černý obelisk '
        'Salmanassara III. (841 př. Kr.).',
    refs: [VerseRef(12, 2), VerseRef(12, 5), VerseRef(12, 9)],
    chapters: [ChapterSpan(12, 3, 13), ChapterSpan(14, 21, 24)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Prorok Joel',
    date: 'nejistá datace',
    certainty: DatingCertainty.undated,
    description:
        'Kniha nedatuje sama sebe; badatelé ji kladou do 9. až 5. stol. '
        'př. Kr. Zaslíbení vylití Ducha cituje Petr o Letnicích.',
    refs: [VerseRef(29, 3, 1)],
    chapters: [ChapterSpan.book(29)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Jonáš v Ninive',
    date: 'cca 780 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Prorok z doby krále Jarobeáma II. (2Kr 14,25) utíká před Božím '
        'posláním. Ninive se po jeho kázání obrátí a Bůh se nad městem '
        'smiluje.',
    refs: [VerseRef(32, 1), VerseRef(32, 4)],
    chapters: [ChapterSpan.book(32)],
  ),
  TimelineEvent.world(
    era: TimelineEra.kingdom,
    title: 'První olympijské hry a založení Říma',
    date: '776 a 753 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Podle tradice se konají první olympijské hry (776) a je založen Řím '
        '(753) – v době proroků Ámose a Ozeáše.',
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Proroci Ámos, Ozeáš, Izajáš a Micheáš',
    date: '8. stol. př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'V době blahobytu proroci volají k návratu k Bohu a ke spravedlnosti '
        'pro chudé. Izajáš působí v Jeruzalémě od roku cca 740 př. Kr.',
    refs: [VerseRef(30, 5, 24), VerseRef(28, 11), VerseRef(23, 6)],
    chapters: [
      ChapterSpan.book(30),
      ChapterSpan.book(28),
      ChapterSpan.book(33),
      ChapterSpan(23, 1, 35),
      ChapterSpan(12, 14, 16),
      ChapterSpan(14, 25, 28),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Pád Samaří, zánik severního Izraele',
    date: '722 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Asyřané dobývají Samaří a odvádějí obyvatele. Událost popisují '
        'i asyrské nápisy Sargona II.',
    refs: [VerseRef(12, 17)],
    chapters: [ChapterSpan(12, 17)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Chizkijáš a Sancheríbovo obléhání',
    date: '715–686 př. Kr. (obléhání 701)',
    certainty: DatingCertainty.documented,
    description:
        'Král Chizkijáš (Ezechiáš) obnovuje bohoslužbu a staví tunel pro '
        'vodu (Siloámský nápis). Asyrský král Sancheríb pustoší Judsko, '
        'Jeruzalém však nedobude – zachycuje to i Sancheríbův hranol.',
    refs: [VerseRef(12, 18), VerseRef(12, 19), VerseRef(23, 37)],
    chapters: [
      ChapterSpan(12, 18, 20),
      ChapterSpan(14, 29, 32),
      ChapterSpan(23, 36, 39),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Manasses',
    date: 'cca 697–642 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Nejdéle vládnoucí judský král zavádí modloslužbu i v chrámu. '
        'Kronika vypráví, že se v asyrském zajetí pokořil a Bůh ho vyslyšel.',
    refs: [VerseRef(12, 21), VerseRef(14, 33, 12)],
    chapters: [ChapterSpan(12, 21), ChapterSpan(14, 33)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Jóšijášova reforma',
    date: '640–609 př. Kr. (reforma 622)',
    certainty: DatingCertainty.approximate,
    description:
        'V chrámu je nalezena kniha Zákona a král Jóšijáš obnovuje '
        'smlouvu. Prorokují Sofonjáš, Nahum a mladý Jeremjáš.',
    refs: [VerseRef(12, 22), VerseRef(12, 23), VerseRef(24, 1)],
    chapters: [
      ChapterSpan(12, 22, 23),
      ChapterSpan(14, 34, 35),
      ChapterSpan.book(36),
      ChapterSpan.book(34),
    ],
  ),
  TimelineEvent.world(
    era: TimelineEra.kingdom,
    title: 'Pád Ninive',
    date: '612 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Babylóňané a Médové dobývají asyrské hlavní město, jak předpověděl '
        'prorok Nahum. Babylonská kronika pád popisuje.',
    refs: [VerseRef(34, 3)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Jeremjáš a poslední judští králové',
    date: '627–587 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Jeremjáš čtyřicet let varuje před soudem a vyzývá k pokání; je '
        'proto pronásledován. Abakuk se ptá, proč Bůh použije Babylóňany.',
    refs: [VerseRef(24, 1), VerseRef(24, 31, 31), VerseRef(35, 3, 17)],
    chapters: [ChapterSpan(24, 1, 38), ChapterSpan.book(35)],
  ),

  // --- Zajetí a návrat -------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Daniel na babylonském dvoře',
    date: '605–536 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Daniel a jeho přátelé jsou odvedeni do Babylóna už r. 605 a zůstávají '
        'věrni Bohu u dvora Nebúkadnesara i perských králů.',
    refs: [VerseRef(27, 1), VerseRef(27, 3), VerseRef(27, 6)],
    chapters: [ChapterSpan.book(27)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Pád Jeruzaléma a babylonské zajetí',
    date: '597 a 587/586 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Nebúkadnesar odvádí krále Jójakína (597, zaznamenáno i v '
        'Babylonské kronice) a později boří Jeruzalém i chrám. Lakíšské '
        'dopisy zachycují poslední dny judských pevností.',
    refs: [
      VerseRef(12, 25),
      VerseRef(25, 1),
      VerseRef(24, 39),
      VerseRef(19, 137),
    ],
    chapters: [
      ChapterSpan(12, 24, 25),
      ChapterSpan(14, 36),
      ChapterSpan(24, 39, 52),
      ChapterSpan.book(25),
      ChapterSpan.book(31, 'Proroctví proti Edómu po pádu Jeruzaléma'),
      ChapterSpan(19, 74, 74, 'Nářek nad zničenou svatyní'),
      ChapterSpan(19, 79, 79, 'Nářek nad zničenou svatyní'),
      ChapterSpan(19, 137, 137, 'Píseň vyhnanců u babylonských řek'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Ezechiel mezi vyhnanci',
    date: '593–571 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Kněz Ezechiel vidí Boží slávu u řeky Kebar v Babylónii. Ohlašuje '
        'soud, po pádu Jeruzaléma pak nové srdce a oživení suchých kostí.',
    refs: [VerseRef(26, 1), VerseRef(26, 36, 26), VerseRef(26, 37)],
    chapters: [ChapterSpan.book(26)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Útěcha pro zajatce',
    date: 'zaměřeno na 6. stol. př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Kapitoly Iz 40–66 mluví k lidu v zajetí, jmenují perského krále '
        'Kýra a ohlašují Služebníka Hospodinova. Tradice je připisuje '
        'Izajášovi, mnozí badatelé jeho žákům z doby zajetí.',
    refs: [VerseRef(23, 40), VerseRef(23, 53)],
    chapters: [ChapterSpan(23, 40, 66)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Kýrův edikt a návrat ze zajetí',
    date: '539/538 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Perský král Kýros dobývá Babylón a dovoluje vyhnancům návrat. '
        'Jeho politiku dokládá i Kýrův válec. Navrátilci obnovují oltář.',
    refs: [VerseRef(15, 1), VerseRef(23, 45), VerseRef(14, 36, 22)],
    chapters: [
      ChapterSpan(15, 1, 4),
      ChapterSpan(19, 126, 126, 'Píseň navrátilců'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Dostavění druhého chrámu',
    date: '520–516/515 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Po povzbuzení proroků Agea a Zacharjáše je chrám dokončen '
        'v 6. roce krále Dareia.',
    refs: [VerseRef(15, 6, 15), VerseRef(37, 1), VerseRef(38, 4)],
    chapters: [
      ChapterSpan(15, 5, 6),
      ChapterSpan.book(37),
      ChapterSpan.book(38),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Ester na perském dvoře',
    date: 'cca 480 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Za krále Achašveróše (Xerxa I., 486–465) zachrání Ester svůj lid. '
        'Připomíná to svátek Purim.',
    refs: [VerseRef(17, 4), VerseRef(17, 9)],
    chapters: [ChapterSpan.book(17)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exile,
    title: 'Bitva u Salamíny',
    date: '480 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Řekové porážejí loďstvo perského krále Xerxa – téhož Achašveróše, '
        'jehož manželkou se stala Ester.',
    refs: [VerseRef(17, 1)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Ezdráš učí Zákon',
    date: '458 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Kněz a znalec Zákona Ezdráš přichází do Jeruzaléma a vede lid '
        'k obnově smlouvy. Do té doby se kladou i Kroniky, které začínají '
        'rodokmeny od Adama.',
    refs: [VerseRef(15, 7, 10), VerseRef(16, 8)],
    chapters: [
      ChapterSpan(15, 7, 10),
      ChapterSpan(13, 1, 9, 'Rodokmeny sepsané po návratu ze zajetí'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Nehemjáš staví hradby',
    date: '445–cca 430 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Číšník perského krále Nehemjáš se vrací jako místodržitel a za '
        '52 dní obnoví jeruzalémské hradby. Ezdráš čte lidu Zákon.',
    refs: [VerseRef(16, 2), VerseRef(16, 6, 15), VerseRef(16, 8)],
    chapters: [ChapterSpan.book(16)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Malachiáš, poslední prorok',
    date: 'cca 430 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Prorok kárá vlažné kněze i lid a ohlašuje posla, který připraví '
        'cestu Hospodinu – Nový zákon ho spojuje s Janem Křtitelem.',
    refs: [VerseRef(39, 3), VerseRef(39, 3, 23)],
    chapters: [ChapterSpan.book(39)],
  ),

  // --- Mezi zákony -----------------------------------------------------------
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Alexandr Veliký',
    date: '332 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Alexandr Makedonský dobývá Perskou říši i Judsko; řečtina se stává '
        'společným jazykem – později i jazykem Nového zákona.',
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Septuaginta',
    date: '3. stol. př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'V Alexandrii vzniká řecký překlad Starého zákona. Apoštolové z něj '
        'často citují.',
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Makabejské povstání',
    date: '167–164 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Židé se vzbouří proti Antiochovi IV., který znesvětil chrám; nové '
        'posvěcení chrámu připomíná svátek Chanuka.',
    refs: [VerseRef(43, 10, 22)],
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Řím ovládne Judsko',
    date: '63 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Pompeius dobývá Jeruzalém; Judsko se dostává pod římskou nadvládu.',
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Herodes Veliký',
    date: '37–4 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Herodes vládne jako římský vazal a od r. 20/19 př. Kr. velkolepě '
        'přestavuje chrám.',
    refs: [VerseRef(40, 2, 1), VerseRef(43, 2, 20)],
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Císař Augustus',
    date: '27 př. Kr. – 14 po Kr.',
    certainty: DatingCertainty.documented,
    description:
        'První římský císař; jeho nařízení o sčítání lidu zmiňuje Lukáš.',
    refs: [VerseRef(42, 2, 1)],
  ),

  // --- Ježíš -----------------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Narození Ježíše',
    date: 'cca 6–4 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ježíš se narodil v Betlémě za vlády Heroda Velikého, který '
        'zemřel roku 4 př. Kr. (náš letopočet byl spočítán o pár let '
        'nepřesně).',
    refs: [VerseRef(40, 2), VerseRef(42, 2)],
    chapters: [ChapterSpan(40, 1, 2), ChapterSpan(42, 1, 2)],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Jan Křtitel, křest a pokušení',
    date: 'cca 27–29 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Lukáš datuje vystoupení Jana Křtitele do 15. roku vlády '
        'císaře Tiberia. Ježíš je pokřtěn v Jordánu a na poušti odolá '
        'pokušení.',
    refs: [VerseRef(42, 3, 1), VerseRef(41, 1), VerseRef(43, 1, 29)],
    chapters: [
      ChapterSpan(40, 3, 4),
      ChapterSpan(41, 1),
      ChapterSpan(42, 3, 4),
      ChapterSpan(43, 1),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Ježíš v Galileji',
    date: 'cca 28–29 (31) po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ježíš káže o Božím království, uzdravuje, povolává Dvanáct a mluví '
        'v podobenstvích – hlavně kolem Kafarnaum a Galilejského jezera.',
    refs: [VerseRef(40, 5), VerseRef(41, 1, 15), VerseRef(43, 6)],
    chapters: [
      ChapterSpan(40, 5, 18),
      ChapterSpan(41, 2, 9),
      ChapterSpan(42, 5, 9),
      ChapterSpan(43, 2, 6),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Cesta do Jeruzaléma',
    date: 'cca 29 (32) po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ježíš se rozhodně vydává do Jeruzaléma. Cestou učí o následování, '
        'vypráví podobenství o milosrdném Samařanu a ztraceném synu a křísí '
        'Lazara.',
    refs: [VerseRef(42, 9, 51), VerseRef(42, 15), VerseRef(43, 11)],
    chapters: [
      ChapterSpan(40, 19, 20),
      ChapterSpan(41, 10),
      ChapterSpan(42, 10, 19),
      ChapterSpan(43, 7, 11),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Poslední týden a ukřižování',
    date: '30 nebo 33 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Vjezd do Jeruzaléma, poslední večeře, Getsemane a soud. Ježíš je '
        'ukřižován za prefekta Pontia Piláta (26–36), o kterém píše '
        'i Tacitus a nápis z Cesareje.',
    refs: [VerseRef(40, 21), VerseRef(40, 26), VerseRef(40, 27)],
    chapters: [
      ChapterSpan(40, 21, 27),
      ChapterSpan(41, 11, 15),
      ChapterSpan(42, 20, 23),
      ChapterSpan(43, 12, 19),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Vzkříšení',
    date: '30 nebo 33 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Třetího dne je hrob prázdný. Vzkříšený se ukazuje ženám, '
        'učedníkům i více než pěti stům bratří a posílá je ke všem národům.',
    refs: [VerseRef(40, 28), VerseRef(43, 20), VerseRef(46, 15, 3)],
    chapters: [
      ChapterSpan(40, 28),
      ChapterSpan(41, 16),
      ChapterSpan(42, 24),
      ChapterSpan(43, 20, 21),
    ],
  ),

  // --- První církev ----------------------------------------------------------
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Letnice a církev v Jeruzalémě',
    date: '30 nebo 33 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Seslání Ducha svatého, Petrovo kázání a křest tří tisíc lidí. '
        'Církev sdílí majetek; Štěpán umírá jako první mučedník. Jeruzalémské '
        'církvi později stojí v čele Jakub, bratr Páně.',
    refs: [VerseRef(44, 1, 8), VerseRef(44, 2), VerseRef(44, 7)],
    chapters: [
      ChapterSpan(44, 1, 7),
      ChapterSpan.book(59, 'List Jakuba, vůdce jeruzalémské církve'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Evangelium do Samaří a k pohanům',
    date: 'cca 33–45 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Filip káže v Samaří a etiopskému dvořanu, Petr křtí římského '
        'setníka Kornélia. V Antiochii vzniká první církev z pohanů – tam '
        'se učedníkům poprvé říká křesťané.',
    refs: [VerseRef(44, 8), VerseRef(44, 10), VerseRef(44, 11, 26)],
    chapters: [ChapterSpan(44, 8, 12)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Obrácení apoštola Pavla',
    date: 'cca 33–36 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Pronásledovatel církve Saul se na cestě do Damašku setká se '
        'vzkříšeným Ježíšem.',
    refs: [VerseRef(44, 9), VerseRef(48, 1, 13)],
    chapters: [ChapterSpan(44, 9)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'První misijní cesta',
    date: 'cca 46–48 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Barnabáš a Pavel káží na Kypru a v jižní Galacii (Antiochie '
        'Pisidská, Ikonium, Lystra, Derbe).',
    refs: [VerseRef(44, 13), VerseRef(44, 14)],
    chapters: [ChapterSpan(44, 13, 14)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Apoštolský sněm v Jeruzalémě',
    date: 'cca 49 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Apoštolové rozhodují, že pohané nemusejí přijmout obřízku ani '
        'celý Mojžíšův zákon. O téže otázce píše Pavel Galatským.',
    refs: [VerseRef(44, 15), VerseRef(48, 2)],
    chapters: [
      ChapterSpan(44, 15),
      ChapterSpan.book(48, 'List vznikl cca 48–55 po Kr.'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Druhá misijní cesta – evangelium v Evropě',
    date: 'cca 49–52 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Pavel, Silas a Timotej zakládají církve ve Filipech, Soluni '
        'a Korintu. Pobyt v Korintu datuje nápis o prokonzulu Galliónovi '
        '(51/52 po Kr.).',
    refs: [VerseRef(44, 16), VerseRef(44, 17), VerseRef(44, 18, 12)],
    chapters: [
      ChapterSpan(44, 16, 18),
      ChapterSpan.book(52, 'Napsáno z Korintu cca 50–51 po Kr.'),
      ChapterSpan.book(53, 'Napsáno z Korintu cca 51 po Kr.'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Třetí misijní cesta – Efez',
    date: 'cca 53–57 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Pavel učí dva roky v Efezu, odkud se evangelium šíří po celé '
        'provincii Asii. Píše dopisy Korintským a Římanům.',
    refs: [VerseRef(44, 19), VerseRef(44, 20, 35)],
    chapters: [
      ChapterSpan(44, 19, 21),
      ChapterSpan.book(46, 'Napsáno z Efezu cca 54–55 po Kr.'),
      ChapterSpan.book(47, 'Napsáno z Makedonie cca 55–56 po Kr.'),
      ChapterSpan.book(45, 'Napsáno z Korintu cca 57 po Kr.'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Pavlovo zatčení a soudy',
    date: 'cca 57–59 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Pavel je zatčen v jeruzalémském chrámu a dva roky vězněn v Cesareji. '
        'Hájí se před Félixem, Festem i králem Agrippou a odvolá se k císaři.',
    refs: [VerseRef(44, 22), VerseRef(44, 26), VerseRef(44, 25, 11)],
    chapters: [ChapterSpan(44, 22, 26)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Pavel ve vězení v Římě',
    date: 'cca 60–62 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Po plavbě a ztroskotání u Malty káže Pavel dva roky v Římě '
        'v domácím vězení. Vznikají dopisy z vězení.',
    refs: [VerseRef(44, 27), VerseRef(44, 28), VerseRef(50, 1, 12)],
    chapters: [
      ChapterSpan(44, 27, 28),
      ChapterSpan.book(49, 'List z vězení, cca 60–62 po Kr.'),
      ChapterSpan.book(50, 'List z vězení, cca 60–62 po Kr.'),
      ChapterSpan.book(51, 'List z vězení, cca 60–62 po Kr.'),
      ChapterSpan.book(57, 'List z vězení, cca 60–62 po Kr.'),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Poslední léta apoštolů',
    date: 'cca 62–68 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Pavel píše Timoteovi a Titovi, jak vést církev; Petr povzbuzuje '
        'křesťany v utrpení. Oba podle tradice umírají v Římě za Nerona.',
    refs: [VerseRef(55, 4, 7), VerseRef(60, 1), VerseRef(61, 1)],
    chapters: [
      ChapterSpan.book(54, 'Napsáno cca 62–64 po Kr.'),
      ChapterSpan.book(56, 'Napsáno cca 62–64 po Kr.'),
      ChapterSpan.book(55, 'Pavlův poslední dopis z římského vězení'),
      ChapterSpan.book(60, 'Napsáno z Říma cca 62–64 po Kr.'),
      ChapterSpan.book(61, 'Petrův poslední dopis'),
      ChapterSpan.book(58, 'Napsáno patrně před r. 70 po Kr.'),
      ChapterSpan.book(65, 'Napsáno cca 65–80 po Kr.'),
    ],
  ),
  TimelineEvent.world(
    era: TimelineEra.church,
    title: 'Požár Říma a Neronovo pronásledování',
    date: '64 po Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Nero obviní křesťany z požáru Říma. Podle tradice v té době umírají '
        'v Římě apoštolové Petr a Pavel.',
    refs: [VerseRef(55, 4, 6)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Zničení Jeruzaléma Římany',
    date: '70 po Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Římská vojska pod Titem dobývají Jeruzalém a boří chrám, jak '
        'popisuje historik Josephus Flavius. Ježíš zkázu předpověděl.',
    refs: [VerseRef(42, 21, 20), VerseRef(40, 24, 2)],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Jan v Efezu a na Patmu',
    date: 'cca 90–95 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Stařičký apoštol píše církvím o lásce a pravdě. Za císaře Domitiána '
        'sepisuje na ostrově Patmos vidění o Kristově vítězství a novém '
        'stvoření.',
    refs: [VerseRef(62, 4, 8), VerseRef(66, 1, 9), VerseRef(66, 21)],
    chapters: [
      ChapterSpan.book(62, 'Napsáno cca 90 po Kr.'),
      ChapterSpan.book(63, 'Napsáno cca 90 po Kr.'),
      ChapterSpan.book(64, 'Napsáno cca 90 po Kr.'),
      ChapterSpan.book(66),
    ],
  ),
  TimelineEvent.world(
    era: TimelineEra.church,
    title: 'Nejstarší rukopis Nového zákona',
    date: 'cca 125 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Papyrus P52 se zlomkem Janova evangelia (J 18) – jen několik desítek '
        'let po sepsání.',
    refs: [VerseRef(43, 18, 31)],
  ),
  TimelineEvent.world(
    era: TimelineEra.church,
    title: 'Objev kumránských svitků',
    date: '1947',
    certainty: DatingCertainty.documented,
    description:
        'U Mrtvého moře jsou nalezeny svitky z doby před Kristem včetně '
        'celého svitku Izajáše – potvrzují pečlivost opisování Bible.',
    refs: [VerseRef(23, 53)],
  ),
];

/// Žalmy s Davidovým jménem v nadpisu.
const _davidPsalm = 'Žalm připisovaný Davidovi';

/// Žalmy bez konkrétní souvislosti patří ke zpěvníku jako celku.
const psalterSpan = ChapterSpan(
  19,
  1,
  150,
  'Zpěvník Izraele – žalmy vznikaly cca 1000–400 př. Kr.',
);
