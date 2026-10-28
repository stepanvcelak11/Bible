"""Biblická témata (vlastní texty aplikace).

Každé téma: krátké shrnutí, které se drží toho, na čem se shodují
křesťané různých tradic, a klíčová místa s popiskem. Odkazy v kanonickém
(hebrejském) číslování.
"""

CATEGORIES = [
    ("god", "Bůh"),
    ("jesus", "Ježíš Kristus a Duch svatý"),
    ("salvation", "Člověk, hřích a spasení"),
    ("life", "Život víry"),
    ("relations", "Vztahy a společnost"),
    ("church", "Církev"),
    ("future", "Budoucnost a naděje"),
]

T = []


def topic(id, cat, icon, title, summary, refs):
    T.append(dict(id=id, category=cat, icon=icon, title=title,
                  summary=summary, refs=refs))


# --- Bůh -------------------------------------------------------------------------
topic("creator", "god", "sun", "Bůh Stvořitel",
      "Bible začíná Bohem, který slovem stvořil svět a nazval ho dobrým. "
      "Stvoření ukazuje jeho moc a krásu, ale není samo bohem. Bůh svůj "
      "svět dál udržuje a pečuje o něj.",
      [("Gn 1,1", "Na počátku stvořil Bůh"),
       ("Gn 1,31", "Všechno bylo velmi dobré"),
       ("Ž 19,2", "Nebesa vypravují o Boží slávě"),
       ("Ž 104,24", "Jak mnohá jsou tvá díla"),
       ("Iz 40,26", "Kdo stvořil hvězdy"),
       ("J 1,3", "Všechno povstalo skrze Slovo"),
       ("Ko 1,16-17", "Vše stvořeno skrze Krista a pro něj"),
       ("Žd 11,3", "Vírou chápeme stvoření")])
topic("love", "god", "heart", "Boží láska",
      "„Bůh je láska“ – to není jen jedna z jeho vlastností, ale jádro toho, "
      "kým je. Jeho láska je věrná, nezasloužená a nejjasněji se ukázala "
      "v tom, že dal svého Syna.",
      [("Ex 34,6", "Bůh milosrdný a milostivý"),
       ("Jr 31,3", "Láskou věčnou jsem tě miloval"),
       ("Pl 3,22-23", "Jeho milosrdenství nekončí"),
       ("J 3,16", "Tak Bůh miluje svět"),
       ("Ř 5,8", "Kristus zemřel za nás hříšné"),
       ("Ř 8,38-39", "Nic nás neodloučí"),
       ("1J 4,8-10", "Bůh je láska"),
       ("1J 3,1", "Jsme nazváni Božími dětmi")])
topic("holiness", "god", "flame", "Boží svatost",
      "Svatost znamená, že Bůh je naprosto jiný než my – čistý, dokonalý "
      "a vznešený. Proto se před ním člověk cítí malý. Bůh však svatost "
      "nedrží pro sebe: volá svůj lid, aby byl svatý jako on.",
      [("Ex 15,11", "Kdo je jako ty, vznešený svatostí"),
       ("Lv 19,2", "Buďte svatí, neboť já jsem svatý"),
       ("Iz 6,1-8", "Svatý, svatý, svatý"),
       ("Ž 99,9", "Hospodin, náš Bůh, je svatý"),
       ("Žd 12,14", "Usilujte o posvěcení"),
       ("1Pt 1,15-16", "Buďte svatí v celém svém jednání"),
       ("Zj 4,8", "Svatý je Pán Bůh všemohoucí")])
topic("trinity", "god", "spa", "Trojice",
      "Bible učí, že Bůh je jeden, a zároveň mluví o Otci, Synu a Duchu "
      "svatém jako o Bohu. Křesťané to vyjadřují slovem Trojice: jeden "
      "Bůh ve třech osobách. Je to tajemství, které se zjevuje hlavně "
      "v Ježíšově životě.",
      [("Dt 6,4", "Hospodin je jediný"),
       ("Mt 3,16-17", "Při Ježíšově křtu: Syn, Duch i Otcův hlas"),
       ("Mt 28,19", "Křtěte ve jméno Otce i Syna i Ducha"),
       ("J 1,1", "Slovo bylo Bůh"),
       ("J 14,16-17", "Otec dá jiného Přímluvce"),
       ("2K 13,13", "Milost Pána, láska Boží, společenství Ducha")])
topic("faithfulness", "god", "shield", "Boží věrnost",
      "Bůh dodržuje, co slíbil. Celý příběh Bible je příběhem jeho "
      "věrnosti, i když lidé věrní nebyli. Na jeho slib se lze spolehnout "
      "i v nejistých časech.",
      [("Dt 7,9", "Bůh věrný, který zachovává smlouvu"),
       ("Joz 21,45", "Nepadlo ani jedno slovo"),
       ("Ž 36,6", "Tvá věrnost až k oblakům"),
       ("Pl 3,23", "Veliká je tvá věrnost"),
       ("1K 10,13", "Bůh je věrný v pokušení"),
       ("2Tm 2,13", "Jsme-li nevěrní, on zůstává věrný"),
       ("Žd 10,23", "Věrný je ten, který dal zaslíbení")])

# --- Ježíš Kristus a Duch svatý -------------------------------------------------
topic("jesus", "jesus", "person", "Kdo je Ježíš",
      "Ježíš z Nazareta je podle Nového zákona zaslíbený Mesiáš (Kristus), "
      "Syn Boží a zároveň plně člověk. Ukazuje, jaký je Bůh, učí "
      "o Božím království, uzdravuje a dává svůj život za druhé.",
      [("Iz 9,5", "Dítě se nám narodilo"),
       ("J 1,14", "Slovo se stalo tělem"),
       ("Mt 16,15-16", "Ty jsi Mesiáš, Syn živého Boha"),
       ("J 14,9", "Kdo vidí mne, vidí Otce"),
       ("Fp 2,5-11", "Ponížil sám sebe"),
       ("Ko 1,15", "Obraz neviditelného Boha"),
       ("Žd 4,15", "Byl pokoušen jako my, ale bez hříchu")])
topic("cross", "jesus", "heart", "Kříž a smíření",
      "Ježíšova smrt na kříži je středem křesťanské víry. Bible ji popisuje "
      "mnoha obrazy: oběť za hříchy, výkupné, smíření s Bohem, vítězství "
      "nad zlem. Ježíš vzal na sebe to, co patřilo nám.",
      [("Iz 53,4-6", "On nesl naše nemoci"),
       ("Mk 10,45", "Dát svůj život jako výkupné"),
       ("J 1,29", "Beránek Boží"),
       ("Ř 5,10", "Smířeni s Bohem smrtí jeho Syna"),
       ("2K 5,21", "Učinil ho hříchem za nás"),
       ("1Pt 2,24", "Vynesl naše hříchy na dřevo"),
       ("Ko 2,15", "Zvítězil nad mocnostmi")])
topic("resurrection", "jesus", "sun", "Vzkříšení",
      "Třetího dne Ježíš vstal z mrtvých – to je základ, na kterém stojí "
      "celá víra. Vzkříšení potvrzuje, kým Ježíš je, a dává naději, že "
      "smrt nemá poslední slovo ani pro nás.",
      [("Mt 28,5-6", "Není zde, byl vzkříšen"),
       ("L 24,36-43", "Vzkříšený jí s učedníky"),
       ("J 11,25", "Já jsem vzkříšení a život"),
       ("1K 15,3-8", "Starobylé vyznání o vzkříšení"),
       ("1K 15,20", "Kristus je prvotina zesnulých"),
       ("1K 15,54-57", "Smrt pohlcena ve vítězství"),
       ("1Pt 1,3", "Znovuzrozeni k živé naději")])
topic("spirit", "jesus", "flame", "Duch svatý",
      "Duch svatý je Boží přítomnost v člověku a v církvi. Dává nový "
      "život, utěšuje, vede do pravdy, dává sílu ke svědectví a mění "
      "charakter – přináší „ovoce Ducha“.",
      [("Ez 36,26-27", "Dám vám nového ducha"),
       ("J 14,26", "Přímluvce vás naučí všemu"),
       ("J 16,13", "Uvede vás do veškeré pravdy"),
       ("Sk 1,8", "Přijmete moc"),
       ("Sk 2,1-4", "Letnice"),
       ("Ř 8,26", "Duch se za nás přimlouvá"),
       ("Ga 5,22-23", "Ovoce Ducha"),
       ("1K 12,4-7", "Rozdílná obdarování, týž Duch")])

# --- Člověk, hřích a spasení ---------------------------------------------------------
topic("image", "salvation", "person", "Člověk k Božímu obrazu",
      "Každý člověk je stvořen k Božímu obrazu – muž i žena. Odtud pramení "
      "jeho důstojnost a hodnota, nezávislá na výkonu, zdraví nebo "
      "postavení. Člověk dostal úkol pečovat o stvoření.",
      [("Gn 1,26-28", "Učiňme člověka k našemu obrazu"),
       ("Gn 2,7", "Bůh vdechl dech života"),
       ("Ž 8,5-6", "Co je člověk?"),
       ("Ž 139,13-14", "Utkal jsi mě v lůně matky"),
       ("Jk 3,9", "I bližní je stvořen k Boží podobě"),
       ("Ko 3,10", "Obnovován k obrazu Stvořitele")])
topic("sin", "salvation", "cloud", "Hřích",
      "Hřích není jen porušení pravidla, ale porušený vztah s Bohem – "
      "člověk se staví do středu místo Boha. Týká se všech a má následky "
      "pro jednotlivce i svět. Bible o hříchu mluví otevřeně, protože "
      "nabízí cestu ven.",
      [("Gn 3,6-8", "První neposlušnost"),
       ("Iz 59,2", "Vaše viny vás oddělily od Boha"),
       ("Jr 17,9", "Srdce je nevyzpytatelné"),
       ("Ř 3,23", "Všichni zhřešili"),
       ("Ř 6,23", "Mzdou hříchu je smrt, darem věčný život"),
       ("Jk 1,14-15", "Jak vzniká hřích"),
       ("1J 1,8-9", "Vyznání a odpuštění")])
topic("repentance", "salvation", "refresh", "Pokání a obrácení",
      "Pokání znamená obrat – změnu myšlení i směru života. Není to jen "
      "lítost, ale návrat k Bohu. Bible ho popisuje jako radostnou věc: "
      "Bůh čeká jako otec na marnotratného syna.",
      [("Ez 18,31-32", "Proč byste měli zemřít? Obraťte se"),
       ("Jl 2,12-13", "Roztrhněte svá srdce"),
       ("Mk 1,15", "Čiňte pokání a věřte evangeliu"),
       ("L 15,7", "Radost v nebi nad hříšníkem"),
       ("L 15,17-24", "Marnotratný syn se vrací"),
       ("Sk 3,19", "Obraťte se, aby byly smazány hříchy"),
       ("2K 7,10", "Zármutek podle Boží vůle")])
topic("grace", "salvation", "heart", "Milost",
      "Milost je Boží nezasloužená přízeň. Spasení není odměna za zásluhy, "
      "ale dar, který přijímáme vírou. Milost však člověka nenechává "
      "stejného – učí ho žít nově.",
      [("Ř 3,24", "Ospravedlněni zdarma, z milosti"),
       ("Ř 5,20", "Kde se rozmohl hřích, rozhojnila se milost"),
       ("2K 12,9", "Stačí ti má milost"),
       ("Ef 2,8-9", "Milostí jste spaseni skrze víru"),
       ("Tt 2,11-12", "Milost nás vychovává"),
       ("J 1,16", "Milost za milostí")])
topic("faith", "salvation", "shield", "Víra",
      "Víra je důvěra v Boha a v jeho slovo – ne jen souhlas s myšlenkami, "
      "ale spolehnutí se na něj. Roste nasloucháním, zkouškami i "
      "poslušností. Živá víra se projevuje skutky.",
      [("Gn 15,6", "Abram uvěřil Hospodinu"),
       ("Abk 2,4", "Spravedlivý bude žít z víry"),
       ("Mk 9,24", "Věřím, pomoz mé nevíře"),
       ("Ř 10,17", "Víra je ze slyšení"),
       ("Žd 11,1", "Víra je jistota toho, v co doufáme"),
       ("Žd 11,6", "Bez víry se nelze Bohu líbit"),
       ("Jk 2,17", "Víra bez skutků je mrtvá")])
topic("forgiveness", "salvation", "refresh", "Odpuštění",
      "Bůh odpouští každému, kdo se k němu obrátí – úplně a navždy. "
      "Kdo zakusil odpuštění, je volán odpouštět i druhým. Odpustit "
      "neznamená schválit křivdu, ale vzdát se pomsty.",
      [("Ž 103,10-12", "Jak daleko je východ od západu"),
       ("Iz 1,18", "Budou bílé jako sníh"),
       ("Mi 7,18-19", "Hodí naše hříchy do hlubin moře"),
       ("Mt 6,12", "Odpusť nám, jako i my odpouštíme"),
       ("Mt 18,21-22", "Sedmasedmdesátkrát"),
       ("Ef 4,32", "Odpouštějte si, jako Bůh odpustil vám"),
       ("1J 1,9", "Vyznáváme-li hříchy, odpustí")])
topic("newbirth", "salvation", "sun", "Nový život v Kristu",
      "Kdo uvěří, dostává nový začátek – Ježíš mluví o novém narození. "
      "Pavel říká, že je „nové stvoření“. Nový život roste postupně, "
      "ale jeho začátek je Boží dar.",
      [("J 3,3-7", "Musíte se narodit znovu"),
       ("J 1,12-13", "Moc stát se Božími dětmi"),
       ("2K 5,17", "Kdo je v Kristu, je nové stvoření"),
       ("Ga 2,20", "Už nežiji já, ale žije ve mně Kristus"),
       ("Ef 4,22-24", "Obléci nového člověka"),
       ("Tt 3,5", "Obmytí znovuzrození")])

# --- Život víry -------------------------------------------------------------------
topic("prayer", "life", "help", "Modlitba",
      "Modlitba je rozhovor s Bohem – chvála, díky, prosba, přímluva "
      "i nářek. Ježíš učil modlit se jednoduše a důvěrně jako k Otci. "
      "Modlit se lze kdykoli a kdekoli.",
      [("Ž 62,9", "Vylévejte před ním srdce"),
       ("Mt 6,6-13", "Modlitba Páně"),
       ("Mt 7,7-8", "Proste a bude vám dáno"),
       ("L 18,1", "Modlit se vytrvale"),
       ("Fp 4,6-7", "Se vším se obracejte k Bohu"),
       ("1Te 5,17", "V modlitbách neustávejte"),
       ("Jk 5,16", "Modlitba spravedlivého má velkou moc")])
topic("word", "life", "signpost", "Boží slovo",
      "Bible je podle své vlastní výpovědi slovo, skrze které Bůh mluví. "
      "Je světlem na cestu, vyučuje, napomíná a vede k Ježíši. Nestačí "
      "ho jen číst – má se podle něj žít.",
      [("Dt 6,6-7", "Ať jsou ta slova v tvém srdci"),
       ("Ž 1,2-3", "Kdo rozjímá o Zákoně"),
       ("Ž 119,105", "Svítilnou mým nohám je tvé slovo"),
       ("Iz 40,8", "Slovo našeho Boha trvá navěky"),
       ("Mt 4,4", "Nejen chlebem bude člověk živ"),
       ("2Tm 3,16-17", "Celé Písmo je inspirováno Bohem"),
       ("Žd 4,12", "Slovo Boží je živé"),
       ("Jk 1,22", "Buďte činiteli slova")])
topic("humility", "life", "person", "Pokora",
      "Pokora není podceňování sebe, ale pravdivý pohled na sebe před "
      "Bohem. Ježíš sám se ponížil a umýval nohy. Bůh pyšným odporuje, "
      "ale pokorným dává milost.",
      [("Př 11,2", "S pokornými je moudrost"),
       ("Mi 6,8", "Pokorně chodit se svým Bohem"),
       ("Mt 18,4", "Kdo se poníží jako dítě"),
       ("J 13,14-15", "Dal jsem vám příklad"),
       ("Fp 2,3-4", "V pokoře pokládejte druhé za přednější"),
       ("Jk 4,6", "Pokorným dává milost"),
       ("1Pt 5,5-6", "Oblecte se pokorou")])
topic("temptation", "life", "shield", "Pokušení",
      "Pokušení přichází na každého, i Ježíš byl pokoušen. Pokušení samo "
      "není hřích; Bůh slibuje sílu a cestu ven. Pomáhá znát své slabé "
      "chvíle a nebýt na boj sám.",
      [("Gn 39,9-12", "Josef utíká před pokušením"),
       ("Mt 4,1-11", "Ježíš odolává ďáblovi slovem Písma"),
       ("Mt 26,41", "Bděte a modlete se"),
       ("1K 10,13", "Bůh dá i východisko"),
       ("Žd 2,18", "Může pomoci pokoušeným"),
       ("Jk 1,12-14", "Blahoslavený, kdo obstojí"),
       ("Jk 4,7", "Vzepřete se ďáblu")])
topic("suffering", "life", "rain", "Utrpení",
      "Bible utrpení nevysvětluje jednoduše. Jób, žalmy i Ježíš dávají "
      "prostor nářku i otázkám „proč“. Zároveň ukazuje Boha, který v "
      "utrpení není daleko, sám trpěl a jednou setře každou slzu.",
      [("Jb 1,20-22", "Hospodin dal, Hospodin vzal"),
       ("Ž 22,2", "Bože můj, proč jsi mě opustil?"),
       ("Ž 34,19", "Blízko je zkroušeným"),
       ("Iz 43,2", "Půjdeš-li přes vody, budu s tebou"),
       ("Ř 8,18", "Utrpení nelze srovnat s budoucí slávou"),
       ("2K 4,16-18", "Vnitřně se obnovujeme den ze dne"),
       ("Zj 21,4", "Setře každou slzu")])
topic("peace", "life", "cloud", "Pokoj",
      "Biblický pokoj (šalom) je víc než klid – je to celistvost, smíření "
      "a dobrý vztah s Bohem, lidmi i sebou. Ježíš dává pokoj, který "
      "není závislý na okolnostech.",
      [("Nu 6,24-26", "Ať ti Hospodin dá pokoj"),
       ("Iz 26,3", "Pokoj tomu, kdo na tebe spoléhá"),
       ("J 14,27", "Pokoj vám zanechávám"),
       ("J 16,33", "Ve mně máte pokoj"),
       ("Ř 5,1", "Pokoj s Bohem"),
       ("Fp 4,7", "Pokoj, který převyšuje rozum"),
       ("Mt 5,9", "Blahoslavení tvůrci pokoje")])
topic("joy", "life", "sun", "Radost a vděčnost",
      "Radost je v Bibli ovocem Ducha, ne jen dobrou náladou. Pramení "
      "z Boží blízkosti, a proto je možná i v těžkostech. Vděčnost je "
      "cesta, jak radost pěstovat.",
      [("Neh 8,10", "Radost z Hospodina je vaše síla"),
       ("Ž 16,11", "Hojnost radostí u tebe"),
       ("Ž 100,4", "Vcházejte s díkůvzdáním"),
       ("Abk 3,17-18", "I kdyby fíkovník nekvetl"),
       ("J 15,11", "Aby vaše radost byla plná"),
       ("Fp 4,4", "Radujte se v Pánu vždycky"),
       ("1Te 5,16-18", "Za všech okolností děkujte")])
topic("money", "life", "battery", "Peníze a štědrost",
      "Bible nevidí majetek jako zlý, ale varuje před láskou k penězům "
      "a chamtivostí. Učí spokojenosti, poctivosti a štědrosti – vše, "
      "co máme, je svěřené od Boha.",
      [("Př 3,9-10", "Cti Hospodina svým majetkem"),
       ("Mt 6,19-21", "Kde je tvůj poklad"),
       ("Mt 6,24", "Nemůžete sloužit Bohu i mamonu"),
       ("L 12,15", "Varujte se chamtivosti"),
       ("2K 9,6-7", "Ochotného dárce miluje Bůh"),
       ("1Tm 6,6-10", "Láska k penězům je kořen zla"),
       ("Žd 13,5", "Buďte spokojeni s tím, co máte")])
topic("work", "life", "mountain", "Práce a odpočinek",
      "Práce je součástí Božího záměru od stvoření – Adam měl zahradu "
      "obdělávat a střežit. Bůh však dal i den odpočinku. Křesťan má "
      "pracovat poctivě „jako pro Pána“ a umět si odpočinout v Bohu.",
      [("Gn 2,15", "Obdělávat a střežit zahradu"),
       ("Ex 20,8-11", "Pamatuj na den odpočinku"),
       ("Ž 127,1-2", "Nestaví-li dům Hospodin"),
       ("Kaz 3,1", "Všechno má svůj čas"),
       ("Mk 2,27", "Sobota je pro člověka"),
       ("Mt 11,28-30", "Pojďte ke mně, já vám dám odpočinout"),
       ("Ko 3,23", "Pracujte jako pro Pána"),
       ("2Te 3,10-12", "Kdo nechce pracovat")])

# --- Vztahy a společnost ----------------------------------------------------------
topic("neighbor", "relations", "person", "Láska k bližnímu",
      "Ježíš shrnul Zákon do dvou přikázání: milovat Boha a bližního jako "
      "sebe. Bližním je každý, komu můžu pomoci – i cizinec nebo nepřítel. "
      "Láska se ukazuje v činech.",
      [("Lv 19,18", "Miluj bližního jako sám sebe"),
       ("Mt 22,37-40", "Největší přikázání"),
       ("L 10,30-37", "Milosrdný Samařan"),
       ("Mt 5,44", "Milujte své nepřátele"),
       ("J 13,34-35", "Podle toho poznají, že jste moji"),
       ("1K 13,4-7", "Láska je trpělivá"),
       ("1J 3,18", "Milujme skutkem a pravdou")])
topic("marriage", "relations", "heart", "Manželství",
      "Bible představuje manželství jako smlouvu věrnosti mezi mužem "
      "a ženou, kteří se stávají „jedním tělem“. Má být místem lásky, "
      "vzájemné úcty, služby a odpuštění.",
      [("Gn 2,18-24", "Není dobré, aby byl člověk sám"),
       ("Př 18,22", "Kdo nalezl manželku, nalezl dobro"),
       ("Pís 8,6-7", "Láska je silná jako smrt"),
       ("Mt 19,4-6", "Co Bůh spojil"),
       ("Ef 5,21-33", "Podřizujte se jeden druhému"),
       ("Ko 3,18-19", "Manželé, milujte své ženy"),
       ("Žd 13,4", "Manželství ať mají všichni v úctě")])
topic("family", "relations", "person", "Rodina a výchova",
      "Rodina je místem, kde se předává víra – hlavně příkladem a "
      "rozhovorem v běžném dni. Děti mají rodiče ctít, rodiče mají děti "
      "vést s láskou a nedráždit je.",
      [("Ex 20,12", "Cti otce i matku"),
       ("Dt 6,6-7", "Mluv o tom doma i na cestě"),
       ("Ž 127,3", "Synové jsou dědictví od Hospodina"),
       ("Př 22,6", "Vychovávej chlapce"),
       ("Mk 10,13-16", "Nechte děti přicházet ke mně"),
       ("Ef 6,1-4", "Děti a otcové"),
       ("2Tm 1,5", "Víra babičky a matky")])
topic("friendship", "relations", "person", "Přátelství",
      "Bible zná hluboká přátelství – David a Jonatan, Rút a Noemi. "
      "Přítel miluje v každé době, říká pravdu a stojí při druhém. "
      "Ježíš nazval své učedníky přáteli.",
      [("1S 18,1-3", "David a Jonatan"),
       ("Rt 1,16-17", "Kam půjdeš ty, půjdu i já"),
       ("Př 17,17", "Přítel miluje v každé době"),
       ("Př 27,6", "Rány od přítele jsou věrné"),
       ("Kaz 4,9-12", "Dva jsou lepší než jeden"),
       ("J 15,13-15", "Nazval jsem vás přáteli")])
topic("justice", "relations", "signpost", "Spravedlnost a chudí",
      "Bůh se v Bibli opakovaně zastává chudých, vdov, sirotků a cizinců. "
      "Proroci ostře kritizují útlak a prázdnou zbožnost. Starost "
      "o potřebné je zkouškou pravé víry.",
      [("Dt 10,18-19", "Bůh se ujímá cizince"),
       ("Ž 82,3-4", "Zjednejte právo slabým"),
       ("Př 31,8-9", "Otevři ústa za němého"),
       ("Iz 1,17", "Učte se konat dobro"),
       ("Am 5,24", "Ať se valí právo jako voda"),
       ("Mt 25,35-40", "Cokoli jste učinili jednomu z nejmenších"),
       ("Jk 1,27", "Zbožnost čistá: pečovat o sirotky a vdovy")])
topic("authority", "relations", "mountain", "Křesťan a společnost",
      "Křesťané mají hledat dobro města, kde žijí, modlit se za vládnoucí "
      "a respektovat řád. Zároveň platí, že víc je třeba poslouchat Boha "
      "než lidi. Mají být „solí a světlem“ uprostřed společnosti.",
      [("Jr 29,7", "Hledejte pokoj města"),
       ("Mt 5,13-16", "Sůl země a světlo světa"),
       ("Mt 22,21", "Dejte císaři, co je císařovo"),
       ("Sk 5,29", "Více poslouchat Boha než lidi"),
       ("Ř 13,1-7", "Podřizovat se vládnoucí moci"),
       ("1Tm 2,1-2", "Modlitby za vládce")])

# --- Církev -----------------------------------------------------------------------
topic("church", "church", "person", "Církev",
      "Církev nejsou budovy, ale lidé, kteří patří Kristu – jeho tělo. "
      "Má různé dary a služby, ale jednoho Pána. Schází se ke slovu, "
      "modlitbě, večeři Páně a vzájemné péči.",
      [("Mt 16,18", "Na té skále zbuduji svou církev"),
       ("Mt 18,20", "Kde jsou dva nebo tři"),
       ("Sk 2,42-47", "Život prvních křesťanů"),
       ("1K 12,12-27", "Jedno tělo, mnoho údů"),
       ("Ef 4,11-16", "Dary pro budování těla"),
       ("Žd 10,24-25", "Neopouštějme společná shromáždění"),
       ("1Pt 2,9", "Vyvolený rod, královské kněžstvo")])
topic("baptism", "church", "rain", "Křest",
      "Křest je znamení, které ustanovil Ježíš: vyjadřuje očištění, "
      "spojení s Kristovou smrtí a vzkříšením a začlenění do církve. "
      "Církve se liší v tom, kdy a jak křtí, ale všechny ho slaví.",
      [("Mt 3,13-17", "Ježíšův křest"),
       ("Mt 28,19", "Křtěte všechny národy"),
       ("Sk 2,38", "Čiňte pokání a dejte se pokřtít"),
       ("Sk 8,36-38", "Křest etiopského dvořana"),
       ("Ř 6,3-4", "Pohřbeni s ním křtem"),
       ("Ga 3,27", "Oblékli jste Krista")])
topic("supper", "church", "heart", "Večeře Páně",
      "Při poslední večeři dal Ježíš učedníkům chléb a kalich jako "
      "znamení svého těla a krve – nové smlouvy. Církev ji slaví na jeho "
      "památku, ve společenství a v očekávání jeho příchodu. Tradice "
      "se liší v jejím chápání, ne v jejím významu pro víru.",
      [("Ex 12,13-14", "Pascha – předobraz"),
       ("Mt 26,26-29", "Ustanovení večeře"),
       ("L 22,19-20", "To čiňte na mou památku"),
       ("J 6,35", "Já jsem chléb života"),
       ("1K 10,16-17", "Jeden chléb, jedno tělo"),
       ("1K 11,23-26", "Zvěstujete smrt Páně, dokud nepřijde")])
topic("witness", "church", "signpost", "Svědectví a misie",
      "Ježíš poslal své učedníky, aby nesli evangelium všem národům. "
      "Svědectví není jen úkolem kazatelů – každý může vyprávět, co "
      "s Bohem prožil, a žít tak, aby se druzí ptali.",
      [("Iz 52,7", "Jak krásné jsou nohy posla"),
       ("Mt 28,18-20", "Jděte a získávejte učedníky"),
       ("Sk 1,8", "Budete mými svědky"),
       ("Ř 10,14-15", "Jak uvěří, neuslyší-li"),
       ("2K 5,20", "Jsme Kristovi vyslanci"),
       ("Ko 4,5-6", "Vaše řeč ať je vždy laskavá"),
       ("1Pt 3,15", "Připraveni vydat počet z naděje")])

# --- Budoucnost a naděje ----------------------------------------------------------
topic("return", "future", "sun", "Ježíšův druhý příchod",
      "Nový zákon s jistotou očekává, že Ježíš se vrátí ve slávě. Kdy "
      "to bude, nikdo neví – proto vybízí bdít a žít věrně. Je to "
      "zpráva naděje, ne strachu.",
      [("Mt 24,36", "O tom dni nikdo neví"),
       ("Mt 25,13", "Bděte"),
       ("J 14,2-3", "Zase přijdu a vezmu vás k sobě"),
       ("Sk 1,11", "Přijde stejně, jak odešel"),
       ("1Te 4,16-18", "Potěšujte se těmito slovy"),
       ("Tt 2,13", "Očekáváme blahoslavenou naději"),
       ("Zj 22,20", "Ano, přijdu brzy")])
topic("judgment", "future", "flame", "Soud",
      "Bible mluví o Božím soudu, při kterém vyjde najevo pravda a bude "
      "zjednána spravedlnost. Pro oběti křivd je to naděje. Kdo je "
      "v Kristu, nemusí se soudu bát – soudcem je ten, který za nás zemřel.",
      [("Kaz 12,14", "Bůh přivede na soud každý čin"),
       ("Mt 25,31-46", "Syn člověka bude soudit národy"),
       ("J 5,24", "Kdo věří, nepřichází na soud"),
       ("Ř 2,6", "Odplatí každému podle jeho skutků"),
       ("Ř 8,1", "Žádné odsouzení v Kristu"),
       ("2K 5,10", "Všichni se ukážeme před soudnou stolicí"),
       ("Žd 9,27", "Lidem je určeno jednou zemřít, potom soud")])
topic("newcreation", "future", "mountain", "Věčný život a nové stvoření",
      "Věčný život začíná už teď poznáním Boha a vrcholí vzkříšením. "
      "Bible končí obrazem nového nebe a nové země, kde Bůh přebývá "
      "s lidmi, kde nebude smrt ani pláč. Křesťanská naděje je naděje "
      "pro celé stvoření.",
      [("Iz 65,17", "Stvořím nová nebesa a novou zemi"),
       ("J 17,3", "Věčný život je poznávat Boha"),
       ("Ř 8,19-21", "Stvoření bude osvobozeno"),
       ("1K 2,9", "Co oko nevidělo"),
       ("Fp 3,20-21", "Naše domovská obec je v nebesích"),
       ("Zj 21,1-5", "Hle, všechno činím nové"),
       ("Zj 22,1-5", "Řeka života")])
