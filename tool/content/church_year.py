"""Církevní rok: doby a svátky (vlastní texty aplikace).

Data svátků počítá aplikace (Velikonoce podle gregoriánského výpočtu,
advent od čtvrté neděle před Vánocemi). Odkazy v kanonickém (hebrejském)
číslování.
"""

# (id, barva, název, úvod, [odkazy])
SEASONS = [
    ("advent", "violet", "Advent",
     "Čas očekávání. Církev si připomíná, jak Izrael čekal na Mesiáše, "
     "a zároveň se dívá dopředu – ke Kristovu druhému příchodu. Advent zve "
     "ke ztišení, bdělosti a naději.",
     ["Iz 40,3-5", "Iz 9,1", "L 1,30-33", "Ř 13,11-12", "Mt 24,42"]),
    ("christmas", "white", "Vánoční doba",
     "Radost z narození Ježíše: Bůh se stal člověkem a přišel mezi nás. "
     "Vánoční doba trvá od Božího hodu do neděle Křtu Páně.",
     ["L 2,10-11", "J 1,14", "Iz 9,5", "Ga 4,4-5", "Tt 2,11"]),
    ("ordinary", "green", "Liturgické mezidobí",
     "Zelená barva naděje a růstu. Mezidobí nemá jeden velký svátek – je "
     "to čas, kdy se víra učí žít ve všedních dnech. Evangelia provázejí "
     "Ježíšovým učením a skutky.",
     ["Ž 1,1-3", "Mt 13,31-32", "J 15,5", "Ko 2,6-7", "Ga 6,9"]),
    ("lent", "violet", "Postní doba",
     "Čtyřicet dní (bez nedělí) příprav na Velikonoce – podle Ježíšových "
     "čtyřiceti dní na poušti. Čas pokání, modlitby, odříkání a pomoci "
     "druhým.",
     ["Jl 2,12-13", "Mt 4,1-4", "Ž 51,12-14", "Iz 58,6-7", "2K 6,2"]),
    ("holyweek", "red", "Svatý týden",
     "Nejdůležitější týden roku: od Ježíšova vjezdu do Jeruzaléma přes "
     "poslední večeři, kříž a ticho hrobu až k velikonočnímu ránu.",
     ["Za 9,9", "J 13,1", "Iz 53,4-5", "Fp 2,8-9"]),
    ("easter", "white", "Velikonoční doba",
     "Padesát dní radosti ze vzkříšení – od Velikonoc do Letnic. "
     "Čtou se zprávy o setkáních se vzkříšeným a o prvních krocích "
     "církve ve Skutcích apoštolů.",
     ["1K 15,20", "J 20,19-20", "L 24,30-32", "1Pt 1,3", "Sk 2,42"]),
]

# (id, barva, název, text, [odkazy]) – pořadí podle církevního roku
FEASTS = [
    ("advent1", "violet", "1. neděle adventní",
     "Začátek nového církevního roku. Na adventním věnci se zapaluje první "
     "svíce – světlo, které roste, jak se blíží Vánoce.",
     ["Iz 2,4-5", "Ř 13,11-12", "Mt 24,42-44"]),
    ("christmas", "white", "Narození Páně (Boží hod vánoční)",
     "Slavnost Ježíšova narození v Betlémě. Pastýřům se zvěstuje „veliká "
     "radost pro všechen lid“ – Spasitel se narodil jako malé dítě.",
     ["L 2,8-14", "J 1,14", "Iz 9,5"]),
    ("epiphany", "white", "Zjevení Páně (Tři králové)",
     "Mudrci z východu přicházejí k Ježíši. Svátek říká, že Kristus je "
     "světlo pro všechny národy, nejen pro jeden národ.",
     ["Mt 2,1-2", "Mt 2,10-11", "Iz 60,1-3"]),
    ("baptism", "white", "Křest Páně",
     "Ježíš se nechává pokřtít od Jana v Jordánu a z nebe zaznívá: „Toto "
     "je můj milovaný Syn.“ Tímto svátkem končí vánoční doba.",
     ["Mt 3,13-17", "Iz 42,1"]),
    ("presentation", "white", "Uvedení Páně do chrámu (Hromnice)",
     "Čtyřicet dní po narození přinášejí Marie a Josef Ježíše do chrámu. "
     "Starý Simeon v něm poznává „světlo k osvícení národů“.",
     ["L 2,25-32"]),
    ("ash", "violet", "Popeleční středa",
     "Začátek postní doby. Popel připomíná lidskou pomíjivost i pokání – "
     "a Boží milosrdenství, které na pokání odpovídá.",
     ["Jl 2,12-13", "Ž 51,3-4", "Mt 6,16-18"]),
    ("palm", "red", "Květná neděle",
     "Ježíš vjíždí do Jeruzaléma na oslátku a zástupy ho vítají palmovými "
     "ratolestmi a voláním „Hosanna!“. Začíná Svatý týden.",
     ["Mt 21,8-9", "Za 9,9", "Fp 2,6-8"]),
    ("thursday", "white", "Zelený čtvrtek",
     "Večer poslední večeře. Ježíš myje učedníkům nohy, dává jim chléb "
     "a kalich a nové přikázání lásky. V noci je zatčen v Getsemane.",
     ["J 13,14-15", "1K 11,23-26", "J 13,34-35"]),
    ("friday", "red", "Velký pátek",
     "Den Ježíšovy smrti na kříži. Křesťané si v tichu připomínají, že "
     "Kristus nesl hřích světa a zemřel z lásky.",
     ["Iz 53,4-6", "J 19,28-30", "Žd 4,15-16"]),
    ("saturday", "violet", "Bílá sobota",
     "Den ticha u hrobu. Ježíšovo tělo leží v hrobě; církev čeká a bdí. "
     "Večer začíná velikonoční vigilie.",
     ["Mt 27,59-61", "Ž 16,9-10"]),
    ("easter", "white", "Zmrtvýchvstání Páně (Velikonoce)",
     "Největší svátek křesťanů: Ježíš vstal z mrtvých. Prázdný hrob je "
     "znamením, že smrt nemá poslední slovo.",
     ["Mt 28,5-7", "1K 15,3-4", "J 11,25-26"]),
    ("ascension", "white", "Nanebevstoupení Páně",
     "Čtyřicátý den po Velikonocích. Vzkříšený Ježíš se loučí s učedníky, "
     "posílá je do světa a slibuje jim Ducha svatého.",
     ["Sk 1,8-11", "Mt 28,18-20"]),
    ("pentecost", "red", "Seslání Ducha svatého (Letnice)",
     "Padesátý den po Velikonocích sestupuje na učedníky Duch svatý. "
     "Petr káže a z jeruzalémského shromáždění se rodí církev.",
     ["Sk 2,1-4", "Jl 3,1", "Ga 5,22-23"]),
    ("trinity", "white", "Nejsvětější Trojice",
     "Neděle po Letnicích. Svátek tajemství jednoho Boha – Otce, Syna "
     "a Ducha svatého.",
     ["Mt 28,19", "2K 13,13"]),
    ("cyrilmethod", "red", "Cyril a Metoděj",
     "Slovanští věrozvěsti, kteří v 9. století přišli na Velkou Moravu, "
     "přeložili části Bible do slovanského jazyka a hlásali evangelium "
     "srozumitelnou řečí.",
     ["Ř 10,14-15", "Ž 117,1-2"]),
    ("hus", "red", "Mistr Jan Hus",
     "Den upálení Mistra Jana Husa v Kostnici (1415). Kazatel, který "
     "zdůrazňoval autoritu Písma, věrnost pravdě a svědomí.",
     ["J 8,31-32", "Sk 5,29"]),
    ("reformation", "red", "Den reformace",
     "Výročí Lutherových tezí (1517). Evangelické církve si připomínají "
     "návrat k Písmu a ke zvěsti o milosti, kterou člověk přijímá vírou.",
     ["Ř 1,16-17", "Ef 2,8-9"]),
    ("allsaints", "white", "Všech svatých",
     "Svátek všech, kdo žili s Bohem – známých i neznámých. Bible jim "
     "říká „veliký oblak svědků“.",
     ["Žd 12,1-2", "Zj 7,9-10"]),
    ("allsouls", "violet", "Památka zesnulých (Dušičky)",
     "Den vzpomínky na zemřelé. Křesťané truchlí, ale „ne jako ti, kdo "
     "nemají naději“.",
     ["1Te 4,13-14", "J 14,1-3"]),
    ("lastsunday", "white", "Poslední neděle církevního roku",
     "Rok končí pohledem k cíli: ke Kristu, který vládne, a k novému "
     "nebi a nové zemi, kde Bůh setře každou slzu.",
     ["Zj 21,3-5", "Mt 25,34-36", "Ko 1,15-17"]),
]
