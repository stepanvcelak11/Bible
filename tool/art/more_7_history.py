"""Ilustrace do zbývajících kapitol: historické knihy (Jozue – Ester).

Odkazy jsou v číslování Bible kralické, K() je převede na kanonické.
"""
from kit import *  # noqa: F401,F403
from motifs import *  # noqa: F401,F403
from registry import K

# --- Jozue --------------------------------------------------------------------
K("Joz 1,9", "Buď rozhodný a statečný, neboj se – Hospodin je s tebou", lambda: [
    gr(), man(100, 1, "raise", h=58), sword(116, G - 30, 22, -70), crowd(150, 235, G, 38), rays(100, 15, 4, 24, 40, 140, 7)])
K("Joz 4,20", "Jozue postavil v Gilgálu dvanáct kamenů vzatých z Jordánu", lambda: [
    gr(), stones(110, G, 3), stones(130, G - 8, 2), stones(150, G, 3), man(60, 1, "point", h=56), kid(85, 1, h=30), sea(170, 240, G, 2)])
K("Joz 7,21", "Akan: Zahleděl jsem se na plášť a stříbro a ukryl je ve stanu", lambda: [
    gr(), tent(150, G, 60, 34), coins(150, G - 4, 5), man(80, 1, "cry", h=52), man(210, -1, "point", h=56)])
K("Joz 9,5", "Gibeónští přišli ve starých sandálech a se suchým, plesnivým chlebem", lambda: [
    gr(), man(70, 1, "give", h=52, staff=1), bread(94, G - 30, 7), donkey(30, G, 0.9, 1), man(160, -1, "open", h=56), man(195, -1, "down", h=54)])
K("Joz 11,23", "Jozue vzal celou zemi a země měla od války pokoj", lambda: [
    gr(), field(20, 120, G, 6), tree(150, G, 46), house(200, G, 36, 26), sun(60, 25, 8), sheep(130, G, 0.8), sword(170, G - 2, 24, 0)])
K("Joz 13,1", "Jozue zestárl a zbývá ještě obsadit mnoho země", lambda: [
    gr(), man(80, 1, "point", h=52, staff=0), hills(110, 240, G - 2, 18), mountain(190, G - 10, 70, 40)])
K("Joz 16,1", "Los připadl Josefovým synům", lambda: [
    gr(), man(80, 1, "hold", h=56), circle(100, G - 30, 3), circle(108, G - 28, 3), man(150, -1, "open", h=52), hills(150, 240, G - 2, 14)])
K("Joz 19,50", "Jozue dostal město Timnat-serach, vystavěl je a bydlel v něm", lambda: [
    gr(), city(120, 220, G, 30), man(70, 1, [(60, 100), (20, 40)], h=54), stones(100, G, 3), hills(0, 60, G - 2, 10)])
K("Joz 21,45", "Nepadlo ani jedno ze všech dobrých slov, která Hospodin mluvil", lambda: [
    gr(), crowd(20, 130, G, 40), man(170, -1, "raise", h=56), scroll(120, 30, 30, 16), rays(120, 30, 18, 30, 0, 360, 10)])
K("Joz 23,14", "Jozue: Jdu cestou všeho světa, ale ani jedno Boží slovo nepadlo", lambda: [
    gr(), man(110, 1, "open", "sit", h=50, staff=1), seat(110, G, 16, 12), crowd(140, 235, G, 38), sun(40, 50, 9)])

# --- Soudců -------------------------------------------------------------------
K("Sd 1,2", "Hospodin řekl: Juda potáhne první", lambda: [
    gr(), man(70, 1, "raise", h=56), crowd(110, 230, G, 40), rays(70, 15, 4, 22, 40, 140, 5)])
K("Sd 3,15", "Hospodin jim vzbudil zachránce Ehúda, leváka", lambda: [
    gr(), man(90, 1, "give", h=54), [(118, G - 28), (128, G - 28), (128, G - 24), (118, G - 24)], king(170, -1, "open", "sit", h=56), throne(175, G, 40, -1)])
K("Sd 5,1", "Debora a Barák zpívali Hospodinu píseň", lambda: [
    gr(), woman(90, 1, "raise", h=50), man(130, -1, "raise", h=56), tree(40, G, 54, "palm"), crowd(160, 235, G, 36), mountain(210, G - 30, 60, 30)])
K("Sd 8,23", "Gedeon: Nebudu nad vámi vládnout, Hospodin bude vládnout nad vámi", lambda: [
    gr(), man(110, 1, "raise", h=56), crown(150, G - 4, 14), crowd(160, 235, G, 38), crowd(0, 70, G, 38)])
K("Sd 10,16", "Odstranili cizí bohy a sloužili Hospodinu", lambda: [
    gr(), man(80, 1, "pray", h=54), woman(110, 1, "pray", h=46), [(170, G), (175, G - 12), (185, G - 10), (190, G)], [(200, G - 2), (215, G - 6), (220, G)],
    rotate(pillar(160, G, 30, 8), 70, 160, G)])
K("Sd 12,6", "Řekni Šibbolet! – Řekl Sibbolet, protože to neuměl vyslovit", lambda: [
    gr(0, 90), sea(90, 170, G, 3), gr(170, 240), man(60, 1, "point", h=56), man(200, -1, "open", h=52), spear(40, G, 56)])
K("Sd 15,15", "Samson našel čerstvou oslí čelist a vzal ji do ruky", lambda: [
    gr(), man(110, 1, "raise", h=60, hair=True), smooth([(124, G - 66), (134, G - 70), (138, G - 60)], 3), rock(190, G, 50, 30), hills(0, 60, G, 10)])
K("Sd 19,21", "Stařec ho uvedl do svého domu a dal krmi oslům", lambda: [
    gr(), house(170, G, 60, 40), man(120, 1, "give", h=50, staff=1), man(70, 1, "down", h=54), donkey(30, G, 0.9, 1), moon(210, 20, 7)])
K("Sd 21,21", "Dívky ze Šíla vyšly tančit v zástupech", lambda: [
    gr(), woman(70, 1, "raise", h=46), woman(105, -1, "wide", h=44), woman(140, 1, "raise", h=46), woman(175, -1, "wide", h=44), vine(10, 40, 230, 4),
    [(20, G), (20, 40)], [(225, G), (225, 40)]])

# --- Rút ----------------------------------------------------------------------
K("Rt 3,9", "Rút: Rozprostři nade mnou cíp svého pláště", lambda: [
    gr(), man(110, 1, "down", "lie", g=G, h=44), woman(170, -1, "pray", "kneel", h=42), [(30, G), (60, G - 22), (90, G)], moon(200, 20, 7), stars([(60, 30), (150, 20)])])

# --- 1. Samuelova -------------------------------------------------------------
K("1S 2,1", "Chana se modlila: Mé srdce jásá v Hospodinu", lambda: [
    gr(), woman(100, 1, "raise", h=50), kid(130, -1, h=28), temple(195, G, 60, 34), sun(40, 25, 8)])
K("1S 4,11", "Boží truhla byla zajata", lambda: [
    gr(), man(80, 1, "carry", "walk", h=50), man(130, 1, "carry", "walk", h=50), ark_cov(105, G - 52, 40), spear(160, G, 56), man(200, -1, "cry", h=52)])
K("1S 6,12", "Krávy šly přímo cestou do Bét-šemeše a táhly vůz s truhlou", lambda: [
    gr(), ox(80, G, 1, 1), ox(95, G - 2, 1, 1), [(110, G - 14), (150, G - 14)], circle(120, G - 7, 7), circle(145, G - 7, 7), ark_cov(135, G - 15, 26),
    path(60, G, 0, G - 10, 14, 4), field(180, 240, G, 4)])
K("1S 8,5", "Lid Samuelovi: Ustanov nám krále, jako mají všechny národy", lambda: [
    gr(), man(70, 1, "open", h=54, staff=1), crowd(110, 235, G, 40), crown(170, 40, 16)])
K("1S 11,15", "V Gilgálu ustanovili Saula králem a velice se radovali", lambda: [
    gr(), king(120, 0, "raise", h=60), crowd(10, 95, G, 40), crowd(145, 235, G, 40)])
K("1S 13,9", "Saul nečekal na Samuela a sám obětoval zápalnou oběť", lambda: [
    gr(), king(90, 1, "raise", h=56), altar(140, G, 30, 16, True, True), man(210, -1, "point", "walk", h=54), crowd(0, 50, G, 34)])
K("1S 19,12", "Míkal spustila Davida oknem a on utekl", lambda: [
    gr(), house(110, G, 70, 80, door=False), window(120, G - 62, 16, 14), woman(120, 0, "reach", g=G - 50, h=20)[:4], rope(120, G - 50, 140, G - 20),
    man(160, 1, "down", "walk", h=50), moon(210, 20, 7)])
K("1S 21,6", "Kněz dal Davidovi svaté chleby", lambda: [
    gr(), man(90, 1, "give", h=56), bread(115, G - 32, 7), bread(124, G - 34, 7), man(160, -1, "reach", h=52), table(40, G, 30, 16), tent(210, G, 34, 22)])
K("1S 23,16", "Jónatan přišel za Davidem a posílil ho v Bohu", lambda: [
    gr(), man(100, 1, "give", h=54), man(140, -1, "down", "sit", h=46), tree(200, G, 54), hills(0, 60, G - 2, 12)])
K("1S 26,12", "David vzal kopí a džbán vody od hlavy spícího Saula", lambda: [
    gr(), king(110, 1, "down", "lie", g=G, h=46), spear(70, G - 4, 40, -10), man(170, -1, "hold", h=54), jar(190, G - 26, 0.5), moon(210, 20, 7)])
K("1S 28,8", "Saul se přestrojil a šel v noci", lambda: [
    gr(), man(90, 1, "down", "walk", h=56), man(120, 1, "down", "walk", h=50), man(145, 1, "down", "walk", h=50), moon(200, 22, 8), house(215, G, 30, 22)])
K("1S 31,13", "Pohřbili jejich kosti pod tamaryškem a postili se sedm dní", lambda: [
    gr(), tree(130, G, 64), stones(130, G, 3), man(70, 1, "cry", "sit", h=46), man(190, -1, "cry", "sit", h=46)])

# --- 2. Samuelova -------------------------------------------------------------
K("2S 1,17", "David zpíval žalozpěv nad Saulem a Jónatanem", lambda: [
    gr(), man(100, 1, "cry", "kneel", h=48), harp(140, G, 26), mountain(200, G, 70, 40), sword(60, G - 2, 24, 0)])
K("2S 4,4", "Chůva s Mefibóšetem prchala, on upadl a zůstal chromý", lambda: [
    gr(), woman(110, 1, "carry", "walk", h=48), kid(110, 0, h=18, g=G - 50), house(40, G, 40, 30), path(120, G, 230, G - 10, 16, 4)])
K("2S 8,6", "Hospodin dával Davidovi vítězství všude, kam šel", lambda: [
    gr(), king(110, 1, "raise", h=58), shield(140, G - 30, 1.2), crowd(160, 235, G, 36), city(0, 70, G, 30)])
K("2S 11,2", "David se procházel po střeše královského paláce", lambda: [
    gr(), house(90, G, 100, 60), king(90, 1, "point", g=G - 60, h=40), house(200, G, 50, 30), moon(30, 25, 7)])
K("2S 13,37", "Absolón utekl a David truchlil nad synem každý den", lambda: [
    gr(), king(80, 1, "cry", "sit", h=50), seat(80, G, 16, 12), path(120, G, 230, G - 20, 14, 3), man(210, 1, "down", "walk", h=30)])
K("2S 17,28", "Barzilaj přinesl Davidovi lůžka, mísy, pšenici a med", lambda: [
    gr(), man(80, 1, "give", h=52, staff=1), basket(110, G, 20, 10, 3), jar(140, G, 0.6), bed(180, G, 40), man(220, -1, "open", h=54)])
K("2S 20,16", "Moudrá žena zavolala z města a zachránila je", lambda: [
    gr(), wall(80, 200, G, 50, 5), woman(140, 0, "open", g=G - 50, h=30), man(40, 1, "point", h=54), spear(20, G, 56)])
K("2S 24,24", "David: Nebudu obětovat Hospodinu nic, co mě nic nestálo", lambda: [
    gr(), king(80, 1, "give", h=56), coins(104, G - 30, 4), man(150, -1, "open", h=52), ox(200, G, 0.9, -1), altar(120, G, 20, 12)])

# --- 1. Královská -------------------------------------------------------------
K("1Kr 2,2", "David Šalomounovi: Buď silný a buď mužem", lambda: [
    gr(), bed(80, G, 70), king(80, 1, "bless", "lie", g=G - 6, h=44), king(160, -1, "pray", "kneel", h=50)])
K("1Kr 5,6", "Ať pro mne kácejí cedry na Libanonu", lambda: [
    gr(), tree(60, G, 70), tree(110, G, 60), man(150, -1, [(120, 140), (110, 130)], h=54), rotate(tree(200, G, 50), 80, 200, G)[:2], mountain(200, G - 40, 70, 30)])
K("1Kr 7,23", "Lité moře stálo na dvanácti býcích", lambda: [
    gr(), ellipse(120, G - 40, 50, 8), [(70, G - 40), (80, G - 22), (160, G - 22), (170, G - 40)], ox(80, G, 0.9, -1), ox(120, G, 0.9, 1), ox(160, G, 0.9, 1)])
K("1Kr 9,3", "Posvětil jsem tento dům; mé oči a mé srdce tam budou vždycky", lambda: [
    gr(), temple(120, G, 100, 50), eye(100, 30, 16), heart(140, 30, 6), rays(120, 30, 14, 26, 0, 360, 10)])
K("1Kr 12,28", "Jarobeám udělal dvě zlatá telata", lambda: [
    gr(), king(70, 1, "point", h=56), altar(140, G, 24, 12), ox(140, G - 12, 0.7, 1), altar(200, G, 24, 12), ox(200, G - 12, 0.7, -1)])
K("1Kr 14,6", "Achijáš uslyšel kroky Jarobeámovy ženy: Pojď dál", lambda: [
    gr(), man(80, 1, "open", "sit", h=48, staff=1), seat(80, G, 16, 12), door(130, G, 20, 34), woman(170, -1, "down", "walk", h=48), basket(190, G - 26, 12, 6)])
K("1Kr 16,24", "Omrí koupil horu Šomerón a postavil na ní město", lambda: [
    gr(), hills(80, 240, G, 40), city(130, 220, G - 38, 26), king(60, 1, "give", h=56), coins(84, G - 30, 4)])
K("1Kr 20,11", "Ať se nechlubí ten, kdo se opásává, jako ten, kdo odkládá zbroj", lambda: [
    gr(), man(80, 1, "hold", h=56), helmet(98, G - 34, 1), man(170, -1, "point", h=54), shield(140, G - 10, 1), sword(150, G - 2, 24, 0)])
K("1Kr 22,34", "Kdosi náhodně napjal luk a zasáhl izraelského krále", lambda: [
    gr(), man(50, 1, [(90, 95), (85, 90)], h=54), smooth([(76, G - 54), (82, G - 40), (76, G - 26)], 3), [(80, G - 40), (170, G - 46)],
    chariot(190, G, 1, -1), king(185, -1, "cry", g=G - 16, h=34)])

# --- 2. Královská -------------------------------------------------------------
K("2Kr 1,8", "Muž oblečený v kožich, opásaný koženým pásem – to je Elijáš", lambda: [
    gr(), man(120, 1, "point", h=58, belt=True), hills(150, 240, G - 2, 20), man(50, 1, "open", h=50)])
K("2Kr 3,15", "Elíša: Přiveďte mi hudebníka", lambda: [
    gr(), man(80, 1, "open", h=56), man(140, -1, "down", "sit", h=46), harp(118, G - 8, 24), king(200, -1, h=54)])
K("2Kr 8,6", "Král navrátil Šúnamitce všechno, co jí patřilo", lambda: [
    gr(), king(160, -1, "give", "sit", h=56), throne(165, G, 40, -1), woman(90, 1, "pray", h=48), kid(60, 1, h=30), field(0, 40, G, 3)])
K("2Kr 10,15", "Jehú podal Jónadabovi ruku a vytáhl ho k sobě na vůz", lambda: [
    gr(), chariot(120, G, 1.1, 1), horse(170, G, 1, 1), man(115, 1, "reach", g=G - 18, h=34), man(70, 1, "reach", h=52)])
K("2Kr 12,9", "Kněz Jójada vyvrtal do víka truhly otvor na peníze", lambda: [
    gr(), [(100, G), (100, G - 26), (150, G - 26), (150, G), (100, G)], circle(125, G - 26, 3), man(70, 1, "point", h=56), man(180, -1, "give", h=50),
    coins(158, G - 30, 3)])
K("2Kr 14,9", "Trní na Libanonu vzkázalo cedru… a polní zvěř trní pošlapala", lambda: [
    gr(), tree(70, G, 70), bush(150, G, 20), deer(200, G, 1, -1)])
K("2Kr 18,4", "Chizkijáš rozbil měděného hada, kterého udělal Mojžíš", lambda: [
    gr(), king(80, 1, "raise", h=56), [(150, G), (150, G - 50)], [(140, G - 44), (160, G - 44)], snake(170, G - 4, 1, -1), crowd(190, 235, G, 30)])
K("2Kr 21,13", "Vytřu Jeruzalém, jako se vytírá mísa", lambda: [
    gr(), city(20, 120, G, 30), ellipse(180, G - 16, 26, 6), [(154, G - 16), (165, G - 4), (195, G - 4), (206, G - 16)], hand(200, 50, 1.2, False)])
K("2Kr 24,14", "Nabukadnesar odvlekl do Babylóna řemeslníky a kováře", lambda: [
    gr(), man(60, 1, "down", "walk", h=50), man(90, 1, "down", "walk", h=50), chain(40, G - 30, 110, G - 30, 6), man(140, 1, "point", h=56), spear(160, G, 56),
    city(180, 240, G, 30)])

# --- 1. Paralipomenon ---------------------------------------------------------
K("1Pa 2,1", "Toto jsou synové Izraele", lambda: [
    gr(), man(30, 1, h=50), man(60, 1, h=48), man(90, 1, h=50), man(120, 1, h=46), man(150, -1, h=50), man(180, -1, h=48), man(210, -1, h=44)])
K("1Pa 6,31", "David ustanovil zpěváky, kteří vedli zpěv v Hospodinově domě", lambda: [
    gr(), man(70, 1, "raise", h=54), man(110, 1, "open", h=52), harp(140, G, 24), man(170, -1, "raise", h=52), tent(215, G, 36, 24)])
K("1Pa 8,40", "Ulamovi synové byli stateční muži, lukostřelci", lambda: [
    gr(), man(80, 1, [(90, 95), (85, 90)], h=54), smooth([(106, G - 54), (112, G - 40), (106, G - 26)], 3), [(110, G - 40), (200, G - 46)],
    circle(205, G - 46, 6), circle(205, G - 46, 2), [(205, G - 40), (205, G)]])
K("1Pa 10,12", "Stateční muži pohřbili Saulovy kosti pod posvátným stromem a postili se", lambda: [
    gr(), tree(120, G, 64), stones(120, G, 3), man(60, 1, "cry", "kneel", h=46), man(180, -1, "cry", "kneel", h=46)])
K("1Pa 12,8", "Gádovci – tváře jako lvi, rychlí jako gazely na horách", lambda: [
    gr(), man(70, 1, "hold", h=56), shield(88, G - 30, 1), spear(96, G, 60), deer(150, G, 1.1, 1), hills(110, 240, G - 2, 20), lion(210, G, 0.9, -1)])
K("1Pa 14,15", "Až uslyšíš v korunách stromů šelest kroků, vytáhni do boje", lambda: [
    gr(), tree(130, G, 60), tree(180, G, 54), smooth([(110, 40), (120, 36), (130, 40)], 3), smooth([(150, 34), (160, 30), (170, 34)], 3), king(70, 1, "point", h=56)])
K("1Pa 17,12", "On mi postaví dům a já upevním jeho trůn navěky", lambda: [
    gr(), throne(120, G, 44, 1), crown(120, 40, 16), rays(120, 40, 12, 30, 0, 360, 10), king(60, 1, "pray", "kneel", h=48), temple(200, G, 50, 30)])
K("1Pa 20,6", "Byl tam obr, který měl na rukou i nohou po šesti prstech", lambda: [
    gr(), man(150, -1, "open", h=80), man(70, 1, "point", h=50), spear(180, G, 80)])
K("1Pa 24,5", "Rozdělili kněze losem", lambda: [
    gr(), man(120, 0, "hold", h=56), circle(118, G - 28, 3), crowd(20, 90, G, 38), crowd(150, 235, G, 38)])
K("1Pa 27,1", "Oddíly vojska sloužily králi měsíc co měsíc po celý rok", lambda: [
    gr(), man(60, 1, h=50), spear(74, G, 56), man(100, 1, h=50), spear(114, G, 56), man(140, 1, h=50), spear(154, G, 56), moon(200, 30, 8)])

# --- 2. Paralipomenon ---------------------------------------------------------
K("2Pa 2,14", "Chúram-abí – zručný mistr v práci se zlatem, stříbrem a bronzem", lambda: [
    gr(), man(80, 1, [(60, 90), (40, 80)], "sit", h=48), [(110, G - 20), (130, G - 20), (130, G), (110, G)], flames(140, G - 4, 14), jar(180, G, 0.8),
    cup(210, G - 6)])
K("2Pa 4,7", "Šalomoun udělal deset zlatých svícnů", lambda: [
    gr(), lampstand(40, G, 30), lampstand(80, G, 30), lampstand(120, G, 30), lampstand(160, G, 30), lampstand(200, G, 30)])
K("2Pa 8,18", "Chíramovy lodě s námořníky dopluly do Ofíru pro zlato", lambda: [
    sea(0, 240, G - 4, 3), boat(80, G - 10, 70, True), boat(180, G - 10, 50, True), sun(210, 25, 8)])
K("2Pa 11,16", "Ze všech kmenů přicházeli do Jeruzaléma ti, kdo hledali Hospodina", lambda: [
    gr(), city(140, 235, G, 34), path(0, G, 150, G - 6, 16, 6), man(40, 1, "down", "walk", h=50), woman(70, 1, "down", "walk", h=44), man(100, 1, "down", "walk", h=50, staff=1)])
K("2Pa 13,12", "Bůh je s námi v čele a jeho kněží s troubami", lambda: [
    gr(), man(70, 1, "hold", h=54), trumpet(84, G - 38, 26, -25, 1), man(120, 1, "hold", h=54), trumpet(134, G - 38, 26, -25, 1), crowd(160, 235, G, 40)])
K("2Pa 15,2", "Hospodin je s vámi, když vy jste s ním", lambda: [
    gr(), man(80, 1, "point", h=56), king(140, -1, "pray", h=56), crowd(170, 235, G, 36), rays(110, 15, 4, 22, 40, 140, 7)])
K("2Pa 17,9", "Učili v Judsku a měli s sebou knihu Hospodinova zákona", lambda: [
    gr(), man(80, 1, "hold", h=56), scroll(100, G - 36, 26, 14), crowd(130, 235, G, 38), city(0, 50, G, 26)])
K("2Pa 19,6", "Soudcům: Hleďte, co děláte; nesoudíte pro lidi, ale pro Hospodina", lambda: [
    gr(), king(70, 1, "point", h=56), man(140, -1, "down", "sit", h=46), seat(140, G, 16, 12), scales(190, 30, 1.6)])
K("2Pa 21,12", "Králi přišel dopis od proroka Elijáše", lambda: [
    gr(), king(150, -1, "hold", "sit", h=56), throne(155, G, 40, -1), scroll(126, G - 36, 22, 12), man(70, 1, "give", h=50)])
K("2Pa 23,18", "Jójada svěřil službu kněžím, aby obětovali s radostí a zpěvem", lambda: [
    gr(), man(70, 1, "bless", h=56), temple(170, G, 80, 40), altar(100, G, 20, 12, True), man(130, 1, "raise", h=50)])
K("2Pa 25,9", "Hospodin ti může dát mnohem víc", lambda: [
    gr(), man(80, 1, "point", h=56), king(160, -1, "open", h=56), coins(130, G - 2, 6), rays(80, 15, 4, 22, 40, 140, 5)])
K("2Pa 27,6", "Jótam zesílil, protože řídil své cesty před Hospodinem", lambda: [
    gr(), king(80, 1, "down", "walk", h=58), path(60, G, 220, G - 30, 30, 4), tower(200, G - 30, 18, 50)])
K("2Pa 30,6", "Běžci roznášeli dopisy po celém Izraeli a Judsku", lambda: [
    gr(), man(90, 1, "hold", "walk", h=54), scroll(110, G - 36, 16, 10), man(150, 1, "hold", "walk", h=54), city(180, 240, G, 30), path(0, G, 180, G - 6, 14, 6)])
K("2Pa 32,30", "Chizkijáš svedl vodu z Gíchonu pod zemí na západ do města", lambda: [
    gr(), city(120, 220, G, 34), [(0, G + 12), (180, G + 12)], [(0, G + 18), (180, G + 18)], waves(10, 170, G + 15, 8, 1), man(60, 1, "point", h=54)])
K("2Pa 36,23", "Kýros: Hospodin mi uložil postavit mu dům v Jeruzalémě", lambda: [
    gr(), king(80, 1, "hold", h=58), scroll(100, G - 36, 26, 14), crowd(130, 235, G, 40), sun(200, 25, 8)])

# --- Ezdráš, Nehemiáš, Ester ---------------------------------------------------
K("Ezd 2,1", "Navrátilci z babylonského zajetí se vrátili do Jeruzaléma", lambda: [
    gr(), crowd(10, 120, G, 40), camel(150, G, 1, 1), donkey(190, G, 0.9, 1), city(200, 240, G, 30), path(0, G, 240, G - 4, 12, 6)])
K("Ezd 4,24", "Tehdy se práce na Božím domě zastavila", lambda: [
    gr(), wall(80, 180, G, 20, 2, broken=True), stones(200, G, 3), man(50, 1, "cry", "sit", h=46), [(190, G - 2), (200, G - 30)]])
K("Ezd 6,16", "Posvěcení Božího domu slavili s radostí", lambda: [
    gr(), temple(120, G, 90, 46), crowd(10, 70, G, 38), crowd(170, 235, G, 38), rays(120, 10, 4, 20, 40, 140, 7)])
K("Ezd 9,5", "Ezdráš klekl na kolena a rozprostřel ruce k Hospodinu", lambda: [
    gr(), man(110, 1, "raise", "kneel", h=52), temple(200, G, 50, 30), crowd(10, 60, G, 34)])
K("Neh 1,4", "Nehemiáš seděl, plakal, postil se a modlil", lambda: [
    gr(), man(110, 1, "cry", "sit", h=50), seat(110, G, 16, 12), pillar(40, G, 60), pillar(190, G, 60), moon(210, 20, 7)])
K("Neh 3,1", "Kněží stavěli Ovčí bránu", lambda: [
    gr(), gate(120, G, 40, 50), wall(20, 100, G, 30, 3), wall(140, 230, G, 30, 3), man(60, 1, "carry", h=50), sheep(190, G, 0.8, -1)])
K("Neh 5,11", "Vraťte jim ještě dnes jejich pole, vinice a domy", lambda: [
    gr(), man(80, 1, "point", h=56), man(140, -1, "give", h=52), man(190, -1, "open", h=46), house(220, G, 30, 22)])
K("Neh 7,1", "Hradby byly postaveny a nasadil jsem dveře", lambda: [
    gr(), wall(0, 240, G, 30, 3), gate(120, G, 40, 50), door(120, G, 24, 40), man(70, 1, "point", h=54)])
K("Neh 9,38", "Uzavřeli pevnou smlouvu a sepsali ji", lambda: [
    gr(), table(120, G, 60, 16), scroll(120, G - 24, 40, 16), man(70, 1, "hold", h=54), man(170, -1, "point", h=54), circle(140, G - 18, 3)])
K("Neh 13,19", "Před sobotou dal zavřít brány Jeruzaléma", lambda: [
    gr(), gate(120, G, 44, 50), door(120, G, 28, 40), wall(0, 98, G, 30, 3), wall(142, 240, G, 30, 3), sun(30, G - 40, 9), man(180, -1, "point", h=54)])
K("Est 1,12", "Královna Vašti odmítla přijít na králův rozkaz", lambda: [
    gr(), king(70, 1, "point", "sit", h=56), throne(65, G, 40, 1), woman(180, -1, "back", h=50, crown=True), pillar(130, G, 60)])
K("Est 4,14", "Kdo ví, zda jsi nepřišla ke královské hodnosti právě pro tuto chvíli", lambda: [
    gr(), woman(130, -1, "pray", h=52, crown=True), man(70, 1, "point", h=54), pillar(30, G, 60), pillar(200, G, 60)])
K("Est 7,3", "Ester: Daruj mi život a život mého lidu", lambda: [
    gr(), table(120, G, 70, 16), king(70, 1, "open", "sit", h=56), woman(160, -1, "pray", "kneel", h=46, crown=True), man(210, -1, "cry", "sit", h=46), cup(110, G - 16)])
K("Est 10,3", "Mordokaj byl druhý po králi a hledal dobro svého lidu", lambda: [
    gr(), man(110, 1, "bless", h=58), crowd(140, 235, G, 38), king(40, 1, "down", "sit", h=54)])

# kapitoly, které v číslování BKR začínají jinde než v hebrejském
K("2S 19,39", "Král políbil Barzilaje a požehnal mu", lambda: [
    gr(), king(100, 1, "wide", h=56), man(140, -1, "wide", h=50, staff=0), sea(170, 240, G, 2), donkey(40, G, 0.9, 1)])
K("Neh 10,39", "Neopustíme dům svého Boha", lambda: [
    gr(), temple(150, G, 90, 44), crowd(10, 100, G, 40), man(100, 1, "raise", h=52)])
