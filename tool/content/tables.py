"""Tabulky a přehledy (vlastní sestavení aplikace).

Buňka „@Mt 5,1“ je biblický odkaz, „Text@Mt 5,1“ text s odkazem (zobrazí se bez knihy, pokud je
kniha uvedena v záhlaví sloupce, a lze na ni klepnout).
"""

T = []


def table(id, title, intro, columns, rows, note=""):
    T.append(dict(id=id, title=title, intro=intro, columns=columns,
                  rows=rows, note=note))


table("desatero", "Desatero",
      "Deset přikázání, která Bůh dal Izraeli na Sínaji (Ex 20 a Dt 5), "
      "a jak je vykládá Ježíš.",
      ["Přikázání", "Exodus", "Ježíš a Nový zákon"],
      [
          ["Nebudeš mít jiné bohy", "@Ex 20,2-3", "@Mt 22,37-38"],
          ["Nezobrazíš si Boha", "@Ex 20,4-6", "@J 4,24"],
          ["Nezneužiješ Boží jméno", "@Ex 20,7", "@Mt 6,9"],
          ["Pamatuj na den odpočinku", "@Ex 20,8-11", "@Mk 2,27"],
          ["Cti otce a matku", "@Ex 20,12", "@Ef 6,1-3"],
          ["Nezabiješ", "@Ex 20,13", "@Mt 5,21-22"],
          ["Nezcizoložíš", "@Ex 20,14", "@Mt 5,27-28"],
          ["Nepokradeš", "@Ex 20,15", "@Ef 4,28"],
          ["Nevydáš křivé svědectví", "@Ex 20,16", "@Ef 4,25"],
          ["Nebudeš dychtit po ničem, co patří bližnímu", "@Ex 20,17",
           "@Ř 7,7"],
      ],
      "Číslování přikázání se v církevních tradicích liší (např. katolická "
      "a luterská tradice spojují první dvě a dělí poslední).")

table("svatky", "Izraelské svátky",
      "Svátky podle Zákona (Lv 23) a pozdější svátky, jejich smysl a vztah "
      "k Novému zákonu.",
      ["Svátek", "Kdy", "Připomíná", "Odkaz", "Nový zákon"],
      [
          ["Pascha a nekvašené chleby", "1. měsíc (nísan), 14.–21. den; "
           "březen–duben", "Vysvobození z Egypta", "@Ex 12,1-20",
           "Poslední večeře, Kristus náš beránek@1K 5,7"],
          ["Letnice (Svátek týdnů)", "50 dní po Pasše; květen–červen",
           "Dožínky; později i dar Zákona", "@Lv 23,15-21",
           "Seslání Ducha svatého@Sk 2,1-4"],
          ["Den troubení", "7. měsíc (tišri), 1. den; září–říjen",
           "Shromáždění, začátek podzimních svátků", "@Lv 23,23-25", ""],
          ["Den smíření (Jom kipur)", "7. měsíc, 10. den", "Očištění lidu "
           "a svatyně od hříchů", "@Lv 16,29-34",
           "Kristus jako velekněz@Žd 9,11-14"],
          ["Svátek stánků", "7. měsíc, 15.–22. den", "Putování pouští, "
           "sklizeň", "@Lv 23,33-43", "Ježíš na svátku@J 7,37-38"],
          ["Purim", "12. měsíc (adar), 14.–15. den", "Záchrana Židů za "
           "Ester", "@Est 9,20-28", ""],
          ["Posvěcení chrámu (Chanuka)", "9. měsíc (kislev), 25. den; "
           "prosinec", "Nové posvěcení chrámu po Makabejském povstání",
           "", "@J 10,22-23"],
      ],
      "Izraelský kalendář je lunární, proto data připadají každý rok na "
      "jiné dny našeho kalendáře.")

table("kralove-juda", "Králové Judska",
      "Judští králové od rozdělení říše po babylonské zajetí a jak je "
      "hodnotí Bible.",
      ["Král", "Vláda (př. Kr.)", "Hodnocení", "Odkaz"],
      [
          ["Rechabeám", "931–913", "zlý", "@1Kr 12"],
          ["Abijám", "913–911", "zlý", "@1Kr 15"],
          ["Ása", "911–870", "dobrý", "@1Kr 15"],
          ["Jóšafat", "872–848", "dobrý", "@1Kr 22"],
          ["Jóram", "853–841", "zlý", "@2Kr 8"],
          ["Achazjáš", "841", "zlý", "@2Kr 8"],
          ["Atalja (královna)", "841–835", "zlá", "@2Kr 11"],
          ["Jóaš", "835–796", "dobrý", "@2Kr 12"],
          ["Amasjáš", "796–767", "dobrý", "@2Kr 14"],
          ["Uzijáš (Azarjáš)", "792–740", "dobrý", "@2Kr 15"],
          ["Jótam", "750–732", "dobrý", "@2Kr 15"],
          ["Achaz", "735–715", "zlý", "@2Kr 16"],
          ["Chizkijáš", "715–686", "dobrý", "@2Kr 18"],
          ["Manases", "697–642", "zlý (nakonec se kál, 2Pa 33)", "@2Kr 21"],
          ["Amón", "642–640", "zlý", "@2Kr 21"],
          ["Jóšijáš", "640–609", "dobrý", "@2Kr 22"],
          ["Jóachaz", "609", "zlý", "@2Kr 23"],
          ["Jójakím", "609–598", "zlý", "@2Kr 23"],
          ["Jójakín", "598–597", "zlý", "@2Kr 24"],
          ["Sidkijáš", "597–586", "zlý", "@2Kr 24"],
      ],
      "Data podle běžně užívané chronologie (E. R. Thiele); překrývající "
      "se roky znamenají spoluvládu otce a syna. Rozdíly mezi badateli "
      "bývají 1–2 roky.")

table("kralove-izrael", "Králové Izraele (severní říše)",
      "Králové severního Izraele od rozdělení říše po pád Samaří. Bible "
      "žádného z nich nehodnotí jako dobrého.",
      ["Král", "Vláda (př. Kr.)", "Poznámka", "Odkaz"],
      [
          ["Jarobeám I.", "931–910", "zavedl zlatá telata v Bét-elu a Danu",
           "@1Kr 12"],
          ["Nádab", "910–909", "zavražděn", "@1Kr 15"],
          ["Baeša", "909–886", "", "@1Kr 15"],
          ["Éla", "886–885", "zavražděn", "@1Kr 16"],
          ["Zimrí", "885", "vládl 7 dní", "@1Kr 16"],
          ["Omrí", "885–874", "založil Samaří", "@1Kr 16"],
          ["Achab", "874–853", "manželka Jezábel; prorok Eliáš", "@1Kr 16"],
          ["Achazjáš", "853–852", "", "@1Kr 22"],
          ["Jóram", "852–841", "prorok Elíša", "@2Kr 3"],
          ["Jehú", "841–814", "vyhladil Achabův rod", "@2Kr 9"],
          ["Jóachaz", "814–798", "", "@2Kr 13"],
          ["Jóaš", "798–782", "", "@2Kr 13"],
          ["Jarobeám II.", "793–753", "doba blahobytu; Ámos, Ozeáš, Jonáš",
           "@2Kr 14"],
          ["Zekarjáš", "753", "vládl 6 měsíců", "@2Kr 15"],
          ["Šalum", "752", "vládl 1 měsíc", "@2Kr 15"],
          ["Menachem", "752–742", "platil daň Asýrii", "@2Kr 15"],
          ["Pekachjáš", "742–740", "zavražděn", "@2Kr 15"],
          ["Pekach", "752–732", "", "@2Kr 15"],
          ["Hóšea", "732–722", "pád Samaří", "@2Kr 17"],
      ],
      "Data podle chronologie E. R. Thieleho; některé vlády se překrývají.")

table("proroci", "Proroci a jejich doba",
      "Proroci, po nichž máme knihy, komu mluvili, kdy a s jakým poselstvím.",
      ["Prorok", "Komu", "Doba (př. Kr.)", "Hlavní poselství"],
      [
          ["Jonáš@Jon 1", "Ninive", "cca 785–760", "Boží milosrdenství i pro "
           "nepřátele"],
          ["Ámos@Am 1", "Izrael", "cca 760", "Spravedlnost pro chudé"],
          ["Ozeáš@Oz 1", "Izrael", "cca 755–715", "Věrná láska k nevěrnému lidu"],
          ["Izajáš@Iz 1", "Juda", "cca 740–680", "Svatý Bůh, soud, útěcha, Mesiáš"],
          ["Micheáš@Mi 1", "Juda a Izrael", "cca 735–700", "Právo, milosrdenství, "
           "pokora"],
          ["Nahum@Na 1", "Ninive", "663–612", "Pád krutého Ninive"],
          ["Sofonjáš@Sf 1", "Juda", "640–609", "Den Hospodinův"],
          ["Jeremjáš@Jr 1", "Juda", "627–580", "Pokání a nová smlouva"],
          ["Abakuk@Abk 1", "Juda", "cca 605", "Víra uprostřed nespravedlnosti"],
          ["Daniel@Da 1", "vyhnanci", "605–530", "Bůh vládne nad říšemi"],
          ["Ezechiel@Ez 1", "vyhnanci", "593–571", "Boží sláva, nové srdce"],
          ["Abdijáš@Abd 1", "Edóm", "po 586", "Soud nad pýchou"],
          ["Ageus@Ag 1", "navrátilci", "520", "Dostavět chrám"],
          ["Zacharjáš@Za 1", "navrátilci", "520–480", "Obnova a přicházející král"],
          ["Malachiáš@Mal 1", "navrátilci", "cca 450–430", "Upřímný vztah s Bohem"],
          ["Jóel@Jl 1", "Juda", "nejisté", "Pokání a vylití Ducha"],
      ])

table("podobenstvi", "Ježíšova podobenství",
      "Podobenství v evangeliích (Jan podobenství v užším smyslu neuvádí).",
      ["Podobenství", "Mt", "Mk", "L", "Hlavní myšlenka"],
      [
          ["Rozsévač", "@Mt 13,3-9", "@Mk 4,3-9", "@L 8,5-8",
           "Jak lidé přijímají Boží slovo"],
          ["Plevel mezi pšenicí", "@Mt 13,24-30", "", "",
           "Soud patří Bohu, ne nám"],
          ["Hořčičné zrno", "@Mt 13,31-32", "@Mk 4,30-32", "@L 13,18-19",
           "Malé začátky Božího království"],
          ["Kvas", "@Mt 13,33", "", "@L 13,20-21",
           "Království proniká vším"],
          ["Rostoucí símě", "", "@Mk 4,26-29", "",
           "Bůh dává růst"],
          ["Poklad v poli a perla", "@Mt 13,44-46", "", "",
           "Království má nejvyšší cenu"],
          ["Síť", "@Mt 13,47-50", "", "", "Konečné oddělení dobrých a zlých"],
          ["Ztracená ovce", "@Mt 18,12-14", "", "@L 15,3-7",
           "Bůh hledá ztracené"],
          ["Nemilosrdný služebník", "@Mt 18,23-35", "", "",
           "Odpuštěno – proto odpouštěj"],
          ["Dělníci na vinici", "@Mt 20,1-16", "", "",
           "Boží štědrost, ne zásluhy"],
          ["Dva synové", "@Mt 21,28-32", "", "", "Rozhodují činy, ne slova"],
          ["Zlí vinaři", "@Mt 21,33-46", "@Mk 12,1-12", "@L 20,9-19",
           "Odmítnutí Božího Syna"],
          ["Svatební hostina", "@Mt 22,1-14", "", "@L 14,16-24",
           "Pozvání pro všechny"],
          ["Deset družiček", "@Mt 25,1-13", "", "", "Bdělost"],
          ["Svěřené hřivny", "@Mt 25,14-30", "", "@L 19,12-27",
           "Věrnost se svěřenými dary"],
          ["Milosrdný Samařan", "", "", "@L 10,30-37",
           "Kdo je můj bližní"],
          ["Neodbytný přítel", "", "", "@L 11,5-8", "Vytrvalost v modlitbě"],
          ["Bohatý blázen", "", "", "@L 12,16-21", "Bohatství před Bohem"],
          ["Neplodný fíkovník", "", "", "@L 13,6-9", "Čas k pokání"],
          ["Ztracená mince", "", "", "@L 15,8-10", "Radost v nebi"],
          ["Marnotratný syn", "", "", "@L 15,11-32", "Otcova láska"],
          ["Nepoctivý správce", "", "", "@L 16,1-13",
           "Moudré užití majetku"],
          ["Boháč a Lazar", "", "", "@L 16,19-31", "Odpovědnost za chudé"],
          ["Neodbytná vdova", "", "", "@L 18,1-8", "Nepřestávat se modlit"],
          ["Farizeus a celník", "", "", "@L 18,9-14", "Pokora před Bohem"],
      ])

table("zazraky", "Ježíšovy zázraky",
      "Výběr zázraků podle evangelií.",
      ["Zázrak", "Mt", "Mk", "L", "J"],
      [
          ["Voda proměněná ve víno", "", "", "", "@J 2,1-11"],
          ["Uzdravení syna královského úředníka", "", "", "", "@J 4,46-54"],
          ["Zázračný rybolov", "", "", "@L 5,1-11", ""],
          ["Uzdravení malomocného", "@Mt 8,2-4", "@Mk 1,40-45",
           "@L 5,12-16", ""],
          ["Setníkův sluha", "@Mt 8,5-13", "", "@L 7,1-10", ""],
          ["Petrova tchyně", "@Mt 8,14-15", "@Mk 1,30-31", "@L 4,38-39", ""],
          ["Utišení bouře", "@Mt 8,23-27", "@Mk 4,35-41", "@L 8,22-25", ""],
          ["Posedlý v gadarenském kraji", "@Mt 8,28-34", "@Mk 5,1-20",
           "@L 8,26-39", ""],
          ["Ochrnutý spuštěný střechou", "@Mt 9,2-8", "@Mk 2,3-12",
           "@L 5,18-26", ""],
          ["Jairova dcera a nemocná žena", "@Mt 9,18-26", "@Mk 5,22-43",
           "@L 8,41-56", ""],
          ["Muž s odumřelou rukou", "@Mt 12,9-13", "@Mk 3,1-5", "@L 6,6-10",
           ""],
          ["Vzkříšení mladíka v Naimu", "", "", "@L 7,11-17", ""],
          ["Nasycení pěti tisíc", "@Mt 14,13-21", "@Mk 6,30-44",
           "@L 9,10-17", "@J 6,1-14"],
          ["Chůze po vodě", "@Mt 14,22-33", "@Mk 6,45-52", "", "@J 6,16-21"],
          ["Dcera kananejské ženy", "@Mt 15,21-28", "@Mk 7,24-30", "", ""],
          ["Hluchoněmý", "", "@Mk 7,31-37", "", ""],
          ["Nasycení čtyř tisíc", "@Mt 15,32-39", "@Mk 8,1-9", "", ""],
          ["Slepý v Betsaidě", "", "@Mk 8,22-26", "", ""],
          ["Posedlý chlapec", "@Mt 17,14-20", "@Mk 9,14-29", "@L 9,37-43",
           ""],
          ["Nemocný u rybníka Bethesda", "", "", "", "@J 5,1-9"],
          ["Slepý od narození", "", "", "", "@J 9,1-7"],
          ["Shrbená žena", "", "", "@L 13,10-17", ""],
          ["Deset malomocných", "", "", "@L 17,11-19", ""],
          ["Slepý Bartimaios", "@Mt 20,29-34", "@Mk 10,46-52",
           "@L 18,35-43", ""],
          ["Vzkříšení Lazara", "", "", "", "@J 11,1-44"],
          ["Uzdravení Malchova ucha", "", "", "@L 22,49-51", ""],
          ["Rybolov po vzkříšení", "", "", "", "@J 21,1-11"],
      ])

table("ja-jsem", "Ježíšovy výroky „Já jsem“",
      "Sedm obrazů z Janova evangelia, v nichž Ježíš mluví o sobě. "
      "Ozývá se v nich Boží jméno „Jsem, který jsem“ (Ex 3,14).",
      ["Výrok", "Odkaz", "Souvislost"],
      [
          ["Já jsem chléb života", "@J 6,35", "po nasycení zástupu"],
          ["Já jsem světlo světa", "@J 8,12", "Svátek stánků, uzdravení "
           "slepého (J 9)"],
          ["Já jsem dveře", "@J 10,9", "řeč o ovčinci"],
          ["Já jsem dobrý pastýř", "@J 10,11", "dává život za ovce"],
          ["Já jsem vzkříšení a život", "@J 11,25", "u Lazarova hrobu"],
          ["Já jsem cesta, pravda i život", "@J 14,6", "rozlučková řeč"],
          ["Já jsem pravý vinný kmen", "@J 15,1", "zůstávat v Kristu"],
      ],
      "Ježíš říká i prosté „Já jsem“ bez obrazu (např. J 8,58).")

table("apostolove", "Dvanáct apoštolů",
      "Seznamy apoštolů v evangeliích a ve Skutcích (Mt 10,2–4; Mk 3,16–19; "
      "L 6,14–16; Sk 1,13).",
      ["Apoštol", "Kdo byl", "Odkaz"],
      [
          ["Šimon Petr", "rybář, mluvčí učedníků", "@Mt 16,13-19"],
          ["Ondřej", "Petrův bratr, dříve učedník Jana Křtitele",
           "@J 1,40-42"],
          ["Jakub Zebedeův", "rybář, první apoštol mučedník", "@Sk 12,1-2"],
          ["Jan", "Jakubův bratr, „učedník, kterého Ježíš miloval“",
           "@J 13,23"],
          ["Filip", "z Betsaidy", "@J 1,43-46"],
          ["Bartoloměj", "pravděpodobně totožný s Natanaelem", "@J 1,45-49"],
          ["Tomáš", "zvaný Didymos (Dvojče)", "@J 20,24-29"],
          ["Matouš (Levi)", "celník", "@Mt 9,9"],
          ["Jakub Alfeův", "", "@Mk 3,18"],
          ["Tadeáš (Juda Jakubův)", "", "@L 6,16"],
          ["Šimon Horlivec", "dříve zélóta (horlivec)", "@L 6,15"],
          ["Jidáš Iškariotský", "pokladník, zradil Ježíše; po jeho smrti "
           "zvolen Matěj", "@Sk 1,15-26"],
      ])

table("kmeny", "Dvanáct kmenů Izraele",
      "Jákobovi synové, jejich matky a význam jmen (Gn 29–30; 35).",
      ["Syn", "Matka", "Význam jména", "Poznámka"],
      [
          ["Rúben", "Lea", "„hle, syn“", "prvorozený"],
          ["Šimeón", "Lea", "„slyšel“", ""],
          ["Lévi", "Lea", "„přilne“", "kněžský kmen bez vlastního území"],
          ["Juda", "Lea", "„chválit“", "z něj král David i Ježíš"],
          ["Dan", "Bilha (Ráchelina otrokyně)", "„soudil“", ""],
          ["Neftalí", "Bilha", "„zápasila jsem“", ""],
          ["Gád", "Zilpa (Leina otrokyně)", "„štěstí“", ""],
          ["Ašer", "Zilpa", "„blaženost“", ""],
          ["Isachar", "Lea", "„odplata“", ""],
          ["Zabulón", "Lea", "„příbytek, čest“", ""],
          ["Josef", "Ráchel", "„přidá“", "jeho podíl dostali synové "
           "Efrajim a Manases"],
          ["Benjamín", "Ráchel", "„syn pravice“", "Ráchel zemřela při "
           "porodu"],
      ])

table("pavlovy-listy", "Pavlovy listy",
      "Komu, odkud a kdy Pavel psal (přibližně; u některých listů se "
      "badatelé liší).",
      ["List", "Adresáti", "Odkud", "Kdy (po Kr.)", "Téma"],
      [
          ["Galatským@Ga 1", "sbory v Galacii", "nejisté", "49–55", "svoboda v Kristu"],
          ["1. Tesalonickým@1Te 1", "Tesalonika", "Korint", "50–51", "naděje Kristova "
           "příchodu"],
          ["2. Tesalonickým@2Te 1", "Tesalonika", "Korint", "51", "vytrvalost"],
          ["1. Korintským@1K 1", "Korint", "Efez", "54", "jednota a láska"],
          ["2. Korintským@2K 1", "Korint", "Makedonie", "55–56", "síla ve slabosti"],
          ["Římanům@Ř 1", "Řím", "Korint", "57", "ospravedlnění z víry"],
          ["Efezským@Ef 1", "Efez a okolí", "vězení", "60–62", "církev – Kristovo "
           "tělo"],
          ["Filipským@Fp 1", "Filipy", "vězení", "60–62", "radost v Kristu"],
          ["Koloským@Ko 1", "Kolosy", "vězení", "60–62", "Kristus nade vším"],
          ["Filemonovi@Fm 1", "Filemon", "vězení", "60–62", "odpuštění a bratrství"],
          ["1. Timoteovi@1Tm 1", "Timoteus v Efezu", "Makedonie (?)", "62–64",
           "vedení sboru"],
          ["Titovi@Tt 1", "Titus na Krétě", "nejisté", "63–65", "zdravé učení "
           "a dobré skutky"],
          ["2. Timoteovi@2Tm 1", "Timoteus", "vězení v Římě", "66–67", "věrnost do "
           "konce"],
      ])
