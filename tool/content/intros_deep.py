"""Prohloubení úvodů ke knihám (vlastní text aplikace).

kniha → (historické pozadí, souvislost s Ježíšem a Novým zákonem,
jak knihu číst)
"""

DEEP = {
    1: ("Genesis vznikla v prostředí starověkého Předního východu, kde "
        "existovaly i jiné příběhy o stvoření a potopě (např. babylonský "
        "Enúma eliš a Epos o Gilgamešovi). Na rozdíl od nich Genesis "
        "představuje jediného Boha, který tvoří slovem, svět je dobrý "
        "a člověk má důstojnost Božího obrazu. Praotcové žili jako "
        "kočovní pastevci mezi Mezopotámií, Kenaanem a Egyptem.",
        "Nový zákon často navazuje na Genesis: Ježíš je „poslední Adam“ "
        "(1K 15,45), Abrahamova víra je vzorem pro křesťany (Ř 4) "
        "a zaslíbení, že v Abrahamovi dojdou požehnání všechny národy, "
        "se naplňuje v evangeliu (Ga 3,8).",
        "Čtěte nejdřív jako příběh – kapitoly 1–11 jako úvod k celé Bibli, "
        "12–50 jako rodinnou ságu. Všímejte si, jak Bůh jedná s "
        "nedokonalými lidmi a jak se opakuje motiv zaslíbení."),
    2: ("Izraelci žili v Egyptě jako cizinci a později otroci. Egypt "
        "Nové říše (16.–11. stol. př. Kr.) stavěl velká města; "
        "zmínky o otrocích pracujících na cihlách odpovídají době. Kniha "
        "zachycuje přechod od rodiny k národu.",
        "Pascha je pozadím poslední večeře; Ježíš je nazván „naším "
        "velikonočním beránkem“ (1K 5,7). Jan přirovnává Ježíše "
        "k svatostánku, v němž Bůh „přebýval mezi námi“ (J 1,14).",
        "Kapitoly 1–20 čtěte souvisle jako drama vysvobození. U popisu "
        "svatostánku (kap. 25–40) se ptejte, co říká o Boží svatosti "
        "a o přístupu k Bohu."),
    3: ("Leviticus popisuje bohoslužbu svatostánku v době putování. Oběti "
        "a předpisy o čistotě byly běžné i u okolních národů, ale "
        "v Izraeli vyjadřovaly vztah se svatým Bohem a péči o společenství "
        "(např. ochranu chudých a cizinců).",
        "List Židům vykládá oběti a Den smíření jako předobraz Kristovy "
        "jediné oběti (Žd 9–10). Ježíš cituje Lv 19,18 jako druhé "
        "největší přikázání (Mk 12,31).",
        "Nečtěte jen jako soupis pravidel. Ptejte se: co tento předpis "
        "chránil, co učil o Bohu a o hříchu? Dobře se čte spolu s listem "
        "Židům."),
    4: ("Izrael putuje Sínajskou pouští a Negebem; Kádeš-barnea byla "
        "oáza na jihu Kenaanu. Sčítání sloužila k organizaci tábora "
        "a armády.",
        "Pavel uvádí události putování jako varování i povzbuzení "
        "(1K 10,1–13). Ježíš přirovnává svůj kříž k měděnému hadu "
        "(Nu 21; J 3,14–15).",
        "Pasáže se seznamy můžete přelétnout; zastavte se u příběhů "
        "(kap. 11–14, 16–17, 20–24). Zeptejte se, kde ve svém životě "
        "„reptám“ místo důvěry."),
    5: ("Kniha má podobu smlouvy, připomínající starověké smlouvy mezi "
        "vládcem a poddanými: připomenutí dějin, ustanovení, požehnání "
        "a kletby, svědkové.",
        "Ježíš při pokušení na poušti odpovídá třikrát slovy z "
        "Deuteronomia (Mt 4,1–11). „Slyš, Izraeli“ nazývá největším "
        "přikázáním (Mk 12,29–30).",
        "Čtěte jako kázání starého vůdce lidu. Podtrhávejte si slova "
        "„pamatuj“, „miluj“ a „poslouchej“."),
    6: ("Kenaan byl rozdělen na městské státy, často v područí Egypta. "
        "Archeologie dobu dobývání nepopisuje jednoznačně a badatelé se "
        "v jejím výkladu liší; text sám ukazuje, že dobytí bylo "
        "postupné a neúplné (13,1).",
        "Jméno Jozue a Ježíš je stejné (hebrejsky Jehošua – „Hospodin "
        "zachraňuje“). List Židům mluví o „odpočinku“, který Jozue "
        "nedal plně a který přináší Kristus (Žd 4,8–11).",
        "Těžké pasáže o válce čtěte v jejich historickém kontextu a "
        "s vědomím, že šlo o jedinečnou událost, ne o vzor pro dnešek. "
        "Zaměřte se na Boží věrnost a na výzvu k rozhodnutí."),
    7: ("Doba soudců spadá do přechodu z doby bronzové do železné, kdy "
        "se rozpadly velké říše a na pobřeží se usadili Pelištejci. "
        "Kmeny byly volně propojené a často je ohrožovali sousedé.",
        "Soudci jsou nedokonalí zachránci; kniha vzbuzuje touhu po "
        "spravedlivém králi. List Židům uvádí Gedeóna, Baráka, Samsona "
        "i Jefteho mezi hrdiny víry (Žd 11,32).",
        "Sledujte opakující se cyklus (2,11–19). Příběhy jsou syrové – "
        "Bible je popisuje, ne schvaluje."),
    8: ("Příběh se odehrává v době soudců, v Betlémě a v Moábu. Zákon "
        "o paběrkování a o příbuzném-vykupiteli chránil vdovy a chudé "
        "(Lv 19,9–10; 25,25; Dt 25,5–10).",
        "Rút patří k ženám, které jsou výslovně jmenovány v Ježíšově "
        "rodokmenu (Mt 1,5). Bóaz "
        "jako vykupitel bývá chápán jako obraz Krista.",
        "Kniha je krátká – přečtěte ji najednou (asi 15 minut). Všímejte "
        "si, kde jedná Bůh skrytě a kde skrze laskavost lidí."),
    9: ("Pelištejci měli převahu díky zpracování železa (13,19–22). "
        "Kmeny potřebovaly jednotné vedení a žádaly krále jako okolní "
        "národy.",
        "David je předek Ježíše; Ježíšovo narození v Betlémě, Davidově "
        "městě, navazuje na tento příběh. Chanin chvalozpěv je podobný "
        "Mariinu chvalozpěvu (L 1,46–55).",
        "Sledujte tři postavy: Samuela, Saula a Davida. Ptejte se, čím "
        "se liší Saulovo a Davidovo srdce."),
    10: ("David sjednotil kmeny a z Jeruzaléma, dosud jebúsejského města, "
         "udělal hlavní město. Nápis z Tel Danu (9. stol. př. Kr.) "
         "zmiňuje „dům Davidův“.",
         "Zaslíbení trvalého Davidova rodu (kap. 7) je klíčem k "
         "očekávání Mesiáše; Ježíš je oslovován „Synu Davidův“ a anděl "
         "slibuje Marii Davidův trůn pro jejího syna (L 1,32).",
         "Kapitoly 11–12 čtěte spolu s Žalmem 51. Všimněte si, že kniha "
         "otevřeně ukazuje i selhání největšího krále."),
    11: ("Za Šalomouna dosáhl Izrael největšího rozsahu a bohatství. Po "
         "rozdělení soupeřily dvě říše; Asýrie postupně rostla. Kniha "
         "vznikla jako výklad dějin pro lid v zajetí.",
         "Ježíš zmiňuje Šalomounovu slávu (Mt 6,29) a Eliáše; Jan "
         "Křtitel přichází „v duchu a moci Eliášově“ (L 1,17).",
         "Všímejte si hodnotících vět „činil, co je zlé / správné "
         "v Hospodinových očích“. Eliášovy příběhy (kap. 17–19) čtěte "
         "jako celek."),
    12: ("Asyrská a babylonská říše postupně ovládly Přední východ. Mnoho "
         "událostí potvrzují mimobiblické prameny (asyrské letopisy, "
         "Babylonská kronika, Sancheríbův hranol).",
         "Ježíš připomíná Elíšu a Naamána (L 4,27). Pád obou království "
         "ukazuje potřebu nové smlouvy, kterou ohlásil Jeremjáš "
         "a naplnil Kristus.",
         "Pomůže vám tabulka králů (Studium → Tabulky). Proroky, kteří "
         "v té době působili, si můžete číst souběžně."),
    13: ("Kronikář píše po návratu ze zajetí, kdy Judsko bylo malou "
         "perskou provincií. Chce lidu připomenout jeho identitu "
         "a význam bohoslužby.",
         "Rodokmeny vedou od Adama přes Davida – podobně jako rodokmeny "
         "Ježíše u Matouše a Lukáše.",
         "Rodokmeny (kap. 1–9) můžete přelétnout. Porovnejte líčení "
         "Davida s 2. Samuelovou – Kronikář zdůrazňuje jiné věci."),
    14: ("Stejně jako 1. Paralipomenon vzniká po zajetí. Zaměřuje se "
         "jen na Judsko a na chrám; obnovy za Chizkijáše a Jóšijáše "
         "jsou vzorem pro navrátilce.",
         "Ježíš mluví o sobě jako o chrámu (J 2,19–21); Kronikář ukazuje, "
         "jak důležitá byla Boží přítomnost uprostřed lidu.",
         "Čtěte jako „kázání z dějin“: proč se jednomu králi dařilo "
         "a druhému ne? Dobře se čte s 1. a 2. Královskou."),
    15: ("Perský král Kýros dovolil národům vrátit se domů (Kýrův válec). "
         "Navrátilci žili v chudobě a pod tlakem sousedů. Část knihy "
         "obsahuje aramejské úřední dopisy.",
         "Obnova chrámu připravuje dobu, kdy do něj přijde Ježíš. "
         "Ezdráš jako učitel Zákona ukazuje význam Božího slova.",
         "Pozor: kniha není řazena přísně chronologicky (kap. 4 skáče "
         "dopředu). Čtěte spolu s Ageem a Zacharjášem."),
    16: ("Nehemjáš byl číšníkem perského krále Artaxerxa I. a přišel do "
         "Jeruzaléma jako místodržitel roku 445 př. Kr. Hradby byly "
         "důležité pro bezpečí i identitu města.",
         "Nehemjášova modlitba a služba ukazují vůdce, který obětuje "
         "pohodlí pro druhé – motiv, který vrcholí v Kristu.",
         "Čtěte jako deník vůdce. Všímejte si krátkých modliteb "
         "„střelných“ uprostřed práce (např. 2,4)."),
    17: ("Děj se odehrává v Súsách za krále Xerxa I. (Achašveróše). "
         "Mnoho Židů zůstalo v Persii i po návratu části lidu. Kniha "
         "dobře zná perské zvyky a úřady.",
         "Ester riskuje život za svůj lid – motiv přímluvce, který se "
         "postaví za druhé, vrcholí v Ježíši (Žd 7,25).",
         "Přečtěte najednou jako napínavý příběh. Hledejte „náhody“, "
         "za nimiž je skrytá Boží péče."),
    18: ("Kniha patří k moudrostní literatuře Předního východu, která "
         "se zabývala utrpením spravedlivého. Je psána převážně jako "
         "báseň v hebrejské poezii.",
         "Jób touží po prostředníkovi mezi sebou a Bohem (9,33); Nový "
         "zákon představuje Ježíše jako prostředníka (1Tm 2,5). Jakub "
         "připomíná Jóbovu vytrvalost (Jk 5,11).",
         "Nespěchejte s rozhovory přátel – jejich rady znějí zbožně, "
         "ale Bůh je nakonec nepochválí (42,7). Kapitoly 38–41 čtěte "
         "nahlas."),
    19: ("Žalmy vznikaly asi tisíc let a sloužily při bohoslužbě v chrámu "
         "i při osobní modlitbě. Nadpisy uvádějí autory a hudební "
         "pokyny; „sela“ je pravděpodobně hudební značka.",
         "Nový zákon cituje Žalmy častěji než kteroukoli jinou knihu. "
         "Ježíš se modlil žalmy i na kříži (Ž 22,2; 31,6).",
         "Nečtěte žalmy jen jako text, ale jako modlitbu. Zkuste denně "
         "jeden; Žalm 119 po částech."),
    20: ("Moudrostní výroky existovaly i v Egyptě a Mezopotámii; část "
         "Přísloví (22,17–24,22) je podobná egyptskému „Učení "
         "Amenemopa“. Izraelská moudrost je však zakotvena v bázni před "
         "Hospodinem.",
         "Ježíš je nazván „Boží moudrostí“ (1K 1,24) a jeho podobenství "
         "navazují na moudrostní tradici.",
         "Přísloví jsou obecná pravidla, ne záruky. Zkuste číst "
         "jednu kapitolu denně – podle dne v měsíci (31 kapitol)."),
    21: ("Kniha patří k moudrostní literatuře a klade otázky, které "
         "zaznívají i v jiných kulturách: co zbude z lidské námahy?",
         "Pavel píše, že stvoření bylo „podrobeno marnosti“ s nadějí na "
         "osvobození (Ř 8,20–21). Ježíš dává smysl „pod sluncem“.",
         "Neberte jednotlivé věty vytržené – kniha je dialog skepse "
         "a víry. Klíčem je závěr (12,13–14)."),
    22: ("Píseň patří k milostné poezii starověku; podobné písně známe "
         "z Egypta. Byla čtena při svátku Paschy.",
         "Nový zákon přirovnává vztah Krista a církve k manželství "
         "(Ef 5,25–32); proto mnozí vykladači četli Píseň i duchovně.",
         "Čtěte nejdřív doslovně – jako oslavu lásky a manželství. "
         "Pak se můžete ptát, co říká o Boží lásce."),
    23: ("Izajáš působil v Jeruzalémě za čtyř králů, v době asyrské "
         "hrozby. Kapitoly 40–66 mluví k lidu v babylonském zajetí "
         "a po něm; proto je mnozí badatelé připisují pozdějším "
         "autorům z Izajášovy školy.",
         "Ježíš začal své působení čtením z Iz 61 (L 4,16–21). "
         "Píseň o trpícím Služebníku (52,13–53,12) je v Novém zákoně "
         "vztažena na Krista (Sk 8,32–35).",
         "Kniha je dlouhá; začněte kapitolami 6, 9, 40, 53 a 55. "
         "Pomůže znát dobu krále Chizkijáše (2Kr 18–20)."),
    24: ("Jeremjáš působil 40 let v době úpadku Judska a babylonské "
         "nadvlády. Archeologové v Jeruzalémě našli otisky pečetí "
         "se jmény úředníků z knihy (např. Gemarjáše, syna Šáfanova – "
         "36,10).",
         "Zaslíbení nové smlouvy (31,31–34) cituje Ježíš při poslední "
         "večeři (L 22,20) a vykládá ho list Židům (Žd 8).",
         "Kniha není chronologická. Čtěte nejprve příběhové kapitoly "
         "(26–45) a pak proroctví."),
    25: ("Pět nářků vzniklo po zničení Jeruzaléma roku 587/586 př. Kr. "
         "První čtyři jsou akrostichy – každý verš začíná dalším "
         "písmenem hebrejské abecedy.",
         "Ježíš plakal nad Jeruzalémem (L 19,41–44). Kniha učí, že "
         "nářek patří k víře.",
         "Čtěte pomalu, v době smutku. Středem knihy je naděje "
         "(3,21–33)."),
    26: ("Ezechiel byl knězem, kterého Babyloňané odvedli roku 597 "
         "př. Kr. Působil mezi vyhnanci u řeky Kebar. Jeho vidění jsou "
         "plná symbolů a obrazů.",
         "Ježíš jako dobrý pastýř (J 10) navazuje na Ez 34. Nové srdce "
         "a Duch (36,26–27) se naplňují v Novém zákoně.",
         "Kapitoly 1, 18, 34, 36 a 37 jsou dobrým začátkem. "
         "Obrazy čtěte jako obrazy, ne jako technický popis."),
    27: ("Daniel byl odveden do Babylóna roku 605 př. Kr. Kniha je "
         "psána hebrejsky a aramejsky. Vidění v kapitolách 7–12 patří "
         "k apokalyptické literatuře; část badatelů datuje konečnou "
         "podobu knihy do 2. stol. př. Kr.",
         "Ježíš se nejčastěji nazývá „Syn člověka“ – výraz z Da 7,13–14. "
         "Zjevení Janovo navazuje na Danielova vidění.",
         "Kapitoly 1–6 jsou příběhy pro každého; vidění 7–12 čtěte "
         "s vědomím, že jejich výklad se mezi křesťany liší."),
    28: ("Ozeáš působil v severním Izraeli v posledních desetiletích "
         "před pádem Samaří (722 př. Kr.), v době politického chaosu "
         "a uctívání Baala.",
         "Ježíš dvakrát cituje „Chci milosrdenství, a ne oběť“ "
         "(Mt 9,13; 12,7). Mt 2,15 vztahuje 11,1 na Ježíše.",
         "Kapitoly 1–3 čtěte jako příběh; kapitoly 11 a 14 jsou "
         "srdcem knihy."),
    29: ("Datace je nejistá. Pohroma kobylek byla v zemědělské "
         "společnosti katastrofou a prorok ji chápe jako výzvu "
         "k pokání.",
         "Petr cituje Jóele o Letnicích (Sk 2,16–21); Pavel cituje "
         "„každý, kdo vzývá jméno Páně, bude spasen“ (Ř 10,13).",
         "Krátká kniha – přečtěte ji najednou. Klíčem je 2,12–13."),
    30: ("Ámos byl pastýř z Judska, který kázal v severním Izraeli za "
         "Jarobeáma II. v době blahobytu, kdy se prohlubovaly rozdíly "
         "mezi bohatými a chudými.",
         "Jakub ve Skutcích cituje Ám 9,11–12 o obnově Davidova stanu "
         "(Sk 15,16–17). Ježíšův zájem o chudé navazuje na proroky.",
         "Čtěte s otázkou: kde dnes vidím nespravedlnost a co by na ni "
         "řekl Ámos?"),
    31: ("Edóm, potomci Ezaua, se při pádu Jeruzaléma radoval a "
         "pomáhal Babyloňanům. Nepřátelství mezi bratrskými národy je "
         "staré (Gn 27).",
         "Proroctví končí slovy „Království bude Hospodinovo“ – "
         "téma, které rozvíjí Ježíšovo kázání o Božím království.",
         "Jediná kapitola – přečtěte ji spolu s Gn 25–27."),
    32: ("Ninive bylo hlavním městem Asýrie, krutého nepřítele Izraele. "
         "Jonáš je zmíněn v 2Kr 14,25 za Jarobeáma II.",
         "Ježíš mluví o „znamení Jonášově“ – tři dny a tři noci – jako "
         "o obrazu své smrti a vzkříšení (Mt 12,39–41).",
         "Přečtěte najednou a sledujte, kdo se v příběhu obrací – "
         "námořníci, Ninivští – a kdo ne."),
    33: ("Micheáš byl současníkem Izajáše, ale pocházel z venkova "
         "(Morešet). Kritizoval bohaté a vládce, kteří utiskovali chudé.",
         "Mi 5,1 citují zákoníci Herodovi jako místo narození Mesiáše "
         "(Mt 2,5–6).",
         "Verš 6,8 je shrnutím knihy – vraťte se k němu na konci."),
    34: ("Asýrie byla proslulá krutostí; Ninive padlo roku 612 př. Kr. "
         "pod útokem Babyloňanů a Médů – jak Nahum předpověděl.",
         "Boží soud nad zlem je součástí evangelia; „Hle, po horách "
         "kráčí posel radostné zvěsti“ (1,15/2,1) připomíná Pavel "
         "(Ř 10,15).",
         "Čtěte jako útěchu pro utlačené, ne jako oslavu násilí."),
    35: ("Babyloňané se po roce 612 př. Kr. stali světovou velmocí "
         "a ohrožovali Judsko. Abakuk se ptá, jak může Bůh použít "
         "ještě horší národ k potrestání svého lidu.",
         "„Spravedlivý bude žít z víry“ (2,4) cituje Pavel (Ř 1,17; "
         "Ga 3,11) i list Židům (Žd 10,38).",
         "Kniha je rozhovor – čtěte ji jako modlitbu člověka, který "
         "nerozumí, a přesto důvěřuje (3,17–19)."),
    36: ("Sofonjáš působil za krále Jóšijáše, pravděpodobně před jeho "
         "reformou, kdy v Judsku přetrvávala modloslužba.",
         "Den Hospodinův se v Novém zákoně stává „dnem Páně“ – Kristovým "
         "příchodem.",
         "Po přísných kapitolách 1–2 si vychutnejte radost kapitoly 3."),
    37: ("Navrátilci ze zajetí začali stavět chrám, ale práce se na "
         "léta zastavila. Ageus je povzbuzuje roku 520 př. Kr. "
         "Proroctví jsou přesně datována.",
         "Slib slávy nového chrámu (2,9) se podle křesťanů naplňuje "
         "v Kristově přítomnosti.",
         "Krátká kniha – otázka 1,4 je stále aktuální."),
    38: ("Zacharjáš byl současníkem Agea; jeho noční vidění povzbuzují "
         "stavitele chrámu. Druhá část knihy (9–14) má jiný styl "
         "a výhled do budoucnosti.",
         "Evangelia citují Zacharjáše při vjezdu do Jeruzaléma (9,9; "
         "Mt 21,5), při Jidášově zradě (11,12–13) i u kříže (12,10; "
         "J 19,37).",
         "Vidění v kapitolách 1–6 čtěte s poznámkami nebo s dobrým "
         "výkladem; kapitoly 9–14 sledujte s evangelii."),
    39: ("Po návratu ze zajetí a obnově chrámu nastala duchovní "
         "ochablost: kněží přinášeli vadné oběti, lidé se rozváděli "
         "a nedávali desátky.",
         "Posel z 3,1 a „Eliáš“ (3,23) jsou v evangeliích vztaženi "
         "na Jana Křtitele (Mt 11,10.14).",
         "Kniha je psána jako rozhovor: Bůh něco řekne, lid odporuje "
         "(„V čem?“). Hledejte, kde se podobně vymlouvám i já."),
    40: ("Matouš píše pro křesťany, kteří znali Starý zákon a židovské "
         "zvyky. Judsko bylo pod římskou nadvládou, vládli zde Herodovci "
         "a velekněží; očekávání Mesiáše bylo silné.",
         "Matouš ukazuje Ježíše jako naplnění Zákona i Proroků: "
         "„nepřišel jsem zrušit, ale naplnit“ (5,17).",
         "Všímejte si pěti velkých řečí (kap. 5–7, 10, 13, 18, 24–25) "
         "a citací ze Starého zákona."),
    41: ("Podle tradice Marek zapsal Petrovo kázání v Římě, "
         "pravděpodobně v době pronásledování za Nerona. Vysvětluje "
         "židovské zvyky pro čtenáře z pohanů.",
         "Celé evangelium směřuje ke kříži: třetina knihy popisuje "
         "poslední týden.",
         "Nejkratší evangelium – dá se přečíst za jeden večer. Ideální "
         "první kniha pro nové čtenáře."),
    42: ("Lukáš, lékař a Pavlův společník, pečlivě zkoumal svědectví "
         "očitých svědků (1,1–4). Zasazuje události do světových dějin "
         "(císař Augustus, Tiberius, Pilát).",
         "Ježíš je Spasitel všech – i chudých, žen, Samařanů a celníků. "
         "Pokračováním jsou Skutky apoštolů.",
         "Čtěte s pozorností na modlitbu a Ducha svatého; kapitolu 15 "
         "si přečtěte celou."),
    43: ("Jan píše pravděpodobně v Efezu koncem 1. století, kdy církev "
         "čelila rozchodu se synagogou i falešnému učení.",
         "Jan ukazuje Ježíše jako věčné Slovo, které se stalo tělem "
         "(1,14), a vede k víře (20,31).",
         "Sledujte sedm znamení a sedm výroků „Já jsem“ (Studium → "
         "Tabulky). Kapitoly 13–17 čtěte pomalu."),
    44: ("Kniha zachycuje asi 30 let od Ježíšova nanebevstoupení po "
         "Pavlův pobyt v Římě. Římské silnice, společný řecký jazyk "
         "a židovské komunity v městech usnadnily šíření evangelia.",
         "Duch svatý, kterého Ježíš slíbil, vede církev; Petr a Pavel "
         "pokračují v Ježíšově díle.",
         "Mapa Pavlových cest (Studium → Mapy) pomůže sledovat děj. "
         "Čtěte jako pokračování Lukáše."),
    45: ("Sbor v Římě vznikl bez Pavla; tvořili ho křesťané židovského "
         "i pohanského původu. Pavel se chystal do Říma a dál do "
         "Španělska.",
         "Pavel systematicky vykládá evangelium – co Bůh udělal "
         "v Kristu pro hříšníky.",
         "Hutný text – čtěte po menších částech. Kapitoly 1–8 vysvětlují "
         "evangelium, 12–15 život z něj."),
    46: ("Korint byl bohaté přístavní město s pestrým náboženským "
         "a mravním životem. Sbor se potýkal se spory, pýchou "
         "a otázkami každodenního života.",
         "Pavel odpovídá na problémy sboru z pohledu kříže (1,18) "
         "a vzkříšení (kap. 15).",
         "Kniha odpovídá na konkrétní dotazy („co se týče…“). Ptejte se, "
         "jaký princip za radou stojí."),
    47: ("Mezi prvním a druhým listem došlo k napětí: Pavlovi "
         "protivníci zpochybňovali jeho autoritu. Pavel mezitím napsal "
         "i „slzavý dopis“ (2,4).",
         "Kristova síla se projevuje v lidské slabosti (12,9).",
         "Osobní a emotivní list – čtěte ho jako dopis přítele."),
    48: ("Galacie byla oblast v dnešním Turecku. Do sborů přišli "
         "učitelé, kteří požadovali obřízku a dodržování Mojžíšova "
         "zákona od pohanů.",
         "Spása je z milosti skrze víru v Krista, ne ze skutků "
         "Zákona (2,16).",
         "Krátký a vášnivý list. Kapitoly 5–6 ukazují, jak vypadá "
         "svoboda v praxi."),
    49: ("Efez byl jedním z největších měst Malé Asie se slavným "
         "Artemidiným chrámem. Pavel tu působil přes dva roky "
         "(Sk 19).",
         "Kristus spojuje lidi z různých národů v jedno tělo – církev "
         "(2,14–16).",
         "Kapitoly 1–3 popisují, co Bůh udělal; 4–6, jak z toho žít."),
    50: ("Filipy byly římskou kolonií v Makedonii; sbor tu Pavel "
         "založil na 2. misijní cestě (Sk 16). Filipští ho štědře "
         "podporovali.",
         "Píseň o Kristu (2,6–11) je jedním z nejstarších vyznání víry.",
         "Krátký list plný radosti – podtrhávejte slova „radost“ "
         "a „radovat se“."),
    51: ("Kolosy byly malé město v Malé Asii; sbor založil Epafras. "
         "Ohrožovalo ho učení, které mísilo víru s filozofií "
         "a předpisy.",
         "Kristus je obraz neviditelného Boha a hlava církve (1,15–20).",
         "Čtěte spolu s Efezským a Filemonem – vznikly současně."),
    52: ("Pavel založil sbor v Tesalonice na 2. misijní cestě, ale "
         "kvůli pronásledování musel brzy odejít (Sk 17).",
         "Naděje na Kristův příchod dává útěchu i směr životu.",
         "Jedna z nejstarších knih NZ – ukazuje, jak žila mladá církev."),
    53: ("Krátce po prvním listu se v Tesalonice šířily zmatky "
         "o dni Páně a někteří přestali pracovat.",
         "Kristův příchod není důvod k pasivitě, ale k věrnosti.",
         "Kapitola 2 je obtížná; zaměřte se na praktické rady kap. 3."),
    54: ("Timoteus vedl sbor v Efezu, kde se šířilo falešné učení. "
         "Někteří badatelé považují pastorální listy za pozdější; "
         "tradice je připisuje Pavlovi.",
         "Kristus Ježíš přišel na svět zachránit hříšníky (1,15).",
         "Čtěte jako rady zkušeného mentora mladšímu kolegovi."),
    55: ("Pavel je znovu ve vězení v Římě a očekává smrt; mnozí ho "
         "opustili. Je to jeho poslední dopis.",
         "Věrnost Kristu až do konce; Písmo je inspirované Bohem (3,16).",
         "Čtěte jako závěť – co předává člověk, který ví, že odchází?"),
    56: ("Kréta měla pověst ostrova lhářů (1,12 cituje krétského "
         "básníka). Titus měl uspořádat mladé sbory.",
         "Boží milost vychovává k dobrému životu (2,11–14).",
         "Krátký list – všímejte si, jak úzce spojuje učení a život."),
    57: ("Otrok Onésimos utekl Filemonovi, setkal se s Pavlem ve vězení "
         "a stal se křesťanem. Pavel ho posílá zpět s prosbou.",
         "Evangelium mění vztahy – otrok a pán jsou bratři.",
         "Přečtěte najednou a představte si Filemona při čtení dopisu."),
    58: ("List je adresován křesťanům, kteří pod tlakem zvažovali "
         "návrat k židovským obřadům. Autor není znám.",
         "Ježíš je větší než andělé, Mojžíš i kněží; jeho jediná oběť "
         "stačí navždy.",
         "Čtěte spolu s Leviticem. Kapitolu 11 a 12,1–3 si zapamatujte."),
    59: ("Jakub, Ježíšův bratr a vůdce jeruzalémské církve, píše "
         "křesťanům rozptýleným mimo Judsko. Jakub byl popraven "
         "roku 62 (Josephus).",
         "Jakub často připomíná Ježíšovo Kázání na hoře.",
         "Krátké praktické oddíly – vyberte si každý den jednu výzvu."),
    60: ("Křesťané v Malé Asii čelili pomluvám a pronásledování. Petr "
         "píše z „Babylóna“ – pravděpodobně Říma.",
         "Kristus trpěl za nás a dal nám příklad (2,21–24).",
         "Hledejte slovo „naděje“ a rady pro život mezi nevěřícími."),
    61: ("Petr píše krátce před smrtí; varuje před falešnými učiteli. "
         "Autorství je mezi badateli diskutováno.",
         "Petr byl očitým svědkem Ježíšovy slávy (1,16–18).",
         "Čtěte spolu s Judovým listem – mají podobnou látku."),
    62: ("Ve sborech kolem Efezu se šířilo učení, které popíralo, že "
         "Ježíš přišel v těle. Někteří ze sborů odešli.",
         "Bůh je láska a projevil ji v Ježíši (4,9–10).",
         "Jednoduchý jazyk – ale hluboké myšlenky. Čtěte pomalu, "
         "opakovaně."),
    63: ("Putující kazatelé byli přijímáni do domů; Jan varuje před "
         "těmi, kdo šíří bludy.",
         "Pravda a láska patří k sobě.",
         "Přečtete za dvě minuty – spolu s 3. Janovým."),
    64: ("Gaius přijímal misionáře; Diotrefés je odmítal a toužil po "
         "moci.",
         "Pohostinnost je spoluúčastí na šíření pravdy.",
         "Krátké – všímejte si tří postav a jejich postojů."),
    65: ("Do sborů pronikli lidé, kteří zneužívali milost jako "
         "omluvu nemravnosti. Juda cituje i židovské spisy (Henoch).",
         "Bůh dokáže zachovat své lidi od pádu (24–25).",
         "Čtěte spolu s 2. Petrovým; nezapomeňte na závěrečný "
         "chvalozpěv."),
    66: ("Za Domitiána sílil tlak na uctívání císaře. Jan píše sedmi "
         "sborům v Malé Asii v obrazné (apokalyptické) řeči.",
         "Beránek, který byl zabit, vítězí; kniha končí novým "
         "stvořením a voláním „Přijď, Pane Ježíši“.",
         "Neztraťte se v detailech. Začněte dopisy sborům (kap. 2–3) "
         "a závěrem (21–22). Výklady se liší – držte se hlavního "
         "poselství: Kristus vítězí."),
}
