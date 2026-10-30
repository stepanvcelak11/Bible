"""Doplňkové ilustrace (každá druhá kapitola): Jób – Píseň písní."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import A


def harp_player(x, f=1, h=52):
    return man(x, f, [(40, 100), (30, 90)], "sit", h=h) + harp(x + f * 18, G - 16, 20) + rock(x, G, 14, 12)


# --- Jób ----------------------------------------------------------------------
A("Jb 4,3", "Elífaz: Ty jsi mnohé vyučoval a posiloval ochablé ruce", lambda: [
    gr(), man(80, 1, "cry", "sit", h=54), rock(80, G, 16, 12), man(150, -1, "point", h=56)])
A("Jb 6,15", "Moji bratři zklamali jako potok, který vysychá", lambda: [
    gr(), man(60, 1, "cry", "sit", h=50), rock(60, G, 14, 10), smooth([(110, G + 2), (150, G + 6), (200, G + 3)]), stones(150, G + 2, 4), sun(200, 25, 9)])
A("Jb 8,11", "Roste rákos bez vody, papyrus bez bažiny?", lambda: [
    reeds(60, 180, G, 9), sea(40, 200, G + 6, 2), gr(0, 40), gr(200, 240), man(220, -1, "point", h=46)])
A("Jb 10,8", "Tvé ruce mě vytvořily a uspořádaly", lambda: [
    hand(80, 70, 2, False), hand(160, 70, 2, False), man(120, 0, "open", g=G, h=50), gr(60, 180)])
A("Jb 12,7", "Zeptej se zvířat, ona tě poučí, a ptáků, ti ti to oznámí", lambda: [
    gr(), man(60, 1, "open", h=54), deer(130, G, 1.2, -1), sheep(180, G, 0.8, -1), bird(150, 40, 1.4), bird(190, 30, 1.2), fish(210, G + 12, 0.8)])
A("Jb 14,7", "Strom má naději – i když ho porazí, znovu vypučí", lambda: [
    gr(), stump(110, G, 22), [(140, G - 1), (215, G - 4)], [(140, G - 9), (215, G - 10)], ellipse(140, G - 5, 2.5, 4),
    man(60, 1, "point", h=52)])
A("Jb 16,2", "Vy všichni jste bídní utěšitelé", lambda: [
    gr(), man(70, 1, "cry", "sit", h=50), rock(70, G, 14, 10), man(130, -1, "point", h=54), man(165, -1, "point", h=52), man(200, -1, "open", h=54)])
A("Jb 18,6", "Ve stanu svévolníka světlo potemní a lampa zhasne", lambda: [
    tent(120, G, 80, 50), lamp(120, G - 4, 1.6, lit=False), smooth([(132, G - 10), (128, G - 24), (134, G - 34)]), gr(), moon(210, 20, 6)])
A("Jb 19,25", "Vím, že můj Vykupitel žije", lambda: [
    gr(), man(100, 1, "raise", "sit", h=54), rock(100, G, 16, 12), sun(180, 40, 12), rays(180, 40, 16, 34, 0, 360, 12)])
A("Jb 20,8", "Jako sen odletí a nenajdou ho", lambda: [
    gr(), man(60, 1, "down", "lie", h=50), cloud(160, 50, 50), bird(200, 30, 1.2), bird(220, 22), stars([(30, 30), (120, 20)])])
A("Jb 22,28", "Na tvých cestách zazáří světlo", lambda: [
    path(120, G + 6, 150, G - 50, 70, 4), man(110, 1, "down", "walk", h=46), sun(150, 40, 10), rays(150, 40, 14, 30, 0, 360, 12), gr(0, 70)])
A("Jb 24,5", "Jako divocí osli na poušti vycházejí za potravou", lambda: [
    gr(), donkey(70, G, 1.2, 1), donkey(130, G, 1.1, 1), donkey(180, G, 1, -1), hills(0, 240, G - 4, 10), sun(210, 20, 8)])
A("Jb 26,7", "Zavěsil zemi nad nicotou", lambda: [
    circle(120, 75, 36)[0], smooth([(90, 60), (110, 70), (130, 55), (150, 66)]), smooth([(95, 90), (120, 96), (140, 86)]),
    stars([(30, 30), (60, 110), (200, 30), (210, 110), (40, 70), (190, 80)])])
A("Jb 28,12", "Ale kde se nalézá moudrost?", lambda: [
    smooth([(0, G - 60), (240, G - 60)]), [(70, G - 60), (70, G)], [(170, G - 60), (170, G)], man(120, 1, [(120, 160), (100, 140)], "kneel", h=48),
    [(140, G - 52), (150, G - 60)], lamp(90, G, 1.2), circle(150, G - 10, 3), gr(70, 170)])
A("Jb 29,15", "Byl jsem okem slepému a nohou chromému", lambda: [
    gr(), man(90, 1, [(60, 90), (40, 80)], "walk", h=56), man(130, 1, "reach", "walk", h=52), [(150, G - 30), (156, G)]])
A("Jb 30,31", "Má lyra se změnila v kvílení", lambda: [
    gr(), man(110, 1, "cry", "sit", h=54), rock(110, G, 16, 12), harp(160, G, 22), moon(200, 20, 6)])
A("Jb 32,6", "Elíhú: Jsem mladý, a vy jste starci", lambda: [
    gr(), youth(150, -1, "open", h=54), man(60, 1, "down", "sit", h=50), rock(60, G, 14, 10), man(95, 1, "down", "sit", h=50), rock(95, G, 14, 10)])
A("Jb 34,21", "Jeho oči sledují cesty člověka", lambda: [
    path(120, G + 6, 130, G - 40, 60, 4), man(115, 1, "down", "walk", h=44), eye(130, 30, 22), gr(0, 70)])
A("Jb 36,27", "Vytahuje kapky vody a ty tvoří déšť", lambda: [
    cloud(120, 30, 70), rain(80, 160, 45, 90, 12), sea(20, 220, G + 4, 2), *[[(x, G - 2), (x, G - 14)] for x in (60, 100, 140, 180)]])
A("Jb 40,15", "Pohleď na behemota, kterého jsem učinil jako tebe", lambda: [
    gr(), smooth([(60, G - 6), (60, G - 30), (100, G - 40), (160, G - 38), (190, G - 28), (195, G - 16), (180, G - 14)]),
    [(70, G - 8), (70, G)], [(90, G - 8), (90, G)], [(150, G - 8), (150, G)], [(170, G - 12), (170, G)], circle(184, G - 28, 1.5), reeds(200, 235, G, 3)])

# --- Žalmy --------------------------------------------------------------------
A("Ž 3,4", "Ty, Hospodine, jsi štít kolem mne", lambda: [
    gr(), man(100, 1, "down", "lie", h=54), shield(150, G - 40, 3), moon(40, 20, 6), stars([(200, 20), (220, 40)])])
A("Ž 5,4", "Hospodine, ráno uslyšíš můj hlas", lambda: [
    gr(), man(90, 1, "raise", "kneel", h=54), sun(180, G - 6, 14), rays(180, G - 6, 18, 36, 200, 340, 7)])
A("Ž 7,2", "Hospodine, můj Bože, u tebe hledám útočiště", lambda: [
    rock(130, G, 90, 60), man(130, 0, "pray", g=G - 58, h=30), gr(), lion(40, G, 1, 1)])
A("Ž 10,14", "Ty jsi pomocník sirotka", lambda: [
    gr(), kid(110, 1, "reach", h=32), hand(150, G - 50, 1.6, False), rays(150, 20, 6, 20, 0, 360, 8), house(40, G, 30, 24)])
A("Ž 12,7", "Hospodinova slova jsou čistá jako stříbro sedmkrát přetavené", lambda: [
    gr(), furnace(100, G, 60, 40), flames(100, G - 6, 20), cup(160, G - 10, 2), rays(160, G - 26, 8, 16, 0, 360, 8)])
A("Ž 14,2", "Hospodin shlíží z nebe na lidi", lambda: [
    cloud(120, 30, 70), eye(120, 26, 16), gr(), crowd(30, 210, G, 36)])
A("Ž 16,6", "Měřicí šňůra mi padla na místa půvabná", lambda: [
    gr(), field(30, 110, G, 5), tree(150, G, 40), rope(20, G + 6, 220, G + 6), man(200, -1, "raise", h=52), vine(160, 60, 200, 2)[:0]])
A("Ž 18,34", "Dává mým nohám hbitost laní a staví mě na výšinách", lambda: [
    mountain(130, G, 160, 80), deer(130, G - 76, 1.2, 1), gr()])
A("Ž 20,8", "Jedni spoléhají na vozy, jiní na koně, my na jméno Hospodina", lambda: [
    gr(), chariot(60, G, 1, 1), horse(100, G, 1.1, 1), man(180, -1, "raise", h=56), rays(200, 20, 6, 30, 90, 160, 5)])
A("Ž 22,2", "Bože můj, Bože můj, proč jsi mě opustil?", lambda: [
    smooth([(0, G), (120, G - 20), (240, G)]), cross(120, G - 20, 90), J(120, 0, "wide", g=G - 30, h=60)[:6], cloud(60, 20, 40), cloud(190, 20, 40)])
A("Ž 25,4", "Hospodine, dej mi poznat své cesty", lambda: [
    path(120, G + 6, 100, G - 50, 70, 4), path(150, G - 10, 220, G - 40, 20, 3), man(120, 1, "pray", h=40), gr(0, 70)])
A("Ž 27,1", "Hospodin je mé světlo a má spása – koho bych se bál?", lambda: [
    gr(), man(100, 1, "raise", h=56), sun(170, 40, 12), rays(170, 40, 16, 34, 0, 360, 12), cloud(40, 30, 40)])
A("Ž 29,3", "Hospodinův hlas nad vodami, Bůh slávy hřmí", lambda: [
    sea(0, 240, G - 10, 4), cloud(120, 25, 80), [(120, 40), (110, 58), (122, 58), (108, 80)], boat(190, G - 14, 30)])
A("Ž 31,16", "V tvých rukou jsou mé časy", lambda: [
    hand(120, 70, 3, True), hourglass(120, 50, 1.2), gr(60, 180, 120)])
A("Ž 33,3", "Zpívejte mu novou píseň, hrajte krásně za zvuku jásotu", lambda: [
    gr(), harp_player(60), woman(120, 1, "raise", h=48), man(160, -1, "raise", h=52), kid(190, -1, "raise", h=28)])
A("Ž 35,10", "Hospodine, kdo je jako ty? Vysvobozuješ ubohého", lambda: [
    gr(), man(120, 1, "raise", h=54), chain(80, G - 2, 60, G, 4), chain(160, G - 2, 180, G, 4), sun(200, 25, 8)])
A("Ž 37,5", "Svěř Hospodinu svou cestu, doufej v něj a on jednat bude", lambda: [
    path(120, G + 6, 150, G - 50, 70, 4), man(120, 1, "down", "walk", h=46), hand(170, 40, 1.4, True), gr(0, 70)])
A("Ž 39,5", "Hospodine, dej mi poznat, jak je můj život krátký", lambda: [
    gr(), man(70, 1, "pray", "sit", h=50), rock(70, G, 14, 10), hourglass(150, 70, 2.5)])
A("Ž 41,2", "Blaze tomu, kdo pamatuje na ubohého", lambda: [
    gr(), man(90, 1, "give", h=54), man(150, -1, "reach", "sit", h=46), rock(150, G, 14, 10), bread(115, G - 32, 7)])
A("Ž 44,4", "Nedobyli zemi svým mečem, ale tvá pravice", lambda: [
    gr(), sword(60, G, 30, 70), hand(140, 60, 2, False), rays(140, 30, 6, 24, 0, 360, 10), hills(80, 240, G - 2, 12)])
A("Ž 48,3", "Hora Sijón, krásná výšina, radost celé země", lambda: [
    mountain(120, G, 180, 50), city(70, 170, G - 46, 34), gr(), sun(210, 25, 8)])
A("Ž 50,10", "Mně patří všechna zvěř lesa i dobytek na tisících horách", lambda: [
    hills(0, 240, G - 20, 24), deer(50, G, 1, 1), ox(110, G, 0.9, 1), sheep(160, G, 0.8), lion(205, G, 0.8, -1), gr(), tree(30, G - 18, 30)])
A("Ž 51,12", "Čisté srdce stvoř mi, Bože", lambda: [
    heart(120, 60, 26), rays(120, 56, 32, 46, 0, 360, 14), man(120, 0, "pray", "kneel", h=40), gr(60, 180)])
A("Ž 54,6", "Bůh je můj pomocník", lambda: [
    gr(), man(110, 1, "raise", h=54), hand(170, 40, 1.4, False), rock(40, G, 30, 20)])
A("Ž 56,9", "Mé slzy jsou ve tvé lahvi", lambda: [
    gr(), jar(130, G, 2.2), man(70, 1, "cry", "kneel", h=50), *[circle(130 + dx, 50 + dy, 1.4)[0] for dx, dy in ((-4, 0), (2, 6), (-1, 12))]])
A("Ž 58,12", "Opravdu je Bůh, který soudí na zemi", lambda: [scales(120, 30, 3), gr(40, 200)])
A("Ž 60,14", "S Bohem dokážeme mocné věci", lambda: [
    gr(), man(90, 1, "raise", h=56), man(130, 1, "raise", h=52), shield(170, G - 30, 1.4), mountain(210, G, 60, 40)])
A("Ž 62,2", "Jen v Bohu se ztiší má duše", lambda: [
    sea(20, 220, G + 4, 1), smooth([(20, G - 6), (120, G - 4), (220, G - 6)]), man(120, 0, "pray", "sit", h=48), rock(120, G - 4, 16, 10), moon(200, 20, 6)])
A("Ž 64,11", "Spravedlivý se raduje v Hospodinu a hledá v něm útočiště", lambda: [
    gr(), man(110, 1, "raise", h=56), tree(190, G, 50), flowers(20, 80, G, 4)])
A("Ž 66,12", "Prošli jsme ohněm a vodou, ale vyvedl jsi nás na volnost", lambda: [
    flames(50, G - 4, 30), sea(90, 160, G + 4, 3), gr(160, 240), man(200, 1, "raise", h=52), gr(0, 90)])
A("Ž 68,7", "Bůh dává osamělým domov", lambda: [
    gr(), house(140, G, 70, 46), man(90, 1, "down", "walk", h=50), kid(110, 1, h=26), lamp(160, G - 30, 1)])
A("Ž 70,2", "Bože, pospěš mě vysvobodit", lambda: [
    gr(0, 90), man(60, 1, "raise", g=G, h=52), hand(130, 40, 1.6, False), smooth([(90, G), (110, G + 20), (130, G + 30)])])
A("Ž 72,6", "Sestoupí jako déšť na posekanou louku", lambda: [
    cloud(120, 25, 70), rain(80, 160, 40, 80, 10), gr(), tufts(20, 220, G, 10), flowers(30, 210, G, 6)])
A("Ž 74,16", "Tvůj je den i noc, ty jsi upevnil světlo i slunce", lambda: [
    sun(70, 60, 16), rays(70, 60, 20, 30, 0, 360, 12), moon(170, 60, 14), stars([(200, 30), (220, 70), (150, 30)]), gr(20, 220)])
A("Ž 76,4", "Tam zlámal ohnivé šípy, štít i meč", lambda: [
    gr(), shield(80, G - 10, 1.4), rotate(sword(120, G - 4, 30, 90), 0, 0, 0), [(150, G - 2), (165, G - 12)], [(168, G - 14), (180, G - 20)],
    rays(120, 20, 6, 26, 0, 360, 10)])
A("Ž 78,4", "Budeme vyprávět příštímu pokolení o Hospodinových činech", lambda: [
    gr(), man(80, 1, "open", "sit", h=56), rock(80, G, 18, 14), kid(130, -1, "down", "sit", h=30), kid(155, -1, "raise", "sit", h=28),
    youth(190, -1, "down", "sit", h=40), flames(110, G - 2, 10)])
A("Ž 80,9", "Vinnou révu jsi přenesl z Egypta a zasadil ji", lambda: [
    gr(), smooth([(120, G), (115, G - 30), (90, G - 50), (50, G - 56)]), smooth([(117, G - 25), (150, G - 50), (200, G - 54)]),
    grapes(70, G - 52, 1.4), grapes(170, G - 50, 1.4), hand(120, G - 70, 1.2, False)])
A("Ž 82,3", "Zastávejte se nuzného a sirotka", lambda: [
    gr(), man(90, 1, "bless", h=56), kid(130, -1, "reach", h=30), woman(160, -1, "pray", h=46), scales(40, 40, 1.2)])
A("Ž 84,4", "I vrabec našel dům a vlaštovka hnízdo u tvých oltářů", lambda: [
    gr(), altar(120, G, 40, 30), bird(110, G - 50, 1.4), bird(140, G - 60, 1.2), ellipse(130, G - 32, 8, 3, 0, 180), temple(120, G, 200, 90)[:0]])
A("Ž 86,11", "Vyuč mě své cestě, Hospodine, abych chodil v tvé pravdě", lambda: [
    path(120, G + 6, 140, G - 50, 70, 4), man(110, 1, "pray", h=40), scroll(190, 50, 30, 14), gr(0, 70)])
A("Ž 88,2", "Ve dne volám a v noci k tobě", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=54), sun(40, 30, 8), moon(200, 30, 7), stars([(170, 20), (220, 50)])])
A("Ž 90,2", "Dříve než se zrodily hory, od věků na věky jsi Bůh", lambda: [
    mountain(80, G, 120, 60), mountain(170, G, 110, 50), gr(), rays(120, 10, 6, 30, 30, 150, 7)])
A("Ž 93,4", "Mocnější než hukot mnohých vod je Hospodin na výšinách", lambda: [
    sea(0, 240, G - 20, 4), waves(0, 240, G - 34, 8, 4), rays(120, 10, 6, 30, 40, 140, 7), cloud(120, 20, 50)])
A("Ž 95,6", "Pojďte, padněme na tvář a poklekněme před Hospodinem", lambda: [
    gr(), man(60, 1, "pray", "kneel", h=50), woman(100, 1, "pray", "kneel", h=46), man(150, 1, "pray", "bow", h=50), kid(190, 1, "pray", "kneel", h=28)])
A("Ž 97,11", "Pro spravedlivého vzchází světlo a pro upřímné radost", lambda: [
    sun(120, G - 4, 18), rays(120, G - 4, 24, 46, 200, 340, 9), gr(), man(60, 1, "raise", h=40), woman(185, -1, "raise", h=38)])
A("Ž 99,6", "Mojžíš, Áron a Samuel vzývali Hospodina a on jim odpovídal", lambda: [
    gr(), man(70, 1, "raise", staff=1, h=56), man(115, 1, "raise", h=54, belt=True), man(160, 1, "raise", h=52), rays(200, 20, 6, 30, 90, 180, 5)])
A("Ž 101,2", "Budu chodit v bezúhonnosti srdce ve svém domě", lambda: [
    gr(), house(130, G, 90, 50), man(110, 1, "down", "walk", h=40), heart(160, G - 30, 6)])
A("Ž 103,12", "Jak je vzdálen východ od západu, tak vzdálil od nás naše viny", lambda: [
    sun(30, G - 8, 12), sun(210, G - 8, 12), gr(), smooth([(50, G - 30), (120, G - 50), (190, G - 30)]), [(184, G - 34), (190, G - 30), (184, G - 26)]])
A("Ž 105,39", "Rozestřel oblak jako pokrývku a oheň, aby svítil v noci", lambda: [
    cloud(70, 30, 50), flames(180, 50, 24), tent(70, G, 34, 20), tent(130, G, 30, 18), tent(190, G, 30, 18), gr(), moon(220, 15, 5)])
A("Ž 107,29", "Utišil bouři v šepot a vlny se uklidnily", lambda: [
    boat(120, G - 6, 90, True), sea(0, 240, G, 2), man(110, 1, "raise", g=G - 20, h=30), sun(200, 25, 8)])
A("Ž 109,26", "Pomoz mi, Hospodine, můj Bože, zachraň mě", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=54), hand(170, 40, 1.4, False), rays(170, 20, 6, 18, 0, 360, 8)])
A("Ž 111,10", "Počátek moudrosti je bázeň Hospodinova", lambda: [
    gr(), man(100, 1, "pray", "bow", h=54), scroll(180, 60, 34, 16), lamp(180, 36, 1.4)])
A("Ž 113,7", "Pozvedá nuzného z prachu a ubožáka ze smetiště", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=50), hand(150, G - 40, 1.6, True), stones(60, G, 4)])
A("Ž 115,4", "Jejich modly jsou stříbro a zlato – mají ústa, a nemluví", lambda: [
    gr(), [(80, G), (80, G - 8), (110, G - 8), (110, G)], person(95, G - 8, 40, 0, "stand", "hang"), man(170, -1, "raise", h=54)])
A("Ž 117,1", "Chvalte Hospodina, všechny národy", lambda: [
    gr(), crowd(10, 230, G, 44, 12), rays(120, 10, 6, 34, 30, 150, 8)])
A("Ž 123,2", "Jako oči služebníků k ruce pánů, tak naše oči k Hospodinu", lambda: [
    gr(), man(80, 1, "pray", h=54), woman(110, 1, "pray", h=48), hand(180, 50, 1.6, False), rays(180, 30, 6, 20, 0, 360, 8)])
A("Ž 125,2", "Jako hory kolem Jeruzaléma, tak je Hospodin kolem svého lidu", lambda: [
    mountain(40, G, 80, 60), mountain(200, G, 80, 60), city(80, 160, G, 30), gr()])
A("Ž 129,3", "Na mých zádech orali oráči, ale Hospodin je spravedlivý", lambda: [
    gr(), plough(80, G, 1), ox(140, G, 1.1, 1), *[[(10, G + 4 + i * 4), (230, G + 4 + i * 4)] for i in range(3)], man(50, 1, staff=0, h=50)])
A("Ž 131,2", "Utišil jsem svou duši jako odstavené dítě u matky", lambda: [
    gr(), woman(110, 1, "hold", "sit", h=52), seat(110, G, 16, 14), kid(128, 0, "down", "sit", g=G - 22, h=20), moon(200, 20, 6)])
A("Ž 133,1", "Jak je dobré a milé, když bratři bydlí spolu", lambda: [
    gr(), man(60, 1, "wide", h=54), man(90, -1, "wide", h=52), man(130, 1, "wide", h=50), man(160, -1, "wide", h=54), house(210, G, 36, 30)])
A("Ž 135,7", "Vyvádí mraky od konce země, dělá blesky pro déšť", lambda: [
    cloud(80, 30, 60), cloud(170, 40, 50), [(170, 50), (162, 64), (172, 64), (160, 84)], rain(50, 110, 46, 80, 8), gr(), hills(0, 240, G - 2, 10)])
A("Ž 139,9", "I kdybych se usadil na konci moře, tvá pravice mě bude držet", lambda: [
    sea(0, 240, G - 10, 3), sun(200, G - 18, 12), man(80, 1, "raise", g=G - 14, h=40)[:12], hand(120, 50, 1.8, False), bird(170, 40, 1.2)])
A("Ž 141,2", "Má modlitba ať je jako kadidlo před tebou", lambda: [
    gr(), man(80, 1, "raise", h=56), altar(150, G, 20, 12), smooth([(150, G - 14), (144, G - 34), (156, G - 54), (148, G - 74)]),
    smooth([(154, G - 14), (162, G - 34), (154, G - 60)])])
A("Ž 142,1", "Davidova modlitba, když byl v jeskyni", lambda: [
    smooth([(10, G), (30, G - 60), (120, G - 84), (210, G - 60), (230, G)]), man(120, 1, "raise", "kneel", h=46), gr()])
A("Ž 143,6", "Vztahuji k tobě ruce, má duše žízní jako vyprahlá země", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=54), *[[(x, G + 2), (x + 6, G + 8)] for x in (40, 60, 160, 190)], sun(200, 25, 10)])
A("Ž 145,16", "Otvíráš svou ruku a sytíš vše živé", lambda: [
    hand(120, 40, 2, False), bird(70, 60, 1.2), sheep(80, G, 0.8), deer(160, G, 1, -1), bird(170, 70, 1), gr(), field(190, 240, G, 2)])
A("Ž 147,4", "Určuje počet hvězd a každou volá jménem", lambda: [
    stars([(20, 20), (50, 40), (80, 15), (110, 35), (140, 20), (170, 45), (200, 15), (225, 40), (60, 70), (130, 65), (190, 75), (30, 90),
           (100, 95), (160, 100), (220, 95)]), star(120, 50, 6), gr(40, 200, 120)])
A("Ž 149,3", "Chvalte jeho jméno tancem, hrajte mu na buben a citaru", lambda: [
    gr(), woman(60, 1, [(150, 170), (120, 150)], "walk", h=50), circle(78, G - 60, 6), man(110, 1, "raise", "walk", h=54), harp_player(170, -1)])

# --- Přísloví, Kazatel, Píseň ------------------------------------------------
A("Př 2,4", "Hledej moudrost jako stříbro, pátrej po ní jako po pokladu", lambda: [
    gr(), man(80, 1, [(100, 150), (80, 140)], "kneel", h=54), [(110, G - 40), (120, G)], [(130, G), (160, G), (162, G - 12), (128, G - 12), (130, G)],
    coins(145, G - 14, 4)])
A("Př 5,15", "Pij vodu ze své vlastní studny", lambda: [gr(), well(110, G, 26), man(70, 1, "hold", h=54), jar(160, G, 0.9), house(210, G, 30, 24)])
A("Př 8,3", "Moudrost volá u bran, u vchodu do města", lambda: [
    gr(), gate(70, G, 50, 60), woman(130, 1, "open", h=52), crowd(160, 235, G, 30)])
A("Př 10,5", "Kdo sklízí v létě, je rozumný syn", lambda: [
    gr(), field(120, 230, G, 7), youth(80, 1, [(80, 140), (60, 90)], h=52), sickle(100, G - 40, 1.4), sun(40, 25, 8)])
A("Př 12,25", "Starost tíží srdce, ale dobré slovo ho rozveselí", lambda: [
    gr(), man(80, 1, "cry", "sit", h=50), rock(80, G, 14, 10), man(140, -1, "bless", h=54), heart(110, 40, 6)])
A("Př 14,4", "Kde nejsou voli, je žlab prázdný; síla býka přináší hojnost", lambda: [
    gr(), ox(100, G, 1.4, 1), manger(170, G, 30), field(20, 60, G, 3)])
A("Př 16,9", "Člověk si v srdci plánuje cestu, ale Hospodin řídí jeho kroky", lambda: [
    path(120, G + 6, 150, G - 50, 70, 4), man(110, 1, "point", "walk", h=46), hand(170, 40, 1.4, False), gr(0, 70)])
A("Př 18,10", "Hospodinovo jméno je pevná věž", lambda: [gr(), tower(140, G, 30, 90), man(80, 1, "reach", "walk", h=50)])
A("Př 20,12", "Ucho, které slyší, a oko, které vidí – obojí učinil Hospodin", lambda: [
    eye(80, 70, 30), smooth([(170, 50), (185, 52), (190, 70), (178, 88), (170, 84)]), smooth([(176, 62), (182, 70), (176, 76)])])
A("Př 22,6", "Vychovávej dítě na začátku jeho cesty", lambda: [
    gr(), man(100, 1, [(60, 90), (10, 5)], "walk", h=56), kid(125, 1, "reach", "walk", h=30), path(130, G, 210, G - 40, 20, 3)])
A("Př 24,31", "Pole lenocha zarostlo trním a zeď se zbořila", lambda: [
    gr(), wall(120, 220, G, 20, 2, broken=True), bush(60, G, 30), bush(100, G, 20), man(40, 1, "down", "lie", h=40)])
A("Př 26,14", "Jako se dveře otáčejí na veřejích, tak lenoch na lůžku", lambda: [
    gr(), door(60, G, 20, 40), bed(150, G, 70), man(130, 1, "down", "lie", g=G - 6, h=50), sun(210, 25, 8)])
A("Př 28,1", "Spravedliví jsou smělí jako mladý lev", lambda: [gr(), lion(120, G, 2, 1), hills(0, 240, G - 2, 10), sun(200, 25, 8)])
A("Př 30,24", "Čtyři maličcí na zemi, a přece moudří", lambda: [
    gr(), ant(40, G - 3, 2), rock(100, G, 30, 20), circle(100, G - 24, 4), locust(160, 70, 1.6), smooth([(200, G - 20), (210, G - 22), (220, G - 18)]),
    [(205, G - 21), (203, G - 17)], [(214, G - 21), (216, G - 17)]])
A("Kaz 2,4", "Stavěl jsem si domy a sázel vinice", lambda: [
    gr(), house(60, G, 50, 36), king(120, 1, "point", h=54), vine(150, 70, 230, 3), [(150, 70), (150, G)], [(230, 72), (230, G)]])
A("Kaz 6,7", "Všechno lidské pachtění je pro ústa", lambda: [
    gr(), man(110, 1, "hold", "sit", h=52), seat(110, G, 14, 13), bread(132, G - 32, 7), field(160, 230, G, 4)])
A("Kaz 8,1", "Moudrost rozjasňuje tvář člověka", lambda: [
    gr(), man(110, 1, "open", h=56), rays(112, G - 50, 10, 20, 0, 360, 10), scroll(180, 60, 30, 14)])
A("Kaz 10,18", "Pro lenost se propadá strop", lambda: [
    gr(), [(60, G), (60, G - 50)], [(180, G), (180, G - 50)], [(56, G - 50), (110, G - 50), (120, G - 40), (130, G - 50), (184, G - 50)],
    man(120, 1, "down", "lie", h=50)])
A("Pís 4,16", "Vítr, přijď do mé zahrady, ať se šíří vůně", lambda: [
    gr(), tree(50, G, 50), tree(190, G, 46), flowers(80, 160, G, 6), smooth([(60, 40), (100, 30), (140, 40)]), smooth([(80, 55), (120, 48), (160, 56)])])
A("Pís 6,2", "Můj milý sestoupil do své zahrady mezi lilie", lambda: [
    gr(), youth(110, 1, "down", "walk", h=54), lily(60, G, 16), lily(75, G, 14), lily(150, G, 18), lily(170, G, 15), tree(210, G, 40)])
A("Ž 52,10", "Jsem jako zelenající se oliva v Božím domě", lambda: [
    gr(), tree(120, G, 90), *[ellipse(x, y, 2.5, 1.6)[:] for x, y in ((100, 50), (130, 45), (145, 62), (110, 68), (125, 58))], temple(210, G, 40, 30)])
