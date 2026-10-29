"""Slovník pojmů pro hledání podle myšlenky (vlastní data aplikace).

Myšlenka se dá říct mnoha slovy. Každý pojem má:
  * `triggers` – začátky slov, kterými ho může vyjádřit uživatel
    (dnešní čeština, hovorově),
  * `terms` – začátky slov, kterými o něm mluví Bible (kralický i moderní
    překlady); hledají se ve fulltextu jako předpony,
  * `links` – témata (t:), situace (s:) a nitě (h:) aplikace, kde jsou
    k pojmu vybraná klíčová místa.

Vše se porovnává bez diakritiky a velkých písmen.
"""

C = []


def c(id, label, triggers, terms, links=""):
    C.append(dict(id=id, label=label, triggers=triggers.split(),
                  terms=terms.split(), links=links.split()))


# Slova, která samy o sobě myšlenku neurčují (nehledají se doslova).
STOP = """
a i o u v ve k ke s se z ze na do od po za pro pri bez nad pod pred mezi
je jsou byl byla bylo byli jsem jsi jsme jste bude budou by bych bys
být byt mit mít ma má mam mám maji mají ten ta to ty ti tu tak take také
jak kdyz když ze že ale nebo ani jen uz už jeste ještě co kdo kde kam
proc proč protoze protože tento tato toto tyto jeho jeji její jejich
nas nás nam nám vas vás vam vám mne mě me mi mu ho jim je jej sve své
svuj svůj svym svým muj můj moje tvuj tvůj tve tvé nasi naši nase naše
vsak však tedy totiz totiž proto pak tam tady zde vse vše vsechno všechno
vsichni všichni kazdy každý nic nikdo neco něco nekdo někdo jiz již
velmi moc hodne hodně vic víc vice více mene méně jako aby abychom
buh bůh boha bohu bohem boží bozi pan pán pana panu panem hospodin
jezis ježíš jezise ježíše kristus krista kristu clovek člověk lide lidé
lidi rict říct rika říká rekl řekl muze může muzeme můžeme chce chci
máme mame můžu můžeš musí musím musíme dělat dělá jít jde vždy vždycky
nikdy někdy hodně opravdu pravý pravá pravé skutečný jenom jediný
potřebuju potřebuji potřebujeme chceme chtít umí umět najít najde
""".split()

# --- Bůh a jeho vztah k nám ---------------------------------------------------
c("love_god", "Boží láska",
  "láska lásk miluj miluje milov milý drahý přijet přijím zájem",
  "lásk milu milov miloval", "t:love h:bride")
c("faithful", "Boží věrnost a sliby",
  "věrn spolehl spoleh slib zaslíb dodrž nezklam nezrad",
  "věrn věrnost zaslíb slíbil přísah smlouv", "t:faithfulness h:covenant")
c("presence", "Bůh je blízko",
  "blízk blízko přítomn se_mnou s_námi nablízku vedle provází doprovod",
  "blízk s_tebou s_vámi uprostřed přebýv", "h:presence h:name")
c("abandon", "Opuštěnost a samota",
  "opušt opust samot sám sama osaml nenechá nechal zapomn zapomen nikoho",
  "opust opouš zapomen sám= sama= osiř osamě", "s:lonely h:home")
c("care", "Bůh se stará",
  "postar pečuj péče zaopatř potřeb chybí nedostat živob jídlo",
  "pečuj postar chléb nasyt pokrm zaopatř nedostat", "s:anxiety s:money h:bread")
c("protection", "Ochrana a útočiště",
  "chrán ochran bezpeč útoč úkryt schov skrýš štít pevnost zachrání",
  "útočišt štít skál ochran chrán hrad skrýš pevnost", "h:rock")
c("guidance", "Boží vedení",
  "veden vede vedl cesta cestu směr rozhodn nevím_co nevim_co rozcest",
  "vede= vedl veď= vodí vodil cest stezk spravuj ukazuj", "s:decision h:shepherd")
c("shepherd", "Pastýř a ovce",
  "pastýř pastyr ovce ovečk stádo ztracen bloud",
  "pastýř ovc ovec stádo bloud zabloud", "h:shepherd")
c("power", "Boží moc",
  "mocn síl silný všemoh zázrak dokáže zvládne nemožn",
  "moc síl všemoh divy= divů= zázrak nemožn", "t:creator")
c("holy", "Boží svatost",
  "svat svatý čist dokonal vznešen sláva slávu",
  "svat slávu sláv vznešen", "t:holiness")
c("creation", "Stvoření a příroda",
  "stvoř příroda přírod svět vesmír hvězd zvířat strom krása krás",
  "stvoř hvězd zvěř nebesa", "t:creator h:tree")
c("father", "Bůh jako Otec",
  "otec táta tatínek otcov dítě_boží děti_boží adopt",
  "otec otče dítk dědicové= dědici= synovství", "t:image")
c("name", "Kdo je Bůh",
  "kdo_je poznat poznán znát jméno jmén existuje",
  "jméno poznat poznali znáti já_jsem", "s:knowgod h:name")
c("silence", "Když Bůh mlčí",
  "mlčí mlč neodpov neslyší ticho skryt daleko nevidím proč",
  "mlč skrýváš skryješ dokud až_dokud proč daleko", "s:waiting s:doubt")

# --- Ježíš a spása ------------------------------------------------------------
c("jesus", "Kdo je Ježíš",
  "mesiáš syn_boží spasitel vykupitel pán_ježíš",
  "mesiáš kristus syn_boží spasitel slovo", "t:jesus h:king")
c("cross", "Kříž a oběť",
  "kříž kříž ukřiž obět oběť zemřel_za smrt_za krev zástup vykou",
  "kříž ukřiž obět krev beránk vykou", "t:cross h:lamb")
c("resurrection", "Vzkříšení",
  "vzkříš vstal zmrtvých prázdný_hrob velikonoc",
  "vzkříš vstal z_mrtvých", "t:resurrection")
c("salvation", "Záchrana a spasení",
  "spas zachrán záchran vysvobo vykoup zachrání",
  "spas zachrán vysvobo vykoup", "t:grace h:exodus")
c("grace", "Milost a dar",
  "milost dar= daru= darem dárek zdarma nezaslouž zaslouž darem dárek",
  "milost dar= daru= dary= darem zdarma", "t:grace")
c("mercy", "Milosrdenství a soucit",
  "milosrd soucit slitov smilov laskav dobrot něžn",
  "milosrd slitov smilov soucit dobrot", "t:love")
c("forgive", "Odpuštění",
  "odpust odpouš odpuš smíř smír usmíř prominout promin",
  "odpust odpouš odpušt smíř smír", "t:forgiveness s:hurt")
c("sin", "Hřích a vina",
  "hřích hřeš hříš vina viny provin selh selž chyb zlo zlé špatn",
  "hřích hřeš hříš nepravost přestoup vina= viny= vinu= provin", "t:sin s:guilt")
c("guilt", "Vina a stud",
  "vina vinu provin stud styd hanba hanb výčitk svědom",
  "vina= viny= vinu= vinen vinn hanb styd svědom", "s:guilt")
c("repent", "Pokání a obrácení",
  "pokání obrát obrác změn začít_znovu návrat vrátit vrát litov",
  "pokán obrať obrát navrať navrát", "t:repentance s:newstart")
c("newlife", "Nový život a změna",
  "nový_život znovuzroz změn proměn nový_začátek nový_člověk",
  "nov znovu narodit narodil proměn stvoření", "t:newbirth s:newstart")
c("eternal", "Věčný život",
  "věčn nebe nebi ráj posmrt po_smrti",
  "věčn život nebes ráj", "t:newcreation h:tree")
c("lost", "Ztracené a nalezené",
  "ztracen ztratil ztratí ztráta bloud zbloudil",
  "ztrac nalez hledá", "h:shepherd h:home")
c("freedom", "Svoboda",
  "svobod volnost osvobo pouta otrok závisl",
  "svobod osvobo pouta pouty okov otrok otroctv", "h:exodus")

# --- Víra a vztah s Bohem -----------------------------------------------------
c("faith", "Víra a důvěra",
  "víra víru věř důvěř spoléh spoleh odevzd",
  "víra víru vírou věří věřit věřil věřte uvěř doufá spoléh důvěř", "t:faith s:doubt")
c("doubt", "Pochybnosti",
  "pochyb nejist nevěř nevím_jestli otázk",
  "pochyb nevěr malověr proč", "s:doubt")
c("hope", "Naděje",
  "naděj doufá doufat budoucn lepší výhled",
  "naděj doufá očekáv", "s:hope t:return")
c("prayer", "Modlitba",
  "modl modlit prosb prosit volat volám rozhovor_s",
  "modl modlit prosb volá volal vzýva", "t:prayer s:prayer")
c("worship", "Chvála a uctívání",
  "chvál chval uctív oslav zpěv zpív píseň písn hudb",
  "chval chvál zpív píseň písn oslav velebi", "s:gratitude")
c("thanks", "Vděčnost",
  "vděč děkov díky poděk",
  "děkov díků díky chvál", "t:joy s:gratitude")
c("word", "Boží slovo a Písmo",
  "bible písmo písm slovo_boží čtení číst zákon_boží",
  "slovo zákon přikázán písm výpověd", "t:word")
c("spirit", "Duch svatý",
  "duch_svat duch vítr oheň dar_ducha letnic",
  "duch", "t:spirit h:spirit")
c("obey", "Poslušnost",
  "posluš poslech poslouch řídit_se dodržov přikáz",
  "posluš poslouch ostříhá zachová přikázán", "t:word")
c("follow", "Následování a učednictví",
  "následov učedník učednic jít_za kříž_svůj volán povolán",
  "následuj pojď učedník", "t:witness")
c("calling", "Povolání a smysl",
  "povolán smysl poslání úkol účel proč_žiju talent",
  "povolal povolán vyvolil", "s:meaning h:weak")
c("seek", "Hledání Boha",
  "hledat hledá touž touh žízn hlad",
  "hledej hledá žízn touž", "s:knowgod h:water")
c("fasting", "Půst",
  "půst postit postí",
  "postil postí postem postit", "")
c("holiness", "Svatý život a čistota",
  "svatý_život čistot čist nevinn poctiv bezúhon",
  "svat čist bezúhon nevinn", "t:holiness")

# --- Pocity a životní situace -------------------------------------------------
c("fear", "Strach",
  "strach bát bojí bojím obav vyděš děs hrůz panik nervóz",
  "strach neboj nebojte bojí bát= báti= bojím děsí děsit zděs", "s:fear")
c("anxiety", "Starosti a úzkost",
  "staros úzkost stres obav trápí trápen zítř budoucn",
  "staros pečliv úzkost zítř trápen", "s:anxiety")
c("sorrow", "Smutek a pláč",
  "smut smutek pláč brečí brek slz deprese depres žal",
  "smut pláč slz kvíl naříkání zármut", "s:sadness s:grief")
c("grief", "Smrt blízkého a útěcha",
  "smrt zemř umřel pohřeb ztráta truchl vdov sirot",
  "smrt zemř umř mrtv truchl vdov sirot", "s:grief")
c("comfort", "Útěcha a povzbuzení",
  "útěch utěš povzbuz podpoř obejm",
  "utěš potěš těš= útěch", "s:sadness")
c("suffering", "Utrpení a bolest",
  "utrpen trpí trpět bolest bolí těžk zkouš zkoušk krize problém",
  "trpí trpěl soužen utrpen zkouš bolest", "t:suffering")
c("illness", "Nemoc a uzdravení",
  "nemoc nemocn uzdrav lékař nemocnic zdraví",
  "nemoc uzdrav neduh nemocn", "s:illness")
c("weak", "Slabost a síla",
  "slab slabý nemůžu nezvlád selhá unaven vyčerp síl",
  "slab mdl nemoci= síl sílu nezemdl", "s:tired h:weak")
c("tired", "Únava a odpočinek",
  "unav vyčerp odpoč odpočin klid spánek spát vyhořel přetíž",
  "odpoč unav obtíž spánek spí= usnul", "s:tired s:sleep h:rest t:work")
c("peace", "Pokoj",
  "pokoj klid smír harmon vyrovnan",
  "pokoj klid", "t:peace s:peace")
c("joy", "Radost",
  "radost radov štěst šťast veselí",
  "radost raduj radov veselí plesej", "t:joy s:joy")
c("anger", "Hněv",
  "hněv zlost zlob vztek naštv",
  "hněv zlost prchliv", "s:anger")
c("worth", "Hodnota a identita",
  "hodnot bezcenn cenn identit kdo_jsem sebevědom sebehodnot přijetí=",
  "obraz drah cen vzácn vyvolil", "s:worthless t:image")
c("waiting", "Čekání a trpělivost",
  "čekat čeká trpěliv vydrž dlouho kdy_už",
  "čekej očekáv trpěliv", "s:waiting")
c("courage", "Odvaha",
  "odvah odváž stateč nebál neboj síla_do",
  "posilň udatn stateč smělost neboj", "s:courage")
c("temptation", "Pokušení",
  "pokuš pokušen svod závisl slabost_pro",
  "pokuš pokušen svod", "t:temptation s:temptation")
c("success", "Úspěch a požehnání",
  "úspěch daří dař požehn prosper bohat",
  "požehn daří dařit zdar prospěch", "s:success")
c("failure", "Selhání a nový začátek",
  "selh selž nepodař neúspěch prohra zklam pokazil",
  "padl povst zapřel", "s:guilt s:newstart")

# --- Vztahy a společnost ------------------------------------------------------
c("neighbor", "Láska k bližnímu",
  "bližní ostatní druh pomoc pomáh služ laskav",
  "bližní milovati_bližní milovat_bližní", "t:neighbor")
c("enemy", "Nepřátelé",
  "nepřít nepřátel nenávid nesnáší pronásled",
  "nepřít nepřátel nenávid pronásled", "t:neighbor s:hurt")
c("reconcile", "Smíření a konflikt",
  "hádk hádá spor konflikt smíř usmíř rozdělen",
  "smíř svár rozbroj", "t:forgiveness")
c("unity", "Jednota",
  "jednot společ spolu dohromad tým rozdělen",
  "jednomysl jednot tělo= údy= jedno_tělo", "t:church")
c("church", "Církev a společenství",
  "církev sbor společenst komunit bratři sestry shromážd",
  "sbor= sboru církev shromážděn", "t:church")
c("family", "Rodina a děti",
  "rodin rodič dět dítě syn dcer výchov máma otec",
  "matk dcer dítk děti= dětí= rodiče= rodičů", "t:family s:family")
c("marriage", "Manželství a láska",
  "manžel manželk svatb vztah partner láska_mezi",
  "manžel ženich nevěst žena= ženu=", "t:marriage s:love h:bride")
c("friend", "Přátelství",
  "přítel přátel kamarád",
  "přítel přátel", "t:friendship")
c("serve", "Služba druhým",
  "služ sloužit pomáh dobrovol pokor",
  "sloužit slouží služte služb", "t:humility")
c("humble", "Pokora a pýcha",
  "pokor pých pyšn ego chlub namyšl",
  "pokor pých pyšn povyš ponížen", "t:humility")
c("poor", "Chudí a spravedlnost",
  "chud bezdomov potřebn spravedl nespraved křivd utlač",
  "chud nuzn spravedl utisk křivd sirot vdov", "t:justice s:injustice")
c("money", "Peníze a majetek",
  "peníz penez majet bohat dluh chamtiv štědr dávat",
  "peněz stříbr zlat bohat lakom poklad", "t:money s:money")
c("generous", "Štědrost a dávání",
  "štědr dávat dáv rozdáv sdíl",
  "dávej dávat štědr rozdá", "t:money")
c("work", "Práce",
  "prác prace zaměstn kariér šéf",
  "prác dílo pracuj", "t:work s:work")
c("words", "Slova a jazyk",
  "slova jazyk mluv pomluv lež lhát kritiz",
  "jazyk rty= rtů= pomluv utrh klevet", "")
c("truth", "Pravda a lež",
  "pravd lež lhát lže upřímn poctiv",
  "pravd lež= lži= lživ lhář", "t:word")
c("wisdom", "Moudrost",
  "moudr rozum chytr poradit rada=",
  "moudr rozum rada= rady= radu=", "s:decision")
c("judge", "Neodsuzovat druhé",
  "odsuzov soudit kritiz pokrytec",
  "nesuďte soudit pokrytec", "t:judgment")
c("authority", "Stát a autority",
  "stát vlád politik vrchnost zákon autorit",
  "vrchnost vládc císař", "t:authority")
c("stranger", "Cizinci a pohostinnost",
  "cizin uprchl host pohost přijmout",
  "cizin host", "h:nations")
c("witness", "Svědectví a misie",
  "svědect misi evangel zvěstov říct_druhým sdílet_víru",
  "svědk svědect zvěstuj evangel kázat", "t:witness h:nations")

# --- Obrazy a velká témata -------------------------------------------------
c("light", "Světlo a tma",
  "světl tma tmě temn",
  "světl tm temnot", "h:light")
c("water", "Voda a žízeň",
  "voda vod žízn pramen řek",
  "vod žízn pramen řeka řeky řece studnic", "h:water")
c("bread", "Chléb a hostina",
  "chléb chleb hlad jídl hostin stůl",
  "chléb chleb hlad pokrm hostin", "h:bread t:supper")
c("fruit", "Ovoce a růst",
  "ovoc plod růst rost zral vinic",
  "ovoc plod vinic ratolest", "h:vine")
c("rock", "Skála a pevný základ",
  "skál základ pevn kámen jistot",
  "skál základ kámen", "h:rock")
c("kingdom", "Boží království",
  "králov vlád král",
  "královstv", "h:king")
c("victory", "Vítězství nad zlem",
  "vítěz zlo ďábel satan démon boj",
  "vítěz satan ďábel zlý přemoh", "h:victory")
c("judgment", "Soud a spravedlnost Boží",
  "soud odsouz trest spravedliv",
  "soud trest", "t:judgment")
c("return", "Ježíšův návrat",
  "návrat_ježíše druhý_příchod přijde konec_světa apokalyps",
  "příchod přijde den_páně", "t:return")
c("time", "Čas a pomíjivost",
  "čas pomíj krátk stáří mládí život_je",
  "čas pomíj tráva stín= dnové", "")
c("heart", "Srdce a nitro",
  "srdc nitro myšlen motiv uvnitř",
  "srdc mysl", "")
c("blessing", "Požehnání",
  "požehn",
  "požehn", "s:success h:nations")
c("baptism", "Křest",
  "křest křtí pokřt",
  "křest křtí pokřt", "t:baptism")
c("supper", "Večeře Páně",
  "večeř přijímán eucharist",
  "večeře= večeři= kalich lámal", "t:supper")
c("sabbath", "Odpočinutí a sobota",
  "sobot neděl odpočinut volno",
  "sobot odpočin", "h:rest t:work")
