"""Červené nitě Bible: motivy, které se táhnou celou Biblí
(vlastní texty aplikace).

Každá nit je řada zastavení (odkaz, nadpis, proč sem patří). Odkazy
v kanonickém (hebrejském) číslování.
"""

# id, barva (ARGB), ikona, název, úvod, [(odkaz, nadpis, text)]
THREADS = [
    ("lamb", 0xFFC0503A, "lamb", "Beránek",
     "Od Abrahamovy otázky „kde je beránek?“ až k Beránkovi na trůnu. "
     "Obraz oběti, která zachraňuje, provází celou Bibli.",
     [
         ("Gn 22,7-8", "Bůh si vyhlédne beránka",
          "Izák se ptá, kde je beránek k oběti. Abraham odpovídá vírou: "
          "Bůh se postará. Otázka zůstává otevřená na celé dějiny."),
         ("Ex 12,13", "Krev na veřejích",
          "V noci vyjití z Egypta chrání krev beránka izraelské domy. "
          "Pesach se stává každoroční památkou vysvobození."),
         ("Iz 53,7", "Jako beránek na porážku",
          "Prorok popisuje Služebníka, který mlčky trpí za vinu druhých. "
          "Obětí tu už není zvíře, ale člověk."),
         ("J 1,29", "Hle, Beránek Boží",
          "Jan Křtitel ukazuje na Ježíše: on je odpovědí na Izákovu "
          "otázku – beránek, který snímá hřích světa."),
         ("1K 5,7", "Náš velikonoční beránek",
          "Pavel čte Ježíšovu smrt jako nový Pesach. Ježíš zemřel právě "
          "v době velikonočních svátků."),
         ("1Pt 1,18-19", "Drahá krev beránka bez vady",
          "Petr připomíná, že vykoupení nestálo stříbro ani zlato, ale "
          "Kristovu krev – jako krev beránka bez vady."),
         ("Zj 5,12", "Hoden je Beránek",
          "Na konci Bible stojí uprostřed trůnu zabitý, ale živý Beránek. "
          "Oběť se ukazuje jako vítězství."),
     ]),
    ("presence", 0xFFD1A23A, "temple", "Bůh uprostřed lidí",
     "Příběh o tom, jak Bůh hledá místo, kde by mohl bydlet se svým lidem "
     "– od zahrady přes stan a chrám až k novému městu.",
     [
         ("Gn 3,8", "Bůh v zahradě",
          "Bůh se prochází zahradou blízko lidí. Hřích tuto blízkost "
          "přetrhne a člověk se schovává."),
         ("Ex 25,8", "Udělají mi svatyni",
          "Na poušti Bůh dává pokyny ke stavbě stánku, „abych přebýval "
          "uprostřed nich“. Bůh putuje se svým lidem."),
         ("Ex 40,34", "Sláva naplnila příbytek",
          "Když je stánek hotový, přikryje ho oblak a Hospodinova sláva "
          "naplní příbytek."),
         ("1Kr 8,10-11", "Oblak v Šalomounově chrámu",
          "Při posvěcení chrámu se opakuje totéž: oblak naplní dům "
          "Hospodinův. Jeruzalém se stává středem víry."),
         ("Ez 10,18", "Sláva odchází",
          "Před babylonským zajetím vidí Ezechiel, jak Boží sláva opouští "
          "chrám. Chrám je pak zničen."),
         ("J 1,14", "Slovo přebývalo mezi námi",
          "Řecké slovo znamená doslova „rozbilo stan“. V Ježíši je Bůh "
          "přítomen v lidském těle – nový stánek setkání."),
         ("1K 3,16", "Vy jste Boží chrám",
          "Po Letnicích přebývá Boží Duch v lidech. Chrámem je společenství "
          "těch, kdo patří Kristu."),
         ("Zj 21,3", "Boží stánek s lidmi",
          "Na konci se plní to, co začalo v zahradě: Bůh bydlí se svým "
          "lidem natrvalo a bez překážek."),
     ]),
    ("king", 0xFF5D6FB0, "crown", "Král z Davidova rodu",
     "Bůh slíbil Davidovi věčného krále. Když královské dynastie padly, "
     "Izrael čekal na Mesiáše – pomazaného krále.",
     [
         ("Gn 49,10", "Žezlo od Judy",
          "Jákob požehná synům a Judovi slibuje královskou vládu. "
          "Z Judova kmene pak pochází David."),
         ("2S 7,12-13", "Zaslíbení Davidovi",
          "Prorok Nátan přináší Davidovi slib: jeho potomek bude vládnout "
          "a jeho trůn bude pevný navěky."),
         ("Ž 2,6-7", "Ty jsi můj syn",
          "Žalm o králi na Sijónu, kterého Bůh nazývá svým synem. Nový "
          "zákon ho opakovaně vztahuje na Ježíše."),
         ("Iz 9,5-6", "Na Davidově trůnu bez konce",
          "Dítě, které se narodí, ponese jména Božího krále. Jeho vláda "
          "a pokoj nebudou mít konce."),
         ("Iz 11,1", "Výhonek z pařezu",
          "Davidova dynastie skončí jako pokácený strom. Z pařezu však "
          "vyraší výhonek – nový král plný Božího Ducha."),
         ("L 1,32-33", "Trůn jeho otce Davida",
          "Anděl Gabriel vysvětluje Marii, že její syn je ten slíbený "
          "král z Nátanova proroctví."),
         ("Mt 21,9", "Hosana synu Davidovu",
          "Při vjezdu do Jeruzaléma zástupy vítají Ježíše jako Davidova "
          "potomka a krále."),
         ("Zj 22,16", "Kořen a potomek Davidův",
          "V poslední kapitole Bible se Ježíš sám představuje jako "
          "naplnění slibu daného Davidovi."),
     ]),
    ("covenant", 0xFF4E9A8A, "handshake", "Smlouva",
     "Bůh opakovaně uzavírá s lidmi smlouvu – závazek věrnosti. "
     "Každá další navazuje na předchozí a míří k „nové smlouvě“.",
     [
         ("Gn 9,11-13", "Noe a duha",
          "Po potopě Bůh slibuje, že už nezničí zemi. Duha je znamením "
          "smlouvy se vším živým."),
         ("Gn 15,5-6", "Abraham a hvězdy",
          "Bůh slibuje Abrahamovi potomstvo jako hvězd. Abraham uvěří "
          "a Bůh mu to počítá za spravedlnost."),
         ("Ex 24,7-8", "Krev smlouvy na Sinaji",
          "Izrael slibuje poslouchat Boží slova. Mojžíš kropí lid krví "
          "a mluví o „krvi smlouvy“."),
         ("2S 7,16", "Smlouva s Davidem",
          "Slib trvalého domu a království pro Davidovy potomky."),
         ("Jr 31,31-33", "Nová smlouva",
          "Lid smlouvu opakovaně porušil. Jeremjáš ohlašuje novou: Bůh "
          "vepíše svůj zákon lidem do srdce."),
         ("L 22,20", "Kalich nové smlouvy",
          "Při poslední večeři Ježíš používá Jeremjášova slova i slova "
          "ze Sinaje: nová smlouva v jeho krvi."),
         ("Žd 8,10", "Zákon v srdci",
          "List Židům cituje Jeremjáše a ukazuje, že nová smlouva je "
          "skrze Krista skutečností."),
     ]),
    ("exodus", 0xFF3F7CAC, "waves", "Vysvobození (exodus)",
     "Vyjití z Egypta je vzor, podle kterého Bible vypráví o záchraně: "
     "Bůh slyší, vyvádí z otroctví a vede ke svobodě.",
     [
         ("Ex 3,7-8", "Viděl jsem trápení",
          "Bůh se zjevuje Mojžíšovi v hořícím keři: vidí útlak svého lidu "
          "a sestupuje, aby ho vysvobodil."),
         ("Ex 14,21-22", "Cesta mořem",
          "Izrael prochází mořem po suchu. Tento zázrak se stane "
          "základním vyznáním víry Izraele."),
         ("Iz 43,16-19", "Nový exodus",
          "V babylonském zajetí prorok slibuje nové vyjití – ještě větší "
          "než to první: „Hle, já činím nové věci.“"),
         ("Oz 11,1", "Z Egypta jsem povolal syna",
          "Ozeáš vzpomíná na exodus jako na Boží lásku k Izraeli – "
          "synovi, kterého Bůh vyvedl."),
         ("Mt 2,15", "Ježíš a Egypt",
          "Matouš vztahuje Ozeášova slova na Ježíše, který se jako dítě "
          "vrací z Egypta. Ježíš prožívá příběh Izraele."),
         ("L 9,30-31", "Ježíšův „odchod“",
          "Na hoře proměnění mluví Mojžíš a Eliáš o Ježíšově odchodu – "
          "řecky „exodos“ – který se naplní v Jeruzalémě."),
         ("1K 10,1-2", "Prošli mořem",
          "Pavel vykládá průchod mořem jako obraz křtu: přechod ze "
          "staré služby do nového života."),
         ("Zj 15,3", "Píseň Mojžíšova a Beránkova",
          "Vykoupení na konci času zpívají píseň, která spojuje Mojžíše "
          "u moře s Beránkem."),
     ]),
    ("water", 0xFF3E8EAE, "drop", "Voda života",
     "Voda v Bibli znamená život, očištění i Boží Ducha. Řeka teče od "
     "první zahrady až do nového Jeruzaléma.",
     [
         ("Gn 2,10", "Řeka v zahradě",
          "Z Edenu vytéká řeka a dělí se na čtyři ramena. Život začíná "
          "u vody."),
         ("Ex 17,6", "Voda ze skály",
          "Na poušti Bůh napojí žíznivý lid ze skály. Pavel později "
          "napíše, že tou skálou byl Kristus (1K 10,4)."),
         ("Ž 42,2", "Jako laň touží po vodě",
          "Žalmista žízní po Bohu tak, jako zvíře v suché krajině "
          "touží po potoku."),
         ("Iz 55,1", "Pojďte k vodám",
          "Bůh zve žíznivé, ať přijdou a pijí zadarmo. Nabídka platí "
          "všem."),
         ("Ez 47,9", "Řeka z chrámu",
          "Ezechiel vidí řeku, která vytéká z chrámu a všude, kam doteče, "
          "přináší život – i do Mrtvého moře."),
         ("J 4,14", "Voda, kterou dám já",
          "Ježíš u studny nabízí Samařance vodu, po které už nikdo "
          "nebude žíznit."),
         ("J 7,37-39", "Proudy živé vody",
          "O svátku stánků Ježíš volá žíznivé k sobě. Jan vysvětluje, "
          "že mluvil o Duchu."),
         ("Zj 22,1", "Řeka vody života",
          "V novém Jeruzalémě teče řeka od Božího trůnu – Ezechielovo "
          "vidění se plní."),
     ]),
    ("tree", 0xFF3E8E5E, "tree", "Strom života",
     "Strom života stojí na začátku i na konci Bible. Mezi nimi je jiný "
     "strom – kříž.",
     [
         ("Gn 2,9", "Strom života v zahradě",
          "Uprostřed zahrady roste strom života. Člověk je stvořen "
          "k životu v Boží blízkosti."),
         ("Gn 3,22-24", "Cesta ke stromu je zavřena",
          "Po pádu je cesta ke stromu života střežena cheruby. "
          "Lidé ztrácejí přístup k plnému životu."),
         ("Př 3,18", "Moudrost je strom života",
          "Kniha Přísloví říká, že kdo se drží Boží moudrosti, nachází "
          "kousek ztraceného života."),
         ("Ž 1,3", "Strom u vody",
          "Člověk, který žije z Božího slova, je jako strom zasazený "
          "u potoků – nese ovoce."),
         ("Ga 3,13", "Pověšen na dřevě",
          "Pavel cituje Zákon o tom, kdo visí na dřevě. Kříž – strom "
          "prokletí – se stává místem vykoupení."),
         ("Zj 2,7", "Jíst ze stromu života",
          "Vzkříšený Kristus slibuje vítězům, že budou jíst ze stromu "
          "života. Cesta je znovu otevřená."),
         ("Zj 22,2", "Listí ke zdraví národů",
          "Strom života roste po obou stranách řeky a jeho listí "
          "uzdravuje národy."),
     ]),
    ("nations", 0xFFCF8A45, "globe", "Požehnání pro všechny národy",
     "Bůh si vyvolil Abrahama, aby skrze něj požehnal celému světu. "
     "Tato nit vede od jedné rodiny k zástupu ze všech národů.",
     [
         ("Gn 12,2-3", "V tobě budou požehnány",
          "Abrahamovo povolání má cíl: požehnání pro všechny rody "
          "země."),
         ("Rt 1,16", "Tvůj Bůh je můj Bůh",
          "Moábka Rút se přidává k Izraeli. Stane se prababičkou krále "
          "Davida."),
         ("Iz 49,6", "Světlo národům",
          "Boží služebník má přinést záchranu až na konec země, nejen "
          "Izraeli."),
         ("Jon 4,11", "Bůh lituje Ninive",
          "Jonáš se zlobí, že Bůh odpustil nepřátelskému městu. Bůh mu "
          "ukazuje svůj soucit s každým národem."),
         ("Mt 28,19", "Získejte všechny národy",
          "Vzkříšený Ježíš posílá učedníky do celého světa."),
         ("Sk 2,5-6", "Každý ve svém jazyce",
          "O Letnicích slyší lidé z mnoha národů zvěst ve vlastním "
          "jazyce – opak zmatení jazyků v Babylonu (Gn 11)."),
         ("Ga 3,8", "Evangelium dopředu",
          "Pavel vysvětluje, že slib Abrahamovi byl evangeliem pro "
          "pohany předem."),
         ("Zj 7,9", "Zástup ze všech národů",
          "Na konci stojí před Bohem nespočetný zástup ze všech národů, "
          "kmenů a jazyků."),
     ]),
    ("shepherd", 0xFF7C8B5A, "shepherd", "Pastýř",
     "Bůh se v Bibli často představuje jako pastýř, který vede, chrání "
     "a hledá ztracené.",
     [
         ("Ž 23,1", "Hospodin je můj pastýř",
          "Nejznámější žalm: s Bohem jako pastýřem člověku nic "
          "podstatného nechybí."),
         ("Iz 40,11", "Beránky nese v náručí",
          "Prorok utěšuje lid v zajetí: Bůh pase své stádo jemně "
          "a slabé nese."),
         ("Ez 34,11-12", "Sám budu hledat své ovce",
          "Izraelští vůdci selhali jako pastýři. Bůh slibuje, že se "
          "o rozptýlené ovce postará sám."),
         ("Ez 34,23", "Jediný pastýř – David",
          "Bůh ustanoví jednoho pastýře z Davidova rodu – slib, který "
          "ukazuje k Mesiáši."),
         ("L 15,4-6", "Ztracená ovce",
          "Ježíš vypráví o pastýři, který nechá devadesát devět ovcí "
          "a hledá tu jednu."),
         ("J 10,11", "Dobrý pastýř",
          "Ježíš o sobě říká to, co proroci říkali o Bohu – a dodává, "
          "že pastýř dává život za ovce."),
         ("1Pt 5,4", "Nejvyšší pastýř",
          "Petr připomíná vedoucím církve, že sami slouží pod Kristem, "
          "nejvyšším pastýřem."),
         ("Zj 7,17", "Beránek jejich pastýřem",
          "Paradox na konci: Beránek je zároveň pastýř a vede ke "
          "studnicím vod života."),
     ]),
    ("victory", 0xFFA8475B, "serpent", "Vítězství nad zlem",
     "Hned po pádu Bůh slibuje, že zlo nebude mít poslední slovo. "
     "Celá Bible pak vypráví, jak tento slib dochází naplnění.",
     [
         ("Gn 3,15", "Rozdrtí hlavu hada",
          "První slib naděje: potomek ženy rozdrtí hadovi hlavu, i když "
          "sám bude zraněn. Církev v tom od starověku vidí první "
          "zaslíbení Mesiáše."),
         ("Nu 21,8-9", "Měděný had",
          "Na poušti, kdo pohlédne na měděného hada na tyči, zůstane "
          "naživu."),
         ("J 3,14-15", "Vyvýšený Syn člověka",
          "Ježíš sám přirovnává svůj kříž k měděnému hadu: kdo v něj "
          "věří, má život."),
         ("Ko 2,15", "Triumf nad mocnostmi",
          "Pavel popisuje kříž jako vítězný průvod, v němž Kristus "
          "odzbrojil mocnosti zla."),
         ("Žd 2,14", "Zbavil moci ďábla",
          "Ježíš se stal člověkem, aby svou smrtí přemohl toho, kdo měl "
          "moc nad smrtí."),
         ("Ř 16,20", "Satan pod vašima nohama",
          "Pavel ozvěnou Genesis 3 slibuje: Bůh pokoje brzy rozdrtí "
          "satana."),
         ("Zj 20,10", "Konec zla",
          "Ďábel, starý had, je nakonec definitivně poražen."),
     ]),
    ("spirit", 0xFF8C6BA8, "spirit", "Duch Boží",
     "Boží Duch se vznáší nad vodami při stvoření, vede proroky "
     "a o Letnicích sestupuje na všechny, kdo věří.",
     [
         ("Gn 1,2", "Duch nad vodami",
          "Na počátku se Boží Duch vznáší nad prázdnotou – tam, kde "
          "Duch působí, vzniká život."),
         ("Nu 11,29", "Kéž by všichni byli proroky",
          "Mojžíš si přeje, aby Bůh dal svého Ducha celému lidu, ne "
          "jen několika vyvoleným."),
         ("Ez 36,26-27", "Nové srdce a nový duch",
          "Bůh slibuje vyměnit kamenné srdce za srdce z masa a vložit "
          "do lidí svého Ducha."),
         ("Jl 3,1", "Vyleji svého Ducha",
          "Jóel slibuje Ducha pro všechny – syny i dcery, staré i mladé. "
          "Petr tento text cituje o Letnicích."),
         ("L 3,22", "Duch sestupuje na Ježíše",
          "Při křtu sestupuje Duch na Ježíše v podobě holubice."),
         ("Sk 2,4", "Letnice",
          "Mojžíšovo přání a Jóelův slib se plní: Duch je vylit na "
          "všechny učedníky."),
         ("Ř 8,11", "Duch, který křísí",
          "Týž Duch, který vzkřísil Ježíše, dá život i nám."),
         ("Ga 5,22-23", "Ovoce Ducha",
          "Duch proměňuje charakter: láska, radost, pokoj a další "
          "ovoce."),
     ]),
    ("light", 0xFFE0B341, "light", "Světlo",
     "První Boží slovo zní „Budiž světlo“. Světlo pak provází Boží lid "
     "pouští, svítí z Božího slova a nakonec září v Ježíši i v jeho "
     "lidech.",
     [
         ("Gn 1,3", "Budiž světlo",
          "Prvním Božím činem je světlo do tmy. Bůh začíná tím, že dává "
          "vidět."),
         ("Ex 13,21", "Ohnivý sloup v noci",
          "Na poušti jde Bůh před lidem v noci jako světlo, aby mohli jít "
          "i ve tmě."),
         ("Ž 119,105", "Svíce mým nohám",
          "Boží slovo nesvítí na celou cestu najednou, ale na další krok."),
         ("Iz 9,1", "Lid ve tmě uvidí světlo",
          "Prorok slibuje velké světlo pro ty, kdo bydlí v zemi stínu "
          "smrti. Matouš to čte o Ježíšově působení v Galileji."),
         ("J 8,12", "Já jsem světlo světa",
          "Ježíš o sobě říká to, co patřilo Bohu: kdo jde za ním, nebude "
          "chodit ve tmě."),
         ("Mt 5,14", "Vy jste světlo světa",
          "Světlo se předává dál. Ježíšovi učedníci mají svítit tak, aby "
          "lidé viděli dobré skutky a chválili Otce."),
         ("2K 4,6", "Světlo v srdcích",
          "Týž Bůh, který řekl „ze tmy ať zazáří světlo“, rozsvítil "
          "i lidská srdce poznáním Krista."),
         ("Zj 22,5", "Už nebude noc",
          "V novém světě není třeba lampy ani slunce. Světlem je sám "
          "Bůh."),
     ]),
    ("bread", 0xFFB9824A, "bread", "Chléb z nebe",
     "Bůh sytí svůj lid – manou na poušti, chlebem pro vdovu i chlebem, "
     "který láme Ježíš. Chléb se stává znamením Boží péče i společenství.",
     [
         ("Gn 14,18", "Chléb a víno",
          "Kněz Melchisedech vychází Abramovi naproti s chlebem a vínem "
          "a žehná mu."),
         ("Ex 16,4", "Mana z nebe",
          "Bůh dává každé ráno chléb z nebe – tolik, kolik je potřeba na "
          "jeden den."),
         ("Dt 8,3", "Nejen chlebem",
          "Mana měla naučit, že člověk žije z každého slova, které vychází "
          "z Božích úst. Ježíš tato slova cituje na poušti."),
         ("1Kr 17,14", "Mouka nedojde",
          "Vdova ze Sarepty dá poslední hrst mouky prorokovi a Bůh ji "
          "sytí po celou dobu sucha."),
         ("J 6,35", "Já jsem chléb života",
          "Po nasycení zástupu Ježíš říká, že on sám je chléb, který "
          "utiší hlad nadobro."),
         ("L 22,19", "Toto je mé tělo",
          "Při poslední večeři láme Ježíš chléb a dává ho učedníkům na "
          "památku své oběti."),
         ("L 24,30-31", "Poznali ho při lámání chleba",
          "Učedníci v Emauzích poznají vzkříšeného ve chvíli, kdy jim "
          "láme chléb."),
         ("Sk 2,42", "Lámání chleba",
          "První církev se pravidelně schází k učení, modlitbám a lámání "
          "chleba."),
     ]),
    ("mountain", 0xFF8A7F72, "mountain", "Setkání na hoře",
     "Velké chvíle setkání s Bohem se často odehrávají na horách – od "
     "Mórija přes Sinaj a Karmel až k hoře proměnění a novému Jeruzalému.",
     [
         ("Gn 22,14", "Na hoře Hospodin vidí",
          "Na hoře Mórija si Bůh opatří oběť místo Izáka. Místo dostane "
          "jméno „Hospodin vidí“."),
         ("Ex 19,20", "Sinaj",
          "Bůh sestupuje na horu v ohni a volá Mojžíše nahoru. Tady se "
          "rodí smlouva."),
         ("1Kr 18,38", "Karmel",
          "Na hoře Karmel sestoupí oheň na Eliášovu oběť a lid vyzná, že "
          "Hospodin je Bůh."),
         ("1Kr 19,11-12", "Tichý vánek na Chorébu",
          "Na téže hoře jako Mojžíš potkává Eliáš Boha ne ve vichru, "
          "zemětřesení ani ohni, ale v tichém vánku."),
         ("Iz 2,2-3", "Hora, k níž proudí národy",
          "Prorok vidí Boží horu, ke které přicházejí všechny národy učit "
          "se Božím cestám."),
         ("Mt 5,1-2", "Kázání na hoře",
          "Ježíš vystoupí na horu a učí – jako nový Mojžíš vykládá, jak "
          "žít s Bohem."),
         ("Mt 17,2", "Hora proměnění",
          "Na hoře se Ježíš promění v záři a vedle něj stojí Mojžíš "
          "a Eliáš, muži Sinaje a Karmelu."),
         ("Zj 21,10", "Velká a vysoká hora",
          "Z vysoké hory vidí Jan sestupovat nový Jeruzalém. Cesta na "
          "horu končí v Božím městě."),
     ]),
    ("rest", 0xFF6F8FA8, "rest", "Odpočinutí",
     "Bůh sedmý den odpočívá a zve k odpočinku i člověka. Sobota "
     "připomíná stvoření i vysvobození a ukazuje k odpočinutí, které "
     "dává Ježíš.",
     [
         ("Gn 2,2-3", "Sedmý den",
          "Bůh dokončí dílo, odpočine a sedmý den požehná. Odpočinek je "
          "součástí dobrého stvoření."),
         ("Ex 20,8-10", "Pamatuj na sobotu",
          "Desatero dává odpočinek všem – dětem, otrokům, cizincům "
          "i zvířatům."),
         ("Dt 5,15", "Byl jsi otrokem",
          "Sobota připomíná, že Bůh vyvedl lid z otroctví. Kdo odpočívá, "
          "žije jako svobodný."),
         ("Ž 23,2", "Na travnatých nivách",
          "Dobrý pastýř dopřává odpočinek a vede k tichým vodám."),
         ("Mt 11,28", "Pojďte ke mně",
          "Ježíš zve unavené a obtížené: „Já vám dám odpočinout.“"),
         ("Mk 2,27", "Sobota pro člověka",
          "Ježíš připomíná, že sobota je dar pro člověka, ne břemeno."),
         ("Žd 4,9-10", "Odpočinutí Božího lidu",
          "Pro Boží lid zbývá ještě sobotní odpočinutí – vstoupit do "
          "Božího pokoje."),
         ("Zj 14,13", "Odpočinou od svých prací",
          "Ti, kdo umírají v Pánu, odpočinou od námah a jejich skutky jdou "
          "s nimi."),
     ]),
    ("home", 0xFF9C6B8E, "home", "Vyhnanství a cesta domů",
     "Od vyhnání ze zahrady je člověk na cestě. Abraham je poutník, Izrael "
     "zažije zajetí i návrat a Ježíš slibuje domov u Otce.",
     [
         ("Gn 3,23-24", "Vyhnání ze zahrady",
          "Člověk ztrácí domov v Boží blízkosti. Cesta zpět je střežena."),
         ("Gn 12,1", "Odejdi do země, kterou ti ukážu",
          "Abram opouští domov a stává se poutníkem na cestě s Bohem."),
         ("Ex 3,8", "Do dobré a prostorné země",
          "Bůh slibuje vyvést otroky z Egypta do země oplývající mlékem "
          "a medem."),
         ("Ž 137,1", "U řek babylonských",
          "V zajetí lid pláče, když vzpomíná na Sijón. Stesk po domově se "
          "stává modlitbou."),
         ("Jr 29,10-11", "Budoucnost a naděje",
          "Bůh slibuje vyhnancům návrat po sedmdesáti letech: má s nimi "
          "plány pokoje."),
         ("Ezd 1,3", "Kdo chce, ať se vrátí",
          "Perský král dovoluje návrat. Vyhnanci se vydávají domů stavět "
          "chrám."),
         ("L 15,20", "Otec mu běží naproti",
          "Ztracený syn se vrací domů a otec ho vítá dřív, než stačí "
          "domluvit."),
         ("J 14,2", "V domě mého Otce",
          "Ježíš jde připravit místo. Konečný domov není místo, ale "
          "bytí s ním."),
         ("Žd 11,13-16", "Hledali lepší vlast",
          "Praotcové víry se cítili jako cizinci, protože toužili po "
          "nebeské vlasti."),
     ]),
    ("priest", 0xFFB4664A, "priest", "Kněz a prostředník",
     "Člověk potřebuje někoho, kdo ho přivede k Bohu. Kněží Izraele "
     "přinášejí oběti a přimlouvají se – až přijde velekněz, který "
     "obětuje sám sebe.",
     [
         ("Gn 14,18-20", "Melchisedech",
          "Tajemný král a kněz Boha Nejvyššího žehná Abramovi. List Židům "
          "v něm vidí obraz Krista."),
         ("Ex 28,1", "Áron a jeho synové",
          "Bůh ustanoví kněze, aby sloužili ve svatyni a nesli jména "
          "kmenů před Bohem."),
         ("Lv 16,30", "Den smíření",
          "Jednou za rok velekněz koná smíření, aby byl lid očištěn ode "
          "všech hříchů."),
         ("Ž 110,4", "Kněz navěky",
          "Žalm ohlašuje kněze podle řádu Melchisedechova – ne na čas, "
          "ale navěky."),
         ("Iz 53,12", "Za provinilce se přimlouval",
          "Trpící služebník nese hřích mnohých a přimlouvá se za ty, kdo "
          "selhali."),
         ("Žd 4,14-16", "Velekněz, který soucítí",
          "Ježíš zná naše slabosti, a proto smíme přistupovat k trůnu "
          "milosti s důvěrou."),
         ("1Tm 2,5", "Jeden prostředník",
          "Mezi Bohem a lidmi je jediný prostředník – člověk Kristus "
          "Ježíš."),
         ("1Pt 2,9", "Královské kněžstvo",
          "Kněžská služba se rozšiřuje na celý Boží lid: všichni smějí "
          "přistoupit k Bohu a nést ho druhým."),
     ]),
    ("name", 0xFFC9A86A, "name", "Jméno „Já jsem“",
     "Bůh se Mojžíšovi představí jménem „Jsem, který jsem“. Ježíš pak "
     "mluví o sobě slovy „Já jsem“ – a na konci zazní „Já jsem Alfa "
     "i Omega“.",
     [
         ("Ex 3,14", "Jsem, který jsem",
          "U hořícího keře Bůh zjeví své jméno: je tu, je přítomen a je "
          "věrný."),
         ("Ex 34,6-7", "Milosrdný a milostivý",
          "Po zlatém teleti Bůh vysvětlí, co jeho jméno znamená: "
          "milosrdenství, trpělivost a věrnost."),
         ("Ž 8,2", "Jak vznešené je tvé jméno",
          "Žalmista žasne nad Božím jménem, které se zrcadlí v celém "
          "stvoření."),
         ("Iz 43,1-3", "Volám tě tvým jménem",
          "Bůh, který má jméno, zná jménem i svůj lid: „Neboj se, jsi "
          "můj.“"),
         ("J 8,58", "Dříve než byl Abraham, já jsem",
          "Ježíš použije Boží jméno o sobě. Posluchači pochopí a chtějí "
          "ho kamenovat."),
         ("J 11,25", "Já jsem vzkříšení i život",
          "Jedno ze sedmi Ježíšových „Já jsem“ – u hrobu Lazara."),
         ("Fp 2,9-10", "Jméno nad každé jméno",
          "Bůh dal Ježíši jméno, před kterým poklekne každé koleno."),
         ("Zj 1,8", "Já jsem Alfa i Omega",
          "Bible končí tam, kde začala u keře: Bůh, který je, který byl "
          "a který přichází."),
     ]),
    ("bride", 0xFFC86A86, "bride", "Ženich a nevěsta",
     "Bible začíná svatbou v zahradě a končí svatbou Beránka. Mezi tím "
     "proroci líčí Boha jako věrného manžela nevěrného lidu.",
     [
         ("Gn 2,23-24", "První svatba",
          "Muž s radostí vítá ženu a stanou se jedním tělem. Manželství "
          "stojí na začátku příběhu."),
         ("Pís 8,6-7", "Láska silná jako smrt",
          "Píseň písní opěvuje lásku, kterou nemohou uhasit ani velké "
          "vody."),
         ("Oz 2,21-22", "Zasnoubím si tě navěky",
          "Bůh slibuje nevěrnému lidu nový začátek ve věrnosti, "
          "milosrdenství a lásce."),
         ("Iz 62,5", "Radost ženicha",
          "Jako se ženich raduje z nevěsty, bude se Bůh radovat ze svého "
          "lidu."),
         ("J 3,29", "Přítel ženicha",
          "Jan Křtitel se nazývá přítelem ženicha – ženichem je Ježíš."),
         ("Ef 5,31-32", "Velké tajemství",
          "Pavel čte slova z Genesis o jednom těle jako obraz Krista "
          "a církve."),
         ("Zj 19,7", "Přišla svatba Beránka",
          "Nebe jásá: nevěsta je připravena a začíná svatební hostina."),
         ("Zj 21,2", "Město jako nevěsta",
          "Nový Jeruzalém sestupuje z nebe, připravený jako nevěsta "
          "ozdobená pro svého muže."),
     ]),
    ("vine", 0xFF7A4E7E, "vine", "Vinice a vinný kmen",
     "Izrael je Boží vinice, o kterou Bůh pečuje, ale nenese dobré ovoce. "
     "Ježíš se představí jako pravý vinný kmen, z něhož ovoce roste.",
     [
         ("Ž 80,9", "Réva vysazená z Egypta",
          "Žalmista vypráví dějiny Izraele jako révu, kterou Bůh přenesl "
          "a zasadil."),
         ("Iz 5,1-2", "Píseň o vinici",
          "Bůh udělal pro svou vinici všechno, a ona přesto vydala "
          "planá hrozna."),
         ("Jr 2,21", "Zvrhlá réva",
          "Jeremjáš naříká, že ušlechtilá réva se zvrhla v cizí."),
         ("Mt 21,33", "Podobenství o vinařích",
          "Nájemci vinice odmítají vydat úrodu a nakonec zabijí i "
          "majitelova syna."),
         ("L 22,18", "Z plodu vinné révy",
          "Při poslední večeři Ježíš slibuje, že víno znovu bude pít "
          "v Božím království."),
         ("J 15,5", "Já jsem vinný kmen",
          "Ježíš je pravá réva, učedníci ratolesti. Kdo v něm zůstává, "
          "nese mnoho ovoce."),
         ("Ga 5,22-23", "Ovoce Ducha",
          "Ovoce, které Bůh hledal na vinici, roste v lidech skrze "
          "Ducha."),
     ]),
    ("weak", 0xFF6FA07A, "weak", "Bůh si vybírá slabé",
     "Znovu a znovu Bůh volí mladší, menší a slabší – aby bylo vidět, že "
     "síla je jeho.",
     [
         ("Gn 25,23", "Starší bude sloužit mladšímu",
          "Už před narozením Jákoba a Ezaua Bůh obrací běžný řád "
          "prvorozenství."),
         ("Ex 4,10-12", "Nejsem výmluvný",
          "Mojžíš se brání, že neumí mluvit. Bůh odpovídá: „Já budu "
          "s tvými ústy.“"),
         ("Sd 6,15", "Nejmenší v domě svého otce",
          "Gedeón se cítí nejslabší, a právě jeho Bůh posílá zachránit "
          "Izrael."),
         ("1S 16,7", "Hospodin hledí na srdce",
          "Ze synů Jišajových je vybrán nejmladší pastýř, na kterého "
          "nikdo nepomyslel."),
         ("1S 17,45", "Ve jménu Hospodina",
          "David nejde proti Goliášovi s mečem, ale ve jménu Boha."),
         ("Jr 1,6-7", "Jsem příliš mladý",
          "Jeremjáš namítá svůj věk. Bůh mu řekne: „Neříkej, že jsi "
          "mladý.“"),
         ("L 1,52", "Povyšuje ponížené",
          "Marie zpívá o Bohu, který svrhává mocné z trůnů a povyšuje "
          "malé."),
         ("1K 1,27", "Co je slabé, vyvolil Bůh",
          "Bůh vybral to, co svět považuje za slabé, aby se nikdo "
          "nechlubil před ním."),
         ("2K 12,9", "Moc se dovršuje ve slabosti",
          "Pavlovi Bůh řekne: „Stačí ti má milost.“ Slabost se stává "
          "místem Boží síly."),
     ]),
    ("rock", 0xFF8C8C8C, "rock", "Kámen a skála",
     "Bůh je skála, na které se dá stavět. Z kamene teče voda na poušti, "
     "odmítnutý kámen se stává úhelným a z lidí se staví živý chrám.",
     [
         ("Gn 28,18", "Kámen v Bét-elu",
          "Jákob postaví kámen, na kterém spal, jako památník setkání "
          "s Bohem."),
         ("Ex 17,6", "Voda ze skály",
          "Na poušti udeří Mojžíš do skály a vyteče voda pro žíznivý "
          "lid."),
         ("Ž 18,3", "Hospodin je má skála",
          "David vyznává Boha jako skálu, pevnost a útočiště."),
         ("Iz 28,16", "Úhelný kámen na Sijónu",
          "Bůh klade pevný základní kámen: kdo věří, nebude ve spěchu "
          "utíkat."),
         ("Da 2,34-35", "Kámen, který se stal horou",
          "V Nebúkadnesarově snu kámen utržený bez lidských rukou rozbije "
          "sochu říší a naplní celou zemi."),
         ("Mt 7,24", "Dům na skále",
          "Kdo slyší Ježíšova slova a jedná podle nich, staví na skále."),
         ("Mt 21,42", "Kámen, který stavitelé zavrhli",
          "Ježíš vztahuje žalm o odmítnutém kameni na sebe."),
         ("1K 10,4", "Ta skála byla Kristus",
          "Pavel čte skálu na poušti jako obraz Krista, který dává pít."),
         ("1Pt 2,4-5", "Živé kameny",
          "Věřící se jako živé kameny stavějí na Kristu v duchovní dům."),
     ]),
]
