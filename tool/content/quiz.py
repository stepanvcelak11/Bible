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
q("ot", "Na které hoře se Elijáš utkal s Baalovými proroky?",
  "Karmel", ["Sínaj", "Olivová hora", "Tábor"], "1Kr 18,20")
q("ot", "Kdo byl vzat do nebe ve vichru?",
  "Elijáš", ["Elíša", "Mojžíš", "Izajáš"], "2Kr 2,11")
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
  "Nátan", ["Gád", "Samuel", "Elijáš"], "2S 12,1")
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
q("people", "Čím obchodovala Lydie z Thyatir?",
  "Purpurem", ["Kořením", "Olejem", "Stříbrem"], "Sk 16,14")
