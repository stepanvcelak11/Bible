"""Příběhy Bible pro myšlenkovou mapu: období → příběhy → postavy,
a souvislosti mezi příběhy (vlastní texty aplikace).

Pole: id, období (id ze story.py), název, rozsah („Gn 1-2“ – první
kapitola se otevře ve čtečce), shrnutí, postavy (id z people.py),
souvislosti [(id příběhu, proč spolu souvisí)]. Souvislost stačí zapsat
u jednoho z obou příběhů. Kapitoly v kanonickém (hebrejském) číslování.
"""

S = [
    # --- Stvoření a pád ------------------------------------------------------
    ("stvoreni", "creation", "Stvoření světa", "Gn 1-2",
     "Bůh slovem tvoří dobrý svět a člověka ke svému obrazu. Sedmý den "
     "odpočívá a dává lidem zahradu i úkol o ni pečovat.",
     ["adam", "eva"],
     [("nove-nebe", "Bible začíná zahradou a končí městem se stromem "
       "života – stvoření je obnoveno"),
      ("narozeni", "„Na počátku bylo Slovo“ – skrze Slovo, které se stalo "
       "tělem, vzniklo všechno (J 1)")]),
    ("pad", "creation", "Pád do hříchu", "Gn 3",
     "Had zpochybní Boží slovo a lidé jedí ze zakázaného stromu. Ztrácejí "
     "blízkost s Bohem, ale slyší první slib vítězství nad zlem.",
     ["adam", "eva"],
     [("pokuseni", "Kde Adam v zahradě podlehl, Ježíš na poušti obstál"),
      ("kriz", "Slib, že potomek ženy rozdrtí hadovi hlavu (Gn 3,15)"),
      ("drak", "„Starý had, zvaný ďábel“ je nakonec poražen")]),
    ("kain-abel", "creation", "Kain a Ábel", "Gn 4",
     "První bratři a první vražda. Bůh Kaina varuje, že hřích číhá u dveří, "
     "a i vraha chrání znamením.",
     ["kain", "abel"],
     [("hrdinove-viry", "Ábel je první v řadě hrdinů víry (Žd 11,4)")]),
    ("potopa", "creation", "Potopa a Noe", "Gn 6-9",
     "Svět je plný násilí, ale Noe chodí s Bohem. Bůh ho zachrání v arše "
     "a po potopě uzavírá smlouvu s duhou.",
     ["noe", "henoch"],
     [("krest", "Voda soudu i záchrany – Petr ji čte jako obraz křtu "
       "(1Pt 3,20-21)"),
      ("hrdinove-viry", "Henoch i Noe patří mezi svědky víry")]),
    ("babel", "creation", "Babylonská věž", "Gn 11",
     "Lidé chtějí stavbou dosáhnout nebe a udělat si jméno. Bůh zmate "
     "jejich jazyky a rozptýlí je po zemi.",
     [],
     [("letnice", "V Babelu se jazyky rozdělily, o Letnicích jim lidé "
       "z mnoha národů rozumějí"),
      ("abram", "Lidé si chtěli udělat jméno – Abramovi Bůh slibuje, že "
       "jeho jméno učiní velkým")]),

    # --- Praotcové -----------------------------------------------------------
    ("abram", "patriarchs", "Povolání Abrama", "Gn 12-15",
     "Bůh volá Abrama z Cháranu do neznámé země a slibuje potomstvo "
     "a požehnání pro všechny národy. Abram uvěří a Bůh to počítá za "
     "spravedlnost.",
     ["abraham", "sara", "lot", "melchisedech"],
     [("kornelius", "Požehnání pro všechny národy se naplňuje, když "
       "evangelium přijímají pohané"),
      ("pavlovy-listy", "Abraham uvěřil – Pavel jím dokládá ospravedlnění "
       "z víry (Ř 4)")]),
    ("hagar", "patriarchs", "Hagar a Izmael", "Gn 16",
     "Sáraj nečeká na Boží slib a dá Abramovi svou otrokyni. Hagar utíká "
     "na poušť, kde ji najde Bůh, „který vidí“.",
     ["hagar", "izmael", "sara"], []),
    ("sodoma", "patriarchs", "Sodoma a Gomora", "Gn 18-19",
     "Tři hosté slibují Sáře syna. Abraham pak prosí za Sodomu a Bůh "
     "z ní vyvede Lota s rodinou.",
     ["abraham", "sara", "lot"], []),
    ("izak", "patriarchs", "Obětování Izáka", "Gn 21-22",
     "Slíbený syn se konečně narodí. Pak Bůh žádá Abrahama, aby ho "
     "obětoval – a na hoře Mórija si sám opatří beránka.",
     ["abraham", "izak", "sara", "izmael"],
     [("kriz", "Otec, jediný syn a dřevo na hoře – Bůh si opatří "
       "beránka"),
      ("hrdinove-viry", "Abraham věřil, že Bůh může i mrtvé vzkřísit "
       "(Žd 11,17-19)")]),
    ("rebeka", "patriarchs", "Nevěsta pro Izáka", "Gn 24",
     "Abrahamův služebník prosí o znamení u studny a Bůh ho dovede "
     "k Rebece, která ochotně odchází za Izákem.",
     ["izak", "rebeka", "laban"],
     [("samaritanka", "Setkání u studny – i Ježíš se u studny setká "
       "se ženou")]),
    ("jakob-ezau", "patriarchs", "Jákob a Ezau", "Gn 25-27",
     "Dvojčata soupeří už v lůně. Ezau prodá prvorozenství za misku "
     "jídla a Jákob lstí získá otcovo požehnání.",
     ["jakob", "ezau", "rebeka", "izak"], []),
    ("zebrik", "patriarchs", "Jákobův žebřík a léta u Lábana", "Gn 28-31",
     "Na útěku vidí Jákob žebřík do nebe a slyší Boží slib. U Lábana "
     "slouží za Ráchel, je sám oklamán a vrací se s velkou rodinou.",
     ["jakob", "rachel", "lea", "laban"],
     [("ucednici", "Ježíš slibuje Natanaelovi, že uvidí anděly vystupovat "
       "a sestupovat na Syna člověka (J 1,51)")]),
    ("jabok", "patriarchs", "Zápas u Jaboku a smíření", "Gn 32-33",
     "V noci před setkáním s Ezauem zápasí Jákob s Bohem a dostává jméno "
     "Izrael. Ezau mu pak běží naproti a objímá ho.",
     ["jakob", "ezau"],
     [("ztraceni", "Ezau běží bratrovi naproti a objímá ho – stejně jako "
       "otec marnotratného syna")]),
    ("josef-prodan", "patriarchs", "Josef prodán do Egypta", "Gn 37-39",
     "Otcův oblíbenec Josef má sny o budoucnosti. Bratři ho prodají do "
     "otroctví, ale Bůh je s ním i v Egyptě.",
     ["josef", "juda", "jakob", "tamar"],
     [("posledni-vecere", "Josef prodán bratry za stříbrné, Ježíš "
       "zrazen učedníkem za stříbrné")]),
    ("josef-egypt", "patriarchs", "Josef zachraňuje svou rodinu",
     "Gn 41-50",
     "Josef vyloží faraonovy sny a stane se správcem Egypta. Když bratři "
     "přijdou pro obilí, odpustí jim: „Bůh to zamýšlel k dobrému.“",
     ["josef", "juda", "jakob"],
     [("kriz", "Zlo, které Bůh obrací v záchranu mnoha lidí"),
      ("mojzis", "Josefova rodina v Egyptě – odtud o staletí později "
       "začíná vyjití")]),
    ("job", "patriarchs", "Jóbova zkouška", "Jb 1-42",
     "Spravedlivý Jób přijde o všechno. S přáteli zápasí s otázkou "
     "utrpení, až mu Bůh odpoví z bouře.",
     ["job"],
     [("getsemane", "Nevinný trpící, který se v bolesti obrací k Bohu")]),

    # --- Vyjití a poušť ------------------------------------------------------
    ("mojzis", "exodus", "Mojžíš a hořící keř", "Ex 1-4",
     "Izraelité jsou v Egyptě otroky. Zachráněný chlapec Mojžíš vyroste, "
     "uteče do Midjánu a u hořícího keře ho Bůh posílá vyvést svůj lid.",
     ["mojzis", "cipora", "aron", "mirjam"],
     [("narozeni", "Faraon i Herodes vraždí chlapce – a budoucí "
       "zachránce unikne")]),
    ("rany", "exodus", "Rány a Pesach", "Ex 7-12",
     "Faraon odmítá propustit lid. Po deseti ranách přichází noc, kdy "
     "krev beránka na veřejích chrání izraelské domy.",
     ["mojzis", "aron"],
     [("posledni-vecere", "Ježíš slaví Pesach a sám se stává velikonočním "
       "Beránkem"),
      ("beranek", "Zabitý Beránek uprostřed trůnu")]),
    ("more", "exodus", "Přechod Rudého moře", "Ex 13-15",
     "Bůh vede lid v oblakovém a ohnivém sloupu. Moře se rozestoupí, "
     "Izrael projde suchou nohou a Mirjam zpívá Bohu píseň.",
     ["mojzis", "mirjam"],
     [("beranek", "Vítězové v nebi zpívají „píseň Mojžíše a Beránka“ "
       "(Zj 15,3)"),
      ("jericho", "Moře se rozestoupí – a o generaci později i Jordán")]),
    ("mana", "exodus", "Mana a voda ze skály", "Ex 16-18",
     "Na poušti lid reptá, a Bůh přesto dává každé ráno manu a vodu ze "
     "skály. Jetro radí Mojžíšovi, jak se o vedení podělit.",
     ["mojzis", "aron", "jetro"],
     [("nasyceni", "„Já jsem chléb života“ – Ježíš navazuje na manu "
       "z nebe (J 6)")]),
    ("sinaj", "exodus", "Smlouva na Sinaji", "Ex 19-24",
     "U hory Sinaj Bůh uzavírá s Izraelem smlouvu a dává Desatero. Lid "
     "slibuje: „Všechno, co Hospodin mluvil, budeme dělat.“",
     ["mojzis"],
     [("kazani", "Zákon z hory – a Ježíš ho na hoře vykládá"),
      ("letnice", "Oheň a hlas na Sinaji, oheň a Duch o Letnicích"),
      ("jeremjas", "Kamenné desky – a zaslíbená smlouva vepsaná do srdce")]),
    ("tele", "exodus", "Zlaté tele", "Ex 32-34",
     "Zatímco je Mojžíš na hoře, lid si udělá zlaté tele. Mojžíš se "
     "přimlouvá a Bůh se zjevuje jako milosrdný a milostivý.",
     ["mojzis", "aron"],
     [("rozdeleni", "Jarobeám staví dvě zlatá telata se stejnými slovy "
       "(1Kr 12,28)")]),
    ("den-smireni", "exodus", "Svatostánek a Den smíření", "Lv 16",
     "Jednou v roce vstupuje velekněz s krví oběti do svatyně svatých "
     "a kozel odnáší hříchy lidu na poušť.",
     ["aron"],
     [("kriz", "Kristus jako velekněz vstoupil s vlastní krví jednou "
       "provždy (Žd 9)")]),
    ("zvedove", "exodus", "Zvědové a čtyřicet let na poušti", "Nu 13-14",
     "Dvanáct zvědů prozkoumá zemi. Deset se bojí, jen Jozue a Káleb "
     "důvěřují Bohu. Nevěřící generace zůstane na poušti.",
     ["jozue", "kaleb", "mojzis", "aron"],
     [("pokuseni", "Čtyřicet let zkoušky na poušti – a Ježíšových "
       "čtyřicet dní")]),
    ("had", "exodus", "Vzpoury a měděný had", "Nu 16-21",
     "Kórach se bouří proti Mojžíšovi a Áronovi. Když lid uštknou hadi, "
     "zachrání ho pohled na měděného hada na tyči.",
     ["korach", "aron", "mojzis"],
     [("nikodem", "„Jako Mojžíš vyvýšil hada na poušti, tak musí být "
       "vyvýšen Syn člověka“ (J 3,14)")]),
    ("bileam", "exodus", "Bileám a oslice", "Nu 22-25",
     "Moábský král najme Bileáma, aby proklel Izrael. Místo kletby však "
     "musí žehnat a vidí hvězdu, která vzejde z Jákoba.",
     ["bileam", "pinchas"],
     [("narozeni", "Hvězda z Jákoba – mudrci jdou za hvězdou do "
       "Betléma")]),
    ("rozlouceni", "exodus", "Mojžíšovo rozloučení", "Dt 30-34",
     "Na prahu země Mojžíš předkládá lidu volbu mezi životem a smrtí, "
     "pověří Jozua a umírá na hoře Nebó.",
     ["mojzis", "jozue"],
     [("pokuseni", "Ježíš odpovídá pokušiteli slovy Deuteronomia"),
      ("promeneni", "Mojžíš do země nevstoupil – na hoře proměnění stojí "
       "s Ježíšem")]),

    # --- Země a soudci -------------------------------------------------------
    ("rachab", "land", "Rachab a zvědové", "Joz 2",
     "Prostitutka z Jericha ukryje izraelské zvědy, protože uvěřila "
     "v Izraelova Boha. Šarlatová šňůra zachrání její rodinu.",
     ["rachab", "jozue"],
     [("narozeni", "Rachab je v Ježíšově rodokmenu (Mt 1,5)"),
      ("hrdinove-viry", "Rachab mezi hrdiny víry (Žd 11,31)")]),
    ("jericho", "land", "Přes Jordán k Jerichu", "Joz 3-6",
     "Jordán se zastaví a lid vstoupí do země. Hradby Jericha padnou "
     "po sedmi dnech pochodu a troubení.",
     ["jozue"],
     [("krest", "Jordán, kde Izrael vstoupil do země, je místem "
       "Ježíšova křtu")]),
    ("akan", "land", "Akánův hřích", "Joz 7",
     "Po vítězství přijde porážka u Aje. Akán si skrytě ponechal kořist "
     "a jeho hřích dopadá na celý lid.",
     ["achan", "jozue"],
     [("prvni-cirkev", "Skrytá lež na počátku nové etapy – Ananiáš "
       "a Safira")]),
    ("volba", "land", "Dědictví a Jozuova volba", "Joz 14-24",
     "Země se dělí mezi kmeny, Káleb dostává Hebron. Starý Jozue vyzývá: "
     "„Já a můj dům budeme sloužit Hospodinu.“",
     ["kaleb", "jozue"], []),
    ("debora", "land", "Ehúd, Debora a Jáel", "Sd 3-5",
     "Začíná kruh odpadnutí a záchrany. Levák Ehúd osvobodí lid od "
     "Moábců, prorokyně Debora s Bárakem porazí Síseru a Jáel ho zabije.",
     ["ehud", "debora", "barak", "jael"], []),
    ("gedeon", "land", "Gedeón a tři sta mužů", "Sd 6-8",
     "Nejmenší z rodu dostane od anděla jméno „udatný bohatýr“. Bůh "
     "zmenší jeho vojsko, aby bylo jasné, kdo vítězí.",
     ["gedeon"],
     [("pavlovy-listy", "Bůh vybírá slabé, aby se nikdo nechlubil "
       "(1K 1,27)")]),
    ("jefte", "land", "Jefte a jeho slib", "Sd 11",
     "Vyhnaný syn se stane vůdcem a porazí Amónce. Jeho unáhlený slib "
     "ale skončí tragédií.",
     ["jefte"], []),
    ("samson", "land", "Samson a Delila", "Sd 13-16",
     "Nazír s nadlidskou silou žije podle svých tužeb. Delila ho zradí, "
     "ale v poslední modlitbě ho Bůh ještě posílí.",
     ["samson", "delila"], []),
    ("rut", "land", "Rút a Bóaz", "Rt 1-4",
     "Moábka Rút neopustí tchyni Noemi. Na poli potká Bóaze, který se "
     "stane jejich vykupitelem.",
     ["rut", "noemi", "boaz"],
     [("narozeni", "Rút je prababičkou Davida a předkyní Ježíše"),
      ("david-pomazani", "Z Rút a Bóaze pochází král David")]),

    # --- Sjednocené království -----------------------------------------------
    ("samuel", "kingdom", "Chana a malý Samuel", "1S 1-3",
     "Neplodná Chana vyprosí syna a zasvětí ho Bohu. Chlapec Samuel "
     "v noci slyší Boží hlas: „Mluv, tvůj služebník slyší.“",
     ["chana", "samuel", "eli"],
     [("zvestovani", "Chanina píseň a Mariin chvalozpěv – Bůh ponižuje "
       "pyšné a povyšuje ponížené")]),
    ("saul", "kingdom", "Izrael chce krále: Saul", "1S 8-15",
     "Lid chce krále jako ostatní národy. Saul začne dobře, ale "
     "neposlouchá a Samuel mu řekne, že poslušnost je víc než oběť.",
     ["samuel", "saul", "jonatan"], []),
    ("david-pomazani", "kingdom", "Pomazání Davida", "1S 16",
     "Samuel hledá krále mezi Jišajovými syny. Bůh nevybere nejvyššího, "
     "ale nejmladšího pastýře – „Hospodin hledí na srdce.“",
     ["david", "samuel"],
     [("narozeni", "Betlém, Davidovo město, je místem Ježíšova "
       "narození")]),
    ("goliat", "kingdom", "David a Goliáš", "1S 17",
     "Celé vojsko se bojí obra. Pastýř David jde proti němu s prakem "
     "a jménem Hospodina zástupů.",
     ["david", "saul"], []),
    ("david-utek", "kingdom", "David na útěku před Saulem", "1S 18-26",
     "Saul žárlí a pronásleduje Davida. Jonatan zůstane věrným přítelem, "
     "Abigail zabrání krveprolití a David dvakrát ušetří Saulův život.",
     ["david", "jonatan", "saul", "mikal", "abigail"], []),
    ("david-kral", "kingdom", "David králem a slib věčného trůnu",
     "2S 2-7",
     "David se stane králem, dobude Jeruzalém a s radostí tam přinese "
     "truhlu. Bůh mu slibuje dům a trůn navěky.",
     ["david", "mikal", "natan", "abner", "joab"],
     [("zvestovani", "„Bůh mu dá trůn jeho otce Davida“ (L 1,32)"),
      ("vjezd", "„Hosana Synu Davidovu!“")]),
    ("mefiboset", "kingdom", "Laskavost k Mefíbóšetovi", "2S 9",
     "David hledá někoho ze Saulova domu, aby mu prokázal milosrdenství, "
     "a chromého Mefíbóšeta posadí ke svému stolu.",
     ["mefiboset", "david"], []),
    ("batseba", "kingdom", "David a Batšeba", "2S 11-12",
     "Král zhřeší s Batšebou a nechá zabít jejího muže. Prorok Nátan ho "
     "usvědčí příběhem a David činí pokání.",
     ["david", "batseba", "urijas", "natan", "joab"], []),
    ("absalom", "kingdom", "Absalómova vzpoura", "2S 15-18",
     "Davidův syn mu ukradne srdce lidu a vyžene ho z Jeruzaléma. "
     "Vzpoura skončí Absalómovou smrtí a otcovým pláčem.",
     ["absalom", "david", "achitofel", "joab"], []),
    ("zalmy", "kingdom", "Davidovy žalmy", "Ž 22-23",
     "Žalmy jsou modlitby Izraele – nářek i chvála. Žalm 22 začíná "
     "výkřikem opuštěnosti, Žalm 23 vyznává: „Hospodin je můj pastýř.“",
     ["david"],
     [("kriz", "Ježíš se na kříži modlí Žalm 22: „Bože můj, proč jsi mě "
       "opustil?“"),
      ("nasyceni", "Dobrý pastýř, který vede k vodám a sytí")]),
    ("salomoun", "kingdom", "Šalomounova moudrost", "1Kr 1-4",
     "Po zápasu o trůn se Šalomoun stane králem. Místo bohatství prosí "
     "o moudré srdce a Bůh mu dá obojí.",
     ["salomoun", "batseba", "natan"], []),
    ("chram", "kingdom", "Stavba a posvěcení chrámu", "1Kr 6-8",
     "Šalomoun staví v Jeruzalémě chrám. Při jeho posvěcení naplní dům "
     "oblak Boží slávy.",
     ["salomoun"],
     [("kana", "„Zbořte tento chrám…“ – Ježíš mluví o chrámu svého "
       "těla"),
      ("nove-nebe", "V novém Jeruzalémě už chrám není – chrámem je Bůh "
       "sám")]),

    # --- Rozdělené království ------------------------------------------------
    ("rozdeleni", "divided", "Rozdělení říše", "1Kr 12",
     "Rechabeám odmítne ulehčit lidu a deset kmenů se odtrhne. Jarobeám "
     "na severu postaví zlatá telata.",
     ["rechabeam", "jarobeam"], []),
    ("elias", "divided", "Eliáš na Karmelu", "1Kr 17-19",
     "V době sucha Eliáš sytí vdovu ze Sarepty a na Karmelu vyzve "
     "Baalovy proroky. Pak utíká před Jezábel a slyší Boha v tichém "
     "vánku.",
     ["elias", "achab", "jezabel", "vdova-sarepta"],
     [("promeneni", "Eliáš s Mojžíšem mluví s Ježíšem na hoře"),
      ("krest", "Jan Křtitel přichází „v duchu a moci Eliášově“")]),
    ("nabot", "divided", "Nábotova vinice", "1Kr 21",
     "Achab touží po vinici svého souseda. Jezábel zařídí falešný soud "
     "a Nábotovu smrt, Eliáš vynese nad králem rozsudek.",
     ["achab", "jezabel", "elias"], []),
    ("elisa", "divided", "Elíša a Naamán", "2Kr 2-5",
     "Eliáš je vzat do nebe a Elíša dostane jeho plášť. Pomáhá Šúnemce "
     "a syrský velitel Naamán je očištěn v Jordánu.",
     ["elisa", "elias", "naaman", "sunemka"],
     [("krest", "Očištění v Jordánu – Ježíš na Naamána upozorní "
       "v Nazaretu (L 4,27)")]),
    ("jonas", "divided", "Jonáš a Ninive", "Jon 1-4",
     "Prorok utíká před Božím úkolem, skončí v útrobách ryby a nakonec "
     "zvěstuje Ninive. Zlobí se, že Bůh je k nepřátelům milosrdný.",
     ["jonas"],
     [("vzkriseni", "Znamení Jonáše: tři dny a tři noci (Mt 12,40)"),
      ("kornelius", "Boží milosrdenství k cizím národům")]),
    ("ozeas", "divided", "Ozeáš a nevěrná žena", "Oz 1-3",
     "Bůh posílá proroka, aby si vzal nevěrnou ženu. Jeho věrná láska "
     "je obrazem Boží lásky k nevěrnému Izraeli.",
     ["ozeas"],
     [("ztraceni", "Láska, která čeká na návrat nevěrného"),
      ("svatba", "Bůh jako ženich svého lidu – svatba Beránka")]),
    ("amos", "divided", "Ámos a Micheáš: volání po právu", "Am 5",
     "Proroci odsuzují zbožnost bez spravedlnosti: ať se valí právo jako "
     "voda. Micheáš shrne, co Bůh žádá, a ohlašuje vládce z Betléma.",
     ["amos", "micheas"],
     [("narozeni", "„Z tebe, Betléme, vzejde vládce“ (Mi 5,1)")]),
    ("izajas", "divided", "Izajášovo povolání", "Iz 6-9",
     "Ve smutném roce Uzijášovy smrti vidí Izajáš Boha na trůnu. "
     "Ohlašuje znamení Immanuele a dítě, které ponese vládu.",
     ["izajas", "uzijas"],
     [("narozeni", "„Panna počne a porodí syna“ – Immanuel, Bůh s námi"),
      ("beranek", "„Svatý, svatý, svatý“ zní i před trůnem ve Zjevení")]),
    ("kralove-judy", "divided", "Judští králové: Ása, Jóšafat, Uzijáš",
     "2Pa 14-26",
     "Králové Judy střídají důvěru v Boha a pýchu. Jóšafat v nouzi "
     "prosí: „Nevíme, co dělat, ale k tobě upíráme oči.“",
     ["asa", "josafat", "uzijas"], []),
    ("chizkijas", "divided", "Chizkijáš a Asyřané", "2Kr 18-20",
     "Asyrská armáda obléhá Jeruzalém. Chizkijáš rozloží dopis s výhrůžkami "
     "před Hospodinem a Izajáš ohlásí záchranu.",
     ["chizkijas", "izajas"], []),
    ("pad-samari", "divided", "Pád Samaří", "2Kr 17",
     "Severní Izrael neposlouchá proroky. Roku 722 př. Kr. ho dobude "
     "Asýrie a obyvatele odvede do vyhnanství.",
     [], []),
    ("manases", "divided", "Manases a jeho pokání", "2Pa 33",
     "Nejhorší král Judy vede lid k modlám. V asyrském zajetí se pokoří "
     "a Bůh vyslyší i jeho prosbu.",
     ["menases"],
     [("ztraceni", "Ani nejhorší hříšník není pro Boží milost ztracený")]),
    ("josijas", "divided", "Jóšijáš a nalezená kniha Zákona", "2Kr 22-23",
     "Při opravě chrámu se najde kniha Zákona. Mladý král se zděsí, "
     "prorokyně Chulda potvrdí slovo a Jóšijáš obnoví smlouvu.",
     ["josijas", "chulda"],
     [("cteni-zakona", "Znovu nalezené a veřejně čtené Boží slovo")]),
    ("trpici-sluzebnik", "divided", "Trpící Boží služebník", "Iz 52-53",
     "Izajáš popisuje Služebníka, kterým lidé pohrdli. Byl proboden pro "
     "naše nevěrnosti a jeho rány nás uzdravují.",
     ["izajas"],
     [("kriz", "Proroctví o utrpení, které se naplnilo na kříži"),
      ("filip-dvoran", "Etiopský dvořan čte právě Iz 53, když k němu "
       "přijde Filip")]),
    ("abakuk", "divided", "Abakuk: spravedlivý bude žít z víry", "Abk 1-3",
     "Prorok se ptá, proč Bůh mlčí k bezpráví. Odpověď zní: spravedlivý "
     "bude žít z víry – a Abakuk se raduje i bez úrody.",
     ["abakuk"],
     [("pavlovy-listy", "Pavel cituje Abakuka jako jádro evangelia "
       "(Ř 1,17)")]),
    ("jeremjas", "divided", "Jeremjáš a nová smlouva", "Jr 31-39",
     "Jeremjáš ohlašuje novou smlouvu vepsanou do srdce. Král spálí jeho "
     "svitek, prorok skončí v cisterně a Jeruzalém padne.",
     ["jeremjas", "baruch", "ebed-melech"],
     [("posledni-vecere", "„Tento kalich je nová smlouva v mé krvi“")]),
    ("pad-jeruzalema", "divided", "Pád Jeruzaléma", "2Kr 24-25",
     "Nebúkadnesar dobude Jeruzalém, spálí chrám a odvede lid do "
     "Babylona. Zdá se, že je všemu konec.",
     ["nabukadnesar"],
     [("drak", "Babylon se stává obrazem každé pyšné moci, která "
       "nakonec padne")]),

    # --- Babylonské zajetí ---------------------------------------------------
    ("daniel-pec", "exile", "Daniel a ohnivá pec", "Da 1-4",
     "Mladí zajatci zůstanou věrni Bohu na babylonském dvoře. Tři přátelé "
     "odmítnou klanět se soše a v peci je s nimi čtvrtý.",
     ["daniel", "tri-pratele", "nabukadnesar"],
     [("hrdinove-viry", "Ti, kdo „uhasili moc ohně“ (Žd 11,34)")]),
    ("daniel-lvi", "exile", "Daniel v jámě lvové", "Da 6",
     "Daniel se dál třikrát denně modlí, i když je to zakázané. Ráno "
     "vyjde z uzavřené jámy živý.",
     ["daniel"],
     [("vzkriseni", "Kámen přivalený na jámu a ráno – živý")]),
    ("syn-cloveka", "exile", "Vidění Syna člověka", "Da 7",
     "Po čtyřech šelmách přichází na oblacích „jako Syn člověka“ a "
     "dostává od Věkovitého věčnou vládu.",
     ["daniel"],
     [("soud", "Ježíš před veleradou: uvidíte Syna člověka přicházet na "
       "oblacích (Mk 14,62)"),
      ("vize-krista", "Jan vidí „podobného Synu člověka“ (Zj 1,13)")]),
    ("kosti", "exile", "Údolí suchých kostí", "Ez 36-37",
     "Ezechiel vidí údolí plné kostí, které Boží Duch znovu oživí. Bůh "
     "slibuje nové srdce a nového ducha.",
     ["ezechiel"],
     [("letnice", "Duch, který oživuje – sestupuje o Letnicích"),
      ("nikodem", "Narodit se z vody a z Ducha (Ez 36,25-27)")]),
    ("potesta", "exile", "Potěšte můj lid", "Iz 40",
     "Do zajetí zní slova útěchy: připravte Hospodinu cestu na poušti. "
     "Ti, kdo doufají v Hospodina, nabírají novou sílu.",
     ["izajas"],
     [("krest", "„Hlas volajícího na poušti“ – Jan Křtitel")]),

    # --- Návrat a obnova -----------------------------------------------------
    ("navrat", "return", "Návrat a nový chrám", "Ezd 1-6",
     "Perský král Kýros dovolí Židům vrátit se. Zerubábel vede stavbu "
     "chrámu a proroci Ageus a Zachariáš povzbuzují lid.",
     ["kyros", "zerubabel"],
     [("vjezd", "„Tvůj král přichází, pokorný, jede na oslu“ (Za 9,9)")]),
    ("ezdras", "return", "Ezdráš a Zákon", "Ezd 7-10",
     "Písař Ezdráš přichází, aby lid učil Boží Zákon. Lid vyznává své "
     "hříchy a obnovuje věrnost.",
     ["ezdras"], []),
    ("nehemjas", "return", "Nehemjáš staví hradby", "Neh 1-6",
     "Číšník perského krále se modlí za zničený Jeruzalém. Vrátí se, "
     "zorganizuje stavbu a hradby jsou hotové za 52 dní.",
     ["nehemjas"], []),
    ("cteni-zakona", "return", "Čtení Zákona a obnova smlouvy", "Neh 8-9",
     "Lid se shromáždí a Ezdráš čte Zákon od rána do poledne. Lidé pláčou, "
     "ale slyší: „Radost z Hospodina je vaše síla.“",
     ["ezdras", "nehemjas"], []),
    ("ester", "return", "Ester: pro takovou chvíli", "Est 1-10",
     "Židovská dívka se stane perskou královnou. Když Haman chystá "
     "vyvraždění Židů, Ester riskuje život a lid je zachráněn.",
     ["ester", "mordokaj", "haman"],
     [("josef-egypt", "Bůh staví své lidi na místa u cizího dvora, aby "
       "zachránili mnohé")]),
    ("malachias", "return", "Malachiáš: posel před Pánem", "Mal 3",
     "Poslední prorok Starého zákona ohlašuje posla, který připraví cestu, "
     "a příchod proroka Eliáše.",
     [],
     [("krest", "Jan Křtitel je posel, který připravuje cestu"),
      ("elias", "Zaslíbený návrat Eliáše")]),

    # --- Ježíš ---------------------------------------------------------------
    ("zvestovani", "jesus", "Zvěstování", "L 1",
     "Anděl Gabriel ohlašuje Zachariášovi narození Jana a Marii narození "
     "Ježíše. Marie odpovídá: „Staň se mi podle tvého slova.“",
     ["jezis", "marie", "zachariasz", "josef-nt"], []),
    ("narozeni", "jesus", "Narození v Betlémě", "L 2",
     "Ježíš se narodí v Betlémě a leží v jeslích. Andělé zvěstují "
     "pastýřům radost, Simeon a Anna poznávají dítě v chrámu.",
     ["jezis", "marie", "josef-nt", "simeon", "anna", "herodes"], []),
    ("krest", "jesus", "Jan Křtitel a Ježíšův křest", "Mt 3",
     "Jan volá k pokání u Jordánu. Když křtí Ježíše, otevřou se nebesa, "
     "sestoupí Duch a zazní: „Toto je můj milovaný Syn.“",
     ["jezis", "jan-krtitel"], []),
    ("pokuseni", "jesus", "Pokušení na poušti", "Mt 4",
     "Po čtyřiceti dnech postu Ježíše pokouší ďábel. Ježíš odpovídá "
     "slovy Písma a pak začíná kázat.",
     ["jezis"], []),
    ("ucednici", "jesus", "Povolání prvních učedníků", "J 1",
     "Jan ukazuje na Ježíše jako Beránka Božího. První učedníci jdou "
     "za ním a přivádějí další: „Pojď a uvidíš.“",
     ["jezis", "ondrej", "petr", "filip", "natanael", "jan-apostol",
      "jakub-zebedeuv"], []),
    ("kana", "jesus", "Svatba v Káni a očištění chrámu", "J 2",
     "Ježíš promění vodu ve víno – první znamení jeho slávy. V Jeruzalémě "
     "vyžene prodavače z chrámu.",
     ["jezis", "marie"],
     [("svatba", "Ježíšovo první znamení je na svatbě, Bible končí "
       "svatbou Beránka")]),
    ("nikodem", "jesus", "Nikodém a nové narození", "J 3",
     "Farizeus přichází v noci a slyší, že je třeba se narodit znovu. "
     "„Tak Bůh miloval svět, že dal svého jediného Syna.“",
     ["jezis", "nikodem"], []),
    ("samaritanka", "jesus", "Žena u studny", "J 4",
     "Ježíš mluví se Samařankou, se kterou se nikdo nebaví. Nabízí jí "
     "živou vodu a ona přivede celé město.",
     ["jezis", "samaritanka"],
     [("nove-nebe", "Živá voda – řeka vody života v novém Jeruzalémě")]),
    ("kazani", "jesus", "Kázání na hoře", "Mt 5-7",
     "Blahoslavenství, láska k nepřátelům, Otče náš a dům na skále. "
     "Ježíš ukazuje, jak vypadá život v Božím království.",
     ["jezis"], []),
    ("zazraky", "jesus", "Uzdravení a zázraky v Galileji", "Mt 8-9",
     "Ježíš uzdravuje setníkova sluhu na dálku, utiší bouři, povolá "
     "celníka Matouše a vzkřísí Jairovu dceru.",
     ["jezis", "setnik-kafarnaum", "jairos", "matous"],
     [("kornelius", "Víra římského setníka – předzvěst víry pohanů")]),
    ("nasyceni", "jesus", "Nasycení zástupu", "J 6",
     "Z pěti chlebů a dvou ryb nasytí Ježíš tisíce lidí. Pak říká: "
     "„Já jsem chléb života.“",
     ["jezis", "ondrej", "filip", "petr"],
     [("posledni-vecere", "Vzal chléb, vzdal díky, lámal a dával")]),
    ("promeneni", "jesus", "Petrovo vyznání a proměnění", "Mt 16-17",
     "Petr vyzná: „Ty jsi Mesiáš.“ Na hoře se Ježíš promění v záři "
     "a mluví s Mojžíšem a Eliášem.",
     ["jezis", "petr", "jakub-zebedeuv", "jan-apostol"], []),
    ("ztraceni", "jesus", "Podobenství o ztracených", "L 15",
     "Ztracená ovce, ztracená mince a ztracený syn. Bůh je jako otec, "
     "který vybíhá naproti synovi, jenž se vrací.",
     ["jezis"], []),
    ("lazar", "jesus", "Marta, Marie a vzkříšení Lazara", "J 11",
     "Ježíš pláče u hrobu přítele a říká Martě: „Já jsem vzkříšení "
     "i život.“ Pak volá Lazara ven z hrobu.",
     ["jezis", "lazar", "marta", "marie-betanie"],
     [("vzkriseni", "Lazarovo vzkříšení předznamenává Ježíšovo")]),
    ("zacheus", "jesus", "Slepý Bartimaios a Zacheus", "L 18-19",
     "U Jericha volá slepec o smilování a prohlédne. Celník Zacheus vyleze "
     "na strom, Ježíš k němu přijde domů a Zacheus se změní.",
     ["jezis", "bartimaios", "zacheus"], []),
    ("vjezd", "jesus", "Vjezd do Jeruzaléma", "Mt 21",
     "Ježíš vjíždí do města na oslátku a zástupy volají Hosana. "
     "V chrámu převrací stoly směnárníků.",
     ["jezis"], []),
    ("posledni-vecere", "jesus", "Poslední večeře", "J 13",
     "Ježíš myje učedníkům nohy a při velikonoční večeři ohlásí zradu. "
     "Jidáš odchází do noci.",
     ["jezis", "petr", "jidas", "jan-apostol"], []),
    ("getsemane", "jesus", "Getsemane a zatčení", "Mt 26",
     "Večeře Páně, modlitba v zahradě: „Ne má, ale tvá vůle.“ Jidáš "
     "zradí polibkem a učedníci utečou.",
     ["jezis", "jidas", "petr", "jakub-zebedeuv", "jan-apostol"], []),
    ("soud", "jesus", "Soud před Kaifášem a Pilátem", "J 18",
     "Ježíš stojí před veleknězem, Petr ho třikrát zapře. Pilát se ptá, "
     "co je pravda, a propustí Barabáše.",
     ["jezis", "kaifas", "pilat", "herodes-antipas", "barabas", "petr"], []),
    ("kriz", "jesus", "Ukřižování", "J 19",
     "Ježíš nese kříž na Golgotu a umírá se slovy „Dokonáno jest“. "
     "Josef z Arimatie a Nikodém ho pohřbí.",
     ["jezis", "simon-kyrene", "josef-arimatie", "nikodem", "marie",
      "jan-apostol", "pilat"],
     [("beranek", "Zabitý Beránek, který zvítězil")]),
    ("vzkriseni", "jesus", "Vzkříšení", "J 20-21",
     "Hrob je prázdný. Ježíš se ukáže Marii Magdalské, Tomášovi "
     "i učedníkům u moře a ptá se Petra: „Miluješ mě?“",
     ["jezis", "marie-magdalska", "tomas", "petr", "kleofas"],
     [("nove-nebe", "Vzkříšení je začátek nového stvoření")]),

    # --- Církev --------------------------------------------------------------
    ("nanebevstoupeni", "church", "Nanebevstoupení", "Sk 1",
     "Ježíš posílá učedníky být jeho svědky až na konec země a je vzat "
     "do nebe. Místo Jidáše je vybrán Matyáš.",
     ["jezis", "matyas", "petr"],
     [("vzkriseni", "Čtyřicet dní setkání se vzkříšeným")]),
    ("letnice", "church", "Letnice", "Sk 2",
     "Duch svatý sestoupí jako oheň a učedníci mluví jazyky národů. "
     "Po Petrově kázání se pokřtí tři tisíce lidí.",
     ["petr"], []),
    ("prvni-cirkev", "church", "První církev", "Sk 3-5",
     "Petr a Jan uzdraví chromého a odvážně svědčí před veleradou. "
     "Věřící sdílejí majetek – Barnabáš štědře, Ananiáš a Safira lživě.",
     ["petr", "jan-apostol", "barnabas", "ananias-safira"], []),
    ("stepan", "church", "Štěpán, první mučedník", "Sk 6-7",
     "Služebník Štěpán je obviněn a před veleradou vypráví dějiny "
     "Izraele. Umírá s prosbou za ty, kdo ho kamenují; přihlíží Saul.",
     ["stepan", "pavel"],
     [("kriz", "Štěpán umírá jako Ježíš – s odpuštěním na rtech")]),
    ("filip-dvoran", "church", "Filip a etiopský dvořan", "Sk 8",
     "Pronásledovaní věřící nesou zvěst dál. Filip vysvětlí dvořanovi "
     "z Etiopie, o kom mluví Izajáš, a pokřtí ho.",
     ["dvoran"], []),
    ("obraceni", "church", "Obrácení Saula", "Sk 9",
     "Pronásledovatel Saul potká na cestě do Damašku vzkříšeného Ježíše. "
     "Ananiáš mu vrátí zrak a Barnabáš se ho zastane.",
     ["pavel", "ananias-damasek", "barnabas", "tabita"], []),
    ("kornelius", "church", "Petr a Kornélius", "Sk 10-11",
     "Petr ve vidění pochopí, že Bůh nikomu nestraní. Římský setník "
     "Kornélius a jeho dům přijmou Ducha svatého.",
     ["kornelius", "petr"], []),
    ("prvni-cesta", "church", "První misijní cesta", "Sk 13-14",
     "Církev v Antiochii vysílá Barnabáše a Saula. Na Kypru a v Malé Asii "
     "vznikají sbory, Jan Marek se vrátí domů.",
     ["pavel", "barnabas", "jan-marek"], []),
    ("snem", "church", "Sněm v Jeruzalémě", "Sk 15",
     "Musí se pohané obřezat? Apoštolové a starší se shodnou: spása je "
     "z milosti. Pavel se pak s Barnabášem rozejde.",
     ["jakub-bratr", "petr", "pavel", "barnabas", "silas"],
     [("pavlovy-listy", "Svoboda od Zákona – hlavní téma listu "
       "Galatským")]),
    ("druha-cesta", "church", "Filipy, Athény a Korint", "Sk 16-18",
     "Pavel a Silas zpívají ve vězení ve Filipech. Lýdie je první "
     "věřící Evropy, v Korintu Pavel pracuje s Priskou a Akvilou.",
     ["pavel", "silas", "lydie", "timoteus", "priska-akvila", "apollos"],
     []),
    ("pavel-souzen", "church", "Pavel zatčen a souzen", "Sk 21-26",
     "V Jeruzalémě je Pavel zatčen. Před Felixem, Festem i králem "
     "Agrippou vypráví, jak potkal Ježíše.",
     ["pavel", "felix", "festus", "agrippa"],
     [("soud", "Jako jeho Pán stojí Pavel před veleradou i římskými "
       "místodržiteli")]),
    ("rim", "church", "Plavba do Říma", "Sk 27-28",
     "Loď ztroskotá u Malty, ale všichni přežijí. Pavel v Římě káže "
     "„se vší smělostí a bez překážek“.",
     ["pavel", "lukas"], []),
    ("pavlovy-listy", "church", "Pavlovy listy: spaseni milostí", "Ř 1-8",
     "Pavel píše sborům: všichni zhřešili, ale jsou ospravedlněni zadarmo "
     "z milosti skrze víru. Nic nás neodloučí od Boží lásky.",
     ["pavel", "foibe", "priska-akvila", "apollos"], []),
    ("radost-vezeni", "church", "Listy z vězení", "Fp 1-4",
     "Ve vězení Pavel píše o radosti a Kristově pokoře. Filemona prosí, "
     "aby přijal uprchlého otroka Onésima jako bratra.",
     ["epafroditus", "filemon", "onesimus"], []),
    ("listy-spolupracovnikum", "church", "Listy spolupracovníkům",
     "2Tm 1-4",
     "Starý Pavel povzbuzuje Timotea a Tita, aby věrně předávali víru. "
     "„Dobrý boj jsem bojoval, běh jsem dokonal.“",
     ["timoteus", "lois-eunike", "titus", "demas", "jan-marek", "lukas"],
     []),
    ("hrdinove-viry", "church", "Hrdinové víry (Židům)", "Žd 11-12",
     "List Židům ukazuje Krista jako velekněze a vypočítává svědky víry "
     "od Ábela po Rachab. Teď běžíme my – s pohledem na Ježíše.",
     [], []),
    ("obecne-listy", "church", "Listy Jakuba, Petra, Jana a Judy", "Jk 1-5",
     "Víra se má projevit skutky, utrpení nese naději, Bůh je láska. "
     "Apoštolové povzbuzují církev k věrnosti.",
     ["jakub-bratr", "petr", "jan-apostol", "juda-bratr"], []),

    # --- Nové stvoření -------------------------------------------------------
    ("vize-krista", "newcreation", "Vidění Krista a dopisy sborům", "Zj 1-3",
     "Na ostrově Patmos vidí Jan vzkříšeného Krista mezi svícny. Sedmi "
     "sborům posílá povzbuzení i varování.",
     ["jan-apostol"], []),
    ("beranek", "newcreation", "Trůn a Beránek", "Zj 4-5",
     "Nebeská bohoslužba kolem Božího trůnu. Svitek dějin může otevřít "
     "jen Beránek, který byl zabit.",
     [], []),
    ("drak", "newcreation", "Drak, šelma a pád Babylonu", "Zj 12-19",
     "Zlo bojuje proti Božímu lidu, ale svatí vítězí krví Beránka. "
     "Pyšný Babylon padne.",
     [],
     [("babel", "Babylon – od věže v Šineáru po pád velkého města")]),
    ("svatba", "newcreation", "Svatba Beránka", "Zj 19",
     "Nebe jásá: přišla svatba Beránka a jeho nevěsta je připravena. "
     "Jezdec na bílém koni vítězí.",
     [], []),
    ("nove-nebe", "newcreation", "Nové nebe a nová země", "Zj 21-22",
     "Bůh bydlí se svými lidmi a setře každou slzu. Řeka vody života "
     "a strom života – „Hle, všechno činím nové.“",
     [], []),
]
