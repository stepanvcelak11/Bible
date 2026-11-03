"""Plány měst a staveb (vlastní schematické kresby aplikace).

Každý plán: plátno w × h (sever nahoře, není-li řečeno jinak), tvary
a očíslované body s popisem a odkazy. Rozměry staveb podle biblického
popisu (loket ≈ 45 cm); plány měst jsou schematické – poloha údolí, hradeb
a míst podle běžných rekonstrukcí, místa nejistá jsou tak označena.

Tvary: R(x, y, w, h, styl), P(styl, body…) uzavřený mnohoúhelník,
L(styl, body…) čára, C(x, y, r, styl), T(x, y, text, velikost),
SCALE(x, y, délka, popisek), NORTH(x, y).
Styly: ground court wall building holy most water valley road screen
furniture camp camp2 hill.
"""


def R(x, y, w, h, s):
    return {"k": "rect", "s": s, "p": [x, y, w, h]}


def P(s, *pts):
    return {"k": "poly", "s": s, "p": [c for p in pts for c in p]}


def L(s, *pts):
    return {"k": "line", "s": s, "p": [c for p in pts for c in p]}


def C(x, y, r, s):
    return {"k": "circle", "s": s, "p": [x, y, r]}


def T(x, y, text, z=1.0):
    return {"k": "text", "s": "text", "p": [x, y, z], "t": text}


def SCALE(x, y, length, label):
    return {"k": "scale", "s": "text", "p": [x, y, length], "t": label}


def NORTH(x, y):
    return {"k": "north", "s": "text", "p": [x, y]}


# --- Svatostánek ------------------------------------------------------------
# 1 loket = 3,6 px; nádvoří 100 × 50 loket, vchod na východě (vpravo).
_tab = [
    R(20, 25, 360, 180, "court"),
    L("wall", (380, 79), (380, 25), (20, 25), (20, 205), (380, 205),
      (380, 151)),
    L("screen", (380, 79), (380, 151)),
    R(56, 97, 36, 36, "most"),
    R(92, 97, 72, 36, "holy"),
    L("screen", (92, 97), (92, 133)),
    R(67, 110, 14, 10, "furniture"),          # truhla
    R(118, 101, 16, 7, "furniture"),          # stůl (sever)
    C(126, 126, 4, "furniture"),              # svícen (jih)
    R(99, 111, 8, 8, "furniture"),            # kadidlový oltář
    C(240, 115, 7, "water"),                  # umyvadlo
    R(291, 106, 18, 18, "building"),          # oltář
    T(250, 190, "NÁDVOŘÍ"),
    SCALE(30, 222, 36, "10 loket ≈ 4,5 m"),
    NORTH(370, 222),
]

# --- Tábor Izraele -----------------------------------------------------------
def _camp(x, y, w, h, name, lead=False):
    return [R(x, y, w, h, "camp2" if lead else "camp"),
            T(x + w / 2, y + h / 2, name, 0.9)]


_camp_shapes = [
    R(160, 120, 80, 50, "court"), R(170, 136, 28, 18, "holy"),
    R(160, 98, 80, 18, "building"), T(200, 107, "Merarí", 0.8),
    R(160, 174, 80, 18, "building"), T(200, 183, "Kehat", 0.8),
    R(126, 120, 30, 50, "building"), T(141, 145, "Geršon", 0.75),
    R(244, 120, 34, 50, "building"), T(261, 140, "Mojžíš", 0.7),
    T(261, 151, "Áron", 0.7),
    *_camp(90, 40, 72, 44, "Ašer"), *_camp(164, 40, 72, 44, "Dan", True),
    *_camp(238, 40, 72, 44, "Neftalí"),
    *_camp(290, 92, 80, 44, "Isachar"), *_camp(290, 138, 80, 44, "Juda", True),
    *_camp(290, 184, 80, 44, "Zabulon"),
    *_camp(90, 236, 72, 44, "Šimeon"), *_camp(164, 236, 72, 44, "Rúben", True),
    *_camp(238, 236, 72, 44, "Gád"),
    *_camp(30, 92, 80, 44, "Benjamín"), *_camp(30, 138, 80, 44, "Efrajim", True),
    *_camp(30, 184, 80, 44, "Manases"),
    T(380, 160, "V", 1.1), T(200, 20, "S", 1.1),
]

# --- Šalomounův chrám --------------------------------------------------------
# 1 loket = 3 px; dům 60 × 20 loket, předsíň 10 loket, vchod na východě.
_sol = [
    R(20, 30, 360, 210, "court"),
    R(45, 85, 195, 90, "building"),           # postranní komory
    R(60, 100, 60, 60, "most"),
    R(120, 100, 120, 60, "holy"),
    R(240, 100, 30, 60, "building"),          # předsíň
    L("screen", (120, 100), (120, 160)),
    L("furniture", (63, 130), (117, 130)),    # křídla cherubů
    R(84, 124, 12, 12, "furniture"),          # truhla
    R(126, 126, 8, 8, "furniture"),           # zlatý oltář
    *[C(150 + 20 * i, 108, 3, "furniture") for i in range(5)],
    *[C(150 + 20 * i, 152, 3, "furniture") for i in range(5)],
    C(278, 112, 5, "building"), C(278, 148, 5, "building"),
    R(300, 100, 60, 60, "building"),          # bronzový oltář
    C(305, 212, 15, "water"),                 # moře
    *[C(70 + 28 * i, 60, 6, "water") for i in range(5)],
    *[C(70 + 28 * i, 205, 6, "water") for i in range(5)],
    T(200, 228, "VNITŘNÍ NÁDVOŘÍ", 0.85),
    SCALE(30, 252, 30, "10 loket ≈ 4,5 m"),
    NORTH(370, 252),
]

# --- Herodův chrám -------------------------------------------------------------
_her = [
    P("court", (80, 30), (320, 30), (320, 285), (80, 285)),
    R(52, 18, 64, 34, "building"),            # Antonia
    R(80, 263, 240, 22, "building"),          # Královská stoa
    R(298, 30, 22, 233, "building"),          # Šalomounovo sloupořadí
    R(82, 30, 216, 10, "building"),
    R(82, 40, 10, 223, "building"),
    L("screen", (118, 80), (262, 80), (262, 210), (118, 210), (118, 80)),
    R(130, 100, 80, 80, "holy"),              # nádvoří Izraele a kněží
    R(210, 112, 44, 56, "court"),             # nádvoří žen
    R(138, 122, 34, 36, "most"),              # svatyně
    R(182, 130, 18, 18, "building"),          # oltář
    T(200, 236, "NÁDVOŘÍ POHANŮ", 0.85),
    T(84, 12, "Antonia", 0.8),
    L("wall", (80, 30), (320, 30), (320, 285), (80, 285), (80, 30)),
    NORTH(360, 290),
]

# --- Jeruzalém: údolí společná pro plány města -------------------------------
_valleys = [
    L("valley", (300, 15), (292, 120), (272, 220), (244, 320), (218, 362)),
    L("valley", (186, 30), (184, 150), (194, 260), (214, 352)),
    L("valley", (52, 70), (64, 200), (104, 312), (166, 356), (218, 362)),
    T(318, 170, "Kidron", 0.75), T(160, 230, "Tyropoion", 0.7),
    T(70, 300, "Hinnom", 0.75),
]

_david = [
    *_valleys,
    P("hill", (330, 40), (380, 40), (380, 260), (330, 260), (318, 150)),
    T(356, 120, "Olivová", 0.75), T(356, 132, "hora", 0.75),
    P("court", (202, 205), (256, 198), (262, 262), (246, 330), (222, 344),
      (205, 280)),
    L("wall", (202, 205), (256, 198), (262, 262), (246, 330), (222, 344),
      (205, 280), (202, 205)),
    P("court", (200, 62), (276, 56), (268, 198), (204, 205)),
    L("wall", (200, 62), (276, 56), (268, 198), (204, 205), (200, 62)),
    R(224, 86, 28, 16, "holy"),               # chrám
    R(222, 148, 34, 22, "building"),          # palác
    C(272, 252, 6, "water"),                  # Gichón
    C(222, 336, 5, "water"),                  # Šíloach
    C(214, 364, 4, "water"),                  # En-rogel
    T(232, 270, "Město", 0.75), T(232, 282, "Davidovo", 0.75),
    NORTH(40, 360),
]

_neh = [
    *[v for v in _valleys if v.get("t") != "Tyropoion"],
    P("court", (198, 60), (282, 54), (270, 200), (262, 262), (246, 330),
      (220, 346), (180, 300), (150, 210), (170, 120)),
    L("wall", (198, 60), (282, 54), (270, 200), (262, 262), (246, 330),
      (220, 346), (180, 300), (150, 210), (170, 120), (198, 60)),
    R(226, 92, 26, 16, "holy"),
    C(214, 340, 6, "water"),
    T(214, 160, "město", 0.8),
    NORTH(40, 360),
]

_jesus = [
    *_valleys,
    P("hill", (330, 40), (380, 40), (380, 260), (330, 260), (318, 150)),
    T(356, 70, "Olivová", 0.75), T(356, 82, "hora", 0.75),
    P("court", (72, 128), (150, 120), (160, 70), (232, 74), (300, 72),
      (300, 186), (270, 220), (260, 262), (244, 330), (214, 348),
      (130, 330), (82, 262)),
    L("wall", (72, 128), (232, 132)),         # první hradba (sever)
    L("wall", (150, 120), (160, 70), (232, 74)),  # druhá hradba
    L("wall", (72, 128), (82, 262), (130, 330), (214, 348), (244, 330),
      (260, 262), (270, 220), (300, 186), (300, 72), (232, 74)),
    R(228, 84, 66, 96, "court"), R(250, 112, 18, 26, "holy"),  # chrám
    R(222, 70, 24, 18, "building"),           # Antonia
    R(246, 46, 26, 12, "water"),              # Bethesda
    R(76, 132, 30, 22, "building"),           # Herodův palác
    C(222, 336, 6, "water"),                  # Siloe
    C(124, 94, 6, "hill"),                    # Golgota
    T(130, 220, "Horní město", 0.75), T(220, 250, "Dolní", 0.75),
    T(220, 262, "město", 0.75),
    NORTH(40, 360),
]

# --- Izraelský dům -------------------------------------------------------------
_house = [
    R(30, 30, 240, 180, "building"),
    R(40, 40, 220, 42, "court"),              # zadní místnost
    R(40, 92, 54, 108, "court"),              # stáj (vlevo)
    R(206, 92, 54, 108, "court"),             # zásoby (vpravo)
    R(104, 92, 92, 108, "ground"),            # nádvoří
    *[C(99, 104 + 22 * i, 3, "building") for i in range(5)],
    *[C(201, 104 + 22 * i, 3, "building") for i in range(5)],
    C(130, 120, 9, "holy"),                   # pec
    *[L("furniture", (172, 110 + 8 * i), (194, 110 + 8 * i)) for i in range(7)],
    L("ground", (138, 210), (162, 210)),      # dveře (mezera)
    R(136, 206, 28, 8, "ground"),
    T(150, 60, "zadní místnost", 0.8),
    SCALE(30, 226, 45, "asi 5 m"),
]

# --- Noemova archa (bokorys) -------------------------------------------------
# 300 × 30 loket, tři patra, dveře z boku, okno pod střechou (Gn 6,15-16).
_ark = [
    R(20, 60, 360, 36, "building"),
    L("furniture", (20, 72), (380, 72)), L("furniture", (20, 84), (380, 84)),
    R(160, 84, 10, 12, "ground"),             # dveře
    R(20, 56, 360, 4, "holy"),                # okno pod střechou
    T(260, 110, "300 loket ≈ 135 m", 0.9),
    L("furniture", (386, 60), (386, 96)), T(362, 110, "30 loket", 0.75),
    # pro srovnání: člověk a dům
    L("furniture", (40, 150), (40, 143)), C(40, 141, 1.5, "furniture"),
    T(60, 146, "člověk", 0.7),
    R(90, 136, 30, 14, "court"), T(130, 160, "dům", 0.7),
    L("furniture", (20, 150), (380, 150)),
]


def part(n, x, y, name, text, refs):
    return {"n": n, "x": x, "y": y, "name": name, "text": text, "refs": refs}


PLANS = [
    {
        "id": "svatostanek", "group": "Stavby",
        "title": "Svatostánek",
        "subtitle": "Stan setkávání na poušti (Ex 25–40)",
        "intro": "Přenosná svatyně, kterou Izrael postavil pod Sínajem podle "
                 "vzoru, jenž Bůh ukázal Mojžíšovi. Stála uprostřed tábora: "
                 "Bůh chtěl bydlet uprostřed svého lidu. Rozměry jsou "
                 "z biblického popisu, vchod je na východě (vpravo).",
        "refs": ["Ex 25,8-9", "Ex 40,34-38", "Žd 9,1-12"],
        "chapters": ["Ex 25", "Ex 26", "Ex 27", "Ex 30", "Ex 35", "Ex 36",
                     "Ex 37", "Ex 38", "Ex 39", "Ex 40", "Nu 3", "Nu 4",
                     "Žd 8", "Žd 9"],
        "w": 400, "h": 235, "shapes": _tab,
        "parts": [
            part(1, 392, 115, "Brána",
                 "Jediný vchod do nádvoří, široký 20 loket, zakrytý pestře "
                 "tkanou zástěnou. Ježíš o sobě řekl: Já jsem dveře.",
                 ["Ex 27,16", "J 10,9"]),
            part(2, 300, 96, "Oltář pro zápalné oběti",
                 "Bronzový oltář 5 × 5 loket hned za vchodem. Kdo přicházel "
                 "k Bohu, začínal obětí za hřích.",
                 ["Ex 27,1-8", "Lv 1,3-9", "Žd 10,10-12"]),
            part(3, 240, 98, "Umyvadlo",
                 "Bronzová nádrž mezi oltářem a stanem. Kněží si v ní myli "
                 "ruce a nohy, než vešli do svatyně.",
                 ["Ex 30,17-21", "J 13,8-10"]),
            part(4, 150, 88, "Svatyně",
                 "První místnost stanu (20 × 10 loket). Vcházeli do ní "
                 "kněží denně při službě.",
                 ["Ex 26,33", "Žd 9,2.6"]),
            part(5, 126, 92, "Stůl s předkladnými chleby",
                 "Na severní straně svatyně; dvanáct chlebů za dvanáct kmenů "
                 "stále před Hospodinem.",
                 ["Ex 25,23-30", "Lv 24,5-9", "J 6,35"]),
            part(6, 138, 126, "Svícen",
                 "Sedmiramenný zlatý svícen na jižní straně – jediné světlo "
                 "ve svatyni.",
                 ["Ex 25,31-40", "J 8,12"]),
            part(7, 103, 142, "Kadidlový oltář",
                 "Malý zlatý oltář před oponou. Vůně kadidla je obrazem "
                 "modliteb.",
                 ["Ex 30,1-10", "Ž 141,2", "Zj 8,3-4"]),
            part(8, 92, 88, "Opona",
                 "Oddělovala svatyni od velesvatyně. Při Ježíšově smrti se "
                 "opona v chrámu roztrhla – cesta k Bohu je otevřená.",
                 ["Ex 26,31-33", "Mt 27,51", "Žd 10,19-22"]),
            part(9, 74, 142, "Velesvatyně a truhla smlouvy",
                 "Krychle 10 × 10 × 10 loket. V ní truhla s deskami smlouvy "
                 "a slitovnice; velekněz sem vstupoval jen jednou za rok.",
                 ["Ex 25,10-22", "Lv 16,2.14-15", "Žd 9,3-7"]),
            part(10, 20, 115, "Ohrada nádvoří",
                 "Plátěné zástěny na sloupech, 100 × 50 loket (asi 45 × 22 m), "
                 "vysoké 5 loket.",
                 ["Ex 27,9-18"]),
        ],
    },
    {
        "id": "tabor", "group": "Stavby",
        "title": "Tábor Izraele",
        "subtitle": "Rozložení kmenů kolem svatostánku (Nu 2–3)",
        "intro": "Na poušti tábořil Izrael v pevném pořádku: uprostřed "
                 "svatostánek, kolem něj Lévijci a na každé světové straně "
                 "tři kmeny pod korouhví vedoucího kmene. Východ je vpravo.",
        "refs": ["Nu 2,1-2", "Nu 2,34"],
        "chapters": ["Nu 1", "Nu 2", "Nu 3", "Nu 10"],
        "w": 400, "h": 290, "shapes": _camp_shapes,
        "parts": [
            part(1, 184, 128, "Svatostánek uprostřed",
                 "Bůh bydlí uprostřed svého lidu – všechny kmeny se dívají "
                 "ke stanu setkávání.",
                 ["Nu 2,2", "Ex 25,8", "Zj 21,3"]),
            part(2, 330, 132, "Východ: Juda, Isachar, Zabulon",
                 "Judův tábor (186 400 mužů) stál před vchodem a při "
                 "pochodu vyrážel první.",
                 ["Nu 2,3-9", "Nu 10,14"]),
            part(3, 200, 284, "Jih: Rúben, Šimeon, Gád",
                 "Rúbenův tábor (151 450 mužů) táhl jako druhý.",
                 ["Nu 2,10-16"]),
            part(4, 70, 132, "Západ: Efrajim, Manases, Benjamín",
                 "Synové Ráchel pod korouhví Efrajima (108 100 mužů).",
                 ["Nu 2,18-24"]),
            part(5, 200, 36, "Sever: Dan, Ašer, Neftalí",
                 "Danův tábor (157 600 mužů) uzavíral pochod.",
                 ["Nu 2,25-31", "Nu 10,25"]),
            part(6, 141, 114, "Lévijci kolem stanu",
                 "Geršonovci na západě, Kehatovci na jihu, Meraríovci na "
                 "severu – strážili svatostánek a nesli jeho části.",
                 ["Nu 1,50-53", "Nu 3,23-37"]),
            part(7, 276, 128, "Mojžíš a Áron",
                 "Před vchodem na východě tábořili Mojžíš, Áron a jeho "
                 "synové.",
                 ["Nu 3,38"]),
        ],
    },
    {
        "id": "salomounuv-chram", "group": "Stavby",
        "title": "Šalomounův chrám",
        "subtitle": "První chrám v Jeruzalémě (1Kr 6–7)",
        "intro": "Šalomoun postavil chrám na hoře Mória podle vzoru "
                 "svatostánku, jen dvakrát větší a z kamene, cedru a zlata. "
                 "Stavba trvala sedm let. Vchod je na východě (vpravo).",
        "refs": ["1Kr 6,1-2", "1Kr 8,10-13", "2Pa 3,1"],
        "chapters": ["1Kr 5", "1Kr 6", "1Kr 7", "1Kr 8", "2Pa 2", "2Pa 3",
                     "2Pa 4", "2Pa 5"],
        "w": 400, "h": 262, "shapes": _sol,
        "parts": [
            part(1, 90, 92, "Velesvatyně",
                 "Krychle 20 × 20 × 20 loket obložená zlatem. Sem byla "
                 "přenesena truhla smlouvy.",
                 ["1Kr 6,16.19-20", "1Kr 8,6"]),
            part(2, 90, 168, "Cherubové",
                 "Dva cheruby z olivového dřeva, vysoké 10 loket; jejich "
                 "křídla se dotýkala obou stěn i sebe navzájem nad truhlou.",
                 ["1Kr 6,23-28", "1Kr 8,7"]),
            part(3, 180, 92, "Svatyně",
                 "Hlavní síň dlouhá 40 loket, obložená cedrem s řezbami "
                 "tykví a květů.",
                 ["1Kr 6,17-18"]),
            part(4, 130, 168, "Zlatý oltář, svícny a stoly",
                 "Kadidlový oltář před velesvatyní, deset svícnů (pět "
                 "vpravo, pět vlevo) a stoly na předkladné chleby.",
                 ["1Kr 7,48-50", "2Pa 4,7-8"]),
            part(5, 255, 92, "Předsíň",
                 "Vstupní síň 20 loket široká a 10 hluboká.",
                 ["1Kr 6,3"]),
            part(6, 290, 130, "Sloupy Jakin a Boaz",
                 "Dva bronzové sloupy před vchodem: Jakin („upevní“) na "
                 "jihu, Boaz („v něm je síla“) na severu.",
                 ["1Kr 7,15-22"]),
            part(7, 330, 92, "Bronzový oltář",
                 "Velký oltář 20 × 20 loket pro zápalné oběti.",
                 ["2Pa 4,1", "1Kr 8,64"]),
            part(8, 326, 212, "Bronzové moře",
                 "Litá nádrž o průměru 10 loket na dvanácti bronzových "
                 "býcích, pro omývání kněží.",
                 ["1Kr 7,23-26.39", "2Pa 4,6"]),
            part(9, 70, 222, "Deset nádrží na podstavcích",
                 "Pojízdné bronzové nádrže, pět na jižní a pět na severní "
                 "straně domu.",
                 ["1Kr 7,27-39"]),
            part(10, 52, 130, "Postranní komory",
                 "Tři patra komor kolem domu – sklady chrámových pokladů.",
                 ["1Kr 6,5-10"]),
        ],
    },
    {
        "id": "heroduv-chram", "group": "Stavby",
        "title": "Chrám v době Ježíše",
        "subtitle": "Herodem přestavěný druhý chrám",
        "intro": "Druhý chrám, postavený po návratu z Babylóna, Herodes "
                 "Veliký velkolepě rozšířil. Sem chodil Ježíš i apoštolové. "
                 "Plán je schematický podle archeologických rekonstrukcí.",
        "refs": ["J 2,19-21", "Mk 13,1-2", "L 21,5-6"],
        "chapters": ["Mt 21", "Mt 24", "Mk 11", "Mk 12", "Mk 13", "L 1",
                     "L 2", "L 19", "L 21", "J 2", "J 7", "J 8", "J 10",
                     "Sk 2", "Sk 3", "Sk 4", "Sk 5", "Sk 21", "Sk 22"],
        "w": 400, "h": 300, "shapes": _her,
        "parts": [
            part(1, 160, 252, "Nádvoří pohanů",
                 "Rozlehlé nádvoří přístupné všem národům. Tady Ježíš "
                 "vyhnal penězoměnce: můj dům bude domem modlitby pro "
                 "všechny národy.",
                 ["Mk 11,15-17", "J 2,13-16"]),
            part(2, 309, 150, "Šalomounovo sloupořadí",
                 "Krytá kolonáda podél východní hradby. Ježíš tu učil "
                 "v zimě, první církev se tu scházela.",
                 ["J 10,22-23", "Sk 3,11", "Sk 5,12"]),
            part(3, 118, 92, "Zábradlí s výstrahou",
                 "Nízká přepážka s nápisy, že pohan nesmí jít dál pod trestem "
                 "smrti. Pavel píše, že Kristus tuto zeď zbořil.",
                 ["Sk 21,28-29", "Ef 2,14"]),
            part(4, 232, 140, "Nádvoří žen a pokladnice",
                 "Sem směli i ženy. U pokladnice Ježíš viděl vdovu dávat "
                 "dvě drobné mince.",
                 ["Mk 12,41-44", "J 8,20"]),
            part(5, 262, 140, "Krásná brána",
                 "Podle většiny výkladů východní brána nádvoří žen; tady "
                 "Petr uzdravil chromého.",
                 ["Sk 3,2-8"]),
            part(6, 191, 160, "Oltář a nádvoří kněží",
                 "Před svatyní stál oltář pro oběti. Zachariáš tu sloužil, "
                 "když mu anděl ohlásil narození Jana.",
                 ["L 1,8-11"]),
            part(7, 155, 140, "Svatyně",
                 "Vlastní chrámová budova s oponou před velesvatyní, která "
                 "se při Ježíšově smrti roztrhla.",
                 ["Mt 27,51", "L 2,27-32"]),
            part(8, 84, 35, "Pevnost Antonia",
                 "Římská posádka nad chrámem. Odtud vojáci zachránili Pavla "
                 "před davem.",
                 ["Sk 21,31-37"]),
            part(9, 320, 285, "Vrchol chrámu",
                 "Nejvyšší místo hradby nad údolím – podle tradice jihovýchodní "
                 "roh, kam ďábel postavil Ježíše při pokušení.",
                 ["Mt 4,5-7"]),
        ],
    },
    {
        "id": "jeruzalem-david", "group": "Jeruzalém",
        "title": "Jeruzalém Davida a Šalomouna",
        "subtitle": "Město Davidovo a chrámová hora",
        "intro": "David dobyl jebúsejskou pevnost Sijón na úzkém hřbetu nad "
                 "pramenem Gichón. Šalomoun město rozšířil k severu a "
                 "postavil chrám a palác. Plán je schematický.",
        "refs": ["2S 5,6-10", "1Kr 3,1", "Ž 48,2-3"],
        "chapters": ["2S 5", "2S 6", "2S 15", "2S 24", "1Kr 1", "1Kr 3",
                     "1Kr 9", "1Pa 11", "1Pa 21", "Ž 48", "Ž 122", "Ž 125"],
        "w": 400, "h": 380, "shapes": _david,
        "parts": [
            part(1, 238, 300, "Město Davidovo (Sijón)",
                 "Jebúsejská pevnost, kterou dobyli Davidovi muži a David "
                 "z ní učinil hlavní město.",
                 ["2S 5,6-9", "1Pa 11,4-8"]),
            part(2, 286, 252, "Pramen Gichón",
                 "Hlavní pramen města. U něj byl Šalomoun pomazán za krále; "
                 "Ezechiáš později jeho vodu svedl tunelem do města.",
                 ["1Kr 1,33-39", "2Pa 32,30"]),
            part(3, 238, 76, "Chrám na hoře Mória",
                 "Šalomoun stavěl chrám na místě, které David koupil od "
                 "Ornana; tradičně spojováno s horou, kde Abraham obětoval "
                 "Izáka.",
                 ["2Pa 3,1", "2S 24,18-25", "Gn 22,2"]),
            part(4, 239, 140, "Královský palác",
                 "Šalomounův palác s Libanonským lesním domem a síní trůnu "
                 "se stavěl třináct let.",
                 ["1Kr 7,1-12"]),
            part(5, 304, 196, "Údolí Kidron",
                 "Údolí mezi městem a Olivovou horou. David jím utíkal "
                 "před Abšalómem.",
                 ["2S 15,23.30"]),
            part(6, 94, 330, "Údolí Hinnom",
                 "Údolí na západě a jihu; později místo pohanských obětí, "
                 "podle něj se jmenuje gehenna.",
                 ["Joz 15,8", "Jr 7,31"]),
            part(7, 222, 370, "En-rogel",
                 "Pramen pod městem, kde se Adonijáš dal provolat králem.",
                 ["1Kr 1,9"]),
            part(8, 226, 352, "Šíloach",
                 "Pokojně tekoucí voda u jižního konce města.",
                 ["Iz 8,6", "Neh 3,15"]),
        ],
    },
    {
        "id": "jeruzalem-nehemjas", "group": "Jeruzalém",
        "title": "Jeruzalém za Nehemjáše",
        "subtitle": "Obnovené hradby a brány (Neh 3)",
        "intro": "Po návratu z Babylóna obnovil Nehemjáš s lidem hradby za "
                 "52 dní. Kapitola 3 jde kolem města proti směru hodinových "
                 "ručiček od Ovčí brány. Polohy bran jsou přibližné.",
        "refs": ["Neh 2,11-18", "Neh 6,15-16", "Neh 12,27-43"],
        "chapters": ["Neh 1", "Neh 2", "Neh 3", "Neh 4", "Neh 6", "Neh 12",
                     "Ezd 3", "Ezd 6"],
        "w": 400, "h": 380, "shapes": _neh,
        "parts": [
            part(1, 268, 58, "Ovčí brána",
                 "Začátek obnovy – stavěl ji velekněz Eljašíb s kněžími.",
                 ["Neh 3,1", "J 5,2"]),
            part(2, 236, 52, "Věže Mea a Chananeel",
                 "Věže na severní hradbě u chrámu.",
                 ["Neh 3,1", "Jr 31,38"]),
            part(3, 194, 66, "Rybí brána",
                 "Brána, kudy přicházeli tyrští obchodníci s rybami.",
                 ["Neh 3,3", "Neh 13,16"]),
            part(4, 172, 120, "Stará brána",
                 "Brána na severozápadě města.",
                 ["Neh 3,6", "Neh 12,39"]),
            part(5, 150, 206, "Údolní brána",
                 "Odtud vyjel Nehemjáš v noci prohlížet zbořené hradby.",
                 ["Neh 2,13-15", "Neh 3,13"]),
            part(6, 214, 350, "Hnojná brána",
                 "Brána na jižním konci k údolí Hinnom.",
                 ["Neh 3,14", "Neh 12,31"]),
            part(7, 230, 324, "Pramenná brána a rybník Šelach",
                 "U královské zahrady a schodů z Města Davidova.",
                 ["Neh 3,15", "Neh 12,37"]),
            part(8, 264, 250, "Vodní brána",
                 "Na náměstí před ní četl Ezdráš lidu Zákon.",
                 ["Neh 3,26", "Neh 8,1-3"]),
            part(9, 272, 196, "Koňská brána",
                 "Na východní hradbě u chrámu.",
                 ["Neh 3,28", "Jr 31,40"]),
            part(10, 280, 120, "Východní brána a brána Mifkad",
                 "Brány při chrámu na východní straně.",
                 ["Neh 3,29-31"]),
            part(11, 239, 100, "Chrám",
                 "Druhý chrám, dostavěný za Zerubábela.",
                 ["Ezd 6,14-16"]),
        ],
    },
    {
        "id": "jeruzalem-jezis", "group": "Jeruzalém",
        "title": "Jeruzalém v době Ježíše",
        "subtitle": "Místa Ježíšových posledních dnů",
        "intro": "Město s Herodovým chrámem, dvěma pahorky a hradbami. "
                 "Plán je schematický; u některých míst (Golgota, palác, "
                 "večeřadlo) se poloha určuje podle tradice a bádání.",
        "refs": ["L 19,41-44", "Mt 23,37"],
        "chapters": ["Mt 21", "Mt 26", "Mt 27", "Mt 28", "Mk 11", "Mk 14",
                     "Mk 15", "Mk 16", "L 19", "L 22", "L 23", "L 24",
                     "J 5", "J 9", "J 12", "J 18", "J 19", "J 20", "Sk 1"],
        "w": 400, "h": 380, "shapes": _jesus,
        "parts": [
            part(1, 260, 160, "Chrám",
                 "Herodův chrám na severovýchodě města.",
                 ["J 2,13-21", "Mk 11,15-17"]),
            part(2, 232, 64, "Pevnost Antonia",
                 "Římská posádka u chrámu.",
                 ["Sk 21,34-37"]),
            part(3, 260, 38, "Rybník Bethesda",
                 "Rybník s pěti sloupořadími u Ovčí brány, kde Ježíš "
                 "uzdravil muže nemocného 38 let.",
                 ["J 5,2-9"]),
            part(4, 236, 340, "Rybník Siloe",
                 "Sem Ježíš poslal slepého od narození, aby se umyl.",
                 ["J 9,6-7"]),
            part(5, 124, 82, "Golgota",
                 "Místo ukřižování „blízko města“, za tehdejší hradbou.",
                 ["J 19,17-20", "Žd 13,12"]),
            part(6, 110, 106, "Hrob v zahradě",
                 "Nový hrob v zahradě nedaleko Golgoty.",
                 ["J 19,41-42", "J 20,1"]),
            part(7, 90, 166, "Herodův palác",
                 "Sídlo, kde při svátcích pobýval Pilát – možné místo "
                 "Ježíšova soudu (jinak Antonia).",
                 ["Mk 15,16", "J 18,28"]),
            part(8, 340, 126, "Getsemane",
                 "Zahrada za potokem Kidron na úpatí Olivové hory.",
                 ["J 18,1", "Mt 26,36-46"]),
            part(9, 356, 94, "Olivová hora",
                 "Odtud vjížděl Ježíš do města a odtud vystoupil na nebe.",
                 ["L 19,37-41", "Sk 1,9-12"]),
            part(10, 124, 268, "Horní město",
                 "Čtvrť bohatých; tradičně zde večeřadlo a dům Kaifáše.",
                 ["Mk 14,13-16", "J 18,24"]),
            part(11, 90, 318, "Údolí Hinnom (gehenna)",
                 "Údolí, podle něhož Ježíš pojmenoval místo soudu.",
                 ["Mt 5,22", "Mk 9,43"]),
        ],
    },
    {
        "id": "dum", "group": "Stavby",
        "title": "Izraelský dům",
        "subtitle": "Běžný dům biblických časů",
        "intro": "Typický dům se čtyřmi prostorami: nádvoří uprostřed, po "
                 "stranách stáje a zásoby oddělené sloupy, vzadu obytná "
                 "místnost a nahoře plochá střecha. Mnoho příběhů se odehrává "
                 "právě v něm.",
        "refs": ["Dt 22,8", "Mk 2,1-4"],
        "chapters": ["Joz 2", "1S 28", "2Kr 4", "Mk 2", "L 5", "L 11",
                     "L 15", "Sk 10"],
        "w": 300, "h": 240, "shapes": _house,
        "parts": [
            part(1, 150, 175, "Nádvoří",
                 "Pod širým nebem se vařilo, peklo a pracovalo.",
                 ["2S 17,18", "L 22,55"]),
            part(2, 130, 140, "Pec",
                 "Hliněná pec na chléb; topilo se i trávou a suchým "
                 "býlím.",
                 ["Mt 6,30", "Lv 26,26"]),
            part(3, 67, 146, "Stáj",
                 "Zvířata byla na noc v domě. Odtud „vykrmené tele“.",
                 ["1S 28,24", "L 13,15", "L 15,23"]),
            part(4, 233, 128, "Zásoby",
                 "Džbány s obilím, olejem a vínem.",
                 ["1Kr 17,12-16", "L 12,18"]),
            part(5, 183, 102, "Schody na střechu",
                 "Na rovnou střechu se chodilo sušit len, modlit se i spát.",
                 ["Joz 2,6", "Sk 10,9"]),
            part(6, 70, 60, "Zadní místnost",
                 "Celá rodina spala spolu – proto soused o půlnoci "
                 "nechtěl vstávat.",
                 ["L 11,5-7"]),
            part(7, 280, 40, "Střecha se zábradlím",
                 "Zákon žádal zábradlí, aby nikdo nespadl. Přátelé "
                 "ochrnutého rozkryli střechu a spustili ho k Ježíši.",
                 ["Dt 22,8", "Mk 2,3-4"]),
            part(8, 150, 222, "Dveře",
                 "Na noc se zavíraly na závoru.",
                 ["L 11,7", "Zj 3,20"]),
        ],
    },
    {
        "id": "archa", "group": "Stavby",
        "title": "Noemova archa",
        "subtitle": "Rozměry podle Gn 6 (bokorys)",
        "intro": "Archa byla dlouhá 300 loket, široká 50 a vysoká 30 "
                 "(asi 135 × 22 × 13 m), se třemi patry, dveřmi z boku "
                 "a oknem pod střechou. Pro srovnání je dole člověk a dům.",
        "refs": ["Gn 6,13-22", "Žd 11,7", "1Pt 3,20"],
        "chapters": ["Gn 6", "Gn 7", "Gn 8"],
        "w": 400, "h": 175, "shapes": _ark,
        "parts": [
            part(1, 30, 78, "Tři patra",
                 "Dolní, druhé a třetí patro s přihrádkami, natřené "
                 "smolou uvnitř i zvenčí.",
                 ["Gn 6,14.16"]),
            part(2, 165, 104, "Dveře z boku",
                 "Do archy se vcházelo dveřmi; Hospodin za Noemem zavřel.",
                 ["Gn 6,16", "Gn 7,16"]),
            part(3, 300, 48, "Okno pod střechou",
                 "Světlík loket pod střechou; oknem později vypustil "
                 "havrana a holubici.",
                 ["Gn 6,16", "Gn 8,6-11"]),
        ],
    },
]


# Jeruzalém jako první skupina.
PLANS.sort(key=lambda p: p["group"] != "Jeruzalém")
