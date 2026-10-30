"""Ilustrace do zbývajících kapitol: proroci (Izajáš – Malachiáš).

Odkazy jsou v číslování Bible kralické, K() je převede na kanonické.
"""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import K

# --- Izajáš -------------------------------------------------------------------
K("Iz 1,3", "Vůl zná svého vlastníka a osel jesle svého pána, ale Izrael nezná", lambda: [
    gr(), ox(80, G, 1.2, 1), donkey(150, G, 1, -1), manger(115, G, 30), man(210, -1, "back", h=52)])
K("Iz 3,10", "Spravedlivému se povede dobře, bude jíst ovoce svých činů", lambda: [
    gr(), man(80, 1, "hold", h=54), basket(102, G - 30, 18, 10, 4), tree(170, G, 56), sun(220, 25, 8)])
K("Iz 5,2", "Okopal vinici, vybral kamení, vysázel révu a postavil věž", lambda: [
    gr(), hills(0, 240, G - 2, 20), tower(190, G - 6, 20, 50), vine(20, G - 40, 160, 4), [(40, G - 10), (40, G - 40)], [(140, G - 10), (140, G - 40)], stones(20, G, 2)])
K("Iz 8,6", "Tento lid pohrdl tiše plynoucí vodou Šíloachu", lambda: [
    gr(0, 80), waves(80, 240, G, 8, 1), waves(80, 240, G + 6, 8, 1), man(50, 1, "back", h=54), city(150, 235, G - 20, 26)])
K("Iz 10,15", "Chlubí se sekera nad tím, kdo jí seká?", lambda: [
    gr(), man(90, 1, [(150, 160), (140, 150)], h=56), [(96, G - 76), (112, G - 92)], [(108, G - 96), (118, G - 88), (114, G - 84)], tree(170, G, 60)])
K("Iz 13,10", "Hvězdy nebudou zářit, slunce se při východu zatmí", lambda: [
    circle(80, 50, 14), circle(80, 50, 9), moon(170, 40, 9), stars([(130, 20), (210, 70)]), gr(), hills(0, 240, G, 10)])
K("Iz 15,2", "Moáb kvílí na výšinách", lambda: [
    gr(), hills(80, 240, G, 30), man(140, 1, "cry", h=44, g=G - 26), woman(170, -1, "cry", h=40, g=G - 28), city(0, 70, G, 30)])
K("Iz 17,6", "Zůstanou paběrky jako při česání olivy – dvě tři olivy na vršku", lambda: [
    gr(), tree(120, G, 80), circle(118, G - 76, 2), circle(126, G - 72, 2), man(190, -1, [(150, 160), (20, 10)], h=52, staff=0)])
K("Iz 19,8", "Rybáři naříkají, ti, kdo házejí udice do Nilu", lambda: [
    gr(), man(80, 1, "cry", "sit", h=46), [(100, G - 30), (150, G - 50)], [(150, G - 50), (150, G - 6)], waves(120, 240, G, 6, 1), reeds(200, 240, G, 3)])
K("Iz 21,11", "Strážce, kolik zbývá z noci?", lambda: [
    gr(), tower(150, G, 30, 60), man(150, 0, "down", g=G - 60, h=30), man(60, 1, "point", h=50), moon(210, 20, 8), stars([(40, 20), (100, 35)])])
K("Iz 23,1", "Kvílejte, taršíšské lodě", lambda: [
    sea(0, 240, G - 4, 3), boat(70, G - 10, 60, True), boat(180, G - 10, 50, True), cloud(120, 25, 40)])
K("Iz 25,6", "Hospodin připraví na této hoře hostinu pro všechny národy", lambda: [
    mountain(120, G, 220, 60), table(120, G - 58, 70, 12), bread(105, G - 72, 6), cup(130, G - 70), crowd(10, 70, G, 32), crowd(170, 235, G, 32), gr()])
K("Iz 27,3", "Já, Hospodin, jsem strážcem vinice, každou chvíli ji zavlažuji", lambda: [
    gr(), vine(20, G - 40, 200, 4), [(40, G), (40, G - 40)], [(180, G), (180, G - 40)], cloud(120, 20, 40), rain(90, 160, 30, 70, 6)])
K("Iz 29,18", "Hluší uslyší slova knihy a oči slepých uvidí", lambda: [
    gr(), man(80, 1, "hold", h=54), book(100, G - 36, 18, 12), man(150, -1, "raise", h=52), man(195, -1, "open", h=50), sun(220, 25, 7)])
K("Iz 31,5", "Jako ptáci rozpínající křídla ochrání Hospodin Jeruzalém", lambda: [
    gr(), city(40, 200, G, 40), bird(80, 40, 1.6), bird(150, 30, 1.8, -1), bird(200, 50, 1.2, -1)])
K("Iz 33,17", "Tvé oči spatří krále v jeho kráse", lambda: [
    gr(), king(150, -1, "bless", h=60), rays(150, G - 60, 6, 20, 0, 360, 10), man(70, 1, "raise", h=52), hills(0, 240, G - 2, 6)])
K("Iz 35,6", "Chromý poskočí jako jelen a na poušti vytrysknou vody", lambda: [
    gr(), man(80, 1, "raise", h=54), deer(160, G, 1.2, 1), waves(150, 240, G - 2, 5), plant(30, G, 16), flowers(200, 240, G, 3)])
K("Iz 37,1", "Chizkijáš roztrhl své roucho a vešel do Hospodinova domu", lambda: [
    gr(), king(90, 1, "cry", "walk", h=56), temple(180, G, 80, 40)])
K("Iz 39,2", "Chizkijáš ukázal poslům všechny své poklady", lambda: [
    gr(), king(80, 1, "point", h=56), coins(130, G - 2, 6), jar(160, G, 0.7), cup(180, G - 6), man(215, -1, "open", h=50)])
K("Iz 42,3", "Nalomenou třtinu nedolomí, doutnající knot neuhasí", lambda: [
    gr(), reeds(30, 110, G, 4), [(130, G), (130, G - 20), (138, G - 30)], lamp(180, G - 10, 1.4), smooth([(184, G - 18), (182, G - 26), (186, G - 32)], 3)])
K("Iz 44,17", "Ze zbytku dřeva si udělá boha a klaní se mu", lambda: [
    gr(), flames(60, G - 2, 20), man(110, 1, "pray", "bow", h=44), pillar(170, G, 30, 8), circle(170, G - 34, 5)])
K("Iz 46,4", "Až do stáří jsem to já, ponesu vás", lambda: [
    gr(), man(120, 0, "carry", h=58), man(120, 0, "down", "sit", g=G - 58, h=22), sun(200, G - 10, 10), path(0, G, 240, G - 6, 14, 6)])
K("Iz 48,18", "Kéž bys pozoroval má přikázání! Tvůj pokoj by byl jako řeka", lambda: [
    gr(0, 80), waves(80, 240, G - 2, 8), waves(80, 240, G + 4, 8), man(50, 1, "open", h=54), tree(110, G - 6, 34)])
K("Iz 50,4", "Každé ráno mi probouzí ucho, abych naslouchal jako učedník", lambda: [
    gr(), man(110, 1, "down", "sit", h=48), sun(200, G - 6, 12), book(140, G - 20, 16, 10), bird(60, 40, 1)])
K("Iz 52,8", "Tvoji strážní pozvedají hlas a společně jásají", lambda: [
    gr(), wall(20, 220, G, 40, 4), man(70, 1, "raise", g=G - 40, h=34), man(120, 1, "raise", g=G - 40, h=34), man(170, -1, "raise", g=G - 40, h=34), sun(210, 20, 7)])
K("Iz 54,2", "Rozšiř prostor svého stanu a roztáhni plachty", lambda: [
    gr(), tent(120, G, 100, 40), [(70, G - 20), (40, G)], [(170, G - 20), (200, G)], woman(30, 1, "reach", h=46), man(215, -1, "reach", h=50)])
K("Iz 57,15", "Přebývám na výšině, ale i se zkroušeným a pokorným", lambda: [
    gr(), man(120, 1, "pray", "kneel", h=46), rays(120, 10, 6, 50, 50, 130, 7), mountain(210, G, 60, 50)])
K("Iz 59,1", "Hospodinova ruka není krátká, aby nemohla zachránit", lambda: [
    sea(0, 240, G, 3), man(100, 0, "raise", g=G + 10, h=50)[:10], hand(150, 50, 2, False), cloud(170, 25, 40)])
K("Iz 61,1", "Poslal mě obvázat ty, kdo mají zlomené srdce", lambda: [
    gr(), man(90, 1, "give", h=56), man(150, -1, "cry", "sit", h=44), heart(122, 40, 7), rays(90, 15, 4, 20, 40, 140, 5)])
K("Iz 63,3", "Lis jsem šlapal sám", lambda: [
    gr(), [(70, G), (80, G - 24), (170, G - 24), (180, G)], man(125, 1, "wide", "walk", g=G - 18, h=50), grapes(80, G - 30, 1), grapes(170, G - 30, 1)])
K("Iz 65,17", "Stvořím nová nebesa a novou zemi", lambda: [
    sun(120, 40, 14), rays(120, 40, 18, 34, 0, 360, 14), tree(40, G, 46), tree(200, G, 40, "palm"), flowers(70, 170, G, 6), gr()])

# --- Jeremjáš, Pláč --------------------------------------------------------------
K("Jr 3,15", "Dám vám pastýře podle svého srdce", lambda: [
    gr(), man(80, 1, "bless", h=54, staff=1), sheep(130, G, 1), sheep(160, G, 0.9, -1), sheep(190, G, 0.9), heart(80, 30, 6)])
K("Jr 5,22", "Moři jsem dal za hranici písek", lambda: [
    sea(120, 240, G - 4, 4), *[circle(x, G + 2, 0.8)[0] for x in range(20, 120, 9)], gr(0, 120), man(50, 1, "point", h=50)])
K("Jr 7,2", "Postav se v bráně Hospodinova domu a volej", lambda: [
    gr(), temple(160, G, 80, 44), man(100, 1, "open", h=56), crowd(10, 70, G, 36)])
K("Jr 9,23", "Ať se moudrý nechlubí svou moudrostí ani bohatý svým bohatstvím", lambda: [
    gr(), man(60, 1, "hold", h=54), book(80, G - 34, 16, 10), man(120, 1, "hold", h=54), coins(140, G - 34, 3), man(190, -1, "pray", "kneel", h=46)])
K("Jr 11,16", "Hospodin tě nazval zelenou olivou, krásnou a plodnou", lambda: [
    gr(), tree(120, G, 80), *[circle(x, y, 2)[0] for x, y in ((100, 70), (130, 60), (145, 80), (110, 90))], sun(210, 25, 8)])
K("Jr 13,7", "Vykopal jsem pás u Eufratu a byl zničený", lambda: [
    gr(0, 140), man(70, 1, [(80, 100), (60, 90)], "kneel", h=48), [(100, G - 2), (130, G - 4)], waves(140, 240, G, 6)])
K("Jr 15,16", "Našel jsem tvá slova a snědl je, byla mi radostí", lambda: [
    gr(), man(110, 1, "hold", h=56), scroll(132, G - 36, 24, 14), heart(150, 40, 6)])
K("Jr 17,8", "Bude jako strom zasazený u vody, který vyhání kořeny k potoku", lambda: [
    gr(0, 140), tree(90, G, 70), smooth([(90, G), (110, G + 6), (130, G + 4)], 3), waves(140, 240, G, 6), sun(200, 25, 10)])
K("Jr 20,9", "Bylo to v mém srdci jako hořící oheň zavřený v kostech", lambda: [
    gr(), man(110, 1, "cry", h=56), flames(110, G - 30, 12), heart(110, G - 36, 5)])
K("Jr 22,13", "Běda tomu, kdo staví svůj dům nespravedlností", lambda: [
    gr(), house(150, G, 80, 56), king(70, 1, "point", h=56), man(210, -1, "carry", h=48)])
K("Jr 24,2", "Dva koše fíků: jeden velmi dobré, druhý velmi špatné", lambda: [
    gr(), basket(90, G, 30, 16, 5), basket(160, G, 30, 16, 5), man(210, -1, "point", h=52), temple(30, G, 40, 26)])
K("Jr 26,8", "Kněží a proroci se Jeremjáše chopili: Musíš zemřít!", lambda: [
    gr(), man(120, 1, "open", h=54), man(70, 1, "point", h=54), man(170, -1, "point", h=54), temple(215, G, 40, 30)])
K("Jr 28,10", "Chananjáš vzal Jeremjášovi z šíje jho a zlomil je", lambda: [
    gr(), man(80, 1, "down", h=54), man(150, -1, "raise", h=56), [(130, G - 70), (145, G - 64)], [(155, G - 64), (170, G - 70)], crowd(180, 240, G, 30)])
K("Jr 31,33", "Vložím svůj zákon do jejich nitra a napíšu ho na jejich srdce", lambda: [
    gr(), heart(120, 60, 16), [(110, 56), (130, 56)], [(108, 62), (132, 62)], [(112, 68), (128, 68)], man(60, 1, "pray", h=50), man(185, -1, "pray", h=50)])
K("Jr 33,3", "Volej ke mně a odpovím ti", lambda: [
    gr(), man(100, 1, "raise", "kneel", h=48), rays(160, 15, 6, 40, 40, 140, 7), wall(170, 240, G, 40, 4)])
K("Jr 35,6", "Rekabovci: Víno nepijeme", lambda: [
    gr(), table(120, G, 70, 16), cup(105, G - 16), cup(130, G - 16), jar(150, G - 16, 0.5), man(60, 1, "back", h=54), man(190, -1, "back", h=54)])
K("Jr 37,21", "Jeremjáš dostával každý den bochník chleba z ulice pekařů", lambda: [
    gr(), wall(0, 240, G, 60, 6)[:2], man(90, 1, "reach", "sit", h=46), man(150, -1, "give", h=54), bread(126, G - 32, 7)])
K("Jr 40,4", "Dnes ti rozvazuji pouta z rukou", lambda: [
    gr(), man(90, 1, "raise", h=54), chain(110, G - 2, 140, G, 3), man(170, -1, "point", h=56), spear(190, G, 60)])
K("Jr 42,3", "Ať nám Hospodin oznámí cestu, po které máme jít", lambda: [
    gr(), man(80, 1, "pray", h=54), crowd(110, 235, G, 40), path(0, G, 60, G - 10, 10, 3)])
K("Jr 44,17", "Budeme pálit kadidlo královně nebes", lambda: [
    gr(), woman(80, 1, "give", h=48), bread(104, G - 28, 6), altar(140, G, 20, 12, False, True), moon(150, 30, 9), man(200, -1, "point", h=54)])
K("Jr 46,4", "Zapřahejte koně, nasaďte přilby", lambda: [
    gr(), horse(80, G, 1.3, 1), man(140, 1, "hold", h=54), helmet(140, G - 60, 1), shield(160, G - 30, 1), spear(180, G, 60)])
K("Jr 48,11", "Moáb byl jako víno, které nikdo nepřelil z nádoby do nádoby", lambda: [
    gr(), jar(90, G, 1.4), jar(140, G, 1.2), jar(185, G, 1), hills(0, 60, G - 2, 10)])
K("Jr 50,2", "Babylón je dobyt, Bél zahanben", lambda: [
    gr(), city(130, 240, G, 40), rotate(pillar(80, G, 40, 10), 70, 80, G), man(40, 1, "raise", h=50)])
K("Jr 52,33", "Jójakín odložil vězeňský oděv a jídal u královského stolu", lambda: [
    gr(), table(120, G, 80, 16), king(70, 1, "down", "sit", h=50), king(180, -1, "give", "sit", h=50), bread(115, G - 19, 7), cup(135, G - 16)])
K("Pl 2,19", "Vylévej své srdce jako vodu před Panovníkem", lambda: [
    gr(), woman(110, 1, "raise", "kneel", h=44), moon(200, 22, 7), heart(130, 40, 6), smooth([(130, 48), (128, 60), (132, 72)], 3)])
K("Pl 4,4", "Děti prosí o chléb, ale nikdo jim ho nelámá", lambda: [
    gr(), kid(90, 1, "reach", h=30), kid(120, 1, "reach", h=26), woman(60, 1, "cry", "sit", h=44), city(150, 240, G, 30)])

# --- Ezechiel -----------------------------------------------------------------
K("Ez 3,3", "Snědl jsem svitek a byl mi v ústech sladký jako med", lambda: [
    gr(), man(110, 1, "hold", h=56), scroll(132, G - 40, 20, 12), hand(160, 40, 1.2, False)])
K("Ez 5,1", "Vezmi ostrý meč, ostříhej si hlavu a vousy a zvaž vlasy", lambda: [
    gr(), man(80, 1, "hold", h=54), sword(96, G - 40, 24, -30), scales(170, 50, 1.6)])
K("Ez 7,23", "Udělej řetěz, neboť země je plná krvavých soudů", lambda: [
    gr(), man(80, 1, "hold", h=54), chain(100, G - 30, 170, G - 10, 7), city(170, 240, G, 30)])
K("Ez 9,4", "Udělej znamení na čela mužů, kteří vzdychají", lambda: [
    gr(), man(90, 1, "reach", h=56), man(150, -1, "cry", h=52), man(185, -1, "cry", h=50), [(147, G - 52), (153, G - 46)], [(153, G - 52), (147, G - 46)]])
K("Ez 11,23", "Hospodinova sláva vystoupila z města a stanula na hoře na východ", lambda: [
    gr(), city(10, 110, G, 34), mountain(180, G, 100, 50), rays(180, G - 60, 6, 26, 0, 360, 10), cloud(180, G - 60, 30)])
K("Ez 13,11", "Zeď omítnutá vápnem padne pod prudkým lijákem", lambda: [
    gr(), wall(60, 180, G, 40, 4, broken=True), cloud(120, 25, 60), rain(70, 180, 40, 80, 10), man(210, -1, "cry", h=50)])
K("Ez 15,4", "Dřevo vinné révy je dobré jen do ohně", lambda: [
    gr(), flames(120, G - 2, 30), [(100, G - 6), (140, G - 2)], [(105, G - 2), (135, G - 8)], man(60, 1, "point", h=52)])
K("Ez 17,23", "Zasadím výhonek cedru na vysoké hoře a ptáci budou hnízdit pod ním", lambda: [
    mountain(120, G, 200, 50), tree(120, G - 48, 60), bird(90, 40, 1), bird(150, 30, 1.2, -1), gr()])
K("Ez 19,2", "Tvá matka byla lvice mezi lvy a vychovávala svá mláďata", lambda: [
    gr(), lion(100, G, 1.5, 1), lion(160, G, 0.7, -1), lion(190, G, 0.7, -1)])
K("Ez 21,9", "Meč, meč je nabroušen a vyleštěn", lambda: [
    gr(), sword(120, 60, 60, -60), sparkle(150, 30), sparkle(100, 90), man(60, 1, "cry", h=52)])
K("Ez 23,4", "Dvě sestry – Samaří a Jeruzalém", lambda: [
    gr(), city(10, 100, G, 34), city(140, 230, G, 34), heart(120, 40, 6)])
K("Ez 25,5", "Rabu učiním pastvinou velbloudů", lambda: [
    gr(), wall(120, 220, G, 20, 2, broken=True), camel(60, G, 1.2, 1), camel(110, G, 1, 1)])
K("Ez 27,5", "Tvou loď udělali z cypřišů, stěžeň z libanonského cedru", lambda: [
    sea(0, 240, G, 3), boat(120, G - 6, 110, True), sun(40, 25, 8)])
K("Ez 29,4", "Faraone, velký netvore v Nilu, dám ti do čelistí háky", lambda: [
    waves(0, 240, G - 4, 8), dragon(120, 90, 1.4), [(170, 60), (170, 80), (164, 86)]])
K("Ez 31,3", "Asýrie byla jako cedr na Libanonu s krásnými větvemi", lambda: [
    gr(), tree(120, G, 100), bird(90, 30, 1), bird(160, 40, 1, -1), mountain(220, G, 50, 40)])
K("Ez 33,7", "Ustanovil jsem tě strážným pro dům izraelský", lambda: [
    gr(), wall(40, 200, G, 40, 4), man(120, 1, "hold", g=G - 40, h=40), trumpet(132, G - 70, 20, -25, 1), city(0, 40, G, 30)])
K("Ez 35,3", "Pohoří Seír, učiním tě pustinou", lambda: [
    gr(), mountain(130, G, 160, 70), stones(40, G, 3), stones(200, G, 3), hand(130, 30, 1.2, False)])
K("Ez 39,9", "Budou pálit zbraně – štíty, luky a kopí", lambda: [
    gr(), flames(120, G - 4, 40), shield(100, G - 8, 0.8), spear(140, G - 4, 40, -20), man(50, 1, "give", h=52), man(200, -1, "hold", h=52)])
K("Ez 41,18", "Na stěnách byli cherubové a palmy", lambda: [
    gr(), [(20, G), (20, G - 70), (220, G - 70), (220, G)], tree(70, G, 50, "palm"), angel(120, 0, "wide", h=50), tree(170, G, 50, "palm")])
K("Ez 43,2", "Sláva Boha Izraele přicházela od východu a země zářila", lambda: [
    gr(), temple(80, G, 80, 40), sun(200, 50, 12), rays(200, 50, 16, 40, 100, 260, 9), hills(140, 240, G - 2, 8)])
K("Ez 46,1", "Brána vnitřního nádvoří bude otevřena v den odpočinku", lambda: [
    gr(), gate(120, G, 44, 56), wall(0, 98, G, 40, 4), wall(142, 240, G, 40, 4), sun(200, 20, 8)])
K("Ez 48,35", "Jméno města bude od toho dne: Hospodin je tam", lambda: [
    gr(), city(20, 220, G, 44), gate(120, G, 30, 40), rays(120, 30, 10, 30, 0, 360, 12)])

# --- Daniel, Ozeáš, Jóel, Ámos -------------------------------------------------
K("Da 2,34", "Kámen se utrhl bez lidské ruky a rozdrtil sochu", lambda: [
    gr(), man(110, 0, "down", h=90), rock(160, G, 20, 16), mountain(210, G, 60, 50), [(150, G - 10), (125, G - 4)]])
K("Da 4,10", "Uprostřed země stál strom a jeho výška byla ohromná", lambda: [
    gr(), tree(120, G, 110), bird(90, 30, 1), bird(150, 40, 1, -1), deer(60, G, 1, 1), sheep(190, G, 0.9, -1)])
K("Da 9,3", "Obrátil jsem tvář k Panovníku Bohu v modlitbě a postu", lambda: [
    gr(), man(100, 1, "raise", "kneel", h=48), window(170, G - 50, 20, 20)])
K("Da 11,32", "Lid, který zná svého Boha, zůstane pevný", lambda: [
    gr(), crowd(40, 200, G, 40), man(120, 0, "raise", h=56), rock(120, G, 140, 6)])
K("Oz 2,14", "Vyvedu ji na poušť a promluvím k jejímu srdci", lambda: [
    gr(), hills(0, 240, G - 2, 14), woman(100, 1, "down", "walk", h=48), heart(150, 40, 7), sun(210, 25, 8)])
K("Oz 4,16", "Izrael se vzpírá jako vzpurná jalovice", lambda: [
    gr(), ox(110, G, 1.4, -1), rope(140, G - 20, 190, G - 30), man(200, -1, [(70, 90), (20, 10)], h=54)])
K("Oz 6,3", "Přijde k nám jako déšť, jako jarní déšť svlažující zemi", lambda: [
    gr(), cloud(120, 25, 60), rain(80, 170, 40, 100, 10), field(20, 230, G, 8)])
K("Oz 8,7", "Sejí vítr a budou sklízet vichřici", lambda: [
    gr(), man(70, 1, "give", "walk", h=54), smooth([(120, 90), (160, 70), (200, 80)], 3), smooth([(130, 60), (170, 40), (220, 55)], 3), smooth([(140, 110), (190, 100), (230, 110)], 3)])
K("Oz 10,12", "Sejte spravedlnost a žněte milosrdenství", lambda: [
    gr(), man(60, 1, "give", "walk", h=54), field(100, 230, G, 7), sun(210, 25, 8)])
K("Oz 13,3", "Budou jako ranní oblak, jako rosa, jako dým z okna", lambda: [
    gr(), house(120, G, 60, 40), smooth([(130, G - 46), (124, G - 60), (136, G - 74), (128, G - 90)], 4), cloud(60, 30, 30), sun(200, 30, 8)])
K("Jl 2,13", "Roztrhněte svá srdce, a ne svá roucha", lambda: [
    gr(), man(90, 1, "cry", "kneel", h=48), heart(150, 60, 12), [(150, 52), (146, 60), (152, 66), (150, 72)]])
K("Jl 3,18", "V ten den budou hory kapat moštem a pahorky oplývat mlékem", lambda: [
    gr(), mountain(80, G, 120, 60), hills(140, 240, G, 20), grapes(80, 60, 1.4), vine(140, G - 30, 230, 3), sheep(190, G, 0.8)])
K("Am 2,13", "Budu vás tlačit, jako tlačí vůz plný snopů", lambda: [
    gr(), [(70, G - 14), (170, G - 14)], circle(90, G - 7, 7), circle(150, G - 7, 7), wheat(100, G - 14, 24), wheat(120, G - 14, 26), wheat(140, G - 14, 24),
    ox(200, G, 1, 1)])
K("Am 4,13", "Ten, který tvoří hory, stvořil vítr a jitřní záři", lambda: [
    mountain(80, G, 120, 60), mountain(170, G, 100, 46), sun(210, 30, 10), smooth([(20, 40), (60, 30), (100, 40)], 3), gr()])
K("Am 6,4", "Leží na lůžkách ze slonoviny a jedí beránky ze stáda", lambda: [
    gr(), bed(100, G, 70), man(100, 1, "down", "lie", g=G - 6, h=44), table(170, G, 40, 14), cup(165, G - 14), sheep(215, G, 0.8, -1)])
K("Am 9,14", "Vystavějí zpustošená města a vysadí vinice", lambda: [
    gr(), house(60, G, 40, 30), man(110, 1, [(60, 100), (20, 40)], h=52), vine(140, G - 36, 230, 3), [(150, G), (150, G - 36)], [(220, G), (220, G - 36)]])

# --- Micheáš až Malachiáš ------------------------------------------------------
K("Mi 1,4", "Hory se pod ním rozplývají jako vosk před ohněm", lambda: [
    mountain(120, G, 160, 70), flames(120, G - 72, 20), smooth([(80, G - 30), (75, G - 10), (70, G)], 3), smooth([(160, G - 30), (166, G - 10), (170, G)], 3), gr()])
K("Mi 3,12", "Sijón bude zorán jako pole", lambda: [
    gr(), plough(120, G, 1), ox(170, G, 1, 1), field(10, 90, G, 5), stones(220, G, 2)])
K("Mi 7,19", "Všechny naše hříchy vrhne do hlubin moře", lambda: [
    sea(0, 240, G - 30, 5), stones(120, G + 10, 3), hand(120, 30, 1.4, False), [(120, 50), (120, 80)]])
K("Na 1,7", "Dobrý je Hospodin, záštita v den soužení", lambda: [
    gr(), tower(150, G, 30, 70), man(80, 1, "down", "walk", h=52), cloud(60, 25, 40), rain(30, 100, 40, 80, 6)])
K("Na 3,2", "Práskání biče, rachot kol a cválající koně", lambda: [
    gr(), horse(80, G, 1.3, 1, True), chariot(140, G, 1, 1), horse(190, G, 1, 1, True)])
K("Abk 1,2", "Jak dlouho, Hospodine, budu volat o pomoc?", lambda: [
    gr(), man(110, 1, "raise", h=56), cloud(160, 30, 40), city(170, 240, G, 30)])
K("Sf 2,3", "Hledejte Hospodina, všichni pokorní země", lambda: [
    gr(), man(70, 1, "pray", "kneel", h=46), woman(110, 1, "pray", "kneel", h=42), man(150, 1, "pray", "kneel", h=46), rays(200, 20, 6, 30, 120, 240, 6)])
K("Ag 2,9", "Sláva tohoto posledního domu bude větší než sláva prvního", lambda: [
    gr(), temple(120, G, 100, 50), rays(120, 40, 20, 40, 200, 340, 9), man(30, 1, "raise", h=46)])
K("Za 3,4", "Svlékněte z něho špinavý oděv – oblékám tě do slavnostního roucha", lambda: [
    gr(), man(120, 0, "open", h=58), angel(60, 1, "give", h=56), [(170, G), (180, G - 10), (200, G - 4), (210, G)]])
K("Za 7,10", "Neutiskujte vdovu, sirotka, cizince ani chudého", lambda: [
    gr(), woman(60, 1, "down", h=48), kid(90, 1, h=28), man(130, 1, "down", h=50, staff=0), man(180, -1, "reach", "sit", h=44), heart(120, 30, 6)])
K("Za 12,10", "Pohlédnou na toho, kterého probodli", lambda: [
    gr(), cross(120, G, 70), crowd(10, 90, G, 38), crowd(150, 235, G, 38), rays(120, 20, 6, 20, 0, 360, 10)])
K("Za 14,4", "Jeho nohy stanou na Olivové hoře a hora se rozpoltí", lambda: [
    mountain(80, G, 100, 60), mountain(170, G, 100, 60), [(125, G), (125, G - 30)], rays(125, 30, 6, 26, 0, 360, 12), gr()])
K("Mal 2,10", "Nemáme všichni jednoho Otce? Nestvořil nás jeden Bůh?", lambda: [
    gr(), crowd(30, 210, G, 40), man(60, 1, "wide", h=54), man(180, -1, "wide", h=54), rays(120, 15, 6, 30, 40, 140, 7)])

# kapitoly, které v číslování BKR začínají jinde než v hebrejském
K("Jon 2,10", "Ryba vyvrhla Jonáše na souš", lambda: [
    sea(100, 240, G, 3), gr(0, 100), fish(170, G - 10, 3, -1), man(70, 1, "raise", "kneel", h=44), sun(40, 25, 8)])
K("Na 2,4", "Vozy se řítí ulicemi jako blesky", lambda: [
    gr(), chariot(90, G, 1, 1), horse(130, G, 1, 1, True), chariot(170, G, 0.9, 1), horse(206, G, 0.9, 1, True), city(0, 60, G, 30)])
