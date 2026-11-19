"""Biblický kvíz (vlastní otázky aplikace).

Každá otázka: kategorie, otázka, správná odpověď, tři špatné a odkaz,
kde se odpověď v Bibli najde (po odpovědi se zobrazí text). Odkazy
v kanonickém (hebrejském) číslování. Pořadí odpovědí aplikace míchá.
"""

CATEGORIES = [
    ("ot", "Starý zákon"),
    ("gospels", "Ježíš a evangelia"),
    ("church", "Skutky a listy"),
    ("people", "Biblické postavy"),
]

Q = []


def q(cat, question, right, wrong, ref):
    assert len(wrong) == 3 and right not in wrong
    Q.append(dict(category=cat, question=question,
                  answers=[right, *wrong], ref=ref))


# --- Starý zákon -----------------------------------------------------------------
q("ot", "Kterého dne Bůh odpočinul od svého díla stvoření?",
  "Sedmého", ["Šestého", "Prvního", "Osmého"], "Gn 2,2")
q("ot", "Jak se jmenoval prvorozený syn Adama a Evy?",
  "Kain", ["Ábel", "Šét", "Enóš"], "Gn 4,1")
q("ot", "Kolik dní a nocí pršelo při potopě?",
  "40", ["7", "100", "150"], "Gn 7,12")
q("ot", "Co dal Bůh Noemu jako znamení smlouvy?",
  "Duhu", ["Holubici", "Olivovou ratolest", "Oltář"], "Gn 9,13")
q("ot", "Kolik let bylo Abrahamovi, když se mu narodil Izák?",
  "100", ["75", "90", "120"], "Gn 21,5")
q("ot", "Kterého syna měl Abraham obětovat v zemi Mórija?",
  "Izáka", ["Izmaele", "Jákoba", "Ezaua"], "Gn 22,2")
q("ot", "Za co Ezau prodal své prvorozenství?",
  "Za jídlo z čočovice", ["Za stříbrný prsten", "Za stádo ovcí",
                          "Za plášť"], "Gn 25,34")
q("ot", "Kolik synů měl Jákob?",
  "12", ["10", "7", "14"], "Gn 35,22")
q("ot", "Jak se Bůh zjevil Mojžíšovi na poušti?",
  "V hořícím keři", ["Ve snu", "V oblakovém sloupu", "Ve stánku"],
  "Ex 3,2")
q("ot", "Která rána na Egypt byla poslední?",
  "Smrt prvorozených", ["Kobylky", "Tma", "Vředy"], "Ex 12,29")
q("ot", "Čím Bůh sytil Izraelce na poušti?",
  "Manou", ["Chlebem z Egypta", "Fíky", "Medem"], "Ex 16,35")
q("ot", "Na které hoře dostal Mojžíš kamenné desky?",
  "Sínaj", ["Karmel", "Sijón", "Tábor"], "Ex 31,18")
q("ot", "Kolik let putoval Izrael pouští?",
  "40", ["7", "12", "70"], "Nu 14,33")
q("ot", "Hradby kterého města padly po troubení a křiku lidu?",
  "Jericha", ["Aje", "Jeruzaléma", "Gibeónu"], "Joz 6,20")
q("ot", "S kolika muži porazil Gedeón Midjánce?",
  "300", ["12", "3 000", "10 000"], "Sd 7,7")
q("ot", "Na čem závisela Samsonova síla?",
  "Na neostříhaných vlasech", ["Na zbroji", "Na postu",
                               "Na prstenu od otce"], "Sd 16,17")
q("ot", "Koho Bůh v noci volal ve svatyni v Šílu?",
  "Samuela", ["Élího", "Saula", "Davida"], "1S 3,10")
q("ot", "Čím David porazil Goliáše?",
  "Prakem a kamenem", ["Mečem", "Kopím", "Lukem"], "1S 17,50")
q("ot", "Kdo postavil první chrám v Jeruzalémě?",
  "Šalomoun", ["David", "Saul", "Chizkijáš"], "1Kr 6,14")
q("ot", "Na které hoře se Eliáš utkal s Baalovými proroky?",
  "Karmel", ["Sínaj", "Olivová hora", "Tábor"], "1Kr 18,20")
q("ot", "Kdo byl vzat do nebe ve vichru?",
  "Eliáš", ["Elíša", "Mojžíš", "Izajáš"], "2Kr 2,11")
q("ot", "Který prorok byl tři dny a tři noci v břiše ryby?",
  "Jonáš", ["Daniel", "Ezechiel", "Ámos"], "Jon 2,1")
q("ot", "Kam byl Daniel hozen za to, že se modlil?",
  "Do lví jámy", ["Do ohnivé pece", "Do vězení", "Do studny"], "Da 6,17")
q("ot", "Který žalm začíná slovy „Hospodin je můj pastýř“?",
  "23", ["1", "91", "119"], "Ž 23,1")
q("ot", "Který prorok předpověděl, že Mesiáš vzejde z Betléma?",
  "Micheáš", ["Izajáš", "Jeremjáš", "Malachiáš"], "Mi 5,1")
q("ot", "Kdo vedl obnovu jeruzalémských hradeb po exilu?",
  "Nehemjáš", ["Ezdráš", "Zerubábel", "Daniel"], "Neh 2,17")

# --- Ježíš a evangelia -----------------------------------------------------------
q("gospels", "Ve kterém městě se Ježíš narodil?",
  "V Betlémě", ["V Nazaretu", "V Jeruzalémě", "V Kafarnaum"], "Mt 2,1")
q("gospels", "Ve kterém městě Ježíš vyrůstal?",
  "V Nazaretu", ["V Betlémě", "V Kafarnaum", "V Jerichu"], "L 2,51")
q("gospels", "Kdo pokřtil Ježíše v Jordánu?",
  "Jan Křtitel", ["Petr", "Ondřej", "Zachariáš"], "Mt 3,13")
q("gospels", "Kolik dní se Ježíš postil na poušti?",
  "40", ["3", "7", "12"], "Mt 4,2")
q("gospels", "Jaké bylo podle Jana Ježíšovo první znamení?",
  "Proměnil vodu ve víno", ["Uzdravil slepého", "Nasytil zástup",
                            "Utišil bouři"], "J 2,11")
q("gospels", "Kolik apoštolů si Ježíš vyvolil?",
  "12", ["7", "10", "70"], "L 6,13")
q("gospels", "Kolik mužů Ježíš nasytil pěti chleby a dvěma rybami?",
  "Asi 5 000", ["Asi 500", "Asi 3 000", "Asi 10 000"], "Mt 14,21")
q("gospels", "Komu Ježíš řekl, že se člověk musí narodit znovu?",
  "Nikodémovi", ["Zacheovi", "Petrovi", "Pilátovi"], "J 3,3")
q("gospels", "Kdo vylezl na strom, aby Ježíše viděl?",
  "Zacheus", ["Nikodém", "Bartimaios", "Lazar"], "L 19,4")
q("gospels", "Kterého přítele Ježíš vzkřísil čtvrtý den po pohřbu?",
  "Lazara", ["Jaira", "Zachea", "Šimona"], "J 11,43")
q("gospels", "Kdo v podobenství pomohl přepadenému muži?",
  "Samařan", ["Kněz", "Levita", "Hostinský"], "L 10,33")
q("gospels", "Kolik ovcí nechal pastýř, aby hledal jednu ztracenou?",
  "99", ["9", "49", "100"], "L 15,4")
q("gospels", "Které přikázání označil Ježíš za největší?",
  "Milovat Boha celým srdcem", ["Nezabiješ", "Světit sobotu",
                                "Ctít otce a matku"], "Mt 22,37")
q("gospels", "Kde Ježíš říká: „Já jsem ta cesta, pravda i život“?",
  "Jan 14", ["Matouš 5", "Lukáš 15", "Marek 1"], "J 14,6")
q("gospels", "Za kolik stříbrných zradil Jidáš Ježíše?",
  "30", ["10", "40", "100"], "Mt 26,15")
q("gospels", "Kolikrát Petr zapřel Ježíše?",
  "Třikrát", ["Jednou", "Dvakrát", "Sedmkrát"], "Mt 26,75")
q("gospels", "Kterého vězně propustil Pilát místo Ježíše?",
  "Barabáše", ["Šimona", "Jidáše", "Lazara"], "Mt 27,26")
q("gospels", "Kdo musel nést Ježíšův kříž?",
  "Šimon z Kyrény", ["Josef z Arimatie", "Jan", "Petr"], "Mk 15,21")
q("gospels", "Komu se podle Jana vzkříšený Ježíš ukázal u hrobu jako "
  "prvnímu?",
  "Marii Magdalské", ["Petrovi", "Tomášovi", "Ježíšově matce"],
  "J 20,16")
q("gospels", "Který učedník chtěl nejdřív vidět Ježíšovy rány?",
  "Tomáš", ["Filip", "Jakub", "Natanael"], "J 20,27")

# --- Skutky a listy --------------------------------------------------------------
q("church", "Co se stalo o Letnicích po Ježíšově odchodu?",
  "Sestoupil Duch svatý", ["Pavel uvěřil", "Petr byl vysvobozen",
                           "Byl zvolen Matyáš"], "Sk 2,4")
q("church", "Kolik lidí bylo o Letnicích pokřtěno?",
  "Asi 3 000", ["120", "Asi 500", "Asi 10 000"], "Sk 2,41")
q("church", "Kdo byl prvním křesťanským mučedníkem?",
  "Štěpán", ["Jakub", "Petr", "Filip"], "Sk 7,59")
q("church", "Kde se Saul setkal se vzkříšeným Ježíšem?",
  "Na cestě do Damašku", ["V Jeruzalémě", "V Antiochii", "V Tarsu"],
  "Sk 9,3")
q("church", "Kde byli učedníci poprvé nazváni křesťany?",
  "V Antiochii", ["V Jeruzalémě", "V Římě", "V Korintu"], "Sk 11,26")
q("church", "Kdo vyšel s Pavlem na první misijní cestu?",
  "Barnabáš", ["Timotej", "Lukáš", "Silas"], "Sk 13,2")
q("church", "Kde Pavel a Silas o půlnoci zpívali ve vězení?",
  "Ve Filipech", ["V Efezu", "V Athénách", "V Římě"], "Sk 16,25")
q("church", "Na kterém ostrově Pavel ztroskotal?",
  "Na Maltě", ["Na Krétě", "Na Kypru", "Na Patmu"], "Sk 28,1")
q("church", "Ve které kapitole je chvalozpěv na lásku?",
  "1. Korintským 13", ["Římanům 8", "Efezským 2", "Jakubův 1"],
  "1K 13,4")
q("church", "Co je podle Galatským první z ovoce Ducha?",
  "Láska", ["Víra", "Pokoj", "Trpělivost"], "Ga 5,22")
q("church", "Komu napsal Pavel dva listy jako „vlastnímu synu ve víře“?",
  "Timoteovi", ["Titovi", "Filemonovi", "Lukášovi"], "1Tm 1,2")
q("church", "Na kterém ostrově přijal Jan Zjevení?",
  "Na Patmu", ["Na Kypru", "Na Krétě", "Na Maltě"], "Zj 1,9")
q("church", "Čím je člověk podle listu Efezským spasen?",
  "Milostí skrze víru", ["Dodržováním Zákona", "Obřízkou",
                         "Dobrými skutky"], "Ef 2,8")

# --- Biblické postavy ------------------------------------------------------------
q("people", "Kdo se podle Bible dožil nejvyššího věku?",
  "Metuzalém", ["Adam", "Noe", "Abraham"], "Gn 5,27")
q("people", "Jak se jmenovala Abrahamova manželka?",
  "Sára", ["Rebeka", "Ráchel", "Lea"], "Gn 17,15")
q("people", "Za kterou ženu sloužil Jákob sedm let?",
  "Ráchel", ["Lea", "Rebeka", "Dína"], "Gn 29,18")
q("people", "Komu bratři prodali Josefa?",
  "Izmaelcům", ["Egypťanům", "Pelištejcům", "Kenaancům"], "Gn 37,28")
q("people", "Kdo byl Mojžíšovým bratrem a mluvčím?",
  "Áron", ["Jozue", "Kálef", "Chúr"], "Ex 4,14")
q("people", "Kdo převzal vedení Izraele po Mojžíšovi?",
  "Jozue", ["Áron", "Kálef", "Gedeón"], "Joz 1,2")
q("people", "Která prorokyně soudila Izrael pod palmou?",
  "Debora", ["Mirjam", "Chulda", "Jael"], "Sd 4,5")
q("people", "Kdo řekla: „Tvůj lid je můj lid a tvůj Bůh je můj Bůh“?",
  "Rút", ["Noemi", "Orpa", "Ester"], "Rt 1,16")
q("people", "Kdo byl prvním izraelským králem?",
  "Saul", ["David", "Samuel", "Šalomoun"], "1S 10,1")
q("people", "Který Saulův syn byl Davidovým věrným přítelem?",
  "Jónatan", ["Abšalóm", "Jóab", "Nátan"], "1S 18,1")
q("people", "Který prorok pokáral Davida příběhem o ovečce?",
  "Nátan", ["Gád", "Samuel", "Eliáš"], "2S 12,1")
q("people", "Kdo byli hozeni do rozpálené pece a vyšli bez úhony?",
  "Šadrak, Méšak a Abed-nego", ["Daniel a jeho strážci",
                                "Ezdráš a Nehemjáš",
                                "Tři Danielovi synové"], "Da 3,23")
q("people", "Která královna se zastala svého lidu před Hamanem?",
  "Ester", ["Vašti", "Jezábel", "Královna ze Sáby"], "Est 7,3")
q("people", "Kdo byl otcem Jana Křtitele?",
  "Zachariáš", ["Josef", "Simeón", "Zebedeus"], "L 1,13")
q("people", "Čím se živili Petr a Ondřej, když je Ježíš povolal?",
  "Byli rybáři", ["Byli celníci", "Byli tesaři", "Byli pastýři"],
  "Mt 4,18")
q("people", "Čím byl Matouš, než šel za Ježíšem?",
  "Celníkem", ["Rybářem", "Tesařem", "Lékařem"], "Mt 9,9")
q("people", "Jaké řemeslo měl apoštol Pavel?",
  "Stanař", ["Rybář", "Tesař", "Hrnčíř"], "Sk 18,3")
q("people", "Čím obchodovala Lýdie z Thyatir?",
  "Purpurem", ["Kořením", "Olejem", "Stříbrem"], "Sk 16,14")


# --- Doplněné otázky -----------------------------------------------------------
CATEGORIES += [('kings', 'Králové a proroci'), ('wisdom', 'Žalmy a moudrost')]

q('ot', 'Kam Bůh umístil člověka, kterého stvořil?',
  'Do zahrady v Edenu', ['Do Babylóna', 'Na horu Sínaj', 'Do země Kenaán'], 'Gn 2,8')
q('ot', 'Ze kterého stromu Bůh zakázal člověku jíst?',
  'Ze stromu poznání dobrého a zlého', ['Ze stromu života', 'Z fíkovníku', 'Z olivovníku'], 'Gn 2,17')
q('ot', 'Proč lidé přestali stavět babylónskou věž?',
  'Bůh zmátl jejich jazyk', ['Přišla potopa', 'Zničilo ji zemětřesení', 'Došel jim materiál'], 'Gn 11,7-8')
q('ot', 'Odkud se Abram vydal do Kenaánu, když ho Bůh povolal?',
  'Z Cháranu', ['Z Egypta', 'Z Ninive', 'Z Damašku'], 'Gn 12,4')
q('ot', 'Co Hospodin slíbil Abramovi, když mu ukázal hvězdy na nebi?',
  'Že jeho potomstvo bude stejně početné', ['Že bude králem', 'Že se dožije sta let', 'Že získá Egypt'], 'Gn 15,5')
q('ot', 'Co se stalo s Lotovou ženou, když se ohlédla?',
  'Proměnila se v solný sloup', ['Oslepla', 'Onemocněla malomocenstvím', 'Ztratila řeč'], 'Gn 19,26')
q('ot', 'Co viděl Jákob ve snu v Bét-elu?',
  'Žebřík sahající do nebe', ['Hořící keř', 'Sedm krav', 'Duhu nad zemí'], 'Gn 28,12')
q('ot', 'Jaké jméno dostal Jákob po zápasu u potoka Jabok?',
  'Izrael', ['Abraham', 'Juda', 'Edom'], 'Gn 32,29')
q('ot', 'Co dal Jákob Josefovi jako znamení zvláštní lásky?',
  'Pestrobarevnou suknici', ['Zlatý prsten', 'Meč', 'Stádo ovcí'], 'Gn 37,3')
q('ot', 'Co znamenal faraonův sen o sedmi tučných a sedmi hubených kravách?',
  'Sedm let hojnosti a sedm let hladu', ['Sedm vítězných válek', 'Sedm let moru', 'Sedm budoucích králů'], 'Gn 41,29-30')
q('ot', 'Kdo vytáhl malého Mojžíše z vody v ošatce?',
  'Faraonova dcera', ['Mojžíšova matka', 'Egyptská porodní bába', 'Faraonova manželka'], 'Ex 2,5')
q('ot', 'Co si Izraelci udělali, když Mojžíš dlouho nesestupoval z hory?',
  'Zlaté tele', ['Měděného hada', 'Kamenný oltář', 'Zlatou truhlu'], 'Ex 32,4')
q('ot', 'Kolik zvědů vyslal Mojžíš do kenaanské země?',
  '12', ['2', '7', '40'], 'Nu 13,2')
q('ot', 'Kteří dva zvědové dostali slib, že vejdou do zaslíbené země?',
  'Jozue a Káleb', ['Áron a Chúr', 'Mojžíš a Áron', 'Gedeón a Barák'], 'Nu 14,30')
q('ot', 'Kdo v Jerichu ukryl izraelské zvědy?',
  'Rachab', ['Debora', 'Rút', 'Jáel'], 'Joz 2,4')
q('ot', 'Čím si Gedeón ověřoval Boží vůli?',
  'Rounem', ['Losem', 'Hvězdami', 'Snem'], 'Sd 6,37')
q('ot', 'Kde k Eliášovi promluvil Hospodin tichým, jemným hlasem?',
  'Na hoře Choréb', ['Na Karmelu', 'V jeruzalémském chrámu', 'U Jordánu'], '1Kr 19,8-12')
q('ot', 'Kdo posilnil Eliáše jídlem, když na poušti prosil o smrt?',
  'Anděl', ['Havrani', 'Vdova ze Sarepty', 'Elíša'], '1Kr 19,5')
q('ot', 'Kolikrát se měl Naamán umýt v Jordánu, aby byl čistý?',
  'Sedmkrát', ['Třikrát', 'Jednou', 'Dvanáctkrát'], '2Kr 5,10')
q('ot', 'Za kterého krále byl zničen jeruzalémský chrám a lid odveden do Babylóna?',
  'Nebúkadnesara', ['Kýra', 'Faraona Neka', 'Sancheríba'], '2Kr 25,8-9')
q('ot', 'Který perský král dovolil Židům vrátit se a postavit chrám?',
  'Kýros', ['Dareios', 'Xerxes', 'Nebúkadnesar'], 'Ezd 1,1-3')
q('ot', 'Co napsala tajemná ruka na zeď Belšasarova paláce?',
  'Mene, mene, tekel, ufarsin', ['Svatý, svatý, svatý', 'Pamatuj na Hospodina', 'Hle, přichází král'], 'Da 5,25')
q('ot', 'Co Ezechiel uviděl v údolí, kterému Bůh vrátil život?',
  'Suché kosti', ['Zbořené modly', 'Rozbité hradby', 'Uschlé stromy'], 'Ez 37,1-4')
q('ot', 'Kterému městu kázal Jonáš pokání?',
  'Ninive', ['Babylónu', 'Sodomě', 'Týru'], 'Jon 3,2')
q('gospels', 'Jak se jmenoval anděl, který zvěstoval Marii narození Ježíše?',
  'Gabriel', ['Michael', 'Rafael', 'Serafín'], 'L 1,26-27')
q('gospels', 'Kam Marie položila novorozeného Ježíše?',
  'Do jeslí', ['Do košíku', 'Do kolébky v chrámu', 'Na lůžko v hostinci'], 'L 2,7')
q('gospels', 'Kdo podle Matouše přišel k Ježíši, veden hvězdou?',
  'Mudrci od východu', ['Pastýři', 'Kněží z chrámu', 'Herodovi vojáci'], 'Mt 2,1-2')
q('gospels', 'Kam utekl Josef s Marií a dítětem před Herodem?',
  'Do Egypta', ['Do Babylóna', 'Do Nazareta', 'Do Damašku'], 'Mt 2,14')
q('gospels', 'Kolik bylo Ježíšovi, když zůstal v chrámu a rodiče ho hledali?',
  '12 let', ['30 let', '8 dní', '7 let'], 'L 2,42')
q('gospels', 'Kolik let bylo Ježíšovi přibližně, když začal veřejně působit?',
  'Asi 30', ['Asi 20', 'Asi 40', 'Asi 12'], 'L 3,23')
q('gospels', 'Čím se živil Jan Křtitel na poušti?',
  'Kobylkami a medem', ['Manou', 'Chlebem a rybami', 'Datlemi a mlékem'], 'Mt 3,4')
q('gospels', 'Kde podle Matouše Ježíš pronesl blahoslavenství?',
  'Na hoře', ['Na lodi', 'V chrámu', 'V nazaretské synagoze'], 'Mt 5,1-3')
q('gospels', 'Kterou modlitbu Ježíš naučil své učedníky?',
  'Otče náš', ['Žalm 23', 'Slyš, Izraeli', 'Chvalozpěv Mariin'], 'Mt 6,9-13')
q('gospels', 'Na čem postavil svůj dům moudrý muž z Ježíšova podobenství?',
  'Na skále', ['Na písku', 'Na kopci', 'U řeky'], 'Mt 7,24-25')
q('gospels', 'Co udělal Ježíš, když se na jezeře strhla bouře a učedníci ho vzbudili?',
  'Utišil vítr a moře', ['Poslal je zpět ke břehu', 'Skočil do vody', 'Odplul sám na druhý břeh'], 'Mk 4,39')
q('gospels', 'Kdo šel po vodě Ježíši naproti?',
  'Petr', ['Jan', 'Ondřej', 'Jakub'], 'Mt 14,29')
q('gospels', 'Kdo se ukázal s Ježíšem při jeho proměnění?',
  'Mojžíš a Eliáš', ['Abraham a David', 'Izajáš a Jeremjáš', 'Noe a Henoch'], 'Mt 17,3')
q('gospels', 'Kolikrát má podle Ježíše člověk odpustit svému bratru?',
  'Sedmdesátkrát sedmkrát', ['Sedmkrát', 'Třikrát', 'Jednou za rok'], 'Mt 18,22')
q('gospels', 'Co udělal mladší syn v podobenství o marnotratném synu?',
  'Promrhal svůj podíl majetku', ['Zabil vykrmené tele', 'Zůstal doma s otcem', 'Koupil si pole'], 'L 15,13')
q('gospels', 'Kolik malomocných Ježíš uzdravil, když se mu jen jeden vrátil poděkovat?',
  '10', ['7', '12', '3'], 'L 17,17')
q('gospels', 'Na čem vjel Ježíš do Jeruzaléma?',
  'Na oslátku', ['Na koni', 'Na velbloudu', 'Na voze'], 'J 12,14')
q('gospels', 'Co podle Jana udělal Ježíš učedníkům při poslední večeři?',
  'Umyl jim nohy', ['Pomazal je olejem', 'Pokřtil je', 'Dal jim prsteny'], 'J 13,5')
q('gospels', 'Kde se Ježíš modlil v noci, kdy byl zatčen?',
  'V Getsemane', ['V chrámu', 'V Betánii', 'V Kafarnaum'], 'Mt 26,36')
q('gospels', 'Komu Petr při Ježíšově zatčení usekl ucho?',
  'Malchovi', ['Kaifášovi', 'Barabášovi', 'Jidášovi'], 'J 18,10')
q('gospels', 'Co dal Pilát napsat nad Ježíšův kříž?',
  'Ježíš Nazaretský, král Židů', ['Syn Boží', 'Rouhač', 'Prorok z Galileje'], 'J 19,19')
q('gospels', 'Kdo požádal Piláta o Ježíšovo tělo?',
  'Josef z Arimatie', ['Petr', 'Zacheus', 'Lazar'], 'Mt 27,57-58')
q('gospels', 'Kam šli dva učedníci, k nimž se vzkříšený Ježíš připojil na cestě?',
  'Do Emauz', ['Do Betléma', 'Do Jericha', 'Do Kafarnaum'], 'L 24,13')
q('gospels', 'Kolik velkých ryb vytáhli učedníci v síti po Ježíšově vzkříšení?',
  '153', ['100', '99', '77'], 'J 21,11')
q('gospels', 'Kolikrát se Ježíš po vzkříšení zeptal Petra: „Miluješ mě?“',
  'Třikrát', ['Jednou', 'Dvakrát', 'Sedmkrát'], 'J 21,17')
q('church', 'Koho apoštolové vybrali losem na místo Jidáše?',
  'Matěje', ['Barnabáše', 'Štěpána', 'Pavla'], 'Sk 1,26')
q('church', 'Koho uzdravili Petr a Jan u chrámové brány zvané Krásná?',
  'Chromého od narození', ['Slepého', 'Malomocného', 'Hluchoněmého'], 'Sk 3,2-7')
q('church', 'Kteří manželé lhali o ceně prodaného pole?',
  'Ananiáš a Safira', ['Akvila a Priscilla', 'Zachariáš a Alžběta', 'Josef a Marie'], 'Sk 5,1-2')
q('church', 'Komu Filip na cestě vysvětlil proroka Izajáše a pokřtil ho?',
  'Etiopskému dvořanovi', ['Kornéliovi', 'Šimonu kouzelníkovi', 'Saulovi'], 'Sk 8,27-38')
q('church', 'Kdo vložil v Damašku ruce na Saula, aby znovu viděl?',
  'Ananiáš', ['Barnabáš', 'Petr', 'Silas'], 'Sk 9,17')
q('church', 'Kterého setníka navštívil Petr v Cesareji?',
  'Kornélia', ['Julia', 'Theofila', 'Felixe'], 'Sk 10,1')
q('church', 'Kdo vyvedl Petra z vězení, když byl hlídán čtyřmi stráži?',
  'Anděl Páně', ['Král Herodes', 'Apoštol Jan', 'Římský setník'], 'Sk 12,7')
q('church', 'Kde Pavel kázal o oltáři „neznámému Bohu“?',
  'V Athénách', ['V Římě', 'V Korintu', 'V Efezu'], 'Sk 17,22-23')
q('church', 'Kdo byli Akvila a Priscilla?',
  'Manželé, Pavlovi spolupracovníci', ['Římští úředníci', 'Proroci z Antiochie', 'Pavlovi rodiče'], 'Sk 18,2')
q('church', 'Který mladík usnul při Pavlově kázání a vypadl z okna?',
  'Eutychus', ['Timoteus', 'Titus', 'Onésimus'], 'Sk 20,9')
q('church', 'K čemu se Pavel odvolal, když byl souzen před Festem?',
  'K císaři', ['K veleradě', 'K Mojžíšovu zákonu', 'K lidu v Jeruzalémě'], 'Sk 25,11')
q('church', 'Komu napsal Pavel list kvůli uprchlému otroku Onésimovi?',
  'Filemonovi', ['Titovi', 'Timoteovi', 'Gaiovi'], 'Fm 1,10')
q('church', 'Kdo podle Římanům 3,23 zhřešil?',
  'Všichni', ['Většina lidí', 'Jen pohané', 'Jen zákoníci'], 'Ř 3,23')
q('church', 'Co je podle Římanům 6,23 mzdou hříchu?',
  'Smrt', ['Nemoc', 'Chudoba', 'Vyhnanství'], 'Ř 6,23')
q('church', 'Co podle 1. Korintským 13,13 zůstává?',
  'Víra, naděje a láska', ['Moudrost a poznání', 'Zákon a proroci', 'Modlitba a půst'], '1K 13,13')
q('church', 'Jaká je podle Jakubova listu víra bez skutků?',
  'Mrtvá', ['Dokonalá', 'Skrytá', 'Nejsilnější'], 'Jk 2,17')
q('church', 'Kolika církvím jsou určeny dopisy na začátku knihy Zjevení?',
  'Sedmi', ['Dvanácti', 'Třem', 'Deseti'], 'Zj 1,11')
q('church', 'Kterými slovy se Kristus představuje ve Zjevení 22,13?',
  'Já jsem Alfa i Omega', ['Já jsem dobrý pastýř', 'Já jsem pravá réva', 'Já jsem chléb života'], 'Zj 22,13')
q('church', 'Kolik dní po Ježíšově vzkříšení se učedníkům ukazoval, než byl vzat do nebe?',
  '40', ['3', '7', '50'], 'Sk 1,3')
q('church', 'Jaké jméno měl Saul, když začal působit mezi pohany?',
  'Pavel', ['Petr', 'Silas', 'Barnabáš'], 'Sk 13,9')
q('people', 'Který Abrahamův synovec se usadil u Sodomy?',
  'Lot', ['Izák', 'Nachor', 'Lában'], 'Gn 13,12')
q('people', 'Kdo se stal Izákovou manželkou?',
  'Rebeka', ['Ráchel', 'Lea', 'Sára'], 'Gn 24,67')
q('people', 'Jak se jmenoval Josefův nejmladší bratr?',
  'Benjamín', ['Juda', 'Rúben', 'Lévi'], 'Gn 35,18')
q('people', 'Která Mojžíšova sestra zpívala s bubínkem po přechodu moře?',
  'Mirjam', ['Sipora', 'Debora', 'Chana'], 'Ex 15,20')
q('people', 'Jak se jmenovala Mojžíšova manželka?',
  'Sipora', ['Mirjam', 'Rachab', 'Ráchel'], 'Ex 2,21')
q('people', 'Která žena se v Šílu modlila o syna a porodila Samuela?',
  'Chana', ['Penina', 'Noemi', 'Abígail'], '1S 1,20')
q('people', 'Koho si vzala Rút za muže v Betlémě?',
  'Bóaza', ['Elímeleka', 'Obéda', 'Machlóna'], 'Rt 4,13')
q('people', 'Kdo byla Rútina tchyně?',
  'Noemi', ['Orpa', 'Chana', 'Debora'], 'Rt 1,3-4')
q('people', 'Jak se jmenoval Davidův otec?',
  'Jišaj', ['Bóaz', 'Obéd', 'Saul'], '1S 16,1')
q('people', 'Čí manželkou byla Batšeba, než si ji vzal David?',
  'Uriáše Chetejského', ['Joába', 'Nátana', 'Abšalóma'], '2S 11,3')
q('people', 'Který Davidův syn se proti otci vzbouřil?',
  'Abšalóm', ['Šalomoun', 'Nátan', 'Jónatan'], '2S 15,10')
q('people', 'Koho povolal Eliáš za svého nástupce?',
  'Elíšu', ['Gechazího', 'Jonáše', 'Ozeáše'], '1Kr 19,16')
q('people', 'Která královna chtěla zabít proroka Eliáše?',
  'Jezábel', ['Atalja', 'Ester', 'Vašti'], '1Kr 19,2')
q('people', 'Kdo vychoval královnu Ester?',
  'Mordokaj', ['Haman', 'Nehemjáš', 'Ezdráš'], 'Est 2,7')
q('people', 'Kdo přišel o všechno, zůstal Bohu věrný a Bůh mu nakonec dvojnásob požehnal?',
  'Jób', ['Lot', 'Ezau', 'Jonáš'], 'Jb 42,10')
q('people', 'Kdo byla matka Jana Křtitele?',
  'Alžběta', ['Anna', 'Marie', 'Salome'], 'L 1,5')
q('people', 'Jak se jmenovala sestra Marty a Lazara?',
  'Marie', ['Salome', 'Lýdie', 'Tabita'], 'J 11,1')
q('people', 'Který velekněz vedl výslech Ježíše?',
  'Kaifáš', ['Gamaliel', 'Nikodém', 'Zachariáš'], 'Mt 26,57')
q('people', 'Kterou učednici v Joppe vzkřísil Petr?',
  'Tabitu', ['Lýdii', 'Priscillu', 'Rode'], 'Sk 9,40')
q('people', 'U kterého učitele se Pavel vzdělával v Zákoně?',
  'U Gamaliela', ['U Nikodéma', 'U Kaifáše', 'U Barnabáše'], 'Sk 22,3')
q('kings', 'Kdo pomazal Davida za krále?',
  'Samuel', ['Nátan', 'Eliáš', 'Gád'], '1S 16,13')
q('kings', 'Které město dobyl David a učinil je svým sídlem?',
  'Jeruzalém', ['Hebron', 'Samaří', 'Betlém'], '2S 5,6-7')
q('kings', 'Oč požádal Šalomoun Boha, když mu Bůh nabídl cokoli?',
  'O moudré srdce', ['O bohatství', 'O dlouhý život', 'O vítězství nad nepřáteli'], '1Kr 3,9')
q('kings', 'Která panovnice přijela vyzkoušet Šalomounovu moudrost?',
  'Královna ze Šeby', ['Ester', 'Jezábel', 'Vašti'], '1Kr 10,1')
q('kings', 'Který Šalomounův syn kraloval, když se říše rozdělila?',
  'Rechabeám', ['Jarobeám', 'Abšalóm', 'Ása'], '1Kr 11,43')
q('kings', 'Kdo se stal prvním králem severního Izraele po rozdělení říše?',
  'Jarobeám', ['Rechabeám', 'Achab', 'Omrí'], '1Kr 12,20')
q('kings', 'Který izraelský král si vzal za ženu Jezábel?',
  'Achab', ['Jehú', 'Saul', 'Jarobeám'], '1Kr 16,31')
q('kings', 'Kdo nosil Eliášovi u potoka Kerít chléb a maso?',
  'Havrani', ['Holubice', 'Anděl', 'Vdova ze Sarepty'], '1Kr 17,6')
q('kings', 'Komu Elíša rozmnožil olej, aby mohla splatit dluh?',
  'Chudé vdově', ['Šúnemské ženě', 'Naamánovi', 'Královně Jezábel'], '2Kr 4,1-7')
q('kings', 'Kolik bylo Jóašovi, když se stal judským králem?',
  '7 let', ['12 let', '18 let', '30 let'], '2Kr 12,1')
q('kings', 'Kterému králi Bůh prodloužil život o patnáct let?',
  'Chizkijášovi', ['Joziášovi', 'Davidovi', 'Uzijášovi'], '2Kr 20,6')
q('kings', 'Za kterého krále se v chrámu našla kniha Zákona?',
  'Joziáše', ['Chizkijáše', 'Achaza', 'Menašeho'], '2Kr 22,8')
q('kings', 'Kdy viděl Izajáš Hospodina sedět na vysokém trůnu?',
  'V roce, kdy zemřel král Uzijáš', ['Při posvěcení chrámu', 'V babylónském zajetí', 'Při korunovaci Joziáše'], 'Iz 6,1')
q('kings', 'Čeho se ve vidění dotkl serafín Izajášových rtů?',
  'Žhavým uhlíkem', ['Kapkou oleje', 'Svitkem knihy', 'Svou rukou'], 'Iz 6,6-7')
q('kings', 'Kolik let mělo podle Jeremjáše trvat babylónské zajetí?',
  '70', ['40', '7', '400'], 'Jr 25,11')
q('kings', 'Kterého proroka spustili do cisterny plné bláta?',
  'Jeremjáše', ['Izajáše', 'Ezechiela', 'Daniela'], 'Jr 38,6')
q('kings', 'Kterému prorokovi Bůh řekl, aby si vzal Gomeru?',
  'Ozeášovi', ['Ámosovi', 'Jóelovi', 'Micheášovi'], 'Oz 1,2-3')
q('kings', 'Čím byl Ámos, než ho Bůh poslal prorokovat?',
  'Pastýřem a pěstitelem fíků', ['Knězem', 'Písařem', 'Rybářem'], 'Am 7,14')
q('kings', 'Který prorok zvěstoval, že Bůh vylije svého Ducha na každé tělo?',
  'Jóel', ['Ámos', 'Malachiáš', 'Abakuk'], 'Jl 3,1')
q('kings', 'Který prorok pokáral krále Davida po hříchu s Batšebou?',
  'Nátan', ['Samuel', 'Gád', 'Eliáš'], '2S 12,7')
q('wisdom', 'Čím je podle Žalmu 119 Boží slovo mé noze?',
  'Svítilnou', ['Holí', 'Pokrmem', 'Štítem'], 'Ž 119,105')
q('wisdom', 'Čemu se podobá spravedlivý podle Žalmu 1?',
  'Stromu u tekoucích vod', ['Skále', 'Lvu', 'Hvězdě'], 'Ž 1,3')
q('wisdom', 'Komu připisují nadpisy nejvíc žalmů?',
  'Davidovi', ['Šalomounovi', 'Mojžíšovi', 'Asafovi'], 'Ž 3,1')
q('wisdom', 'Který žalm je nejdelší kapitolou Bible?',
  '119', ['23', '150', '51'], 'Ž 119,1')
q('wisdom', 'Kolik žalmů obsahuje kniha Žalmů?',
  '150', ['120', '100', '176'], 'Ž 150,6')
q('wisdom', 'Co je podle Přísloví počátkem poznání?',
  'Bázeň před Hospodinem', ['Bohatství', 'Učení u mudrců', 'Dlouhý věk'], 'Př 1,7')
q('wisdom', 'Na co se nemáš spoléhat podle Přísloví 3,5?',
  'Na vlastní rozumnost', ['Na Hospodina', 'Na rady otce', 'Na modlitbu'], 'Př 3,5')
q('wisdom', 'Ke kterému tvoru posílají Přísloví lenocha, aby se učil?',
  'K mravenci', ['K včele', 'Ke lvu', 'K holubici'], 'Př 6,6')
q('wisdom', 'Co má podle Kazatele svůj čas?',
  'Všechno pod nebem', ['Jen radost', 'Jen práce', 'Jen modlitba'], 'Kaz 3,1')
q('wisdom', 'Kterými slovy začíná Kazatel svou úvahu o životě?',
  'Marnost nad marnost', ['Bázeň Hospodinova', 'Všechno je dobré', 'Hle, činím nové věci'], 'Kaz 1,2')
q('wisdom', 'O čem zpívá Píseň písní?',
  'O lásce mezi milými', ['O stvoření světa', 'O válce', 'O stavbě chrámu'], 'Pís 1,2')
q('wisdom', 'Kdo podle knihy Jób zpochybnil před Hospodinem Jóbovu věrnost?',
  'Satan', ['Elífaz', 'Bildad', 'Michael'], 'Jb 1,9-11')
q('wisdom', 'Kolik přátel přišlo Jóba potěšit?',
  'Tři', ['Sedm', 'Dva', 'Dvanáct'], 'Jb 2,11')
q('wisdom', 'Který žalm je Davidovou kajícnou modlitbou po hříchu s Batšebou?',
  '51', ['23', '1', '100'], 'Ž 51,1-2')
q('wisdom', 'Jak začíná Žalm 46: „Bůh je naše …“',
  'Útočiště a síla', ['Světlo a spása', 'Pastýř', 'Píseň'], 'Ž 46,2')


# --- Otázky k dalším postavám ---------------------------------------------------
q("people", "Který učitel zákona radil veleradě, aby apoštoly nechala být?",
  "Gamaliel", ["Nikodém", "Kaifáš", "Annáš"], "Sk 5,34")
q("people", "Jak se jmenoval mladík, který usnul při Pavlově kázání a spadl "
  "z okna?",
  "Eutychus", ["Timoteus", "Onésimos", "Tychikus"], "Sk 20,9")
q("people", "Kdo poznal Petrův hlas za dveřmi, ale z radosti mu zapomněl "
  "otevřít?",
  "Služka Rode", ["Marie, matka Marka", "Lýdie", "Tabita"], "Sk 12,13-14")
q("church", "Co chtěl Šimon mág od apoštolů koupit za peníze?",
  "Moc udílet Ducha svatého", ["Místo mezi apoštoly", "Uzdravovací olej",
                              "Petrovy klíče"], "Sk 8,18-19")
q("church", "Který prorok svázal sám sebe Pavlovým pásem?",
  "Agabos", ["Silas", "Barnabáš", "Apollos"], "Sk 21,10-11")
q("gospels", "Kolik dala do chrámové pokladnice chudá vdova?",
  "Dvě drobné mince", ["Jeden denár", "Desátek z úrody", "Stříbrný talent"],
  "Mk 12,42")
q("gospels", "Komu Ježíš na kříži řekl: „Dnes budeš se mnou v ráji“?",
  "Kajícímu lotrovi", ["Janovi", "Setníkovi", "Marii Magdalské"],
  "L 23,43")
q("gospels", "Kterému sluhovi velekněze uťal Petr ucho?",
  "Malchovi", ["Kaifášovi", "Barabášovi", "Alexandrovi"], "J 18,10")
q("gospels", "Jak dlouho trpěla žena krvotokem, než se dotkla Ježíšova "
  "roucha?",
  "Dvanáct let", ["Tři roky", "Sedm let", "Čtyřicet let"], "Mk 5,25")
q("kings", "Kdo byl pomazán za krále Izraele, aby vyhladil Achabův dům?",
  "Jehú", ["Jóram", "Ozeáš", "Jarobeám"], "2Kr 9,6-7")
q("kings", "Který Elíšův služebník si vzal Naamánovy dary a dostal jeho "
  "malomocenství?",
  "Gechazí", ["Báruk", "Jónatan", "Ebed-melek"], "2Kr 5,27")
q("kings", "Proti kterému městu prorokoval Nahum?",
  "Ninive", ["Babylón", "Týr", "Damašek"], "Na 1,1")
q("kings", "Který prorok slíbil, že Bůh vyleje svého Ducha na všechny lidi?",
  "Jóel", ["Ámos", "Abdijáš", "Ageus"], "Jl 3,1")
q("kings", "Který prorok povzbuzoval lid po návratu z exilu ke stavbě "
  "chrámu slovy „Pomyslete na své cesty“?",
  "Ageus", ["Malachiáš", "Ezechiel", "Daniel"], "Ag 1,5")
q("kings", "Kterou knihou končí Starý zákon v křesťanských Biblích?",
  "Malachiáš", ["Zacharjáš", "Daniel", "Nehemjáš"], "Mal 1,1")
q("ot", "Jak zemřeli Áronovi synové Nádab a Abíhú?",
  "Pohltil je oheň od Hospodina", ["Otrávili se", "Spolkla je země",
                                   "Zabil je Mojžíš"], "Lv 10,2")
