"""Rozšíření úvodů ke knihám Starého zákona (vlastní text aplikace).

Každá kniha: účel, adresáti, prostředí, hlavní postavy a místa, zvláštnosti,
hlavní témata (název + vysvětlení a význam) a časová osa knihy.
Datace odpovídají aplikaci (u nejistých období přibližně; tradiční
chronologie je označena „tradičně“).
"""

OT = {
    1: dict(
        purpose="Vyprávět o počátku světa, lidstva, hříchu a o tom, jak si Bůh "
        "vyvolil Abrahama a jeho rod, aby skrze něj požehnal všem národům.",
        recipients="Izraelský lid",
        setting="Mezopotámie, Kenaan a Egypt",
        people=["Adam a Eva", "Noe", "Abraham", "Sára", "Izák", "Rebeka",
                "Jákob", "Ráchel", "Josef"],
        places=["Eden", "Ur", "Cháran", "Šekem", "Bét-el", "Chebrón",
                "Beer-šeba", "Egypt"],
        features="Kniha počátků: stvoření, první vzpoura člověka, první "
        "zaslíbení vykoupení (3,15) a první smlouvy Boha s lidmi.",
        themes=[
            ("Stvoření", "Bůh stvořil svět dobrý a člověka ke svému obrazu. "
             "Každý člověk má proto hodnotu a důstojnost."),
            ("Hřích a jeho následky", "Nedůvěra k Bohu přinesla odcizení, "
             "vinu a smrt. Hřích se šíří, ale Bůh ho nenechává mít poslední "
             "slovo."),
            ("Zaslíbení a smlouva", "Bůh se zavazuje Abrahamovi i jeho "
             "potomkům. Jeho sliby platí, i když lidé selhávají."),
            ("Víra a poslušnost", "Abraham věřil Bohu a bylo mu to počteno "
             "za spravedlnost (15,6). Víra se ukazuje v ochotě vykročit."),
            ("Boží prozřetelnost", "V Josefově příběhu Bůh obrací zlé "
             "úmysly lidí k dobrému (50,20)."),
        ],
        timeline=[
            ("bez datace", "Stvoření, pád, potopa, babylonská věž"),
            ("tradičně 2166 př. Kr.", "Narození Abrama"),
            ("tradičně 2091 př. Kr.", "Abram odchází z Cháranu (je mu 75 "
             "let)"),
            ("tradičně 2066 př. Kr.", "Narození Izáka"),
            ("tradičně 2006 př. Kr.", "Narození Jákoba a Ezaua"),
            ("tradičně 1876 př. Kr.", "Jákobova rodina přichází do Egypta"),
        ],
        timeline_note="Tradiční data vycházejí z věků uvedených v Bibli "
        "a z dřívější datace exodu (1446 př. Kr.). Mnozí badatelé kladou "
        "dobu praotců o 100–300 let později.",
    ),
    2: dict(
        purpose="Zaznamenat, jak Bůh vysvobodil Izrael z egyptského otroctví, "
        "uzavřel s ním smlouvu a začal přebývat uprostřed svého lidu.",
        recipients="Izraelský lid",
        setting="Egypt, Sínajský poloostrov",
        people=["Mojžíš", "Áron", "Mirjam", "farao", "Jetro", "Jozue"],
        places=["Egypt", "Midján", "Rákosové moře", "hora Sínaj"],
        features="Obsahuje Desatero (kap. 20), ustanovení Paschy a podrobný "
        "popis svatostánku.",
        themes=[
            ("Vysvobození", "Bůh slyší volání utlačených a jedná. Exodus se "
             "stal vzorem pro pochopení spásy."),
            ("Boží jméno", "Bůh se zjevuje jako „Jsem, který jsem“ (3,14) – "
             "věrný, přítomný a svrchovaný."),
            ("Smlouva a Zákon", "Desatero vychází z vysvobození: Bůh nejprve "
             "zachraňuje a potom učí žít svobodně."),
            ("Boží přítomnost", "Svatostánek ukazuje, že svatý Bůh chce "
             "přebývat se svým lidem."),
        ],
        timeline=[
            ("15. nebo 13. stol. př. Kr.", "Útlak Izraelců v Egyptě"),
            ("cca 1446 nebo 1260 př. Kr.", "Vyjití z Egypta, přechod moře"),
            ("o 3 měsíce později", "Příchod k Sínaji, Desatero"),
            ("o rok později", "Postaven svatostánek (40,17)"),
        ],
    ),
    3: dict(
        purpose="Učit Izrael, jak žít jako svatý lid ve vztahu se svatým "
        "Bohem – v bohoslužbě i v každodenním životě.",
        recipients="Kněží a izraelský lid",
        setting="U hory Sínaj",
        people=["Mojžíš", "Áron", "Nádab a Abíhú"],
        places=["hora Sínaj"],
        features="Kniha zákonů o obětech a čistotě; obsahuje přikázání "
        "„Miluj svého bližního jako sebe“ (19,18).",
        themes=[
            ("Svatost", "„Buďte svatí, neboť já jsem svatý“ (11,44). Svatost "
             "se týká bohoslužby, jídla, sexuality i spravedlnosti."),
            ("Oběť a smíření", "Oběti ukazují vážnost hříchu i Boží cestu "
             "k odpuštění; Nový zákon je vidí naplněné v Kristu."),
            ("Láska k bližnímu", "Zákon chrání chudé, cizince a slabé – víra "
             "se projevuje ve vztazích."),
        ],
        timeline=[
            ("rok po exodu", "Vysvěcení kněží (kap. 8–9)"),
            ("během pobytu u Sínaje", "Zákony o obětech, čistotě a svátcích"),
        ],
    ),
    4: dict(
        purpose="Popsat cestu Izraele od Sínaje k hranicím zaslíbené země "
        "a ukázat následky nedůvěry i Boží věrnost.",
        recipients="Izraelský lid",
        setting="Sínajská poušť, Kádeš, Moábské pláně",
        people=["Mojžíš", "Áron", "Mirjam", "Jozue", "Káleb", "Balák",
                "Bileám"],
        places=["Sínaj", "Kádeš-barnea", "Moábské pláně"],
        features="Dvě sčítání lidu (kap. 1 a 26) rámují dobu putování; "
        "obsahuje Áronovo požehnání (6,24–26).",
        themes=[
            ("Nevěra a její následky", "Generace, která nedůvěřovala Bohu, "
             "nevstoupila do země. Strach může zavřít dveře."),
            ("Boží trpělivost", "Bůh lid trestá, ale neopouští – živí ho a "
             "vede dál."),
            ("Vedení", "Oblak a ohnivý sloup ukazují, že Bůh vede svůj lid "
             "krok za krokem."),
        ],
        timeline=[
            ("2. rok po exodu", "Odchod od Sínaje"),
            ("krátce poté", "Zvědové v Kenaanu, vzpoura v Kádeši"),
            ("38 let", "Putování pouští"),
            ("40. rok", "Na Moábských pláních"),
        ],
    ),
    5: dict(
        purpose="Připomenout nové generaci Boží jednání a vyzvat ji k lásce "
        "a věrnosti Bohu před vstupem do země.",
        recipients="Nová generace Izraele",
        setting="Moábské pláně u Jordánu",
        people=["Mojžíš", "Jozue"],
        places=["Moábské pláně", "hora Nebó"],
        features="Tři Mojžíšovy řeči; „Slyš, Izraeli“ (6,4–5). Ježíš z této "
        "knihy citoval při pokušení na poušti.",
        themes=[
            ("Láska k Bohu", "Bůh nechce jen vnější poslušnost, ale lásku "
             "celým srdcem (6,5)."),
            ("Paměť", "„Pamatuj“ – připomínání Božích skutků chrání před "
             "zapomenutím a pýchou."),
            ("Volba", "Život a smrt, požehnání a kletba: Bůh vyzývá vybrat si "
             "život (30,19)."),
        ],
        timeline=[
            ("40. rok po exodu", "Mojžíšovy řeči k lidu"),
            ("tamtéž", "Obnovení smlouvy, Jozue nástupcem"),
            ("konec 40. roku", "Mojžíšova smrt na hoře Nebó"),
        ],
    ),
    6: dict(
        purpose="Ukázat, jak Bůh splnil slib a uvedl Izrael do zaslíbené "
        "země, a vyzvat k věrnosti.",
        recipients="Izraelský lid",
        setting="Kenaan",
        people=["Jozue", "Rachab", "Káleb", "Akán"],
        places=["Jordán", "Jericho", "Aj", "Gibeón", "Šíló", "Šekem"],
        features="Rozdělení země mezi kmeny (kap. 13–21); závěrečná výzva "
        "„Já a můj dům budeme sloužit Hospodinu“.",
        themes=[
            ("Boží věrnost", "„Nepadlo ani jedno slovo“ z Božích slibů "
             "(21,45)."),
            ("Odvaha a poslušnost", "Úspěch nestojí na síle, ale na důvěře "
             "a poslušnosti (1,7–9)."),
            ("Rozhodnutí", "Každá generace se musí sama rozhodnout, komu "
             "bude sloužit (24,15)."),
        ],
        timeline=[
            ("cca 1406 nebo 1220 př. Kr.", "Přechod Jordánu, pád Jericha"),
            ("následující roky", "Dobývání země"),
            ("později", "Rozdělení země, Jozuovo rozloučení"),
        ],
    ),
    7: dict(
        purpose="Ukázat, kam vede odpadnutí od Boha, a jak Bůh přesto znovu "
        "posílá zachránce.",
        recipients="Izraelský lid v době královské",
        setting="Kenaan v době kmenů",
        people=["Debora", "Barák", "Gedeón", "Jefte", "Samson", "Delila"],
        places=["Šíló", "Bét-el", "Gibea"],
        features="Opakující se kruh: odpadnutí – útlak – volání – záchrana. "
        "Kniha nic nepřikrášluje.",
        themes=[
            ("Kruh hříchu", "Bez trvalé věrnosti se lid stále vrací ke "
             "stejným chybám."),
            ("Bůh používá slabé", "Soudci byli nedokonalí lidé; síla "
             "pocházela od Boha."),
            ("Morální chaos", "„Každý dělal, co uznal za správné“ (21,25) – "
             "kniha ukazuje potřebu dobrého vedení."),
        ],
        timeline=[
            ("cca 1200–1050 př. Kr.", "Doba soudců"),
            ("cca 1125 př. Kr.", "Debora a Barák (přibližně)"),
            ("cca 1100 př. Kr.", "Gedeón (přibližně)"),
            ("cca 1070 př. Kr.", "Samson (přibližně)"),
        ],
    ),
    8: dict(
        purpose="Ukázat Boží péči a věrnou lásku v obyčejném životě "
        "a vysvětlit původ Davidova rodu.",
        recipients="Izraelský lid",
        setting="Moáb a Betlém v době soudců",
        people=["Rút", "Noemi", "Bóaz"],
        places=["Moáb", "Betlém"],
        features="Cizinka Moábka se stává prababičkou krále Davida "
        "a předkyní Ježíše (Mt 1,5).",
        themes=[
            ("Věrná láska", "Rút zůstává věrná Noemi i v nejisté budoucnosti."),
            ("Vykupitel", "Bóaz jako příbuzný-vykupitel ukazuje Boží péči "
             "o slabé."),
            ("Boží plán", "Bůh jedná i skrze obyčejná rozhodnutí obyčejných "
             "lidí."),
        ],
        timeline=[
            ("doba soudců", "Hladomor, odchod do Moábu"),
            ("o 10 let později", "Návrat Noemi a Rút do Betléma"),
            ("o generace později", "Narození Davida"),
        ],
    ),
    9: dict(
        purpose="Popsat přechod od soudců ke králům a vzestup Davida.",
        recipients="Izraelský lid",
        setting="Izrael",
        people=["Chana", "Samuel", "Élí", "Saul", "Jonatan", "David",
                "Goliáš"],
        places=["Šíló", "Ráma", "Gibea", "údolí Ela", "Gilboa"],
        features="Bůh hledí na srdce, ne na vzhled (16,7).",
        themes=[
            ("Poslušnost", "„Poslušnost je lepší než oběť“ (15,22)."),
            ("Boží volba", "Bůh si vybírá Davida, nejmladšího pastýře."),
            ("Přátelství", "Jonatan a David – věrnost i v nebezpečí."),
        ],
        timeline=[
            ("cca 1100 př. Kr.", "Narození Samuela"),
            ("cca 1050 př. Kr.", "Saul králem"),
            ("cca 1025 př. Kr.", "David pomazán (přibližně)"),
            ("cca 1010 př. Kr.", "Saulova smrt na Gilboa"),
        ],
    ),
    10: dict(
        purpose="Vylíčit Davidovu vládu – úspěchy, selhání i Boží zaslíbení "
        "trvalého království.",
        recipients="Izraelský lid",
        setting="Juda a celý Izrael, Jeruzalém",
        people=["David", "Batšeba", "Nátan", "Absalóm", "Jóab", "Urijáš"],
        places=["Chebrón", "Jeruzalém"],
        features="Boží smlouva s Davidem (kap. 7) je základem mesiášské "
        "naděje.",
        themes=[
            ("Zaslíbení", "Bůh slibuje Davidovi trvalý rod – naplněno "
             "v Ježíši, Synu Davidově."),
            ("Hřích a pokání", "Ani velký král není nad Božím zákonem; "
             "David své selhání přiznává (12,13)."),
            ("Následky", "Odpuštění neruší všechny následky – rodina "
             "prochází bolestí."),
        ],
        timeline=[
            ("cca 1010 př. Kr.", "David králem v Chebrónu"),
            ("cca 1003 př. Kr.", "Dobytí Jeruzaléma"),
            ("cca 990 př. Kr.", "Hřích s Batšebou (přibližně)"),
            ("cca 980 př. Kr.", "Absalómova vzpoura (přibližně)"),
        ],
    ),
    11: dict(
        purpose="Ukázat, že prosperita národa závisí na věrnosti Bohu – od "
        "Šalomounovy slávy po rozdělení a úpadek.",
        recipients="Izraelci v zajetí",
        setting="Izrael a Juda",
        people=["Šalomoun", "Rechabeám", "Jarobeám", "Achab", "Jezábel",
                "Eliáš"],
        places=["Jeruzalém", "Samaří", "Karmel", "Choréb"],
        features="Stavba chrámu; Eliášův zápas s Baalovými proroky "
        "(kap. 18).",
        themes=[
            ("Moudrost", "Šalomoun prosí o moudrost, ne o bohatství."),
            ("Rozdělené srdce", "Šalomounova pozdní modloslužba vede "
             "k rozdělení říše."),
            ("Bůh mluví", "Eliáš poznává Boha v tichém hlasu (19,12)."),
        ],
        timeline=[
            ("cca 970 př. Kr.", "Šalomoun králem"),
            ("cca 960 př. Kr.", "Dokončení chrámu"),
            ("cca 931 př. Kr.", "Rozdělení říše"),
            ("cca 874–853 př. Kr.", "Achab v Izraeli, Eliáš"),
        ],
    ),
    12: dict(
        purpose="Vysvětlit, proč oba národy skončily v zajetí: odmítly "
        "varování proroků.",
        recipients="Izraelci v zajetí",
        setting="Izrael a Juda",
        people=["Elíša", "Naamán", "Jehú", "Chizkijáš", "Izajáš", "Jóšijáš",
                "Nebúkadnesar"],
        places=["Samaří", "Jeruzalém", "Asýrie", "Babylón"],
        features="Pád Samaří (kap. 17) i Jeruzaléma (kap. 25) potvrzují "
        "i mimobiblické prameny.",
        themes=[
            ("Varování", "Bůh trpělivě posílá proroky (17,13)."),
            ("Reformy", "Chizkijáš a Jóšijáš ukazují, že návrat k Bohu je "
             "možný."),
            ("Soud a naděje", "Kniha končí propuštěním krále Jójakína – "
             "Davidův rod nezanikl."),
        ],
        timeline=[
            ("cca 850 př. Kr.", "Eliášovo nanebevzetí, Elíša"),
            ("722 př. Kr.", "Pád Samaří"),
            ("701 př. Kr.", "Sancheríb u Jeruzaléma"),
            ("622 př. Kr.", "Jóšijášova reforma"),
            ("587/586 př. Kr.", "Zničení Jeruzaléma"),
        ],
    ),
    13: dict(
        purpose="Povzbudit navrátilce ze zajetí: připomenout jejich kořeny, "
        "Davidův rod a význam chrámu.",
        recipients="Židé po návratu z Babylónu",
        setting="Izrael (pohled zpět z 5. stol. př. Kr.)",
        people=["David", "Šalomoun", "Nátan"],
        places=["Jeruzalém", "Chebrón"],
        features="Rozsáhlé rodokmeny od Adama; Davidova vláda líčená se "
        "zaměřením na přípravu chrámu.",
        themes=[
            ("Kořeny a identita", "Rodokmeny ukazují, že Bůh nezapomněl na "
             "žádnou rodinu."),
            ("Bohoslužba", "David organizuje kněze, lévijce a zpěváky."),
            ("Chvála", "„Vzdejte díky Hospodinu, neboť je dobrý“ (16,34)."),
        ],
        timeline=[
            ("cca 1010–970 př. Kr.", "Vláda Davida"),
            ("5.–4. stol. př. Kr.", "Sepsání knihy"),
        ],
    ),
    14: dict(
        purpose="Ukázat dějiny Judska od Šalomouna po zajetí jako dějiny "
        "věrnosti a nevěrnosti v bohoslužbě.",
        recipients="Židé po návratu z Babylónu",
        setting="Juda a Jeruzalém",
        people=["Šalomoun", "Jóšafat", "Chizkijáš", "Jóšijáš", "Kýros"],
        places=["Jeruzalém"],
        features="Končí Kýrovým ediktem – nadějí na návrat.",
        themes=[
            ("Pokání", "„Pokoří-li se můj lid… uzdravím jejich zemi“ (7,14)."),
            ("Důvěra", "„Boj nepatří vám, ale Bohu“ (20,15)."),
            ("Obnova", "Králové, kteří hledali Boha, přinesli obnovu."),
        ],
        timeline=[
            ("cca 960 př. Kr.", "Posvěcení chrámu"),
            ("cca 931 př. Kr.", "Rozdělení říše"),
            ("587/586 př. Kr.", "Zničení Jeruzaléma"),
            ("539/538 př. Kr.", "Kýrův edikt"),
        ],
    ),
    15: dict(
        purpose="Zachytit návrat ze zajetí, obnovu chrámu a obnovu "
        "duchovního života podle Božího zákona.",
        recipients="Navrátilci v Judsku",
        setting="Babylónie a Jeruzalém",
        people=["Kýros", "Zerubábel", "Jéšua", "Ezdráš", "Ageus",
                "Zacharjáš"],
        places=["Babylón", "Jeruzalém"],
        features="Obsahuje aramejské úřední dopisy perské doby.",
        themes=[
            ("Boží svrchovanost", "Bůh vede i pohanské vládce (1,1)."),
            ("Obnova bohoslužby", "Nejdříve oltář, potom chrám."),
            ("Slovo Boží", "Ezdráš se rozhodl zkoumat, plnit a učit Zákon "
             "(7,10)."),
        ],
        timeline=[
            ("538 př. Kr.", "První návrat pod Zerubábelem"),
            ("536 př. Kr.", "Základy chrámu"),
            ("516/515 př. Kr.", "Dokončení chrámu"),
            ("458 př. Kr.", "Ezdrášův příchod"),
        ],
    ),
    16: dict(
        purpose="Ukázat obnovu jeruzalémských hradeb i společenství skrze "
        "modlitbu, vedení a poslušnost Božímu slovu.",
        recipients="Navrátilci v Judsku",
        setting="Perská Súsy a Jeruzalém",
        people=["Nehemjáš", "Ezdráš", "Artaxerxés", "Sanbalat"],
        places=["Súsy", "Jeruzalém"],
        features="Psáno převážně v 1. osobě jako Nehemjášovy paměti.",
        themes=[
            ("Modlitba a práce", "Nehemjáš se modlí i jedná."),
            ("Vedení", "Dobrý vůdce povzbuzuje, organizuje a nevzdává se."),
            ("Radost", "„Radost z Hospodina je vaše síla“ (8,10)."),
        ],
        timeline=[
            ("445 př. Kr.", "Nehemjáš v Jeruzalémě"),
            ("445 př. Kr.", "Hradby postaveny za 52 dní (6,15)"),
            ("cca 433 př. Kr.", "Druhý Nehemjášův pobyt"),
        ],
    ),
    17: dict(
        purpose="Ukázat Boží skrytou péči o jeho lid a vysvětlit původ "
        "svátku Purim.",
        recipients="Židé v perské říši",
        setting="Súsy, sídlo perských králů",
        people=["Ester", "Mordokaj", "Achašveróš (Xerxés)", "Haman"],
        places=["Súsy"],
        features="Boží jméno se v knize nevyskytuje, přesto je jeho péče "
        "zřetelná.",
        themes=[
            ("Prozřetelnost", "„Kdo ví, zda ses nedostala ke královské "
             "hodnosti právě pro takovou chvíli?“ (4,14)."),
            ("Odvaha", "Ester riskuje život pro svůj lid."),
            ("Spravedlnost", "Pýcha a nenávist Hamana se obracejí proti "
             "němu."),
        ],
        timeline=[
            ("483 př. Kr.", "Hostina krále Achašveróše (3. rok vlády)"),
            ("479/478 př. Kr.", "Ester královnou (7. rok)"),
            ("473 př. Kr.", "Záchrana Židů, svátek Purim"),
        ],
    ),
    18: dict(
        purpose="Zápasit s otázkou utrpení spravedlivého a ukázat Boží "
        "moudrost, která přesahuje lidské vysvětlení.",
        recipients="Všichni, kdo trpí a hledají odpovědi",
        setting="Země Ús (pravděpodobně Edóm či Arábie)",
        people=["Jób", "Elífaz", "Bildad", "Sófar", "Elíhú", "satan"],
        places=["země Ús"],
        features="Básnický dialog; Bůh nakonec odpovídá ze smršti.",
        themes=[
            ("Utrpení", "Utrpení není vždy trestem za hřích."),
            ("Upřímnost", "Jób před Bohem nic nepředstírá – a Bůh ho "
             "nakonec ospravedlňuje."),
            ("Boží velikost", "Bůh neodpovídá na všechno, ale ukazuje sebe "
             "(42,5)."),
        ],
        timeline=[
            ("nejisté", "Příběh se odehrává pravděpodobně v době praotců"),
        ],
    ),
    19: dict(
        purpose="Dát Božímu lidu slova k modlitbě a chvále ve všech "
        "životních situacích.",
        recipients="Izrael a všichni, kdo se modlí",
        setting="Od doby Mojžíše po návrat ze zajetí",
        people=["David", "Asaf", "synové Kórachovi", "Mojžíš", "Šalomoun"],
        places=["Jeruzalém", "Sijón"],
        features="Pět knih žalmů; chvalozpěvy, nářky, žalmy důvěry, "
        "moudrosti i královské žalmy.",
        themes=[
            ("Chvála", "Žalmy učí oslavovat Boha za to, kdo je."),
            ("Nářek", "Bolest i otázky smějí zaznít před Bohem."),
            ("Důvěra", "„Hospodin je můj pastýř“ (23,1)."),
            ("Mesiáš", "Královské žalmy ukazují k Mesiáši; Nový zákon je "
             "často cituje."),
        ],
        timeline=[
            ("cca 1400 př. Kr.", "Žalm 90 připisován Mojžíšovi"),
            ("cca 1010–970 př. Kr.", "Davidovy žalmy"),
            ("po 587 př. Kr.", "Žalmy zajetí (např. 137)"),
            ("po 538 př. Kr.", "Konečné uspořádání sbírky"),
        ],
    ),
    20: dict(
        purpose="Učit praktické moudrosti pro život v bázni před Bohem.",
        recipients="Mladí lidé i všichni, kdo hledají moudrost",
        setting="Izraelský královský dvůr a rodina",
        people=["Šalomoun", "Agur", "Lemúel"],
        places=["Jeruzalém"],
        features="Krátká přísloví o slovech, práci, penězích, přátelství "
        "a rodině; závěrečná báseň o statečné ženě.",
        themes=[
            ("Bázeň Hospodinova", "Začátek poznání (1,7)."),
            ("Slova", "Jazyk může uzdravovat i ničit."),
            ("Práce a poctivost", "Pílí, poctivostí a pokorou se staví "
             "dobrý život."),
        ],
        timeline=[
            ("cca 970–930 př. Kr.", "Šalomounova přísloví"),
            ("cca 700 př. Kr.", "Muži judského krále Chizkijáše opisují "
             "další přísloví (25,1)"),
        ],
    ),
    21: dict(
        purpose="Ukázat marnost života bez Boha a vést k radosti z Božích "
        "darů a k bázni před ním.",
        recipients="Hledající lidé",
        setting="Pohled moudrého na život „pod sluncem“",
        people=["Kazatel"],
        places=["Jeruzalém"],
        features="Upřímné otázky a závěr „Boha se boj a jeho příkazy "
        "zachovávej“ (12,13).",
        themes=[
            ("Pomíjivost", "Úspěch, bohatství ani moudrost nedávají "
             "trvalé naplnění."),
            ("Čas", "Všechno má svou chvíli (3,1)."),
            ("Radost z darů", "Jídlo, práce a láska jsou dary, které "
             "můžeme přijímat s vděčností."),
        ],
        timeline=[
            ("tradičně 10. stol. př. Kr.", "Připisováno Šalomounovi"),
        ],
    ),
    22: dict(
        purpose="Oslavit lásku mezi mužem a ženou jako dobrý Boží dar.",
        recipients="Izrael; zamilovaní a manželé",
        setting="Izrael, venkov i Jeruzalém",
        people=["milá (Šulamitka)", "milý"],
        places=["Jeruzalém", "Libanon"],
        features="Milostná poezie; židovská i křesťanská tradice v ní "
        "viděla i obraz Boží lásky.",
        themes=[
            ("Láska", "„Láska je silná jako smrt“ (8,6)."),
            ("Věrnost", "Láska chce výlučnost a trvalost."),
            ("Čas lásky", "„Nebuďte lásku, dokud sama nechce“ (2,7)."),
        ],
        timeline=[
            ("tradičně 10. stol. př. Kr.", "Připisováno Šalomounovi"),
        ],
    ),
    23: dict(
        purpose="Volat Judu k návratu k Bohu, ohlásit soud i útěchu "
        "a zaslíbit Mesiáše.",
        recipients="Juda a Jeruzalém",
        setting="Jeruzalém v době asyrské hrozby",
        people=["Izajáš", "Uzijáš", "Achaz", "Chizkijáš", "Sancheríb",
                "Kýros"],
        places=["Jeruzalém", "Asýrie", "Babylón"],
        features="Nejčastěji citovaný prorok v Novém zákoně; písně "
        "o Služebníku Hospodinově (kap. 42–53).",
        themes=[
            ("Svatost Boží", "„Svatý, svatý, svatý“ (6,3)."),
            ("Mesiáš", "Dítě se nám narodilo (9,5); trpící Služebník (53)."),
            ("Útěcha", "„Potěšujte můj lid“ (40,1) – naděje po soudu."),
        ],
        timeline=[
            ("cca 740 př. Kr.", "Izajášovo povolání (rok Uzijášovy smrti)"),
            ("cca 734 př. Kr.", "Proroctví o Immanuelovi"),
            ("701 př. Kr.", "Sancheríbovo obléhání Jeruzaléma"),
        ],
    ),
    24: dict(
        purpose="Varovat Judu před soudem a vyzvat k pokání; zaslíbit novou "
        "smlouvu.",
        recipients="Juda a Jeruzalém",
        setting="Jeruzalém před a po babylonském dobytí",
        people=["Jeremjáš", "Báruk", "Jóšijáš", "Jójakím", "Sidkijáš",
                "Nebúkadnesar"],
        places=["Anatót", "Jeruzalém", "Egypt"],
        features="Nejvíce osobních pasáží ze všech proroků („Jeremjášova "
        "vyznání“).",
        themes=[
            ("Pokání", "Bůh zve k návratu, i když lid odmítá."),
            ("Věrnost v utrpení", "Jeremjáš zůstal věrný, i když byl "
             "odmítán a vězněn."),
            ("Nová smlouva", "Bůh vepíše svůj zákon do srdce (31,33)."),
        ],
        timeline=[
            ("627 př. Kr.", "Jeremjášovo povolání"),
            ("605 př. Kr.", "Báruk zapisuje proroctví"),
            ("597 př. Kr.", "První deportace"),
            ("587/586 př. Kr.", "Pád Jeruzaléma"),
        ],
    ),
    25: dict(
        purpose="Vyjádřit zármutek nad zničeným Jeruzalémem a uprostřed "
        "bolesti nalézt naději v Boží věrnosti.",
        recipients="Přeživší po pádu Jeruzaléma",
        setting="Zničený Jeruzalém",
        people=["autor (tradičně Jeremjáš)"],
        places=["Jeruzalém"],
        features="Pět nářků; kap. 1–4 jsou abecední akrostichy.",
        themes=[
            ("Žal", "Bolest smí být vyslovena naplno."),
            ("Boží věrnost", "„Je nové každé ráno“ (3,22–23)."),
        ],
        timeline=[
            ("587/586 př. Kr.", "Zničení Jeruzaléma a chrámu"),
        ],
    ),
    26: dict(
        purpose="Ukázat vyhnancům, že Bůh je svrchovaný i v zajetí, že soud "
        "byl spravedlivý a že přijde obnova.",
        recipients="Židé v babylonském zajetí",
        setting="Babylónie, u řeky Kebar",
        people=["Ezechiel"],
        places=["řeka Kebar", "Jeruzalém"],
        features="Výrazná vidění: Boží sláva (kap. 1), suché kosti "
        "(kap. 37), nový chrám (kap. 40–48).",
        themes=[
            ("Boží sláva", "Bůh není vázán na jedno místo."),
            ("Osobní odpovědnost", "Každý odpovídá za své činy (kap. 18)."),
            ("Nové srdce", "Bůh dává nové srdce a nového ducha (36,26)."),
        ],
        timeline=[
            ("597 př. Kr.", "Ezechiel odveden do Babylónie"),
            ("593 př. Kr.", "Povolání"),
            ("587/586 př. Kr.", "Zpráva o pádu Jeruzaléma"),
            ("571 př. Kr.", "Poslední datované proroctví"),
        ],
    ),
    27: dict(
        purpose="Povzbudit k věrnosti v cizím prostředí a ukázat, že Bůh "
        "vládne nad dějinami.",
        recipients="Židé v zajetí a pod cizí vládou",
        setting="Babylón a Persie",
        people=["Daniel", "Chananjáš, Míšael a Azarjáš", "Nebúkadnesar",
                "Belšasar", "Dareios"],
        places=["Babylón"],
        features="Část psána aramejsky (2,4–7,28); příběhy (kap. 1–6) "
        "a apokalyptická vidění (kap. 7–12).",
        themes=[
            ("Věrnost", "Daniel a přátelé zůstávají věrní i za cenu života."),
            ("Boží vláda", "Říše přicházejí a odcházejí, Boží království "
             "trvá (2,44)."),
            ("Syn člověka", "Vidění, k němuž se Ježíš přihlásil (7,13–14)."),
        ],
        timeline=[
            ("605 př. Kr.", "Daniel odveden do Babylóna"),
            ("539 př. Kr.", "Pád Babylóna (Belšasarova hostina)"),
            ("cca 537 př. Kr.", "Daniel ve lví jámě (za Dareia)"),
        ],
    ),
    28: dict(
        purpose="Ukázat Boží věrnou lásku k nevěrnému lidu a vyzvat "
        "k návratu.",
        recipients="Severní Izrael",
        setting="Izrael před pádem Samaří",
        people=["Ozeáš", "Gomer"],
        places=["Samaří"],
        features="Prorokovo manželství je živým obrazem vztahu Boha "
        "a Izraele.",
        themes=[
            ("Věrná láska", "Bůh neopouští, i když je zrazen (11,8)."),
            ("Poznání Boha", "„Chci milosrdenství, ne oběť“ (6,6)."),
        ],
        timeline=[
            ("cca 755–715 př. Kr.", "Ozeášovo působení"),
            ("722 př. Kr.", "Pád Samaří"),
        ],
    ),
    29: dict(
        purpose="Vyzvat k pokání po pohromě kobylek a ohlásit Den Hospodinův "
        "i vylití Ducha.",
        recipients="Juda",
        setting="Juda po zničující pohromě",
        people=["Jóel"],
        places=["Jeruzalém", "Sijón"],
        features="Petr citoval Jóele o Letnicích (Sk 2).",
        themes=[
            ("Pokání", "„Roztrhněte svá srdce, ne roucha“ (2,13)."),
            ("Duch pro všechny", "Bůh vyleje svého Ducha na každé tělo (3,1)."),
        ],
        timeline=[
            ("nejisté", "Datace sporná (9.–4. stol. př. Kr.)"),
        ],
    ),
    30: dict(
        purpose="Odsoudit sociální nespravedlnost a prázdnou zbožnost.",
        recipients="Severní Izrael",
        setting="Izrael v době blahobytu",
        people=["Ámos", "Amasjáš", "Jarobeám II."],
        places=["Tekóa", "Bét-el", "Samaří"],
        features="Prorok byl pastýř a pěstitel fíků z Judska.",
        themes=[
            ("Spravedlnost", "„Ať se valí právo jako voda“ (5,24)."),
            ("Pravá bohoslužba", "Bůh odmítá bohoslužbu bez spravedlnosti."),
        ],
        timeline=[
            ("cca 760 př. Kr.", "Ámosovo působení (dva roky před "
             "zemětřesením)"),
        ],
    ),
    31: dict(
        purpose="Ohlásit soud nad Edómem za pýchu a krutost vůči Judovi.",
        recipients="Juda",
        setting="Po pádu Jeruzaléma",
        people=["Abdijáš"],
        places=["Edóm", "Jeruzalém"],
        features="Nejkratší kniha Starého zákona.",
        themes=[
            ("Pýcha", "Pýcha klame srdce (v. 3)."),
            ("Boží spravedlnost", "Jak jsi činil, tak se stane tobě (v. 15)."),
        ],
        timeline=[
            ("pravděpodobně po 586 př. Kr.", "Proroctví o Edómu"),
        ],
    ),
    32: dict(
        purpose="Ukázat Boží milosrdenství k nepřátelům a odhalit úzkost "
        "lidského srdce.",
        recipients="Izrael",
        setting="Jafo, moře, Ninive",
        people=["Jonáš"],
        places=["Jafo", "Taršíš", "Ninive"],
        features="Ježíš zmínil „znamení Jonášovo“ (Mt 12,39–41).",
        themes=[
            ("Boží milosrdenství", "Bůh má soucit i s krutými Ninivany."),
            ("Útěk před Bohem", "Před Bohem se nedá utéct – ale lze se "
             "k němu vrátit."),
        ],
        timeline=[
            ("cca 785–760 př. Kr.", "Jonášovo působení (za Jarobeáma II.)"),
        ],
    ),
    33: dict(
        purpose="Odsoudit nespravedlnost a zaslíbit vládce z Betléma.",
        recipients="Izrael a Juda",
        setting="Juda v 8. stol. př. Kr.",
        people=["Micheáš"],
        places=["Betlém", "Jeruzalém", "Samaří"],
        features="Předpověď Betléma jako místa narození Mesiáše (5,1).",
        themes=[
            ("Co Bůh žádá", "Právo, milosrdenství a pokora (6,8)."),
            ("Mesiáš", "Vládce z Betléma (5,1)."),
            ("Odpuštění", "Kdo je Bůh jako ty? (7,18)."),
        ],
        timeline=[
            ("cca 735–700 př. Kr.", "Micheášovo působení"),
        ],
    ),
    34: dict(
        purpose="Ohlásit pád Ninive a potěšit utlačené.",
        recipients="Juda",
        setting="Asyrská nadvláda",
        people=["Nahum"],
        places=["Ninive"],
        features="Ninive padlo roku 612 př. Kr.",
        themes=[
            ("Boží spravedlnost", "Krutost nezůstane bez soudu."),
            ("Útočiště", "„Hospodin je dobrý, je záštitou“ (1,7)."),
        ],
        timeline=[
            ("663–612 př. Kr.", "Vznik proroctví"),
            ("612 př. Kr.", "Pád Ninive"),
        ],
    ),
    35: dict(
        purpose="Zápasit s otázkou, proč Bůh dopouští zlo, a naučit se "
        "důvěřovat.",
        recipients="Juda",
        setting="Před babylonským vpádem",
        people=["Abakuk"],
        places=["Juda", "Babylónie"],
        features="Rozhovor proroka s Bohem; „spravedlivý bude žít z víry“ "
        "(2,4).",
        themes=[
            ("Otázky", "Prorok se nebojí ptát."),
            ("Víra", "Víra se drží Boha i bez úrody a jistot (3,17–18)."),
        ],
        timeline=[
            ("cca 605 př. Kr.", "Vzestup Babylónie"),
        ],
    ),
    36: dict(
        purpose="Ohlásit Den Hospodinův a vyzvat k pokoře.",
        recipients="Juda",
        setting="Za krále Jóšijáše",
        people=["Sofonjáš", "Jóšijáš"],
        places=["Jeruzalém"],
        features="Končí obrazem Boha, který se raduje nad svým lidem (3,17).",
        themes=[
            ("Soud", "Den Hospodinův přichází."),
            ("Radost", "Bůh se nad svým lidem raduje."),
        ],
        timeline=[
            ("640–609 př. Kr.", "Vláda Jóšijáše"),
        ],
    ),
    37: dict(
        purpose="Povzbudit navrátilce, aby dostavěli chrám.",
        recipients="Navrátilci v Jeruzalémě",
        setting="Jeruzalém 520 př. Kr.",
        people=["Ageus", "Zerubábel", "Jéšua"],
        places=["Jeruzalém"],
        features="Přesně datovaná proroctví během čtyř měsíců.",
        themes=[
            ("Priority", "Nejdřív Boží dům, ne jen vlastní domy (1,4)."),
            ("Povzbuzení", "„Buďte silní… já jsem s vámi“ (2,4)."),
        ],
        timeline=[
            ("520 př. Kr.", "Proroctví a obnovení stavby"),
            ("516/515 př. Kr.", "Dokončení chrámu"),
        ],
    ),
    38: dict(
        purpose="Povzbudit navrátilce vidinou Boží budoucnosti a příchodu "
        "krále.",
        recipients="Navrátilci v Jeruzalémě",
        setting="Jeruzalém po návratu",
        people=["Zacharjáš", "Zerubábel", "Jéšua"],
        places=["Jeruzalém"],
        features="Osm nočních vidění; král přijíždějící na oslu (9,9).",
        themes=[
            ("Boží Duch", "„Ne mocí ani silou, ale mým Duchem“ (4,6)."),
            ("Mesiáš", "Pokorný král (9,9), probodený (12,10)."),
        ],
        timeline=[
            ("520–518 př. Kr.", "Vidění"),
            ("po 480 př. Kr.", "Kapitoly 9–14 (pravděpodobně později)"),
        ],
    ),
    39: dict(
        purpose="Vyzvat k obnovení upřímného vztahu s Bohem a ohlásit posla "
        "před Hospodinovým příchodem.",
        recipients="Židé v Judsku",
        setting="Jeruzalém v 5. stol. př. Kr.",
        people=["Malachiáš"],
        places=["Jeruzalém"],
        features="Poslední kniha Starého zákona; ohlašuje Eliáše, kterého "
        "Ježíš ztotožnil s Janem Křtitelem.",
        themes=[
            ("Boží láska", "„Miluji vás“ (1,2)."),
            ("Upřímnost", "Bohu nepatří zbytky, ale to nejlepší."),
            ("Příchod Páně", "Posel připraví cestu (3,1)."),
        ],
        timeline=[
            ("cca 450–430 př. Kr.", "Malachiášovo působení"),
        ],
    ),
}
