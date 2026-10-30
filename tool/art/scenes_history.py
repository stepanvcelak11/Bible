"""Ilustrace: Jozue – Ester."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import art


# --- Jozue --------------------------------------------------------------------

@art("Joz 2,15", "Rachab spustila zvědy po provaze z okna")
def _():
    return [gr(), wall(110, 230, G, 70, 6), window(170, G - 50, 14, 14), woman(170, -1, "reach", g=G - 44, h=24)[:3],
            rope(176, G - 46, 150, G - 10), man(140, 1, [(150, 170), (160, 175)], g=G, h=42), moon(40, 30, 7),
            [(176, G - 46), (178, G - 30)]]


@art("Joz 3,15", "Kněží nesoucí truhlu vstoupili do Jordánu a voda se zastavila")
def _():
    return [gr(0, 50), gr(190, 240), man(90, 1, [(40, 100), (40, 100)], "walk", h=48), man(150, 1, [(40, 100), (40, 100)], "walk", h=48),
            ark_cov(120, G - 32, 30), waves(40, 70, G - 30), waves(42, 68, G - 22), waves(170, 200, G - 30),
            waves(172, 198, G - 22), crowd(0, 50, G, 34, 3), tree(215, G, 34, "palm")]


@art("Joz 6,20", "Lid mocně zavolal a hradby Jericha se zřítily")
def _():
    out = [gr(), wall(120, 230, G, 40, 4, broken=True), stones(150, G, 3), stones(195, G, 2)]
    out += rotate(tower(215, G - 40, 16, 22), 12, 215, G - 40)
    return out + [man(40, 1, [(110, 120), (100, 110)], "walk"), trumpet(62, G - 42, 18, -25),
                  man(80, 1, [(110, 120), (100, 110)], "walk"), trumpet(102, G - 42, 18, -25)]


@art("Joz 24,15", "Já a můj dům budeme sloužit Hospodinu")
def _():
    return [gr(), house(170, G, 56, 40), man(80, 1, "raise"), woman(105, 1, "pray"), kid(125, 0, h=30),
            kid(138, 0, h=24)]


# --- Soudců -------------------------------------------------------------------

@art("Sd 4,5", "Debora soudila Izraele pod palmou v pohoří Efrajim")
def _():
    return [gr(), tree(80, G, 80, "palm"), woman(105, 1, "bless", "sit", h=52), rock(105, G, 18, 14),
            man(160, -1, "pray"), man(190, -1, "down")]


@art("Sd 6,37", "Gedeon položil na humno vlněné rouno")
def _():
    return [gr(), fleece(150, G, 26), man(90, 1, "raise", "kneel"), moon(200, 30, 7),
            stars([(40, 30), (130, 20), (170, 40), (225, 60)])]


@art("Sd 7,20", "Troubili na rohy, rozbili džbány a drželi pochodně")
def _():
    out = [gr()]
    for x in (50, 120, 190):
        out += man(x, 1, [(150, 170), (90, 120)], "walk", h=50)
        out += torch(x + 10, G - 66, 1)
        out += trumpet(x + 12, G - 34, 14, -30)
    return out + [jar(30, G, 0.6)[1:], stones(90, G, 2)]


@art("Sd 14,6", "Samson roztrhl lva holýma rukama")
def _():
    return [gr(), man(100, 1, [(100, 110), (110, 130)], "walk", h=60), lion(150, G, 1.5, -1)]


@art("Sd 16,29", "Samson se vzepřel o dva prostřední sloupy")
def _():
    return [gr(), pillar(80, G, 70), pillar(160, G, 70), [(60, G - 74), (180, G - 74)],
            man(120, 0, "wide", h=60), stones(40, G, 3), stones(200, G, 2)]


# --- Rút ----------------------------------------------------------------------

@art("Rt 1,16", "Kam ty půjdeš, půjdu i já – tvůj Bůh bude můj Bůh")
def _():
    return [gr(), woman(100, 1, "down", "walk", h=52),
            woman(125, 1, [(70, 90), (10, 5)], "walk", h=48), hills(140, 240, G - 30, 10), woman(30, -1, "cry", h=48)]


@art("Rt 2,3", "Rút sbírala klasy na poli za ženci")
def _():
    return [gr(), field(130, 230, G, 8), woman(70, 1, "reach", "bow", h=50), wheat(60, G, 14, -3),
            man(115, -1, "point", h=54), sun(30, 25, 7)]


# --- 1. Samuelova -------------------------------------------------------------

@art("1S 1,10", "Chana se v hořkosti modlila k Hospodinu a usedavě plakala")
def _():
    return [gr(), pillar(60, G, 60), pillar(180, G, 60), [(40, G - 64), (200, G - 64)],
            woman(115, 1, "pray", "kneel", h=54), man(165, -1, "down", "sit", h=50), seat(163, G, 14, 13)]


@art("1S 3,10", "Mluv, Hospodine, tvůj služebník slyší")
def _():
    return [gr(), youth(80, 1, "pray", "lie", h=50), bed(100, G, 60), lampstand(190, G, 30), rays(150, 20, 5, 30, 90, 160, 5)]


@art("1S 16,13", "Samuel vzal roh s olejem a pomazal Davida")
def _():
    return [gr(), man(95, 1, [(130, 150), (10, 5)], h=58), horn(108, G - 64, 1, 1), youth(140, -1, "pray", "kneel", h=48),
            sheep(195, G, 0.9, -1), man(30, 1), man(55, 1)]


@art("1S 16,23", "David hrál na lyru a Saulovi se ulevilo")
def _():
    return [gr(), king(80, 1, "cry", "sit", h=58), throne(80, G, 44), youth(150, -1, [(40, 100), (30, 90)], "sit", h=48),
            rock(150, G, 16, 13), harp(138, G - 24, 22)]


@art("1S 17,49", "David vložil do praku kámen a zasáhl Pelištejce do čela")
def _():
    out = [gr(), youth(60, 1, [(150, 200), (40, 10)], "walk", h=44), sling(64, G - 60, 1.2)]
    out += man(180, -1, [(60, 100), (20, 10)], h=96)
    return out + [spear(198, G - 4, 100, 10), shield(160, G - 50, 1.4), helmet(183, G - 92, 1.1), circle(150, G - 85, 1.5)]


@art("1S 18,3", "Jónatan uzavřel s Davidem smlouvu, protože ho miloval")
def _():
    return [gr(), youth(105, 1, "give", h=52), youth(140, -1, "give", h=50), sword(125, G - 30, 18, 90),
            tree(40, G, 50), tent(200, G, 34, 22)]


@art("1S 24,5", "David potají uřízl cíp Saulova pláště")
def _():
    return [smooth([(10, G), (20, G - 70), (90, G - 92), (170, G - 92), (230, G - 60), (235, G)]), gr(),
            king(100, -1, "down", "kneel", h=56), youth(165, -1, [(80, 100), (30, 10)], "kneel", h=48), sword(145, G - 30, 14, -60)]


# --- 2. Samuelova -------------------------------------------------------------

@art("2S 6,14", "David tančil před Hospodinem ze všech sil")
def _():
    return [gr(), man(90, 1, [(150, 160), (120, 140)], "walk", h=54), ark_cov(170, G - 20, 30),
            man(155, 1, [(40, 100), (40, 100)], h=44), man(190, 1, [(40, 100), (40, 100)], h=44), harp(40, G, 20)]


@art("2S 9,7", "Mefibóšet bude stále jíst u mého stolu")
def _():
    return [gr(), table(120, G, 80, 14), king(70, 1, "give", "sit", h=56), man(170, -1, "pray", "sit", h=50),
            bread(110, G - 15, 8), cup(130, G - 14), [(200, G - 30), (205, G)], [(210, G - 30), (205, G)]]


@art("2S 12,7", "Nátan řekl Davidovi: Ty jsi ten muž!")
def _():
    return [gr(), king(150, -1, "cry", "sit", h=56), throne(150, G, 44, -1), man(85, 1, "point", h=56),
            sheep(40, G, 0.8)]


# --- 1. Královská -------------------------------------------------------------

@art("1Kr 3,9", "Dej svému služebníku srdce, které umí naslouchat")
def _():
    return [gr(), king(110, 1, "raise", "kneel", h=56), altar(180, G, 22, 14, True), stars([(40, 30), (90, 15), (200, 40)]),
            moon(150, 20, 6)]


@art("1Kr 3,25", "Rozetněte živé dítě vedví – moudrý Šalomounův soud")
def _():
    return [gr(), king(120, 0, "bless", "sit", h=56), throne(120, G, 44, 1), woman(60, 1, "reach", h=48),
            woman(185, -1, "hold", h=48), circle(170, G - 32, 3), sword(212, G - 10, 30, -10)]


@art("1Kr 6,14", "Šalomoun dostavěl Hospodinův dům")
def _():
    return [gr(), temple(120, G, 100, 60), man(30, 1, "carry", h=40), [(18, G - 44), (42, G - 44)],
            man(215, -1, "raise", h=40)]


@art("1Kr 10,1", "Královna ze Šeby přišla vyzkoušet Šalomouna hádankami")
def _():
    return [gr(), king(80, 1, "bless", "sit", h=56), throne(80, G, 44), woman(140, -1, "give", h=54, crown=True),
            camel(200, G, 1.1, -1), jar(118, G, 0.8)]


@art("1Kr 17,6", "Krkavci mu nosili chléb a maso ráno i večer")
def _():
    return [gr(), man(110, 1, "reach", "sit", h=54), rock(110, G, 18, 12), bird(150, 50, 2), bird(185, 40, 1.6),
            smooth([(150, G + 4), (180, G - 2), (230, G + 3)]), tree(40, G, 40)]


@art("1Kr 18,38", "Sestoupil Hospodinův oheň a pohltil oběť")
def _():
    return [gr(), altar(120, G, 34, 20, True), [(120, 0), (115, 30), (124, 50), (118, G - 40)],
            man(70, 1, "raise", h=54), crowd(160, 235, G, 40), stones(105, G + 1, 4)]


@art("1Kr 19,5", "Anděl se ho dotkl a řekl: Vstaň a jez")
def _():
    return [gr(), tree(60, G, 50), man(85, 1, "down", "lie", h=56), angel(170, -1, "give", h=54),
            bread(145, G - 2, 8), jar(130, G, 0.6)]


@art("1Kr 19,12", "Po ohni zaznělo tiché a jemné vanutí")
def _():
    return [smooth([(0, G), (10, G - 70), (60, G - 90), (90, G - 60), (95, G)]), gr(),
            man(130, 1, "cry", h=54), smooth([(170, 60), (200, 55), (230, 62)]), smooth([(165, 75), (195, 70), (225, 78)]),
            smooth([(175, 90), (205, 86), (230, 92)])]


# --- 2. Královská -------------------------------------------------------------

@art("2Kr 2,11", "Ohnivý vůz s ohnivými koňmi a Elijáš vystoupil ve vichru do nebe")
def _():
    return [chariot(150, 70, 1.4, 1, True), horse(195, 60, 1.3, 1, True), rotate(cloud(150, 80, 70), 0, 0, 0),
            gr(), man(60, 1, "raise", h=52)]


@art("2Kr 4,6", "Olej tekl, dokud byly nádoby")
def _():
    out = [gr(), woman(70, 1, [(60, 100), (40, 120)], h=52), jar(95, G, 1.2)]
    for i, x in enumerate((130, 150, 170, 195, 215)):
        out += jar(x, G, 0.9 + (i % 2) * 0.2)
    return out + [kid(40, 1, "carry", h=30)]


@art("2Kr 5,14", "Naamán se sedmkrát ponořil do Jordánu a byl čistý")
def _():
    return [sea(30, 210, G - 12, 3), man(120, 0, "raise", g=G - 6, h=54)[:12], gr(0, 40), gr(200, 240),
            reeds(10, 30, G, 3), horse(215, G, 1, -1)]


@art("2Kr 6,17", "Hora byla plná ohnivých koní a vozů kolem Elíši")
def _():
    return [hills(0, 240, G - 30, 26), chariot(60, G - 40, 0.9, 1, True), chariot(170, G - 44, 0.9, -1, True),
            horse(95, G - 36, 0.9), gr(), man(100, 1, "point", h=52), youth(140, -1, "cry", h=46)]


@art("2Kr 25,9", "Babylonští spálili Hospodinův dům i Jeruzalém")
def _():
    return [gr(), city(30, 210, G, 50), flames(70, G - 40, 26), flames(150, G - 46, 30), flames(190, G - 30, 18),
            smooth([(70, G - 70), (60, G - 90), (75, G - 110)]), smooth([(150, G - 80), (160, G - 100), (148, G - 120)])]


@art("2Kr 22,8", "Nalezl jsem v Hospodinově domě knihu zákona")
def _():
    return [gr(), man(90, 1, "hold", h=54), scroll(118, G - 34, 22, 10), king(170, -1, "cry", h=56), pillar(220, G, 60)]


# --- Kroniky ------------------------------------------------------------------

@art("1Pa 4,10", "Jabes volal: Kéž mi opravdu požehnáš a rozšíříš mé území")
def _():
    return [gr(), man(80, 1, "raise", h=56), hills(110, 240, G - 2, 14), field(130, 220, G, 6), sun(200, 25, 7)]


@art("1Pa 15,16", "Zpěváci s harfami, lyrami a cimbály hlasitě zvučeli radostí")
def _():
    return [gr(), man(50, 1, [(40, 100), (30, 90)], h=52), harp(65, G - 18, 22), man(110, 1, [(110, 150), (90, 140)], h=52),
            trumpet(122, G - 52, 18, -40), man(170, -1, [(80, 120), (80, 120)], h=52), circle(158, G - 38, 5),
            circle(182, G - 38, 5), woman(215, -1, "raise", h=48)]


@art("1Pa 29,11", "Tvá, Hospodine, je velikost, moc a sláva")
def _():
    return [gr(), king(120, 0, "raise", h=58), crowd(10, 80, G, 40), crowd(160, 235, G, 40), rays(120, 20, 6, 30, 30, 150, 7)]


@art("2Pa 7,1", "Z nebe sestoupil oheň a dům naplnila Hospodinova sláva")
def _():
    return [gr(), temple(140, G, 90, 50), flames(70, G - 20, 26), altar(70, G, 26, 14), [(70, 0), (65, 30), (74, 50), (70, G - 45)],
            king(30, 1, "raise", "kneel", h=46)]


@art("2Pa 20,21", "Zpěváci šli před vojskem a zpívali: Chvalte Hospodina")
def _():
    return [gr(), man(60, 1, "raise", "walk", h=52), man(90, 1, "raise", "walk", h=50), man(160, 1, "down", "walk", h=50),
            spear(172, G - 30, 50), man(195, 1, "down", "walk", h=50), spear(207, G - 30, 50), shield(150, G - 30, 1)]


@art("2Pa 34,14", "Chilkijáš nalezl knihu Hospodinova zákona")
def _():
    return [gr(), man(100, 1, "hold", "kneel", h=54), scroll(125, G - 30, 22, 10), jar(180, G, 0.8), basket(200, G, 14, 8),
            coins(160, G - 2, 4)]


# --- Ezdráš, Nehemjáš, Ester --------------------------------------------------

@art("Ezd 3,11", "Položili základy Hospodinova domu – jedni jásali, jiní plakali")
def _():
    return [gr(), wall(80, 160, G, 12, 2), man(50, 1, "raise", h=52), man(190, -1, "cry", h=52),
            trumpet(62, G - 52, 16, -60), man(215, -1, "raise", h=48)]


@art("Ezd 7,10", "Ezdráš se upřímně zasadil o zkoumání Hospodinova zákona")
def _():
    return [gr(), man(90, 1, "hold", "sit", h=56), seat(88, G, 16, 15), scroll(124, G - 34, 26, 12), lamp(150, G - 30, 1.2),
            table(140, G, 40, 30)]


@art("Neh 2,13", "Za noci jsem prohlížel pobořené hradby Jeruzaléma")
def _():
    return [gr(), wall(90, 230, G, 30, 3, broken=True), stones(150, G, 3), donkey(55, G, 1.3),
            man(55, 1, "point", "sit", g=G - 14, h=44), moon(200, 20, 7)]


@art("Neh 4,11", "Jednou rukou pracovali a druhou drželi zbraň")
def _():
    return [gr(), wall(110, 230, G, 30, 3), man(70, 1, [(80, 120), (10, 5)], h=56), sword(60, G - 25, 26, 180),
            stones(105, G - 31, 2), man(170, -1, [(130, 160), (40, 20)], g=G - 30, h=46), spear(155, G - 34, 40)]


@art("Neh 8,5", "Ezdráš otevřel knihu před očima všeho lidu a lid povstal")
def _():
    return [gr(), [(80, G - 20), (160, G - 20)], [(85, G - 20), (85, G)], [(155, G - 20), (155, G)],
            man(120, 0, "hold", g=G - 20, h=50), scroll(120, G - 50, 22, 10), crowd(10, 75, G, 34), crowd(165, 235, G, 34)]


@art("Est 2,17", "Král si zamiloval Ester a vložil jí na hlavu královskou korunu")
def _():
    return [gr(), king(90, 1, [(110, 150), (60, 90)], h=58), woman(140, -1, "pray", h=52, crown=True), pillar(30, G, 60),
            pillar(210, G, 60)]


@art("Est 5,2", "Král vztáhl k Ester zlaté žezlo")
def _():
    return [gr(), king(150, -1, [(80, 100), (10, 5)], "sit", h=58), throne(150, G, 44, -1),
            [(133, G - 37), (110, G - 48)], circle(109, G - 49, 2), woman(85, 1, "reach", h=52)]
