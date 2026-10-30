"""Doplňkové ilustrace (každá druhá kapitola): proroci."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import A


def prophet(x, f=1, arms="open", h=56):
    return man(x, f, arms, h=h)


# --- Izajáš -------------------------------------------------------------------
A("Iz 4,6", "Stánek bude stínem ve dne před horkem a úkrytem před deštěm", lambda: [
    gr(), [(70, G), (70, G - 46)], [(170, G), (170, G - 46)], smooth([(60, G - 44), (120, G - 56), (180, G - 44)]), man(110, 1, "down", "sit", h=48),
    sun(210, 25, 10), cloud(40, 25, 30)])
A("Iz 7,14", "Panna počne a porodí syna a dá mu jméno Immanuel", lambda: [
    gr(), woman(110, 1, "hold", "sit", h=52), seat(110, G, 16, 14), circle(130, G - 34, 3.5), star(170, 30, 6), rays(170, 30, 9, 22, 0, 360, 10)])
A("Iz 12,3", "S radostí budete čerpat vodu z pramenů spásy", lambda: [
    gr(), well(120, G, 26), woman(80, 1, "hold", h=50), jar(100, G - 30, 0.6), man(160, -1, "raise", h=52), sun(210, 25, 8)])
A("Iz 14,12", "Jak jsi spadl z nebe, jitřenko, synu úsvitu!", lambda: [
    star(80, 20, 6), [(86, 26), (150, 90)], star(156, 96, 4), stars([(40, 40), (200, 30), (220, 70)]), gr(80, 240, G)])
A("Iz 16,5", "Trůn bude upevněn milosrdenstvím", lambda: [gr(), king(120, 1, "bless", "sit", h=58), throne(120, G, 46), heart(180, 50, 10)])
A("Iz 18,2", "Posílá posly po moři v papyrových člunech", lambda: [
    boat(100, G - 4, 60, mast=False), man(100, 1, [(90, 110), (60, 80)], g=G - 12, h=36), sea(0, 240, G, 3), reeds(190, 230, G - 4, 4)])
A("Iz 20,2", "Izajáš chodil bosý jako znamení", lambda: [
    gr(), man(110, 1, "down", "walk", h=58), path(120, G, 220, G - 30, 20, 3), crowd(10, 70, G, 30)])
A("Iz 22,22", "Položím mu na rameno klíč od Davidova domu", lambda: [
    gr(), man(110, 1, [(150, 170), (10, 5)], h=56), circle(120, G - 66, 5), [(124, G - 66), (150, G - 66)], [(146, G - 66), (146, G - 60)],
    [(140, G - 66), (140, G - 61)], door(190, G, 24, 40)])
A("Iz 24,14", "Pozvednou hlas a budou plesat nad Hospodinovou velebností", lambda: [
    gr(), crowd(10, 230, G, 44, 12), rays(120, 15, 6, 30, 30, 150, 7), sea(0, 240, G + 8, 1)])
A("Iz 26,3", "Toho, kdo je pevné mysli, chráníš v pokoji", lambda: [
    gr(), man(120, 0, "pray", "sit", h=50), rock(120, G, 30, 16), smooth([(20, 40), (60, 30), (100, 40)]), smooth([(150, 40), (190, 30), (230, 40)]), moon(200, 70, 6)])
A("Iz 28,24", "Oře oráč celý den, aby zasel?", lambda: [
    gr(), ox(150, G, 1.2, 1), plough(110, G, 1), man(80, 1, [(60, 90), (60, 90)], "walk", h=54), *[[(10, G + 4 + i * 4), (100, G + 4 + i * 4)] for i in range(3)]])
A("Iz 30,21", "Uslyšíš za sebou slovo: Toto je ta cesta, jděte po ní", lambda: [
    path(120, G + 6, 150, G - 50, 70, 4), path(150, G - 20, 230, G - 30, 14, 3), man(120, 1, "down", "walk", h=44), rays(60, 50, 4, 16, 0, 360, 8), gr(0, 70)])
A("Iz 32,2", "Každý bude jako úkryt před větrem a potoky vod v suché zemi", lambda: [
    rock(90, G, 70, 50), man(130, -1, "down", "sit", h=44), smooth([(150, G + 4), (190, G), (235, G + 5)]), smooth([(160, 40), (200, 34), (230, 42)]), gr(0, 50)])
A("Iz 34,16", "Hledejte v Hospodinově knize a čtěte", lambda: [gr(), man(80, 1, "hold", "sit", h=54), seat(80, G, 16, 14), scroll(115, G - 36, 30, 14), lamp(170, G - 6, 1.4)])
A("Iz 36,13", "Rabšake stál a volal na lidi na hradbách", lambda: [
    gr(), wall(120, 230, G, 40, 4), crowd(130, 220, G - 40, 26), man(60, 1, "point", h=56, belt=True), spear(80, G, 60)])
A("Iz 38,8", "Stín na slunečních hodinách ustoupí o deset stupňů", lambda: [
    gr(), *[[(80 + i * 8, G - i * 6), (88 + i * 8, G - i * 6), (88 + i * 8, G - (i + 1) * 6)] for i in range(8)], sun(200, 30, 10),
    king(40, 1, "pray", h=50)])
A("Iz 41,10", "Neboj se, vždyť já jsem s tebou", lambda: [
    gr(), man(110, 1, "cry", "kneel", h=52), hand(160, G - 46, 1.6, False), rays(170, 20, 6, 24, 0, 360, 8)])
A("Iz 43,2", "Půjdeš-li přes vody, já budu s tebou", lambda: [
    sea(0, 240, G - 4, 3), man(110, 1, "down", "walk", g=G - 6, h=50)[:14], rays(110, 20, 6, 30, 40, 140, 7)])
A("Iz 45,9", "Řekne hlína svému hrnčíři: Co to děláš?", lambda: [gr(), potter(120, G, 56), hand(200, 40, 1.2, False)])
A("Iz 47,1", "Sestup a usedni do prachu, dcero babylonská", lambda: [
    gr(), woman(110, 1, "cry", "sit", h=50, crown=True), city(160, 235, G, 40), tower(200, G - 40, 14, 30)])
A("Iz 49,15", "I kdyby matka zapomněla na své dítě, já na tebe nezapomenu", lambda: [
    gr(), woman(110, 1, "hold", h=52), circle(130, G - 32, 3.5), hand(180, 50, 1.6, True), rays(180, 30, 6, 18, 0, 360, 8)])
A("Iz 51,11", "Vykoupení se vrátí s plesáním na Sijón", lambda: [
    gr(), path(30, G, 170, G - 40, 30, 4), man(80, 1, "raise", "walk", h=50), woman(110, 1, "raise", "walk", h=46), city(170, 235, G - 30, 30)])
A("Iz 56,7", "Můj dům bude nazván domem modlitby pro všechny národy", lambda: [
    gr(), temple(120, G, 90, 50), crowd(10, 70, G, 30), crowd(175, 235, G, 30)])
A("Iz 58,7", "Lámat chléb hladovému a uvést do domu bezdomovce", lambda: [
    gr(), house(50, G, 50, 36), man(110, 1, "give", h=54), bread(134, G - 32, 8), man(170, -1, "reach", h=48), kid(195, -1, "reach", h=28)])
A("Iz 60,1", "Vstaň, rozjasni se, neboť přišlo tvé světlo", lambda: [
    sun(170, 50, 16), rays(170, 50, 20, 40, 0, 360, 14), gr(), woman(90, 1, "raise", h=52), city(10, 60, G, 30)])
A("Iz 62,3", "Budeš skvostnou korunou v Hospodinově ruce", lambda: [hand(120, 90, 3, True), crown(120, 64, 30), rays(120, 54, 22, 34, 180, 360, 8)])
A("Iz 64,7", "My jsme hlína, ty jsi náš hrnčíř", lambda: [hand(120, 70, 2.6, False), jar(120, G, 1.8), gr(60, 180)])

# --- Jeremjáš, Pláč -----------------------------------------------------------
A("Jr 2,13", "Opustili pramen živé vody a vytesali si děravé cisterny", lambda: [
    gr(), smooth([(10, G + 4), (50, G), (90, G + 5)]), well(60, G - 30, 20)[:0], [(140, G), (140, G - 20), (190, G - 20), (190, G)],
    [(150, G - 20), (155, G - 10), (150, G)], man(110, 1, "cry", h=52)])
A("Jr 4,3", "Rozorejte si úhor a nesejte do trní", lambda: [gr(), ox(140, G, 1.2, 1), plough(100, G, 1), man(70, 1, [(60, 90), (60, 90)], "walk", h=54), bush(210, G, 24)])
A("Jr 6,16", "Zastavte se na cestách a ptejte se na stezky starodávné", lambda: [
    gr(), path(120, G, 40, G - 50, 20, 3), path(120, G, 200, G - 50, 20, 3), man(120, 1, "pray", h=50), tree(30, G - 52, 20)])
A("Jr 8,7", "I čáp na nebi zná svůj čas, ale můj lid nezná Hospodinův řád", lambda: [
    gr(), bird(80, 40, 2.4), bird(130, 30, 2), bird(170, 45, 1.8), man(200, -1, "point", h=52)])
A("Jr 10,13", "Když zahřmí, hučí vody na nebi; vyvádí mraky od konce země", lambda: [
    cloud(120, 30, 80), rain(70, 170, 44, 90, 12), [(90, 40), (82, 56), (92, 56), (80, 76)], gr(), hills(0, 240, G - 2, 10)])
A("Jr 12,5", "Běžel jsi s pěšáky a unavili tě – jak budeš závodit s koňmi?", lambda: [
    gr(), man(60, 1, [(110, 60), (-60, -20)], "walk", h=52, beard=False), horse(150, G, 1.4, 1, True), horse(200, G, 1.3, 1, True)])
A("Jr 14,4", "Půda popraskala, protože nebyl déšť, oráči si zahalují hlavu", lambda: [
    gr(), *[[(x, G + 2), (x + 8, G + 8), (x + 4, G + 14)] for x in (40, 80, 150, 190)], man(110, 1, "cry", h=54, veil=True), sun(200, 25, 12)])
A("Jr 16,16", "Pošlu mnoho rybářů, kteří je vyloví", lambda: [
    boat(110, G - 4, 80), man(100, 1, [(60, 120), (60, 120)], g=G - 14, h=36), nets(150, G + 4, 30, 12), sea(0, 240, G, 3), fish(140, G + 12, 0.6)])
A("Jr 19,10", "Rozbij džbán před očima mužů", lambda: [
    gr(), man(90, 1, "raise", h=56), [(130, G - 2), (136, G - 10), (142, G - 2)], [(150, G), (154, G - 8), (160, G - 1)], [(120, G), (126, G - 6)],
    man(180, -1, h=52), man(205, -1, h=50)])
A("Jr 21,8", "Předkládám vám cestu života a cestu smrti", lambda: [
    gr(), path(120, G, 50, G - 50, 20, 3), path(120, G, 190, G - 50, 20, 3), man(120, 1, "open", h=46), sun(50, 30, 7)])
A("Jr 23,29", "Není mé slovo jako kladivo, které tříští skálu?", lambda: [
    gr(), rock(150, G, 50, 30), [(150, G - 30), (146, G - 20), (154, G - 10)], [(100, G - 60), (130, G - 38)], [(94, G - 66), (110, G - 54)],
    [(110, G - 54), (104, G - 70)], rays(150, G - 30, 6, 16, 180, 360, 6)])
A("Jr 25,4", "Posílal jsem k vám proroky, ale neposlouchali jste", lambda: [
    gr(), prophet(70, 1), man(140, -1, "back", h=52), man(170, 1, "back", h=50), man(200, 1, "back", h=52)])
A("Jr 27,2", "Udělej si pouta a jha a vlož si je na šíji", lambda: [
    gr(), man(120, 0, [(80, 100), (80, 100)], h=56), [(84, G - 46), (156, G - 46)], [(86, G - 42), (154, G - 42)], rope(84, G - 46, 80, G - 30)])
A("Jr 30,17", "Dám ti zahojit rány a uzdravím tě", lambda: [gr(), man(120, -1, "raise", "kneel", h=52), hand(70, 50, 1.6, False), rays(70, 30, 6, 20, 0, 360, 8)])
A("Jr 32,9", "Koupil jsem pole v Anatótu a navážil stříbro", lambda: [
    gr(), field(150, 235, G, 6), scales(90, 40, 1.4), man(50, 1, "give", h=54), coins(80, G - 6, 3)])
A("Jr 34,8", "Vyhlásili propuštění otroků na svobodu", lambda: [
    gr(), man(110, 1, "raise", h=54), chain(80, G - 2, 60, G, 4), chain(140, G - 2, 160, G, 4), king(190, -1, "bless", h=54)])
A("Jr 36,23", "Král odřezával sloupce svitku a házel je do ohně", lambda: [
    gr(), king(80, 1, "hold", "sit", h=56), throne(80, G, 44), flames(150, G - 4, 20), stones(150, G, 3), scroll(110, G - 36, 20, 10)])
A("Jr 39,8", "Babylonští spálili královský dům a zbořili hradby Jeruzaléma", lambda: [
    gr(), wall(40, 200, G, 30, 3, broken=True), flames(80, G - 30, 20), flames(160, G - 30, 24), stones(120, G, 4)])
A("Jr 41,12", "Jóchanan je dostihl u velkých vod v Gibeónu", lambda: [
    gr(0, 120), sea(120, 240, G + 4, 3), man(60, 1, "point", "walk", h=54), crowd(130, 200, G - 6, 20)[:0], man(100, 1, "down", "walk", h=50)])
A("Jr 43,9", "Vezmi do ruky velké kameny a ukryj je v cihelně", lambda: [
    gr(), man(90, 1, "hold", h=54), rock(110, G - 32, 12, 8), wall(140, 220, G, 20, 3)])
A("Jr 45,1", "Bárúk zapisoval Jeremjášova slova do knihy", lambda: [
    gr(), man(70, 1, "open", h=56), man(150, -1, [(60, 100), (40, 80)], "sit", h=50), scroll(125, G - 32, 22, 10), seat(150, G, 14, 13)])
A("Jr 47,6", "Meči Hospodinův, vrať se do své pochvy, uklidni se", lambda: [gr(80, 160), sword(120, G - 20, 50, 0), [(110, G - 20), (110, G), (130, G), (130, G - 20)]])
A("Jr 49,16", "Ty, který bydlíš ve skalních rozsedlinách na vrcholu pahorku", lambda: [
    mountain(120, G, 160, 90), eagle(130, 40, 1.4), *[[(x, G - 30), (x + 4, G - 40)] for x in (90, 150)], gr()])
A("Jr 51,63", "Přivaž ke svitku kámen a hoď ho do Eufratu", lambda: [
    gr(0, 110), man(70, 1, [(130, 160), (100, 130)], h=56), scroll(150, 40, 20, 10), rock(150, 52, 8, 6), sea(110, 240, G + 4, 3)])
A("Pl 1,1", "Jak opuštěné sedí město, kdysi lidnaté!", lambda: [
    gr(), city(80, 220, G, 40), wall(40, 80, G, 14, 2, broken=True), woman(40, 1, "cry", "sit", h=44)])
A("Pl 5,21", "Obrať nás, Hospodine, k sobě, a my se obrátíme", lambda: [
    gr(), man(80, 1, "raise", "kneel", h=52), woman(120, 1, "raise", "kneel", h=48), sun(190, 40, 10), rays(190, 40, 14, 28, 0, 360, 10)])

# --- Ezechiel -----------------------------------------------------------------
A("Ez 2,9", "Viděl jsem ruku vztaženou ke mně a v ní svitek", lambda: [
    gr(), man(150, -1, "reach", h=56), hand(80, 50, 1.6, False), scroll(80, 76, 26, 12), rays(70, 30, 6, 20, 0, 360, 8)])
A("Ez 4,1", "Vezmi si cihlu a vyryj na ni město Jeruzalém", lambda: [
    gr(), man(80, 1, [(60, 110), (40, 90)], "kneel", h=54), [(110, G), (110, G - 14), (160, G - 14), (160, G)], city(118, 152, G - 3, 9, gate=False)])
A("Ez 6,3", "Hory izraelské, slyšte slovo Panovníka Hospodina", lambda: [mountain(160, G, 140, 70), mountain(220, G, 60, 40), gr(), prophet(60, 1)])
A("Ez 8,3", "Duch mě zvedl mezi zemí a nebem a přenesl do Jeruzaléma", lambda: [
    man(80, 1, "open", g=70, h=46), hand(70, 20, 1.2, False), smooth([(100, 60), (140, 50), (180, 60)]), city(130, 230, G, 34), gr()])
A("Ez 10,18", "Hospodinova sláva vyšla nad prahem chrámu", lambda: [
    gr(), temple(120, G, 90, 50), rays(120, 40, 10, 30, 0, 360, 12), wheel(60, G - 14, 12), wheel(180, G - 14, 12)])
A("Ez 12,7", "Vynesl jsem za soumraku zavazadlo vyhnanství otvorem ve zdi", lambda: [
    gr(), wall(30, 140, G, 50, 5), [(80, G), (80, G - 30), (100, G - 30), (100, G)], man(170, 1, "carry", "walk", h=54),
    [(158, G - 58), (182, G - 58), (182, G - 50), (158, G - 50), (158, G - 58)], moon(210, 20, 6)])
A("Ez 14,14", "Kdyby tam byli Noe, Daniel a Jób…", lambda: [
    gr(), man(60, 1, h=56), ark(60, 40, 40), man(120, 1, "pray", h=52), lion(120, 40, 0.6), man(180, 1, "cry", "sit", h=50), rock(180, G, 14, 10)])
A("Ez 16,6", "Šel jsem kolem, viděl tě a řekl jsem ti: Žij!", lambda: [
    gr(), man(80, 1, "reach", h=56), circle(140, G - 4, 4), bez((144, G - 4), (152, G - 6), (158, G)), rays(140, G - 4, 8, 16, 180, 360, 6)])
A("Ez 18,31", "Pořiďte si nové srdce a nového ducha", lambda: [heart(80, 60, 16), [(102, 60), (138, 60)], [(132, 54), (138, 60), (132, 66)], heart(170, 60, 20), rays(170, 56, 24, 34, 0, 360, 10)])
A("Ez 20,12", "Dal jsem jim své dny odpočinku jako znamení", lambda: [
    gr(), sun(120, G - 4, 16), rays(120, G - 4, 20, 34, 200, 340, 7), man(60, 1, "pray", "sit", h=46), woman(180, -1, "pray", "sit", h=44)])
A("Ez 22,30", "Hledal jsem muže, který by zazdil trhlinu a stál v ní", lambda: [
    gr(), wall(20, 100, G, 40, 4), wall(140, 220, G, 40, 4), man(120, 0, "wide", h=46)])
A("Ez 24,3", "Postav hrnec, postav ho a nalij do něj vodu", lambda: [
    gr(), flames(120, G - 4, 26), stones(120, G, 4), ellipse(120, G - 30, 22, 4), bez((98, G - 30), (120, G - 8), (142, G - 30)), man(60, 1, "point", h=54)])
A("Ez 26,5", "Týr bude místem, kde se suší sítě", lambda: [
    rock(100, G, 120, 20), nets(80, G - 22, 30, 10), nets(130, G - 22, 30, 10), sea(140, 240, G + 4, 3), gr(0, 40)])
A("Ez 28,26", "Budou bydlet v bezpečí, stavět domy a sázet vinice", lambda: [
    gr(), house(60, G, 50, 36), vine(120, 70, 210, 3), [(120, 70), (120, G)], [(210, 72), (210, G)], man(160, 1, "raise", h=50)])
A("Ez 30,21", "Zlomil jsem paži faraona, egyptského krále", lambda: [gr(), king(120, 1, [(30, 90), (5, 0)], h=56), sword(180, G, 30, 120), tree(40, G, 40, "palm")])
A("Ez 32,2", "Jsi jako drak v moři, čeříš vodu", lambda: [sea(0, 240, G - 4, 3), dragon(130, G - 20, 2), reeds(10, 40, G - 6, 3)])
A("Ez 36,26", "Dám vám nové srdce a vložím do vás nového ducha", lambda: [heart(120, 60, 26), bird(120, 22, 1.2, 1, True), rays(120, 56, 32, 46, 0, 360, 12)])
A("Ez 38,8", "Lid shromážděný z národů bydlí v bezpečí", lambda: [gr(), hills(0, 240, G - 10, 20), house(60, G, 40, 30), house(110, G, 36, 26), house(160, G, 40, 30), sun(210, 25, 8)])
A("Ez 40,3", "Muž s lněnou šňůrou a měřicím prutem stál v bráně", lambda: [
    gr(), gate(170, G, 40, 50), man(100, 1, [(60, 90), (10, 5)], h=58), [(120, G - 10), (124, G - 70)], rope(80, G - 30, 60, G)])
A("Ez 42,15", "Vyměřil chrámový areál ze všech čtyř stran", lambda: [
    [(60, 30), (180, 30), (180, G), (60, G), (60, 30)], [(90, 60), (150, 60), (150, 100), (90, 100), (90, 60)], *[sparkle(x, y, 2) for x, y in ((60, 30), (180, 30), (180, G), (60, G))],
    man(30, 1, [(60, 90), (10, 5)], h=40)])
A("Ez 44,2", "Tato brána zůstane zavřená, protože jí vešel Hospodin", lambda: [gr(), gate(120, G, 70, 70), door(120, G, 30, 34), rays(120, 20, 8, 30, 40, 140, 7)])

# --- Daniel a Malí proroci ----------------------------------------------------
A("Da 8,3", "U řeky stál beran se dvěma rohy", lambda: [gr(), ram(110, G, 2, 1), [(124, G - 30), (130, G - 44)], [(128, G - 30), (138, G - 40)], sea(150, 240, G + 4, 2)])
A("Da 10,5", "Pozvedl jsem oči a hle, muž oblečený do lnu u řeky", lambda: [
    sea(0, 240, G + 4, 2), gr(0, 240, G - 6), man(150, -1, "down", g=G - 6, h=62, belt=True), rays(150, G - 56, 10, 24, 0, 360, 10), man(60, 1, "cry", "bow", g=G - 6, h=50)])
A("Oz 1,2", "Ozeáš si vzal za ženu Gomer", lambda: [gr(), man(100, 1, "give", h=56), woman(140, -1, "down", h=50), house(200, G, 40, 30)])
A("Oz 3,1", "Jdi a znovu miluj ženu, jak Hospodin miluje Izraele", lambda: [gr(), man(100, 1, "wide", h=56), woman(140, -1, "cry", h=50), heart(120, 30, 8)])
A("Oz 5,15", "Odejdu, dokud nebudou hledat mou tvář", lambda: [gr(), crowd(10, 120, G, 36), path(150, G, 220, G - 40, 20, 3), rays(210, 30, 6, 20, 0, 360, 8)])
A("Oz 7,11", "Efrajim je jako hloupá holubice", lambda: [bird(80, 60, 1.6, 1, True), bird(170, 50, 1.4, -1, True), city(10, 60, G, 30), city(180, 235, G, 30), gr()])
A("Oz 9,10", "Jako hrozny na poušti jsem našel Izraele", lambda: [gr(), grapes(120, 70, 2), hills(0, 240, G - 2, 12), sun(200, 25, 8)])
A("Oz 12,4", "Jákob v lůně chytil bratra za patu", lambda: [gr(), man(80, 1, "reach", "walk", h=50, beard=False), man(130, 1, "down", "walk", h=50), man(190, -1, "raise", h=40)[:0]])
A("Jl 1,4", "Co nechala housenka, sežraly kobylky", lambda: [gr(), field(20, 220, G, 9), locust(60, 50, 2), locust(130, 40, 2), locust(190, 60, 1.6)])
A("Am 1,1", "Slova Ámose, jednoho z pastýřů z Tekóy", lambda: [gr(), man(90, 1, "open", staff=1, h=56), sheep(140, G, 0.9), sheep(165, G, 0.8, -1), sheep(190, G, 0.8), tree(220, G, 40)])
A("Am 3,8", "Lev zařval – kdo by se nebál? Panovník promluvil – kdo by neprorokoval?", lambda: [gr(), lion(80, G, 1.6, 1), man(170, -1, "open", h=56)])
A("Am 8,1", "Ukázal mi koš letního ovoce", lambda: [gr(), basket(120, G, 40, 18), *[circle(105 + i * 7, G - 22, 3.5)[0] for i in range(5)], man(60, 1, "point", h=54)])
A("Mi 2,12", "Shromáždím je jako ovce v ohradě", lambda: [
    gr(), [(60, G), (60, G - 20), (180, G - 20), (180, G)], *[[(x, G), (x, G - 22)] for x in (80, 100, 120, 140, 160)], sheep(90, G, 0.8),
    sheep(130, G, 0.8, -1), sheep(160, G, 0.7), man(210, -1, staff=0, h=52)])
A("Sf 1,12", "Prohledám Jeruzalém s lampami", lambda: [gr(), city(80, 220, G, 40), lamp(50, G - 30, 1.6), man(40, 1, "hold", h=50), moon(200, 20, 6)])
A("Za 1,8", "V noci jsem uviděl muže na ryzém koni mezi myrtami", lambda: [
    gr(), horse(120, G, 1.6, 1), man(118, 1, "down", "sit", g=G - 16, h=44), bush(50, G, 30), bush(200, G, 30), moon(200, 20, 6)])
A("Za 5,1", "Pozvedl jsem oči a viděl letící svitek", lambda: [scroll(120, 50, 60, 24), smooth([(50, 70), (80, 60)]), smooth([(40, 50), (70, 44)]), gr(), man(60, 1, "point", h=50)])
A("Za 10,1", "Proste Hospodina o déšť v čase jarního deště", lambda: [cloud(140, 25, 70), rain(100, 180, 40, 80, 10), gr(), man(60, 1, "raise", h=54), field(120, 230, G, 6)])
A("Za 13,1", "Pro Davidův dům se otevře pramen k očištění", lambda: [
    gr(0, 80), gr(170, 240), smooth([(90, 40), (100, 80), (110, G), (160, G + 8)]), smooth([(100, 40), (112, 80), (124, G - 4), (170, G)]), man(50, 1, "raise", h=52)])
A("Mal 1,11", "Od východu slunce až na západ bude mé jméno veliké mezi národy", lambda: [
    sun(30, G - 8, 12), sun(210, G - 8, 12), gr(), crowd(60, 180, G, 34), smooth([(40, 40), (120, 20), (200, 40)])])
