"""Ilustrace do zbývajících kapitol: Jób, Žalmy, Přísloví, Kazatel, Píseň písní.

Odkazy jsou v číslování Bible kralické, K() je převede na kanonické.
"""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import K

# --- Jób ----------------------------------------------------------------------
K("Jb 1,21", "Hospodin dal, Hospodin vzal, buď jméno Hospodinovo požehnáno", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=50), house(200, G, 40, 30), stones(170, G, 2), sun(40, 25, 8)])
K("Jb 3,3", "Kéž by zanikl den, kdy jsem se narodil", lambda: [
    gr(), man(110, 1, "cry", "sit", h=48), cloud(60, 30, 40), cloud(180, 25, 40), rain(150, 220, 40, 90, 6)])
K("Jb 5,7", "Člověk se rodí k trápení, jako jiskry vzlétají vzhůru", lambda: [
    gr(), flames(130, G - 2, 30), *[circle(x, y, 1.2)[0] for x, y in ((120, 80), (138, 70), (128, 55), (145, 45), (118, 40))], man(70, 1, "down", "sit", h=46)])
K("Jb 7,6", "Mé dny míjejí rychleji než tkalcovský člunek", lambda: [
    gr(), man(80, 1, "cry", "sit", h=48), hourglass(160, 70, 1.6), sun(40, 25, 8), moon(220, 25, 7)])
K("Jb 9,9", "On učinil Velký vůz, Orion a Plejády", lambda: [
    stars([(30, 30), (50, 25), (70, 30), (90, 40), (85, 55), (60, 55), (150, 20), (160, 35), (170, 50), (190, 25), (200, 40), (215, 30)]), star(120, 70, 5),
    gr(), man(120, 0, "raise", h=40)])
K("Jb 11,7", "Dokážeš vystihnout hloubku Boží?", lambda: [
    sea(0, 240, G - 10, 4), fish(80, G + 4, 1), fish(170, G + 8, 0.8, -1), cloud(120, 25, 50), man(120, 0, "open", g=G - 14, h=30), rays(120, 25, 20, 40, 200, 340, 5)])
K("Jb 13,15", "I kdyby mě zabil, budu v něho doufat", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=48), cloud(140, 25, 50), rays(140, 30, 14, 40, 40, 140, 5), stones(60, G, 3)])
K("Jb 15,33", "Jako réva setřásá nezralé hrozny", lambda: [
    gr(), vine(40, G - 50, 200, 3), [(60, G), (60, G - 50)], [(180, G), (180, G - 50)], *[circle(x, G - 2, 2)[0] for x in (100, 112, 140)], man(215, -1, "down", h=50)])
K("Jb 17,7", "Zrak mi pohasl žalem", lambda: [
    gr(), man(120, 1, "cry", "sit", h=48), seat(120, G, 16, 12), moon(200, 25, 7)])
K("Jb 21,7", "Proč svévolníci žijí, stárnou a nabývají moci?", lambda: [
    gr(), man(80, 1, "open", "sit", h=50), table(130, G, 50, 16), cup(120, G - 16), coins(140, G - 18, 4), sheep(190, G, 0.8), ox(220, G, 0.8, -1)])
K("Jb 23,10", "Zná mou cestu; až mě vyzkouší, vyjdu jako zlato", lambda: [
    gr(), furnace(160, G, 50, 36), flames(160, G - 14, 18), path(10, G, 130, G - 10, 20, 6), man(70, 1, "down", "walk", h=52)])
K("Jb 25,5", "Ani měsíc nezáří a hvězdy nejsou čisté v jeho očích", lambda: [
    moon(80, 40, 12), stars([(140, 25), (170, 50), (200, 20), (220, 60), (30, 70)]), gr(), man(140, 1, "pray", "kneel", h=44)])
K("Jb 27,18", "Staví svůj dům jako mol, jako budku, kterou si udělá hlídač", lambda: [
    gr(), [(100, G), (110, G - 30), (140, G - 30), (150, G)], [(105, G - 30), (125, G - 44), (145, G - 30)], field(160, 240, G, 4), man(60, 1, "down", h=50)])
K("Jb 31,32", "Cizinec nenocoval venku, dveře jsem otvíral pocestnému", lambda: [
    gr(), house(80, G, 60, 40), man(130, -1, "open", h=54), man(190, -1, "down", "walk", h=50, staff=0), moon(210, 20, 7)])
K("Jb 33,4", "Duch Boží mě učinil a dech Všemohoucího mi dává život", lambda: [
    gr(), man(120, 0, "open", h=56), smooth([(170, 40), (155, 50), (140, 45), (130, 55)], 4), smooth([(175, 55), (160, 62), (145, 60)], 3), cloud(190, 30, 30)])
K("Jb 35,5", "Pohleď na nebesa a viz, pozoruj oblaka, jsou výš než ty", lambda: [
    gr(), man(80, 1, "point", h=54), cloud(140, 30, 40), cloud(200, 50, 34), cloud(60, 20, 26)])
K("Jb 37,6", "Sněhu říká: Padej na zem", lambda: [
    cloud(120, 25, 60), *[sparkle(x, y, 2.5) for x, y in ((80, 60), (110, 75), (150, 65), (180, 85), (95, 100), (135, 105), (200, 110))], gr(), tree(40, G, 40)])
K("Jb 39,19", "Dáváš koni sílu a oblékáš jeho šíji hřívou?", lambda: [
    gr(), horse(120, G, 1.8, 1, True), hills(0, 240, G - 2, 10)])
K("Jb 41,18", "Leviatan – jeho oči jsou jako paprsky jitřenky", lambda: [
    sea(0, 240, G - 10, 4), dragon(120, 80, 1.4), sun(210, 30, 8)])

# --- Žalmy --------------------------------------------------------------------
K("Ž 2,6", "Ustanovil jsem svého krále na Sijónu, své svaté hoře", lambda: [
    hills(0, 240, G, 10), mountain(120, G, 150, 60), king(120, 0, "raise", g=G - 60, h=34), crowd(10, 60, G, 30), crowd(180, 235, G, 30)])
K("Ž 4,8", "V pokoji uléhám a hned usínám", lambda: [
    gr(), bed(120, G, 70), man(120, 1, "down", "lie", g=G - 6, h=44), moon(200, 22, 8), stars([(40, 30), (80, 20), (160, 35)])])
K("Ž 6,6", "Každou noc smáčím lůžko slzami", lambda: [
    gr(), bed(120, G, 70), man(110, 1, "cry", "sit", g=G - 6, h=44), moon(200, 22, 8), *[circle(x, G - 10, 1)[0] for x in (96, 102)]])
K("Ž 9,9", "Hospodin je hradem pro utlačené", lambda: [
    gr(), tower(150, G, 40, 80), wall(100, 200, G, 30, 3), man(70, 1, "down", "walk", h=50), woman(45, 1, "down", "walk", h=44)])
K("Ž 11,1", "U Hospodina hledám útočiště; jak mi můžete říkat: Uleť na horu jako pták?", lambda: [
    gr(), mountain(170, G, 110, 70), bird(150, 50, 1.4), man(70, 1, "pray", h=54)])
K("Ž 13,5", "Já však doufám v tvé milosrdenství", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=48), sun(190, 30, 10), heart(120, 40, 6)])
K("Ž 15,1", "Hospodine, kdo smí pobývat v tvém stánku?", lambda: [
    mountain(130, G, 170, 70), tent(130, G - 70, 30, 18), path(30, G, 120, G - 66, 20, 3), man(50, 1, "down", "walk", h=46), gr()])
K("Ž 17,8", "Ukryj mě ve stínu svých křídel", lambda: [
    gr(), smooth([(40, 70), (80, 40), (120, 30), (160, 40), (200, 70)], 6), smooth([(40, 70), (60, 60), (80, 66), (100, 56), (120, 62), (140, 56), (160, 66), (180, 60), (200, 70)], 6),
    man(120, 0, "pray", "kneel", h=44)])
K("Ž 19,1", "Nebesa vypravují o Boží slávě", lambda: [
    sun(120, 50, 16), stars([(30, 30), (60, 70), (200, 25), (215, 70), (170, 15)]), hills(0, 240, G, 14), gr()])
K("Ž 21,3", "Vložil jsi mu na hlavu korunu z ryzího zlata", lambda: [
    gr(), king(120, 0, "raise", h=60), crown(120, 30, 18), rays(120, 30, 12, 26, 200, 340, 7), crowd(10, 80, G, 36), crowd(160, 235, G, 36)])
K("Ž 24,7", "Brány, pozvedněte hlavy, ať vejde Král slávy", lambda: [
    gr(), gate(120, G, 50, 60), wall(0, 95, G, 40, 4), wall(145, 240, G, 40, 4), rays(120, 30, 10, 30, 0, 360, 12), crown(120, 30, 14)])
K("Ž 26,6", "Umývám si ruce v nevinnosti a obcházím tvůj oltář", lambda: [
    gr(), man(80, 1, "reach", h=54), ellipse(110, G - 30, 14, 3), [(96, G - 30), (104, G - 20), (116, G - 20), (124, G - 30)], [(110, G - 20), (110, G)],
    altar(180, G, 30, 16, True)])
K("Ž 28,7", "Hospodin je má síla a můj štít", lambda: [
    gr(), man(90, 1, "raise", h=56), shield(150, 70, 2.2), rays(150, 70, 18, 30, 0, 360, 10)])
K("Ž 30,11", "Můj nářek jsi obrátil v tanec", lambda: [
    gr(), man(80, 1, "raise", h=54), woman(130, -1, "wide", h=48), man(175, 1, "raise", h=50), sun(210, 25, 8)])
K("Ž 32,8", "Povedu tě po cestě, kterou máš jít; mé oko bude nad tebou", lambda: [
    gr(), path(20, G + 2, 220, G - 30, 40, 4), man(80, 1, "down", "walk", h=52), eye(170, 30, 18), rays(170, 30, 12, 22, 0, 360, 10)])
K("Ž 34,7", "Anděl Hospodinův táboří kolem těch, kdo se ho bojí", lambda: [
    gr(), tent(120, G, 40, 26), angel(60, 1, "wide", h=56), angel(190, -1, "wide", h=56), moon(120, 22, 7)])
K("Ž 36,9", "U tebe je zdroj života, v tvém světle vidíme světlo", lambda: [
    gr(), rock(110, G, 40, 26), smooth([(100, G - 20), (90, G - 10), (70, G)], 3), waves(10, 80, G + 4, 4), sun(170, 40, 14), man(200, -1, "raise", h=50)])
K("Ž 38,4", "Mé viny mi přerostly přes hlavu jako těžké břemeno", lambda: [
    gr(), man(120, 1, "carry", "bow", h=44), [(95, G - 50), (145, G - 50), (145, G - 70), (95, G - 70), (95, G - 50)], stones(200, G, 2)])
K("Ž 40,2", "Vytáhl mě z jámy a postavil mé nohy na skálu", lambda: [
    gr(0, 80), [(80, G), (90, G + 14), (150, G + 14), (160, G)], rock(190, G, 60, 30), man(190, 1, "raise", g=G - 30, h=40), hand(150, 60, 1.2, False)])
K("Ž 43,3", "Sešli své světlo a svou pravdu, ať mě vedou", lambda: [
    gr(), mountain(190, G, 90, 60), temple(190, G - 58, 30, 16), path(20, G, 170, G - 50, 30, 4), man(70, 1, "down", "walk", h=50), rays(190, 40, 14, 30, 200, 340, 6)])
K("Ž 45,13", "Královská dcera je celá skvostná", lambda: [
    gr(), woman(120, 0, "hold", h=56, crown=True), sparkle(100, 60), sparkle(140, 70), woman(70, 1, "down", "walk", h=44), woman(180, -1, "down", "walk", h=44)])
K("Ž 47,1", "Všechny národy, tleskejte rukama", lambda: [
    gr(), crowd(10, 230, G, 40), man(60, 1, "raise", h=56), woman(120, 1, "raise", h=50), man(180, -1, "raise", h=54)])
K("Ž 49,17", "Když umře, nic si nevezme s sebou", lambda: [
    gr(), man(90, 1, "open", h=54), coins(150, G - 2, 6), house(200, G, 40, 30), path(80, G, 0, G - 8, 12, 4)])
K("Ž 53,6", "Kéž ze Sijónu vzejde Izraeli spása", lambda: [
    gr(), mountain(130, G, 150, 60), city(90, 170, G - 58, 20), rays(130, 50, 20, 40, 200, 340, 7), crowd(10, 60, G, 32)])
K("Ž 55,6", "Kéž bych měl křídla jako holubice, odletěl bych a usadil se", lambda: [
    gr(), man(80, 1, "reach", h=54), bird(150, 50, 1.6, 1, True), bird(190, 35, 1.2, 1, True), hills(140, 240, G - 2, 14)])
K("Ž 57,8", "Probuď se, harfo a citaro, probudím jitřenku", lambda: [
    gr(), man(100, 1, "down", "sit", h=46), harp(128, G - 4, 26), sun(200, G - 6, 14), hills(150, 240, G - 2, 6)])
K("Ž 59,16", "Ráno budu jásat o tvém milosrdenství", lambda: [
    gr(), man(110, 1, "raise", h=56), sun(190, 50, 12), hills(140, 240, G - 2, 10)])
K("Ž 61,2", "Doveď mě na skálu, která je pro mě příliš vysoká", lambda: [
    gr(), rock(170, G, 70, 80), man(60, 1, "reach", h=52), hand(170, 30, 1.2, False), path(70, G, 150, G - 60, 16, 3)])
K("Ž 63,1", "Má duše po tobě žízní v zemi vyprahlé, bez vody", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=48), sun(190, 30, 12), *[[(x, G + 2), (x + 6, G + 6)] for x in (20, 60, 160, 210)], plant(40, G, 10)])
K("Ž 65,9", "Navštěvuješ zemi a svlažuješ ji, Boží potok je plný vody", lambda: [
    gr(), cloud(80, 25, 40), rain(50, 120, 40, 90, 6), waves(120, 240, G - 4, 5), field(10, 120, G, 6), tree(200, G - 6, 34)])
K("Ž 67,6", "Země vydala svou úrodu", lambda: [
    gr(), field(10, 140, G, 8), basket(170, G, 24, 12, 4), tree(215, G, 44), sun(60, 25, 8)])
K("Ž 69,1", "Zachraň mě, Bože, vody mi sahají až po krk", lambda: [
    sea(0, 240, G - 20, 5), man(120, 0, "raise", g=G + 20, h=60)[:12], cloud(180, 25, 40), rain(160, 220, 40, 80, 5)])
K("Ž 71,9", "Neodvrhuj mě v čase stáří", lambda: [
    gr(), man(110, 1, "pray", "sit", h=48, staff=0), seat(110, G, 16, 12), sun(200, G - 10, 12), tree(40, G, 50)])
K("Ž 73,23", "Jsem stále s tebou, držíš mě za pravici", lambda: [
    gr(), man(110, 1, "reach", h=54), hand(150, G - 40, 1.4, False), rays(160, 30, 6, 24, 0, 360, 10), path(0, G, 100, G - 6, 12, 6)])
K("Ž 75,8", "V Hospodinově ruce je kalich", lambda: [
    gr(), hand(120, 50, 2, True), cup(120, 70, 2), man(60, 1, "open", h=50), man(190, -1, "cry", h=50)])
K("Ž 77,19", "Tvá cesta vedla mořem, tvé stezky mnohými vodami", lambda: [
    sea(0, 90, G, 4), sea(150, 240, G, 4), path(120, G + 4, 120, G - 30, 40, 10), crowd(100, 140, G - 10, 30), cloud(120, 25, 30)])
K("Ž 79,1", "Bože, pohané vtrhli do tvého dědictví a obrátili Jeruzalém v trosky", lambda: [
    gr(), wall(20, 200, G, 30, 3, broken=True), stones(210, G, 3), man(80, 1, "cry", "kneel", h=46), flames(150, G - 30, 16)])
K("Ž 81,3", "Troubte na roh při novoluní", lambda: [
    gr(), man(100, 1, "hold", h=54), horn(124, G - 34, 1.4, 1), moon(190, 30, 9), crowd(150, 235, G, 34)])
K("Ž 83,13", "Učiň je jako plevy hnané větrem", lambda: [
    gr(), *[[(x, y), (x + 4, y - 2)] for x, y in ((60, 80), (90, 70), (120, 90), (150, 60), (180, 80), (200, 50), (100, 50))],
    smooth([(20, 70), (60, 60), (100, 70)], 3), smooth([(30, 90), (80, 85), (130, 95)], 3), man(210, -1, "down", h=50)])
K("Ž 85,10", "Milosrdenství a věrnost se potkají, spravedlnost a pokoj se políbí", lambda: [
    gr(), man(95, 1, "wide", h=54), woman(140, -1, "wide", h=50), heart(118, 30, 7), sun(210, 25, 8)])
K("Ž 87,2", "Hospodin miluje brány Sijónu", lambda: [
    gr(), city(40, 200, G, 40), gate(120, G, 36, 44), heart(120, 40, 8)])
K("Ž 89,1", "Navěky budu zpívat o Hospodinově milosrdenství", lambda: [
    gr(), man(90, 1, "raise", h=56), harp(140, G, 26), rays(120, 20, 6, 26, 0, 360, 10)])
K("Ž 92,12", "Spravedlivý pokvete jako palma, poroste jako libanonský cedr", lambda: [
    gr(), tree(80, G, 80, "palm"), tree(170, G, 74), man(125, 0, "raise", h=46)])
K("Ž 94,22", "Hospodin je mým hradem, můj Bůh skálou útočiště", lambda: [
    gr(), rock(150, G, 90, 60), tower(150, G - 58, 20, 30), man(70, 1, "pray", h=52)])
K("Ž 96,12", "Ať jásá pole a všechno, co je na něm, ať plesají stromy v lese", lambda: [
    gr(), field(10, 100, G, 6), tree(130, G, 56), tree(175, G, 64), tree(215, G, 50), sun(60, 25, 9)])
K("Ž 98,8", "Ať řeky tleskají, ať hory jásají", lambda: [
    mountain(70, G - 10, 110, 60), mountain(180, G - 10, 100, 50), sea(0, 240, G, 3), sun(120, 25, 9)])
K("Ž 100,4", "Vejděte do jeho bran s děkováním", lambda: [
    gr(), gate(170, G, 44, 54), wall(192, 240, G, 40, 4), crowd(20, 140, G, 40), man(130, 1, "raise", h=52)])
K("Ž 102,7", "Jsem jako osamělý pták na střeše", lambda: [
    gr(), house(120, G, 90, 50), bird(130, G - 56, 1.4), moon(200, 22, 7)])
K("Ž 104,14", "Dáváš růst trávě pro dobytek a rostlinám pro člověka", lambda: [
    gr(), tufts(10, 230, G, 8), ox(70, G, 1, 1), sheep(120, G, 0.9, 1), field(150, 230, G, 5), man(200, -1, "down", h=46), sun(40, 25, 8)])
K("Ž 106,9", "Pohrozil Rudému moři a vyschlo", lambda: [
    sea(0, 80, G, 4), sea(160, 240, G, 4), gr(80, 160), crowd(90, 150, G, 32), man(60, 1, "raise", g=G - 20, h=30, staff=0)])
K("Ž 108,4", "Tvé milosrdenství sahá výš než nebesa", lambda: [
    cloud(70, 40, 40), cloud(170, 30, 50), heart(120, 22, 9), rays(120, 22, 12, 26, 0, 360, 12), gr(), man(120, 0, "raise", h=44)])
K("Ž 110,1", "Hospodin řekl mému Pánu: Seď po mé pravici", lambda: [
    cloud(120, 90, 80), throne(120, 88, 40, 1), J(120, 1, "bless", "sit", g=88, h=40), rays(120, 30, 6, 30, 0, 360, 12)])
K("Ž 112,9", "Štědře rozdává chudým", lambda: [
    gr(), man(90, 1, "give", h=56), bread(116, G - 32, 7), man(150, -1, "reach", "kneel", h=44), woman(190, -1, "reach", h=46), kid(215, -1, h=28)])
K("Ž 114,4", "Hory poskakovaly jako berani, pahorky jako jehňata", lambda: [
    gr(), mountain(80, G - 6, 90, 60), mountain(180, G - 4, 70, 40), ram(40, G, 1, 1), sheep(210, G, 0.8, -1)])
K("Ž 116,13", "Pozvednu kalich spásy a budu vzývat Hospodinovo jméno", lambda: [
    gr(), man(110, 1, "raise", h=56), cup(126, G - 66, 1.2), rays(126, G - 70, 6, 20, 200, 340, 5)])
K("Ž 118,22", "Kámen, který stavitelé zavrhli, se stal kamenem úhelným", lambda: [
    gr(), wall(60, 200, G, 40, 4), [(60, G), (60, G - 40), (80, G - 40), (80, G), (60, G)], man(30, 1, "point", h=50), man(220, -1, "open", h=50)])
K("Ž 120,1", "V soužení jsem volal k Hospodinu a on mi odpověděl", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=48), rays(150, 15, 6, 34, 40, 140, 7), hills(150, 240, G - 2, 12)])
K("Ž 122,1", "Zaradoval jsem se, když mi řekli: Půjdeme do domu Hospodinova", lambda: [
    gr(), city(150, 235, G, 40), path(0, G, 150, G - 6, 14, 6), man(50, 1, "raise", "walk", h=52), woman(80, 1, "down", "walk", h=46), kid(105, 1, h=28)])
K("Ž 124,7", "Unikli jsme jako pták z osidla lovců", lambda: [
    gr(), nets(80, G - 10, 40, 14), bird(150, 50, 1.6), bird(190, 35, 1.2), sun(210, 20, 7)])
K("Ž 126,5", "Kdo sejí se slzami, budou žnout s jásotem", lambda: [
    gr(), man(60, 1, "cry", "walk", h=50), field(110, 240, G, 7), man(170, 1, "raise", h=54), wheat(195, G - 30, 12)])
K("Ž 128,3", "Tvé děti jako olivové výhonky kolem tvého stolu", lambda: [
    gr(), table(120, G, 90, 16), man(60, 1, "open", "sit", h=48), woman(180, -1, "open", "sit", h=44), kid(100, 1, h=26), kid(125, 0, h=24), kid(145, -1, h=26),
    vine(10, 40, 230, 3)])
K("Ž 130,6", "Má duše čeká na Panovníka víc než strážní na jitro", lambda: [
    gr(), wall(60, 200, G, 40, 4), man(130, 1, "down", g=G - 40, h=36), spear(144, G - 40, 40), sun(220, G - 4, 10), moon(30, 25, 7)])
K("Ž 132,8", "Povstaň, Hospodine, ke svému odpočinku, ty a truhla tvé moci", lambda: [
    gr(), ark_cov(120, G - 52, 40), man(95, 1, "carry", "walk", h=50), man(145, 1, "carry", "walk", h=50), rays(120, 30, 6, 20, 0, 360, 10)])
K("Ž 134,2", "Pozvedněte ruce ke svatyni a dobrořečte Hospodinu", lambda: [
    gr(), temple(170, G, 80, 40), man(80, 1, "raise", h=54), man(40, 1, "raise", h=52), moon(210, 20, 7), lamp(140, G - 4, 1)])
K("Ž 136,8", "Slunce, aby vládlo dni – neboť jeho milosrdenství trvá navěky", lambda: [
    sun(70, 50, 16), moon(180, 40, 12), stars([(150, 20), (210, 70), (220, 25)]), gr(), hills(0, 240, G, 8)])
K("Ž 138,2", "Klaním se směrem k tvému svatému chrámu", lambda: [
    gr(), man(80, 1, "pray", "bow", h=44), temple(180, G, 80, 40), rays(180, 50, 10, 24, 200, 340, 6)])
K("Ž 140,7", "Kryješ mou hlavu v den boje", lambda: [
    gr(), man(110, 1, "pray", h=56), helmet(110, G - 60, 1.4), hand(110, 40, 1.4, False), spear(60, G, 56)])
K("Ž 144,12", "Naši synové ať jsou jako statné rostliny, dcery jako sloupy paláce", lambda: [
    gr(), youth(70, 1, "raise", h=50), plant(40, G, 30), woman(160, -1, "down", h=48), pillar(200, G, 60), pillar(220, G, 60)])
K("Ž 146,7", "Hospodin propouští vězně na svobodu", lambda: [
    gr(), wall(10, 90, G, 60, 6), door(70, G, 20, 34), man(120, 1, "raise", "walk", h=52), chain(140, G - 2, 160, G, 3), sun(200, 25, 9)])
K("Ž 148,3", "Chvalte ho, slunce a měsíci, chvalte ho, všechny zářící hvězdy", lambda: [
    sun(60, 40, 14), moon(170, 35, 10), stars([(110, 20), (210, 60), (140, 70), (30, 80), (220, 20)]), gr(), man(120, 0, "raise", h=40)])

# --- Přísloví -----------------------------------------------------------------
K("Př 1,8", "Poslouchej, synu, otcovo napomenutí", lambda: [
    gr(), man(80, 1, "point", "sit", h=50), seat(80, G, 16, 12), youth(140, -1, "pray", h=44), woman(190, -1, h=46)])
K("Př 4,18", "Stezka spravedlivých je jako světlo úsvitu, které se rozjasňuje", lambda: [
    gr(), path(30, G + 2, 210, G - 40, 40, 4), man(70, 1, "down", "walk", h=50), sun(210, G - 46, 14)])
K("Př 7,3", "Napiš si má slova na desku svého srdce", lambda: [
    gr(), man(80, 1, "point", h=54), heart(150, 70, 14), [(140, 66), (160, 66)], [(140, 72), (160, 72)], [(144, 78), (156, 78)]])
K("Př 9,1", "Moudrost si postavila dům a vytesala sedm sloupů", lambda: [
    gr(), [(40, G - 60), (200, G - 60)], [(30, G - 60), (120, G - 80), (210, G - 60)], *[pillar(x, G, 60, 6) for x in (50, 67, 85, 103, 121, 139, 157)], woman(190, -1, "open", h=48)])
K("Př 11,25", "Kdo svlažuje druhé, sám bude svlažen", lambda: [
    gr(), man(80, 1, "give", h=54), jar(105, G - 30, 0.6), smooth([(112, G - 30), (118, G - 20), (122, G - 8)], 3), plant(126, G, 20), plant(150, G, 16),
    cloud(190, 25, 34), rain(170, 220, 40, 80, 5)])
K("Př 13,20", "Kdo chodí s moudrými, zmoudří", lambda: [
    gr(), man(90, 1, "point", "walk", h=54, staff=1), youth(130, 1, "down", "walk", h=46), path(30, G, 230, G - 10, 20, 6)])
K("Př 15,1", "Vlídná odpověď odvrací rozhořčení", lambda: [
    gr(), man(80, 1, "open", h=54), man(160, -1, "point", h=54), heart(120, 40, 6)])
K("Př 17,17", "Přítel miluje v každé době", lambda: [
    gr(), man(100, 1, "give", h=54), man(140, -1, "cry", "sit", h=46), cloud(170, 30, 30), sun(60, 25, 8)])
K("Př 19,17", "Kdo se smilovává nad nuzným, půjčuje Hospodinu", lambda: [
    gr(), man(90, 1, "give", h=54), coins(118, G - 30, 3), man(150, -1, "reach", "sit", h=44), rays(120, 15, 4, 20, 40, 140, 5)])
K("Př 21,1", "Srdce krále je v Hospodinově ruce jako vodní toky", lambda: [
    gr(), hand(120, 60, 2.2, True), heart(120, 54, 6), crown(120, 40, 12), waves(20, 220, G - 4, 8)])
K("Př 23,5", "Bohatství si udělá křídla a uletí jako orel", lambda: [
    gr(), man(70, 1, "reach", h=54), coins(110, G - 2, 4), eagle(170, 40, 1.4)])
K("Př 25,11", "Jako zlatá jablka na stříbrné misce je slovo řečené v pravý čas", lambda: [
    gr(), table(120, G, 60, 16), ellipse(120, G - 20, 20, 4), *[circle(x, G - 26, 4)[0] for x in (110, 120, 130)], man(60, 1, "open", h=52), man(180, -1, "down", h=50)])
K("Př 27,17", "Železo se brousí železem a člověk se brousí stykem s druhým", lambda: [
    gr(), man(70, 1, "give", h=54), man(170, -1, "give", h=54), sword(100, G - 34, 26, 20), sword(140, G - 34, 26, 160), sparkle(120, G - 40)])
K("Př 29,25", "Kdo doufá v Hospodina, je v bezpečí", lambda: [
    gr(), rock(150, G, 80, 50), man(150, 0, "raise", g=G - 50, h=34), sun(210, 25, 8)])

# --- Kazatel, Píseň písní ------------------------------------------------------
K("Kaz 1,7", "Všechny řeky tečou do moře, a moře se nenaplní", lambda: [
    mountain(40, G - 10, 70, 50), smooth([(60, G - 12), (90, G - 4), (120, G + 2)], 3), smooth([(70, G - 10), (100, G), (130, G + 4)], 3), sea(130, 240, G + 4, 3),
    sun(200, 25, 8), cloud(100, 25, 30)])
K("Kaz 5,2", "Bůh je na nebi a ty na zemi, proto ať je tvých slov málo", lambda: [
    gr(), man(110, 1, "pray", "kneel", h=48), cloud(120, 25, 60), rays(120, 30, 12, 40, 40, 140, 7)])
K("Kaz 7,14", "V den dobrý užívej dobra a v den zlý uvažuj", lambda: [
    gr(), sun(60, 40, 12), cloud(180, 35, 40), rain(160, 210, 50, 90, 5), man(120, 0, "open", h=50)])
K("Kaz 9,7", "Jez s radostí svůj chléb a pij s dobrým srdcem víno", lambda: [
    gr(), table(120, G, 70, 16), bread(110, G - 19, 8), cup(135, G - 16), man(60, 1, "raise", "sit", h=48), woman(180, -1, "open", "sit", h=44)])
K("Kaz 11,1", "Pouštěj svůj chléb po vodě, po mnoha dnech jej opět najdeš", lambda: [
    gr(0, 90), man(60, 1, "give", h=54), sea(90, 240, G, 3), bread(140, G - 6, 8), sun(210, 25, 8)])
K("Pís 1,15", "Jak jsi krásná, má přítelkyně, tvé oči jsou jako holubice", lambda: [
    gr(), man(80, 1, "open", h=54), woman(150, -1, "down", h=50), bird(120, 40, 1.2, 1, True), flowers(170, 235, G, 4)])
K("Pís 3,4", "Našla jsem toho, kterého miluje má duše", lambda: [
    gr(), woman(100, 1, "wide", h=50), man(140, -1, "wide", h=54), city(170, 240, G, 30), heart(120, 30, 7), moon(40, 25, 7)])
K("Pís 5,2", "Spím, ale srdce bdí; hlas mého milého – klepe", lambda: [
    gr(), house(80, G, 70, 50), woman(70, 1, "down", "lie", g=G - 6, h=36), door(110, G, 16, 30), man(150, -1, "reach", h=54), moon(210, 20, 7)])
K("Pís 7,12", "Ráno půjdeme do vinic a podíváme se, zda réva raší", lambda: [
    gr(), vine(110, G - 46, 230, 3), [(120, G), (120, G - 46)], [(220, G), (220, G - 46)], man(50, 1, "point", "walk", h=54), woman(80, 1, "down", "walk", h=48),
    sun(30, 25, 8)])
