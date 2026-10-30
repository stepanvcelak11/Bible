"""Ilustrace: evangelia a Skutky."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import art


def disciples(x0, x1, n=3, f=1, arms="down"):
    out = []
    for i in range(n):
        x = x0 + (x1 - x0) * i / max(1, n - 1)
        out += man(x, f, arms, h=50 + (i % 2) * 3, beard=i % 2 == 0)
    return out


# --- Matouš -------------------------------------------------------------------

@art("Mt 1,20", "Anděl se Josefovi zjevil ve snu: Neboj se přijmout Marii")
def _():
    return [gr(), man(70, 1, "down", "lie", h=56), angel(170, -1, "bless", G - 20, 50), stars([(40, 30), (110, 20), (230, 40)]),
            moon(220, 20, 6)]


@art("Mt 2,11", "Mudrci vešli do domu, padli na zem a poklonili se dítěti")
def _():
    return [gr(), woman(60, 1, "hold", "sit", h=52), seat(60, G, 14, 14), circle(80, G - 34, 3.5), star(90, 18, 6),
            rays(90, 18, 9, 26, 50, 130, 5), king(120, -1, "give", "kneel", h=50), king(160, -1, "give", h=54), king(200, -1, "pray", h=56),
            jar(135, G - 30, 0.5)]


@art("Mt 3,16", "Ježíš vystoupil z vody a Duch Boží sestoupil jako holubice")
def _():
    return [sea(20, 220, G - 6, 3), J(110, 0, "pray", g=G - 4, h=58)[:14], man(160, -1, "bless", g=G - 4, h=54)[:14],
            bird(110, 30, 1.4, 1, True), rays(110, 20, 16, 40, 0, 180, 7), reeds(200, 235, G, 3), gr(0, 20)]


@art("Mt 4,3", "Pokušitel přistoupil k Ježíšovi na poušti")
def _():
    return [gr(), J(90, 1, "down", "sit", h=56), rock(90, G, 18, 14), stones(150, G, 4), hills(130, 240, G - 2, 14), sun(210, 25, 9),
            snake(190, G, 0.9, -1)]


@art("Mt 4,19", "Pojďte za mnou a učiním z vás rybáře lidí")
def _():
    return [gr(0, 120), J(70, 1, "bless", h=58), boat(170, G + 2, 70), man(150, -1, "down", g=G - 8, h=40), man(185, -1, "hold", g=G - 8, h=40),
            nets(215, G, 20, 8), sea(110, 240, G + 6, 2)]


@art("Mt 5,1", "Ježíš vystoupil na horu, posadil se a učil")
def _():
    return [smooth([(0, G), (60, G - 40), (120, G - 50), (180, G - 40), (240, G)]), J(120, 0, "open", "sit", g=G - 50, h=50),
            crowd(10, 230, G + 4, 34), flowers(40, 80, G - 30, 3)]


@art("Mt 5,14", "Vy jste světlo světa – město na hoře se nemůže skrýt")
def _():
    return [mountain(120, G, 180, 50), city(80, 160, G - 48, 30), lamp(40, 40, 2), rays(56, 30, 6, 16, 200, 340, 5), gr(),
            moon(210, 25, 7)]


@art("Mt 6,26", "Pohleďte na nebeské ptáky – váš nebeský Otec je živí")
def _():
    return [gr(), bird(60, 40, 2), bird(100, 30, 1.6), bird(150, 50, 1.8), bird(190, 35, 1.4), flowers(20, 120, G, 6), lily(150, G, 16),
            lily(165, G, 14), J(210, -1, "point", h=56)]


@art("Mt 7,24", "Rozvážný muž postavil svůj dům na skále")
def _():
    return [rock(80, G, 100, 30), house(80, G - 28, 50, 34), cloud(190, 25, 50), rain(150, 230, 40, 100, 12),
            sea(130, 240, G + 4, 2)]


@art("Mt 13,3", "Rozsévač vyšel rozsévat")
def _():
    out = [gr(), man(80, 1, [(80, 110), (40, 20)], "walk", h=58), smooth([(10, G + 6), (120, G + 4), (240, G + 7)])]
    for x, y in ((110, 90), (118, 100), (125, 84), (132, 96), (140, 105), (150, 92)):
        out += circle(x, y, 1.1)
    return out + [bird(190, 40, 1.4), plant(180, G, 10), plant(205, G, 14), plant(225, G, 12)]


@art("Mt 13,46", "Kupec našel jednu vzácnou perlu a prodal vše, co měl")
def _():
    return [gr(), man(100, 1, "hold", h=56), pearl(118, G - 34, 5), rays(118, G - 34, 8, 14, 0, 360, 8), basket(170, G, 16, 9),
            coins(200, G - 2, 4)]


@art("Mt 14,29", "Petr vystoupil z lodi a kráčel po vodě k Ježíšovi")
def _():
    return [boat(190, G - 4, 60, True), man(110, 1, "reach", g=G, h=48)[:14], J(60, 1, "reach", g=G - 4, h=56), sea(0, 240, G, 3),
            cloud(110, 20, 40)]


@art("Mt 18,12", "Nenechá devadesát devět ovcí a nejde hledat tu zaběhlou?")
def _():
    return [gr(), J(110, 1, [(40, 100), (40, 100)], "walk", staff=None, h=58), sheep(122, G - 46, 0.8, 1), hills(150, 240, G - 2, 12),
            sheep(180, G, 0.6), sheep(200, G, 0.6, -1), sheep(220, G, 0.6), rock(40, G, 30, 18)]


@art("Mt 20,1", "Hospodář vyšel najmout dělníky na svou vinici")
def _():
    return [gr(), man(60, 1, "point", h=56), man(110, -1, h=50), man(135, -1, beard=False, h=52), vine(160, 70, 230, 3),
            [(160, 70), (160, G)], [(230, 72), (230, G)], sun(30, 20, 7)]


@art("Mt 25,1", "Deset družiček vzalo své lampy a vyšly naproti ženichovi")
def _():
    out = [gr(), moon(220, 20, 6)]
    for i, x in enumerate((30, 70, 110, 150, 190)):
        out += woman(x, 1, "hold", h=48)
        out += lamp(x + 10, G - 30, 1, lit=i < 3)
    return out


@art("Mt 25,35", "Měl jsem hlad a dali jste mi jíst, byl jsem cizinec a ujali jste se mne")
def _():
    return [gr(), man(150, -1, "reach", "sit", h=50), rock(150, G, 16, 12), woman(100, 1, "give", h=50), bread(124, G - 30, 7),
            cup(117, G - 22), house(40, G, 40, 30)]


@art("Mt 26,26", "Ježíš vzal chléb, požehnal, lámal a dával učedníkům")
def _():
    return [table(120, G, 160, 24), J(120, 0, "hold", g=G - 2, h=60), bread(120, G - 26, 10), cup(140, G - 24),
            man(60, -1, "down", "sit", g=G, h=48)[:0], disciples(40, 80, 2, 1), disciples(160, 200, 2, -1)]


@art("Mt 28,19", "Jděte, získávejte mi učedníky ve všech národech")
def _():
    return [smooth([(0, G), (60, G - 30), (120, G - 36), (180, G - 30), (240, G)]), J(120, 0, "wide", g=G - 36, h=58),
            disciples(30, 70, 2, 1), disciples(175, 215, 2, -1), path(60, G + 6, 10, G - 20, 8, 2)]


# --- Marek --------------------------------------------------------------------

@art("Mk 2,4", "Odkryli střechu a spustili lehátko s ochrnutým")
def _():
    return [gr(), house(120, G, 120, 60, door=False), rope(80, G - 60, 92, G - 30), rope(160, G - 60, 148, G - 30),
            [(90, G - 30), (150, G - 30)], man(100, 1, "down", "lie", g=G - 32, h=40), man(75, 1, "reach", g=G - 60, h=36),
            man(165, -1, "reach", g=G - 60, h=36), J(200, -1, "bless", h=50)]


@art("Mk 4,39", "Ježíš pohrozil větru a moři: Utiš se!")
def _():
    return [boat(120, G - 6, 120, True), J(130, 0, "raise", g=G - 26, h=50), disciples(80, 100, 2, 1, "cry"), sea(0, 240, G - 6, 3),
            cloud(60, 20, 40), cloud(190, 25, 40)]


@art("Mk 5,41", "Talitha kum – děvčátko, pravím ti, vstaň!")
def _():
    return [gr(), bed(110, G, 70), kid(90, 1, "reach", "sit", g=G - 6, h=34), J(150, -1, "reach", h=58), woman(30, 1, "pray", h=48),
            man(55, 1, "cry", h=52)]


@art("Mk 6,41", "Vzal pět chlebů a dvě ryby, vzhlédl k nebi a požehnal")
def _():
    return [gr(), J(70, 1, "raise", h=58), basket(110, G, 16, 9, "bread"), basket(135, G, 14, 8, "fish"), crowd(150, 235, G, 36),
            hills(140, 240, G - 34, 8)]


@art("Mk 10,14", "Nechte děti přicházet ke mně, nebraňte jim")
def _():
    return [gr(), J(110, 1, "bless", "sit", h=56), rock(110, G, 18, 14), kid(150, -1, "raise", h=32), kid(175, -1, h=28),
            kid(140, -1, h=24), woman(205, -1, "pray", h=48), man(40, 1, "point", h=52)]


@art("Mk 10,51", "Co chceš, abych pro tebe učinil? – Abych viděl")
def _():
    return [gr(), J(80, 1, "bless", h=58), man(140, -1, "raise", "kneel", h=52), [(170, G - 20), (175, G)], crowd(180, 235, G, 30)]


@art("Mk 11,7", "Přivedli osle, Ježíš na něj usedl a lid stlal pláště na cestu")
def _():
    return [gr(), donkey(100, G, 1.6, 1), J(95, 1, "bless", "sit", g=G - 16, h=46), tree(200, G, 60, "palm"), man(165, -1, "raise", h=50),
            kid(185, -1, "raise", h=30), smooth([(120, G - 1), (150, G - 3), (170, G)]), man(30, 1, h=48)]


@art("Mk 12,42", "Chudá vdova vhodila dvě drobné mince")
def _():
    return [gr(), [(110, G), (110, G - 30), (150, G - 30), (150, G)], ellipse(130, G - 30, 20, 4), woman(90, 1, "give", h=46),
            circle(116, G - 34, 1.2), circle(119, G - 36, 1.2), J(200, -1, "point", "sit", h=56), rock(200, G, 16, 14)]


@art("Mk 14,35", "Ježíš padl na zem a modlil se v Getsemanské zahradě")
def _():
    return [gr(), rock(110, G, 40, 16), J(110, 1, "pray", "kneel", g=G - 14, h=56), tree(40, G, 60), tree(200, G, 54),
            disciples(165, 165, 1, -1, "down")[:0], man(180, -1, "down", "lie", h=44), moon(220, 20, 6)]


@art("Mk 15,24", "Ukřižovali ho")
def _():
    return [smooth([(0, G), (80, G - 20), (160, G - 20), (240, G)]), cross(120, G - 20, 90), J(120, 0, "wide", g=G - 30, h=60)[:6],
            cross(50, G - 8, 60), cross(190, G - 8, 60), woman(90, 1, "cry", g=G - 18, h=40), man(150, -1, "down", g=G - 18, h=42)]


@art("Mk 16,6", "Nelekejte se – byl vzkříšen, není zde")
def _():
    return [gr(), tomb(140, G, 90, 60, "rolled"), angel(122, 0, "bless", G, 40), woman(40, 1, "cry", h=48), woman(65, 1, "hold", h=46),
            jar(80, G - 26, 0.5), sun(30, 20, 7)]


# --- Lukáš --------------------------------------------------------------------

@art("L 1,28", "Anděl přišel k Marii: Buď zdráva, milostí zahrnutá")
def _():
    return [gr(), angel(80, 1, "bless", h=60), woman(160, -1, "pray", "kneel", h=50), window(200, G - 50, 14, 16), lily(120, G, 14)]


@art("L 1,40", "Marie vešla do Zachariášova domu a pozdravila Alžbětu")
def _():
    return [gr(), woman(100, 1, "wide", h=48), woman(130, -1, "wide", h=50), house(200, G, 50, 36), hills(0, 80, G - 2, 10)]


@art("L 2,7", "Porodila syna, zavinula ho a položila do jeslí")
def _():
    return [gr(), [(20, G), (40, G - 60), (200, G - 64), (230, G)], manger(120, G, 30), circle(120, G - 16, 4),
            bez((124, G - 16), (130, G - 18), (134, G - 13)), woman(85, 1, "pray", "kneel", h=48), man(160, -1, "down", staff=0, h=54),
            ox(205, G, 0.8, -1), donkey(40, G, 0.8, 1), star(120, 30, 5)]


@art("L 2,9", "Anděl Páně stanul u pastýřů a obklopila je Boží sláva")
def _():
    return [gr(), angel(140, 0, "wide", G - 40, 50), rays(140, 50, 30, 50, 180, 360, 9), man(60, 1, "cry", "kneel", h=50),
            man(90, 1, "cry", staff=1, h=52), sheep(190, G, 0.8), sheep(210, G, 0.7, -1), stars([(30, 20), (220, 30)])]


@art("L 2,46", "Našli ho v chrámě, jak sedí uprostřed učitelů")
def _():
    return [gr(), pillar(20, G, 60), pillar(220, G, 60), kid(120, 0, "open", "sit", h=40), seat(120, G, 14, 10), man(70, 1, "down", "sit", h=52),
            man(175, -1, "point", "sit", h=52), scroll(90, G - 50, 18, 8)]


@art("L 5,6", "Zahrnuli tak velké množství ryb, že se jim sítě trhaly")
def _():
    out = [boat(110, G - 6, 100), man(90, 1, [(60, 120), (60, 120)], g=G - 18, h=40), man(125, 1, [(60, 120), (60, 120)], g=G - 18, h=40),
           nets(170, G, 40, 16), sea(0, 240, G, 3)]
    for x, y in ((160, G + 6), (172, G + 10), (185, G + 5), (176, G + 2)):
        out += fish(x, y, 0.5)
    return out


@art("L 7,38", "Žena plakala, smáčela mu nohy slzami a mazala je olejem")
def _():
    return [gr(), J(80, 1, "bless", "sit", h=56), seat(78, G, 16, 15), woman(140, -1, "reach", "bow", h=50), jar(175, G, 0.7),
            man(210, -1, "point", h=52)]


@art("L 10,34", "Samařan ošetřil jeho rány a naložil ho na svého osla")
def _():
    return [gr(), man(130, 1, "down", "lie", h=50), man(110, 1, "reach", "kneel", h=52), donkey(60, G, 1.4, 1), path(200, G, 220, G - 40, 20, 3),
            man(215, 1, h=30), hills(140, 240, G - 2, 10)]


@art("L 10,39", "Marie seděla u Pánových nohou a poslouchala, Marta se starala")
def _():
    return [gr(), J(90, 1, "open", "sit", h=56), seat(88, G, 16, 15), woman(140, -1, "pray", "sit", h=44), woman(200, -1, "hold", h=50),
            jar(186, G - 30, 0.6)]


@art("L 15,8", "Žena rozsvítí lampu, mete dům a hledá, dokud minci nenajde")
def _():
    return [gr(), woman(110, 1, [(60, 100), (40, 30)], "bow", h=54), lamp(80, G - 30, 1.4), [(150, G - 10), (175, G)],
            circle(170, G - 2, 2), rays(170, G - 2, 4, 9, 180, 360, 5), house(120, G, 200, 70, door=False)[0:1]]


@art("L 15,20", "Otec ho uviděl z dálky, běžel mu naproti a objal ho")
def _():
    return [gr(), man(110, 1, "wide", "walk", h=56), youth(140, -1, "cry", h=48), house(40, G, 44, 32), path(160, G, 220, G - 30, 18, 3),
            goat(210, G, 0.7, -1, False)]


@art("L 16,20", "U dveří boháče ležel chudák Lazar")
def _():
    return [gr(), gate(70, G, 40, 50), man(120, 1, "reach", "sit", h=46), table(190, G, 50, 16), man(190, -1, "hold", "sit", h=52),
            cup(175, G - 16), goat(150, G, 0.7, -1, False)]


@art("L 18,13", "Celník se bil v prsa: Bože, slituj se nade mnou hříšným")
def _():
    return [gr(), pillar(20, G, 60), man(80, 1, "raise", h=56, belt=True), man(190, -1, "pray", h=52), pillar(225, G, 60)]


@art("L 19,4", "Zacheus vylezl na moruši, aby Ježíše viděl")
def _():
    return [gr(), tree(140, G, 90), man(135, 1, "reach", "sit", g=G - 54, h=30), J(70, 1, "point", h=58), crowd(170, 235, G, 34)]


@art("L 24,15", "Sám Ježíš se k nim připojil a šel s nimi")
def _():
    return [path(120, G + 6, 170, 40, 80, 4), J(90, 1, "open", "walk", h=56), man(130, -1, "down", "walk", h=52), man(155, -1, "point", "walk", h=50),
            sun(200, 30, 8), gr(0, 50)]


@art("L 24,30", "Vzal chléb, požehnal, lámal a dával jim – a poznali ho")
def _():
    return [table(120, G, 100, 20), J(120, 0, "hold", g=G - 2, h=58), bread(120, G - 22, 9), man(60, 1, "raise", "sit", h=50),
            man(180, -1, "cry", "sit", h=50), lamp(150, G - 20, 1)]


# --- Jan ----------------------------------------------------------------------

@art("J 1,5", "Světlo ve tmě svítí a tma ho nepohltila")
def _():
    return [lamp(120, 90, 3), rays(132, 70, 12, 40, 0, 360, 14), stars([(30, 30), (200, 40), (60, 110), (210, 110)])]


@art("J 2,7", "Naplňte džbány vodou – a voda se proměnila ve víno")
def _():
    out = [gr(), J(60, 1, "point", h=58), man(200, -1, "hold", h=52)]
    for x in (100, 125, 150, 175):
        out += jar(x, G, 1.3)
    return out


@art("J 3,2", "Nikodém přišel k Ježíšovi v noci")
def _():
    return [gr(), J(150, -1, "open", "sit", h=56), seat(152, G, 16, 15), man(90, 1, "pray", h=56), lamp(120, G - 4, 1.2),
            moon(200, 20, 7), stars([(40, 20), (90, 30)])]


@art("J 4,7", "Dej mi napít – řekl Ježíš ženě u studny")
def _():
    return [gr(), well(120, G, 26), J(80, 1, "give", "sit", h=56), rock(78, G, 16, 14), woman(165, -1, "hold", h=50),
            jar(152, G - 32, 0.6), sun(210, 25, 8)]


@art("J 6,9", "Je tu chlapec, který má pět chlebů a dvě ryby")
def _():
    return [gr(), kid(110, 1, "give", h=34), basket(130, G - 16, 12, 6, "bread"), man(160, -1, "point", h=52), J(200, -1, "bless", h=58),
            crowd(10, 80, G, 34)]


@art("J 8,6", "Ježíš se sklonil a psal prstem po zemi")
def _():
    return [gr(), J(110, 1, "reach", "kneel", h=56), [(140, G - 1), (150, G - 3), (156, G)], woman(60, 1, "cry", h=48),
            man(180, -1, h=52), man(205, -1, beard=False, h=50), stones(185, G, 2)]


@art("J 9,7", "Jdi se umýt v rybníku Siloe – šel, umyl se a vrátil se vidoucí")
def _():
    return [gr(0, 90), man(130, 1, "cry", "kneel", g=G - 4, h=50), sea(90, 220, G, 2), [(90, G), (90, G + 10)], [(220, G), (220, G + 10)],
            stones(60, G, 3), rays(130, 30, 6, 20, 0, 360, 10)]


@art("J 10,11", "Já jsem dobrý pastýř")
def _():
    return [gr(), J(110, 0, [(40, 110), (40, 110)], h=60), sheep(110, G - 40, 0.8, 1)[:0], sheep(60, G, 0.9, 1), sheep(160, G, 0.9, -1),
            sheep(190, G, 0.8, -1), sheep(40, G, 0.7, 1), hills(0, 240, G - 2, 6)]


@art("J 11,43", "Lazare, pojď ven!")
def _():
    return [gr(), tomb(160, G, 90, 60, "rolled"), man(155, 0, "hang", g=G, h=40), J(70, 1, "point", h=58), woman(40, 1, "pray", h=48)]


@art("J 13,5", "Nalil vodu do umyvadla a začal učedníkům umývat nohy")
def _():
    return [gr(), J(110, 1, "reach", "kneel", h=56), ellipse(140, G - 3, 12, 3), man(165, -1, "open", "sit", h=50), seat(165, G, 14, 13),
            jar(80, G, 0.8), man(210, -1, h=50)]


@art("J 15,5", "Já jsem vinný kmen, vy jste ratolesti")
def _():
    return [gr(), [(120, G), (120, G - 30)], smooth([(120, G - 30), (90, G - 50), (50, G - 55), (20, G - 50)]),
            smooth([(120, G - 30), (150, G - 50), (190, G - 55), (220, G - 50)]), smooth([(120, G - 30), (120, G - 60), (115, G - 80)]),
            grapes(60, G - 50, 1.5), grapes(185, G - 50, 1.5), grapes(115, G - 72, 1.3), grapes(30, G - 46, 1.2)]


@art("J 19,26", "Ženo, to je tvůj syn – to je tvá matka")
def _():
    return [smooth([(0, G), (80, G - 10), (160, G - 10), (240, G)]), cross(120, G - 10, 100), J(120, 0, "wide", g=G - 22, h=60)[:6],
            woman(85, 1, "cry", g=G - 8, h=48), youth(155, -1, "pray", g=G - 8, h=48)]


@art("J 20,16", "Marie! – Rabbuni!")
def _():
    return [gr(), J(90, 1, "bless", h=58), woman(140, -1, "reach", "kneel", h=48), tomb(205, G, 60, 40, "rolled"), flowers(20, 70, G, 3),
            sun(30, 20, 7)]


@art("J 20,27", "Vlož sem svůj prst a nebuď nevěřící")
def _():
    return [gr(), J(100, 1, "open", h=58), man(140, -1, "reach", h=52), disciples(185, 225, 2, -1)]


@art("J 21,9", "Na břehu viděli oheň, na něm rybu a chléb")
def _():
    return [gr(0, 150), flames(90, G - 4, 18), stones(90, G, 4), fish(90, G - 18, 0.7), J(50, 1, "give", "sit", h=54), rock(50, G, 16, 12),
            boat(200, G + 2, 50), sea(140, 240, G + 6, 2), man(130, -1, "pray", h=50)]


@art("J 21,17", "Pas mé ovce")
def _():
    return [gr(), J(80, 1, "point", h=58), man(130, -1, "cry", h=52), sheep(180, G, 0.9, -1), sheep(210, G, 0.8, 1), sea(140, 240, G + 6, 1)]


# --- Skutky -------------------------------------------------------------------

@art("Sk 1,9", "Byl vzat vzhůru a oblak jim ho zakryl")
def _():
    return [cloud(120, 50, 70), J(120, 0, "bless", g=48, h=40), gr(), disciples(40, 90, 3, 1, "raise"), disciples(160, 210, 3, -1, "raise")]


@art("Sk 2,3", "Ukázaly se jim jazyky jako z ohně a spočinuly na každém z nich")
def _():
    out = [gr()]
    for i, x in enumerate((40, 80, 120, 160, 200)):
        out += man(x, 0, "raise" if i % 2 else "pray", h=50, beard=i % 2 == 0)
        out += flames(x, G - 54, 5)[1:2]
    return out


@art("Sk 3,8", "Chromý vyskočil, stál a chodil a chválil Boha")
def _():
    return [gr(), gate(70, G, 50, 70), man(140, 1, [(150, 170), (120, 160)], "walk", h=54), man(190, -1, "bless", h=54),
            man(215, -1, h=52)]


@art("Sk 7,59", "Štěpán se modlil: Pane Ježíši, přijmi mého ducha")
def _():
    return [gr(), man(100, 1, "raise", "kneel", h=52, beard=False), rays(140, 20, 6, 30, 90, 180, 5), stones(130, G, 3), crowd(170, 235, G, 40),
            man(30, 1, "down", h=50, beard=False)]


@art("Sk 8,30", "Filip uslyšel, že dvořan čte proroka Izajáše")
def _():
    return [gr(), chariot(140, G, 1.4, 1), man(140, 1, "hold", g=G - 18, h=34), scroll(156, G - 34, 14, 7), horse(195, G, 1.2, 1),
            man(80, 1, "point", "walk", h=54), path(10, G, 30, G - 30, 10, 2)]


@art("Sk 9,3", "U Damašku ho náhle ozářilo světlo z nebe")
def _():
    return [gr(), rays(160, 10, 6, 70, 100, 160, 7), man(120, 1, "cry", "bow", h=56), horse(60, G, 1.2, -1), city(180, 240, G, 30)]


@art("Sk 10,11", "Petr viděl nebe otevřené a sestupovat cosi jako velké plátno")
def _():
    return [gr(), house(80, G, 110, 40, door=False), man(70, 1, "open", "sit", g=G - 40, h=40), [(140, 30), (200, 30), (215, 60), (125, 60), (140, 30)],
            sheep(170, 52, 0.6), bird(150, 45, 0.8), snake(195, 56, 0.4), [(140, 30), (170, 5)], [(200, 30), (170, 5)]]


@art("Sk 12,7", "Anděl vzbudil Petra a řetězy mu spadly z rukou")
def _():
    return [gr(), man(80, 1, "open", "sit", h=50), chain(60, G - 10, 40, G, 4), chain(100, G - 10, 115, G, 4), angel(160, -1, "point", h=58),
            [(200, G), (200, G - 70)], [(210, G), (210, G - 70)], [(220, G), (220, G - 70)], [(200, G - 35), (225, G - 35)]]


@art("Sk 16,25", "O půlnoci se Pavel a Silas modlili a zpívali Bohu")
def _():
    return [gr(), man(90, 1, "raise", "sit", h=52), man(140, -1, "pray", "sit", h=50), chain(70, G - 4, 50, G, 3), window(120, 40, 20, 14),
            [(116, 33), (116, 47)], [(124, 33), (124, 47)], moon(200, 20, 6)]


@art("Sk 17,22", "Pavel stál uprostřed Areopagu a mluvil")
def _():
    return [gr(), man(70, 1, "open", h=56), pillar(130, G, 50), pillar(160, G, 50), pillar(190, G, 50), [(120, G - 54), (200, G - 54)],
            [(122, G - 58), (160, G - 70), (198, G - 58)], crowd(110, 230, G, 30)]


@art("Sk 27,41", "Loď najela na mělčinu a příď uvízla")
def _():
    return [rotate(boat(120, G - 10, 110, True), -12, 120, G - 10), sea(0, 240, G - 4, 3), cloud(60, 25, 50), cloud(180, 20, 50),
            rain(20, 230, 40, 80, 14), man(60, 0, "raise", g=G, h=30)[:12]]


@art("Sk 28,3", "Zmije se Pavlovi zakousla do ruky, ale nic zlého se mu nestalo")
def _():
    return [gr(), flames(100, G - 2, 22), stones(100, G, 4), man(140, -1, [(70, 90), (10, 5)], h=56), snake(116, G - 34, 0.6, -1),
            man(50, 1, "cry", h=50), rain(10, 230, 10, 40, 8)]
