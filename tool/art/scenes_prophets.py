"""Ilustrace: Jób – Malachiáš."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import art


# --- Jób ----------------------------------------------------------------------

@art("Jb 2,8", "Jób seděl v popelu a přátelé k němu přišli, aby ho potěšili")
def _():
    return [gr(), man(70, 1, "cry", "sit", h=54), rock(70, G, 16, 12), man(140, -1, "cry", "sit", h=50), rock(140, G, 14, 12),
            man(175, -1, "down", "sit", h=50), rock(175, G, 14, 12), man(210, -1, "pray", "sit", h=50), rock(210, G, 14, 12)]


@art("Jb 38,1", "Hospodin odpověděl Jóbovi z bouře")
def _():
    return [cloud(150, 30, 70), rain(110, 200, 45, 80, 8), [(170, 45), (160, 62), (170, 62), (158, 82)],
            stars([(30, 25), (60, 15), (90, 35)]), gr(), man(70, 1, "raise", "kneel", h=54), hills(120, 240, G - 2, 12)]


@art("Jb 42,10", "Hospodin Jóbovi obnovil vše a dal mu dvojnásob")
def _():
    return [gr(), man(60, 1, "raise", h=54), woman(85, 1, "pray", h=50), kid(110, 0, h=30), kid(125, 0, h=26),
            camel(170, G, 1, 1), sheep(210, G, 0.8), sheep(228, G, 0.7), sun(200, 30, 8)]


# --- Žalmy --------------------------------------------------------------------

@art("Ž 1,3", "Je jako strom zasazený u vodních toků")
def _():
    return [tree(110, G, 90), smooth([(10, G + 6), (60, G + 2), (120, G + 8), (180, G + 3), (235, G + 7)]),
            smooth([(20, G + 14), (80, G + 10), (150, G + 16), (230, G + 12)]), gr(0, 100), circle(95, G - 60, 2),
            circle(125, G - 70, 2), circle(110, G - 52, 2), circle(135, G - 55, 2)]


@art("Ž 8,4", "Hledím na nebesa, dílo tvých prstů, na měsíc a hvězdy")
def _():
    return [gr(), man(100, 1, "open", h=50), moon(170, 30, 10),
            stars([(30, 20), (60, 40), (90, 15), (130, 30), (200, 60), (220, 20), (150, 60), (40, 70)]), hills(130, 240, G - 2, 10)]


@art("Ž 23,1", "Hospodin je můj pastýř, nebudu mít nedostatek")
def _():
    return [gr(), man(80, 1, "bless", staff=1, h=58), sheep(130, G, 1, 1), sheep(160, G, 0.9, -1), sheep(190, G, 1),
            sheep(118, G - 10, 0.6, -1)[:0], smooth([(140, G + 8), (190, G + 4), (235, G + 9)]), tree(220, G, 40), tufts(110, 230, G, 5)]


@art("Ž 42,2", "Jako laň dychtí po vodních bystřinách, tak dychtí má duše po tobě")
def _():
    return [deer(110, G, 2, 1), smooth([(130, G + 6), (170, G + 2), (230, G + 7)]), smooth([(140, G + 12), (190, G + 9), (235, G + 13)]),
            gr(0, 130), reeds(200, 230, G, 3), tree(40, G, 46)]


@art("Ž 46,2", "Bůh je naše útočiště a síla")
def _():
    return [mountain(130, G, 160, 80), tower(130, G - 70, 16, 30), sea(0, 240, G + 6, 3), stars([(30, 30), (220, 30)])]


@art("Ž 91,4", "Přikryje tě svými perutěmi, pod jeho křídly najdeš útočiště")
def _():
    return [gr(), hen(120, G, 3, 1), chick(80, G), chick(92, G, 1.1), chick(150, G, 0.9), chick(160, G)]


@art("Ž 119,105", "Tvé slovo je lampou mým nohám a světlem mé stezce")
def _():
    return [gr(), path(60, G + 2, 220, G - 30, 40, 4), man(90, 1, [(20, 60), (10, 5)], "walk", h=56),
            lamp(110, G - 6, 1.4), rays(110, G - 10, 6, 16, 200, 340, 5), moon(200, 20, 7), stars([(40, 25), (150, 15), (230, 45)])]


@art("Ž 121,1", "Pozvedám oči k horám – odkud přijde pomoc?")
def _():
    return [mountain(170, G, 120, 70), mountain(90, G, 80, 40), gr(), man(40, 1, "open", h=52), sun(200, 25, 8)]


@art("Ž 127,1", "Nebude-li dům stavět Hospodin, nadarmo se namáhají stavitelé")
def _():
    return [gr(), wall(110, 200, G, 34, 4), man(70, 1, "carry", h=54), [(58, G - 58), (82, G - 58), (82, G - 52), (58, G - 52), (58, G - 58)],
            stones(220, G, 3)]


@art("Ž 137,1", "U babylonských řek jsme sedávali a plakali")
def _():
    return [tree(60, G, 70), harp(85, G - 52, 16), sea(100, 235, G + 4, 3), gr(0, 100), man(35, 1, "cry", "sit", h=50),
            woman(120, 1, "cry", "sit", g=G - 6, h=44)[:0]]


@art("Ž 150,3", "Chvalte ho zvukem polnice, harfou a citarou")
def _():
    return [gr(), trumpet(30, 60, 30, -20), harp(80, G, 34), circle(130, 70, 10), circle(150, 70, 10),
            man(185, -1, "raise", h=50), woman(215, -1, "raise", h=46), flowers(110, 170, G, 4)]


# --- Přísloví, Kazatel, Píseň ------------------------------------------------

@art("Př 3,5", "Doufej v Hospodina celým srdcem")
def _():
    return [path(120, G + 6, 150, G - 50, 60, 4), man(110, 1, "down", "walk", h=50), heart(190, 40, 10), sun(40, 30, 7), gr(0, 60)]


@art("Př 6,6", "Jdi k mravenci, lenochu, pozoruj jeho cesty a zmoudři")
def _():
    return [gr(), ant(60, G - 3, 2), ant(110, G - 3, 2), ant(160, G - 3, 2), circle(66, G - 12, 2), circle(116, G - 12, 2),
            rock(210, G, 40, 26), man(30, 1, "down", "lie", h=40)[:0]]


@art("Př 31,10", "Statečnou ženu kdo nalezne? Má větší cenu než perly")
def _():
    return [gr(), woman(90, 1, [(60, 100), (30, 80)], "sit", h=52), seat(90, G, 16, 14), [(120, G - 40), (120, G - 10)],
            circle(120, G - 30, 4), house(190, G, 50, 34), basket(140, G, 16, 8, "bread")]


@art("Kaz 3,1", "Všechno má svou chvíli – čas sázet i čas sklízet")
def _():
    return [gr(), man(50, 1, "reach", "bow", h=50), plant(80, G, 10), field(140, 230, G, 6), man(120, 1, [(80, 140), (60, 90)], h=52),
            sickle(140, G - 40, 1.4), sun(200, 25, 7)]


@art("Kaz 4,12", "Trojitá šňůra se jen tak nepřetrhne")
def _():
    return [smooth([(30, 75), (60, 68), (90, 82), (120, 68), (150, 82), (180, 68), (210, 75)]),
            smooth([(30, 75), (60, 82), (90, 68), (120, 82), (150, 68), (180, 82), (210, 75)]),
            smooth([(30, 72), (75, 75), (105, 72), (135, 78), (165, 72), (210, 75)]), man(60, 1, h=40, g=G), man(120, 0, h=40, g=G),
            man(180, -1, h=40, g=G), gr()]


@art("Kaz 12,1", "Pamatuj na svého Stvořitele ve dnech svého mládí")
def _():
    return [gr(), youth(80, 1, "raise", h=52), man(160, -1, "down", staff=0, h=50), sun(120, 30, 8), tree(215, G, 40)]


@art("Pís 2,12", "Na zemi se objevují květy, nastal čas zpěvu")
def _():
    return [gr(), youth(90, 1, "give", h=52), woman(130, -1, "give", h=48), flowers(10, 70, G, 5), flowers(160, 235, G, 6),
            bird(170, 40, 1.4), bird(190, 32), tree(210, G, 50)]


@art("Pís 8,6", "Polož si mě jako pečeť na srdce – láska je silná jako smrt")
def _():
    return [heart(120, 70, 30), heart(120, 70, 18), flames(120, 60, 10)[1:2], gr(60, 180, G + 10)]


# --- Izajáš -------------------------------------------------------------------

@art("Iz 2,4", "Překují své meče na radlice")
def _():
    return [gr(), man(70, 1, [(60, 110), (150, 200)], h=54), [(105, G - 52), (110, G - 10)], [(90, G), (125, G)], [(95, G), (98, G - 12), (120, G - 12), (123, G)],
            sword(150, G - 8, 26, 70), plough(180, G, 1), field(200, 235, G, 2)]


@art("Iz 6,1", "Viděl jsem Panovníka sedět na vysokém a vznešeném trůnu")
def _():
    return [throne(120, G - 30, 40, 1), rays(120, G - 70, 18, 40, 200, 340, 7), angel(60, 0, "raise", G - 40, 40), angel(180, 0, "raise", G - 40, 40),
            smooth([(20, G - 20), (120, G - 10), (220, G - 20)]), gr(), man(120, 1, "cry", "bow", h=40)]


@art("Iz 9,5", "Dítě se nám narodilo, syn je nám dán")
def _():
    return [gr(), manger(120, G, 30), circle(120, G - 16, 4), bez((124, G - 16), (130, G - 18), (134, G - 13)),
            star(120, 30, 7), rays(120, 30, 10, 30, 40, 140, 5), woman(80, 1, "pray", "kneel", h=48), man(165, -1, "down", staff=0, h=54)]


@art("Iz 11,6", "Vlk bude pobývat s beránkem a malý chlapec je povede")
def _():
    return [gr(), dog(70, G, 1.3, 1, wolf=True), sheep(115, G, 1, -1), kid(150, -1, "reach", h=34), sheep(180, G, 0.8, 1), ox(215, G, 0.9, -1)]


@art("Iz 40,31", "Ti, kdo skládají naději v Hospodina, vznesou se jako orli")
def _():
    return [eagle(120, 50, 2.6), mountain(60, G, 100, 40), mountain(180, G, 90, 30), sun(210, 25, 8), gr()]


@art("Iz 53,6", "Všichni jsme bloudili jako ovce, každý se obrátil na svou cestu")
def _():
    return [gr(), sheep(40, G, 1, -1), sheep(90, G, 0.9, 1), sheep(150, G - 20, 0.8, 1), sheep(200, G, 1, 1),
            hills(110, 200, G - 2, 20), path(120, G, 40, 60, 10, 3), path(150, G, 220, 60, 10, 3)]


@art("Iz 55,1", "Všichni žízniví, pojďte k vodám")
def _():
    return [gr(), jar(110, G, 1.4), smooth([(150, G + 6), (190, G + 2), (235, G + 7)]), man(60, 1, "reach", "walk", h=50),
            woman(150, -1, "give", h=48), tree(215, G, 40, "palm")]


# --- Jeremjáš, Pláč, Ezechiel ------------------------------------------------

@art("Jr 1,9", "Hospodin se dotkl mých úst: Vložil jsem do tvých úst svá slova")
def _():
    return [gr(), youth(140, -1, "cry", h=52), hand(108, G - 50, 1.4, False), rays(90, 20, 4, 30, 30, 90, 4), tree(40, G, 46)]


@art("Jr 18,3", "Sestoupil jsem do domu hrnčíře, a hle, pracoval na kruhu")
def _():
    return [gr(), potter(110, G, 56), jar(190, G, 1), jar(212, G, 0.8)]


@art("Jr 29,11", "Já znám své myšlenky s vámi – myšlenky pokoje, abych vám dal naději")
def _():
    return [gr(), path(120, G, 160, G - 50, 50, 4), sun(170, 40, 10), man(90, 1, "down", "walk", h=48), woman(110, 1, "down", "walk", h=44)]


@art("Jr 38,6", "Spustili Jeremjáše na provazech do jámy plné bahna")
def _():
    return [gr(0, 80), gr(160, 240), [(80, G), (80, G + 10)], [(160, G), (160, G + 10)], rope(120, G - 20, 120, G + 10),
            man(120, 0, "raise", g=G + 50, h=44), smooth([(85, G + 40), (120, G + 46), (155, G + 40)]), man(50, 1, "reach", h=50),
            [(80, G + 10), (85, G + 50)], [(160, G + 10), (155, G + 50)]]


@art("Pl 3,22", "Hospodinovo milosrdenství je každé jitro nové")
def _():
    return [sun(120, G - 4, 18), rays(120, G - 4, 24, 50, 200, 340, 9), gr(), wall(10, 70, G, 20, 2, broken=True),
            wall(170, 230, G, 18, 2, broken=True), man(90, 1, "raise", h=40)]


@art("Ez 1,15", "Viděl jsem kola s očima vedle bytostí")
def _():
    return [wheel(80, 80, 30), wheel(80, 80, 18, 6), wheel(170, 80, 30), wheel(170, 80, 18, 6),
            eye(80, 40, 12), eye(170, 40, 12), cloud(125, 25, 50), gr(), man(125, 1, "cry", "bow", h=38)]


@art("Ez 37,7", "Kosti se k sobě přibližovaly, kost ke své kosti")
def _():
    return [gr(), bones(20, 220, G, 9), man(120, 0, "wide", h=56), hills(0, 240, G - 60, 10), smooth([(140, 50), (180, 45), (220, 52)])]


@art("Ez 47,12", "Při řece porostou stromy, jejichž listí bude k uzdravení")
def _():
    return [temple(40, G - 40, 60, 30), smooth([(60, G - 40), (100, G - 20), (140, G), (240, G + 6)]),
            smooth([(70, G - 40), (120, G - 12), (160, G + 10), (240, G + 14)]), tree(130, G - 22, 40), tree(200, G - 4, 50),
            fish(190, G + 10, 0.8)]


@art("Ez 34,12", "Jako pastýř hledá své ovce, tak já budu hledat své ovce")
def _():
    return [gr(), hills(0, 240, G - 4, 20), man(140, -1, "reach", staff=1, h=56), sheep(90, G, 0.9, 1), sheep(60, G - 18, 0.7, 1),
            moon(40, 20, 7)]


# --- Daniel -------------------------------------------------------------------

@art("Da 1,12", "Dávej nám jíst zeleninu a pít vodu")
def _():
    return [gr(), table(120, G, 90, 18), youth(70, 1, "give", "sit", h=50), youth(100, 1, "down", "sit", h=48)[:0],
            plant(110, G - 18, 10), plant(125, G - 18, 9), jar(140, G - 18, 0.7), man(190, -1, "point", h=54)]


@art("Da 3,25", "Vidím čtyři muže, jak se volně procházejí uprostřed ohně")
def _():
    return [gr(), furnace(120, G, 160, 90), man(80, 1, "raise", h=40), man(105, 1, "pray", h=40), man(135, 1, "down", h=40),
            angel(160, -1, "down", G, 44)[:-6], flames(60, G - 50, 16), flames(180, G - 50, 16)]


@art("Da 5,5", "Zjevily se prsty lidské ruky a psaly na omítku zdi")
def _():
    return [gr(), [(90, 20), (230, 20)], hand(140, 50, 1.6, False), [(150, 78), (160, 76)], [(165, 78), (170, 74), (175, 79)],
            [(180, 76), (195, 76)], king(60, 1, "cry", h=56), lampstand(30, G, 26), table(200, G, 40, 16), cup(200, G - 16)]


@art("Da 6,23", "Můj Bůh poslal anděla a ten zavřel lvům tlamy")
def _():
    return [gr(), man(120, 0, "pray", h=54), lion(70, G, 1.3, 1), lion(175, G, 1.3, -1), angel(120, 0, "down", G - 60, 30)[:-6],
            smooth([(0, 20), (40, 10), (200, 10), (240, 20)])]


@art("Da 7,13", "Hle, s nebeskými oblaky přicházel jako Syn člověka")
def _():
    return [cloud(90, 90, 60), cloud(160, 95, 50), J(120, 0, "raise", g=G - 50, h=60), rays(120, 20, 10, 40, 160, 380, 10)]


# --- Malí proroci -------------------------------------------------------------

@art("Oz 11,4", "Táhl jsem je provázky lidskosti, poutky lásky")
def _():
    return [gr(), man(100, 1, [(50, 70), (100, 110)], h=56), kid(140, -1, "reach", h=26), rope(117, G - 32, 133, G - 18)]


@art("Jl 3,1", "Vyleji svého Ducha na všechny lidi")
def _():
    return [gr(), bird(120, 30, 1.6, -1, True), rays(120, 40, 10, 40, 40, 140, 7), youth(60, 1, "raise", h=46), woman(100, 1, "raise", h=46),
            man(150, -1, "raise", h=50), kid(185, -1, "raise", h=30), woman(210, -1, "pray", h=44)]


@art("Am 5,24", "Ať se valí právo jako voda a spravedlnost jako proud")
def _():
    return [smooth([(0, 50), (60, 70), (120, 90), (180, 110), (240, 120)]), smooth([(0, 70), (60, 90), (110, 106), (170, 126), (240, 136)]),
            waves(60, 160, 95, 4), scales(40, 110, 1.4)]


@art("Am 7,7", "Pán stál na zdi s olovnicí v ruce")
def _():
    return [gr(), wall(60, 180, G, 50, 5), man(120, 0, [(90, 110), (10, 5)], g=G - 50, h=50), plumb(150, G - 82, G - 30)]


@art("Abd 1,4", "I kdybys hnízdil mezi hvězdami, strhnu tě odtud")
def _():
    return [mountain(120, G, 140, 90), eagle(130, 30, 1.4), stars([(40, 20), (80, 30), (180, 20), (220, 40)]), gr()]


@art("Jon 1,15", "Vzali Jonáše a hodili ho do moře, a moře se utišilo")
def _():
    return [boat(130, G - 20, 90, True), man(110, 1, "down", g=G - 32, h=30), man(150, -1, "raise", g=G - 32, h=30),
            man(70, 0, "raise", g=G - 6, h=36)[:12], sea(10, 230, G - 10, 3), cloud(200, 20, 30)]


@art("Jon 2,1", "Hospodin poslal velkou rybu, aby Jonáše spolkla")
def _():
    return [fish(120, 80, 9, 1), man(122, 1, "pray", "kneel", g=96, h=24), waves(0, 240, 40), sea(0, 240, 120, 3)]


@art("Jon 3,4", "Ještě čtyřicet dní a Ninive bude vyvráceno")
def _():
    return [gr(), city(100, 230, G, 50), man(60, 1, "point", h=54), man(130, -1, "cry", "kneel", h=38), king(160, -1, "pray", "kneel", h=40)]


@art("Jon 4,6", "Hospodin dal vyrůst skočci, aby Jonášovi stínil hlavu")
def _():
    return [gr(), man(100, 1, "down", "sit", h=50), rock(100, G, 16, 12), smooth([(130, G), (135, G - 40), (110, G - 60), (80, G - 55)]),
            heart(110, G - 62, 6), heart(90, G - 56, 6), sun(200, 30, 10), city(170, 235, G, 30)]


@art("Mi 4,4", "Každý bude sedět pod svou vinnou révou a pod svým fíkovníkem")
def _():
    return [gr(), tree(70, G, 60), man(80, 1, "down", "sit", h=50), [(125, 60), (225, 58)], [(130, 60), (130, G)], [(220, 58), (220, G)], grapes(150, 64, 1.3), grapes(195, 63, 1.3), plant(172, 60, 10),
            woman(175, -1, "pray", "sit", h=46)]


@art("Mi 5,1", "Ty, Betléme Efrata, z tebe mi vzejde vládce")
def _():
    return [gr(), hills(0, 240, G - 4, 10), house(80, G - 4, 30, 20), house(110, G - 6, 26, 24), house(140, G - 4, 28, 18),
            star(120, 30, 7), rays(120, 30, 10, 26, 40, 140, 5), sheep(190, G, 0.8)]


@art("Mi 6,8", "Jednat spravedlivě, milovat milosrdenství a pokorně chodit se svým Bohem")
def _():
    return [path(120, G + 6, 150, G - 50, 70, 4), man(110, 1, "down", "walk", h=46), sun(150, 30, 8), gr(0, 70)]


@art("Na 2,1", "Hle, po horách přichází posel s dobrou zprávou")
def _():
    return [mountain(120, G, 200, 60), man(120, 1, "raise", "walk", g=G - 60, h=40), sun(200, 20, 8), gr()]


@art("Abk 2,2", "Zapiš to vidění a vyryj ho na tabulky")
def _():
    return [gr(), man(80, 1, [(60, 110), (40, 90)], h=56), tablets(130, G - 20, 34), tower(200, G, 24, 70)]


@art("Abk 3,17", "I kdyby fíkovník nevykvetl, já budu jásat v Hospodinu")
def _():
    return [gr(), fig_tree(60, G, 60, True), man(130, 1, "raise", h=54), smooth([(170, G), (200, G - 4), (235, G)]), [(180, G - 2), (184, G - 10)]]


@art("Sf 3,17", "Hospodin bude jásat nad tebou s plesáním")
def _():
    return [gr(), kid(120, 0, "raise", h=36), rays(120, 20, 6, 40, 30, 150, 7), flowers(30, 90, G, 4), flowers(150, 220, G, 4),
            heart(120, 30, 7)]


@art("Ag 1,8", "Vystupte na horu, přineste dřevo a stavějte dům")
def _():
    return [mountain(60, G, 100, 50), tree(40, G - 20, 26), gr(), man(140, -1, [(150, 200), (150, 200)], h=54),
            [(120, G - 58), (160, G - 60)], wall(170, 230, G, 26, 3)]


@art("Za 4,2", "Svícen celý ze zlata a vedle něho dvě olivy")
def _():
    return [gr(), lampstand(120, G, 60), tree(50, G, 60), tree(190, G, 60)]


@art("Za 8,5", "Náměstí města budou plná chlapců a děvčat, kteří si tam hrají")
def _():
    return [gr(), city(0, 240, G - 40, 30, gate=False), kid(60, 1, "raise", h=30), kid(90, -1, "wide", h=28), kid(140, 1, "raise", h=30),
            kid(175, -1, "wide", h=26), circle(115, G - 20, 3), man(30, 1, "down", "sit", h=40), man(215, -1, "bless", "sit", h=40)]


@art("Za 9,9", "Hle, tvůj král přichází, pokorný, jede na oslu")
def _():
    return [gr(), donkey(120, G, 1.6, 1), J(115, 1, "bless", "sit", g=G - 16, h=46), city(170, 235, G, 30)]


@art("Mal 3,10", "Vyzkoušejte mě, zda vám neotevřu nebeské průduchy")
def _():
    return [gr(), house(80, G, 60, 40), basket(150, G, 16, 9, "bread"), jar(175, G, 0.9), cloud(150, 20, 60),
            rain(110, 190, 35, 60, 6), man(210, -1, "raise", h=50)]


@art("Mal 3,20", "Vám vyjde slunce spravedlnosti se zdravím na svých křídlech")
def _():
    return [sun(120, 60, 18), rays(120, 60, 24, 44, 0, 360, 16), gr(), kid(70, 1, "raise", h=30), kid(170, -1, "raise", h=30),
            ox(30, G, 0.8, 1)]
