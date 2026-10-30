"""Doplňkové ilustrace (každá druhá kapitola): Genesis – Deuteronomium."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import A

# --- Genesis ------------------------------------------------------------------
A("Gn 5,24", "Henoch chodil s Bohem, a nebylo ho, neboť ho Bůh vzal", lambda: [
    gr(), man(110, 1, "raise", "walk", h=56), path(120, G, 170, G - 40, 30, 4), rays(170, 20, 6, 40, 40, 140, 7), sun(170, 20, 6)])
A("Gn 13,9", "Abram řekl Lotovi: Je-li tobě vlevo, půjdu vpravo", lambda: [
    gr(), man(90, -1, "point", staff=0, h=56), man(140, 1, "point", h=52), sheep(40, G, 0.8, -1), sheep(20, G, 0.7, -1),
    sheep(190, G, 0.8), sheep(212, G, 0.7), hills(150, 240, G - 2, 10)])
A("Gn 16,13", "Hagar u pramene: Ty jsi Bůh, který mě vidí", lambda: [
    gr(), woman(100, 1, "cry", "kneel", h=50), well(150, G, 20), eye(150, 40, 18), rays(150, 40, 12, 24, 0, 360, 10), tree(210, G, 40, "palm")])
A("Gn 19,16", "Andělé vzali Lota, jeho ženu a dcery za ruce a vyvedli je z města", lambda: [
    gr(), angel(60, 1, [(70, 90), (10, 5)], h=54), man(90, 1, "down", "walk", h=50), woman(115, 1, "down", "walk", h=46),
    city(160, 235, G, 40), flames(190, G - 40, 18)])
A("Gn 25,33", "Ezau prodal Jákobovi své prvorozenství za misku čočovice", lambda: [
    gr(), man(70, 1, "reach", "sit", h=54), man(150, -1, "give", h=52, beard=False), flames(120, G - 2, 12), stones(120, G, 3),
    ellipse(128, G - 26, 6, 2), tent(210, G, 30, 18)])
A("Gn 29,10", "Jákob odvalil kámen ze studny a napojil Ráchelino stádo", lambda: [
    gr(), well(110, G, 24), man(80, 1, "reach", h=54, beard=False), rock(122, G - 12, 10, 6), woman(150, -1, "down", staff=0, h=48),
    sheep(185, G, 0.8, -1), sheep(210, G, 0.8, -1)])
A("Gn 33,4", "Ezau běžel Jákobovi naproti, objal ho a políbil", lambda: [
    gr(), man(105, 1, "wide", h=56), man(130, -1, "wide", h=54), crowd(160, 235, G, 30), sheep(40, G, 0.7), camel(70, G, 0.8, 1)])
A("Gn 35,7", "Jákob postavil oltář v Bét-elu", lambda: [
    gr(), altar(130, G, 30, 22), man(85, 1, "raise", h=56), rock(180, G, 30, 16), stars([(40, 30), (200, 30), (150, 20)])])
A("Gn 39,21", "Hospodin byl s Josefem i ve vězení", lambda: [
    gr(), youth(110, 1, "pray", "sit", h=50), window(160, 50, 22, 16), [(155, 42), (155, 58)], [(165, 42), (165, 58)],
    chain(90, G, 70, G - 2, 4), [(30, G), (30, 20)], [(30, 20), (210, 20)]])
A("Gn 42,6", "Josefovi bratři se mu poklonili tváří k zemi", lambda: [
    gr(), man(60, 1, "bless", h=56, crown=True), man(110, -1, "pray", "bow", h=50), man(150, -1, "pray", "bow", h=50),
    man(195, -1, "pray", "bow", h=50), basket(225, G, 12, 8)])
A("Gn 46,29", "Josef padl otci kolem krku a dlouho plakal", lambda: [
    gr(), man(110, 1, "wide", h=56), man(135, -1, "wide", h=52, staff=None), chariot(50, G, 1, 1), crowd(170, 235, G, 30)])
A("Gn 48,14", "Jákob vložil ruce na hlavy Efrajima a Manasesa a žehnal jim", lambda: [
    gr(), man(110, 1, [(110, 130), (110, 140)], "sit", h=56), bed(100, G, 50), kid(150, -1, "pray", h=32), kid(170, -1, "pray", h=30),
    man(205, -1, h=54)])

# --- Exodus -------------------------------------------------------------------
A("Ex 4,3", "Mojžíš hodil hůl na zem a ta se proměnila v hada", lambda: [
    gr(), man(90, 1, "open", h=56), snake(150, G - 2, 1.4, 1), bush(210, G, 22, True)])
A("Ex 7,20", "Áron udeřil holí do vody a voda v Nilu se proměnila v krev", lambda: [
    gr(0, 110), man(80, 1, [(120, 150), (20, 10)], staff=0, h=56), sea(110, 235, G + 4, 3), reeds(115, 130, G, 2), king(220, -1, "cry", h=40)])
A("Ex 8,2", "Žáby vystoupily a přikryly egyptskou zemi", lambda: [
    gr(), *[ellipse(x, G - 4, 5, 3.5) for x in (40, 70, 100, 130, 160, 190)],
    *[circle(x + 2, G - 7, 1.2)[0] for x in (40, 70, 100, 130, 160, 190)], house(120, G - 10, 40, 30)[:0], man(215, -1, "cry", h=50)])
A("Ex 10,13", "Východní vítr přinesl kobylky", lambda: [
    gr(), field(20, 140, G, 6), locust(60, 40, 2), locust(110, 30, 1.6), locust(150, 55, 1.8), locust(190, 35, 1.4),
    locust(90, 70, 1.4), man(200, -1, "cry", h=50)])
A("Ex 18,24", "Mojžíš poslechl radu svého tchána Jitra", lambda: [
    gr(), man(80, 1, "point", "sit", h=56), seat(78, G, 16, 15), man(140, -1, "down", staff=0, h=56), crowd(170, 235, G, 30)])
A("Ex 21,1", "Toto jsou právní ustanovení, která jim předložíš", lambda: [
    gr(), scales(120, 40, 2.2), man(60, 1, "open", h=56), crowd(160, 235, G, 34)])
A("Ex 23,16", "Slavnost žní – prvotiny tvé práce", lambda: [
    gr(), field(20, 110, G, 5), man(140, 1, [(30, 100), (30, 100)], h=54), basket(165, G - 30, 18, 10, "bread"), sun(210, 25, 8)])
A("Ex 25,31", "Uděláš svícen z čistého zlata", lambda: [lampstand(120, G, 80), gr(60, 180)])
A("Ex 27,1", "Oltář z akáciového dřeva s rohy na čtyřech rozích", lambda: [
    gr(), [(80, G), (80, G - 40), (160, G - 40), (160, G)], [(76, G - 40), (80, G - 50), (84, G - 40)], [(156, G - 40), (160, G - 50), (164, G - 40)],
    [(60, G - 20), (180, G - 20)], flames(120, G - 40, 26)])
A("Ex 29,7", "Vezmeš olej k pomazání a vyleješ ho Áronovi na hlavu", lambda: [
    gr(), man(150, -1, "pray", "kneel", h=52, belt=True), man(95, 1, [(130, 160), (10, 5)], h=58), horn(106, G - 66, 1),
    smooth([(124, G - 54), (130, G - 46)]), tent(30, G, 30, 20)])
A("Ex 33,22", "Postavím tě do skalní rozsedliny a přikryji tě svou dlaní", lambda: [
    smooth([(60, G), (70, G - 70), (120, G - 90), (170, G - 70), (180, G)]), [(118, G), (114, G - 50), (124, G - 50), (122, G)],
    man(120, 0, "pray", h=40), hand(140, G - 60, 1.6, False), rays(200, 30, 6, 40, 120, 200, 6)])
A("Ex 35,21", "Každý, koho srdce pohnulo, přinesl dar pro stavbu svatyně", lambda: [
    gr(), man(60, 1, "give", h=54), woman(100, 1, "give", h=50), jar(126, G - 30, 0.5), coins(150, G - 2, 5), basket(180, G, 16, 9),
    tent(220, G, 30, 22)])
A("Ex 37,1", "Besalel zhotovil truhlu z akáciového dřeva", lambda: [
    gr(), ark_cov(140, G, 50), man(80, 1, [(60, 90), (40, 70)], "kneel", h=54)])

# --- Leviticus ----------------------------------------------------------------
A("Lv 2,1", "Přinese-li kdo obětní dar z jemné mouky, poleje ji olejem", lambda: [
    gr(), man(90, 1, "hold", h=56, belt=True), ellipse(118, G - 32, 10, 3), jar(135, G - 34, 0.5), altar(180, G, 26, 16, True)])
A("Lv 4,3", "Oběť za hřích – býček bez vady", lambda: [
    gr(), ox(110, G, 1.4, 1), man(70, 1, [(80, 100), (40, 80)], h=56, belt=True), altar(190, G, 26, 16, True, True)])
A("Lv 6,6", "Oheň na oltáři musí stále hořet, nesmí vyhasnout", lambda: [
    gr(), altar(120, G, 40, 24, True), man(60, 1, "carry", h=54, belt=True), [(46, G - 58), (74, G - 58)], [(48, G - 61), (72, G - 61)],
    moon(200, 25, 7), stars([(170, 20), (220, 50)])])
A("Lv 8,12", "Mojžíš vylil olej na Áronovu hlavu a pomazal ho", lambda: [
    gr(), man(140, -1, "pray", h=56, belt=True, crown=True), man(90, 1, [(130, 160), (10, 5)], h=56), horn(102, G - 64, 1), crowd(180, 235, G, 30)])
A("Lv 10,1", "Nádab a Abíhú přinesli před Hospodina nepatřičný oheň", lambda: [
    gr(), youth(90, 1, "hold", h=52), youth(130, 1, "hold", h=50), flames(110, G - 34, 10), flames(150, G - 32, 10), tent(210, G, 34, 22)])
A("Lv 12,8", "Nemá-li na beránka, vezme dvě hrdličky", lambda: [
    gr(), woman(100, 1, "hold", h=50), bird(124, G - 40, 0.7, 1, True), bird(130, G - 30, 0.7, 1, True), man(170, -1, "reach", h=54, belt=True)])
A("Lv 14,7", "Živého ptáka vypustí do pole – malomocný je čistý", lambda: [
    gr(), man(90, 1, "raise", h=56, belt=True), bird(150, 40, 1.6, 1, True), field(160, 235, G, 5), man(40, 1, "pray", h=50)])
A("Lv 17,11", "Život těla je v krvi", lambda: [
    gr(), heart(120, 60, 18), altar(120, G, 30, 16), sheep(60, G, 0.9), man(180, -1, "pray", h=52)])
A("Lv 20,26", "Budete mi svatí, neboť já Hospodin jsem svatý", lambda: [
    gr(), crowd(30, 210, G, 40), rays(120, 20, 8, 40, 40, 140, 7), sun(120, 20, 7)])
A("Lv 24,5", "Dvanáct chlebů na stole před Hospodinem", lambda: [
    gr(), table(120, G, 80, 22), *[bread(x, G - 23 - (i // 6) * 6, 8) for i, x in enumerate([90, 102, 114, 126, 138, 150] * 2)], lampstand(200, G, 30)])
A("Lv 26,4", "Dám vám déšť v pravý čas a země vydá úrodu", lambda: [
    cloud(120, 25, 60), rain(80, 160, 40, 70, 8), gr(), field(30, 210, G, 9), tree(220, G, 40)])

# --- Numeri -------------------------------------------------------------------
A("Nu 1,2", "Sečtěte celou pospolitost Izraele podle rodů", lambda: [
    gr(), man(60, 1, "hold", "sit", h=54), scroll(90, G - 36, 22, 12), crowd(120, 235, G, 40), tent(30, G, 26, 16)])
A("Nu 3,6", "Přiveď kmen Lévi, ať slouží Áronovi při stanu setkávání", lambda: [
    gr(), tent(170, G, 60, 34), man(60, 1, h=54, belt=True), man(90, 1, h=50), man(115, 1, h=52)])
A("Nu 7,3", "Předáci přivedli šest krytých vozů a dvanáct dobytčat", lambda: [
    gr(), chariot(70, G, 1, 1), ox(110, G, 0.9), chariot(160, G, 1, 1), ox(200, G, 0.9), man(30, 1, h=50)])
A("Nu 9,17", "Když se oblak zvedl, Izraelci vytáhli; kde se usadil, tam táborili", lambda: [
    cloud(130, 30, 60), tent(130, G, 50, 26), tent(60, G, 30, 18), tent(200, G, 30, 18), gr(), man(30, 1, "point", h=40)])
A("Nu 11,31", "Vítr přinesl od moře křepelky", lambda: [
    gr(), bird(50, 40, 1.4), bird(80, 30, 1.2), bird(110, 50, 1.5), bird(140, 35, 1.3), bird(170, 55, 1.4), bird(200, 40, 1.2),
    man(80, 1, "raise", h=50), tent(180, G, 34, 20)])
A("Nu 14,6", "Jozue a Káleb roztrhli svá roucha: Ta země je velmi dobrá", lambda: [
    gr(), man(80, 1, "open", h=56), man(110, 1, "raise", h=54), crowd(150, 235, G, 40), grapes(40, 70, 1.5)])
A("Nu 16,32", "Země otevřela ústa a pohltila Kóracha a jeho lidi", lambda: [
    gr(0, 90), gr(160, 240), [(90, G), (100, G + 10), (120, G + 6), (140, G + 14), (160, G)], man(125, 0, "raise", g=G + 4, h=30)[:3],
    man(60, 1, "cry", h=54), tent(200, G, 34, 22)])
A("Nu 19,2", "Ať ti přivedou ryzou jalovici bez vady", lambda: [
    gr(), ox(120, G, 1.4, 1), man(70, 1, "point", h=56, belt=True), man(190, -1, h=50)])
A("Nu 23,7", "Bileám pronesl výrok: Jak mohu proklínat, koho Bůh neproklel?", lambda: [
    gr(), man(90, 1, "open", h=56), altar(140, G, 20, 14, True), king(190, -1, "cry", h=52), tent(30, G - 20, 20, 10), hills(0, 60, G - 2, 18)])
A("Nu 26,53", "Země bude rozdělena losem do dědictví", lambda: [
    gr(), hills(0, 240, G - 4, 16), man(110, 1, [(80, 120), (30, 10)], h=56), stones(140, G, 3), field(160, 230, G - 4, 4)])
A("Nu 27,1", "Selofchadovy dcery předstoupily před Mojžíše", lambda: [
    gr(), man(60, 1, "bless", "sit", h=56), seat(58, G, 16, 15), woman(120, -1, "pray", h=48), woman(145, -1, h=46), woman(170, -1, h=48),
    woman(195, -1, h=44), woman(220, -1, h=46)])
A("Nu 29,1", "Sedmý měsíc, první den – den troubení", lambda: [
    gr(), man(80, 1, [(110, 130), (100, 120)], h=56), trumpet(102, G - 42, 22, -30), man(150, 1, [(110, 130), (100, 120)], h=52),
    horn(170, G - 40, 1.2), moon(210, 25, 6)])
A("Nu 32,1", "Rúbenovci a Gádovci měli velmi mnoho dobytka", lambda: [
    gr(), sheep(40, G, 0.8), sheep(60, G, 0.8, -1), sheep(80, G, 0.8), ox(120, G, 0.9), sheep(160, G, 0.8, -1), man(200, -1, staff=0, h=54),
    hills(0, 240, G - 30, 10)])
A("Nu 33,1", "Toto jsou zastávky Izraelců na cestě z Egypta", lambda: [
    gr(), path(30, G, 210, G - 50, 20, 4), tent(60, G - 10, 20, 12), tent(120, G - 30, 18, 10), tent(180, G - 44, 14, 8),
    man(30, 1, "down", "walk", staff=1, h=40)])
A("Nu 35,11", "Vyberete si města, která vám budou útočištěm", lambda: [
    gr(), city(140, 230, G, 40), man(80, 1, "reach", "walk", h=54), path(90, G, 160, G, 20, 10)[:0], hills(0, 60, G - 2, 10)])

# --- Deuteronomium ------------------------------------------------------------
A("Dt 1,1", "Toto jsou slova, která Mojžíš mluvil k celému Izraeli", lambda: [
    gr(), man(70, 1, "open", h=58, staff=None), crowd(110, 235, G, 40), hills(130, 240, G - 34, 10)])
A("Dt 3,27", "Vystup na vrchol a pohleď na západ, sever, jih i východ", lambda: [
    smooth([(0, G), (50, G - 40), (90, G - 44), (130, G)]), man(70, 1, "point", g=G - 44, h=40), hills(130, 240, G - 4, 10),
    tree(190, G - 8, 20, "palm"), gr(130, 240)])
A("Dt 7,13", "Bude tě milovat, žehnat ti a rozmnoží tě", lambda: [
    gr(), field(20, 100, G, 5), grapes(120, 60, 1.5), sheep(160, G, 0.9), sheep(190, G, 0.8, -1), kid(220, -1, "raise", h=30), sun(60, 25, 8)])
A("Dt 9,17", "Mojžíš rozbil desky před jejich očima", lambda: [
    gr(), man(110, 1, "raise", h=56), rotate(tablets(160, G, 20), 30, 160, G - 10), stones(190, G, 3), ox(60, G, 0.8)])
A("Dt 11,14", "Dám vaší zemi déšť v pravý čas, ranní i pozdní", lambda: [
    cloud(80, 25, 50), rain(50, 110, 40, 70, 6), gr(), field(30, 140, G, 6), grapes(180, 60, 1.4), tree(215, G, 46)])
A("Dt 14,22", "Každý rok odvedeš desátek z výnosu svého pole", lambda: [
    gr(), man(80, 1, [(30, 100), (30, 100)], h=56), basket(110, G - 30, 18, 10, "bread"), field(140, 230, G, 6)])
A("Dt 15,11", "Otevři svou ruku bratru, chudému a potřebnému", lambda: [
    gr(), man(90, 1, "give", h=56), man(150, -1, "reach", "sit", h=48), rock(150, G, 14, 10), bread(115, G - 32, 7)])
A("Dt 17,18", "Král si opíše tento zákon do knihy", lambda: [
    gr(), king(100, 1, [(60, 100), (40, 80)], "sit", h=56), table(150, G, 50, 26), scroll(150, G - 32, 30, 12), throne(98, G, 40)])
A("Dt 19,14", "Neposuneš mezník svého bližního", lambda: [
    gr(), [(120, G), (118, G - 30), (126, G - 32), (128, G)], field(20, 100, G, 4), field(140, 220, G, 4), man(60, 1, h=50), man(180, -1, h=50)])
A("Dt 22,1", "Uvidíš-li zaběhlého vola svého bratra, přiveď mu ho zpět", lambda: [
    gr(), man(80, 1, "reach", "walk", h=56), ox(130, G, 1.2, 1), man(200, -1, "wide", h=52), house(225, G, 20, 20)[:0]])
A("Dt 24,19", "Zapomeneš-li na poli snop, nech ho cizinci, sirotkovi a vdově", lambda: [
    gr(), field(130, 230, G, 6), [(100, G), (104, G - 18), (110, G)], wheat(104, G - 4, 14), woman(60, 1, "reach", h=48), kid(80, 1, h=26),
    man(170, -1, "point", h=52)])
A("Dt 25,4", "Nezavážeš ústa volu, když mlátí obilí", lambda: [
    gr(), ox(120, G, 1.5, 1), circle(120, G - 4, 34)[0][:0], field(30, 80, G, 3), man(190, -1, staff=0, h=52), ellipse(120, G + 2, 50, 4)])
A("Dt 27,2", "Postavíte velké kameny a napíšete na ně slova zákona", lambda: [
    gr(), [(90, G), (90, G - 40), (150, G - 40), (150, G)], *[[(98, G - 34 + i * 7), (142, G - 34 + i * 7)] for i in range(4)],
    man(60, 1, "point", h=54), mountain(200, G, 60, 40)])
A("Dt 31,8", "Hospodin sám půjde před tebou; nenechá tě", lambda: [
    gr(), man(140, -1, "bless", staff=0, h=56), man(100, 1, "pray", h=54, beard=False), path(100, G, 40, G - 30, 20, 3), rays(30, 30, 6, 20, 0, 360, 8)])

# --- doplnění ------------------------------------------------------------------
A("Gn 21,6", "Sára řekla: Bůh mi připravil smích", lambda: [
    gr(), woman(100, 1, "hold", "sit", h=50), seat(100, G, 14, 13), circle(120, G - 32, 3.5), man(150, -1, "raise", h=56), tent(210, G, 34, 22)])
A("Gn 27,27", "Izák přičichl k Jákobovu oděvu a požehnal mu", lambda: [
    gr(), man(80, 1, [(110, 130), (100, 120)], "sit", h=56), bed(80, G, 40), youth(130, -1, "pray", "kneel", h=48), woman(200, -1, "cry", h=46)])
A("Gn 31,49", "Ať Hospodin bdí mezi mnou a tebou", lambda: [
    gr(), stones(120, G, 5), rock(120, G - 6, 20, 14), man(70, 1, "raise", h=56), man(170, -1, "raise", h=54), eye(120, 30, 16)])
A("Gn 44,12", "Pohár se našel v Benjamínově žoku", lambda: [
    gr(), man(110, 1, "hold", h=54, beard=False), cup(130, G - 30, 1.2), basket(150, G, 18, 10), youth(185, -1, "cry", h=46), donkey(40, G, 1, 1)])
A("Gn 50,20", "Vy jste proti mně zamýšleli zlé, Bůh to obrátil v dobré", lambda: [
    gr(), man(100, 1, "wide", h=56, crown=True), man(150, -1, "cry", "kneel", h=48), man(185, -1, "pray", "kneel", h=48), sun(40, 25, 8)])
A("Ex 5,7", "Už nebudete dávat lidu slámu na výrobu cihel", lambda: [
    gr(), man(80, 1, "carry", h=52), [(66, G - 56), (94, G - 56), (94, G - 50), (66, G - 50), (66, G - 56)],
    wall(120, 180, G, 18, 3), man(210, -1, "point", h=56), sun(40, 25, 8)])
A("Ex 30,18", "Uděláš měděnou nádrž k omývání", lambda: [
    gr(), ellipse(120, G - 30, 20, 5), bez((100, G - 30), (120, G - 6), (140, G - 30)), [(120, G - 18), (120, G)], [(108, G), (132, G)],
    man(70, 1, "reach", h=54, belt=True), tent(200, G, 40, 26)])
A("Ex 39,43", "Mojžíš viděl, že dílo udělali, a požehnal jim", lambda: [
    gr(), tent(160, G, 70, 34), man(70, 1, "wide", h=56), crowd(110, 235, G, 30)[:0], man(100, -1, "pray", h=48), lampstand(215, G, 22)])
A("Lv 22,31", "Dodržujte mé příkazy a jednejte podle nich", lambda: [
    gr(), scroll(120, 50, 40, 18), man(60, 1, "pray", h=52), woman(90, 1, "pray", h=48), man(170, -1, "raise", h=52)])
A("Nu 4,15", "Kehatovci ponesou svaté předměty na tyčích", lambda: [
    gr(), man(70, 1, [(40, 100), (40, 100)], "walk", h=50), man(160, 1, [(40, 100), (40, 100)], "walk", h=50),
    [(60, G - 32), (190, G - 32)], ark_cov(115, G - 33, 30)])
A("Nu 17,23", "Áronova hůl vypučela, rozkvetla a nesla mandle", lambda: [
    gr(), [(120, G), (120, G - 70)], *[circle(120 + dx, G - 70 + dy, 2.5)[0] for dx, dy in ((-6, 4), (5, 0), (-3, 14), (6, 20), (-6, 30))],
    smooth([(120, G - 50), (130, G - 56), (134, G - 50), (120, G - 50)]), [(108, G - 60), (114, G - 64)], man(170, -1, "open", h=54), [(70, G), (70, G - 60)], [(80, G), (80, G - 60)]])
A("Nu 24,17", "Vzejde hvězda z Jákoba", lambda: [
    gr(), star(150, 30, 10), rays(150, 30, 14, 30, 0, 360, 12), man(80, 1, "point", h=56), hills(120, 240, G - 2, 12)])
A("Nu 30,3", "Dá-li muž Hospodinu slib, nezruší své slovo", lambda: [
    gr(), man(110, 1, [(150, 175), (10, 5)], h=56), rays(170, 20, 6, 24, 90, 180, 5), tent(200, G, 34, 22)])
A("Dt 5,12", "Dbej na den odpočinku, abys ho světil", lambda: [
    gr(), house(170, G, 60, 40), man(80, 1, "down", "sit", h=50), woman(110, 1, "pray", "sit", h=46), kid(135, 0, h=26), lamp(170, G - 46, 1.2), moon(40, 20, 6)])
A("Dt 12,7", "Budete jíst před Hospodinem a radovat se vy i vaše domy", lambda: [
    table(120, G, 120, 18), man(60, 1, "raise", "sit", h=50), woman(180, -1, "raise", "sit", h=46), kid(120, 0, "raise", g=G - 18, h=24),
    bread(90, G - 19, 8), grapes(150, G - 24, 0.9), gr()])
A("Dt 20,19", "Nebudeš kácet stromy, které nesou ovoce", lambda: [
    gr(), tree(120, G, 80), *[circle(x, y, 3)[0] for x, y in ((100, 50), (130, 45), (145, 62), (110, 68))], man(190, -1, "down", h=52),
    [(205, G - 30), (210, G - 50), (218, G - 46)]])
A("Dt 28,3", "Požehnaný budeš ve městě a požehnaný na poli", lambda: [
    gr(), city(10, 100, G, 36), field(130, 230, G, 7), sun(170, 25, 9), rays(170, 25, 13, 22, 0, 360, 10)])
A("Dt 32,11", "Jako orel nese svá mláďata na perutích", lambda: [
    eagle(120, 60, 2.6), bird(110, 66, 0.8), bird(130, 64, 0.7), mountain(60, G, 100, 50), mountain(190, G, 90, 36), gr()])
