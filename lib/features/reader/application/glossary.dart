import '../../search/application/reference_parser.dart';

/// Heslo slovníčku biblického světa: věc, míra, mince, skupina nebo zvyk,
/// který dnešní čtenář nemusí znát. Rozpozná se přímo v textu verše.
class GlossaryEntry {
  const GlossaryEntry(
    this.title,
    this.patterns,
    this.text, {
    this.newTestamentOnly = false,
  });

  final String title;

  /// Jen v Novém zákoně (Kralická „peníz“ = denár jen tam).
  final bool newTestamentOnly;

  /// Tvary bez diakritiky: „slovo“ = přesné slovo, „slov*“ = začátek slova.
  final List<String> patterns;
  final String text;
}

/// Vlastní texty aplikace – jednoduše, aby si čtenář dokázal věc představit.
const glossary = <GlossaryEntry>[
  // --- Peníze -----------------------------------------------------------------
  GlossaryEntry(
    'Denár',
    ['denar*'],
    'Stříbrná římská mince velká asi jako dnešní desetikoruna. Byla to '
        'obvyklá denní mzda dělníka na vinici – tedy „peníze za jeden '
        'den práce“.',
  ),
  GlossaryEntry(
    'Denár (peníz)',
    ['peniz', 'penizi'],
    'V Kralické „peníz“ v evangeliích znamená denár – stříbrnou římskou '
        'minci s císařovým obrazem, denní mzdu dělníka.',
    newTestamentOnly: true,
  ),
  GlossaryEntry(
    'Drachma (groš)',
    ['drachm*', 'gros', 'grose', 'grosu', 'grosi', 'grosem'],
    'Řecká stříbrná mince v hodnotě zhruba jednoho denáru – asi denní '
        'mzda. Ztracený groš v Lk 15 byl pro chudou ženu velká ztráta.',
  ),
  GlossaryEntry(
    'Hřivna',
    ['hrivn*'],
    'Velká jednotka váhy a peněz. Podle překladu označuje buď minu '
        '(asi 100 denárů, tedy tři až čtyři měsíce práce), nebo talent '
        '(přes 6000 denárů – mzda za mnoho let).',
  ),
  GlossaryEntry(
    'Talent',
    ['talent*'],
    'Největší jednotka váhy a peněz: asi 30–40 kg stříbra, tedy zhruba '
        '6000 denárů – mzda za 15–20 let práce. Z podobenství o talentech '
        'pochází i dnešní slovo „talent“ pro nadání.',
  ),
  GlossaryEntry(
    'Mina',
    ['mina', 'miny', 'minu', 'minami'],
    'Jednotka váhy a peněz: asi půl kila stříbra, 100 denárů – mzda za '
        'tři až čtyři měsíce.',
  ),
  GlossaryEntry(
    'Šekel',
    ['sekel*', 'sekl*', 'sikl*'],
    'Základní jednotka váhy (asi 11 g). Ve Starém zákoně se neplatilo '
        'mincemi, ale odváženým stříbrem – proto „šekel“ znamená váhu '
        'i cenu.',
  ),
  GlossaryEntry(
    'Nejmenší mince',
    ['sarty', 'sart', 'sartu', 'halir', 'halire', 'lepto*', 'kodrant*'],
    'Leptón byla nejmenší měděná mince v oběhu – asi 1/128 denáru. Dvě '
        'takové mince vdovy byly prakticky nic, a přece podle Ježíše '
        'dala nejvíc.',
  ),
  GlossaryEntry(
    'Statér',
    ['stater*'],
    'Stříbrná mince v hodnotě čtyř drachem – přesně chrámová daň za '
        'dva lidi (Petra a Ježíše, Mt 17,27).',
  ),
  GlossaryEntry(
    'Clo a daně',
    ['clo', 'cla', 'clu', 'cle', 'celnic*'],
    'Římané pronajímali výběr cel a daní místním lidem. Ti museli odvést '
        'pevnou částku a co vybrali navíc, si nechali – proto byli celníci '
        'považováni za zloděje a zrádce.',
  ),
  // --- Míry a váhy ------------------------------------------------------------
  GlossaryEntry(
    'Loket',
    ['loket', 'lokte', 'loktu', 'lokty', 'loktech', 'loktu', 'loktum'],
    'Délková míra od lokte po konec prostředníčku – asi 45 cm. Goliáš '
        'měřil „šest loket a píď“, tedy kolem tří metrů (podle jiných '
        'rukopisů asi dva metry).',
  ),
  GlossaryEntry('Píď', [
    'pid',
    'pidi',
    'pidem',
  ], 'Rozpětí roztažené dlaně od palce po malíček – asi 22 cm, půl lokte.'),
  GlossaryEntry(
    'Efa',
    ['efa', 'efy', 'efu', 'efi', 'efou'],
    'Dutá míra na obilí a mouku, asi 22 litrů – zhruba velký kbelík. '
        'Desetina efy (omer) byla denní dávka many na osobu.',
  ),
  GlossaryEntry(
    'Chomer a kór',
    ['chomer*', 'chomeru'],
    'Velká míra na obilí – „oslí náklad“, asi 220 litrů. Odpovídá deseti '
        'efám.',
  ),
  GlossaryEntry(
    'Bat',
    ['bat', 'batu', 'batu', 'batech'],
    'Míra na tekutiny (olej, víno), asi 22 litrů – stejně jako efa '
        'u obilí.',
  ),
  GlossaryEntry('Hin', [
    'hin',
    'hinu',
  ], 'Menší míra na tekutiny, asi 3,5–4 litry.'),
  GlossaryEntry(
    'Stadium',
    ['stadi*'],
    'Řecká délková míra, asi 185 metrů – délka běžecké dráhy na '
        'stadionu. Odtud dnešní slovo stadion.',
  ),
  // --- Lidé a skupiny ---------------------------------------------------------
  GlossaryEntry(
    'Farizeové',
    ['farize*', 'farizej*'],
    'Zbožné hnutí laiků, kteří chtěli zachovávat Zákon v každodenním '
        'životě – při jídle, práci i sabatu. Lid si jich vážil. Ježíš je '
        'kritizoval, když se pravidla stala důležitější než milosrdenství.',
  ),
  GlossaryEntry(
    'Saduceové',
    ['saduce*', 'saducej*'],
    'Kněžská aristokracie kolem chrámu, spolupracovala s Římany. '
        'Uznávali jen pět knih Mojžíšových a nevěřili ve vzkříšení '
        'ani v anděly.',
  ),
  GlossaryEntry(
    'Zákoníci',
    ['zakonik*', 'zakonic*'],
    'Znalci a vykladači Zákona – učitelé a „právníci“ své doby. Opisovali '
        'Písmo a rozhodovali, jak se má přikázání v praxi dodržovat.',
  ),
  GlossaryEntry(
    'Celníci (publikáni)',
    ['publikan*', 'celnik*'],
    'Výběrčí cel a daní pro Římany. Často vybírali víc, než měli – lid je '
        'pokládal za podvodníky a kolaboranty. Ježíš s nimi přesto jedl '
        'a jednoho (Matouše) povolal za učedníka.',
  ),
  GlossaryEntry(
    'Levité',
    ['levit*'],
    'Potomci Léviho, kmene určeného ke službě ve svatyni. Pomáhali kněžím, '
        'starali se o chrám, zpěv a stráž. Nedostali vlastní území, žili '
        'z desátků.',
  ),
  GlossaryEntry(
    'Samaří a Samaritáni',
    ['samar*', 'samaritan*'],
    'Obyvatelé střední části země, potomci Izraelců smíšených s jinými '
        'národy. Uctívali Boha na hoře Gerizim a uznávali jen Tóru. Židé '
        'a Samaritáni se navzájem nesnášeli – proto byl „milosrdný '
        'Samaritán“ tak šokující.',
  ),
  GlossaryEntry(
    'Velerada',
    ['velerad*', 'sanhedr*'],
    'Nejvyšší židovský soud v Jeruzalémě – 71 členů v čele s veleknězem. '
        'Za Římanů rozhodovala o náboženských věcech, ale trest smrti '
        'vynést nesměla.',
  ),
  GlossaryEntry(
    'Velekněz',
    ['velekn*'],
    'Nejvyšší kněz Izraele. Jen on směl jednou za rok, o Dni smíření, '
        'vstoupit do velesvatyně. Za Ježíše úřad obsazovali Římané '
        'a Herodes.',
  ),
  GlossaryEntry(
    'Setník',
    ['setnik*'],
    'Římský důstojník velící asi stovce vojáků (centurio). Setníci jsou '
        'v Novém zákoně často vylíčeni kladně – jeden z nich vyznal pod '
        'křížem: „Tento byl Syn Boží.“',
  ),
  GlossaryEntry(
    'Místodržitel',
    ['prokurator*', 'mistodrzi*'],
    'Římský správce provincie (Pilát v Judsku). Měl vojsko, vybíral daně '
        'a jako jediný mohl vynést rozsudek smrti.',
  ),
  GlossaryEntry(
    'Tetrarcha (čtvrták)',
    ['ctvrtak*', 'tetrarch*'],
    'Doslova „vládce čtvrtiny“ – menší panovník závislý na Římu. Herodes '
        'Antipas, který dal popravit Jana Křtitele, byl tetrarchou Galileje.',
  ),
  GlossaryEntry(
    'Vdovy a sirotci',
    ['vdov*', 'sirot*'],
    'Ve společnosti bez sociálního systému byli nejzranitelnější: neměli '
        'muže ani otce, který by je živil a hájil. Zákon i proroci proto '
        'opakovaně volají po jejich ochraně.',
  ),
  GlossaryEntry(
    'Otroci',
    ['otrok*', 'otrokyn*'],
    'Otroctví bylo ve starověku běžné – z dluhů, válek nebo narozením. '
        'Izraelský zákon ho omezoval (propuštění po šesti letech), v římském '
        'světě tvořili otroci velkou část obyvatel.',
  ),
  GlossaryEntry(
    'Pastýř',
    ['pastyr*', 'pastucha*'],
    'Pastýř vodil ovce na pastvu, hledal vodu a v noci je chránil před '
        'šelmami a zloději. Ovce znaly jeho hlas. Proto se „pastýř“ stal '
        'obrazem krále i Boha.',
  ),
  GlossaryEntry(
    'Tesař',
    ['tesar*'],
    'Řecké slovo tektón znamená řemeslníka, který pracuje se dřevem '
        'i kamenem – spíš „stavitel“. Ježíš i Josef tak živili rodinu.',
  ),
  // --- Svátky a zvyky -----------------------------------------------------------
  GlossaryEntry(
    'Sabat (sobota)',
    ['sabat*', 'sobot*'],
    'Sedmý den týdne, den odpočinku od pátečního do sobotního večera. '
        'Nesmělo se pracovat ani cestovat dál než asi kilometr. Připomínal '
        'stvoření i vysvobození z otroctví.',
  ),
  GlossaryEntry(
    'Pesach (Velikonoce)',
    ['velikonoc*', 'pesach*', 'fase', 'fasy', 'fasu'],
    'Svátek vysvobození z Egypta. Každá rodina jedla beránka, nekvašený '
        'chléb a hořké byliny a vyprávěla příběh exodu. Do Jeruzaléma '
        'tehdy přišly statisíce poutníků.',
  ),
  GlossaryEntry(
    'Letnice',
    ['letnic*'],
    'Svátek žní padesát dní po Pesachu (řecky Pentékosté – „padesátý“). '
        'Do chrámu se nesly první chleby z nové úrody.',
  ),
  GlossaryEntry(
    'Nekvašený chléb',
    ['nekvasen*', 'presnic*', 'presnych', 'presny'],
    'Plochý chléb bez kvasu, upečený narychlo. O Pesachu připomínal, že '
        'Izrael odcházel z Egypta ve spěchu a těsto nestihlo vykynout.',
  ),
  GlossaryEntry(
    'Kvas',
    ['kvas', 'kvasu', 'kvasem', 'kvasne', 'kvasny'],
    'Kousek starého zkvašeného těsta, který se přidával do nového. Malé '
        'množství prokvasí všechno – proto je kvas obrazem tichého růstu '
        '(Boží království) i šíření zla.',
  ),
  GlossaryEntry(
    'Obřízka',
    ['obriz*', 'obrez*'],
    'Znamení smlouvy s Abrahamem, prováděné chlapcům osmý den po narození. '
        'V první církvi se vedl velký spor, zda musí být obřezáni i pohané '
        '(Sk 15).',
  ),
  GlossaryEntry(
    'Desátek',
    ['desatek', 'desatk*', 'desatky'],
    'Desetina úrody a stáda odevzdávaná Bohu – na podporu levitů, kněží, '
        'chudých, vdov a cizinců.',
  ),
  GlossaryEntry(
    'Malomocenství',
    ['malomoc*'],
    'Souhrnné označení pro různé kožní nemoci (nejen dnešní lepru). '
        'Nemocný musel žít mimo obec a volat „nečistý!“. Ježíšův dotek '
        'malomocného byl proto něčím nevídaným.',
  ),
  GlossaryEntry(
    'Pomazání',
    ['pomaz*'],
    'Polití hlavy olejem při dosazení krále, kněze nebo proroka – '
        'znamení, že ho vybral Bůh. Hebrejsky „pomazaný“ = mašíach, '
        'Mesiáš; řecky Christos.',
  ),
  GlossaryEntry(
    'Nazírský slib',
    ['nazir*'],
    'Zvláštní zasvěcení Bohu: nestříhat si vlasy, nepít víno a nedotýkat '
        'se mrtvých. Nazírem byl například Samson.',
  ),
  GlossaryEntry(
    'Prvorozenství',
    ['prvoroz*'],
    'Nejstarší syn dostával dvojnásobný podíl dědictví a vedení rodu. '
        'Proto tolik záleželo na tom, komu otec požehná (Ezau a Jákob).',
  ),
  GlossaryEntry(
    'Paběrkování',
    ['paberk*'],
    'Zákon přikazoval nesklízet pole až do krajů a nechat na něm '
        'klasy, které spadly – pro chudé, vdovy a cizince. Tak se živila '
        'Rút na Bóazově poli.',
  ),
  GlossaryEntry(
    'Zápalná oběť',
    ['zapaln*'],
    'Oběť, při které se celé zvíře spálilo na oltáři – vyjadřovala úplné '
        'odevzdání Bohu.',
  ),
  // --- Svatyně --------------------------------------------------------------------
  GlossaryEntry(
    'Stánek úmluvy',
    ['stanek', 'stanku', 'stankem', 'svatostan*'],
    'Přenosná svatyně z látek a kůží, kterou Izrael nosil pouští. Měl '
        'nádvoří s oltářem, svatyni se svícnem a velesvatyni s truhlou '
        'smlouvy – předobraz pozdějšího chrámu.',
  ),
  GlossaryEntry(
    'Truhla smlouvy',
    ['truhl*'],
    'Pozlacená skříňka asi 110 × 70 × 70 cm s deskami Desatera. Víko se '
        'dvěma cheruby („slitovnice“) bylo místem Boží přítomnosti.',
  ),
  GlossaryEntry(
    'Efod',
    ['efod*'],
    'Kněžské roucho podobné zástěře, u velekněze zdobené zlatem '
        'a drahokamy. Patřil k němu náprsník s urim a tumim.',
  ),
  GlossaryEntry(
    'Urim a tumim',
    ['urim*', 'tumim*'],
    'Předměty v náprsníku velekněze, jimiž se hledala Boží odpověď ano/ne. '
        'Jak přesně fungovaly, dnes nevíme.',
  ),
  GlossaryEntry(
    'Svícen (menora)',
    ['svicen*', 'svicn*', 'menor*'],
    'Sedmiramenný zlatý svícen ve svatyni, kde stále hořel olej. Dnes je '
        'symbolem Izraele.',
  ),
  GlossaryEntry(
    'Kadidlo',
    ['kadid*'],
    'Vonná pryskyřice ze stromů jižní Arábie. Spalovala se na zlatém '
        'oltáři – obraz modliteb stoupajících k Bohu. Byla velmi drahá.',
  ),
  GlossaryEntry(
    'Synagoga',
    ['synagog*'],
    'Shromažďovací dům, kde se Židé v sobotu scházeli k modlitbě, čtení '
        'a výkladu Písma. Vznikly nejspíš během vyhnanství, kdy nebyl '
        'chrám.',
  ),
  // --- Předměty a příroda -----------------------------------------------------------
  GlossaryEntry(
    'Jho',
    ['jho', 'jha', 'jhu', 'jhem'],
    'Dřevěné břevno na šíji dvou volů, kterým se táhl pluh. Obraz '
        'podřízenosti a břemene – Ježíš nabízí „jho příjemné“.',
  ),
  GlossaryEntry(
    'Mlýnský kámen',
    ['mlyn*', 'zernov*'],
    'Obilí se mlelo mezi dvěma kameny – ručně (ženy každé ráno) nebo '
        'velkým kamenem, který otáčel osel. Pověsit někomu žernov na krk '
        'znamenalo jistou smrt ve vodě.',
  ),
  GlossaryEntry(
    'Mlat (humno)',
    ['mlat*', 'humn*'],
    'Udusané místo na kopci, kde se obilí mlátilo a vyhazovalo do větru: '
        'zrno spadlo zpět, plevy vítr odnesl. Obraz Božího soudu.',
  ),
  GlossaryEntry(
    'Měchy na víno',
    ['mech', 'mechy', 'mechu', 'mechach'],
    'Víno se uchovávalo v nádobách z kozí kůže. Nové víno ještě kvasí '
        'a roztahuje se – starý ztvrdlý měch by praskl.',
  ),
  GlossaryEntry(
    'Lis na víno',
    ['lis', 'lisu', 'lise', 'lisy', 'presu'],
    'Kamenná nádrž, ve které se hrozny šlapaly nohama; šťáva stékala do '
        'nižší jímky. Obraz radosti ze sklizně i Božího soudu.',
  ),
  GlossaryEntry(
    'Olivovník',
    ['olivov*', 'oliv*'],
    'Strom, který žije stovky let. Olivový olej sloužil k jídlu, svícení, '
        'léčení i pomazání. Getsemane znamená „lis na olej“.',
  ),
  GlossaryEntry(
    'Fíkovník',
    ['fikov*', 'fik', 'fiky', 'fiku'],
    'Jeden z nejcennějších stromů země. „Sedět pod svým fíkovníkem“ '
        'znamenalo žít v pokoji a bezpečí.',
  ),
  GlossaryEntry(
    'Cedr',
    ['cedr*'],
    'Vysoký vonný strom z Libanonu, nejcennější stavební dřevo starověku. '
        'Šalomoun z něj stavěl chrám i palác.',
  ),
  GlossaryEntry(
    'Yzop',
    ['yzop*', 'hyzop*', 'ysop*'],
    'Drobná aromatická bylina; svazečkem se kropilo krví nebo vodou při '
        'očišťování. „Pokrop mě yzopem“ (Ž 51) = očisti mě.',
  ),
  GlossaryEntry(
    'Myrha',
    ['myrh*'],
    'Vonná pryskyřice, drahá a hořká. Používala se k pomazání a balzamování '
        'mrtvých – mezi dary mudrců tak napovídá Ježíšovu smrt.',
  ),
  GlossaryEntry(
    'Nardový olej',
    ['nard*'],
    'Vzácný parfém z rostliny rostoucí v Himálaji. Láhev, kterou Marie '
        'vylila na Ježíše, měla cenu roční mzdy.',
  ),
  GlossaryEntry(
    'Mana',
    ['mana', 'manu', 'manou', 'many'],
    'Chléb z nebe, který Izrael sbíral na poušti každé ráno. Jméno '
        'pochází z otázky „Man hu?“ – „Co je to?“.',
  ),
  GlossaryEntry(
    'Jesle',
    ['jesl*'],
    'Žlab na krmení dobytka, často vytesaný z kamene. Zvířata se v zimě '
        'ustájila v přízemí domu nebo v jeskyni.',
  ),
  GlossaryEntry(
    'Sandály',
    ['strevic*', 'sandal*', 'obuv*'],
    'Lidé chodili v sandálech po prašných cestách. Rozvazovat a nosit '
        'pánovi obuv byla práce otroka – proto Jan říká, že není hoden '
        'ani rozvázat řemínek.',
  ),
  GlossaryEntry(
    'Cisterna a studna',
    ['cistern*', 'studn*'],
    'Vody bylo málo. Cisterny vytesané ve skále zachycovaly dešťovou vodu; '
        'prázdné sloužily i jako vězení (Josef, Jeremjáš). U studny se '
        'potkávali lidé – i budoucí manželé.',
  ),
  GlossaryEntry(
    'Svitek',
    ['svitek', 'svitk*'],
    'Knihy se psaly na pruhy papyru nebo kůže svinuté do role. Svitek '
        'Izajáše měřil přes sedm metrů.',
  ),
  GlossaryEntry(
    'Pečeť',
    ['pecet*'],
    'Otisk prstenu nebo válečku do hlíny či vosku. Potvrzoval pravost '
        'a uzavíral dokument – zlomit pečeť smel jen oprávněný.',
  ),
  GlossaryEntry(
    'Prak',
    ['prak', 'praku', 'prakem'],
    'Kožený řemínek na vrhání kamenů. V rukou zkušeného pastýře '
        'smrtelná zbraň – kámen letěl rychlostí přes 100 km/h.',
  ),
  GlossaryEntry(
    'Šofar (polnice)',
    ['sofar*', 'polnice', 'polnici', 'polnicemi', 'troub*'],
    'Trouba z beraního rohu. Svolávala lid, ohlašovala svátky, válku '
        'i příchod krále.',
  ),
  GlossaryEntry(
    'Harfa a lyra',
    ['harf*', 'loutn*', 'citar*'],
    'Strunné nástroje, na které hrál David. Lyra (kinnor) se nosila '
        'v rukou a doprovázela zpěv žalmů.',
  ),
  GlossaryEntry(
    'Lampa',
    ['lamp*', 'kahan*'],
    'Malá hliněná miska s olejem a knotem. Svítila slabě, proto se '
        'stavěla na podstavec – „na svícen“, ne pod nádobu.',
  ),
  GlossaryEntry(
    'Kříž',
    ['kriz', 'krize', 'krizi', 'krizem', 'ukriz*'],
    'Římský trest pro otroky a vzbouřence – nejkrutější a nejpotupnější '
        'smrt. Odsouzený nesl příčné břevno na místo popravy.',
  ),
];

/// Hesla rozpoznaná v textu (každé nejvýš jednou, v pořadí výskytu).
List<GlossaryEntry> glossaryFor(String text, {int bookId = 0}) {
  final words = foldCzech(text).split(RegExp(r'[^a-z0-9]+'));
  final found = <GlossaryEntry>[];
  for (final w in words) {
    if (w.length < 2) continue;
    for (final e in glossary) {
      if (found.contains(e)) continue;
      if (e.newTestamentOnly && bookId < 40) continue;
      for (final p in e.patterns) {
        final hit = p.endsWith('*')
            ? w.startsWith(p.substring(0, p.length - 1))
            : w == p;
        if (hit) {
          found.add(e);
          break;
        }
      }
    }
  }
  return found;
}
