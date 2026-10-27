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
  }) : world = true;

  final bool world;
  final TimelineEra era;
  final String title;

  /// Datum tak, jak se zobrazí („cca 1010–970 př. Kr.“).
  final String date;
  final DatingCertainty certainty;
  final String description;

  /// Hlavní biblická místa (kanonické číslování).
  final List<VerseRef> refs;
}

/// Hlavní události biblických dějin.
///
/// Datace vycházejí z běžně používané chronologie studijních Biblí
/// a odborné literatury; u nejistých období jsou uvedeny rozsahy nebo
/// alternativy. Vlastní text aplikace.
const timelineEvents = [
  TimelineEvent(
    era: TimelineEra.beginnings,
    title: 'Stvoření a prvotní dějiny',
    date: 'Bez datace',
    certainty: DatingCertainty.undated,
    description:
        'Stvoření světa a člověka, pád do hříchu, potopa a babylonská věž. '
        'Vyprávění Gn 1–11 nepodává historickou chronologii.',
    refs: [VerseRef(1, 1), VerseRef(1, 3), VerseRef(1, 6), VerseRef(1, 11)],
  ),
  TimelineEvent.world(
    era: TimelineEra.beginnings,
    title: 'Vznik písma',
    date: 'cca 3200 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'V Mezopotámii vzniká klínové písmo a v Egyptě hieroglyfy – začínají '
        'psané dějiny.',
    refs: [],
  ),
  TimelineEvent.world(
    era: TimelineEra.beginnings,
    title: 'Velká pyramida v Gíze',
    date: 'cca 2560 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Stavba Chufuovy pyramidy v Egyptě – stála už staletí, když do Egypta '
        'přišel Abraham.',
    refs: [],
  ),

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
  ),
  TimelineEvent(
    era: TimelineEra.patriarchs,
    title: 'Izák, Jákob a dvanáct kmenů',
    date: 'tradičně 2066–1876 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Izák se narodil tradičně r. 2066, Jákob 2006 př. Kr. Jákob, '
        'nazvaný Izrael, je praotcem dvanácti kmenů. Josef se v Egyptě '
        'stává správcem a rodina se tam usazuje (tradičně 1876 př. Kr.).',
    refs: [
      VerseRef(1, 28),
      VerseRef(1, 32, 23),
      VerseRef(1, 37),
      VerseRef(1, 50, 20),
    ],
  ),
  TimelineEvent.world(
    era: TimelineEra.patriarchs,
    title: 'Chammurapiho zákoník',
    date: 'cca 1750 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Babylonský král Chammurapi dává vytesat sbírku zákonů – ukazuje '
        'právní svět doby praotců.',
    refs: [],
  ),

  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Vyvedení z Egypta',
    date: '15. nebo 13. stol. př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Bůh povolává Mojžíše, Izrael prochází Rákosovým mořem. Odborníci '
        'se dělí mezi dřívější (cca 1446) a pozdější (cca 1260) dataci.',
    refs: [VerseRef(2, 3), VerseRef(2, 12), VerseRef(2, 14)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exodus,
    title: 'Ramesse II. vládne Egyptu',
    date: '1279–1213 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Nejslavnější faraon Nové říše; zastánci pozdní datace exodu ho '
        'považují za faraona útlaku.',
    refs: [],
  ),

  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Smlouva na Sínaji a Desatero',
    date: 'krátce po exodu',
    certainty: DatingCertainty.traditional,
    description:
        'Bůh uzavírá s Izraelem smlouvu a dává Zákon. Následuje čtyřicet '
        'let putování pouští.',
    refs: [VerseRef(2, 19), VerseRef(2, 20), VerseRef(4, 14), VerseRef(5, 6)],
  ),
  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Vstup do země pod vedením Jozua',
    date: 'cca 1400 nebo 1200 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Přechod Jordánu, pád Jericha a rozdělení země mezi kmeny. Datace '
        'závisí na dataci exodu.',
    refs: [VerseRef(6, 1), VerseRef(6, 3), VerseRef(6, 6), VerseRef(6, 24)],
  ),
  TimelineEvent.world(
    era: TimelineEra.exodus,
    title: 'Merenptahova stéla',
    date: 'cca 1208 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Nejstarší mimobiblická zmínka o „Izraeli“ – lidu žijícím v Kenaanu. '
        'Nápis faraona Merenptaha.',
    refs: [],
  ),

  TimelineEvent(
    era: TimelineEra.exodus,
    title: 'Doba soudců',
    date: 'cca 1200–1050 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Kmenová společnost bez krále. Soudci jako Debora, Gedeón a Samson '
        'vysvobozují Izrael z útlaku. Do této doby patří i příběh Rút.',
    refs: [VerseRef(7, 2), VerseRef(7, 4), VerseRef(7, 6), VerseRef(8, 1)],
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
    era: TimelineEra.kingdom,
    title: 'Saul, první izraelský král',
    date: 'cca 1050–1010 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Prorok Samuel na žádost lidu pomaže Saula za krále. Saul však '
        'Boha neposlouchá a je zavržen.',
    refs: [VerseRef(9, 8), VerseRef(9, 10), VerseRef(9, 15)],
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
    refs: [VerseRef(9, 16), VerseRef(10, 5), VerseRef(10, 7)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Šalomoun a stavba chrámu',
    date: 'cca 970–931 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Šalomoun prosí o moudrost a staví v Jeruzalémě chrám. Jeho vláda '
        'je dobou rozkvětu, ale i útlaku a modloslužby.',
    refs: [VerseRef(11, 3), VerseRef(11, 6), VerseRef(11, 8)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Rozdělení království',
    date: 'cca 931 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Po Šalomounově smrti se deset severních kmenů odtrhne: vzniká '
        'Izrael (Samaří) a Juda (Jeruzalém).',
    refs: [VerseRef(11, 12)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Proroci Eliáš a Elíša',
    date: 'cca 870–800 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'V době krále Achaba se Eliáš staví proti uctívání Baala. Achaba '
        'zmiňují i asyrské záznamy (bitva u Karkaru 853 př. Kr.).',
    refs: [VerseRef(11, 17), VerseRef(11, 18), VerseRef(12, 2)],
  ),
  TimelineEvent.world(
    era: TimelineEra.kingdom,
    title: 'První olympijské hry a založení Říma',
    date: '776 a 753 př. Kr.',
    certainty: DatingCertainty.traditional,
    description:
        'Podle tradice se konají první olympijské hry (776) a je založen Řím '
        '(753) – v době proroků Ámose a Ozeáše.',
    refs: [],
  ),

  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Proroci Ámos, Ozeáš a Izajáš',
    date: '8. stol. př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Proroci volají k návratu k Bohu a ke spravedlnosti. Izajáš '
        'působí v Jeruzalémě od roku cca 740 př. Kr.',
    refs: [VerseRef(30, 5, 24), VerseRef(28, 11), VerseRef(23, 6)],
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
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Sancheríb obléhá Jeruzalém',
    date: '701 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Za krále Chizkijáše (Ezechiáše) asyrský král Sancheríb pustoší '
        'Judsko, Jeruzalém však nedobude. Tažení zachycuje i Sancheríbův '
        'hranol a reliéfy z Lakíše.',
    refs: [VerseRef(12, 18), VerseRef(12, 19), VerseRef(23, 37)],
  ),
  TimelineEvent(
    era: TimelineEra.kingdom,
    title: 'Jóšijášova reforma',
    date: '622 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'V chrámu je nalezena kniha Zákona a král Jóšijáš obnovuje '
        'smlouvu. Působí prorok Jeremjáš.',
    refs: [VerseRef(12, 22), VerseRef(12, 23), VerseRef(24, 1)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Pád Jeruzaléma a babylonské zajetí',
    date: '597 a 587/586 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Nebúkadnesar odvádí krále Jójakína (597, zaznamenáno i v '
        'Babylonské kronice) a později boří Jeruzalém i chrám.',
    refs: [
      VerseRef(12, 24),
      VerseRef(12, 25),
      VerseRef(25, 1),
      VerseRef(19, 137),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Ezechiel a Daniel v zajetí',
    date: 'cca 600–530 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Proroci v Babylónii utěšují vyhnance nadějí na obnovu a Boží '
        'vládu nad říšemi.',
    refs: [VerseRef(26, 37), VerseRef(27, 1), VerseRef(27, 6)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Kýrův edikt a návrat ze zajetí',
    date: '539/538 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Perský král Kýros dobývá Babylón a dovoluje vyhnancům návrat. '
        'Jeho politiku dokládá i Kýrův válec.',
    refs: [VerseRef(15, 1), VerseRef(23, 45), VerseRef(14, 36, 22)],
  ),
  TimelineEvent(
    era: TimelineEra.exile,
    title: 'Dostavění druhého chrámu',
    date: '516/515 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Po povzbuzení proroků Agea a Zacharjáše je chrám dokončen '
        'v 6. roce krále Dareia.',
    refs: [VerseRef(15, 6, 15), VerseRef(37, 1), VerseRef(38, 4)],
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
    title: 'Ezdráš a Nehemjáš',
    date: '458 a 445 př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ezdráš učí Zákon, Nehemjáš obnovuje jeruzalémské hradby. '
        'Malachiáš je posledním z proroků Starého zákona.',
    refs: [VerseRef(15, 7), VerseRef(16, 2), VerseRef(16, 8), VerseRef(39, 3)],
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Alexandr Veliký',
    date: '332 př. Kr.',
    certainty: DatingCertainty.documented,
    description:
        'Alexandr Makedonský dobývá Perskou říši i Judsko; řečtina se stává '
        'společným jazykem – později i jazykem Nového zákona.',
    refs: [],
  ),
  TimelineEvent.world(
    era: TimelineEra.between,
    title: 'Septuaginta',
    date: '3. stol. př. Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'V Alexandrii vzniká řecký překlad Starého zákona. Apoštolové z něj '
        'často citují.',
    refs: [],
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
    refs: [],
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
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Jan Křtitel a Ježíšův křest',
    date: 'cca 27–29 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Lukáš datuje vystoupení Jana Křtitele do 15. roku vlády '
        'císaře Tiberia.',
    refs: [VerseRef(42, 3, 1), VerseRef(41, 1), VerseRef(43, 1, 29)],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Ježíšovo působení',
    date: 'cca 28–30 (33) po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ježíš káže o Božím království, uzdravuje a povolává učedníky, '
        'hlavně v Galileji. Jan zmiňuje tři svátky Paschy.',
    refs: [VerseRef(40, 5), VerseRef(41, 1, 15), VerseRef(43, 6)],
  ),
  TimelineEvent(
    era: TimelineEra.jesus,
    title: 'Ukřižování a vzkříšení',
    date: '30 nebo 33 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Ježíš je ukřižován za prefekta Pontia Piláta (26–36), o kterém '
        'píše i Tacitus a nápis z Cesareje. Třetího dne vstal z mrtvých.',
    refs: [
      VerseRef(40, 27),
      VerseRef(40, 28),
      VerseRef(43, 20),
      VerseRef(46, 15, 3),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Letnice a vznik církve',
    date: '30 nebo 33 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Seslání Ducha svatého v Jeruzalémě, Petrovo kázání a křest tří '
        'tisíc lidí.',
    refs: [VerseRef(44, 1, 8), VerseRef(44, 2)],
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
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Pavlovy misijní cesty',
    date: 'cca 46–57 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Evangelium se šíří do Malé Asie a Řecka. Pobyt v Korintu datuje '
        'nápis o prokonzulu Galliónovi (51/52 po Kr.). Vznikají Pavlovy '
        'dopisy.',
    refs: [
      VerseRef(44, 13),
      VerseRef(44, 16),
      VerseRef(44, 18, 12),
      VerseRef(44, 19),
    ],
  ),
  TimelineEvent(
    era: TimelineEra.church,
    title: 'Apoštolský sněm v Jeruzalémě',
    date: 'cca 49 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Apoštolové rozhodují, že pohané nemusejí přijmout obřízku ani '
        'celý Mojžíšův zákon.',
    refs: [VerseRef(44, 15), VerseRef(48, 2)],
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
    title: 'Jan na Patmu – Zjevení',
    date: 'cca 95 po Kr.',
    certainty: DatingCertainty.approximate,
    description:
        'Za císaře Domitiána sepisuje Jan vidění o Kristově vítězství '
        'a novém stvoření.',
    refs: [VerseRef(66, 1, 9), VerseRef(66, 21)],
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
