"""Velké otázky pro hledání podle myšlenky (vlastní texty aplikace).

Lidé se často neptají na verš, ale obecně: „Jak se správně modlit?“,
„Proč je na světě zlo?“, „Jak vznikl vesmír?“. Každá otázka má slova,
kterými ji lidé vyjadřují, a cíle v aplikaci, kde je odpověď vysvětlená:
  t:<id>        biblické téma
  s:<id>        verše do situace
  l:<kurz>:<n>  lekce kurzu (číslováno od 0)
  c:<kurz>      celý kurz
"""

QUESTIONS = [
    # --- Bůh ----------------------------------------------------------------
    ("Existuje Bůh?",
     "existuje bůh je bůh skutečný důkaz boží existence věřit ateista "
     "jak vím že bůh je",
     "t:creator t:doubt s:knowgod"),
    ("Jaký je Bůh?",
     "jaký je bůh kdo je bůh boží vlastnosti charakter boží povaha",
     "t:names t:love t:holiness s:knowgod"),
    ("Co je Trojice?",
     "trojice svatá trojice otec syn duch tři osoby jeden bůh",
     "t:trinity t:spirit"),
    ("Miluje mě Bůh?",
     "miluje mě bůh záleží bohu na mně boží láska ke mně",
     "t:love t:adoption s:worthless"),
    ("Proč Bůh mlčí?",
     "proč bůh mlčí neodpovídá neslyší cítím se daleko od boha",
     "t:prayer t:doubt t:presence"),
    ("Jak poznat Boha?",
     "jak poznat boha najít boha vztah s bohem začít s bohem přiblížit",
     "s:knowgod t:presence t:prayer"),
    ("Kdo řídí dějiny?",
     "řídí svět dějiny osud náhoda boží plán prozřetelnost má bůh kontrolu",
     "t:providence t:kingdom"),

    # --- Svět a zlo ---------------------------------------------------------
    ("Jak vznikl svět a vesmír?",
     "jak vznikl vesmír svět země život stvoření počátek velký třesk "
     "evoluce věda šest dní",
     "t:creator l:howto:1 t:image"),
    ("Proč je na světě zlo?",
     "proč je zlo na světě odkud se vzalo zlo proč bůh dopouští zlo "
     "zlí lidé válka holocaust",
     "t:suffering t:sin t:evil"),
    ("Proč Bůh dopouští utrpení?",
     "proč bůh dopouští utrpení bolest nemoc nespravedlnost trpí nevinní "
     "děti proč zrovna já",
     "t:suffering s:injustice s:illness"),
    ("Existuje ďábel?",
     "existuje ďábel satan démoni zlí duchové posedlost",
     "t:evil t:warfare t:angels"),
    ("Existují andělé?",
     "existují andělé strážný anděl jak vypadají andělé",
     "t:angels"),
    ("Jak se starat o přírodu?",
     "příroda ekologie planeta zvířata péče o zemi klima",
     "t:creation_care t:creator"),

    # --- Ježíš --------------------------------------------------------------
    ("Kdo byl Ježíš?",
     "kdo byl ježíš skutečně žil historický ježíš byl ježíš bůh mesiáš "
     "syn boží",
     "t:jesus t:titles t:incarnation"),
    ("Proč Ježíš musel zemřít?",
     "proč ježíš zemřel musel zemřít na kříži proč kříž smysl smrti "
     "za naše hříchy",
     "t:cross t:sacrifice t:redemption"),
    ("Opravdu Ježíš vstal z mrtvých?",
     "vstal z mrtvých vzkříšení opravdu důkaz prázdný hrob velikonoce",
     "t:resurrection"),
    ("Proč Ježíš mluvil v podobenstvích?",
     "proč podobenství příběhy jak rozumět podobenstvím",
     "l:parables:0 t:parables"),
    ("Dělal Ježíš opravdu zázraky?",
     "zázraky opravdu dějí dnes ježíšovy zázraky uzdravení",
     "t:miracles"),
    ("Kdy se Ježíš vrátí?",
     "kdy přijde konec světa druhý příchod návrat ježíše apokalypsa "
     "poslední dny",
     "t:return t:judgment t:newcreation"),

    # --- Spása a víra ------------------------------------------------------
    ("Jak se stát křesťanem?",
     "jak se stát křesťanem uvěřit obrátit začít věřit přijmout ježíše "
     "být spasen",
     "t:faith t:repentance t:newbirth s:knowgod"),
    ("Co je hřích?",
     "co je hřích hřešit co je špatně co bůh zakazuje",
     "t:sin t:law"),
    ("Jak odpustit, když to bolí?",
     "jak odpustit někomu kdo mi ublížil nedokážu odpustit křivda bolí",
     "t:forgiveness s:hurt t:reconciliation"),
    ("Odpustí mi Bůh?",
     "odpustí mi bůh i tohle velký hřích nemůže mi odpustit jsem moc "
     "špatný",
     "t:forgiveness t:grace s:guilt"),
    ("Co je milost?",
     "co je milost spasení z milosti zasloužit si nebe skutky",
     "t:grace t:justification"),
    ("Co je víra?",
     "co je víra jak věřit jak mít víru víra a rozum",
     "t:faith t:doubt"),
    ("Co když pochybuji?",
     "pochybuji pochybnosti nevím jestli věřím ztrácím víru otázky",
     "t:doubt s:doubt"),
    ("Co je křest?",
     "co je křest proč se nechat pokřtít křtiny dětí",
     "t:baptism"),
    ("Co je večeře Páně?",
     "večeře páně přijímání eucharistie mše chléb a víno",
     "t:supper"),
    ("Jak se změnit a růst?",
     "jak se změnit být lepší člověk růst ve víře duchovní růst "
     "posvěcení zlozvyky",
     "t:growth t:newbirth s:newstart"),

    # --- Smrt a věčnost -----------------------------------------------------
    ("Co bude po smrti?",
     "co bude po smrti život po smrti kam jdeme když umřeme duše nebe",
     "t:heaven t:newcreation t:resurrection t:death"),
    ("Existuje peklo?",
     "existuje peklo zatracení věčný trest očistec",
     "t:judgment t:heaven"),
    ("Jak se vyrovnat se smrtí blízkého?",
     "smrt blízkého truchlení pohřeb zemřel mi smutek po ztrátě",
     "s:grief t:death"),
    ("Jak vypadá nebe?",
     "jak vypadá nebe co budeme dělat v nebi uvidíme se tam",
     "t:heaven t:newcreation"),

    # --- Modlitba a duchovní život -----------------------------------------
    ("Jak se správně modlit?",
     "jak se modlit správně modlitba naučit modlit co říkat bohu "
     "jak mluvit s bohem otče náš",
     "t:prayer s:prayer"),
    ("Proč Bůh neodpovídá na modlitby?",
     "proč bůh neodpovídá nevyslyšená modlitba modlím se a nic",
     "t:prayer t:patience s:waiting"),
    ("Jak číst Bibli?",
     "jak číst bibli kde začít čtení bible rozumět bibli studovat",
     "c:howto t:word"),
    ("Kdo napsal Bibli?",
     "kdo napsal bibli jak vznikla bible autoři kdy vznikla",
     "c:origin l:howto:0"),
    ("Je Bible pravdivá?",
     "je bible pravdivá spolehlivá změněná opisy přepisovaná dá se věřit "
     "bibli",
     "l:origin:2 l:origin:3 t:word"),
    ("Proč je v Bibli tolik knih?",
     "proč tolik knih kánon apokryfy které knihy patří",
     "l:origin:4 l:howto:0"),
    ("Jaký překlad Bible číst?",
     "překlad bible jaký vybrat kralická původní jazyk hebrejština řečtina",
     "l:howto:4 l:origin:5"),
    ("Jak poznat Boží vůli?",
     "boží vůle jak poznat co chce bůh rozhodnutí jak se rozhodnout "
     "vedení",
     "t:guidance s:decision"),
    ("Co je půst?",
     "co je půst postit se ztišení samota rozjímání",
     "t:silence"),
    ("Jak chválit Boha?",
     "chvála uctívání zpěv písně bohoslužba",
     "t:worship t:joy"),

    # --- Život ---------------------------------------------------------------
    ("Co dělat, když nevím jak dál?",
     "nevím jak dál co dělat nevím co mám dělat ztracený bezradný "
     "rozcestí",
     "s:decision t:guidance s:hope"),
    ("Jaký má život smysl?",
     "smysl života proč žiju k čemu jsem na světě poslání účel",
     "s:meaning t:image t:kingdom"),
    ("Jak se usmířit po hádce?",
     "usmířit hádka konflikt pohádal spor smíření omluvit",
     "t:reconciliation t:anger"),
    ("Jak zvládat hněv?",
     "hněv vztek zlost zvládat ovládat vybuchnu",
     "t:anger s:anger"),
    ("Jak se zbavit strachu?",
     "strach zbavit strachu bojím úzkost panika odvaha",
     "t:fear s:fear t:worry"),
    ("Jak přestat mít starosti?",
     "starosti trápení stres úzkost přemýšlím pořád",
     "t:worry s:anxiety"),
    ("Jak bojovat s pokušením?",
     "pokušení odolat závislost zlozvyk pornografie nemůžu přestat",
     "t:temptation s:temptation"),
    ("Co Bible říká o penězích?",
     "peníze bohatství chudoba dluhy štědrost desátky",
     "t:money s:money t:contentment"),
    ("Co Bible říká o práci?",
     "práce zaměstnání kariéra odpočinek pracovat",
     "t:work s:work"),
    ("Co Bible říká o manželství?",
     "manželství svatba manžel manželka vztah láska partner sex",
     "t:marriage s:love"),
    ("Co Bible říká o rozvodu?",
     "rozvod rozchod rozpad manželství znovu oženit",
     "t:marriage s:hurt"),
    ("Jak vychovávat děti?",
     "výchova dětí rodičovství rodiče děti rodina",
     "t:family t:children s:family"),
    ("Jak být dobrý přítel?",
     "přátelství kamarád přítel jak najít přátele",
     "t:friendship s:lonely"),
    ("Kdo je můj bližní?",
     "bližní láska k bližnímu pomáhat druhým cizí lidé",
     "t:neighbor l:parables:3 t:service"),
    ("Jak se chovat k nepřátelům?",
     "nepřátelé ublížil nenávidí mě pomsta milovat nepřátele",
     "t:neighbor t:forgiveness s:hurt"),
    ("Co Bible říká o politice a státu?",
     "stát politika vláda volby daně zákon poslušnost autority",
     "t:authority t:justice"),
    ("Co Bible říká o chudých?",
     "chudí spravedlnost bezdomovci pomoc chudým sociální",
     "t:justice t:service"),
    ("Proč chodit do církve?",
     "proč chodit do kostela církev sbor společenství farnost věřit sám",
     "t:church t:fellowship"),
    ("Jak mluvit o víře s druhými?",
     "mluvit o víře evangelizace svědectví misie sdílet víru",
     "t:witness"),
    ("Jak najít pokoj?",
     "pokoj klid vnitřní mír neklid",
     "t:peace s:peace"),
    ("Jak být šťastný?",
     "štěstí šťastný radost spokojenost",
     "t:joy t:contentment s:joy"),
    ("Jak zvládat čekání?",
     "čekání trpělivost dlouho nic se neděje",
     "t:patience s:waiting"),
    ("Jak přijmout sám sebe?",
     "přijmout sám sebe sebevědomí cítím se bezcenný hodnota identita "
     "kdo jsem",
     "s:worthless t:image t:adoption"),
    ("Co dělat v osamělosti?",
     "osamělost samota jsem sám nikoho nemám",
     "s:lonely t:presence"),
    ("Jak stárnout dobře?",
     "stáří stárnutí senioři generace",
     "t:age"),

    # --- Svět Bible ---------------------------------------------------------
    ("Jak se žilo v době Bible?",
     "jak se žilo bydlení jídlo každodenní život doba ježíše",
     "c:world"),
    ("Jaké svátky slavil Izrael?",
     "svátky izraele židovské svátky pesach sabat jom kipur stánky",
     "c:feasts"),
    ("Kdo byli proroci?",
     "kdo byli proroci prorok proroctví co dělali",
     "c:prophets"),
    ("Kdo byl apoštol Pavel?",
     "apoštol pavel saul z tarsu pavlovy cesty dopisy",
     "c:paul"),
]

# Otázky s vlastním krátkým výkladem (kde k nim aplikace jinak text nemá).
# Čtvrtá položka: odstavce výkladu a místa [(odkaz, popisek)].
QUESTIONS += [
    ("Kdo je Duch svatý?",
     "duch svatý kdo je duch co dělá duch svatý utěšitel přímluvce",
     "t:spirit t:trinity"),
    ("Co je Desatero?",
     "desatero deset přikázání desky zákona sinaj",
     "t:law"),
    ("Co slavíme o Velikonocích?",
     "velikonoce velký pátek proč slavíme velikonoce zmrtvýchvstání beránek",
     "t:resurrection t:cross l:feasts:1"),
    ("Co slavíme o Vánocích?",
     "vánoce proč slavíme vánoce narození ježíše betlém vtělení",
     "t:incarnation"),
    ("Proč se křtí děti a jak je to s křtem?",
     "křtí děti křest dětí pokřtít miminko křtiny znovu pokřtít",
     "t:baptism"),
    ("Která církev je ta pravá?",
     "pravá církev která církev katolická evangelická pravoslavná sbory "
     "rozdělení křesťanů",
     "t:church t:unity"),
    ("Dějí se zázraky i dnes?",
     "zázraky dnes dějí se uzdravení dnes opravdu existují zázraky",
     "t:miracles s:illness"),
    ("Smí křesťan pít alkohol?",
     "alkohol pít víno pivo opíjet opilost smí křesťan pít",
     "s:temptation",
     dict(text=[
         "Bible víno nezakazuje: Ježíš proměnil vodu ve víno na svatbě "
         "a víno patří k Večeři Páně. Žalm 104 mluví o víně, které "
         "„obveseluje srdce člověka“.",
         "Zároveň opakovaně varuje před opilstvím. Pavel píše: „Neopíjejte "
         "se vínem, to vede k nevázanosti, ale buďte plni Ducha.“ Kniha "
         "Přísloví popisuje, jak alkohol klame a bere sílu.",
         "Bible také žádá ohleduplnost: nepít tam, kde by to druhému "
         "uškodilo nebo ho svedlo. Kdo se pití nedokáže ovládat, pro toho "
         "je moudré nepít vůbec a hledat pomoc.",
     ], read=[("J 2,9", "Voda proměněná ve víno"),
              ("Ž 104,15", "Víno obveseluje srdce"),
              ("Ef 5,18", "Neopíjejte se, buďte plni Ducha"),
              ("Př 20,1", "Víno klame"),
              ("Ř 14,21", "Ohled na slabšího bratra")])),
    ("Je sex před svatbou hřích?",
     "sex před svatbou předmanželský sex spát spolu s přítelem přítelkyní "
     "čistota sexualita",
     "t:marriage",
     dict(text=[
         "Bible vidí sexualitu jako dobrý Boží dar, který patří do "
         "manželství – do smlouvy, ve které se muž a žena dávají jeden "
         "druhému celým životem a stávají se „jedním tělem“.",
         "Proto Nový zákon vyzývá k čistotě a varuje před smilstvem, tedy "
         "sexem mimo manželství. Pavel připomíná, že tělo není bezcenné: "
         "„Vaše tělo je chrámem Ducha svatého.“",
         "Kdo v tomhle selhal, není odepsaný. Bible nabízí odpuštění "
         "a nový začátek – Ježíš ženě přistižené při cizoložství řekl: "
         "„Ani já tě neodsuzuji. Jdi a už nehřeš.“",
     ], read=[("Gn 2,24", "Budou jedním tělem"),
              ("1K 6,18", "Utíkejte před smilstvem"),
              ("1K 6,19", "Tělo je chrámem Ducha"),
              ("1Te 4,3", "Boží vůle je vaše posvěcení"),
              ("J 8,11", "Ani já tě neodsuzuji")])),
    ("Smím se rozvést?",
     "rozvést rozvod rozvedení rozvedený manželství se rozpadá chci "
     "odejít od manžela manželky",
     "t:marriage s:love",
     dict(text=[
         "Bible bere manželství jako celoživotní smlouvu. Ježíš na otázku "
         "o rozvodu odpovídá: „Co Bůh spojil, člověk nerozlučuj.“ Rozvod "
         "vidí jako ránu, ne jako běžné řešení.",
         "Zároveň Bible počítá s tím, že svět je porušený. Ježíš zmiňuje "
         "nevěru a Pavel opuštění nevěřícím partnerem; křesťanské "
         "církve tyto výjimky vykládají různě.",
         "Kdo je v násilném nebo nebezpečném vztahu, má právo být "
         "v bezpečí. Při krizi v manželství pomáhá mluvit s někým "
         "moudrým – s duchovním nebo s manželskou poradnou.",
     ], read=[("Mt 19,6", "Co Bůh spojil"),
              ("Mt 19,9", "Ježíš o rozvodu"),
              ("1K 7,15", "Když nevěřící odchází"),
              ("Mal 2,16", "Nenávidím zapuzení"),
              ("Ž 34,19", "Hospodin je blízko zkroušeným")])),
    ("Co dělat, když mě šikanují?",
     "šikana šikanují posmívají smějí se mi ve škole v práci ubližují "
     "ponižují bijí",
     "s:hurt s:worthless",
     dict(text=[
         "Šikana není něco, co musíte potichu snášet. Bible stojí na "
         "straně slabých a utlačovaných a Bůh slyší jejich volání.",
         "Svěřte se někomu, komu důvěřujete – rodičům, učiteli, vedoucímu "
         "nebo kamarádovi. Děti a mladí mohou zavolat na Linku bezpečí "
         "116 111 (zdarma, nonstop).",
         "Vaše hodnota nezávisí na tom, co o vás říkají druzí: Bůh vás "
         "stvořil a miluje. Ježíš sám zažil posměch a ponížení – rozumí "
         "tomu, čím procházíte.",
     ], read=[("Ž 34,19", "Hospodin je blízko zkroušeným"),
              ("Ž 10,17", "Bůh slyší ponížené"),
              ("Iz 43,4", "Jsi v mých očích vzácný"),
              ("Žd 4,15", "Ježíš s námi soucítí"),
              ("Ř 12,21", "Nedej se přemoci zlem")])),
    ("Co když už nechci žít?",
     "nechci být naživu chci umřít sebevražda zabít se skončit se "
     "vším konec života",
     "s:hope s:worthless",
     dict(text=[
         "Jestli teď myslíte na to, že nechcete žít, nejste v tom sami "
         "a nemusíte to nést sami. Prosím, řekněte to ještě dnes někomu "
         "blízkému nebo zavolejte na Linku první psychické pomoci 116 123 "
         "(zdarma, nonstop). Děti a mladí mohou volat Linku bezpečí "
         "116 111. V ohrožení života volejte 155 nebo 112.",
         "I lidé v Bibli prošli tak hlubokou tmou, že si přáli zemřít – "
         "prorok Eliáš i Jób. Bůh je za to neodsoudil: Eliášovi dal "
         "nejdřív jídlo a spánek a pak k němu tiše promluvil.",
         "Vaše bolest je skutečná a váš život má cenu. Bůh je blízko "
         "těm, kdo mají zlomené srdce.",
     ], read=[("1Kr 19,4", "Eliáš si přeje zemřít"),
              ("1Kr 19,7", "Vstaň a jez, cesta je daleká"),
              ("Ž 34,19", "Hospodin je blízko zkroušeným"),
              ("Mt 11,28", "Pojďte ke mně, unavení"),
              ("Iz 42,3", "Nalomenou třtinu nedolomí")])),
    ("Je lež někdy v pořádku?",
     "lež lhát zalhat milosrdná lež pravda poctivost",
     "t:truth t:speech"),
    ("Co Bible říká o nadávání a sprostých slovech?",
     "nadávat sprostá slova mluva klení vulgární jazyk",
     "t:speech"),
    ("Co Bible říká o závislosti?",
     "závislost závislý drogy hry mobil pornografie nemůžu přestat",
     "t:temptation s:temptation t:redemption"),
    ("Jak se vyrovnat s nemocí?",
     "nemoc nemocný rakovina diagnóza nemocnice uzdravení zdraví",
     "s:illness t:suffering"),
    ("Jak se vypořádat se závistí?",
     "závist závidím žárlivost srovnávání druzí mají víc",
     "t:contentment t:joy"),
    ("Jak zvládat stres a vyhoření?",
     "stres vyhoření přepracovaný nestíhám únava nezvládám",
     "s:tired t:work t:worry"),
    ("Proč mám věřit zrovna Bibli?",
     "proč věřit bibli jiná náboženství proč křesťanství která víra je "
     "pravá",
     "t:jesus t:resurrection t:doubt"),
    ("Kdo jsou andělé strážní?",
     "anděl strážný strážní andělé ochrana",
     "t:angels"),
    ("Co je pokání?",
     "pokání obrátit se litovat změnit smýšlení",
     "t:repentance"),
    ("Co je Boží království?",
     "boží království království nebeské co je království",
     "t:kingdom"),
    ("Co je spása?",
     "spása spasení spasen zachránit záchrana",
     "t:grace t:faith t:redemption"),
    ("Jak žít podle Bible?",
     "jak žít podle bible dobrý život křesťanský život jak se chovat "
     "správně žít",
     "t:neighbor t:growth s:meaning"),
    ("Proč umírají nevinní a děti?",
     "proč umírají děti nevinní smrt dítěte nespravedlivá smrt",
     "t:suffering t:death s:grief"),
    ("Proč Bůh poslal potopu?",
     "proč potopa poslal potopu noe zničil svět archa",
     "t:judgment t:covenant",
     dict(text=[
         "Bible vypráví, že země byla plná násilí a zkaženosti a Bohu "
         "bylo „líto, že učinil člověka“. Potopa je v Bibli soud nad zlem, "
         "které ničilo celé stvoření.",
         "Zároveň je to příběh záchrany: Bůh zachránil Noeho, jeho rodinu "
         "a zvířata a po potopě uzavřel smlouvu, že už nikdy nezničí zemi "
         "potopou. Znamením je duha.",
         "Nový zákon vidí v potopě obraz křtu – vodou prochází soud "
         "i záchrana (1Pt 3,20-21).",
     ], read=[("Gn 6,11", "Země byla plná násilí"),
              ("Gn 6,6", "Bohu bylo líto"),
              ("Gn 9,11", "Už nikdy potopa"),
              ("Gn 9,13", "Duha jako znamení"),
              ("1Pt 3,20", "Potopa a křest")])),
]
