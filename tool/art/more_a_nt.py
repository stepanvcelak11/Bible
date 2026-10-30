"""Ilustrace do zbývajících kapitol: Nový zákon.

Číslování NZ je v BKR i v moderních překladech (až na drobnosti) stejné.
"""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import K

# --- Evangelia ----------------------------------------------------------------
K("Mt 9,9", "Ježíš uviděl Matouše u celnice: Pojď za mnou", lambda: [
    gr(), J(70, 1, "point", h=58), table(160, G, 50, 16), man(165, -1, "raise", "sit", h=46), coins(150, G - 18, 4)])
K("Mt 12,1", "Učedníci v sobotu trhali klasy a jedli", lambda: [
    gr(), field(100, 240, G, 7), J(60, 1, "down", "walk", h=58), man(120, 1, "reach", h=52), man(170, 1, "reach", h=50)])
K("Mt 16,18", "Ty jsi Petr, Skála, a na té skále postavím svou církev", lambda: [
    gr(), rock(160, G, 80, 40), J(70, 1, "point", h=58), man(160, -1, "pray", g=G - 40, h=36)])
K("Mt 19,24", "Snáze projde velbloud uchem jehly", lambda: [
    gr(), camel(80, G, 1.4, 1), [(170, G), (170, G - 60)], ellipse(170, G - 52, 3, 6), J(215, -1, "point", h=56)])
K("Mt 22,9", "Jděte na rozcestí a pozvěte na svatbu každého, koho najdete", lambda: [
    gr(), path(0, G, 120, G - 8, 14, 4), path(240, G, 120, G - 8, 14, 4), man(120, 0, "wide", h=54), man(50, 1, "down", "walk", h=48, staff=0),
    woman(190, -1, "down", "walk", h=44)])
K("Mt 24,32", "Od fíkovníku se naučte: když raší, víte, že je blízko léto", lambda: [
    gr(), fig_tree(130, G, 70), J(60, 1, "point", h=58), sun(210, 25, 9)])
K("Mt 27,29", "Spletli korunu z trní a vložili mu ji na hlavu", lambda: [
    gr(), J(120, 0, "hold", h=58), thorns(120, G - 60, 8), man(60, 1, "point", h=54), man(180, -1, "point", h=54), spear(200, G, 60)])
K("Mk 1,35", "Velmi časně ráno odešel na pusté místo a tam se modlil", lambda: [
    gr(), J(110, 1, "pray", "kneel", h=50), hills(130, 240, G - 2, 16), sun(200, G - 8, 12), moon(40, 25, 7)])
K("Mk 3,14", "Ustanovil dvanáct, aby byli s ním", lambda: [
    gr(), mountain(120, G, 220, 30), J(120, 0, "bless", g=G - 30, h=50), crowd(10, 90, G, 40), crowd(150, 235, G, 40)])
K("Mk 9,36", "Postavil dítě doprostřed, objal je a řekl", lambda: [
    gr(), J(110, 1, "wide", h=58), kid(140, -1, "wide", h=30), man(60, 1, h=50), man(190, -1, h=50)])
K("Mk 13,1", "Mistře, pohleď, jaké kamení a jaké stavby!", lambda: [
    gr(), temple(160, G, 110, 56), J(40, 1, "down", h=58), man(80, 1, "point", h=52)])
K("L 4,17", "V synagoze mu podali knihu proroka Izajáše", lambda: [
    gr(), J(110, 1, "hold", h=58), scroll(132, G - 36, 26, 14), crowd(150, 235, G, 36), pillar(40, G, 60)])
K("L 6,38", "Dávejte, a bude vám dáno – dobrá míra natlačená a vrchovatá", lambda: [
    gr(), man(80, 1, "give", h=54), basket(120, G - 28, 26, 14, 6), *[circle(x, G - 46, 2)[0] for x in (112, 120, 128)], man(170, -1, "reach", h=52)])
K("L 9,58", "Lišky mají doupata, ptáci hnízda, ale Syn člověka nemá kde hlavu složit", lambda: [
    gr(), dog(60, G, 1, 1), tree(140, G, 60), bird(140, G - 60, 1), J(200, -1, "down", h=58)])
K("L 12,27", "Pohleďte na lilie, jak rostou", lambda: [
    gr(), lily(60, G, 22), lily(80, G, 18), lily(100, G, 24), lily(120, G, 18), J(190, -1, "point", h=58), sun(150, 25, 8)])
K("L 14,28", "Kdo chce stavět věž, nejdřív si sedne a spočítá náklady", lambda: [
    gr(), man(70, 1, "hold", "sit", h=48), seat(70, G, 16, 12), coins(95, G - 26, 3), tower(170, G, 30, 40), stones(210, G, 3)])
K("L 17,15", "Jeden z nich se vrátil a nahlas chválil Boha", lambda: [
    gr(), J(80, 1, "bless", h=58), man(130, -1, "raise", "kneel", h=46), man(190, 1, "down", "walk", h=46), man(215, 1, "down", "walk", h=46)])
K("L 21,25", "Budou znamení na slunci, měsíci a hvězdách a moře bude hučet", lambda: [
    sun(50, 30, 10), moon(120, 25, 8), stars([(170, 20), (200, 35), (90, 45)]), sea(0, 240, G - 10, 4), cloud(200, 60, 30)])
K("L 23,43", "Dnes budeš se mnou v ráji", lambda: [
    gr(), cross(120, G, 70), cross(60, G, 56), cross(180, G, 56), rays(120, 20, 6, 20, 0, 360, 10)])
K("J 5,8", "Vstaň, vezmi své lůžko a choď", lambda: [
    gr(), J(80, 1, "bless", h=58), man(150, -1, "raise", h=52), [(160, G - 30), (185, G - 30)], waves(170, 240, G, 4)])
K("J 7,38", "Z nitra toho, kdo věří, poplynou proudy živé vody", lambda: [
    gr(0, 80), man(60, 1, "raise", h=54), waves(80, 240, G - 2, 8), waves(80, 240, G + 4, 8), plant(120, G - 8, 14), sun(200, 25, 8)])
K("J 12,24", "Pšeničné zrno, když padne do země a zemře, přinese mnoho užitku", lambda: [
    gr(), circle(60, G + 6, 2), smooth([(60, G + 4), (62, G - 4)], 2), wheat(110, G, 30), wheat(130, G, 34), wheat(150, G, 30), J(210, -1, "point", h=56)])
K("J 14,6", "Já jsem ta cesta, pravda i život", lambda: [
    gr(), path(30, G + 2, 210, G - 40, 40, 4), J(80, 1, "wide", h=58), house(210, G - 44, 30, 20)])
K("J 16,21", "Když žena porodí, nevzpomíná na úzkost pro radost", lambda: [
    gr(), woman(110, 1, "hold", "sit", h=48), kid(124, 0, h=14, g=G - 28), heart(120, 40, 6), house(200, G, 40, 30)])
K("J 18,38", "Pilát mu řekl: Co je pravda?", lambda: [
    gr(), man(80, 1, "open", h=56), J(160, -1, "down", h=58), pillar(30, G, 60), pillar(210, G, 60)])

# --- Skutky -------------------------------------------------------------------
K("Sk 6,3", "Vyhledejte sedm mužů s dobrou pověstí, plných Ducha a moudrosti", lambda: [
    gr(), man(30, 1, h=48), man(55, 1, h=48), man(80, 1, h=48), man(105, 1, h=48), man(130, 1, h=48), man(155, 1, h=48), man(180, 1, h=48),
    man(215, -1, "bless", h=54)])
K("Sk 11,26", "V Antiochii byli učedníci poprvé nazváni křesťany", lambda: [
    gr(), city(140, 240, G, 36), crowd(20, 130, G, 40), cross(120, G - 60, 16)])
K("Sk 15,6", "Apoštolové a starší se sešli, aby tu věc posoudili", lambda: [
    gr(), man(50, 1, "point", "sit", h=46), man(90, 1, "open", "sit", h=46), man(150, -1, "down", "sit", h=46), man(190, -1, "open", "sit", h=46), scroll(120, G - 30, 24, 12)])
K("Sk 19,19", "Mnozí snesli své knihy a spálili je přede všemi", lambda: [
    gr(), flames(120, G - 4, 34), book(110, G - 6, 12, 8), man(60, 1, "give", h=52), man(180, -1, "give", h=52), crowd(200, 240, G, 30)])
K("Sk 22,3", "Pavel promlouvá k lidu: Byl jsem vychován u nohou Gamalielových", lambda: [
    gr(), man(80, 1, "open", h=56), chain(70, G - 30, 90, G - 30, 3), crowd(120, 235, G, 40), wall(0, 50, G, 40, 4)])
K("Sk 25,11", "Odvolávám se k císaři", lambda: [
    gr(), man(80, 1, "raise", h=56), man(170, -1, "down", "sit", h=50), throne(175, G, 40, -1), spear(210, G, 56)])

# --- Epištoly -----------------------------------------------------------------
K("Ř 2,4", "Boží dobrota tě vede k pokání", lambda: [
    gr(), man(110, 1, "pray", "kneel", h=48), hand(160, 50, 1.4, False), heart(160, 30, 6), path(0, G, 100, G - 6, 12, 6)])
K("Ř 4,18", "Abraham uvěřil v naději proti naději", lambda: [
    stars([(30, 20), (60, 40), (90, 15), (130, 30), (160, 12), (190, 35), (215, 18), (110, 55)]), gr(), man(120, 0, "raise", h=50), tent(200, G, 36, 22)])
K("Ř 7,24", "Ubohý já člověk! Kdo mě vysvobodí?", lambda: [
    gr(), man(110, 1, "cry", "kneel", h=48), chain(80, G - 2, 140, G, 5), cross(200, G, 56)])
K("Ř 9,21", "Což nemá hrnčíř moc nad hlínou?", lambda: [
    gr(), potter(110, G, 54), jar(180, G, 0.9), jar(210, G, 0.7)])
K("Ř 14,19", "Usilujme o to, co slouží pokoji a vzájemnému budování", lambda: [
    gr(), man(70, 1, [(60, 100), (20, 40)], h=54), wall(100, 170, G, 30, 3), man(200, -1, [(60, 100), (20, 40)], h=54), bird(130, 40, 1.2, 1, True)])
K("Ř 16,16", "Pozdravujte se navzájem", lambda: [
    gr(), man(80, 1, "wide", h=54), man(120, -1, "wide", h=54), woman(170, 1, "wide", h=46), woman(205, -1, "wide", h=46)])
K("1K 2,9", "Co oko nevidělo a ucho neslyšelo, připravil Bůh těm, kdo ho milují", lambda: [
    gr(), eye(80, 50, 18), rays(150, 40, 10, 40, 0, 360, 14), heart(150, 40, 8), man(150, 0, "raise", h=44)])
K("1K 5,7", "Vymeťte starý kvas", lambda: [
    gr(), woman(100, 1, "reach", h=48), [(115, G - 20), (140, G)], house(180, G, 60, 40), bread(60, G - 4, 10)])
K("1K 7,17", "Každý ať žije tak, jak mu Pán určil a jak ho Bůh povolal", lambda: [
    gr(), man(50, 1, [(150, 160), (20, 10)], h=52), woman(110, 1, "hold", h=46), basket(126, G - 26, 12, 6), man(180, -1, "down", "sit", h=46), nets(200, G - 6, 20, 8)])
K("1K 10,31", "Ať jíte, nebo pijete, všechno čiňte k Boží slávě", lambda: [
    gr(), table(120, G, 80, 16), bread(110, G - 19, 8), cup(135, G - 16), man(60, 1, "raise", "sit", h=48), woman(180, -1, "raise", "sit", h=44)])
K("1K 12,4", "Jsou různá obdarování, ale tentýž Duch", lambda: [
    gr(), man(50, 1, "hold", h=52), harp(74, G - 4, 20), woman(110, 1, "give", h=46), bread(132, G - 28, 6), man(180, -1, "open", h=52), bird(120, 30, 1.4, 1, True)])
K("1K 14,8", "Vydá-li polnice nejasný zvuk, kdo se bude chystat do boje?", lambda: [
    gr(), man(80, 1, "hold", h=54), trumpet(94, G - 38, 26, -25, 1), man(170, -1, "open", h=52), shield(200, G - 26, 1)])
K("1K 16,13", "Bděte, stůjte pevně ve víře, buďte stateční a silní", lambda: [
    gr(), man(120, 0, "down", h=60), rock(120, G, 60, 6), shield(150, G - 30, 1.2), moon(200, 20, 7)])
K("2K 2,14", "Bůh skrze nás šíří vůni svého poznání na každém místě", lambda: [
    gr(), man(110, 1, "hold", "walk", h=56), jar(128, G - 32, 0.6), smooth([(130, G - 50), (150, G - 60), (170, G - 54), (190, G - 66)], 4), city(180, 240, G, 30)])
K("2K 7,6", "Bůh, který těší ponížené, nás potěšil příchodem Tita", lambda: [
    gr(), man(80, 1, "wide", h=54), man(130, -1, "wide", "walk", h=52), path(140, G, 240, G - 10, 16, 4), sun(200, 25, 8)])
K("2K 10,4", "Zbraně našeho boje mají sílu od Boha k boření hradeb", lambda: [
    gr(), wall(120, 220, G, 40, 4, broken=True), man(70, 1, "raise", h=56), book(70, G - 70, 16, 10), rays(70, G - 70, 10, 20, 0, 360, 8)])
K("2K 13,11", "Buďte jedné mysli, žijte v pokoji a Bůh lásky bude s vámi", lambda: [
    gr(), crowd(30, 210, G, 40), heart(120, 30, 8), bird(170, 30, 1.2, -1, True)])
K("Ga 1,18", "Šel jsem do Jeruzaléma, abych se seznámil s Petrem", lambda: [
    gr(), man(70, 1, "wide", h=54), man(115, -1, "wide", h=54), city(150, 240, G, 36), path(0, G, 60, G - 4, 10, 4)])
K("Ga 4,6", "Bůh poslal do našich srdcí Ducha, který volá: Abba, Otče!", lambda: [
    gr(), man(80, 1, "wide", h=56), kid(115, -1, "wide", h=30), bird(100, 30, 1.4, 1, True), heart(140, 50, 6)])
K("Ef 1,18", "Ať osvítí oči vašeho srdce", lambda: [
    gr(), heart(120, 70, 16), eye(120, 70, 12), rays(120, 70, 20, 34, 0, 360, 12), man(40, 1, "pray", h=50)])
K("Ef 4,26", "Slunce ať nezapadá nad vaším hněvem", lambda: [
    gr(), sun(120, G - 4, 16), man(70, 1, "wide", h=54), man(170, -1, "wide", h=54)])
K("Fp 2,10", "Před jménem Ježíš se skloní každé koleno", lambda: [
    gr(), cross(120, G - 30, 40), rays(120, G - 60, 10, 30, 0, 360, 12), man(50, 1, "pray", "kneel", h=44), woman(80, 1, "pray", "kneel", h=40),
    king(165, -1, "pray", "kneel", h=44), man(195, -1, "pray", "kneel", h=44)])
K("Ko 1,6", "Evangelium přináší ovoce a roste po celém světě", lambda: [
    gr(), tree(120, G, 80), *[circle(x, y, 2)[0] for x, y in ((100, 70), (130, 60), (145, 85), (110, 90), (125, 80))], man(40, 1, "point", h=50), man(200, -1, "raise", h=50)])
K("Ko 4,6", "Vaše řeč ať je vždy laskavá, solí kořeněná", lambda: [
    gr(), man(80, 1, "open", h=54), man(170, -1, "down", h=54), jar(125, G - 50, 0.5), *[circle(x, G - 36, 0.8)[0] for x in (120, 126, 131)], heart(125, 30, 5)])
K("1Te 1,9", "Obrátili jste se k Bohu od modlářství", lambda: [
    gr(), man(110, 1, "raise", "walk", h=56), rotate(pillar(50, G, 30, 8), 70, 50, G), rays(200, 20, 6, 30, 120, 240, 6)])
K("1Te 3,12", "Ať vás Pán dá růst a oplývat láskou jedni k druhým", lambda: [
    gr(), crowd(30, 210, G, 40), heart(80, 30, 5), heart(120, 22, 7), heart(160, 30, 5), plant(220, G, 20)])
K("2Te 2,15", "Stůjte pevně a držte se učení, které jste přijali", lambda: [
    gr(), man(120, 0, "hold", h=58), scroll(120, G - 36, 26, 14), rock(120, G, 70, 6), smooth([(20, 60), (60, 50), (100, 60)], 3), smooth([(140, 60), (180, 50), (220, 60)], 3)])
K("1Tm 1,15", "Kristus Ježíš přišel na svět spasit hříšníky", lambda: [
    gr(), J(110, 1, "reach", h=58), man(170, -1, "cry", "kneel", h=44), rays(110, 15, 4, 22, 40, 140, 7)])
K("1Tm 3,2", "Biskup má být bezúhonný, pohostinný a schopný učit", lambda: [
    gr(), man(80, 1, "open", h=56), house(30, G, 40, 30), crowd(120, 235, G, 36), book(100, G - 34, 14, 10)])
K("1Tm 6,18", "Ať konají dobro, jsou bohatí na dobré skutky a štědří", lambda: [
    gr(), man(90, 1, "give", h=56), coins(118, G - 30, 4), woman(160, -1, "reach", h=46), kid(190, -1, "reach", h=28)])
K("2Tm 3,16", "Celé Písmo je vdechnuto Bohem a je užitečné k učení", lambda: [
    gr(), table(120, G, 60, 16), scroll(120, G - 26, 40, 16), rays(120, G - 26, 24, 40, 200, 340, 7), man(60, 1, "point", h=52), youth(180, -1, "down", "sit", h=40)])
K("Tt 1,5", "Proto jsem tě nechal na Krétě, abys ustanovil starší", lambda: [
    sea(0, 240, G, 3), hills(60, 200, G - 6, 20), boat(210, G - 6, 40, True), man(120, 1, "bless", g=G - 24, h=40)])
K("Tt 3,5", "Zachránil nás koupelí znovuzrození a obnovou Duchem", lambda: [
    gr(0, 60), waves(60, 240, G, 8), man(130, 0, "raise", g=G + 4, h=50), bird(130, 30, 1.4, 1, True), rays(130, 30, 6, 20, 200, 340, 5)])
K("Žd 1,10", "Ty jsi na počátku založil zemi a nebesa jsou dílem tvých rukou", lambda: [
    circle(120, 80, 30), smooth([(96, 70), (110, 64), (126, 72), (144, 66)], 4), sun(40, 30, 8), moon(200, 25, 7), stars([(70, 20), (170, 15), (220, 70)])])
K("Žd 3,4", "Každý dům má svého stavitele, stavitelem všeho je Bůh", lambda: [
    gr(), house(140, G, 60, 40), man(80, 1, [(60, 100), (20, 40)], h=54), ladder(170, G, 180, G - 40, 8, 4), sun(210, 20, 8)])
K("Žd 5,12", "Potřebujete mléko, a ne hutný pokrm", lambda: [
    gr(), cup(100, G - 20, 1.6), bread(150, G - 6, 12), kid(60, 1, "reach", h=30), table(130, G, 70, 14)])
K("Žd 8,5", "Pozemská svatyně je jen stínem nebeské", lambda: [
    gr(), tent(80, G, 60, 30), [(50, G + 4), (160, G + 8)], cloud(180, 40, 50), temple(180, 40, 40, 20)])
K("Žd 10,25", "Neopouštějme společná shromáždění, povzbuzujme se", lambda: [
    gr(), house(120, G, 120, 50), crowd(70, 170, G, 36), sun(210, 20, 8)])
K("Žd 13,2", "Nezapomínejte na pohostinnost – tak někteří hostili anděly", lambda: [
    gr(), table(120, G, 60, 16), man(70, 1, "give", h=54), angel(170, -1, "down", h=54), bread(115, G - 19, 7), cup(130, G - 16)])
K("Jk 2,15", "Jestliže bratr nebo sestra nemají co na sebe ani co jíst…", lambda: [
    gr(), man(80, 1, "point", h=54), woman(160, -1, "reach", "sit", h=42), kid(190, -1, "reach", h=26), bread(110, G - 4, 8)])
K("Jk 4,14", "Co je váš život? Pára, která se na chvíli ukáže a pak zmizí", lambda: [
    gr(), flames(120, G - 2, 20), jar(120, G - 8, 1), smooth([(116, G - 30), (110, G - 50), (122, G - 70), (114, G - 92)], 4), man(60, 1, "down", "sit", h=46)])
K("1Pt 1,24", "Každý člověk je jako tráva, tráva uschne a květ opadne", lambda: [
    gr(), tufts(20, 220, G, 8), flowers(40, 120, G, 4), lily(160, G, 16), sun(200, 25, 10)])
K("1Pt 4,10", "Služte si navzájem tím obdarováním, které kdo přijal", lambda: [
    gr(), man(70, 1, "give", h=54), bread(96, G - 30, 6), woman(130, -1, "reach", h=46), woman(160, 1, "give", h=46), jar(184, G - 30, 0.5), man(210, -1, "reach", h=50)])
K("2Pt 2,5", "Bůh zachoval Noeho, hlasatele spravedlnosti", lambda: [
    sea(0, 240, G, 3), ark(120, G - 16, 110), rainbow(120, G - 30, 70), man(120, 1, "raise", g=G - 40, h=24)])
K("1J 1,5", "Bůh je světlo a není v něm žádná tma", lambda: [
    sun(120, 60, 20), rays(120, 60, 24, 50, 0, 360, 16), gr(), man(60, 1, "raise", h=46), woman(180, -1, "raise", h=42)])
K("1J 3,1", "Hleďte, jakou lásku nám dal Otec: smíme se nazývat Božími dětmi", lambda: [
    gr(), man(110, 1, "wide", h=58), kid(140, -1, "wide", h=30), kid(80, 1, "wide", h=26), heart(120, 30, 7)])
K("1J 5,4", "Vítězství, které přemohlo svět, je naše víra", lambda: [
    gr(), man(110, 1, "raise", h=58), crown(110, 40, 14), circle(180, G - 30, 26), shield(110, G - 30, 0.9)])

# --- Zjevení ------------------------------------------------------------------
K("Zj 2,10", "Buď věrný až na smrt, a dám ti korunu života", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=48), crown(150, 40, 18), rays(150, 40, 12, 26, 0, 360, 10)])
K("Zj 6,2", "Viděl jsem bílého koně a jezdce s lukem", lambda: [
    gr(), horse(120, G, 1.6, 1, True), man(116, 1, "raise", "sit", g=G - 30, h=36), crown(116, G - 76, 10)])
K("Zj 9,3", "Z dýmu vyšly na zem kobylky", lambda: [
    gr(), smooth([(120, G), (110, G - 30), (130, G - 60), (115, G - 90)], 4), locust(70, 60, 1.4), locust(160, 50, 1.4), locust(190, 80, 1.2), locust(60, 90, 1)])
K("Zj 11,15", "Zatroubil sedmý anděl: Království světa připadlo našemu Pánu", lambda: [
    gr(), angel(110, 1, "hold", h=60), trumpet(126, G - 40, 30, -30, 1), city(160, 240, G, 30), crowd(0, 70, G, 30)])
K("Zj 13,1", "Viděl jsem šelmu, jak vystupuje z moře", lambda: [
    sea(0, 240, G - 10, 4), dragon(120, 70, 1.6)])
K("Zj 16,1", "Jděte a vylijte sedm misek Božího hněvu na zem", lambda: [
    gr(), angel(120, 0, "hold", g=80, h=50), ellipse(120, 70, 10, 3), smooth([(128, 72), (134, 90), (132, 110)], 3), hills(0, 240, G, 10)])
K("Zj 18,21", "Anděl hodil do moře kámen jako mlýnský: Tak bude svržen Babylón", lambda: [
    sea(0, 240, G - 6, 4), angel(80, 1, "raise", g=G - 20, h=50), circle(120, 50, 10), circle(120, 50, 3), city(160, 240, G - 12, 30)])
K("Zj 20,12", "Viděl jsem mrtvé stát před trůnem a knihy byly otevřeny", lambda: [
    gr(), throne(120, G - 30, 40, 1), rays(120, 40, 10, 30, 0, 360, 12), book(80, G - 6, 18, 10), book(160, G - 6, 18, 10), crowd(10, 60, G, 36), crowd(190, 235, G, 36)])
