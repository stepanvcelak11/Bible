"""Rozšíření úvodů ke knihám Nového zákona (vlastní text aplikace)."""

NT = {
    40: dict(
        purpose="Ukázat, že Ježíš je zaslíbený Mesiáš, Davidův syn a král, "
        "v němž se naplňuje Starý zákon.",
        recipients="Především křesťané židovského původu",
        setting="Galilea a Judsko",
        people=["Ježíš", "Marie", "Josef", "Jan Křtitel", "Petr", "učedníci",
                "farizeové", "Pilát"],
        places=["Betlém", "Egypt", "Nazaret", "Kafarnaum", "Jeruzalém"],
        features="Pět velkých řečí (např. Kázání na hoře, kap. 5–7); mnoho "
        "citací se slovy „aby se naplnilo“.",
        themes=[
            ("Ježíš Mesiáš", "Rodokmen, narození i skutky ukazují na "
             "naplnění Božích slibů."),
            ("Království nebeské", "Ježíš ohlašuje Boží vládu, která už "
             "začíná a jednou se plně projeví."),
            ("Učednictví", "Následovat Ježíše znamená žít jeho učení "
             "a předávat ho dál (28,19–20)."),
        ],
        timeline=[
            ("cca 6–4 př. Kr.", "Narození Ježíše"),
            ("cca 27–29 po Kr.", "Křest a začátek působení"),
            ("30 nebo 33 po Kr.", "Ukřižování a vzkříšení"),
            ("cca 60–80 po Kr.", "Sepsání evangelia"),
        ],
    ),
    41: dict(
        purpose="Představit Ježíše jako Božího Syna, který přišel sloužit "
        "a dát svůj život.",
        recipients="Především křesťané z pohanů (pravděpodobně v Římě)",
        setting="Galilea a Jeruzalém",
        people=["Ježíš", "Jan Křtitel", "Petr", "Jakub", "Jan", "Pilát"],
        places=["Galilea", "Kafarnaum", "Cesarea Filipova", "Jeruzalém"],
        features="Nejkratší a pravděpodobně nejstarší evangelium; rychlé "
        "tempo („hned“), vysvětluje židovské zvyky.",
        themes=[
            ("Služebník", "„Syn člověka nepřišel, aby si dal sloužit“ "
             "(10,45)."),
            ("Kdo je Ježíš?", "Otázka prochází celou knihou až k vyznání "
             "setníka (15,39)."),
            ("Učedníci", "Učedníci často nechápou – a Ježíš s nimi přesto "
             "trpělivě pracuje."),
        ],
        timeline=[
            ("cca 27–29 po Kr.", "Začátek působení v Galileji"),
            ("30 nebo 33 po Kr.", "Poslední týden v Jeruzalémě"),
            ("cca 60–70 po Kr.", "Sepsání evangelia"),
        ],
    ),
    42: dict(
        purpose="Podat spořádaný a ověřený popis Ježíšova života (1,3–4) "
        "a ukázat ho jako Spasitele všech lidí.",
        recipients="Theofilos a křesťané z pohanů",
        setting="Galilea, Samaří, Judsko",
        people=["Ježíš", "Marie", "Alžběta", "Zachariáš", "Jan Křtitel",
                "Zacheus", "učedníci"],
        places=["Nazaret", "Betlém", "Galilea", "Jericho", "Jeruzalém",
                "Emauzy"],
        features="Nejvíce podobenství (marnotratný syn, milosrdný "
        "Samařan); zájem o chudé, ženy a vyděděnce.",
        themes=[
            ("Spasitel všech", "Ježíš přišel hledat a zachránit, co "
             "zahynulo (19,10)."),
            ("Modlitba a Duch", "Ježíš se často modlí; Duch svatý vede "
             "události."),
            ("Soucit", "Bůh je otec, který vybíhá naproti (15,20)."),
        ],
        timeline=[
            ("cca 6–4 př. Kr.", "Narození Jana Křtitele a Ježíše"),
            ("cca 28 po Kr.", "15. rok vlády Tiberia, vystoupení Jana "
             "Křtitele (3,1)"),
            ("30 nebo 33 po Kr.", "Ukřižování, vzkříšení, nanebevstoupení"),
            ("cca 60–80 po Kr.", "Sepsání evangelia"),
        ],
    ),
    43: dict(
        purpose="Vést k víře, že Ježíš je Kristus, Syn Boží, a k životu "
        "v jeho jménu (20,31).",
        recipients="Křesťané i hledající",
        setting="Galilea, Samaří a hlavně Jeruzalém",
        people=["Ježíš", "Jan Křtitel", "Nikodém", "Samařanka", "Marta, "
                "Marie a Lazar", "Tomáš", "Petr"],
        places=["Kána", "Sychar", "Betanie", "Jeruzalém"],
        features="Sedm znamení a sedm výroků „Já jsem“; zmiňuje tři "
        "svátky Paschy.",
        themes=[
            ("Ježíš je Bůh", "Slovo bylo u Boha a Slovo byl Bůh (1,1)."),
            ("Víra a život", "Kdo věří, má život věčný (3,16)."),
            ("Láska", "„Milujte se navzájem, jako jsem já miloval vás“ "
             "(15,12)."),
        ],
        timeline=[
            ("cca 27–29 po Kr.", "Začátek Ježíšova působení"),
            ("30 nebo 33 po Kr.", "Ukřižování a vzkříšení"),
            ("cca 90 po Kr.", "Sepsání evangelia"),
        ],
    ),
    44: dict(
        purpose="Ukázat, jak se evangelium v moci Ducha svatého šířilo "
        "z Jeruzaléma až do Říma.",
        recipients="Theofilos a církev",
        setting="Jeruzalém, Judsko, Samaří, Malá Asie, Řecko, Řím",
        people=["Petr", "Jan", "Štěpán", "Filip", "Pavel", "Barnabáš",
                "Silas", "Lukáš"],
        places=["Jeruzalém", "Samaří", "Antiochie", "Efez", "Korint",
                "Řím"],
        features="Pokračování Lukášova evangelia; pasáže v 1. osobě "
        "množného čísla („my“) naznačují autora jako očitého svědka.",
        themes=[
            ("Duch svatý", "Duch dává odvahu i směr (1,8)."),
            ("Církev", "Společenství učení, chleba a modlitby (2,42)."),
            ("Evangelium pro všechny", "Bůh nedělá rozdíly mezi národy "
             "(10,34–35)."),
        ],
        timeline=[
            ("30 nebo 33 po Kr.", "Letnice"),
            ("cca 33–36 po Kr.", "Obrácení Pavla"),
            ("cca 46–48 po Kr.", "1. misijní cesta"),
            ("cca 49 po Kr.", "Apoštolský sněm"),
            ("cca 49–52 po Kr.", "2. misijní cesta"),
            ("cca 53–57 po Kr.", "3. misijní cesta"),
            ("cca 60–62 po Kr.", "Pavel v Římě"),
        ],
    ),
    45: dict(
        purpose="Vyložit evangelium: všichni zhřešili a všichni mohou být "
        "ospravedlněni z milosti skrze víru v Krista.",
        recipients="Křesťané v Římě",
        setting="Pavel píše z Korintu před cestou do Jeruzaléma",
        people=["Pavel", "Foibé", "Priska a Akvila"],
        places=["Řím", "Korint"],
        features="Nejsoustavnější Pavlův dopis; výklad o Izraeli "
        "(kap. 9–11).",
        themes=[
            ("Hřích", "Všichni zhřešili (3,23)."),
            ("Ospravedlnění z víry", "Spravedlnost je Boží dar (3,24)."),
            ("Život v Duchu", "Žádné odsouzení pro ty, kdo jsou v Kristu "
             "(kap. 8)."),
            ("Proměna", "Neřiďte se tímto světem, ale proměňujte se "
             "(12,2)."),
        ],
        timeline=[("cca 57 po Kr.", "Sepsání dopisu v Korintu")],
    ),
    46: dict(
        purpose="Řešit rozdělení a problémy v korintském sboru a ukázat "
        "cestu lásky.",
        recipients="Sbor v Korintu",
        setting="Pavel píše z Efezu",
        people=["Pavel", "Apollos", "Petr (Kéfas)", "Sóstenés"],
        places=["Korint", "Efez"],
        features="Píseň o lásce (kap. 13) a jedno z nejstarších písemných "
        "svědectví o vzkříšení (15,3–8).",
        themes=[
            ("Jednota", "Církev je jedno tělo s mnoha údy (kap. 12)."),
            ("Láska", "Bez lásky nejsem nic (13,2)."),
            ("Vzkříšení", "Kristus vstal – a proto i naše víra má smysl."),
        ],
        timeline=[
            ("cca 50–52 po Kr.", "Pavel zakládá sbor v Korintu"),
            ("cca 54 po Kr.", "Sepsání dopisu"),
        ],
    ),
    47: dict(
        purpose="Obhájit Pavlovu službu a ukázat, že Boží moc se projevuje "
        "ve slabosti.",
        recipients="Sbor v Korintu",
        setting="Pavel píše z Makedonie",
        people=["Pavel", "Titus"],
        places=["Korint", "Makedonie"],
        features="Nejosobnější Pavlův dopis; sbírka pro Jeruzalém "
        "(kap. 8–9).",
        themes=[
            ("Síla ve slabosti", "„Stačí ti má milost“ (12,9)."),
            ("Smíření", "Bůh nás v Kristu smířil se sebou (5,18–20)."),
            ("Štědrost", "Radostného dárce miluje Bůh (9,7)."),
        ],
        timeline=[("cca 55–56 po Kr.", "Sepsání dopisu")],
    ),
    48: dict(
        purpose="Bránit evangelium milosti proti učení, že spásu je třeba "
        "si zasloužit dodržováním Zákona.",
        recipients="Sbory v Galacii",
        setting="Po Pavlově první misijní cestě",
        people=["Pavel", "Petr", "Barnabáš", "Titus"],
        places=["Galacie", "Jeruzalém", "Antiochie"],
        features="Ostrý tón; ovoce Ducha (5,22–23).",
        themes=[
            ("Svoboda", "Kristus nás osvobodil (5,1)."),
            ("Víra, ne zásluhy", "Ospravedlnění z víry v Krista (2,16)."),
            ("Život v Duchu", "Ovoce Ducha roste ve vztazích."),
        ],
        timeline=[("cca 49–55 po Kr.", "Sepsání dopisu (datace sporná)")],
    ),
    49: dict(
        purpose="Ukázat bohatství, které máme v Kristu, a jak má církev "
        "žít jako jedno tělo.",
        recipients="Křesťané v Efezu a okolí",
        setting="Pavel ve vězení (pravděpodobně v Římě)",
        people=["Pavel", "Tychikos"],
        places=["Efez"],
        features="Boží výzbroj (6,10–18); učení o manželství a rodině.",
        themes=[
            ("Milost", "Spaseni jste milostí skrze víru (2,8–9)."),
            ("Jednota", "Jedno tělo a jeden Duch (4,4)."),
            ("Duchovní boj", "Oblečte se do Boží výzbroje (6,11)."),
        ],
        timeline=[("cca 60–62 po Kr.", "Sepsání dopisu")],
    ),
    50: dict(
        purpose="Poděkovat Filipským, povzbudit je k jednotě a radosti "
        "v Kristu.",
        recipients="Sbor ve Filipech",
        setting="Pavel ve vězení",
        people=["Pavel", "Timoteus", "Epafroditos", "Euodia a Syntyché"],
        places=["Filipy", "Řím"],
        features="Dopis radosti; píseň o Kristově pokoře (2,5–11).",
        themes=[
            ("Radost", "Radujte se v Pánu vždycky (4,4)."),
            ("Pokora", "Mějte stejné smýšlení jako Kristus (2,5)."),
            ("Spokojenost", "Naučil jsem se být spokojen (4,11)."),
        ],
        timeline=[
            ("cca 49–50 po Kr.", "Založení sboru (Sk 16)"),
            ("cca 60–62 po Kr.", "Sepsání dopisu"),
        ],
    ),
    51: dict(
        purpose="Ukázat Kristovu nadřazenost nad vším a varovat před "
        "falešným učením.",
        recipients="Sbor v Kolosách",
        setting="Pavel ve vězení",
        people=["Pavel", "Epafras", "Onésimos", "Tychikos"],
        places=["Kolosy", "Laodikeia"],
        features="Hymnus o Kristu (1,15–20).",
        themes=[
            ("Kristus nade vším", "V něm je obsažena všechna plnost (2,9)."),
            ("Nový život", "Oblečte se do soucitu a lásky (3,12–14)."),
        ],
        timeline=[("cca 60–62 po Kr.", "Sepsání dopisu")],
    ),
    52: dict(
        purpose="Povzbudit mladý sbor v pronásledování a vysvětlit naději "
        "Kristova příchodu.",
        recipients="Sbor v Tesalonice",
        setting="Pavel píše z Korintu",
        people=["Pavel", "Silvanus", "Timoteus"],
        places=["Tesalonika", "Korint"],
        features="Jedna z nejstarších knih Nového zákona.",
        themes=[
            ("Víra, láska, naděje", "Dílo víry, námaha lásky, vytrvalost "
             "naděje (1,3)."),
            ("Kristův příchod", "Útěcha pro truchlící (4,13–18)."),
        ],
        timeline=[
            ("cca 49–50 po Kr.", "Založení sboru (Sk 17)"),
            ("cca 50–51 po Kr.", "Sepsání dopisu"),
        ],
    ),
    53: dict(
        purpose="Opravit nedorozumění o dni Páně a vyzvat k vytrvalosti "
        "a práci.",
        recipients="Sbor v Tesalonice",
        setting="Krátce po prvním dopise",
        people=["Pavel", "Silvanus", "Timoteus"],
        places=["Tesalonika"],
        features="„Kdo nechce pracovat, ať nejí“ (3,10).",
        themes=[
            ("Vytrvalost", "Neochabujte v konání dobra (3,13)."),
            ("Den Páně", "Nedejte se vyvést z míry spekulacemi."),
        ],
        timeline=[("cca 51 po Kr.", "Sepsání dopisu")],
    ),
    54: dict(
        purpose="Dát Timoteovi pokyny pro vedení sboru a varovat před "
        "falešným učením.",
        recipients="Timoteus v Efezu",
        setting="Efez",
        people=["Pavel", "Timoteus"],
        places=["Efez"],
        features="Požadavky na starší a služebníky sboru (kap. 3).",
        themes=[
            ("Zdravé učení", "Kristus přišel na svět zachránit hříšníky "
             "(1,15)."),
            ("Vzor", "Buď věřícím příkladem (4,12)."),
            ("Peníze", "Zbožnost se spokojeností je velký zisk (6,6)."),
        ],
        timeline=[("cca 62–64 po Kr.", "Sepsání dopisu (podle tradice)")],
    ),
    55: dict(
        purpose="Povzbudit Timotea k věrnosti a odvaze; Pavlovo rozloučení.",
        recipients="Timoteus",
        setting="Pavel ve vězení v Římě před popravou",
        people=["Pavel", "Timoteus", "Lukáš", "Marek", "Lóis a Euniké"],
        places=["Řím", "Efez"],
        features="Pavlův poslední dopis: „Dobrý boj jsem bojoval“ (4,7).",
        themes=[
            ("Věrnost do konce", "Vytrvat i v utrpení."),
            ("Písmo", "Celé Písmo je inspirováno Bohem (3,16)."),
        ],
        timeline=[
            ("cca 64 po Kr.", "Neronovo pronásledování křesťanů"),
            ("cca 66–67 po Kr.", "Sepsání dopisu, Pavlova smrt"),
        ],
    ),
    56: dict(
        purpose="Pomoci Titovi uspořádat sbory na Krétě a ukázat, že "
        "zdravé učení vede k dobrým skutkům.",
        recipients="Titus na Krétě",
        setting="Kréta",
        people=["Pavel", "Titus"],
        places=["Kréta", "Nikopolis"],
        features="Krátký souhrn milosti, která vychovává (2,11–14).",
        themes=[
            ("Milost", "Bůh nás zachránil ne pro naše skutky (3,5)."),
            ("Dobré skutky", "Víra se ukazuje v praktickém životě."),
        ],
        timeline=[("cca 63–65 po Kr.", "Sepsání dopisu (podle tradice)")],
    ),
    57: dict(
        purpose="Prosit Filemona, aby přijal uprchlého otroka Onésima jako "
        "bratra v Kristu.",
        recipients="Filemon a sbor v jeho domě",
        setting="Pavel ve vězení",
        people=["Pavel", "Filemon", "Onésimos"],
        places=["Kolosy"],
        features="Nejkratší Pavlův dopis; ukázka odpuštění v praxi.",
        themes=[
            ("Odpuštění", "Přijmi ho jako mne (v. 17)."),
            ("Rovnost v Kristu", "Otrok i pán jsou bratři."),
        ],
        timeline=[("cca 60–62 po Kr.", "Sepsání dopisu")],
    ),
    58: dict(
        purpose="Ukázat, že Kristus je větší než andělé, Mojžíš i kněžství, "
        "a povzbudit k vytrvalosti ve víře.",
        recipients="Křesťané židovského původu",
        setting="Nejisté; pravděpodobně před zničením chrámu",
        people=["Ježíš (velekněz)", "Melchisedech", "hrdinové víry"],
        places=["Jeruzalém"],
        features="Galerie víry (kap. 11); autor neznámý.",
        themes=[
            ("Kristus je větší", "Jedinečná oběť a věčný velekněz."),
            ("Víra", "Víra je podstata toho, v co doufáme (11,1)."),
            ("Vytrvalost", "Běžme vytrvale, upřeme zrak na Ježíše (12,1–2)."),
        ],
        timeline=[("pravděpodobně před 70 po Kr.", "Sepsání listu")],
    ),
    59: dict(
        purpose="Vyzvat k živé víře, která se projevuje skutky.",
        recipients="Židovští křesťané v diaspoře",
        setting="Jeruzalém",
        people=["Jakub"],
        places=["Jeruzalém"],
        features="Praktická moudrost podobná Přísloví a Kázání na hoře.",
        themes=[
            ("Víra a skutky", "Víra bez skutků je mrtvá (2,17)."),
            ("Jazyk", "Malý úd, velká moc (kap. 3)."),
            ("Zkoušky", "Zkoušky vedou k vytrvalosti (1,2–4)."),
        ],
        timeline=[("cca 45–62 po Kr.", "Sepsání listu (Jakub zemřel 62)")],
    ),
    60: dict(
        purpose="Povzbudit křesťany v utrpení živou nadějí a vyzvat "
        "k dobrému životu mezi nevěřícími.",
        recipients="Křesťané v Malé Asii",
        setting="Petr píše z „Babylóna“ (pravděpodobně Říma)",
        people=["Petr", "Silvanus", "Marek"],
        places=["Pontus, Galacie, Kappadokie, Asie, Bithýnie", "Řím"],
        features="„Buďte vždy připraveni obhájit naději“ (3,15).",
        themes=[
            ("Naděje", "Znovuzrození k živé naději (1,3)."),
            ("Utrpení", "Trpět pro dobro má smysl."),
            ("Identita", "Vyvolený rod, Boží lid (2,9)."),
        ],
        timeline=[("cca 62–64 po Kr.", "Sepsání listu")],
    ),
    61: dict(
        purpose="Varovat před falešnými učiteli a vyzvat k růstu v poznání.",
        recipients="Stejní čtenáři jako 1. Petrův",
        setting="Krátce před Petrovou smrtí",
        people=["Petr"],
        places=["Řím"],
        features="Bůh je trpělivý, nechce, aby někdo zahynul (3,9).",
        themes=[
            ("Růst", "Rostěte v milosti a poznání (3,18)."),
            ("Pravda", "Rozlišovat falešné učení."),
        ],
        timeline=[("cca 64–68 po Kr.", "Sepsání listu")],
    ),
    62: dict(
        purpose="Upevnit jistotu víry a varovat před bludy; ukázat, že Bůh "
        "je světlo a láska.",
        recipients="Sbory v okolí Efezu",
        setting="Efez",
        people=["Jan"],
        places=["Efez"],
        features="Jednoduchý jazyk, hluboké myšlenky; „Bůh je láska“ (4,8).",
        themes=[
            ("Láska", "Milujeme, protože on první miloval nás (4,19)."),
            ("Světlo", "Chodit ve světle, vyznávat hříchy (1,9)."),
            ("Jistota", "Abyste věděli, že máte věčný život (5,13)."),
        ],
        timeline=[("cca 85–95 po Kr.", "Sepsání listu")],
    ),
    63: dict(
        purpose="Vyzvat k lásce a varovat před bludnými učiteli.",
        recipients="„Vyvolená paní a její děti“ – pravděpodobně sbor",
        setting="Efez",
        people=["Jan (Starší)"],
        places=["Efez"],
        features="Jeden z nejkratších dopisů Bible.",
        themes=[("Pravda a láska", "Láska se drží pravdy.")],
        timeline=[("cca 85–95 po Kr.", "Sepsání listu")],
    ),
    64: dict(
        purpose="Pochválit Gaia za pohostinnost a varovat před "
        "Diotrefovou pýchou.",
        recipients="Gaius",
        setting="Efez",
        people=["Jan (Starší)", "Gaius", "Diotrefés", "Démétrios"],
        places=["Efez"],
        features="Nejkratší kniha Nového zákona.",
        themes=[("Pohostinnost", "Podporovat Boží služebníky.")],
        timeline=[("cca 85–95 po Kr.", "Sepsání listu")],
    ),
    65: dict(
        purpose="Vyzvat k zápasu o víru proti bezbožným učitelům.",
        recipients="Křesťané ohrožení bludy",
        setting="Nejisté",
        people=["Juda", "Michael"],
        places=[],
        features="Krásný závěrečný chvalozpěv (v. 24–25).",
        themes=[
            ("Zápas o víru", "Bojujte za víru jednou provždy danou (v. 3)."),
            ("Ochrana", "Bůh vás může zachovat od pádu (v. 24)."),
        ],
        timeline=[("cca 65–80 po Kr.", "Sepsání listu")],
    ),
    66: dict(
        purpose="Povzbudit pronásledované křesťany vizí Kristova vítězství "
        "a nového stvoření.",
        recipients="Sedm sborů v Malé Asii",
        setting="Ostrov Patmos",
        people=["Jan", "Ježíš (Beránek)", "sedm sborů"],
        places=["Patmos", "Efez", "Smyrna", "Pergamon", "Thyatira",
                "Sardy", "Filadelfie", "Laodikeia"],
        features="Apokalyptická kniha plná symbolů a čísel; vykladači se "
        "liší v pojetí (historické, futuristické, symbolické).",
        themes=[
            ("Kristovo vítězství", "Beránek zvítězil."),
            ("Věrnost", "Buď věrný až do smrti (2,10)."),
            ("Nové stvoření", "Bůh setře každou slzu (21,4)."),
        ],
        timeline=[
            ("cca 95 po Kr.", "Jan na Patmu, za císaře Domitiána"),
        ],
    ),
}
