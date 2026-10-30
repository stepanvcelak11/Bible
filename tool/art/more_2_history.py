"""Doplňkové ilustrace (každá druhá kapitola): Jozue – Ester."""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import A

# --- Jozue, Soudců, Rút -------------------------------------------------------
A("Joz 5,13", "Jozue uviděl muže s taseným mečem – velitele Hospodinova vojska", lambda: [
    gr(), man(80, 1, "pray", "kneel", h=54), man(150, -1, [(140, 170), (10, 5)], h=62), sword(140, G - 70, 30, 10), city(190, 240, G, 30)])
A("Joz 8,34", "Jozue přečetl všechna slova zákona, požehnání i zlořečení", lambda: [
    gr(), man(120, 0, "hold", h=56), scroll(120, G - 38, 26, 12), crowd(10, 90, G, 36), crowd(150, 235, G, 36), mountain(40, G - 30, 60, 30)])
A("Joz 10,12", "Slunce, zastav se nad Gibeónem, a ty, měsíci, nad údolím", lambda: [
    gr(), man(120, 1, "raise", h=56), sun(60, 30, 10), moon(190, 30, 8), hills(0, 240, G - 2, 12)])
A("Joz 12,1", "Toto jsou králové země, které Izraelci porazili", lambda: [
    gr(), *[g for i, x in enumerate((40, 80, 120, 160, 200)) for g in crown(x, 70 + (i % 2) * 10, 16)], man(120, 0, "raise", h=40)])
A("Joz 14,11", "Káleb: Ještě dnes jsem tak silný jako v den, kdy mě Mojžíš poslal", lambda: [
    gr(), man(100, 1, "raise", staff=None, h=58), mountain(180, G, 100, 60), man(60, 1, "down", h=52, beard=False)])
A("Joz 15,19", "Aksa prosila otce: Dej mi i prameny vod", lambda: [
    gr(), woman(90, 1, "reach", h=50), man(140, -1, "give", h=56), smooth([(160, G + 6), (200, G + 2), (235, G + 7)]), donkey(40, G, 1, 1)])
A("Joz 18,1", "Celá pospolitost se shromáždila v Šílu a postavila tam stan setkávání", lambda: [
    gr(), tent(120, G, 70, 36), crowd(10, 80, G, 34), crowd(165, 235, G, 34), hills(0, 240, G - 40, 8)])
A("Joz 20,3", "Útočištná města – tam se může utéct, kdo zabil neúmyslně", lambda: [
    gr(), city(140, 230, G, 40), man(80, 1, "reach", "walk", h=54), gate(185, G, 24, 30)[:0], hills(0, 60, G - 2, 10)])
A("Joz 22,10", "Postavili u Jordánu veliký oltář jako svědka", lambda: [
    gr(0, 130), altar(70, G, 40, 30), sea(130, 240, G + 4, 3), man(30, 1, "point", h=50), man(110, -1, h=46)])
A("Sd 2,16", "Hospodin povolával soudce, aby je zachraňovali", lambda: [
    gr(), man(120, 0, "raise", h=58), crowd(10, 90, G, 36), crowd(150, 235, G, 36), rays(120, 20, 6, 30, 40, 140, 7)])
A("Sd 9,8", "Stromy se vydaly pomazat si krále – olivu, fíkovník, vinnou révu", lambda: [
    gr(), tree(50, G, 56), tree(110, G, 46), vine(150, 70, 190, 2), [(150, 70), (150, G)], [(190, 72), (190, G)], bush(215, G, 20)])
A("Sd 11,1", "Gileádský Jiftach byl udatný bojovník", lambda: [
    gr(), man(110, 1, [(40, 60), (10, 5)], h=58, belt=True), sword(98, G - 20, 26, 180), shield(130, G - 34, 1.4), hills(150, 240, G - 2, 12)])
A("Sd 13,20", "Anděl Hospodinův vystoupil v plameni oltáře", lambda: [
    gr(), altar(120, G, 26, 16, True), angel(120, 0, "raise", G - 40, 40), man(60, 1, "cry", "bow", h=52), woman(190, -1, "cry", "bow", h=46)])
A("Sd 17,6", "Každý dělal, co uznal za správné", lambda: [
    gr(), man(40, 1, "point", h=52), man(90, -1, "point", h=52), man(150, 1, "open", h=52), man(200, -1, "back", h=52),
    path(120, G, 30, G - 40, 12, 2), path(120, G, 210, G - 40, 12, 2)])
A("Sd 20,1", "Všichni Izraelci se shromáždili jako jeden muž", lambda: [gr(), crowd(10, 230, G, 44, 12), man(120, 0, "raise", g=G - 40, h=30)])
A("Rt 4,16", "Noemi vzala dítě do náruče a stala se mu chůvou", lambda: [
    gr(), woman(100, 1, "hold", "sit", h=50), seat(100, G, 14, 13), circle(120, G - 32, 3.5), woman(150, -1, "raise", h=48), man(180, -1, h=54),
    field(200, 240, G, 2)])

# --- Samuel -------------------------------------------------------------------
A("1S 5,3", "Dágon ležel tváří k zemi před Hospodinovou truhlou", lambda: [
    gr(), ark_cov(80, G, 36), rotate(person(160, G, 50, 1, "stand", "down"), 85, 160, G - 2), pillar(220, G, 60), pillar(20, G, 60)])
A("1S 7,12", "Samuel postavil kámen a nazval ho Eben-ezer: Až potud nám pomáhal Hospodin", lambda: [
    gr(), rock(120, G, 30, 40), man(70, 1, "raise", h=56), hills(150, 240, G - 2, 12), sun(200, 25, 8)])
A("1S 9,3", "Saul šel hledat oslice svého otce", lambda: [
    gr(), youth(90, 1, "point", "walk", h=58), youth(120, 1, "down", "walk", h=48), hills(130, 240, G - 2, 18), donkey(200, G - 18, 0.8, -1)])
A("1S 10,1", "Samuel vylil Saulovi olej na hlavu a políbil ho", lambda: [
    gr(), man(80, 1, [(130, 160), (10, 5)], h=56), horn(92, G - 64, 1), youth(130, -1, "pray", h=60), donkey(200, G, 1, -1)])
A("1S 12,18", "Samuel volal k Hospodinu a ten dal hromy a déšť", lambda: [
    cloud(120, 25, 70), rain(70, 170, 40, 70, 10), [(150, 35), (142, 50), (150, 50), (140, 66)], gr(), man(60, 1, "raise", h=56),
    crowd(110, 235, G, 34)])
A("1S 15,22", "Poslušnost je lepší než oběť", lambda: [
    gr(), man(80, 1, "point", h=56), king(140, -1, "cry", h=56), sheep(185, G, 0.8), sheep(205, G, 0.8, -1), ox(225, G, 0.6, -1)])
A("1S 20,20", "Jónatan vystřelil tři šípy jako znamení pro Davida", lambda: [
    gr(), youth(70, 1, [(90, 95), (60, 80)], h=54), [(85, G - 50), (88, G - 30)], [(150, 50), (180, 60)], kid(140, 1, "reach", "walk", h=30),
    rock(210, G, 30, 22), youth(210, -1, h=30)[:0]])
A("1S 22,1", "David utekl do jeskyně Adulam", lambda: [
    smooth([(20, G), (40, G - 60), (120, G - 80), (200, G - 60), (220, G)]), youth(120, 0, "pray", "sit", h=46), gr(), crowd(150, 210, G, 24)])
A("1S 25,23", "Abígajil spěšně sesedla z osla a padla před Davidem", lambda: [
    gr(), donkey(50, G, 1.1, 1), woman(100, 1, "pray", "bow", h=50), man(160, -1, "open", h=56), basket(80, G, 14, 8, "bread"), crowd(190, 235, G, 30)])
A("1S 27,1", "David si řekl: Uteču do pelištejské země", lambda: [
    gr(), man(110, 1, "cry", "sit", h=54), rock(110, G, 16, 12), path(140, G, 220, G - 40, 30, 4), city(180, 235, G - 40, 20)])
A("1S 30,6", "David byl ve velké tísni, ale posilnil se v Hospodinu", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=56), flames(190, G - 20, 20), wall(170, 230, G, 20, 2, broken=True), crowd(10, 70, G, 30)])
A("2S 2,4", "Judovci přišli a pomazali Davida za krále", lambda: [
    gr(), man(120, 0, "pray", h=56, crown=True), crowd(10, 90, G, 36), crowd(150, 235, G, 36), horn(130, G - 70, 1)])
A("2S 3,31", "David šel za márami a plakal", lambda: [
    gr(), man(80, 1, "cry", "walk", h=54), man(130, 1, [(40, 100), (40, 100)], "walk", h=48), man(190, 1, [(40, 100), (40, 100)], "walk", h=48),
    [(120, G - 30), (200, G - 30)], [(130, G - 33), (190, G - 33)]])
A("2S 7,18", "Král David přišel, usedl před Hospodinem a řekl: Kdo jsem já?", lambda: [
    gr(), king(90, 1, "pray", "sit", h=56), seat(88, G, 16, 15), ark_cov(170, G, 34), tent(170, G, 70, 50)[:2]])
A("2S 10,12", "Buď silný, buďme stateční pro svůj lid", lambda: [
    gr(), man(100, 1, [(100, 130), (10, 5)], h=56), man(140, -1, [(100, 130), (10, 5)], h=56), shield(80, G - 30, 1.2), shield(160, G - 30, 1.2)])
A("2S 14,33", "Král políbil Absolóna", lambda: [
    gr(), king(110, 1, "wide", h=56), youth(140, -1, "pray", "kneel", h=48), throne(60, G, 40)])
A("2S 15,30", "David vystupoval na Olivovou horu s plačem a bosý", lambda: [
    smooth([(0, G), (120, G - 30), (240, G - 50)]), man(110, 1, "cry", "walk", g=G - 28, h=50), crowd(10, 80, G, 30), tree(200, G - 46, 30)])
A("2S 18,9", "Absolón se zachytil hlavou v dubu", lambda: [
    gr(), tree(120, G, 90), youth(110, 0, "raise", g=G - 30, h=40), horse(190, G, 1.2, 1)])
A("2S 19,1", "Můj synu Absolóne! Kéž bych zemřel místo tebe", lambda: [
    gr(), wall(120, 220, G, 50, 5), gate(170, G, 30, 40)[1:2], king(80, 1, "cry", h=58)])
A("2S 22,2", "Hospodin je můj skalní útes, má pevnost a můj vysvoboditel", lambda: [
    mountain(150, G, 120, 80), man(60, 1, "raise", h=56), harp(90, G, 20), gr(), tower(150, G - 74, 14, 20)])
A("2S 23,15", "Kdo by mi dal napít vody ze studny u betlémské brány!", lambda: [
    gr(), well(150, G, 22), man(70, 1, "reach", "sit", h=54), man(190, -1, "hold", h=52), jar(178, G - 30, 0.6), city(200, 240, G, 24)])

# --- Královské ----------------------------------------------------------------
A("1Kr 1,38", "Šalomoun jel na mezku krále Davida do Gíchonu", lambda: [
    gr(), donkey(110, G, 1.6, 1), man(105, 1, "bless", "sit", g=G - 16, h=46, crown=True), man(160, 1, "raise", h=52), trumpet(172, G - 50, 18, -30)])
A("1Kr 4,20", "Judy a Izraele bylo jako písku u moře; jedli, pili a radovali se", lambda: [
    gr(), table(120, G, 120, 16), man(70, 1, "raise", "sit", h=48), woman(110, 1, "raise", "sit", h=44), man(150, -1, "raise", "sit", h=48),
    grapes(180, 30, 1.2), sea(10, 230, G + 8, 1)])
A("1Kr 8,22", "Šalomoun stál před oltářem a rozpjal ruce k nebi", lambda: [
    gr(), king(120, 0, "raise", h=58), temple(120, G - 20, 160, 40)[:0], altar(180, G, 26, 16, True), crowd(10, 70, G, 30)])
A("1Kr 11,30", "Achijáš roztrhl nový plášť na dvanáct kusů", lambda: [
    gr(), man(80, 1, "hold", h=56), *[[(110 + i * 8, G - 34 + (i % 2) * 4), (115 + i * 8, G - 26)] for i in range(6)], youth(190, -1, h=52)])
A("1Kr 13,24", "Na cestě ho potkal lev; osel i lev stáli u těla", lambda: [
    gr(), donkey(70, G, 1.1, 1), lion(170, G, 1.2, -1), man(120, 1, "down", "lie", h=40), path(0, G, 30, G - 10, 10, 2)])
A("1Kr 15,11", "Ása dělal, co je správné v Hospodinových očích", lambda: [
    gr(), king(110, 1, "raise", h=56), altar(170, G, 24, 14, True), rotate(person(60, G, 40, 1), 80, 60, G - 2)])
A("1Kr 21,2", "Dej mi svou vinici, Nábote", lambda: [
    gr(), king(70, 1, "point", h=56), man(130, -1, "cry", h=52), vine(160, 70, 230, 3), [(160, 70), (160, G)], [(230, 72), (230, G)]])
A("2Kr 7,8", "Malomocní vešli do prázdného tábora, jedli, pili a brali", lambda: [
    gr(), tent(140, G, 40, 26), tent(200, G, 30, 18), man(70, 1, "hold", h=50), man(100, 1, "raise", h=48), jar(150, G, 0.7)])
A("2Kr 9,20", "Jehú jede jako šílený", lambda: [gr(), chariot(120, G, 1.6, 1), horse(170, G, 1.4, 1, True), man(115, 1, "point", g=G - 22, h=34)])
A("2Kr 11,12", "Kněz vyvedl královského syna, vložil na něj korunu: Ať žije král!", lambda: [
    gr(), kid(120, 0, "down", h=34, crown=True), man(85, 1, [(110, 130), (100, 120)], h=56), crowd(150, 235, G, 36), trumpet(175, G - 50, 18, -30)])
A("2Kr 13,17", "Otevři okno na východ a vystřel!", lambda: [
    gr(), window(150, G - 50, 30, 30), king(120, 1, [(90, 95), (60, 80)], h=50), man(80, 1, [(110, 120), (100, 110)], "sit", h=50),
    [(140, G - 60), (200, G - 70)]])
A("2Kr 16,10", "Král Achaz uviděl oltář v Damašku a poslal jeho nákres", lambda: [
    gr(), king(80, 1, "point", h=56), altar(150, G, 40, 26), scroll(80, 40, 30, 14), city(190, 240, G, 30)])
A("2Kr 17,6", "Izrael byl odveden do Asýrie", lambda: [
    gr(), man(70, 1, "down", "walk", h=50), woman(100, 1, "cry", "walk", h=46), man(130, 1, "down", "walk", h=50), chain(80, G - 40, 130, G - 40, 6),
    man(190, 1, "point", "walk", h=54), spear(200, G - 30, 50)])
A("2Kr 19,14", "Chizkijáš rozložil dopis před Hospodinem", lambda: [
    gr(), king(100, 1, "pray", "kneel", h=56), scroll(150, G - 4, 34, 8), temple(200, G, 50, 40)])
A("2Kr 23,2", "Král četl všem knihu smlouvy nalezenou v domě Hospodinově", lambda: [
    gr(), king(120, 0, "hold", h=56), scroll(120, G - 38, 26, 12), crowd(10, 90, G, 36), crowd(150, 235, G, 36)])

# --- Kroniky ------------------------------------------------------------------
A("1Pa 1,1", "Adam, Šét, Enoš… – rodokmen od počátku", lambda: [
    gr(), tree(120, G, 100), *[circle(x, y, 3)[0] for x, y in ((120, 30), (90, 45), (150, 45), (75, 65), (105, 60), (135, 60), (165, 65))],
    scroll(40, G - 10, 30, 12)])
A("1Pa 5,20", "Volali k Bohu v boji a on je vyslyšel, protože doufali v něho", lambda: [
    gr(), man(80, 1, "raise", h=56), man(110, 1, "raise", h=52), shield(140, G - 30, 1.2), spear(160, G, 60), rays(140, 20, 6, 30, 40, 140, 6)])
A("1Pa 7,40", "Ašerovci – vybraní stateční muži a přední knížata", lambda: [
    gr(), man(60, 1, h=56), man(100, 1, h=54), man(140, 1, h=56), man(180, 1, h=52), spear(70, G, 60), spear(150, G, 60)])
A("1Pa 9,27", "Vrátní nocovali kolem Božího domu a každé ráno ho otvírali", lambda: [
    gr(), gate(130, G, 50, 60), man(80, 1, [(60, 90), (10, 5)], h=54), moon(200, 20, 7), stars([(40, 20), (220, 50)])])
A("1Pa 11,18", "Tři hrdinové prorazili tábor a přinesli Davidovi vodu", lambda: [
    gr(), man(150, -1, "give", h=54), jar(130, G - 30, 0.6), king(80, 1, [(110, 130), (60, 80)], h=56), well(210, G, 18)])
A("1Pa 13,7", "Vezli Boží truhlu na novém voze a David s lidem tančil", lambda: [
    gr(), chariot(110, G, 1.1, 1), ark_cov(110, G - 24, 26), ox(160, G, 0.9, 1), man(50, 1, "raise", h=52), harp(25, G, 18)])
A("1Pa 16,8", "Chvalte Hospodina, vzývejte jeho jméno, vyprávějte o jeho činech", lambda: [
    gr(), man(60, 1, "raise", h=54), harp(90, G - 4, 24), man(130, -1, [(110, 150), (90, 140)], h=52), circle(118, G - 46, 5), circle(142, G - 46, 5),
    crowd(170, 235, G, 30)])
A("1Pa 18,14", "David vládl nad Izraelem a jednal se svým lidem spravedlivě", lambda: [
    gr(), king(80, 1, "bless", "sit", h=56), throne(80, G, 44), scales(150, 40, 1.4), crowd(170, 235, G, 30)])
A("1Pa 21,16", "David uviděl anděla s taseným mečem nad Jeruzalémem", lambda: [
    city(80, 220, G, 30), angel(150, -1, [(140, 170), (10, 5)], G - 40, 50), sword(140, G - 100, 26, 30), gr(), man(40, 1, "pray", "bow", h=50)])
A("1Pa 22,5", "David připravil hojnost materiálu pro stavbu chrámu", lambda: [
    gr(), stones(60, G, 5), [(100, G - 4), (150, G - 4)], [(100, G - 8), (150, G - 8)], [(102, G - 12), (148, G - 12)], king(190, -1, "point", h=56)])
A("1Pa 25,1", "Synové Asafovi prorokovali za doprovodu citer, harf a cimbálů", lambda: [
    gr(), man(50, 1, [(40, 100), (30, 90)], "sit", h=50), harp(68, G - 16, 20), man(120, 1, [(40, 100), (30, 90)], "sit", h=50), harp(138, G - 16, 20),
    man(190, -1, [(80, 120), (80, 120)], h=50), circle(178, G - 38, 5), circle(202, G - 38, 5)])
A("1Pa 26,13", "Losovali o každou bránu, malý i velký", lambda: [
    gr(), gate(60, G, 30, 40), gate(180, G, 30, 40), man(120, 0, [(60, 90), (60, 90)], h=54), stones(120, G - 26, 2)])
A("2Pa 1,10", "Dej mi moudrost a poznání, abych mohl vést tento lid", lambda: [
    gr(), king(110, 1, "raise", "kneel", h=56), tent(190, G, 50, 30), stars([(40, 20), (90, 30), (200, 20)]), moon(150, 20, 6)])
A("2Pa 3,1", "Šalomoun začal stavět dům Hospodinův na hoře Mórija", lambda: [
    smooth([(0, G), (60, G - 30), (180, G - 30), (240, G)]), wall(80, 160, G - 30, 20, 2), man(60, 1, "carry", g=G - 20, h=40), gr(), king(200, -1, "point", g=G - 10, h=46)])
A("2Pa 6,13", "Šalomoun poklekl na podium a rozpjal ruce k nebi", lambda: [
    gr(), [(80, G - 20), (160, G - 20)], [(80, G - 20), (80, G)], [(160, G - 20), (160, G)], king(120, 1, "raise", "kneel", g=G - 20, h=50),
    crowd(170, 235, G, 30), crowd(5, 70, G, 30)])
A("2Pa 9,17", "Král udělal velký trůn ze slonoviny a obložil ho zlatem", lambda: [
    gr(), king(120, 1, "bless", "sit", g=G - 12, h=56), throne(120, G - 12, 50), [(80, G), (80, G - 6), (100, G - 6), (100, G - 12), (160, G - 12)],
    lion(60, G, 0.8, 1), lion(190, G, 0.8, -1)])
A("2Pa 10,8", "Rechabeám odmítl radu starších a poslechl mladíky", lambda: [
    gr(), king(120, 0, "down", "sit", h=54), throne(120, G, 40), man(50, 1, "point", h=54), man(75, 1, "down", h=54), youth(170, -1, "raise", h=48),
    youth(200, -1, "point", h=48)])
A("2Pa 12,6", "Knížata a král se pokořili: Hospodin je spravedlivý", lambda: [
    gr(), king(90, 1, "pray", "kneel", h=54), man(140, 1, "pray", "kneel", h=50), man(190, 1, "pray", "kneel", h=50)])
A("2Pa 14,10", "Hospodine, pomoz nám, na tebe se spoléháme", lambda: [
    gr(), king(80, 1, "raise", h=56), crowd(120, 235, G, 40), rays(160, 15, 6, 30, 40, 140, 6)])
A("2Pa 16,9", "Hospodinovy oči pátrají po celé zemi", lambda: [
    eye(120, 50, 40), rays(120, 50, 26, 40, 0, 360, 14), gr(), hills(0, 240, G - 2, 12)])
A("2Pa 18,16", "Viděl jsem Izraele rozptýleného po horách jako ovce bez pastýře", lambda: [
    hills(0, 240, G - 10, 30), sheep(40, G - 20, 0.7), sheep(100, G - 34, 0.7, -1), sheep(170, G - 30, 0.7), sheep(210, G - 14, 0.7, -1),
    man(120, 1, "open", h=50), gr()])
A("2Pa 22,11", "Jóšabat ukryla malého Jóaše a jeho kojnou v ložnici", lambda: [
    gr(), woman(100, 1, "hold", h=50), circle(118, G - 32, 3.5), bed(170, G, 50), door(40, G, 20, 36)])
A("2Pa 24,10", "Všichni přinášeli peníze a házeli je do truhly", lambda: [
    gr(), [(100, G), (100, G - 24), (140, G - 24), (140, G)], ellipse(120, G - 24, 6, 1.5), man(70, 1, "give", h=54), woman(170, -1, "give", h=48),
    kid(195, -1, "give", h=28), circle(116, G - 32, 1.4)])
A("2Pa 26,10", "Uzijáš stavěl věže a měl vinaře, neboť miloval půdu", lambda: [
    gr(), tower(60, G, 20, 50), vine(110, 70, 200, 3), [(110, 70), (110, G)], [(200, 72), (200, G)], king(150, 1, "reach", h=50), plough(210, G, 1)])
A("2Pa 28,15", "Zajatce oblékli, obuli, nakrmili a odvezli na oslech domů", lambda: [
    gr(), man(70, 1, "give", h=54), man(110, -1, "reach", h=48), bread(90, G - 32, 7), donkey(170, G, 1.2, 1), man(170, 1, "down", "sit", g=G - 14, h=40)])
A("2Pa 29,3", "Chizkijáš otevřel dveře Hospodinova domu a opravil je", lambda: [
    gr(), temple(140, G, 100, 60), king(60, 1, "point", h=56), door(140, G, 14, 24)])
A("2Pa 31,5", "Izraelci hojně přinášeli prvotiny obilí, moštu, oleje a medu", lambda: [
    gr(), basket(60, G, 18, 10, "bread"), jar(90, G, 1), jar(110, G, 0.8), grapes(140, G - 14, 1.2), man(190, -1, "raise", h=54), wheat(215, G, 20)])
A("2Pa 35,1", "Jóšijáš slavil v Jeruzalémě Hospodinův hod beránka", lambda: [
    table(120, G, 120, 16), king(70, 1, "raise", "sit", h=50), man(170, -1, "raise", "sit", h=48), sheep(120, G - 16, 0.8)[:0], bread(110, G - 17, 9),
    cup(135, G - 16), gr()])

# --- Ezdráš, Nehemjáš, Ester --------------------------------------------------
A("Ezd 1,7", "Král Kýros vydal nádoby Hospodinova domu", lambda: [
    gr(), king(70, 1, "give", h=56), cup(100, G - 30, 1.2), jar(130, G, 1), jar(150, G, 0.8), basket(175, G, 18, 9), man(210, -1, "reach", h=52)])
A("Ezd 5,2", "Zerubábel a Jéšua začali stavět dům Boží a proroci jim pomáhali", lambda: [
    gr(), wall(90, 170, G, 24, 3), man(60, 1, "carry", h=52), man(200, -1, "raise", h=54), man(130, 0, "point", g=G - 24, h=40)])
A("Ezd 8,21", "U řeky Ahavy jsem vyhlásil půst, abychom se pokořili před Bohem", lambda: [
    sea(100, 240, G + 4, 2), gr(0, 100), man(40, 1, "pray", "kneel", h=50), man(80, 1, "pray", "kneel", h=48), tent(170, G - 4, 30, 18)[:0]])
A("Neh 6,15", "Hradby byly dokončeny za padesát dva dní", lambda: [
    gr(), wall(30, 200, G, 40, 4), gate(115, G, 30, 46), man(215, -1, "raise", h=52), sun(40, 20, 7)])
A("Neh 9,2", "Izraelci vstali a vyznávali své hříchy", lambda: [
    gr(), man(60, 1, "pray", "kneel", h=50), man(100, 1, "cry", "kneel", h=50), woman(140, 1, "pray", "kneel", h=46), man(180, 1, "pray", "bow", h=48)])
A("Neh 12,27", "Hradby posvětili s radostí, díkůvzdáním a zpěvem", lambda: [
    wall(10, 230, G, 30, 3), man(60, 1, "raise", g=G - 30, h=40), harp(90, G - 30, 18), man(130, 1, "raise", g=G - 30, h=40),
    trumpet(150, G - 56, 16, -30), man(190, 1, "raise", g=G - 30, h=40)])
A("Est 3,2", "Mordokaj nepoklekl a nepoklonil se Hamanovi", lambda: [
    gr(), man(100, 1, "down", h=54), man(150, -1, "point", h=56, belt=True), man(190, -1, "pray", "bow", h=48), gate(40, G, 30, 40)])
A("Est 6,11", "Haman vedl Mordokaje na koni po náměstí", lambda: [
    gr(), horse(110, G, 1.6, 1), man(108, 1, "down", "sit", g=G - 16, h=44, crown=True), man(170, -1, "raise", h=54), city(10, 70, G, 30)])
A("Est 8,16", "Pro Židy nastalo světlo, radost, veselí a čest", lambda: [
    gr(), man(60, 1, "raise", h=52), woman(90, -1, "raise", h=48), kid(115, 0, "raise", h=28), man(150, 1, "raise", h=52), woman(185, -1, "raise", h=48),
    sun(120, 20, 8)])

# --- doplnění ------------------------------------------------------------------
A("Joz 17,18", "Hornatina bude tvá – je to les, vykácej ho", lambda: [
    gr(), tree(140, G, 50), tree(180, G, 56), tree(215, G, 44), man(90, 1, [(120, 150), (100, 140)], h=56), [(104, G - 66), (118, G - 50)],
    [(100, G - 70), (110, G - 72), (108, G - 64)]])
A("Sd 18,9", "Vstaňte, viděli jsme tu zemi a je velmi dobrá", lambda: [
    gr(), man(80, 1, "point", h=54), man(110, 1, "raise", h=50), hills(130, 240, G - 2, 14), field(140, 230, G - 2, 6), sun(200, 25, 7)])
A("1S 14,13", "Jónatan šplhal po rukou i nohou a za ním jeho zbrojnoš", lambda: [
    smooth([(60, G), (100, G - 50), (140, G - 80), (200, G - 90), (240, G - 90)]), youth(120, 1, "reach", "kneel", g=G - 60, h=40),
    youth(90, 1, "reach", "kneel", g=G - 34, h=36), gr(0, 70)])
A("1S 29,11", "David se ráno se svými muži vrátil", lambda: [
    gr(), man(80, -1, "down", "walk", h=54), man(110, -1, "down", "walk", h=50), man(140, -1, "down", "walk", h=50), sun(200, 30, 8), path(60, G, 10, G - 30, 14, 2)])
A("2S 5,7", "David dobyl pevnost Sijón – Davidovo město", lambda: [
    gr(), mountain(150, G, 140, 40), city(110, 190, G - 38, 30), man(50, 1, "raise", h=56)])
A("2S 16,13", "Šimeí šel po svahu, proklínal Davida a házel kameny", lambda: [
    smooth([(120, G - 30), (180, G - 50), (240, G - 56)]), man(180, -1, [(150, 180), (10, 5)], g=G - 50, h=44), stones(140, G - 30, 2),
    gr(), king(70, 1, "down", "walk", h=54), man(100, 1, "down", "walk", h=50)])
A("2S 21,10", "Rispa prostřela žíněné roucho na skálu a bdělá dnem i nocí", lambda: [
    gr(), rock(110, G, 50, 16), woman(110, 1, "wide", "sit", g=G - 14, h=46), bird(170, 40, 1.4), bird(190, 30, 1.2), moon(40, 20, 6)])
A("2Kr 15,35", "Jótam postavil Horní bránu Hospodinova domu", lambda: [
    gr(), gate(130, G, 50, 60), king(60, 1, "point", h=56), man(190, -1, "carry", h=50), [(176, G - 54), (204, G - 54)]])
A("2Kr 20,5", "Slyšel jsem tvou modlitbu a viděl tvé slzy, uzdravím tě", lambda: [
    gr(), bed(120, G, 70), king(110, 1, "cry", "lie", g=G - 6, h=50), man(190, -1, "bless", h=56), sun(40, 25, 8)])
A("1Pa 3,1", "Toto jsou synové Davidovi, kteří se mu narodili v Chebrónu", lambda: [
    gr(), king(70, 1, "bless", h=58), kid(110, -1, h=34), kid(130, -1, h=30), kid(150, -1, h=28), kid(170, -1, h=26), kid(188, -1, h=24)])
A("1Pa 19,2", "David poslal posly, aby Chanúna potěšili", lambda: [
    gr(), king(60, 1, "point", h=56), man(110, 1, "down", "walk", h=50), man(140, 1, "down", "walk", h=50), city(180, 240, G, 30)])
A("1Pa 23,30", "Každé ráno a každý večer stát a chválit Hospodina", lambda: [
    gr(), man(100, 1, "raise", h=54), man(140, 1, "raise", h=52), sun(40, 30, 8), moon(210, 30, 7)])
A("1Pa 28,20", "Buď silný a odvážný, Šalomoune, a jednej", lambda: [
    gr(), king(80, 1, [(110, 130), (100, 120)], h=56), youth(130, -1, "pray", "kneel", h=50, crown=True), scroll(190, 50, 30, 14)])
A("2Pa 5,13", "Trubači a zpěváci zazněli jako jeden hlas a dům naplnil oblak", lambda: [
    gr(), temple(150, G, 90, 50), cloud(150, 50, 60), man(50, 1, [(110, 130), (100, 120)], h=52), trumpet(72, G - 42, 18, -30), man(90, 1, "raise", h=50)])
A("2Pa 33,12", "Manases se v tísni pokořil před Bohem svých otců", lambda: [
    gr(), king(110, 1, "pray", "kneel", h=56), chain(80, G - 4, 60, G, 4), [(170, G), (170, 30)], [(180, G), (180, 30)], [(190, G), (190, 30)]])
A("Ezd 10,1", "Ezdráš se s pláčem modlil a kolem něj se shromáždil veliký zástup", lambda: [
    gr(), man(80, 1, "cry", "bow", h=56), temple(40, G, 50, 34)[:0], crowd(120, 235, G, 40)])
A("Neh 11,1", "Losovali, aby jeden z deseti bydlel ve svatém městě", lambda: [
    gr(), city(130, 235, G, 40), man(70, 1, [(60, 90), (60, 90)], h=54), stones(70, G - 34, 2), man(30, 1, h=48)])
A("Est 9,22", "Dny hodování a radosti, kdy si posílají dárky a dávají chudým", lambda: [
    gr(), table(80, G, 80, 16), bread(70, G - 17, 8), grapes(95, G - 24, 0.9), man(150, 1, "give", h=52), basket(176, G - 30, 14, 8, "bread"),
    woman(210, -1, "reach", h=46)])
