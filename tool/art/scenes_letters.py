"""Ilustrace: Římanům – Zjevení."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import art


@art("Ř 5,8", "Bůh prokazuje svou lásku k nám: Kristus zemřel za nás, když jsme byli hříšní")
def _():
    return [smooth([(0, G), (80, G - 16), (160, G - 16), (240, G)]), cross(120, G - 16, 90), rays(120, G - 80, 20, 50, 200, 340, 7),
            man(70, 1, "cry", "kneel", g=G - 10, h=40), heart(180, 40, 8)]


@art("Ř 10,15", "Jak krásné jsou nohy těch, kdo zvěstují dobré věci")
def _():
    return [gr(), man(100, 1, "open", "walk", h=56), path(100, G + 4, 200, G - 30, 30, 3), hills(130, 240, G - 30, 10), sun(210, 20, 7)]


@art("Ř 11,17", "Byl jsi naroubován mezi větve olivy")
def _():
    return [gr(), tree(120, G, 90), smooth([(150, G - 50), (180, G - 60), (200, G - 58)]), [(150, G - 52), (155, G - 47)],
            man(200, -1, "reach", h=50)]


@art("Ř 12,5", "My mnozí jsme jedno tělo v Kristu")
def _():
    return [gr(), man(40, 1, "wide", h=48), woman(80, 0, "wide", h=44), man(120, 0, "wide", h=50), kid(155, 0, "wide", h=30),
            woman(190, -1, "wide", h=46), man(225, -1, "wide", h=48)]


@art("1K 3,6", "Já jsem sázel, Apollos zaléval, ale Bůh dal vzrůst")
def _():
    return [gr(), man(60, 1, "reach", "kneel", h=50), plant(110, G, 22), man(160, -1, [(70, 110), (40, 90)], h=52), jar(136, G - 32, 0.6),
            [(132, G - 34), (120, G - 24)], sun(110, 25, 8), rays(110, 25, 12, 22, 0, 360, 10)]


@art("1K 9,24", "Běžte tak, abyste získali vítěznou cenu")
def _():
    return [gr(), man(60, 1, [(100, 60), (-60, -20)], "walk", h=52, beard=False), man(110, 1, [(110, 60), (-50, -20)], "walk", h=52, beard=False),
            [(200, G), (200, G - 50)], [(200, G - 50), (215, G - 45), (200, G - 40)], crown(160, G - 30, 14)]


@art("1K 11,24", "To čiňte na mou památku")
def _():
    return [table(120, G, 90, 20), bread(100, G - 21, 14), cup(140, G - 20, 1.6), [(100, G - 32), (100, G - 26)], gr()]


@art("1K 13,4", "Láska je trpělivá a laskavá")
def _():
    return [heart(120, 50, 22), gr(), man(80, 1, "give", h=52), woman(160, -1, "give", h=48), kid(120, 0, "raise", h=28)]


@art("2K 4,7", "Ten poklad máme v hliněných nádobách")
def _():
    return [jar(120, G, 4), rays(120, G - 40, 10, 34, 0, 360, 12), gr(60, 180)]


@art("2K 5,17", "Je-li kdo v Kristu, je nové stvoření")
def _():
    return [gr(), stones(60, G, 3), plant(120, G, 30), sun(180, 40, 10), rays(180, 40, 14, 22, 0, 360, 10), flowers(150, 220, G, 3)]


@art("2K 9,7", "Ochotného dárce miluje Bůh")
def _():
    return [gr(), man(90, 1, "give", h=54), basket(130, G, 22, 12, "bread"), woman(170, -1, "reach", h=46), kid(195, -1, "reach", h=28)]


@art("Ga 5,22", "Ovoce Ducha je láska, radost, pokoj")
def _():
    out = [gr(), tree(120, G, 100)]
    for x, y in ((95, 45), (120, 35), (145, 48), (105, 62), (138, 64), (122, 52), (85, 58), (155, 60), (115, 75)):
        out += circle(x, y, 3)
    return out


@art("Ga 6,2", "Neste břemena jedni druhých")
def _():
    return [gr(), man(100, 1, [(150, 200), (150, 200)], "walk", h=54), man(130, 1, [(150, 200), (150, 200)], "walk", h=52),
            [(85, G - 60), (145, G - 58), (145, G - 50), (85, G - 52), (85, G - 60)], path(160, G, 230, G - 30, 20, 3)]


@art("Ef 2,20", "Úhelným kamenem je sám Kristus Ježíš")
def _():
    return [gr(), wall(60, 200, G, 50, 5), [(40, G), (40, G - 16), (60, G - 16)], [(40, G - 16), (52, G - 22), (72, G - 22), (60, G - 16)],
            [(72, G - 22), (72, G - 6), (60, G)]]


@art("Ef 6,11", "Oblečte se do plné výzbroje Boží")
def _():
    return [gr(), man(110, 1, [(30, 90), (10, 5)], h=60, belt=True), helmet(111, G - 58, 1.2), shield(140, G - 30, 1.6),
            sword(80, G - 25, 30, 180), [(102, G - 50), (118, G - 50), (120, G - 30), (100, G - 30), (102, G - 50)]]


@art("Fp 3,14", "Běžím k cíli, k vítězné ceně Božího povolání")
def _():
    return [gr(), man(90, 1, [(110, 60), (-60, -20)], "walk", h=54, beard=False), path(120, G, 220, G - 20, 14, 3),
            [(210, G - 10), (210, G - 60)], [(210, G - 60), (226, G - 55), (210, G - 50)], sun(180, 25, 8)]


@art("Fp 4,6", "S modlitbou a díkůvzdáním předkládejte své žádosti Bohu")
def _():
    return [gr(), woman(100, 1, "pray", "kneel", h=52), rays(160, 20, 6, 40, 90, 160, 6), lamp(60, G, 1.3), flowers(150, 220, G, 4)]


@art("Ko 2,7", "Buďte v něm zakořeněni a budováni")
def _():
    return [tree(120, G, 90), gr(), smooth([(118, G), (105, G + 10), (85, G + 16)]), smooth([(122, G), (135, G + 12), (160, G + 16)]),
            smooth([(120, G), (120, G + 14), (114, G + 22)])]


@art("Ko 3,23", "Cokoli děláte, dělejte z celé duše jako pro Pána")
def _():
    return [gr(), man(90, 1, [(80, 140), (60, 120)], h=54), table(150, G, 60, 22), [(130, G - 22), (170, G - 26)], house(220, G, 30, 26)]


@art("1Te 4,16", "Pán sestoupí z nebe, až zazní Boží polnice")
def _():
    return [cloud(120, 40, 80), rays(120, 40, 24, 50, 30, 150, 7), trumpet(170, 30, 20, -20), gr(), crowd(20, 220, G, 34)]


@art("1Te 5,17", "V modlitbách neustávejte")
def _():
    return [gr(), man(70, 1, "pray", "kneel", h=50), woman(120, 1, "pray", h=48), sun(180, 30, 8), moon(220, 30, 6), house(200, G, 40, 30)]


@art("2Te 3,13", "Neochabujte v konání dobra")
def _():
    return [gr(), man(90, 1, "give", h=54), man(130, -1, "reach", "sit", h=46), rock(130, G, 14, 10), bread(110, G - 32, 7)]


@art("1Tm 4,12", "Ať nikdo nepohrdá tvým mládím – buď příkladem věřícím")
def _():
    return [gr(), youth(120, 0, "open", h=52), crowd(10, 90, G, 36), crowd(150, 235, G, 36)]


@art("2Tm 1,5", "Upřímná víra žila v tvé babičce Loidě a matce Euniké")
def _():
    return [gr(), woman(70, 1, "bless", "sit", h=48), seat(70, G, 14, 13), woman(120, 1, "hold", h=50), scroll(140, G - 30, 16, 8),
            kid(165, -1, "reach", h=30)]


@art("2Tm 4,7", "Dobrý boj jsem bojoval, běh jsem dokonal, víru zachoval")
def _():
    return [gr(), man(100, 1, "raise", h=54), crown(160, 40, 18), rays(160, 34, 14, 26, 0, 360, 10), path(10, G, 80, G - 6, 10, 4)]


@art("Tt 2,7", "Ve všem se dávej za příklad dobrého jednání")
def _():
    return [gr(), man(100, 1, "bless", h=56), youth(140, -1, "pray", h=48), boat(210, G + 4, 40), sea(170, 240, G + 6, 1)]


@art("Fm 1,16", "Už ne jako otroka, ale jako milovaného bratra")
def _():
    return [gr(), man(100, 1, "wide", h=54), man(130, -1, "wide", h=52, beard=False), chain(170, G - 2, 200, G, 4), house(40, G, 40, 30)]


@art("Žd 6,19", "Naděje je kotvou duše, pevnou a jistou")
def _():
    return [anchor(120, 80, 3), rope(120, 38, 120, 20), sea(0, 240, 40, 2), smooth([(20, G), (120, G + 4), (220, G)])]


@art("Žd 11,8", "Vírou poslechl Abraham a vydal se na cestu, aniž věděl, kam jde")
def _():
    return [gr(), man(80, 1, "point", "walk", staff=1, h=56), path(110, G, 200, G - 40, 20, 3), stars([(150, 20), (180, 30), (210, 15), (130, 40)]),
            tent(30, G, 30, 18)]


@art("Žd 12,1", "Obklopeni oblakem svědků běžme vytrvale závod")
def _():
    return [cloud(70, 30, 60), cloud(170, 30, 60), crowd(20, 220, 50, 20), gr(), man(120, 1, [(110, 60), (-60, -20)], "walk", h=52, beard=False)]


@art("Jk 1,22", "Buďte činiteli slova, ne pouze posluchači")
def _():
    return [gr(), man(80, 1, "hold", h=54), mirror(110, G - 40, 1.4), man(160, -1, "give", h=52), bread(140, G - 30, 7)]


@art("Jk 3,4", "Lodi řídí nepatrné kormidlo, kam chce kormidelník")
def _():
    return [boat(120, G - 6, 120, True), sea(0, 240, G, 3), man(70, 1, [(80, 100), (60, 80)], g=G - 26, h=40), [(52, G - 26), (40, G)]]


@art("1Pt 2,5", "Jako živé kameny se budujte v duchovní dům")
def _():
    return [gr(), wall(60, 180, G, 40, 4), man(40, 1, "carry", h=50), [(28, G - 54), (52, G - 54), (52, G - 48), (28, G - 48), (28, G - 54)],
            man(205, -1, "point", h=50)]


@art("1Pt 5,7", "Všechny své starosti vložte na něho, neboť mu na vás záleží")
def _():
    return [gr(), man(100, 1, [(150, 170), (150, 170)], h=54), [(85, G - 70), (115, G - 70), (115, G - 60), (85, G - 60), (85, G - 70)],
            hand(160, 50, 1.6, False), rays(160, 30, 6, 16, 180, 360, 5)]


@art("1Pt 5,8", "Váš protivník obchází jako řvoucí lev")
def _():
    return [gr(), lion(140, G, 2, -1), sheep(60, G, 1, 1), man(30, 1, "bless", staff=1, h=52), hills(150, 240, G - 2, 10)]


@art("2Pt 1,19", "Prorocké slovo je jako lampa, která svítí na temném místě")
def _():
    return [lamp(110, 100, 3), rays(122, 80, 10, 30, 180, 360, 9), star(190, 30, 7), stars([(40, 20), (80, 40), (220, 60)]),
            smooth([(20, 120), (120, 124), (220, 120)])]


@art("2Pt 3,8", "U Pána je jeden den jako tisíc let")
def _():
    return [hourglass(120, 70, 3), sun(50, 40, 8), moon(190, 40, 8), gr(60, 180, 140)]


@art("1J 4,7", "Milujme se navzájem, protože láska je z Boha")
def _():
    return [gr(), man(70, 1, "wide", h=52), woman(100, -1, "wide", h=46), kid(140, 0, "raise", h=28), woman(180, 1, "give", h=48),
            man(210, -1, "reach", "sit", h=44), heart(120, 30, 10)]


@art("2J 1,6", "Láska znamená, že žijeme podle jeho přikázání")
def _():
    return [gr(), woman(100, 1, "bless", h=50), kid(130, -1, h=30), kid(150, -1, h=26), scroll(60, 60, 30, 14), house(210, G, 40, 30)]


@art("3J 1,8", "Takové lidi máme přijímat, abychom spolupracovali na pravdě")
def _():
    return [gr(), house(80, G, 70, 46), man(130, -1, "wide", h=54), man(180, -1, "down", "walk", staff=0, h=52), path(200, G, 230, G - 20, 12, 3)]


@art("Ju 1,24", "Tomu, který vás může uchránit od pádu, buď sláva")
def _():
    return [mountain(120, G, 200, 70), path(60, G, 120, G - 66, 14, 3), man(100, 1, "down", "walk", g=G - 40, h=30),
            hand(150, G - 30, 1.3, True), sun(210, 20, 8)]


# --- Zjevení ------------------------------------------------------------------

@art("Zj 1,12", "Obrátil jsem se a uviděl sedm zlatých svícnů")
def _():
    out = [gr(), J(120, 0, "open", h=60)]
    for x in (30, 60, 90, 150, 180, 210):
        out += lampstand(x, G, 26)[:2] + flames(x, G - 27, 6)[1:2]
    return out


@art("Zj 3,20", "Hle, stojím u dveří a tluču")
def _():
    return [gr(), house(150, G, 80, 56, door=False), door(150, G, 18, 32), J(100, 1, [(100, 130), (10, 5)], h=60), lamp(30, 40, 1.4),
            vine(160, G - 58, 200, 2)]


@art("Zj 4,2", "Na nebi stál trůn a kolem trůnu duha")
def _():
    return [rainbow(120, G - 20, 70), throne(120, G - 20, 50, 1), rays(120, G - 70, 16, 30, 0, 360, 12), cloud(50, G - 10, 40),
            cloud(190, G - 10, 40), sea(30, 210, G + 4, 1)]


@art("Zj 5,6", "Uprostřed trůnu jsem uviděl Beránka")
def _():
    return [smooth([(40, G), (120, G - 6), (200, G)]), sheep(120, G - 6, 2.2, 1), rays(120, G - 40, 30, 50, 180, 360, 9),
            crowd(10, 70, G, 34), crowd(170, 235, G, 34)]


@art("Zj 7,9", "Veliký zástup ze všech národů s palmovými ratolestmi")
def _():
    out = [gr(), crowd(10, 230, G, 44, 12)]
    for x in (40, 100, 160, 210):
        out += [[(x, G - 30), (x, G - 60)]] + tree(x, G - 48, 14, "palm")[2:]
    return out + [rays(120, 10, 6, 30, 30, 150, 7)]


@art("Zj 12,9", "Veliký drak, ten dávný had, byl svržen")
def _():
    return [dragon(130, 90, 2.2), angel(80, 1, [(110, 150), (10, 5)], 60, 44), sword(110, 40, 30, 60), cloud(190, 20, 40)]


@art("Zj 21,2", "Viděl jsem svaté město, nový Jeruzalém, sestupovat z nebe")
def _():
    return [city(50, 190, 80, 50), rays(120, 40, 50, 70, 0, 360, 14), cloud(60, 90, 50), cloud(180, 90, 50), gr(), man(120, 0, "raise", h=30)]


@art("Zj 21,4", "Setře jim každou slzu z očí a smrti už nebude")
def _():
    return [gr(), J(110, 1, [(70, 140), (60, 150)], h=60), woman(140, -1, "cry", h=48), flowers(170, 230, G, 4), sun(30, 20, 8)]


@art("Zj 22,2", "Uprostřed ulice a z obou stran řeky strom života")
def _():
    out = [smooth([(110, 10), (100, 60), (90, G + 10)]), smooth([(130, 10), (140, 60), (150, G + 10)]), waves(100, 140, 80, 2),
           tree(55, G, 80), tree(195, G, 80), gr(0, 90), gr(150, 240)]
    for x, y in ((40, 50), (60, 40), (70, 60), (180, 45), (200, 38), (210, 60)):
        out += circle(x, y, 2.5)
    return out
