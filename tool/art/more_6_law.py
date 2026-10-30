"""Ilustrace do zbývajících kapitol (kresba v každé kapitole): Pět knih Mojžíšových.

Odkazy jsou v číslování Bible kralické, K() je převede na kanonické.
"""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import K

# --- Genesis ------------------------------------------------------------------
K("Gn 6,14", "Udělej si archu z goferového dřeva", lambda: [
    gr(), man(50, 1, [(60, 100), (20, 40)], h=54), [(80, G - 8), (200, G - 8)], [(80, G - 8), (90, G - 30), (190, G - 30), (200, G - 8)],
    [(110, G - 30), (110, G - 8)], [(140, G - 30), (140, G - 8)], [(170, G - 30), (170, G - 8)], ladder(205, G, 190, G - 30, 8, 4), tree(225, G, 40)])
K("Gn 8,11", "Holubice se vrátila a v zobáku nesla čerstvý olivový lístek", lambda: [
    sea(10, 230, G + 2, 2), ark(120, G - 18, 100), man(120, 1, "reach", g=G - 40, h=26)[:8], bird(170, 40, 1.6, -1, True),
    ellipse(156, 42, 3, 1.4, rot=-20), mountain(30, G - 6, 50, 26), sun(210, 22, 8)])
K("Gn 10,32", "Od Noemových synů se po potopě rozdělily národy na zemi", lambda: [
    gr(), man(120, 0, "wide", h=56), man(60, -1, "down", "walk", h=48), woman(40, -1, "down", "walk", h=44), man(180, 1, "down", "walk", h=48),
    woman(205, 1, "down", "walk", h=44), hills(0, 240, G - 2, 10), path(110, G, 20, G - 10, 16, 4), path(130, G, 230, G - 10, 16, 4)])
K("Gn 14,18", "Melchisedech, král Šálemu, vynesl chléb a víno a požehnal Abramovi", lambda: [
    gr(), king(80, 1, "give", h=56), bread(103, G - 32, 7), cup(112, G - 36), man(160, -1, "pray", h=54), city(0, 50, G, 30), spear(190, G, 56)])
K("Gn 17,5", "Tvé jméno bude Abraham, neboť tě učiním otcem mnoha národů", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=50), stars([(30, 25), (60, 15), (95, 30), (140, 12), (175, 28), (210, 18), (225, 45), (20, 55)]),
    star(150, 45, 6), tent(195, G, 40, 24)])
K("Gn 20,17", "Abraham se modlil k Bohu a Bůh Abímeleka uzdravil", lambda: [
    gr(), man(80, 1, "raise", "kneel", h=50), king(160, -1, "pray", h=56), woman(195, -1, h=48), rays(80, 15, 4, 22, 50, 130, 5)])
K("Gn 23,19", "Abraham pohřbil Sáru v jeskyni na poli Makpela", lambda: [
    gr(), hills(100, 240, G, 30), tomb(170, G, 54, 36, "closed"), man(90, 1, "cry", h=54), tree(30, G, 50)])
K("Gn 26,22", "Izák vykopal novou studnu: Nyní nám Hospodin dal volné místo", lambda: [
    gr(), well(120, G, 24), man(80, 1, "raise", h=54), man(160, -1, [(60, 100), (20, 60)], h=50), [(170, G - 8), (178, G - 40)],
    sheep(205, G, 0.9, -1), tent(30, G, 36, 22)])
K("Gn 30,37", "Jákob vzal pruty, oloupal je a položil je k napajedlům", lambda: [
    gr(), man(70, 1, "hold", h=54), [(85, G - 26), (98, G - 40)], [(90, G - 24), (104, G - 36)], table(140, G, 50, 6), sheep(130, G - 6, 0.8),
    goat(170, G, 0.9, -1), sheep(205, G, 0.9, -1)])
K("Gn 34,1", "Dína vyšla, aby se podívala na dívky té země", lambda: [
    gr(), woman(80, 1, "down", "walk", h=48), city(150, 235, G, 34), tent(30, G, 34, 20), path(95, G, 160, G - 6, 10, 4)])
K("Gn 36,6", "Ezau vzal ženy, syny i dobytek a odešel do jiné země", lambda: [
    gr(), man(60, 1, "down", "walk", h=54, staff=1), woman(95, 1, "down", "walk", h=46), camel(140, G, 1, 1), goat(185, G, 0.8, 1),
    sheep(210, G, 0.8, 1), mountain(200, G - 10, 70, 40)])
K("Gn 38,25", "Poznej, čí je ta pečeť, šňůra a hůl", lambda: [
    gr(), woman(90, 1, "give", h=50), circle(116, G - 32, 3), [(118, G - 30), (124, G - 20)], [(132, G), (130, G - 50)], man(170, -1, "cry", h=56)])
K("Gn 40,8", "Josef ve vězení: Výklady snů jsou Boží věc", lambda: [
    gr(), wall(0, 240, G, 60, 6)[:2], man(120, 1, "bless", h=52), man(60, 1, [(30, 100), (20, 90)], "sit", h=46), cup(85, G - 26),
    man(185, -1, "cry", "sit", h=46), basket(170, G - 34, 14, 7, 3), window(210, G - 70, 14, 12)])
K("Gn 43,15", "Bratři vzali dary, dvojnásob stříbra i Benjamína a šli do Egypta", lambda: [
    gr(), man(50, 1, "down", "walk", h=54), man(80, 1, "carry", "walk", h=52), basket(80, G - 54, 16, 8, 3), youth(110, 1, "down", "walk", h=44),
    donkey(160, G, 1, 1), jar(190, G - 20, 0.6), mountain(215, G - 20, 50, 30)])
K("Gn 47,7", "Josef přivedl svého otce k faraonovi a Jákob faraonovi požehnal", lambda: [
    gr(), king(170, -1, "open", "sit", h=56), throne(175, G, 40, -1), man(100, 1, "bless", h=50, staff=1), man(55, 1, "point", h=54), pillar(220, G, 60)])
K("Gn 49,9", "Jákob žehnal synům: Juda je lví mládě", lambda: [
    gr(), bed(70, G, 70), man(70, 1, "bless", "lie", g=G - 6, h=44), man(140, -1, "pray", "kneel", h=48), man(165, -1, "pray", "kneel", h=48),
    lion(210, G, 0.9, -1)])

# --- Exodus -------------------------------------------------------------------
K("Ex 1,11", "Egypťané ustanovili nad Izraelci dozorce a ti stavěli zásobní města", lambda: [
    gr(), man(60, 1, "carry", "walk", h=50), [(48, G - 52), (72, G - 52), (72, G - 58), (48, G - 58), (48, G - 52)], man(100, 1, "carry", "walk", h=50),
    [(88, G - 52), (112, G - 52), (112, G - 58), (88, G - 58), (88, G - 52)], wall(130, 220, G, 30, 4), man(220, -1, "point", h=56), pillar(30, G, 50)])
K("Ex 6,6", "Vyvedu vás z egyptské roboty vztaženou paží", lambda: [
    gr(), man(70, 1, "bless", h=56, staff=1), crowd(120, 230, G, 40), hand(160, 26, 1.4, False), rays(160, 30, 10, 20, 0, 180, 6)])
K("Ex 9,23", "Mojžíš vztáhl hůl k nebi a Hospodin dal hromy a krupobití", lambda: [
    gr(), man(70, 1, "raise", h=56, staff=0), cloud(130, 25, 50), cloud(195, 30, 40), rain(110, 220, 40, 110, 12),
    [(170, 42), (162, 60), (172, 60), (160, 82)], field(130, 230, G, 6)])
K("Ex 11,4", "O půlnoci projdu Egyptem", lambda: [
    gr(), moon(200, 22, 8), stars([(40, 20), (90, 30), (150, 15), (230, 50)]), house(60, G, 40, 30), house(110, G, 34, 26), house(160, G, 44, 32),
    pillar(215, G, 50)])
K("Ex 13,21", "Hospodin šel před nimi ve dne v oblakovém sloupu a v noci v ohnivém", lambda: [
    gr(), cloud(170, 28, 40), [(158, 34), (162, 110)], [(182, 34), (178, 110)], flames(170, 120, 18), crowd(30, 140, G, 40), man(130, 1, "point", h=50, staff=1)])
K("Ex 15,20", "Mirjam vzala bubínek a všechny ženy vyšly za ní a tančily", lambda: [
    gr(), woman(90, 1, "raise", h=50), circle(98, G - 64, 6), woman(130, -1, "raise", h=46), woman(165, 1, "wide", h=46), woman(200, -1, "raise", h=46),
    sea(0, 60, G - 4, 3)])
K("Ex 19,18", "Hora Sínaj byla celá zahalena dýmem, protože Hospodin sestoupil v ohni", lambda: [
    mountain(130, G, 160, 80), flames(130, G - 82, 24), smooth([(130, G - 100), (120, G - 115), (135, G - 128), (125, G - 145)], 4),
    smooth([(145, G - 98), (150, G - 115), (140, G - 130)], 3), crowd(10, 60, G, 32), crowd(190, 235, G, 32), gr()])
K("Ex 22,21", "Cizince neutiskuj, sami jste byli cizinci v egyptské zemi", lambda: [
    gr(), man(80, 1, "give", h=54), bread(104, G - 32, 7), man(140, -1, "reach", "walk", h=50, staff=0), woman(170, -1, h=44), kid(190, -1, h=28),
    path(140, G, 230, G - 14, 16, 4)])
K("Ex 24,18", "Mojžíš vešel do oblaku a vystoupil na horu; byl tam čtyřicet dní", lambda: [
    mountain(120, G, 180, 90), cloud(120, 38, 60), man(118, 1, "raise", g=G - 70, h=22), gr(), man(30, 1, "down", h=44), man(210, -1, "down", h=44)])
K("Ex 26,1", "Příbytek uděláš z deseti pruhů vzácné tkaniny", lambda: [
    gr(), [(60, G), (60, G - 40), (180, G - 40), (180, G)], [(55, G - 40), (120, G - 56), (185, G - 40)], [(90, G - 40), (90, G)],
    [(120, G - 40), (120, G)], [(150, G - 40), (150, G)], [(60, G - 28), (180, G - 28)], man(210, -1, "point", h=50), cloud(120, 20, 30)])
K("Ex 28,4", "Áronovi zhotoví svaté roucho, efod a náprsník", lambda: [
    gr(), man(120, 0, "open", h=60), [(110, G - 40), (130, G - 40), (130, G - 28), (110, G - 28), (110, G - 40)], [(116.6, G - 40), (116.6, G - 28)],
    [(123.3, G - 40), (123.3, G - 28)], [(110, G - 34), (130, G - 34)], man(60, 1, "hold", h=52), man(185, -1, "point", h=52)])
K("Ex 31,18", "Bůh dal Mojžíšovi dvě kamenné desky psané Božím prstem", lambda: [
    mountain(130, G, 170, 70), tablets(120, G - 72, 22), rays(120, G - 86, 10, 26, 200, 340, 7), man(90, 1, "reach", g=G - 50, h=28), gr()])
K("Ex 34,29", "Mojžíš sestoupil z hory a jeho tvář zářila", lambda: [
    gr(), mountain(60, G, 110, 70), man(130, 1, "hold", h=56), tablets(146, G - 30, 14), rays(130, G - 52, 6, 16, 0, 360, 10), crowd(170, 235, G, 36)])
K("Ex 36,5", "Lid přináší víc, než je potřeba pro dílo", lambda: [
    gr(), man(70, 1, "give", h=52), basket(100, G - 30, 16, 8, 3), woman(40, 1, "carry", h=46), jar(40, G - 52, 0.6), man(160, -1, "wide", h=54),
    stones(190, G, 3), [(200, G - 20), (230, G - 20), (230, G), (200, G)], coins(210, G - 24, 5)])
K("Ex 38,8", "Měděnou nádrž udělal ze zrcadel žen, které sloužily u stanu setkávání", lambda: [
    gr(), [(80, G), (90, G - 18), (150, G - 18), (160, G)], ellipse(120, G - 22, 40, 6), woman(190, -1, "give", h=46), mirror(170, G - 26, 1),
    woman(215, -1, "hold", h=44), man(40, 1, "point", h=50)])

# --- Leviticus ----------------------------------------------------------------
K("Lv 3,1", "Pokojná oběť – zvíře bez vady před Hospodinem", lambda: [
    gr(), altar(160, G, 30, 18, True, True), ox(90, G, 1, 1), man(50, 1, [(30, 80), (20, 70)], h=54), tent(220, G, 30, 20)])
K("Lv 5,5", "Kdo se provinil, vyzná, čím zhřešil", lambda: [
    gr(), man(110, 1, "cry", "kneel", h=48), man(170, -1, "bless", h=56), altar(220, G, 22, 14, True), tent(30, G, 40, 24)])
K("Lv 7,12", "Oběť díků – nekvašené koláče zadělané olejem", lambda: [
    gr(), table(120, G, 70, 16), bread(100, G - 19, 8), bread(120, G - 19, 8), bread(140, G - 19, 8), jar(150, G - 16, 0.4),
    man(60, 1, "raise", h=54), man(190, -1, "hold", h=54)])
K("Lv 9,24", "Vyšel oheň od Hospodina a pohltil oběť; lid jásal a padl na tvář", lambda: [
    gr(), altar(120, G, 34, 18, True), flames(120, G - 26, 30), rays(120, 10, 6, 40, 40, 140, 7), man(60, 1, "raise", "kneel", h=46),
    man(180, -1, "pray", "bow", h=40), man(210, -1, "pray", "bow", h=40)])
K("Lv 11,3", "Smíte jíst zvířata s rozdělenými kopyty, která přežvykují", lambda: [
    gr(), ox(60, G, 1, 1), sheep(110, G, 1, 1), goat(150, G, 1, 1), deer(195, G, 1, -1)])
K("Lv 13,2", "Ukáže-li se na kůži skvrna, přivedou ho ke knězi", lambda: [
    gr(), man(150, -1, "open", h=54), man(90, 1, "reach", h=54), tent(210, G, 36, 22), [(144, G - 34), (146, G - 32)], circle(146, G - 34, 2)])
K("Lv 15,13", "Vypere si šaty a omyje se tekoucí vodou a bude čistý", lambda: [
    gr(0, 120), man(80, 1, "reach", "kneel", h=48), waves(120, 240, G, 6), waves(120, 240, G + 6, 6), [(100, G - 4), (118, G - 6)], reeds(200, 235, G - 4, 4)])
K("Lv 18,5", "Zachovávejte má nařízení; kdo je plní, bude jimi žít", lambda: [
    gr(), path(30, G + 2, 210, G - 30, 40, 6), man(90, 1, "down", "walk", h=54), scroll(150, 40, 34, 18), sun(210, 25, 8)])
K("Lv 21,8", "Kněze budeš mít za svatého, neboť předkládá chléb tvého Boha", lambda: [
    gr(), man(110, 1, "hold", h=58), bread(128, G - 34, 8), table(170, G, 40, 16), bread(165, G - 19, 6), bread(178, G - 19, 6), lampstand(215, G, 34)])
K("Lv 25,10", "Padesátý rok posvětíte a vyhlásíte svobodu v zemi", lambda: [
    gr(), man(70, 1, "hold", h=54), horn(95, G - 34, 1.4, 1), crowd(140, 230, G, 40), rays(120, 20, 4, 18, 0, 360, 10)])
K("Lv 27,30", "Všechny desátky ze země patří Hospodinu", lambda: [
    gr(), field(20, 140, G, 6), tree(170, G, 46), basket(210, G, 22, 12, 4), man(120, 1, "give", h=52), wheat(140, G - 30, 12)])

# --- Numeri -------------------------------------------------------------------
K("Nu 2,2", "Každý bude tábořit u své korouhve kolem stanu setkávání", lambda: [
    gr(), tent(120, G, 40, 28), tent(40, G, 30, 18), tent(200, G, 30, 18), [(60, G), (60, G - 40)], [(60, G - 40), (74, G - 36), (60, G - 32)],
    [(180, G), (180, G - 40)], [(180, G - 40), (194, G - 36), (180, G - 32)], cloud(120, 30, 30)])
K("Nu 5,7", "Vyzná svůj hřích a nahradí škodu v plné výši", lambda: [
    gr(), man(90, 1, "give", h=54), coins(118, G - 30, 4), man(160, -1, "open", h=54), house(215, G, 34, 26)])
K("Nu 8,2", "Až budeš rozsazovat kahany, ať sedm kahanů svítí před svícnem", lambda: [
    gr(), lampstand(140, G, 50), man(80, 1, "reach", h=56), tent(210, G, 30, 20)])
K("Nu 10,2", "Udělej si dvě stříbrné trubky ke svolávání a k vytrubování", lambda: [
    gr(), man(70, 1, "hold", h=54), trumpet(84, G - 38, 26, -25, 1), man(130, 1, "hold", h=54), trumpet(144, G - 38, 26, -25, 1), tent(200, G, 40, 24)])
K("Nu 12,13", "Mojžíš úpěl k Hospodinu: Bože, prosím, uzdrav ji!", lambda: [
    gr(), man(80, 1, "raise", "kneel", h=50), woman(160, -1, "cry", "sit", h=44), tent(215, G, 30, 20), cloud(110, 25, 30)])
K("Nu 15,38", "Ať si dělají na cípech oděvů třapce s modrou šňůrou", lambda: [
    gr(), man(120, 0, "open", h=60), [(104, G - 6), (104, G + 2)], [(136, G - 6), (136, G + 2)], circle(104, G + 3, 1.5), circle(136, G + 3, 1.5),
    kid(170, -1, "point", h=30), tent(40, G, 36, 22)])
K("Nu 18,20", "Hospodin Áronovi: Já jsem tvůj podíl a tvé dědictví", lambda: [
    gr(), man(110, 1, "raise", h=56), rays(110, 15, 4, 24, 40, 140, 7), field(150, 235, G, 5), tent(40, G, 36, 22)])
K("Nu 20,11", "Mojžíš udeřil holí dvakrát do skály a vyšlo mnoho vody", lambda: [
    gr(), rock(150, G, 70, 50), man(90, 1, "raise", h=56, staff=0), smooth([(130, G - 20), (125, G - 10), (118, G)], 3), waves(60, 140, G + 4, 4),
    crowd(170, 235, G, 36)])
K("Nu 25,11", "Pinchas horlil pro Hospodina a odvrátil jeho hněv od Izraele", lambda: [
    gr(), man(110, 1, "hold", h=56), spear(126, G - 10, 60, -80), tent(190, G, 50, 30), crowd(10, 70, G, 36)])
K("Nu 28,4", "Jednoho beránka obětuješ ráno a druhého k večeru", lambda: [
    gr(), altar(120, G, 30, 16, True, True), sun(40, 30, 8), moon(200, 24, 7), sheep(70, G, 0.9, 1), sheep(175, G, 0.9, -1)])
K("Nu 31,6", "Pinchas šel s nimi do boje se svatými předměty a trubkami", lambda: [
    gr(), man(70, 1, "hold", h=54), trumpet(84, G - 38, 26, -25, 1), man(120, 1, "down", "walk", h=50), spear(134, G, 54), man(160, 1, "down", "walk", h=50),
    shield(175, G - 28, 1), man(200, 1, "down", "walk", h=50)])
K("Nu 34,2", "Toto je země, která vám připadne do dědictví – Kenaan v hranicích", lambda: [
    gr(), hills(0, 240, G - 4, 20), mountain(190, G - 10, 70, 46), sea(0, 50, G - 2, 2), tree(110, G - 10, 30, "palm"), stones(70, G, 2),
    stones(160, G, 2), man(130, 1, "point", h=46)])
K("Nu 36,10", "Selofchadovy dcery udělaly, jak Hospodin přikázal Mojžíšovi", lambda: [
    gr(), woman(70, 1, "pray", h=46), woman(95, 1, "pray", h=44), woman(120, 1, "pray", h=46), woman(145, 1, "pray", h=44), woman(170, 1, "pray", h=46),
    man(215, -1, "bless", h=54, staff=1)])

# --- Deuteronomium ------------------------------------------------------------
K("Dt 2,7", "Hospodin tě provázel na poušti čtyřicet let a nic ti nechybělo", lambda: [
    gr(), hills(0, 240, G - 2, 16), crowd(20, 120, G, 38), cloud(140, 30, 30), man(160, 1, "down", "walk", h=50, staff=1), sun(215, 25, 8)])
K("Dt 4,9", "Oznamuj to svým synům a vnukům", lambda: [
    gr(), man(90, 1, "open", "sit", h=50, staff=1), seat(90, G, 16, 12), kid(140, -1, h=30), kid(165, -1, "point", h=26), youth(195, -1, h=42), tree(30, G, 50)])
K("Dt 8,3", "Člověk nežije jen z chleba, ale z každého slova Hospodinových úst", lambda: [
    gr(), man(80, 1, "hold", h=54), scroll(100, G - 36, 22, 12), bread(140, G - 4, 10), bread(158, G - 3, 8),
    *[circle(x, G - 2, 1.4)[0] for x in (180, 190, 200, 210, 220)], sun(200, 25, 8)])
K("Dt 10,1", "Vytesej si dvě kamenné desky jako ty první", lambda: [
    gr(), man(90, 1, [(80, 110), (20, 60)], "kneel", h=48), tablets(150, G, 34), stones(200, G, 3), mountain(210, G - 20, 60, 50)])
K("Dt 13,4", "Za Hospodinem, svým Bohem, choďte a jeho se bojte", lambda: [
    gr(), path(20, G + 2, 220, G - 40, 40, 4), man(80, 1, "down", "walk", h=52), woman(110, 1, "down", "walk", h=46), rays(210, 30, 6, 26, 0, 360, 10)])
K("Dt 16,14", "O své slavnosti se budeš radovat ty, tvůj syn, dcera i cizinec", lambda: [
    gr(), tent(40, G, 40, 26), man(100, 1, "raise", h=52), woman(130, -1, "raise", h=46), kid(155, 1, "wide", h=28), man(190, -1, "give", h=50),
    grapes(210, G - 34, 1)])
K("Dt 18,15", "Proroka, jako jsem já, ti vzbudí Hospodin z tvých bratří", lambda: [
    gr(), man(70, 1, "point", h=56, staff=1), crowd(110, 230, G, 40), man(170, 0, "bless", h=50), rays(170, G - 60, 4, 14, 0, 360, 10)])
K("Dt 21,6", "Starší města si umyjí ruce nad potokem", lambda: [
    gr(0, 140), man(70, 1, "reach", h=54), man(110, 1, "reach", h=54), waves(140, 240, G, 6), waves(140, 240, G + 6, 6), city(160, 235, G - 20, 26)])
K("Dt 23,24", "Na bližního vinici smíš jíst hrozny, ale do nádoby si je nedáš", lambda: [
    gr(), vine(30, G - 50, 210, 4), [(60, G), (60, G - 50)], [(180, G), (180, G - 50)], man(120, 1, "reach", h=54), basket(170, G, 18, 10)])
K("Dt 26,2", "Prvotiny úrody vložíš do koše a doneseš na místo, které Hospodin vyvolí", lambda: [
    gr(), man(90, 1, "give", h=54), basket(118, G - 30, 22, 12, 4), man(170, -1, "open", h=56), altar(215, G, 22, 14, True)])
K("Dt 29,29", "Skryté věci náleží Hospodinu, ale zjevené nám a našim synům", lambda: [
    gr(), cloud(170, 30, 50), cloud(200, 45, 30), man(80, 1, "hold", h=54), scroll(100, G - 36, 22, 12), kid(130, -1, h=30), rays(170, 34, 18, 40, 40, 140, 5)])
K("Dt 33,27", "Útočištěm je Bůh dávnověký, vespod jsou věčné paže", lambda: [
    gr(), hand(120, 90, 3, False), man(120, 0, "pray", g=G - 32, h=34), mountain(30, G, 50, 40), mountain(210, G, 50, 40)])
