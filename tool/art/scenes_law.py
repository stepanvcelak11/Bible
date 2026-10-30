"""Ilustrace: Genesis – Deuteronomium."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import art


# --- Genesis ------------------------------------------------------------------

@art("Gn 1,1", "Na počátku stvořil Bůh nebe a zemi")
def _():
    return [sun(60, 40, 10), moon(170, 34, 8), stars([(120, 22), (200, 52), (140, 48), (215, 22)]),
            hills(0, 240, G - 2, 14), sea(10, 230, G + 8), tree(30, G - 6, 34), tree(205, G - 4, 40, "palm"),
            bird(110, 70, 1.2), bird(128, 62), fish(80, G + 14, 0.9), fish(160, G + 16, 0.8, -1)]


@art("Gn 2,15", "Bůh dal člověku zahradu, aby ji obdělával a střežil")
def _():
    return [gr(), tree(35, G, 56), tree(210, G, 50), tree(175, G, 34), man(100, 1, "give", beard=False),
            sheep(140, G, 0.9, -1), flowers(50, 90, G, 4), bird(150, 50, 1)]


@art("Gn 3,6", "Žena vzala z ovoce stromu a dala i svému muži")
def _():
    return [gr(), tree(120, G, 70), snake(132, G - 42, 0.9, -1), woman(95, 1, [(120, 140), (20, 10)], veil=False),
            man(160, -1, "give", beard=False), circle(116, G - 61, 2.5), circle(140, G - 55, 2.5)]


@art("Gn 4,4", "Hospodin shlédl na Ábela a jeho oběť")
def _():
    return [gr(), altar(80, G, 22, 14, True, True), altar(165, G, 22, 14, False),
            man(110, -1, "raise", beard=False, h=50), man(195, -1, "down", beard=False, h=52),
            sheep(50, G, 0.9), wheat(150, G, 18), wheat(145, G, 16)]


@art("Gn 7,17", "Potopa trvala čtyřicet dní a archa se nesla nad vodami")
def _():
    return [cloud(60, 30, 40), cloud(170, 26, 46), rain(30, 220, 40, 80, 14), ark(120, G - 6, 100),
            sea(10, 230, G, 3)]


@art("Gn 9,13", "Duha na oblaku – znamení smlouvy")
def _():
    return [rainbow(120, G - 10, 90), mountain(150, G, 90, 40), ark(150, G - 40, 50), gr(),
            man(60, 1, "raise"), woman(80, 1, "pray"), bird(100, 50, 0.8, -1, True)]


@art("Gn 11,4", "Postavme si město a věž až do nebe")
def _():
    return [gr(), tower(120, G, 70, 100), man(50, 1, "carry", beard=False), man(190, -1, "point"),
            [(40, G - 54), (60, G - 54)], cloud(170, 30, 30), stones(215, G)]


@art("Gn 12,4", "Abram se vydal na cestu, jak mu řekl Hospodin")
def _():
    return [gr(), man(80, 1, "point", "walk", staff=1), woman(55, 1, "down", "walk"), camel(140, G, 1.1),
            sheep(185, G, 0.8), sheep(205, G, 0.7), hills(150, 240, G - 2, 10), sun(210, 30, 7)]


@art("Gn 15,5", "Pohleď na nebe a sečti hvězdy – tolik bude tvého potomstva")
def _():
    return [gr(), man(80, 1, "raise", h=50), tent(170, G, 40, 24),
            stars([(40, 20), (70, 35), (100, 15), (130, 30), (160, 12), (190, 32), (220, 18), (115, 50),
                   (150, 55), (55, 58), (205, 60)]), star(130, 32, 4)]


@art("Gn 18,2", "Abraham uviděl tři muže a běžel jim naproti")
def _():
    return [gr(), tree(30, G, 60), tent(70, G, 36, 22), man(110, 1, "pray", "bow"), man(160, -1),
            man(185, -1, beard=False), man(210, -1)]


@art("Gn 22,13", "Abraham uviděl berana zachyceného v houští")
def _():
    return [gr(), altar(100, G, 30, 14), [(90, G - 15), (115, G - 15)], youth(100, -1, "pray", "lie", g=G - 15, h=34),
            man(145, -1, "bless"), bush(200, G, 26), ram(200, G - 6, 0.9, -1), angel(60, 1, "point", G - 50, 30)]


@art("Gn 24,17", "Rebeka dala Abrahamovu služebníku napít ze džbánu")
def _():
    return [gr(), well(110, G, 22), woman(90, 1, "give"), jar(96, G - 38, 0.7), man(140, -1, "reach"),
            camel(195, G, 1.1, -1), tree(30, G, 50, "palm")]


@art("Gn 28,12", "Jákob ve snu uviděl žebřík, po němž vystupovali andělé")
def _():
    return [gr(), man(60, 1, "down", "lie", h=56), rock(55, G, 14, 8), ladder(120, G - 5, 190, 10, 14, 10),
            angel(160, 0, "pray", G - 50, 26), angel(135, 0, "down", G - 20, 22), stars([(40, 30), (90, 15), (225, 40)])]


@art("Gn 32,25", "Jákob zápasil s mužem až do svítání")
def _():
    return [gr(), man(100, 1, [(110, 130), (100, 120)], h=56), man(130, -1, [(100, 125), (95, 115)], h=58),
            sun(30, 120, 8), moon(210, 30, 6), sea(150, 230, G + 8, 1)]


@art("Gn 37,3", "Izrael miloval Josefa a udělal mu pestrobarevnou suknici")
def _():
    return [gr(), man(80, 1, "bless", "sit", h=56), seat(78, G, 16, 15), youth(140, -1, "open", h=50, belt=True),
            [(135, G - 32), (145, G - 30)], [(134, G - 22), (147, G - 20)], [(134, G - 12), (148, G - 10)],
            tent(205, G, 34, 22)]


@art("Gn 41,25", "Josef vykládá faraonovi sny")
def _():
    return [gr(), king(70, 1, "down", "sit", h=58), throne(70, G, 44, 1), youth(130, -1, "point", h=52),
            ox(190, G - 46, 0.7), ox(220, G - 46, 0.7), wheat(185, G, 20), wheat(200, G, 22), wheat(215, G, 19)]


@art("Gn 45,15", "Josef objal své bratry a plakal")
def _():
    return [gr(), man(100, 1, "wide", h=54), man(125, -1, [(80, 100), (60, 90)]), man(160, -1, "cry"),
            man(190, -1, "pray"), man(215, -1)]


# --- Exodus -------------------------------------------------------------------

@art("Ex 2,3", "Matka položila dítě do ošatky v rákosí u břehu Nilu")
def _():
    return [reeds(75, 100, G + 4, 4), reeds(170, 220, G + 4, 5), sea(60, 230, G + 6, 3), basket(135, G + 3, 24, 8), gr(0, 60),
            circle(129, G - 8, 3.2), bez((132, G - 9), (140, G - 12), (144, G - 6)), woman(35, 1, "pray", "kneel")]


@art("Ex 3,2", "Keř hořel ohněm, a přece nebyl spálen")
def _():
    return [gr(), bush(150, G, 34, True), man(85, 1, "cry", "kneel"), sheep(30, G, 0.8), mountain(205, G, 70, 34)]


@art("Ex 12,7", "Krví beránka potřou obě veřeje dveří")
def _():
    return [gr(), house(130, G, 64, 46), man(75, 1, "reach"), sheep(40, G, 0.9),
            [(118, G - 25), (122, G - 30)], [(140, G - 26), (144, G - 30)], moon(200, 25, 7)]


@art("Ex 14,22", "Izraelci šli středem moře po suchu")
def _():
    out = [gr(70, 170)]
    for i in range(5):
        out += waves(5 + i * 3, 70 - i * 2, G - 10 - i * 9)
        out += waves(170 + i * 2, 235 - i * 3, G - 10 - i * 9)
    return out + [man(100, 1, "raise", "walk", staff=0, h=48), woman(125, 1, "down", "walk", h=42),
                  kid(140, 1, h=26), man(155, 1, "down", "walk", h=40)]


@art("Ex 16,14", "Ráno ležela na zemi mana jako jinovatka")
def _():
    out = [gr(), tent(205, G, 34, 22), woman(60, 1, "reach", "kneel"), man(130, 1, "hold", "bow"), basket(95, G, 14, 8)]
    for x, y in ((80, G - 2), (110, G - 1), (150, G - 2), (170, G - 1), (40, G - 1), (175, G - 3)):
        out += circle(x, y, 1)
    return out


@art("Ex 17,6", "Udeř do skály a vyjde z ní voda")
def _():
    return [gr(), rock(160, G, 50, 40), man(105, 1, [(120, 150), (20, 10)], staff=0),
            smooth([(140, G - 20), (130, G - 10), (125, G)]), smooth([(142, G - 18), (136, G - 6), (134, G)]),
            crowd(10, 70, G, 36, 4)]


@art("Ex 17,12", "Áron a Chúr podpírali Mojžíšovy ruce")
def _():
    return [gr(), rock(120, G, 20, 12), man(120, 0, "raise", g=G - 10, h=54), man(95, 1, [(150, 170), (10, 5)], h=48),
            man(146, -1, [(150, 170), (10, 5)], h=48), hills(0, 240, G - 2, 6)]


@art("Ex 20,2", "Já jsem Hospodin, tvůj Bůh – Desatero")
def _():
    return [mountain(120, G, 180, 80), tablets(120, G - 92, 30), rays(120, G - 100, 22, 40, 200, 340, 7),
            cloud(55, 40, 30), cloud(190, 45, 30), gr(), man(60, 1, "raise", h=34), crowd(150, 230, G, 28)]


@art("Ex 32,4", "Áron udělal zlaté tele a lid volal: To je tvůj bůh")
def _():
    return [gr(), altar(120, G, 26, 10), ox(117, G - 10, 1, 1), crowd(10, 80, G, 40), man(175, -1, "raise"),
            woman(205, -1, "raise")]


@art("Ex 40,34", "Oblak přikryl stan setkávání a příbytek naplnila Hospodinova sláva")
def _():
    return [gr(), tent(120, G, 70, 34), cloud(120, 45, 70),
            tent(35, G, 30, 16), tent(205, G, 30, 16)]


# --- Leviticus ----------------------------------------------------------------

@art("Lv 1,3", "Kněz přináší zápalnou oběť před stanem setkávání")
def _():
    return [gr(), altar(120, G, 30, 20, True, True), man(75, 1, "raise", belt=True), sheep(165, G, 0.9, -1),
            man(200, -1, "pray")]


@art("Lv 16,21", "Kozel ponese jejich viny do pustiny")
def _():
    return [gr(), goat(150, G, 1.3, 1), man(80, 1, [(90, 110), (100, 120)], belt=True),
            hills(160, 240, G - 2, 10), sun(210, 30, 7)]


@art("Lv 19,18", "Miluj svého bližního jako sám sebe")
def _():
    return [gr(), man(95, 1, "give"), man(140, -1, "reach", "sit", h=50), rock(140, G, 16, 12),
            bread(117, G - 33, 7)]


@art("Lv 23,42", "Sedm dní budete bydlet v stáncích")
def _():
    return [gr(), [(70, G), (70, G - 40)], [(170, G), (170, G - 40)], smooth([(60, G - 38), (120, G - 46), (180, G - 38)]),
            smooth([(65, G - 42), (90, G - 48), (110, G - 44)]), smooth([(130, G - 44), (155, G - 49), (178, G - 42)]),
            man(100, 1, "bless", "sit", h=50), woman(140, -1, "pray", "sit", h=46), kid(120, 0, "raise", h=22),
            tree(215, G, 40, "palm")]


# --- Numeri -------------------------------------------------------------------

@art("Nu 6,24", "Ať ti Hospodin žehná a chrání tě")
def _():
    return [gr(), man(70, 1, "wide", belt=True), crowd(110, 230, G, 40)]


@art("Nu 13,23", "Zvědové nesli na tyči hrozen z údolí Eškol")
def _():
    return [gr(), man(70, 1, [(140, 170), (150, 175)], "walk"), man(170, 1, [(140, 170), (150, 175)], "walk"),
            [(60, G - 62), (180, G - 62)], grapes(120, G - 55, 2.2)]


@art("Nu 21,9", "Mojžíš udělal měděného hada a připevnil ho na žerď")
def _():
    return [gr(), [(120, G), (120, G - 70)], [(105, G - 62), (135, G - 62)],
            smooth([(120, G - 70), (126, G - 64), (114, G - 56), (126, G - 48), (116, G - 40)]),
            man(70, 1, "raise", h=50), man(170, -1, "raise", "kneel"), woman(200, -1, "pray", "kneel")]


@art("Nu 22,23", "Oslice uviděla Hospodinova anděla s taseným mečem")
def _():
    return [gr(), donkey(110, G, 1.6, 1), man(105, 1, [(80, 100), (10, 5)], "sit", g=G - 16, h=46),
            angel(185, -1, [(120, 160), (10, 5)], h=60), sword(175, G - 70, 30, 30)]


# --- Deuteronomium ------------------------------------------------------------

@art("Dt 6,7", "Budeš o těch slovech mluvit se svými dětmi")
def _():
    return [gr(), man(95, 1, "point", "sit", h=56), seat(93, G, 16, 15), kid(140, -1, "down", "sit", h=34),
            scroll(110, G - 50, 22, 10), house(205, G, 40, 30)]


@art("Dt 30,19", "Předkládám ti život a smrt – vyvol si život")
def _():
    return [gr(), man(120, 1, "open", h=50), path(110, G, 60, 70, 20, 3), path(130, G, 190, 70, 20, 3),
            tree(195, 75, 30), stones(55, 72, 3), sun(200, 25, 6)]


@art("Dt 34,1", "Mojžíš vystoupil na horu Nebó a Hospodin mu ukázal celou zemi")
def _():
    return [smooth([(0, G), (40, G - 40), (80, G - 50), (110, G - 46), (140, G)]), man(80, 1, "point", g=G - 50, staff=1, h=40),
            hills(140, 240, G - 4, 14), tree(180, G - 6, 20, "palm"), tree(200, G - 8, 16, "palm"),
            sea(150, 230, G + 6, 2), sun(220, 20, 6)]
