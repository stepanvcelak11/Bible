"""Doplňkové ilustrace (každá druhá kapitola): zbytek proroků a Nový zákon."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import A

# --- proroci ------------------------------------------------------------------
A("Iz 66,13", "Jako matka těší svého syna, tak já vás budu těšit", lambda: [
    gr(), woman(110, 1, "wide", h=52), kid(135, -1, "wide", h=30), house(200, G, 40, 30), heart(122, 30, 7)])
A("Ez 45,10", "Mějte spravedlivé váhy a spravedlivé míry", lambda: [gr(), scales(120, 30, 2.6), man(50, 1, "point", h=54), basket(200, G, 20, 12)])
A("Da 12,3", "Rozumní budou zářit jako záře oblohy, jako hvězdy navěky", lambda: [
    stars([(30, 20), (60, 40), (100, 15), (140, 35), (180, 18), (210, 45), (80, 70), (170, 70)]), star(120, 50, 8), gr(), man(120, 0, "raise", h=40)])
A("Oz 14,6", "Budu Izraeli jako rosa, pokvete jako lilie", lambda: [
    gr(), lily(80, G, 20), lily(100, G, 16), lily(140, G, 22), lily(165, G, 17), *[circle(x, y, 1.4)[0] for x, y in ((70, 60), (110, 50), (150, 58), (180, 46))], sun(210, 25, 8)])
A("Za 2,5", "Muž s měřicí šňůrou šel změřit Jeruzalém", lambda: [gr(), city(130, 230, G, 40), man(80, 1, [(60, 90), (10, 5)], "walk", h=56), rope(100, G - 34, 130, G - 10)])
A("Za 6,1", "Čtyři vozy vyjížděly mezi dvěma horami", lambda: [
    mountain(30, G, 60, 60), mountain(210, G, 60, 60), chariot(90, G, 0.8, 1), horse(115, G, 0.9, 1), chariot(150, G - 20, 0.6, 1), horse(168, G - 20, 0.7, 1), gr()])
A("Za 11,7", "Vzal jsem si dvě hole, Laskavost a Svazek, a pásl ovce", lambda: [
    gr(), man(90, 1, [(60, 90), (10, 5)], staff=0, h=56), [(70, G), (68, G - 60)], sheep(140, G, 0.9), sheep(165, G, 0.8, -1), sheep(190, G, 0.9)])

# --- evangelia ----------------------------------------------------------------
A("Mt 8,3", "Ježíš vztáhl ruku, dotkl se malomocného: Chci, buď čist", lambda: [
    gr(), J(100, 1, "reach", h=58), man(150, -1, "pray", "kneel", h=50), crowd(180, 235, G, 30)])
A("Mt 10,16", "Posílám vás jako ovce mezi vlky", lambda: [
    gr(), J(50, 1, "point", h=58), man(100, 1, "down", "walk", h=50), man(125, 1, "down", "walk", h=48), sheep(170, G, 0.8), lion(215, G, 0.8, -1)])
A("Mt 15,27", "I psi jedí drobty, které padají ze stolu jejich pánů", lambda: [
    gr(), woman(140, -1, "pray", "kneel", h=48), J(80, 1, "bless", h=58), table(190, G, 40, 16)[:0], goat(200, G, 0.7, -1, False)])
A("Mt 21,12", "Ježíš vyhnal z chrámu všechny prodavače a převrátil stoly", lambda: [
    gr(), J(100, 1, "raise", h=58), rotate(table(160, G, 40, 14), 20, 160, G), coins(170, G - 2, 4), bird(200, 40, 1.4, 1, True), man(215, 1, "cry", "walk", h=48)])
A("Mt 23,37", "Kolikrát jsem chtěl shromáždit tvé děti jako slepice kuřátka", lambda: [
    gr(), hen(120, G, 2.4, 1), chick(80, G), chick(92, G), chick(150, G), city(170, 235, G, 30)])
A("Mk 7,34", "Ježíš vzhlédl k nebi a řekl: Effatha – otevři se!", lambda: [gr(), J(100, 1, "bless", h=58), man(150, -1, "open", h=52), rays(110, 15, 6, 30, 50, 130, 5)])
A("L 3,4", "Hlas volajícího na poušti: Připravte cestu Pánu", lambda: [
    gr(), man(90, 1, "open", h=56, belt=True), sea(140, 240, G + 4, 2), crowd(150, 230, G - 4, 30), hills(0, 80, G - 2, 10)])
A("L 8,44", "Žena se dotkla třásní jeho pláště a hned byla uzdravena", lambda: [
    gr(), J(130, 1, "down", "walk", h=58), woman(90, 1, "reach", "kneel", h=48), crowd(160, 235, G, 34)])
A("L 11,1", "Pane, nauč nás modlit se", lambda: [gr(), J(90, 1, "pray", "kneel", h=56), man(150, -1, "pray", h=52), man(185, -1, "open", h=50), tree(30, G, 46)])
A("L 13,19", "Hořčičné zrno vyrostlo ve strom a ptáci hnízdí v jeho větvích", lambda: [
    gr(), tree(120, G, 90), bird(100, 40, 1.2), bird(145, 30, 1), circle(60, G - 4, 1.5), J(200, -1, "point", h=56)])
A("L 20,24", "Ukažte mi denár. Čí obraz a nápis nese?", lambda: [
    gr(), J(90, 1, "hold", h=58), circle(114, G - 34, 5), circle(114, G - 34, 2.5), man(150, -1, "point", h=52), man(180, -1, h=50)])
A("L 22,61", "Pán se obrátil a pohleděl na Petra", lambda: [
    gr(), man(80, 1, "cry", h=54), flames(120, G - 4, 14), J(190, -1, "down", h=58), hen(150, 50, 1.2, -1)])
A("J 17,1", "Ježíš pozvedl oči k nebi: Otče, přišla ta hodina", lambda: [gr(), J(110, 1, "raise", h=58), rays(170, 20, 6, 30, 90, 170, 5), man(190, -1, "down", "sit", h=46)])
A("Sk 4,32", "Měli jedno srdce a jednu duši a všechno měli společné", lambda: [
    gr(), table(120, G, 100, 16), man(70, 1, "give", "sit", h=50), woman(170, -1, "give", "sit", h=46), bread(110, G - 17, 8), heart(120, 30, 8)])
A("Sk 13,3", "Postili se, modlili, vložili na ně ruce a vyslali je", lambda: [
    gr(), man(120, 1, "pray", "kneel", h=50), man(150, 1, "pray", "kneel", h=50), man(80, 1, [(110, 130), (100, 120)], h=56), man(200, -1, [(110, 130), (100, 120)], h=54)])
A("Sk 18,3", "Pavel bydlel u Akvily a Priscilly a pracovali spolu – šili stany", lambda: [
    gr(), man(80, 1, [(60, 100), (40, 80)], "sit", h=50), woman(150, -1, [(60, 100), (40, 80)], "sit", h=46), tent(115, G, 30, 16), [(100, G - 20), (130, G - 22)]])
A("Sk 20,9", "Eutychos usnul a spadl z okna ve třetím patře", lambda: [
    gr(), house(80, G, 70, 80, door=False), window(90, G - 60, 16, 14), lamp(70, G - 40, 1), youth(160, 1, "down", "lie", h=40), man(130, 1, "reach", "kneel", h=50)])
A("Sk 23,11", "Pán stál u Pavla a řekl: Buď odvážný", lambda: [
    gr(), man(80, 1, "down", "sit", h=50), chain(60, G - 2, 40, G, 3), J(150, -1, "bless", h=58), moon(210, 20, 6)])
A("Sk 24,25", "Pavel mluvil o spravedlnosti a soudu a Félix se polekal", lambda: [gr(), man(80, 1, "open", h=56), king(160, -1, "cry", "sit", h=54), throne(160, G, 40, -1)])

# --- epištoly a Zjevení -------------------------------------------------------
A("Ř 1,20", "Jeho neviditelná moc je vidět z jeho díla od stvoření světa", lambda: [
    sun(50, 30, 9), mountain(150, G, 140, 60), tree(40, G, 40), bird(130, 30, 1.2), gr(), sea(140, 240, G + 6, 1)])
A("Ř 3,24", "Jsou ospravedlňováni zadarmo jeho milostí", lambda: [gr(), man(100, 1, "raise", "kneel", h=52), cross(170, G, 60), rays(170, G - 44, 10, 26, 0, 360, 10)])
A("Ř 6,4", "Byli jsme pohřbeni křtem, abychom žili novým životem", lambda: [sea(20, 220, G - 6, 3), man(120, 0, "raise", g=G - 4, h=54)[:12], sun(200, 25, 8), plant(40, G - 12, 16)])
A("Ř 8,39", "Nic nás nemůže odloučit od Boží lásky v Kristu", lambda: [heart(120, 70, 36), man(120, 0, "pray", g=94, h=40), gr(70, 170, 112), rays(120, 66, 42, 54, 0, 360, 14)])
A("Ř 13,12", "Noc pokročila, den se přiblížil", lambda: [sun(160, G - 4, 14), rays(160, G - 4, 18, 30, 200, 340, 7), moon(50, 30, 8), stars([(80, 20), (30, 60)]), gr()])
A("Ř 15,7", "Přijímejte jedni druhé, jako Kristus přijal vás", lambda: [gr(), man(80, 1, "wide", h=54), woman(110, -1, "wide", h=48), man(160, 1, "wide", h=52), man(190, -1, "wide", h=54, beard=False)])
A("1K 1,18", "Slovo o kříži je Boží moc", lambda: [smooth([(40, G), (120, G - 14), (200, G)]), cross(120, G - 14, 90), rays(120, G - 78, 20, 44, 0, 360, 14)])
A("1K 4,1", "Služebníci Kristovi a správci Božích tajemství", lambda: [gr(), man(110, 1, [(80, 100), (10, 5)], h=56), circle(132, G - 34, 4), [(136, G - 34), (150, G - 34), (150, G - 30)], door(190, G, 24, 40)])
A("1K 6,19", "Vaše tělo je chrámem Ducha svatého", lambda: [gr(), man(120, 0, "open", h=56), bird(120, 30, 1.2, 1, True), temple(120, G, 160, 100)[:0], rays(120, G - 30, 36, 46, 0, 360, 12)])
A("1K 15,37", "Zaséváš holé zrno, ale Bůh mu dává tělo", lambda: [gr(), circle(60, G + 6, 2), plant(100, G, 12), wheat(140, G, 24), wheat(150, G, 26), wheat(160, G, 23), sun(200, 25, 8)])
A("2K 1,4", "Bůh nás těší, abychom mohli těšit druhé", lambda: [gr(), man(80, 1, "wide", h=54), man(110, -1, "cry", h=50), woman(160, 1, "wide", h=48), woman(188, -1, "cry", h=46)])
A("2K 6,10", "Jako chudí, a mnohé obohacujeme; nic nemáme, a máme všechno", lambda: [gr(), man(100, 1, "give", h=54, staff=None), kid(140, -1, "reach", h=30), heart(120, 30, 8), path(10, G, 60, G - 30, 14, 3)])
A("2K 11,33", "Spustili mě v koši oknem v hradbách", lambda: [
    wall(100, 220, G, 90, 9), window(150, 40, 16, 16), rope(150, 48, 150, 90), basket(150, 100, 20, 12), man(150, 0, "down", g=96, h=30)[:3], gr(0, 100), moon(40, 20, 6)])
A("2K 12,9", "Stačí ti má milost, má moc se projevuje ve slabosti", lambda: [gr(), man(110, 1, "raise", "kneel", h=52), [(80, G), (84, G - 40)], rays(170, 20, 6, 30, 90, 170, 5)])
A("Ga 2,20", "Už nežiji já, ale žije ve mně Kristus", lambda: [gr(), man(120, 0, "open", h=56), heart(120, G - 40, 6), rays(120, G - 40, 10, 30, 0, 360, 12), cross(40, G, 50)])
A("Ga 3,28", "Nerozhoduje, zda jste Žid či Řek, otrok či svobodný – všichni jste jedno", lambda: [
    gr(), man(50, 1, "wide", h=54), woman(85, -1, "wide", h=48), man(120, 1, "wide", h=52, beard=False), kid(150, 0, "wide", h=30), king(185, -1, "wide", h=54)])
A("Ef 3,18", "Abyste pochopili šířku, délku, výšku i hloubku Kristovy lásky", lambda: [
    [(40, 75), (200, 75)], [(120, 10), (120, 140)], [(46, 70), (40, 75), (46, 80)], [(194, 70), (200, 75), (194, 80)], [(115, 16), (120, 10), (125, 16)],
    [(115, 134), (120, 140), (125, 134)], heart(120, 75, 14)])
A("Fp 1,3", "Děkuji svému Bohu při každé vzpomínce na vás", lambda: [
    gr(), man(100, 1, [(60, 100), (40, 80)], "sit", h=52), chain(80, G - 2, 60, G, 3), scroll(140, G - 30, 26, 10), window(190, 50, 20, 16)])
A("1Te 2,7", "Byli jsme mezi vámi laskaví jako matka, která chová své děti", lambda: [gr(), woman(110, 1, "hold", "sit", h=52), seat(110, G, 16, 14), circle(130, G - 34, 3.5), kid(160, -1, h=28)])
A("2Te 1,3", "Vaše víra velmi roste a láska se rozhojňuje", lambda: [gr(), plant(60, G, 12), plant(110, G, 24), tree(180, G, 70), sun(40, 25, 8)])
A("1Tm 2,1", "Konejte modlitby za všechny lidi, i za krále a vládce", lambda: [gr(), man(70, 1, "pray", "kneel", h=52), woman(110, 1, "pray", "kneel", h=48), king(190, -1, h=54), crowd(150, 175, G, 20)])
A("1Tm 5,3", "Pečuj o vdovy, které jsou opravdu opuštěné", lambda: [gr(), woman(140, -1, "down", "sit", h=46), rock(140, G, 14, 10), man(90, 1, "give", h=54), basket(112, G - 30, 14, 8, "bread")])
A("2Tm 2,4", "Jako voják, závodník i rolník – vytrvej", lambda: [
    gr(), man(50, 1, "down", h=54), shield(66, G - 30, 1.2), man(120, 1, [(110, 60), (-60, -20)], "walk", h=50, beard=False), man(190, -1, [(60, 90), (40, 80)], h=52), wheat(210, G, 20)])
A("Žd 2,9", "Ježíš korunován slávou a ctí", lambda: [gr(), J(120, 0, "open", h=60), crown(120, G - 70, 18), rays(120, G - 74, 14, 30, 0, 360, 12)])
A("Žd 4,12", "Boží slovo je živé a ostřejší než dvousečný meč", lambda: [scroll(80, 70, 50, 20), sword(170, 110, 70, 0), gr(40, 210)])
A("Žd 7,1", "Melchisedech vyšel vstříc Abrahamovi a požehnal mu", lambda: [
    gr(), king(80, 1, "bless", h=56), bread(108, G - 32, 7), cup(120, G - 26), man(150, -1, "pray", "kneel", h=50), city(190, 240, G, 30)])
A("Žd 9,4", "Truhla smlouvy a v ní mana, Áronova hůl a desky smlouvy", lambda: [gr(), ark_cov(120, G, 50), tablets(60, G, 22), jar(180, G, 0.9), [(205, G), (205, G - 40)]])
A("Jk 5,7", "Rolník trpělivě čeká na drahocennou úrodu", lambda: [gr(), man(60, 1, staff=0, h=56), field(100, 230, G, 8), cloud(170, 25, 50), rain(140, 200, 36, 60, 6)])
A("1Pt 3,20", "V arše bylo zachráněno osm duší", lambda: [ark(120, G - 6, 120), sea(0, 240, G, 3), *[circle(98 + i * 7, G - 40, 2.5)[0] for i in range(8)], bird(200, 30, 1.2, -1, True)])
A("1J 2,8", "Tma pomíjí a pravé světlo už svítí", lambda: [sun(120, G - 4, 18), rays(120, G - 4, 24, 50, 180, 360, 12), moon(30, 20, 6), gr()])
A("Zj 8,2", "Viděl jsem sedm andělů a dostali sedm polnic", lambda: [
    *[g for i, x in enumerate((40, 80, 120, 160, 200)) for g in angel(x, 0, "down", G - (i % 2) * 10, 40)], gr(), rays(120, 10, 6, 20, 40, 140, 5)])
A("Zj 10,1", "Anděl oděný oblakem, nad hlavou duhu, nohama stál na moři i na zemi", lambda: [
    angel(120, 0, [(110, 150), (60, 30)], G, 80), rainbow(120, 40, 30), sea(130, 240, G + 4, 2), gr(0, 120), scroll(160, 70, 14, 8)])
A("Zj 14,6", "Anděl letěl středem nebe s věčným evangeliem", lambda: [rotate(angel(120, 1, "hold", 90, 50), -30, 120, 70), scroll(150, 60, 18, 8), gr(), crowd(30, 210, G, 30)])
A("Zj 15,2", "Stáli u skleněného moře smíšeného s ohněm a měli Boží harfy", lambda: [
    sea(0, 240, G + 4, 2), flames(120, G - 4, 16), harp(60, G - 4, 20), harp(180, G - 4, 20), man(40, 1, "raise", g=G - 6, h=44), man(200, -1, "raise", g=G - 6, h=44)])
A("Zj 17,14", "Beránek je přemůže, neboť je Pán pánů a Král králů", lambda: [smooth([(40, G), (120, G - 6), (200, G)]), sheep(120, G - 6, 2.4, 1), crown(124, G - 50, 14), rays(120, G - 30, 36, 50, 180, 360, 9)])
A("Zj 19,11", "Hle, bílý kůň; ten, kdo na něm sedí, se jmenuje Věrný a Pravý", lambda: [
    horse(120, G - 30, 2, 1), J(115, 1, "raise", "sit", g=G - 50, h=50, crown=True), cloud(70, G - 10, 50), cloud(180, G - 10, 50), rays(120, 20, 6, 30, 0, 180, 8)])

# --- doplnění ------------------------------------------------------------------
A("Mt 11,28", "Pojďte ke mně všichni, kdo se namáháte a jste obtíženi", lambda: [
    gr(), J(80, 1, "wide", h=58), man(140, -1, "carry", "walk", h=50), [(126, G - 54), (154, G - 54), (154, G - 46), (126, G - 46), (126, G - 54)], woman(180, -1, "cry", "walk", h=46)])
A("Mt 17,2", "Byl proměněn před nimi, jeho tvář zářila jako slunce", lambda: [
    mountain(120, G, 200, 50), J(120, 0, "open", g=G - 48, h=50), rays(120, G - 74, 16, 40, 0, 360, 14), man(50, 1, "cry", "bow", h=40), man(195, -1, "cry", "bow", h=40), gr()])
A("Mk 8,23", "Vzal slepého za ruku a vyvedl ho ven z vesnice", lambda: [
    gr(), J(90, 1, [(60, 90), (10, 5)], "walk", h=58), man(125, 1, "reach", "walk", h=52), tree(200, G, 50), tree(225, G, 36), house(30, G, 30, 22)])
A("Sk 5,15", "Nemocné vynášeli na ulice, aby na ně padl aspoň Petrův stín", lambda: [
    gr(), man(80, 1, "bless", "walk", h=56), bed(150, G, 50), man(140, 1, "down", "lie", g=G - 6, h=40), sun(30, 20, 8), smooth([(90, G + 2), (130, G + 4)])])
A("Sk 14,27", "Vyprávěli, jak Bůh otevřel pohanům dveře víry", lambda: [gr(), door(60, G, 24, 44), man(110, 1, "open", h=56), crowd(140, 235, G, 34)])
A("Sk 21,40", "Pavel stál na schodech a pokynul lidu rukou", lambda: [
    *[[(40 + i * 14, G - i * 8), (54 + i * 14, G - i * 8), (54 + i * 14, G - (i + 1) * 8)] for i in range(5)], man(118, 1, "bless", g=G - 40, h=46),
    crowd(140, 235, G, 34), gr()])
A("Sk 26,28", "Agrippa řekl Pavlovi: Ještě chvíli a přesvědčíš mě", lambda: [
    gr(), man(80, 1, "open", h=56), chain(60, G - 2, 40, G, 3), king(160, -1, "down", "sit", h=54), throne(160, G, 40, -1), woman(205, -1, "down", "sit", h=46, crown=True)])
A("1K 8,1", "Poznání nadýmá, ale láska buduje", lambda: [gr(), wall(110, 210, G, 40, 4), heart(160, G - 60, 10), man(70, 1, "carry", h=52)])
A("2K 3,3", "Jste dopis Kristův, psaný Duchem živého Boha na deskách srdce", lambda: [heart(120, 70, 30), *[[(104, 56 + i * 8), (136, 56 + i * 8)] for i in range(3)], bird(120, 22, 1, 1, True)])
A("2K 8,15", "Kdo nasbíral mnoho, neměl nazbyt, kdo málo, neměl nedostatek", lambda: [
    gr(), basket(80, G, 18, 10), basket(150, G, 18, 10), man(50, 1, "give", h=52), woman(185, -1, "reach", h=46), *[circle(x, G - 1, 1)[0] for x in (100, 115, 130)]])
A("Ef 5,8", "Kdysi jste byli tma, nyní jste světlo v Pánu – žijte jako děti světla", lambda: [
    gr(), kid(90, 1, "raise", h=32), kid(130, -1, "raise", h=30), sun(110, 30, 10), rays(110, 30, 14, 30, 0, 360, 12), moon(30, 30, 6)])
