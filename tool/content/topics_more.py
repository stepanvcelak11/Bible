"""Další biblická témata se studijní částí (vlastní texty aplikace).

Každé téma: shrnutí, klíčová místa s popiskem (kanonické číslování),
„Do hloubky“ (odstavce), zajímavosti a otázky k zamyšlení.
"""

T = []


def topic(id, cat, icon, title, summary, refs, deeper, facts, questions):
    T.append(dict(id=id, category=cat, icon=icon, title=title,
                  summary=summary, refs=refs, deeper=deeper, facts=facts,
                  questions=questions))


# --- Bůh -------------------------------------------------------------------
topic("names", "god", "key", "Boží jména",
      "V Bibli jméno vyjadřuje povahu. Bůh se lidem představuje mnoha "
      "jmény – každé odhaluje kus toho, kým je: Ten, který je, Všemohoucí, "
      "Pastýř, Lékař, Otec.",
      [("Ex 3,14", "Jsem, který jsem"),
       ("Gn 17,1", "Bůh Všemohoucí (El Šadaj)"),
       ("Gn 22,14", "Hospodin vidí a opatří"),
       ("Ex 15,26", "Hospodin, tvůj lékař"),
       ("Ex 17,15", "Hospodin je můj prapor"),
       ("Sd 6,24", "Hospodin je pokoj"),
       ("Ž 23,1", "Hospodin je můj pastýř"),
       ("Mt 6,9", "Otče náš")],
      ["Nejdůležitější Boží jméno zapisuje hebrejština čtyřmi souhláskami "
       "JHWH. Souvisí se slovesem „být“: Bůh je ten, který je, byl a bude – "
       "a který je přítomen se svým lidem. Většina českých překladů ho "
       "píše jako HOSPODIN, často velkými písmeny, aby se odlišilo od "
       "obecného „Pán“.",
       "Další jména vznikala ze zkušenosti: Abraham na hoře Mórija nazval "
       "místo „Hospodin vidí“, Gedeon postavil oltář „Hospodin je pokoj“. "
       "Boží jména tedy nejsou teorie, ale svědectví lidí, kteří Boha "
       "poznali v konkrétní situaci. Ježíš pak učí oslovovat Boha "
       "nejdůvěrněji ze všech: Otče."],
      ["Židé ze zbožné úcty Boží jméno JHWH nevyslovovali a při čtení ho "
       "nahrazovali slovem Adonaj – „Pán“. Odtud pochází i nesprávné "
       "čtení „Jehova“, které vzniklo smícháním souhlásek jednoho slova "
       "se samohláskami druhého.",
       "Kralická bible píše Boží jméno jako „Hospodin“ – staročeské slovo "
       "pro pána domu (hospodáře). Česká tradice tím zdůrazňuje, že Bůh "
       "je ten, kdo se o svůj dům stará."],
      ["Které Boží jméno nejlépe vystihuje mou zkušenost s Bohem?",
       "Jak by mé jméno pro Boha znělo dnes – podle toho, co jsem s ním "
       "prožil?"])

topic("providence", "god", "compass", "Boží vláda a prozřetelnost",
      "Bible učí, že dějiny ani osobní život nejsou slepá náhoda. Bůh "
      "vládne nad světem a umí i lidské zlo a omyly obrátit k dobrému – "
      "aniž by člověku bral odpovědnost.",
      [("Gn 50,20", "Vy jste zamýšleli zlé, Bůh dobré"),
       ("Est 4,14", "Možná právě pro tuto chvíli"),
       ("Př 16,9", "Člověk plánuje, Hospodin řídí kroky"),
       ("Př 19,21", "Boží rada obstojí"),
       ("Da 2,21", "On mění časy a doby"),
       ("Mt 10,29-31", "Ani vrabec nepadne bez vašeho Otce"),
       ("Ř 8,28", "Všechno napomáhá k dobrému"),
       ("Ef 1,11", "Vše působí podle své vůle")],
      ["Příběh Josefa je učebnicí prozřetelnosti. Bratři ho prodají do "
       "otroctví, je neprávem uvězněn a zapomenut – a přece se právě tak "
       "dostane na místo, kde zachrání celou rodinu před hladem. Josef na "
       "konci nezlehčuje vinu bratří, ale vidí, že Bůh byl ve hře celou "
       "dobu.",
       "Kniha Ester Boha ani jednou nejmenuje, a přece je jím prostoupena: "
       "„náhodou“ nespí král, „náhodou“ se čte právě ta kronika. "
       "Prozřetelnost často není vidět v jednotlivém okamžiku, ale až při "
       "pohledu zpět. Neznamená to, že všechno je dobré; znamená to, že Bůh "
       "z ničeho nemusí ustoupit."],
      ["Slovo „prozřetelnost“ pochází z latinského providentia – "
       "„prozíravost, péče dopředu“. Je ve stejné rodině jako slovo "
       "„provize“: Bůh vidí dopředu a postará se.",
       "Ř 8,28 neříká, že všechno je dobré, ale že všechno „napomáhá "
       "k dobrému“ těm, kdo milují Boha – jako když se v receptu i hořké "
       "přísady spojí do dobrého jídla."],
      ["Kdy jsem až zpětně viděl, že mě Bůh vedl i přes těžké období?",
       "Jak se liší důvěra v Boží vládu od fatalismu „stejně se nedá nic "
       "dělat“?"])

topic("glory", "god", "star", "Boží sláva",
      "Hebrejské slovo pro slávu (kavod) znamená doslova „váha, tíha“. "
      "Boží sláva je jeho skutečnost, která má váhu – zjevuje se ve "
      "stvoření, ve stánku, a nejplněji v Ježíši Kristu.",
      [("Ex 33,18-19", "Ukaž mi svou slávu"),
       ("Ex 40,34", "Sláva naplnila příbytek"),
       ("Iz 6,3", "Celá země je plná jeho slávy"),
       ("Ž 19,2", "Nebesa vypravují Boží slávu"),
       ("J 1,14", "Spatřili jsme jeho slávu"),
       ("2K 4,6", "Sláva na tváři Kristově"),
       ("1K 10,31", "Všechno čiňte k Boží slávě"),
       ("Zj 21,23", "Město osvěcuje Boží sláva")],
      ["Mojžíš prosí: „Ukaž mi svou slávu.“ Bůh odpovídá, že nechá kolem "
       "něj projít svou dobrotu a vyhlásí své jméno – milosrdný a "
       "milostivý. Boží sláva tedy není jen oslňující světlo, ale "
       "především jeho charakter: dobrota a věrnost.",
       "Jan píše, že Slovo se stalo tělem „a stanulo mezi námi“ – doslova "
       "„postavilo stan“. Narážka na stánek, který naplnila Boží sláva. "
       "V Ježíši je Boží sláva vidět v lidské tváři. A Pavel dodává, že "
       "Boha lze oslavit i obyčejným jídlem a pitím."],
      ["Rabíni označovali přebývající Boží slávu slovem šechina "
       "(„přebývání“). Je příbuzné se slovem mi-škan – stánek, příbytek.",
       "Johann Sebastian Bach podepisoval své skladby zkratkou S. D. G. – "
       "Soli Deo Gloria, „Jedině Bohu sláva“."],
      ["Kde jsem v poslední době zahlédl Boží slávu – v přírodě, "
       "v člověku, v události?",
       "Co by znamenalo dělat svou běžnou práci „k Boží slávě“?"])

topic("presence", "god", "spa", "Boží přítomnost",
      "Od zahrady Eden po nové Jeruzalém vypráví Bible jeden příběh: Bůh "
      "chce být se svým lidem. Ježíš se jmenuje Immanuel – Bůh s námi – "
      "a slibuje: „Já jsem s vámi po všechny dny.“",
      [("Gn 3,8", "Bůh se procházel v zahradě"),
       ("Ex 33,14", "Má přítomnost půjde s tebou"),
       ("Ž 139,7-10", "Kam bych utekl před tvým Duchem?"),
       ("Iz 41,10", "Neboj se, já jsem s tebou"),
       ("Mt 1,23", "Immanuel – Bůh s námi"),
       ("Mt 28,20", "Jsem s vámi po všechny dny"),
       ("J 14,23", "Přijdeme k němu a učiníme si u něho příbytek"),
       ("Zj 21,3", "Hle, příbytek Boží mezi lidmi")],
      ["Bible popisuje Boží přítomnost ve vlnách: v Edenu ji lidé ztratí, "
       "v ohnivém sloupu a ve stánku se Bůh vrací doprostřed tábora, "
       "v chrámu přebývá v Jeruzalémě. V Ježíši přichází v lidském těle "
       "a skrze Ducha svatého přebývá v každém věřícím. Na konci Bible "
       "už chrám není potřeba – Bůh je se svým lidem přímo.",
       "Žalm 139 ukazuje, že Boží přítomnost není jen útěcha, ale "
       "i výzva: nedá se před ní utéct. Pro toho, kdo se Boha bojí, je to "
       "hrozba; pro toho, kdo mu důvěřuje, je to nejhlubší jistota."],
      ["Bratr Vavřinec, kuchař v pařížském klášteře 17. století, se "
       "proslavil drobnou knížkou o „praktikování Boží přítomnosti“ – "
       "naučil se modlit při mytí nádobí stejně jako v kostele.",
       "Mt 1,23 (Immanuel – Bůh s námi) a Mt 28,20 (já jsem s vámi) "
       "rámují celé Matoušovo evangelium jako závorka."],
      ["Kde se mi nejsnáz připomíná, že je Bůh se mnou?",
       "Co by se změnilo na mém dni, kdybych si Boží přítomnost "
       "připomněl třikrát denně?"])

# --- Ježíš ---------------------------------------------------------------
topic("incarnation", "jesus", "star", "Vtělení – Bůh se stal člověkem",
      "Křesťané věří, že Boží Syn se stal skutečným člověkem: narodil se, "
      "rostl, jedl, plakal i umíral. Bůh nepomáhá zdálky – vstoupil do "
      "lidského života zevnitř.",
      [("Iz 7,14", "Panna počne a porodí syna"),
       ("Iz 9,5", "Dítě se nám narodilo"),
       ("Mi 5,1", "Z Betléma vyjde vládce"),
       ("L 2,7", "Položila ho do jeslí"),
       ("L 2,10-11", "Narodil se vám Spasitel"),
       ("J 1,14", "Slovo se stalo tělem"),
       ("Ga 4,4", "Když se naplnil čas"),
       ("Fp 2,6-8", "Vzal na sebe podobu služebníka")],
      ["Slovo „vtělení“ (latinsky incarnatio) znamená „vstoupení do "
       "masa“. Jan to říká nečekaně drsně: Slovo se stalo „tělem“ – "
       "ne zdáním člověka, ale opravdovým křehkým tělem. Proto Ježíš "
       "rozumí únavě, hladu, pokušení i smutku (Žd 4,15).",
       "Pavel v listu Filipským zpívá o Kristu, který „sám sebe "
       "vyprázdnil“. Nevzdal se toho, že je Bůh, ale vzdal se výsad "
       "a slávy. Vtělení tak není jen nauka o Vánocích, ale vzor: Bůh "
       "sestupuje dolů, ne nahoru."],
      ["Jesle byly kamenné nebo hliněné žlaby na krmení dobytka. "
       "Dobytek se v Betlémě často ustájil v přízemí domu nebo v jeskyni "
       "– „chlév“ byl možná součástí obydlí.",
       "Datum 25. prosince není v Bibli. Slaví se od 4. století; o tom, "
       "proč právě tento den, se historici dodnes přou."],
      ["Co pro mě znamená, že Ježíš zná lidskou únavu a slabost "
       "zevnitř?",
       "Kde mě Bůh zve, abych se podobně „sklonil“ k druhým?"])

topic("parables", "jesus", "lamp", "Ježíšova podobenství",
      "Ježíš učil hlavně v příbězích ze života – o semenech, ovcích, "
      "penězích a hostinách. Podobenství jsou jednoduchá na poslech, "
      "ale hluboká na přemýšlení: kdo chce slyšet, slyší.",
      [("Mt 13,3-9", "Rozsévač"),
       ("Mt 13,31-32", "Hořčičné zrno"),
       ("Mt 13,44-46", "Poklad a perla"),
       ("L 10,30-37", "Milosrdný Samaritán"),
       ("L 15,4-7", "Ztracená ovce"),
       ("L 15,20-24", "Otec běží vstříc synovi"),
       ("L 18,10-14", "Farizeus a celník"),
       ("Mt 25,14-30", "Svěřené hřivny")],
      ["Podobenství (řecky parabolé) staví vedle sebe dvě věci: známou "
       "a neznámou. Království nebeské je „jako“ kvas, síť, poklad. "
       "Většinou má jeden hlavní bod a často končí překvapením – "
       "Samaritán je hrdina, celník odchází ospravedlněn, otec běží "
       "(což se pro váženého muže nehodilo).",
       "Při čtení pomáhá ptát se: komu to Ježíš vyprávěl? Tři "
       "podobenství o ztraceném v Lukáši 15 jsou odpovědí farizeům, kteří "
       "reptali, že jí s hříšníky. Starší bratr, který nechce jít na "
       "oslavu, je tedy zrcadlo pro ty, kdo poslouchali."],
      ["Evangelia obsahují kolem čtyřiceti podobenství. Jan žádné "
       "klasické podobenství nemá – místo toho zaznamenává obrazy jako "
       "„Já jsem dobrý pastýř“ nebo „Já jsem vinný kmen“.",
       "Hořčičné semínko měří asi 1–2 milimetry, ale keř černé hořčice "
       "u Galilejského jezera dorůstá i do výšky dvou až tří metrů."],
      ["S kterou postavou podobenství o ztraceném synu se dnes "
       "nejvíc ztotožňuji – s mladším synem, se starším, nebo s otcem?",
       "Které podobenství mě nejvíc znepokojuje – a proč?"])

topic("miracles", "jesus", "sun", "Ježíšovy zázraky",
      "Evangelia nazývají Ježíšovy zázraky „znameními“ a „mocnými "
      "činy“. Nejsou to kouzla pro efekt, ale ukázky toho, jaké je Boží "
      "království: nemocní uzdraveni, hladoví nasyceni, smrt přemožena.",
      [("J 2,11", "První znamení v Káně"),
       ("Mk 2,5-12", "Uzdravení ochrnutého a odpuštění"),
       ("Mk 4,39-41", "Utišení bouře"),
       ("J 6,11-13", "Nasycení zástupu"),
       ("J 9,6-7", "Slepý od narození vidí"),
       ("J 11,43-44", "Lazare, pojď ven!"),
       ("Mt 11,4-5", "Slepí vidí, chromí chodí"),
       ("J 20,30-31", "Napsáno, abyste věřili")],
      ["Jan vybírá sedm znamení a pokaždé je spojuje s výrokem nebo "
       "rozhovorem: po nasycení zástupu Ježíš říká „Já jsem chléb "
       "života“, před vzkříšením Lazara „Já jsem vzkříšení a život“. "
       "Zázrak je tedy jako ukazatel – nemá se na něm zůstat stát, ale "
       "jít tam, kam ukazuje.",
       "Ježíš zázraky nedělal na objednávku a často prosil uzdravené, ať "
       "nic neříkají. Nechtěl být vnímán jako divotvorce. Mnohé zázraky "
       "navíc vracejí lidi do společenství: malomocný se smí vrátit "
       "domů, žena s krvácením přestává být nečistá."],
      ["Utišení bouře je napsáno slovy, která připomínají Žalm 107: "
       "„Bouři změnil v ticho a vlny utichly.“ Učedníci se ptají „Kdo to "
       "je?“ a čtenář znalý žalmů zná odpověď.",
       "Rybník Siloe, kde se umyl slepý od narození, archeologové "
       "odkryli v Jeruzalémě v roce 2004 při opravě kanalizace."],
      ["Ve kterém příběhu uzdravení se dnes poznávám?",
       "Jsou v mém okolí „znamení“ Boží péče, kterých si nevšímám?"])

topic("titles", "jesus", "crown", "Ježíšova jména a tituly",
      "Ježíš má v Bibli desítky jmen a titulů. Každý z nich je jako okno: "
      "Mesiáš, Syn člověka, Beránek, Pastýř, Světlo, Pán. Dohromady "
      "skládají obraz toho, kdo Ježíš je.",
      [("Mt 1,21", "Ježíš – On vysvobodí svůj lid"),
       ("Mt 16,16", "Ty jsi Mesiáš, Syn živého Boha"),
       ("J 1,29", "Beránek Boží"),
       ("Mk 10,45", "Syn člověka přišel sloužit"),
       ("J 8,12", "Já jsem světlo světa"),
       ("J 10,11", "Já jsem dobrý pastýř"),
       ("J 14,6", "Já jsem cesta, pravda a život"),
       ("Zj 19,16", "Král králů a Pán pánů")],
      ["Jméno Ježíš (hebrejsky Ješua) znamená „Hospodin zachraňuje“. "
       "Bylo v Ježíšově době běžné. Kristus není příjmení, ale titul: "
       "řecký překlad hebrejského „Mesiáš“ – Pomazaný. Pomazáni olejem "
       "byli králové, kněží a někdy proroci.",
       "Ježíš sám o sobě nejčastěji mluví jako o „Synu člověka“. Výraz "
       "může znamenat prostě „člověk“, ale zároveň odkazuje na Danielovo "
       "vidění (Da 7,13), kde Syn člověka dostává věčnou vládu. Titul "
       "tak spojuje pokoru i slávu."],
      ["Janovo evangelium obsahuje sedm výroků „Já jsem“ s obrazem "
       "(chléb, světlo, dveře, pastýř, vzkříšení, cesta, vinný kmen). "
       "Řecké „egó eimi“ připomíná Boží jméno z hořícího keře.",
       "Raní křesťané kreslili rybu. Řecké slovo ICHTHYS (ryba) tvoří "
       "počáteční písmena věty „Ježíš Kristus, Boží Syn, Spasitel“."],
      ["Který Ježíšův titul je mi nejbližší a který nejvzdálenější?",
       "Co by znamenalo brát vážně, že Ježíš je „Pán“ i mých "
       "všedních rozhodnutí?"])

# --- Velké linie Bible ---------------------------------------------------
topic("covenant", "story", "link", "Smlouva",
      "Smlouva je páteř Bible. Bůh se k lidem váže slavnostními sliby – "
      "s Noem, Abrahamem, Izraelem na Sinaji, Davidem – až po novou "
      "smlouvu v Ježíšově krvi. Bůh není vzdálený, ale věrný partner.",
      [("Gn 9,13", "Duha jako znamení smlouvy"),
       ("Gn 15,18", "Smlouva s Abrahamem"),
       ("Ex 24,7-8", "Krev smlouvy na Sinaji"),
       ("2S 7,16", "Tvůj trůn bude pevný navěky"),
       ("Jr 31,31-33", "Nová smlouva zapsaná na srdce"),
       ("L 22,20", "Nová smlouva v mé krvi"),
       ("Žd 8,6", "Lepší smlouva s lepšími sliby")],
      ["Ve starověku uzavírali smlouvy panovníci se svými vazaly. "
       "Obsahovaly představení vládce, připomínku jeho dobrodiní, "
       "podmínky, požehnání a kletby a svědky. Desatero i kniha "
       "Deuteronomium mají podobnou stavbu – Bůh se představuje jako "
       "král, který svůj lid nejdřív vysvobodil a pak mu dal zákon.",
       "Smlouvy v Bibli na sebe navazují: každá rozvíjí tu předchozí. "
       "Jeremjáš slibuje novou smlouvu, ve které Bůh zapíše zákon do "
       "srdce. Ježíš při poslední večeři říká, že nyní nastává. Proto "
       "se obě části Bible jmenují Starý a Nový zákon – latinsky "
       "testamentum, tedy „smlouva“."],
      ["Hebrejsky se smlouva „uzavírá“ slovesem „řezat“ (karat brit). "
       "Souvisí s obřadem, kdy strany procházely mezi rozpůlenými zvířaty "
       "(Gn 15,10).",
       "Slovo „zákon“ v názvech Starý a Nový zákon je staročeský překlad "
       "slova smlouva – ne „soubor paragrafů“."],
      ["Co mi říká, že Bůh se k lidem sám zavazuje sliby?",
       "Jak bych popsal svůj vztah s Bohem – spíš jako smlouvu, nebo "
       "jako obchod?"])

topic("kingdom", "story", "crown", "Boží království",
      "Hlavním tématem Ježíšova kázání bylo Boží království – Boží vláda, "
      "která přichází na zem. Už je tu, kde Ježíš uzdravuje a odpouští, "
      "a jednou se ukáže v plnosti.",
      [("Ž 145,13", "Tvé království je věčné"),
       ("Da 2,44", "Království, které nebude zničeno"),
       ("Mk 1,15", "Přiblížilo se Boží království"),
       ("Mt 6,10", "Přijď tvé království"),
       ("L 17,20-21", "Boží království je mezi vámi"),
       ("Ř 14,17", "Spravedlnost, pokoj a radost"),
       ("Zj 11,15", "Království světa patří našemu Pánu")],
      ["Království v Bibli neznamená hlavně území, ale vládu. Kde se děje "
       "Boží vůle, tam je jeho království. Proto Ježíš učí modlit se "
       "„přijď tvé království, buď vůle tvá“ – obě prosby říkají totéž "
       "dvakrát.",
       "Teologové mluví o napětí „už – ještě ne“. Království už přišlo "
       "v Ježíšovi (nemocní jsou uzdraveni, hříšníci přijati), ale ještě "
       "nedošlo naplnění (svět je stále plný bolesti). Křesťané žijí mezi "
       "těmito dvěma časy – jako lidé, kteří už vědí, jak příběh skončí."],
      ["Matouš píše většinou „království nebeské“ místo „Boží "
       "království“. Ze židovské úcty se vyhýbá častému vyslovování "
       "slova Bůh – význam je stejný.",
       "Daniel vidí sochu z různých kovů, kterou rozbije kámen „utržený "
       "bez lidských rukou“. Kámen roste v horu, která naplní zemi – "
       "obraz království, které začíná nenápadně."],
      ["Kde v mém okolí je vidět „kousek“ Božího království?",
       "Jakou oblast svého života Bohu zatím „nepustím vládnout“?"])

topic("law", "story", "book", "Zákon a Desatero",
      "Zákon (hebrejsky Tóra – „učení, návod“) nebyl dán, aby si ho lid "
      "zasloužil Boží lásku, ale jako odpověď na vysvobození z Egypta. "
      "Ježíš ho shrnuje do dvou přikázání lásky.",
      [("Ex 20,2-3", "Já jsem Hospodin, který tě vyvedl"),
       ("Dt 6,4-5", "Slyš, Izraeli"),
       ("Ž 119,105", "Tvé slovo je svítilnou"),
       ("Mi 6,8", "Co od tebe Hospodin žádá"),
       ("Mt 5,17", "Nepřišel jsem zrušit, ale naplnit"),
       ("Mt 22,37-40", "Největší přikázání"),
       ("Ř 13,10", "Láska je naplněním zákona"),
       ("Ga 3,24", "Zákon jako vychovatel ke Kristu")],
      ["Desatero začíná větou, kterou lidé často přeskakují: „Já jsem "
       "Hospodin, tvůj Bůh, který tě vyvedl z egyptské země, z domu "
       "otroctví.“ Nejprve přichází vysvobození, potom přikázání. Zákon "
       "je návod, jak žít svobodně a nevrátit se do otroctví.",
       "Židovská tradice napočítala v Tóře 613 přikázání. Ježíš na otázku, "
       "které je největší, odpovídá dvěma citáty z Tóry – o lásce k Bohu "
       "(Dt 6,5) a k bližnímu (Lv 19,18). Pavel pak ukazuje, že zákon "
       "sám člověka nezachrání, ale ukazuje, jak moc potřebuje milost."],
      ["Modlitba „Šema Jisrael“ (Slyš, Izraeli, Dt 6,4) je dodnes "
       "nejdůležitější modlitbou židovství; zbožní Židé ji říkají ráno "
       "a večer.",
       "Bible nikde nečísluje „deset přikázání“. Mluví o „deseti slovech“ "
       "(Ex 34,28), a různé církve je proto dělí trochu jinak."],
      ["Vnímám Boží přikázání spíš jako zábradlí, nebo jako břemeno?",
       "Které z Desatera je pro mě dnes nejaktuálnější?"])

topic("temple", "story", "temple", "Stánek a chrám",
      "Stánek na poušti a později chrám v Jeruzalémě byly místem, kde Bůh "
      "přebýval uprostřed lidu. Nový zákon ukazuje, že tím pravým chrámem "
      "je Ježíš – a skrze Ducha i jeho lid.",
      [("Ex 25,8-9", "Udělají mi svatyni"),
       ("Ex 40,34-35", "Sláva naplnila příbytek"),
       ("1Kr 8,27", "Nebesa tě nemohou pojmout"),
       ("Ž 84,2-3", "Jak milé jsou tvé příbytky"),
       ("J 2,19-21", "Zbořte tento chrám"),
       ("1K 3,16", "Jste Boží chrám"),
       ("1K 6,19", "Vaše tělo je chrámem Ducha"),
       ("Zj 21,22", "Chrám jsem v něm neviděl")],
      ["Stánek byl přenosná svatyně: nádvoří s oltářem, svatyně se "
       "svícnem a stolem chlebů a nejsvětější místo s truhlou smlouvy. "
       "Čím blíž ke středu, tím svatější a tím méně lidí smělo vstoupit. "
       "Do velesvatyně vcházel jen velekněz jednou za rok.",
       "Při Ježíšově smrti se opona chrámu roztrhla „odshora dolů“ "
       "(Mk 15,38) – jako by ji roztrhl Bůh sám. Cesta k Boží přítomnosti "
       "je otevřená. Proto Pavel může napsat, že chrámem je nyní "
       "společenství věřících i tělo jednotlivce."],
      ["Herodův chrám měl nádvoří o rozloze kolem 14 hektarů. Zeď "
       "nářků v Jeruzalémě je část opěrné zdi tohoto nádvoří.",
       "Kameny Herodova chrámu vážily i přes 100 tun. Učedníci "
       "obdivovali: „Hle, jaké kameny!“ (Mk 13,1) – a Ježíš předpověděl, "
       "že nezůstane kámen na kameni. Chrám byl zničen v roce 70."],
      ["Co pro mě znamená, že já sám a společenství církve jsme Božím "
       "chrámem?",
       "Jak zacházím se svým tělem, když je „chrámem Ducha“?"])

topic("sacrifice", "story", "flame", "Oběť",
      "Oběti ve Starém zákoně vyjadřovaly díky, smíření i společenství "
      "s Bohem. Proroci připomínali, že Bůh chce hlavně srdce. Nový "
      "zákon vidí v Ježíši jedinou dokonalou oběť, po které už další "
      "nejsou potřeba.",
      [("Gn 22,8", "Bůh si sám vyhlédne beránka"),
       ("Lv 17,11", "Život je v krvi"),
       ("Lv 16,21-22", "Kozel, který odnáší viny"),
       ("Ž 51,18-19", "Obětí Bohu je zkroušený duch"),
       ("Oz 6,6", "Chci milosrdenství, ne oběť"),
       ("Iz 53,7", "Jako beránek vedený na porážku"),
       ("Žd 10,10", "Jednou provždy"),
       ("Ř 12,1", "Vydejte svá těla jako živou oběť")],
      ["Kniha Leviticus popisuje několik druhů obětí. Zápalná oběť se "
       "celá spálila – znamenala úplné odevzdání. Pokojná oběť se z větší "
       "části snědla při slavnostní hostině – byla to společná večeře "
       "s Bohem. Oběť za hřích znamenala, že vina se nedá přejít mávnutím "
       "ruky; něco ji „stojí“.",
       "Proroci ostře kritizovali oběti bez proměněného života. List "
       "Židům pak vykládá, že všechny oběti ukazovaly dopředu na Krista. "
       "Křesťanská „oběť“ už není zvíře, ale chvála, dobročinnost "
       "a celý život vydaný Bohu."],
      ["Na Den smíření se vybírali dva kozli: jeden byl obětován, na "
       "druhého velekněz vložil hříchy lidu a vyhnal ho do pouště. "
       "Odtud pochází výraz „obětní beránek“ – anglicky scapegoat, "
       "„kozel, který unikl“.",
       "Oběti v jeruzalémském chrámu ustaly v roce 70, kdy Římané chrám "
       "zbořili. Židovství je od té doby nahradilo modlitbou, studiem "
       "a skutky milosrdenství."],
      ["Co by znamenalo nabídnout Bohu „živou oběť“ v obyčejném týdnu?",
       "Proč podle mě Bůh chce milosrdenství víc než oběti?"])

topic("messiah", "story", "crown", "Mesiáš – zaslíbený Král",
      "Starý zákon je plný slibů o přicházejícím zachránci: potomku ženy, "
      "Davidově synu, trpícím služebníku. Nový zákon zvěstuje, že tyto "
      "sliby se naplnily v Ježíši z Nazareta.",
      [("Gn 3,15", "Potomek ženy rozdrtí hadovi hlavu"),
       ("2S 7,12-13", "Davidův potomek a věčný trůn"),
       ("Iz 11,1-2", "Výhonek z pařezu Jišajova"),
       ("Iz 53,5", "Pro naše nepravosti byl proboden"),
       ("Za 9,9", "Tvůj král přichází na oslátku"),
       ("J 4,25-26", "To jsem já, který s tebou mluvím"),
       ("L 24,27", "Vykládal jim, co o něm psali proroci"),
       ("Sk 2,36", "Bůh ho učinil Pánem i Mesiášem")],
      ["V Ježíšově době čekali Židé mesiáše různě: jako krále, který "
       "vyžene Římany, jako kněze, nebo jako proroka podobného Mojžíšovi. "
       "Ježíš splnil očekávání nečekaným způsobem – na oslu místo na "
       "válečném koni, korunovaný trním.",
       "Učedníci z Emauz chápou Písmo nově, když jim vzkříšený Ježíš "
       "vykládá „od Mojžíše a všech proroků“, co se o něm psalo. Křesťané "
       "proto čtou Starý zákon jako příběh, který k Ježíši směřuje – ale "
       "který má svou hodnotu i sám o sobě."],
      ["Kumránské svitky ukazují, že tamní společenství čekalo dokonce "
       "dva mesiáše – královského a kněžského.",
       "Händelovo oratorium Mesiáš (1742) je celé sestaveno z biblických "
       "veršů – od Izajáše přes evangelia po Zjevení."],
      ["Jaká očekávání mám já od Ježíše – a v čem mě překvapuje?",
       "Který starozákonní slib o Mesiáši mě nejvíc oslovuje?"])

topic("exodus", "story", "water", "Exodus – Boží vysvobození",
      "Vyjití z Egypta je zakladatelský příběh Izraele: Bůh slyší křik "
      "otroků a vyvede je na svobodu. Proroci i Nový zákon se k němu "
      "neustále vracejí jako ke vzoru každé Boží záchrany.",
      [("Ex 3,7-8", "Viděl jsem bídu svého lidu"),
       ("Ex 12,13", "Krev na veřejích"),
       ("Ex 14,13-14", "Hospodin bude bojovat za vás"),
       ("Ex 15,1-2", "Mojžíšova píseň"),
       ("Iz 43,16-19", "Hle, činím nové věci"),
       ("L 9,30-31", "Mluvili o jeho odchodu"),
       ("1K 5,7", "Kristus, náš velikonoční beránek"),
       ("Zj 15,3", "Píseň Mojžíše a Beránka")],
      ["Exodus je víc než historka o útěku. Je to příběh o tom, že Bůh "
       "vidí utlačované a jedná. Izraelité si ho připomínají každý rok "
       "při Pesachu a mnoho přikázání začíná slovy: „Pamatuj, že jsi byl "
       "otrokem v Egyptě.“",
       "Ve vyprávění o proměnění na hoře mluví Mojžíš a Elijáš s Ježíšem "
       "o jeho „odchodu“ – v řečtině stojí přímo slovo exodos. Ježíšova "
       "smrt a vzkříšení jsou nový exodus: vysvobození z otroctví hříchu "
       "a smrti."],
      ["Spirituály afroamerických otroků jako „Go Down, Moses“ zpívaly "
       "o exodu jako o naději na vlastní svobodu.",
       "Hebrejské jméno moře, které Izrael přešel, je jam suf – „moře "
       "rákosí“. Kde přesně leželo, se dodnes diskutuje."],
      ["Z jakého „Egypta“ mě Bůh vyvedl – nebo potřebuji vyvést?",
       "Proč je důležité si Boží záchranu pravidelně připomínat?"])

topic("blessing", "story", "sun", "Požehnání",
      "Požehnat znamená přát a dávat život, který pochází od Boha. "
      "Bible začíná Božím požehnáním stvoření a Abraham je požehnán, "
      "aby se stal požehnáním pro všechny národy.",
      [("Gn 1,28", "Bůh jim požehnal"),
       ("Gn 12,2-3", "Budeš požehnáním"),
       ("Nu 6,24-26", "Áronské požehnání"),
       ("Ž 1,1-3", "Blaze člověku – strom u vody"),
       ("Jr 17,7-8", "Požehnaný, kdo doufá v Hospodina"),
       ("Mt 5,3-10", "Blahoslavení"),
       ("L 24,50-51", "Ježíš odchází, když žehná"),
       ("Ef 1,3", "Požehnání v Kristu")],
      ["Hebrejské slovo baruch („požehnaný“) souvisí se slovem koleno – "
       "možná proto, že se při požehnání klečelo. Požehnání v Bibli "
       "není jen hezké přání; když otec požehnal synovi, věřilo se, že "
       "slovo má skutečnou moc (proto Jákob tolik toužil po požehnání "
       "prvorozeného).",
       "Abraham je požehnán ne kvůli sobě, ale „abys byl požehnáním“. "
       "Požehnání má téct dál. Poslední, co učedníci vidí na zemi, je "
       "Ježíš se zdviženýma rukama, jak žehná – tak začíná čas církve."],
      ["V roce 1979 archeologové v Jeruzalémě našli dva malé stříbrné "
       "svitky z doby kolem roku 600 př. Kr. s textem áronského "
       "požehnání. Patří k nejstarším známým biblickým textům vůbec.",
       "Slovo „blahoslavený“ v Ježíšově kázání na hoře je řecky "
       "makarios – „šťastný, obdarovaný“, ne „svatý“."],
      ["Komu bych mohl tento týden „být požehnáním“?",
       "Zkuste dnes vyslovit ároňské požehnání (Nu 6,24-26) nad někým "
       "blízkým."])

topic("wisdom", "story", "lamp", "Moudrost",
      "Biblická moudrost není hlavně vzdělání, ale umění dobře žít "
      "před Bohem. Začíná bázní Hospodinovou a v Novém zákoně má tvář "
      "Ježíše Krista.",
      [("Př 1,7", "Počátek moudrosti je bázeň Hospodinova"),
       ("Př 3,5-6", "Doufej v Hospodina celým srdcem"),
       ("Př 4,7", "Získej moudrost"),
       ("Jb 28,28", "Kde se nalézá moudrost?"),
       ("Kaz 3,1", "Všechno má svůj čas"),
       ("Jk 1,5", "Komu chybí moudrost, ať prosí"),
       ("Jk 3,17", "Moudrost shůry"),
       ("1K 1,24-25", "Kristus – Boží moudrost")],
      ["Mudroslovné knihy (Přísloví, Job, Kazatel, Píseň písní a částečně "
       "Žalmy) mluví jinak než zákon nebo proroci. Méně „tak praví "
       "Hospodin“, více pozorování života: o práci, penězích, slovech, "
       "přátelství, lenosti. Přísloví říkají, co obvykle platí; Job "
       "a Kazatel ukazují, že život se do pouček nevejde vždy.",
       "Hebrejské slovo chochma se používalo i pro řemeslnou zručnost "
       "(Ex 31,3). Moudrý je ten, kdo umí „vyrobit“ dobrý život. "
       "Jakub slibuje, že o takovou moudrost může prosit kdokoli – a Bůh "
       "ji dává štědře."],
      ["„Bázeň Hospodinova“ neznamená strach, ale úctu – vědomí, že Bůh "
       "je Bůh a já nejsem.",
       "Přísloví 22,17–24,22 se nápadně podobají egyptskému spisu "
       "Ponaučení Amenemopeho. Izraelští mudrci zřejmě znali moudrost "
       "sousedních národů a přetvořili ji ve světle víry."],
      ["Ve kterém rozhodnutí teď potřebuji prosit o moudrost?",
       "Kdo je pro mě vzorem moudrého člověka – a proč?"])

topic("exile", "story", "compass", "Vyhnanství a návrat",
      "Babylonské vyhnanství byl největší otřes Izraele: chrám zničen, "
      "země ztracena. Ale právě v cizině se zrodila hluboká víra "
      "a naděje. Nový zákon nazývá křesťany „hosty a cizinci“ na cestě "
      "domů.",
      [("Ž 137,1-4", "U řek babylonských"),
       ("Jr 29,7", "Usilujte o pokoj města"),
       ("Jr 29,11", "Plány pokoje, ne neštěstí"),
       ("Ez 37,4-5", "Suché kosti oživnou"),
       ("Ezd 1,2-3", "Kýrův výnos o návratu"),
       ("Neh 8,8-10", "Radost Hospodinova je vaše síla"),
       ("Žd 11,13-16", "Cizinci a poutníci na zemi"),
       ("1Pt 2,11", "Jako hosté a cizinci")],
      ["V roce 586 př. Kr. Babyloňané dobyli Jeruzalém a odvedli velkou "
       "část obyvatel. Proroci vykládali katastrofu jako důsledek "
       "nevěrnosti, ale zároveň slibovali návrat. Jeremjáš psal "
       "vyhnancům překvapivě praktický dopis: stavte domy, sázejte "
       "zahrady, modlete se za město, kde žijete.",
       "Ve vyhnanství, bez chrámu, se víra soustředila na Písmo, sabat "
       "a modlitbu. Pravděpodobně tehdy vznikaly synagogy a byla "
       "shromážděna velká část Starého zákona. Těžká doba se stala "
       "obdobím hlubokého duchovního růstu."],
      ["Kýrův válec, hliněný válec z doby perského krále Kýra (dnes "
       "v Britském muzeu), popisuje jeho politiku návratu deportovaných "
       "národů a obnovy jejich svatyní – podobně jako Ezd 1.",
       "Verdiho sbor „Va, pensiero“ z opery Nabucco je inspirován "
       "Žalmem 137 a stal se neoficiální hymnou italského sjednocení."],
      ["Kde se cítím jako „v cizině“ – a jak tam mohu „usilovat "
       "o pokoj města“?",
       "Přinesla mi někdy těžká doba nečekaný duchovní růst?"])

# --- Člověk a spasení ------------------------------------------------------
topic("justification", "salvation", "scale", "Ospravedlnění",
      "Ospravedlnit je soudní pojem: soudce prohlásí obžalovaného za "
      "spravedlivého. Bible zvěstuje, že Bůh přijímá hříšníka ne pro "
      "jeho zásluhy, ale z milosti skrze víru v Krista.",
      [("Gn 15,6", "Uvěřil a bylo mu to počteno"),
       ("L 18,13-14", "Celník odešel ospravedlněn"),
       ("Ř 3,23-24", "Všichni zhřešili – ospravedlněni darem"),
       ("Ř 5,1", "Máme pokoj s Bohem"),
       ("Ga 2,16", "Ne ze skutků zákona"),
       ("Ef 2,8-10", "Milostí jste spaseni"),
       ("Fp 3,9", "Spravedlnost z víry"),
       ("Jk 2,17-18", "Víra bez skutků je mrtvá")],
      ["Pavel bojoval proti představě, že si člověk musí Boží přijetí "
       "zasloužit dodržováním předpisů. Ospravedlnění je dar: Kristova "
       "spravedlnost je „připsána“ tomu, kdo věří – jako když někdo "
       "splatí cizí dluh.",
       "Jakub na první pohled říká opak, ale řeší jiný problém: víru, "
       "která se nijak neprojeví. Pavel i Jakub se shodují, že pravá "
       "víra nese ovoce – Pavel hned za větou „milostí jste spaseni“ "
       "dodává, že jsme stvořeni „k dobrým skutkům“."],
      ["Martin Luther popisoval, jak mu verš „spravedlivý bude živ "
       "z víry“ (Ř 1,17) otevřel „brány ráje“. Tento objev stál "
       "u začátku reformace v roce 1517.",
       "V roce 1999 podepsaly katolická církev a Světový luterský svaz "
       "Společné prohlášení k nauce o ospravedlnění – po téměř 500 "
       "letech sporu."],
      ["Žiji z vědomí, že jsem přijat, nebo se Bohu pořád snažím "
       "něco dokázat?",
       "Jak se moje víra viditelně projevuje v činech?"])

topic("redemption", "salvation", "key", "Vykoupení a svoboda",
      "Vykoupit znamenalo zaplatit výkupné a osvobodit otroka nebo "
      "zajatce. Bible tak popisuje, co pro nás udělal Bůh: zaplatil "
      "vysokou cenu, abychom byli svobodní.",
      [("Ex 6,6", "Vykoupím vás vztaženou paží"),
       ("Rt 4,9-10", "Bóaz vykupuje Rút"),
       ("Iz 43,1", "Vykoupil jsem tě, jsi můj"),
       ("Mk 10,45", "Dát svůj život jako výkupné"),
       ("J 8,36", "Když vás Syn osvobodí"),
       ("Ga 5,1", "Pro svobodu nás Kristus osvobodil"),
       ("Ko 1,13-14", "Vysvobodil nás z moci tmy"),
       ("1Pt 1,18-19", "Ne stříbrem, ale drahou krví")],
      ["V Izraeli existovala postava „goel“ – vykupitel z příbuzenstva. "
       "Když člověk zchudl a prodal se do otroctví nebo přišel o půdu, "
       "měl ho nejbližší příbuzný vykoupit. Bóaz v knize Rút je takový "
       "vykupitel. Bůh se v Izajášovi sám nazývá goelem Izraele – "
       "nejbližším příbuzným, který se zaručí.",
       "Svoboda v Bibli neznamená dělat si, co chci. Pavel píše, že jsme "
       "osvobozeni k lásce a službě. Svoboda od hříchu je zároveň "
       "svoboda pro Boha a pro druhé."],
      ["Jób v nejhlubší bolesti volá: „Já vím, že můj Vykupitel (goel) "
       "žije“ (Jb 19,25). Händel z toho udělal jednu z nejslavnějších árií "
       "Mesiáše.",
       "V římském světě bylo otroctví běžné a otroci se mohli "
       "vykoupit. Slovo „výkupné“ (lytron) znali Ježíšovi posluchači "
       "z každodenního života."],
      ["Z čeho mě Kristus vykoupil – a k čemu mě osvobodil?",
       "Je v mém životě oblast, kde se stále chovám jako otrok?"])

topic("adoption", "salvation", "family", "Boží děti",
      "Bůh v Bibli není jen Stvořitel a Soudce, ale Otec. Kdo přijme "
      "Krista, je přijat do Boží rodiny – ne jako sluha, ale jako syn "
      "a dcera s plným právem dědictví.",
      [("Iz 49,15", "Zapomene matka na své dítě?"),
       ("Oz 11,1-4", "Učil jsem Efrajima chodit"),
       ("J 1,12", "Dal jim moc stát se Božími dětmi"),
       ("Ř 8,15-16", "Abba, Otče"),
       ("Ga 4,6-7", "Už nejsi otrok, ale syn"),
       ("Ef 1,5", "Předem určil, abychom byli jeho dětmi"),
       ("1J 3,1", "Hle, jak velikou lásku nám dal Otec")],
      ["V římském právu mělo adoptované dítě stejná práva jako "
       "vlastní – jeho dřívější dluhy zanikly a stalo se plným "
       "dědicem. Pavel tento obraz používá, aby ukázal, jak úplné je "
       "přijetí u Boha.",
       "Aramejské slovo Abba je důvěrné oslovení otce, které používaly "
       "i dospělé děti. Ježíš se tak modlí v Getsemane (Mk 14,36) a Duch "
       "svatý učí stejně se modlit i nás. Víra tak není jen přesvědčení, "
       "ale vztah."],
      ["Ozeáš 11 je jeden z nejněžnějších textů Bible: Bůh se popisuje "
       "jako rodič, který učí batole chodit, bere ho do náručí a sklání "
       "se, aby ho nakrmil.",
       "Hned za otázkou, zda matka může zapomenout na dítě, následuje "
       "Iz 49,16: „Vyryl jsem si tě do dlaní.“ Bůh má naše jméno stále "
       "na očích."],
      ["Jak se mění můj vztah k Bohu, když ho oslovím „Abba“?",
       "Je mi bližší vnímat se jako Boží služebník, nebo jako Boží "
       "dítě?"])

topic("growth", "salvation", "sprout", "Posvěcení a duchovní růst",
      "Víra není jednorázový zážitek, ale cesta. Bůh v člověku pracuje "
      "a proměňuje ho k podobě Kristově – pomalu, jako roste strom. "
      "Bible tomu říká posvěcení.",
      [("Ž 1,3", "Jako strom u vodních toků"),
       ("Ř 12,2", "Proměňujte se obnovou mysli"),
       ("2K 3,18", "Proměňováni z slávy do slávy"),
       ("Ga 5,22-23", "Ovoce Ducha"),
       ("Fp 1,6", "Kdo začal dobré dílo, dokoná ho"),
       ("Fp 2,12-13", "Bůh působí chtění i činění"),
       ("Žd 12,1-2", "Běžme vytrvale"),
       ("2Pt 3,18", "Rosťte v milosti a poznání")],
      ["Pavel mluví o „ovoci“ Ducha, ne o „výrobcích“. Ovoce neroste "
       "námahou, ale tím, že strom je napojen na zdroj. Člověk ovšem není "
       "pasivní: Fp 2,12-13 říká obojí najednou – „uskutečňujte svou "
       "spásu“, protože „Bůh ve vás působí“.",
       "Duchovní tradice popisují prostředky růstu: modlitbu, čtení "
       "Písma, společenství, službu, svátosti, ticho, zpověď. Nejsou "
       "to body ke splnění, ale „zahradnické nářadí“, které uvolňuje "
       "místo, kde může Bůh působit."],
      ["Ovoce Ducha je v řečtině v jednotném čísle – ne devět různých "
       "plodů, ale jedno ovoce s devíti chutěmi.",
       "Řecké slovo pro „proměňovat se“ v Ř 12,2 a 2K 3,18 "
       "(metamorfoó) je totéž jako při Ježíšově proměnění na hoře – "
       "odtud slovo metamorfóza."],
      ["Která „chuť“ ovoce Ducha ve mně teď nejvíc roste a která nejméně?",
       "Co je pro mě nejlepší „zahradnické nářadí“ duchovního růstu?"])

topic("doubt", "salvation", "help", "Pochybnosti a otázky",
      "Bible je plná lidí, kteří pochybovali, ptali se a stěžovali si – "
      "Jób, žalmisté, Habakuk, Jan Křtitel, Tomáš. Bůh je za to "
      "nezavrhuje. Pochybnost poctivě přinesená k Bohu může vést "
      "k hlubší víře.",
      [("Ž 13,2-3", "Jak dlouho, Hospodine?"),
       ("Abk 1,2", "Jak dlouho budu volat?"),
       ("Jb 23,3", "Kéž bych věděl, kde ho najdu"),
       ("Mt 11,2-6", "Jsi ten, který má přijít?"),
       ("Mt 14,30-31", "Proč jsi pochyboval?"),
       ("Mk 9,24", "Věřím, pomoz mé nevíře"),
       ("J 20,27-28", "Pán můj a Bůh můj"),
       ("Ju 1,22", "Smilujte se nad pochybujícími")],
      ["Třetina žalmů jsou nářky. Bible tedy počítá s tím, že věřící "
       "bude Bohu klást těžké otázky – a dává mu pro ně slova. "
       "Pochybnost se liší od nevěry: nevěra se od Boha odvrací, "
       "pochybnost se k němu obrací s otázkou.",
       "Tomáš je často nazýván „nevěřící“, ale jeho pochybnost vyústila "
       "v nejsilnější vyznání v evangeliích: „Pán můj a Bůh můj!“ "
       "Ježíš se mu nevysmívá, ukazuje mu své rány. Otec posedlého "
       "chlapce zase říká upřímnou modlitbu, kterou zná mnoho lidí: "
       "„Věřím, pomoz mé nevíře.“"],
      ["I Jan Křtitel, který Ježíše ohlásil, ve vězení zapochyboval. "
       "Ježíš ho nekárá, ale posílá mu svědectví – a vzápětí ho nazve "
       "největším z narozených z ženy.",
       "Matka Tereza podle svých dopisů zažívala dlouhá léta vnitřní "
       "tmy a pocitu Boží nepřítomnosti – a přesto vytrvala ve službě."],
      ["Kterou otázku bych Bohu chtěl upřímně položit?",
       "Komu v mém okolí bych mohl s pochybnostmi pomoci bez "
       "odsuzování?"])

# --- Život víry --------------------------------------------------------------
topic("hope", "life", "sunrise", "Naděje",
      "Biblická naděje není optimismus, že to nějak dopadne. Je to "
      "jistota postavená na Boží věrnosti a na Kristově vzkříšení – "
      "kotva, která drží i v bouři.",
      [("Ž 42,6", "Proč jsi skleslá, má duše?"),
       ("Pl 3,21-23", "Jeho milosrdenství je nové každé ráno"),
       ("Iz 40,31", "Kdo doufají v Hospodina, nabývají síly"),
       ("Ř 5,3-5", "Naděje neklame"),
       ("Ř 15,13", "Bůh naděje"),
       ("1Pt 1,3", "Živá naděje skrze vzkříšení"),
       ("Žd 6,19", "Naděje jako kotva duše")],
      ["Hebrejské slovo kava („doufat“) souvisí s napínáním provazu: "
       "naděje je napjaté čekání, které drží. Pláč Jeremjášův je kniha "
       "o zničeném Jeruzalémě – a přesto právě uprostřed ní stojí slova "
       "o Božím milosrdenství, které je nové každé ráno.",
       "Pavel spojuje naději se vzkříšením: kdyby Kristus nevstal, byla "
       "by víra marná. Křesťanská naděje se tedy neopírá o dobré "
       "okolnosti, ale o událost, která se už stala."],
      ["Kotva byla mezi prvními křesťanskými symboly – najdeme ji "
       "v římských katakombách, často spojenou s rybou.",
       "Pláč Jeremjášův je napsán jako abecední báseň: verše začínají "
       "postupně písmeny hebrejské abecedy. I zármutek dostal řád."],
      ["Na čem stojí moje naděje, když se daří a když se nedaří?",
       "Komu bych mohl dnes nabídnout trochu naděje?"])

topic("fear", "life", "shield", "Strach a odvaha",
      "„Neboj se“ je jedna z nejčastějších vět v Bibli. Bůh nebere "
      "strach na lehkou váhu, ale slibuje svou přítomnost – a odvaha "
      "pak není nepřítomnost strachu, ale krok vpřed navzdory němu.",
      [("Joz 1,9", "Buď silný a udatný"),
       ("Ž 27,1", "Hospodin je mé světlo – koho bych se bál?"),
       ("Ž 56,4", "Když mám strach, doufám v tebe"),
       ("Iz 43,1-2", "Neboj se, půjdeš-li přes vody"),
       ("Mt 14,27", "Vzmužte se, já jsem to"),
       ("J 14,27", "Ať se vaše srdce nechvěje"),
       ("2Tm 1,7", "Duch síly, lásky a rozvahy"),
       ("1J 4,18", "Dokonalá láska zahání strach")],
      ["Jozue dostal výzvu „buď silný a udatný“ třikrát za sebou – což "
       "naznačuje, že se bál. Boží odpověď není „neboj se, protože to "
       "bude snadné“, ale „neboj se, protože já jsem s tebou“.",
       "Bible rozlišuje mezi strachem a „bázní Boží“. Kdo má úctu "
       "k Bohu, nemusí se bát lidí. Ježíš v Getsemane ukazuje, že "
       "i strach se dá přinést v modlitbě – a pak jít dál."],
      ["Říká se, že „neboj se“ je v Bibli 365krát – pro každý den "
       "jeden. Přesné číslo záleží na překladu a počítání, ale výzev "
       "ke statečnosti je opravdu mnoho.",
       "Andělé při zjevení skoro vždy začínají slovy „Neboj se“ – "
       "u Zachariáše, Marie, pastýřů i žen u hrobu."],
      ["Čeho se teď nejvíc bojím a co by znamenalo udělat krok "
       "navzdory strachu?",
       "Jak mi může pomoci vědomí Boží přítomnosti v konkrétní "
       "obavě?"])

topic("worry", "life", "cloud", "Starosti a úzkost",
      "Ježíš mluví o starostech velmi lidsky: o jídle, oblečení "
      "i zítřku. Nezakazuje plánovat, ale zve k důvěře v Otce, který "
      "zná naše potřeby. Starosti máme Bohu „předávat“.",
      [("Ž 55,23", "Svěř Hospodinu své břemeno"),
       ("Mt 6,25-27", "Pohleďte na ptáky"),
       ("Mt 6,33-34", "Hledejte nejprve Boží království"),
       ("L 10,41-42", "Marto, máš starost o mnoho věcí"),
       ("Fp 4,6-7", "Se vším se obracejte k Bohu"),
       ("1Pt 5,7", "Všechnu starost vložte na něj")],
      ["Řecké slovo merimna („starost“) souvisí se slovesem "
       "„rozdělit“. Ustaraný člověk je rozpolcený – myslí na zítřek, "
       "ale žije dnes. Ježíš nabízí jednoduchou radu: každý den má "
       "dost svého trápení.",
       "Pavel ve Filipským nepíše „nemějte problémy“, ale ukazuje "
       "postup: modlitba, prosba, díkůvzdání – a pak přichází Boží pokoj, "
       "který „střeží“ srdce jako stráž. Pavel to psal ve vězení."],
      ["Izraelem každoročně protáhnou stovky milionů stěhovavých ptáků. "
       "Ptáci na nebi, na které Ježíš ukazuje, byli pro jeho posluchače "
       "všedním obrazem.",
       "„Vložte“ v 1Pt 5,7 je stejné řecké sloveso, jakým se popisuje "
       "házení plášťů na oslátko při vjezdu do Jeruzaléma (L 19,35)."],
      ["Kterou starost bych dnes mohl Bohu konkrétně „předat“?",
       "Co mi pomáhá žít tento den, a ne zítřek?"])

topic("worship", "life", "music", "Chvála a uctívání",
      "Uctívat znamená dát Bohu to, co mu patří – úctu, lásku "
      "a vděčnost. Bible je plná písní, a chvála v ní nezní jen "
      "v kostele, ale celým životem.",
      [("Ex 15,20-21", "Mirjam tančí s bubínkem"),
       ("Ž 95,6", "Pojďte, poklekněme"),
       ("Ž 100,1-2", "Služte Hospodinu s radostí"),
       ("Ž 150,6", "Všechno, co dýchá, ať chválí"),
       ("J 4,23-24", "V Duchu a v pravdě"),
       ("Ko 3,16", "Zpívejte žalmy a duchovní písně"),
       ("Žd 13,15", "Oběť chvály"),
       ("Zj 4,11", "Hoden jsi, Pane")],
      ["Kniha Žalmů byla zpěvníkem Izraele. Obsahuje radostné chvály "
       "i nářky – Bible tedy zve přinášet Bohu celé srdce, nejen "
       "dobrou náladu. Hebrejské halal („chválit“) dalo vzniknout slovu "
       "haleluja – „chvalte Hospodina“.",
       "Ježíš samařské ženě říká, že na místě (hora nebo Jeruzalém) "
       "nezáleží tolik jako na tom, zda Boha uctíváme „v Duchu "
       "a v pravdě“. Pavel pak zve vydat celé tělo jako „rozumnou "
       "bohoslužbu“ (Ř 12,1) – i práce a vztahy mohou být chválou."],
      ["Žalmy obsahují hudební pokyny, kterým dnes plně nerozumíme, "
       "např. „sela“ – možná pauza, opakování nebo zesílení hudby.",
       "Kniha Žalmů je rozdělena na pět knih (1–41, 42–72, 73–89, 90–106, "
       "107–150) – možná jako ozvěna pěti knih Mojžíšových."],
      ["Kdy naposledy jsem Boha chválil, i když se mi nechtělo?",
       "Jak by mohla být chválou moje práce zítra?"])

topic("speech", "life", "chat", "Slova a jazyk",
      "Bible připisuje slovům obrovskou moc: Bůh stvořil svět slovem "
      "a lidská slova mohou zraňovat i uzdravovat. Kniha Přísloví "
      "a list Jakubův jsou plné praktických rad o mluvení.",
      [("Př 15,1", "Vlídná odpověď odvrací hněv"),
       ("Př 18,21", "Smrt i život jsou v moci jazyka"),
       ("Př 25,11", "Slovo v pravý čas"),
       ("Mt 12,34", "Z plnosti srdce mluví ústa"),
       ("Ef 4,29", "Jen slova, která budují"),
       ("Ko 4,6", "Řeč vždy laskavá, solí okořeněná"),
       ("Jk 1,19", "Rychlý k naslouchání, pomalý k mluvení"),
       ("Jk 3,5-6", "Malý oheň zapálí velký les")],
      ["Jakub přirovnává jazyk ke kormidlu, které řídí velkou loď, "
       "a k jiskře, která zapálí les. Přitom si nedělá iluze: „jazyk "
       "nikdo z lidí nedokáže zkrotit.“ Proto Ježíš míří hlouběji – "
       "slova vycházejí ze srdce, a proměna řeči začíná proměnou srdce.",
       "Bible dává jednoduchý test: budují má slova, jsou pravdivá "
       "a jsou řečena v pravý čas? Přísloví upozorňují také na mlčení – "
       "„i hlupák, když mlčí, je pokládán za moudrého“ (Př 17,28)."],
      ["„Řeč solí okořeněná“ – sůl chránila jídlo před zkažením "
       "a dodávala mu chuť. Řeč má být čistá i zajímavá.",
       "V hebrejštině je „slovo“ (davar) zároveň „věc, událost“. Slovo "
       "něco dělá, není jen zvuk."],
      ["Které moje slovo z poslední doby by potřebovalo omluvu?",
       "Komu bych dnes mohl říct slovo, které ho povzbudí?"])

topic("anger", "life", "flame", "Hněv a sebeovládání",
      "Hněv sám o sobě nemusí být hřích – hněvá se i Bůh a Ježíš. "
      "Problém je hněv, který ovládá nás, živí se a ubližuje. Bible "
      "učí hněv přiznat, zpomalit a nenechat nad sebou zapadnout slunce.",
      [("Gn 4,6-7", "Hřích číhá u dveří"),
       ("Př 16,32", "Lepší ovládat sebe než dobýt město"),
       ("Př 29,11", "Hlupák dá průchod hněvu"),
       ("Jon 4,4", "Je správné, že se tak hněváš?"),
       ("Mk 3,5", "Ježíš se s hněvem rozhlédl"),
       ("Ef 4,26-27", "Ať nad vaším hněvem nezapadne slunce"),
       ("Jk 1,19-20", "Pomalý k hněvu"),
       ("Ko 3,8", "Odložte hněv a zlobu")],
      ["Bůh se Kaina ptá: „Proč se hněváš?“ a varuje ho, že hřích číhá "
       "u dveří jako zvíře. Kain otázku ignoruje – a hněv vyústí "
       "v první vraždu. Bůh se podobně ptá i Jonáše. Otázka je pozvánka "
       "podívat se, co je pod hněvem: zranění, strach, žárlivost.",
       "Ježíš se hněval na tvrdost srdcí, která bránila uzdravení "
       "člověka. Spravedlivý hněv se zastává druhých; sobecký hněv "
       "brání sám sebe. Pavel radí řešit konflikt brzy – než se hněv "
       "uloží a začne hnít."],
      ["Bůh je v Bibli opakovaně popisován jako „pomalý k hněvu“ "
       "(Ex 34,6) – hebrejsky doslova „dlouhého nosu“: trvá dlouho, než "
       "se nos zčervená a „vzplane“.",
       "„Ať nad vaším hněvem nezapadne slunce“ – v židovském pojetí "
       "začínal západem slunce nový den. Nenést hněv do dalšího dne."],
      ["Co se obvykle skrývá pod mým hněvem?",
       "Je někdo, s kým bych měl konflikt vyřešit dřív, než zapadne "
       "slunce?"])

topic("patience", "life", "hourglass", "Trpělivost a čekání",
      "Bible je kniha čekání: Abraham čeká na syna, Izrael na vysvobození, "
      "proroci na Mesiáše, církev na Kristův návrat. Trpělivost v ní "
      "není pasivita, ale aktivní důvěra, že Bůh jedná v pravý čas.",
      [("Ž 27,14", "Očekávej Hospodina"),
       ("Ž 40,2-4", "Trpělivě jsem čekal"),
       ("Pl 3,25-26", "Dobré je mlčky čekat"),
       ("Iz 40,31", "Kdo čekají na Hospodina"),
       ("Ř 12,12", "V soužení trpěliví"),
       ("Ga 6,9", "V pravý čas budeme sklízet"),
       ("Jk 5,7-8", "Jako rolník čeká na úrodu"),
       ("2Pt 3,9", "Pán neotálí")],
      ["Jakub dává příklad rolníka: zaseje a pak čeká na „ranní a pozdní "
       "déšť“. V Izraeli padal podzimní déšť po setí a jarní před "
       "sklizní. Rolník nemůže déšť přivolat, ale může připravit pole "
       "a vytrvat. Trpělivost tedy není nečinnost.",
       "Petr vysvětluje, proč se Kristův návrat „opožďuje“: Bůh je "
       "trpělivý, protože chce, aby se všichni obrátili. Boží "
       "„zpoždění“ je projev milosrdenství."],
      ["Mezi Božím slibem Abrahamovi a narozením Izáka uplynulo asi 25 "
       "let. Mezi Josefovým snem a jeho naplněním přibližně 22 let.",
       "Trpělivost (makrothymia) znamená řecky doslova „dlouhý dech“ "
       "nebo „dlouhá mysl“."],
      ["Na co teď čekám a jak to čekání prožívám?",
       "Co mohu dělat, zatímco čekám – jako rolník, který připravuje "
       "pole?"])

topic("silence", "life", "pray", "Ztišení a půst",
      "Bůh často nemluví v hluku, ale v tichu. Bible zná půst, samotu "
      "a ztišení jako cesty, jak uvolnit místo pro Boha – ne jako výkon, "
      "ale jako hlad po něm.",
      [("1Kr 19,11-12", "Hlas tichého vánku"),
       ("Ž 46,11", "Ztište se a poznejte, že já jsem Bůh"),
       ("Ž 62,2", "Jen v Bohu se ztiší má duše"),
       ("Iz 58,6-7", "Půst, který si přeji"),
       ("Jl 2,12-13", "Roztrhněte srdce, ne roucha"),
       ("Mt 6,16-18", "Když se postíte"),
       ("Mk 1,35", "Ježíš odešel na pusté místo"),
       ("Sk 13,2-3", "Postili se a modlili")],
      ["Izajáš 58 je ostrou kritikou půstu, při kterém se lidé "
       "trápí, ale dál utlačují dělníky. Bůh chce půst, který rozvazuje "
       "pouta, sytí hladové a otevírá dveře bezdomovcům. Skutečný půst "
       "nás má udělat citlivějšími k Bohu i lidem.",
       "Ježíš se často stahoval do samoty – před důležitými rozhodnutími, "
       "po náročném dni, v noci. Pokud to potřeboval on, potřebujeme to "
       "my tím spíš. Půst a ztišení nemusí být jen od jídla – lze se "
       "postit i od telefonu, zpráv nebo hluku."],
      ["V Ježíšově době se zbožní farizeové postili dvakrát týdně, "
       "v pondělí a ve čtvrtek. Didaché, raně křesťanský spis, radí "
       "postit se ve středu a v pátek.",
       "Ž 46,11 hebrejsky doslova říká „pusťte, nechte toho“ – výzva "
       "přestat bojovat a uvolnit sevřené ruce."],
      ["Kdy mám ve svém dni chvíli ticha?",
       "Od čeho bych se mohl tento týden „postit“, abych měl víc "
       "prostoru pro Boha?"])

topic("service", "life", "handshake", "Služba druhým",
      "Ježíš obrátil představy o velikosti naruby: největší je ten, kdo "
      "slouží. Sám umyl učedníkům nohy. Křesťanská služba vychází "
      "z vděčnosti a vidí Krista v nejmenších.",
      [("Mk 10,43-45", "Kdo chce být velký, buď služebníkem"),
       ("J 13,14-15", "Myjte si nohy navzájem"),
       ("Mt 25,35-40", "Mně jste to učinili"),
       ("Ř 12,11", "Služte Pánu s horlivostí"),
       ("Ga 5,13", "Služte si navzájem v lásce"),
       ("Fp 2,3-4", "Hleďte na zájmy druhých"),
       ("1Pt 4,10", "Služte druzí druhým darem, který jste přijali")],
      ["Mytí nohou bylo prací otroků. Když si učedníci mezi sebou "
       "řešili, kdo je největší, Ježíš si svlékl plášť, opásal se "
       "zástěrou a vzal umyvadlo. Neřekl jen „služte“, ale ukázal, "
       "jak vypadá služba, při které se nikdo nedívá.",
       "V Mt 25 jsou spravedliví překvapeni: „Kdy jsme tě viděli "
       "hladového?“ Nesloužili proto, aby si získali odměnu – prostě "
       "pomáhali. Ježíš se ztotožňuje s nejmenšími, takže služba "
       "člověku v nouzi je služba jemu."],
      ["Slovo „diakon“ pochází z řeckého diakonos – „ten, kdo obsluhuje "
       "u stolu“. Diakonie je dodnes název pro sociální službu církví.",
       "Některé církve na Zelený čtvrtek dodnes myjí nohy – papež, "
       "biskupové i faráři to dělají lidem ve vězení, nemocným "
       "a chudým."],
      ["Komu bych mohl tento týden „umýt nohy“ – posloužit tam, kde to "
       "nikdo neocení?",
       "Sloužím rád, nebo spíš čekám, až mi někdo poděkuje?"])

topic("contentment", "life", "spa", "Spokojenost",
      "V době reklam a srovnávání je spokojenost vzácná. Pavel píše, "
      "že se jí „naučil“ – v nedostatku i hojnosti. Tajemstvím není "
      "mít všechno, ale mít toho, který dává sílu.",
      [("Př 30,8-9", "Nedávej mi chudobu ani bohatství"),
       ("Kaz 5,9", "Kdo miluje peníze, nenasytí se"),
       ("L 12,15", "Život nezávisí na majetku"),
       ("Fp 4,11-13", "Naučil jsem se být spokojený"),
       ("1Tm 6,6-8", "Zbožnost se spokojeností je velký zisk"),
       ("Žd 13,5", "Nikdy tě neopustím")],
      ["Pavel psal o spokojenosti z vězení, kde závisel na darech "
       "přátel. Slovo „naučil jsem se“ ukazuje, že spokojenost není "
       "povaha, ale dovednost, kterou lze trénovat – hlavně "
       "vděčností a důvěrou.",
       "List Židům spojuje spokojenost s Božím slibem „nikdy tě "
       "neopustím“. Kdo ví, že má Boha, nemusí se tolik bát, že mu "
       "něco chybí. Desáté přikázání „nebudeš dychtit“ chrání právě "
       "tento vnitřní pokoj."],
      ["Řecké slovo autarkés („spokojený“) používali stoičtí filosofové "
       "pro soběstačnost. Pavel ho přebírá, ale mění: není soběstačný, "
       "je „Kristosoběstačný“ – „všechno mohu v tom, který mi dává sílu“.",
       "Agurova modlitba (Př 30,8-9) je jediné místo v Bibli, kde "
       "někdo prosí, aby nebyl bohatý."],
      ["Za co mohu dnes poděkovat místo srovnávání s druhými?",
       "Co mi bere spokojenost nejčastěji?"])

topic("guidance", "life", "signpost", "Rozhodování a Boží vedení",
      "Jak poznat Boží vůli? Bible nedává kouzelný návod, ale ukazuje "
      "cestu: Písmo, modlitba, rada moudrých lidí, vnitřní pokoj "
      "a ochota poslechnout. Bůh vede ty, kdo jsou ochotní jít.",
      [("Ž 32,8", "Budu tě vyučovat cestě"),
       ("Př 3,5-6", "On napřímí tvé stezky"),
       ("Př 15,22", "Bez porady plány selhávají"),
       ("Iz 30,21", "Toto je cesta, jděte po ní"),
       ("Sk 16,6-10", "Zavřené a otevřené dveře"),
       ("Ř 12,2", "Rozpoznávat, co je vůle Boží"),
       ("Ko 3,15", "Pokoj Kristův ať rozhoduje"),
       ("Jk 1,5", "Proste o moudrost")],
      ["Pavel na druhé cestě chtěl jít jinam, ale Duch mu „nedovolil“. "
       "Teprve po dvou zavřených dveřích přišel sen o Makedonci – "
       "a evangelium vstoupilo do Evropy. Boží vedení se často ukazuje "
       "za pochodu, ne v kompletní mapě dopředu.",
       "Ko 3,15 používá slovo z antických her: pokoj má být „rozhodčím“ "
       "v našem srdci. Velkou část Boží vůle už známe z Písma (milovat, "
       "být poctivý, odpouštět); v tom, co Písmo neříká, máme svobodu "
       "rozhodnout se moudře."],
      ["Velekněz měl v náprsníku urím a tumím – předměty, jimiž se "
       "hledala Boží odpověď „ano/ne“. Po exilu se přestaly používat "
       "a jak přesně fungovaly, nevíme.",
       "Učedníci losovali o nástupci Jidáše (Sk 1,26). Je to poslední "
       "zmínka o losování v Bibli – po seslání Ducha se rozhoduje "
       "společně a v modlitbě (Sk 15,28)."],
      ["Před jakým rozhodnutím teď stojím a koho bych mohl požádat "
       "o radu?",
       "Je něco, co z Písma už vím, ale nechce se mi to udělat?"])

# --- Vztahy a společnost -----------------------------------------------------
topic("strangers", "relations", "explore", "Cizinci a pohostinnost",
      "Izrael měl pamatovat, že byl sám cizincem v Egyptě – proto má "
      "chránit cizince. Pohostinnost je v Bibli posvátná povinnost; "
      "kdo hostí cizince, může přijmout anděly i Krista.",
      [("Gn 18,2-5", "Abraham hostí tři muže"),
       ("Lv 19,33-34", "Miluj cizince jako sebe"),
       ("Dt 10,18-19", "Bůh miluje cizince"),
       ("Rt 2,10", "Proč si mě všímáš, cizinky?"),
       ("Mt 25,35", "Byl jsem cizincem a ujali jste se mě"),
       ("Ř 12,13", "Pohostinnost pěstujte"),
       ("Žd 13,2", "Někteří tak pohostili anděly"),
       ("1Pt 4,9", "Bez reptání")],
      ["Ve starověkém Orientu znamenala pohostinnost přežití: na poušti "
       "nebyly hotely a odmítnout pocestného mohlo znamenat jeho smrt. "
       "Hostitel měl povinnost chránit hosta i za cenu vlastního "
       "nebezpečí. Abraham běží, aby pohostil neznámé, a přijímá tak "
       "samotného Hospodina.",
       "Kniha Rút je příběh cizinky z nepřátelského národa, kterou "
       "Bóaz přijme – a ona se stane prababičkou krále Davida "
       "a předkyní Ježíše. Řecké slovo pro pohostinnost filoxenia "
       "znamená doslova „láska k cizímu“."],
      ["Zákon Izraele zmiňuje ochranu cizince více než třicetkrát, "
       "často spolu se sirotkem a vdovou – trojicí nejzranitelnějších.",
       "Rublevova ikona Trojice (15. století) zobrazuje tři anděly "
       "u Abrahamova stolu – a jedno místo u stolu zůstává otevřené "
       "divákovi."],
      ["Kdo je v mém okolí „cizinec“, který potřebuje přijetí?",
       "Kdy jsem naposledy pozval někoho, kdo mi to nemůže oplatit?"])

topic("truth", "relations", "scale", "Pravda a poctivost",
      "Bůh je Bůh pravdy a Ježíš o sobě říká „Já jsem pravda“. Lež "
      "ničí důvěru, na které stojí každý vztah. Bible volá k poctivosti "
      "ve slovech, obchodu i v tom, co nikdo nevidí.",
      [("Ex 20,16", "Nevydáš křivé svědectví"),
       ("Lv 19,35-36", "Spravedlivé váhy"),
       ("Př 12,22", "Lživé rty jsou Hospodinu ohavností"),
       ("Za 8,16", "Mluvte pravdu jeden s druhým"),
       ("Mt 5,37", "Vaše ano ať je ano"),
       ("J 8,32", "Pravda vás osvobodí"),
       ("Ef 4,15", "Pravda v lásce"),
       ("Ef 4,25", "Odložte lež")],
      ["Hebrejské slovo emet („pravda“) znamená i „spolehlivost, "
       "věrnost“. Pravdivý člověk je ten, na koho se dá spolehnout – "
       "stejně jako na Boha. Odtud pochází i slovo „amen“: „ano, je to "
       "spolehlivé“.",
       "Pavel spojuje pravdu a lásku: „mluvit pravdu v lásce“. Pravda "
       "bez lásky je krutá, láska bez pravdy je falešná. Ježíš "
       "v kázání na hoře jde dál než zákon: kdo je vždy pravdivý, "
       "nemusí přísahat."],
      ["Obchodníci ve starověku nosili v měšci dvě sady závaží – "
       "lehčí pro prodej, těžší pro nákup. Zákon to výslovně zakazoval "
       "(Dt 25,13).",
       "Slova „Pravda vítězí“ na české prezidentské standartě "
       "navazují na husitské heslo; Jan Hus psal: „Hledaj pravdu, "
       "slyš pravdu, uč sě pravdě, miluj pravdu…“"],
      ["Kde je pro mě nejtěžší být úplně pravdivý?",
       "Jak mohu říct těžkou pravdu s láskou?"])

topic("reconciliation", "relations", "handshake", "Konflikty a smíření",
      "Bible nezakrývá konflikty – i mezi bratry a apoštoly. Ale "
      "ukazuje cestu ke smíření: jít za druhým, mluvit přímo, "
      "odpustit. Bůh nás smířil se sebou, a proto nás posílá smiřovat.",
      [("Gn 33,4", "Ezau běží Jákobovi vstříc"),
       ("Gn 45,4-5", "Josef se dává poznat bratrům"),
       ("Mt 5,23-24", "Nejdřív se smiř s bratrem"),
       ("Mt 18,15", "Jdi a promluv si s ním mezi čtyřma očima"),
       ("Ř 12,18", "Pokud to záleží na vás, žijte v pokoji"),
       ("2K 5,18-19", "Služba smíření"),
       ("Fp 4,2-3", "Evodie a Syntyché"),
       ("Ko 3,13", "Snášejte se a odpouštějte si")],
      ["Ježíš dává jasný postup (Mt 18,15-17): nejdřív mluvit osobně "
       "a v soukromí, ne za zády. Pokud to nepomůže, přizvat jednoho "
       "či dva svědky, teprve potom společenství. Většina konfliktů "
       "se zhorší, když o nich mluvíme s ostatními místo s tím, koho "
       "se týkají.",
       "Ř 12,18 je realistické: „pokud to záleží na vás“. Smíření "
       "potřebuje dvě strany a ne vždy se podaří. My však můžeme udělat "
       "svůj díl – a odpustit i tam, kde druhý nepřijde."],
      ["Pavel ve Filipským jmenovitě prosí dvě ženy, Evodii a Syntyché, "
       "aby se usmířily. Obě s ním „bojovaly za evangelium“ – i dobří "
       "spolupracovníci se mohou pohádat.",
       "Pavel a Barnabáš se rozešli kvůli sporu o Marka (Sk 15,39). "
       "Později Pavel píše, že je mu Marek „užitečný ve službě“ "
       "(2Tm 4,11) – vztahy se mohou uzdravit i po letech."],
      ["S kým bych měl udělat první krok ke smíření?",
       "Mluvím o problémech s lidmi přímo, nebo spíš o nich s jinými?"])

topic("creation_care", "relations", "sprout", "Péče o stvoření",
      "Země patří Hospodinu a člověk ji dostal do správy – ne "
      "k vydrancování, ale „aby ji obdělával a střežil“. Bible "
      "pamatuje i na zvířata a slibuje vysvobození celého stvoření.",
      [("Gn 1,28", "Panujte nad zemí"),
       ("Gn 2,15", "Obdělávat a střežit zahradu"),
       ("Lv 25,23", "Země je moje"),
       ("Ž 24,1", "Hospodinova je země"),
       ("Jb 12,7-10", "Zeptej se zvířat"),
       ("Př 12,10", "Spravedlivý dbá o svůj dobytek"),
       ("L 12,6", "Ani jeden vrabec není zapomenut"),
       ("Ř 8,19-21", "Stvoření čeká na vysvobození")],
      ["„Panovat“ v Gn 1 je třeba číst spolu s Gn 2,15: člověk má zahradu "
       "„obdělávat a střežit“. Hebrejská slovesa avad a šamar se "
       "jinde používají pro službu Bohu a zachovávání přikázání. "
       "Vláda nad zemí je tedy služba, ne vykořisťování.",
       "Zákon předepisoval sabatní rok: každý sedmý rok měla půda "
       "odpočívat (Lv 25,4). Dokonce i dobytek měl nárok na sabat. "
       "Pavel v Římanům 8 vidí stvoření jako ženu v porodních bolestech, "
       "která čeká na nové narození."],
      ["Zákon zakazoval brát z hnízda matku spolu s mláďaty "
       "(Dt 22,6-7) a zavazovat ústa volu, který mlátí obilí "
       "(Dt 25,4).",
       "František z Assisi (13. stol.) složil Píseň bratra Slunce. "
       "V roce 1979 byl vyhlášen patronem ekologie."],
      ["Jak se moje víra projevuje v tom, jak zacházím s přírodou?",
       "Co mi o Bohu říká stvoření kolem mě?"])

topic("age", "relations", "person", "Stáří a generace",
      "Bible si váží stáří: šediny jsou „korunou slávy“. Starší mají "
      "předávat víru, mladší jim prokazovat úctu. A Bůh slibuje, že "
      "bude nést své lidi i ve stáří.",
      [("Lv 19,32", "Povstaň před šedinami"),
       ("Ž 71,17-18", "Ani ve stáří mě neopouštěj"),
       ("Ž 92,13-15", "I ve stáří ponesou ovoce"),
       ("Př 16,31", "Šediny jsou korunou slávy"),
       ("Iz 46,4", "Až do šedin vás ponesu"),
       ("Jl 3,1", "Vaši starci budou mít sny"),
       ("L 2,36-38", "Prorokyně Anna"),
       ("Tt 2,2-4", "Starší učí mladší")],
      ["V tradiční společnosti byli starší strážci paměti a moudrosti. "
       "Ve „vratech města“ zasedali starší a rozsuzovali spory. "
       "Žalm 71 je modlitba stárnoucího člověka, který chce „zvěstovat "
       "Boží sílu dalšímu pokolení“.",
       "Simeon a Anna v chrámu jsou jedni z prvních, kdo poznávají "
       "Ježíše. Anně bylo přes 80 let. Bible nevidí stáří jako konec "
       "užitečnosti – Abraham, Mojžíš i Zachariáš dostali své největší "
       "úkoly ve vysokém věku."],
      ["Mojžíšovi bylo 80 let, když stál před faraonem (Ex 7,7).",
       "Jl 3,1 (v některých překladech 2,28) slibuje sny starcům "
       "i vidění mladíkům – Petr tento text cituje o Letnicích."],
      ["Co jsem se naučil od starších lidí ve víře?",
       "Komu z mladší generace mohu předat, co jsem s Bohem prožil?"])

topic("children", "relations", "family", "Děti",
      "Děti jsou v Bibli darem a požehnáním. Ježíš je bral do náruče "
      "a postavil je doprostřed jako vzor: kdo nepřijme Boží království "
      "jako dítě, nevejde do něj.",
      [("Ž 127,3", "Synové jsou dědictví od Hospodina"),
       ("Ž 139,13-14", "Utkal jsi mě v lůně mé matky"),
       ("1S 3,10", "Mluv, tvůj služebník slyší"),
       ("Př 22,6", "Vychovávej dítě na začátku cesty"),
       ("Mt 18,2-4", "Budete-li jako děti"),
       ("Mk 10,14-16", "Nechte děti přicházet ke mně"),
       ("Ef 6,4", "Nepopouzejte své děti"),
       ("2Tm 3,15", "Od dětství znáš svatá Písma")],
      ["V antickém světě děti neměly velkou hodnotu – nechtěné děti "
       "se často pohazovaly. Ježíšovo jednání bylo převratné: učedníci "
       "děti odhánějí, on se rozhněvá a žehná jim. Dítě je pro něj vzor "
       "důvěry a závislosti, ne „nehotový člověk“.",
       "Bůh mluví i k dětem: Samuel slyší Boží hlas jako chlapec, "
       "David je nejmladší syn, Timotej zná Písmo od dětství díky babičce "
       "Loidě a matce Euniké. Víra se předává hlavně v rodině "
       "a příkladem."],
      ["Didaché, křesťanský spis z konce 1. století, výslovně zakazuje "
       "potrat i odkládání novorozenců – raní křesťané často "
       "zachraňovali pohozené děti.",
       "Slovo „vychovávej“ v Př 22,6 (chanach) se používá i pro "
       "„zasvěcení“ chrámu. Odtud název svátku Chanuka."],
      ["Co se mohu naučit od dětské důvěry?",
       "Jak mohu podpořit víru dětí ve svém okolí?"])

# --- Církev ----------------------------------------------------------------
topic("gifts", "church", "gift", "Duchovní dary",
      "Každý křesťan dostal od Ducha svatého nějaký dar – ne pro sebe, "
      "ale pro druhé. Církev je jako tělo: každý úd je jiný a každý "
      "je potřebný.",
      [("Sk 2,4", "Naplněni Duchem svatým"),
       ("Ř 12,6-8", "Máme různé dary podle milosti"),
       ("1K 12,4-7", "Různé dary, týž Duch"),
       ("1K 12,21-22", "Oko nemůže říct ruce"),
       ("1K 13,1-2", "Bez lásky nejsem nic"),
       ("Ef 4,11-12", "K budování těla Kristova"),
       ("1Pt 4,10-11", "Dobří správci milosti")],
      ["Pavel uvádí různé seznamy darů – proroctví, vyučování, "
       "povzbuzování, štědrost, vedení, milosrdenství, uzdravování, "
       "jazyky… Žádný seznam není úplný. Některé dary jsou nápadné, "
       "jiné skryté, ale Pavel zdůrazňuje, že „slabší“ údy jsou "
       "nezbytné.",
       "Kapitola o lásce (1K 13) stojí přesně mezi dvěma kapitolami "
       "o darech. Není to svatební text, ale korekce pro církev, která "
       "se hádala, čí dar je důležitější. Bez lásky je i největší dar "
       "jen hluk."],
      ["Řecké slovo charisma pochází od charis – „milost“. Dar je tedy "
       "„projev milosti“, ne zásluha.",
       "Korint byl proslulý výrobou bronzu. „Zvučící kov“ z 1K 13,1 "
       "byl pro Korinťany důvěrně známý zvuk."],
      ["Jaký dar ode mě druzí v církvi nebo v rodině přijímají?",
       "Čí nenápadný dar bych mohl ocenit?"])

topic("unity", "church", "link", "Jednota",
      "Ježíšova poslední velká modlitba prosí o jednotu jeho učedníků, "
      "„aby svět uvěřil“. Jednota neznamená stejnost – různí lidé, "
      "národy i tradice jsou spojeni jedním Pánem.",
      [("Ž 133,1", "Jak dobré je, když bratři žijí spolu"),
       ("J 17,20-21", "Aby všichni byli jedno"),
       ("Sk 4,32", "Jedno srdce a jedna duše"),
       ("1K 1,10", "Ať mezi vámi nejsou roztržky"),
       ("Ga 3,28", "Všichni jste jeden v Kristu"),
       ("Ef 4,3-6", "Jeden Pán, jedna víra, jeden křest"),
       ("Fp 2,2", "Jedné mysli"),
       ("Ko 3,14", "Láska je pouto dokonalosti")],
      ["Galatským 3,28 bylo ve své době šokující: Žid a Řek, otrok "
       "a svobodný, muž a žena – všichni jsou „jeden“ v Kristu. První "
       "církve spojovaly lidi, kteří by se jinak nikdy nesešli u jednoho "
       "stolu. Největším sporem raných církví byla právě otázka, zda "
       "pohané mohou jíst s Židy (Sk 15).",
       "Pavel vybízí „zachovávat“ jednotu Ducha – ne ji vyrábět. "
       "Jednota je dar, který lze ztratit pýchou, pomluvami "
       "a stranictvím („já jsem Pavlův, já Apollův“). Pro Ježíše je "
       "jednota svědectvím pro svět."],
      ["Každý rok v lednu probíhá Týden modliteb za jednotu křesťanů, "
       "kterého se účastní katolíci, protestanti i pravoslavní.",
       "Ž 133 přirovnává jednotu k rose z Chermonu – nejvyšší hory "
       "oblasti, odkud rosa a sníh napájejí Jordán."],
      ["S kým z jiné církevní tradice bych mohl sdílet víru?",
       "Čím mohu přispět k jednotě ve svém společenství?"])

topic("fellowship", "church", "family", "Společenství",
      "Víra se v Bibli žije společně. První křesťané se scházeli "
      "k učení, lámání chleba a modlitbám, sdíleli majetek i radosti. "
      "Kde jsou dva nebo tři v Ježíšově jménu, je mezi nimi.",
      [("Kaz 4,9-10", "Dva jsou lepší než jeden"),
       ("Mt 18,20", "Kde jsou dva nebo tři"),
       ("Sk 2,42", "Učení, společenství, chléb a modlitby"),
       ("Sk 2,46-47", "Po domech s radostí"),
       ("Ř 12,15", "Radujte se s radujícími, plačte s plačícími"),
       ("Ga 6,2", "Neste břemena jedni druhých"),
       ("Žd 10,24-25", "Neopouštějte společná shromáždění"),
       ("1J 1,7", "Máme společenství spolu")],
      ["Řecké slovo koinónia znamená „mít podíl na něčem společném“. "
       "Používalo se i pro obchodní společnost. Křesťané mají podíl "
       "na Kristu – a proto i na životech druhých: na jejich jídle, "
       "radostech, starostech i penězích.",
       "Nový zákon obsahuje kolem padesáti výzev „jedni druhým“: "
       "milujte se, povzbuzujte, odpouštějte, snášejte, modlete se "
       "za sebe navzájem. Tyto příkazy se nedají plnit o samotě."],
      ["První křesťané se scházeli v domech. Nejstarší známý "
       "křesťanský „kostel“ v Dura-Európos v Sýrii (asi 240 po Kr.) "
       "byl přestavěný obytný dům.",
       "Ž 133 se zpívá při mnoha setkáních v Izraeli; jeho úvod "
       "„Hine ma tov“ je populární píseň."],
      ["Kdo nese moje břemena – a čí břemena nesu já?",
       "Kterou výzvu „jedni druhým“ bych mohl tento týden "
       "uskutečnit?"])

topic("persecution", "church", "shield", "Pronásledování a věrnost",
      "Ježíš svým učedníkům nesliboval snadný život. Varoval, že je "
      "svět bude nenávidět, ale slíbil, že s nimi bude. Pronásledování "
      "provází církev od počátku až dodnes.",
      [("Da 3,17-18", "I kdyby nás nevysvobodil"),
       ("Mt 5,10-12", "Blahoslavení pronásledovaní"),
       ("J 15,18-20", "Mě pronásledovali, i vás budou"),
       ("Sk 5,41", "Radovali se, že byli hodni trpět"),
       ("Sk 7,59-60", "Štěpán se modlí za ty, kdo ho kamenují"),
       ("2K 4,8-9", "Pronásledováni, ale ne opuštěni"),
       ("Žd 13,3", "Pamatujte na vězně"),
       ("Zj 2,10", "Buď věrný až do smrti")],
      ["Tři mládenci v Danielovi odpovídají králi jednou z nejsilnějších "
       "vět víry: Bůh nás může vysvobodit – „ale i kdyby ne“, modle se "
       "klanět nebudeme. Věrnost nezávisí na výsledku.",
       "Štěpán, první křesťanský mučedník, umírá s modlitbou za své "
       "vrahy, podobně jako Ježíš. Mezi přihlížejícími stojí mladý "
       "Saul – pozdější apoštol Pavel. Tertulián později napsal: „Krev "
       "mučedníků je semenem církve.“"],
      ["Slovo „mučedník“ je řecky martys – „svědek“. Svědek, který "
       "svědectví potvrdí životem.",
       "I dnes žijí miliony křesťanů v zemích, kde za víru hrozí "
       "vězení nebo násilí. Žd 13,3 vyzývá pamatovat na ně, „jako "
       "byste byli uvězněni s nimi“."],
      ["Co mě víra stojí – a jsem ochoten za ni platit?",
       "Za které pronásledované křesťany se mohu modlit?"])

# --- Budoucnost -------------------------------------------------------------
topic("heaven", "future", "sunrise", "Nebe a Boží domov",
      "Bible o nebi mluví střídmě, ale s velkou nadějí: je to místo, "
      "kde je Bůh, kam nás Ježíš předešel, aby připravil místo. "
      "Nakonec se nebe a země spojí v nové stvoření.",
      [("J 14,2-3", "V domě mého Otce je mnoho příbytků"),
       ("L 23,43", "Dnes budeš se mnou v ráji"),
       ("1K 2,9", "Co oko nevidělo"),
       ("2K 5,1", "Věčný dům v nebesích"),
       ("Fp 1,21-23", "Odejít a být s Kristem"),
       ("Fp 3,20", "Naše občanství je v nebesích"),
       ("Žd 11,16", "Touží po lepší vlasti"),
       ("Zj 7,16-17", "Už nebudou hladovět")],
      ["Ježíš popisuje nebe jako dům Otce s mnoha „příbytky“ "
       "(monai – místa, kde se zůstává). V tehdejší rodině se k otcovu "
       "domu přistavovaly pokoje pro syny a jejich rodiny. Nebe je "
       "obrazem domova a rodiny, ne nekonečné nudy na obláčku.",
       "Nový zákon nemluví hlavně o tom, že odejdeme „do nebe“ "
       "navždy, ale o vzkříšení a nové zemi. Smrt věřícího znamená „být "
       "s Kristem“ (Fp 1,23), ale konečným cílem je obnovené stvoření, "
       "kde Bůh přebývá s lidmi (Zj 21,3)."],
      ["Slovo „ráj“ pochází z perského pairidaeza – „ohrazená zahrada“. "
       "Řecký překlad Starého zákona jím označoval zahradu Eden.",
       "Filipy byly římskou kolonií a jejich obyvatelé byli hrdí na "
       "římské občanství. Pavel jim píše: vaše skutečné občanství je "
       "v nebesích."],
      ["Jak moje naděje na nebe ovlivňuje to, jak žiji teď?",
       "Na co se v Božím domově těším nejvíc?"])

topic("death", "future", "candle", "Smrt a truchlení",
      "Bible smrt nezlehčuje – nazývá ji nepřítelem. I Ježíš u hrobu "
      "přítele plakal. Ale křesťané truchlí „s nadějí“, protože "
      "Kristus smrt přemohl.",
      [("Ž 23,4", "I kdybych šel temným údolím"),
       ("Ž 90,12", "Nauč nás počítat naše dny"),
       ("Kaz 3,1-4", "Čas plakat a čas se smát"),
       ("J 11,25-26", "Já jsem vzkříšení a život"),
       ("J 11,35", "Ježíš se rozplakal"),
       ("1K 15,54-55", "Smrti, kde je tvé vítězství?"),
       ("1Te 4,13-14", "Netruchlete jako ti, kdo nemají naději"),
       ("Zj 21,4", "Smrti už nebude")],
      ["Ježíš ví, že za chvíli Lazara vzkřísí – a přesto pláče. "
       "Truchlení tedy není nedostatek víry. Bible dává prostor "
       "nářku: celá kniha Pláč, žalmy nářku, Davidův pláč nad Absolonem. "
       "Pavel nezakazuje truchlit, jen ukazuje, že křesťanský smutek "
       "má naději.",
       "Pavel nazývá smrt „posledním nepřítelem“ (1K 15,26). Kristus "
       "smrt nepřeskočil, ale prošel jí – a proto pro věřící ztratila "
       "„osten“. Křesťanské pohřby od počátku zdůrazňovaly vzkříšení; "
       "hroby se obracely k východu, odkud se čekal vracející se Kristus."],
      ["Žalm 90 je jediný žalm připisovaný Mojžíšovi. Prosba „nauč "
       "nás počítat naše dny“ zve žít moudře s vědomím konečnosti.",
       "Raní křesťané nazývali hřbitov koimétérion – „místo spánku“. "
       "Odtud pochází anglické cemetery i francouzské cimetière."],
      ["Koho jsem ztratil a jak s tím smutkem přicházím k Bohu?",
       "Jak by mě vědomí konečnosti mohlo naučit žít moudřeji?"])

# --- Duchovní svět ---------------------------------------------------------
topic("angels", "world", "angel", "Andělé",
      "Andělé jsou v Bibli Boží poslové a služebníci. Přinášejí zprávy, "
      "chrání, bojují i chválí Boha. Nejsou to roztomilé děti s křidélky "
      "– jejich první slova obvykle zní: „Neboj se!“",
      [("Gn 28,12", "Jákobův žebřík"),
       ("Ž 34,8", "Anděl Hospodinův se utábořil"),
       ("Ž 91,11-12", "Andělům přikáže, aby tě chránili"),
       ("Da 10,12-13", "Anděl, Michael a kníže Perské říše"),
       ("L 1,26-28", "Gabriel u Marie"),
       ("L 2,13-14", "Sláva na výsostech Bohu"),
       ("Mt 18,10", "Andělé maličkých"),
       ("Žd 1,14", "Služební duchové")],
      ["Slovo „anděl“ pochází z řeckého angelos – „posel“; hebrejské "
       "mal'ach znamená totéž. Kanonické knihy jmenují jen dva anděly: Gabriela "
       "(„Bůh je má síla“) a Michaela („Kdo je jako Bůh?“). Zmiňuje "
       "také cheruby, kteří střeží Boží přítomnost, a serafy "
       "(„planoucí“) u Izajáše.",
       "Bible ukazuje anděly jako služebníky, nikdy jako cíl uctívání – "
       "když se Jan ve Zjevení před andělem skloní, slyší: „Nedělej "
       "to! Jsem spoluslužebník… Bohu se klaněj“ (Zj 19,10). Jejich "
       "úkolem je ukazovat k Bohu a sloužit lidem."],
      ["Cherubové v Bibli nejsou baculatá miminka – ta pocházejí "
       "z renesančního umění (putti). Ezechiel je popisuje se čtyřmi "
       "tvářemi a křídly.",
       "Žalm 91,11-12 cituje ďábel při pokoušení Ježíše (Mt 4,6) – "
       "příklad toho, že i Písmo lze vytrhnout z kontextu."],
      ["Překvapuje mě, jak málo toho Bible o andělích říká?",
       "Zažil jsem někdy nečekanou ochranu nebo pomoc „ve správnou "
       "chvíli“?"])

topic("evil", "world", "warning", "Satan a zlo",
      "Bible bere zlo vážně. Mluví o protivníkovi – satanovi, který "
      "pokouší, obviňuje a lže. Ale nikdy ho nestaví na roveň Bohu: "
      "je to poražený nepřítel, kterému je možné vzdorovat.",
      [("Gn 3,1-5", "Had zpochybňuje Boží slovo"),
       ("Jb 1,8-11", "Satan obviňuje Jóba"),
       ("Mt 4,10", "Odejdi, satane"),
       ("J 8,44", "Otec lži"),
       ("J 10,10", "Zloděj přichází krást"),
       ("Jk 4,7", "Vzepřete se ďáblu"),
       ("1J 3,8", "Syn Boží přišel zmařit skutky ďáblovy"),
       ("Ř 16,20", "Bůh brzy rozdrtí satana")],
      ["Hebrejské satan znamená „protivník, žalobce“. V knize Jób je "
       "to ten, kdo obviňuje člověka před Bohem: „Bojí se Jób Boha "
       "jen tak?“ Řecké diabolos znamená „pomlouvač, ten, kdo rozděluje“. "
       "Satanovou hlavní zbraní je lež – začíná otázkou „Opravdu Bůh "
       "řekl…?“",
       "Bible nepopisuje „válku dvou rovnocenných bohů“. Zlo je "
       "parazit na dobrém stvoření. Ježíš satana přemáhá Písmem "
       "a poslušností, na kříži ho „odzbrojil“ (Ko 2,15). Křesťan se "
       "nemá zla bát ani ho podceňovat – má mu vzdorovat a přimknout "
       "se k Bohu."],
      ["C. S. Lewis v předmluvě ke knize Rady zkušeného ďábla píše, že "
       "lidé dělají dvě opačné chyby: buď v ďábla nevěří, nebo se jím "
       "nezdravě zabývají.",
       "Jméno Lucifer („nositel světla“) pochází z latinského překladu "
       "Iz 14,12, kde jde původně o babylonského krále; křesťanská "
       "tradice ho vztáhla na satana."],
      ["Kde v mém životě slyším hlas „Opravdu Bůh řekl…?“",
       "Co mi pomáhá vzdorovat pokušení a lži?"])

topic("warfare", "world", "shield", "Duchovní boj",
      "Pavel píše, že náš boj není proti lidem, ale proti mocnostem "
      "temnoty. Zbraně křesťana jsou nečekané: pravda, spravedlnost, "
      "pokoj, víra, Boží slovo a modlitba. A dobro přemáhá zlo.",
      [("Ef 6,10-12", "Oblečte celou Boží výzbroj"),
       ("Ef 6,13-18", "Pás pravdy, štít víry, meč Ducha"),
       ("2K 10,3-5", "Zbraně mocné Bohem"),
       ("1Pt 5,8-9", "Ďábel obchází jako lev"),
       ("L 10,18-20", "Radujte se, že vaše jména jsou zapsána"),
       ("Ko 2,15", "Odzbrojil mocnosti"),
       ("Ř 12,21", "Přemáhej zlé dobrým")],
      ["Pavel psal list Efezským ve vězení, pravděpodobně připoután "
       "k římskému vojákovi. Popisuje jeho výzbroj: pás, pancíř, "
       "obuv, štít, přilbu a meč. Všechno kromě meče je obranné – "
       "a mečem je Boží slovo.",
       "Duchovní boj podle Bible neznamená hledat démony za každým "
       "problémem. Častěji se odehrává v myšlenkách (2K 10,5), "
       "v pokušení, ve vztazích. A jeho nejsilnější zbraní je "
       "pokorná modlitba a dobro, které neoplácí zlým."],
      ["Řecké slovo pro štít v Ef 6,16 (thyreos) je odvozeno od slova "
       "thyra – „dveře“. Velký římský štít krýl skoro celého vojáka "
       "a jeho kožený potah dokázal zadržet zápalné šípy.",
       "Římské vojenské boty (caligae) měly podrážky pobité hřeby – "
       "díky nim voják pevně stál. Pavel mluví o „obuvi pohotovosti "
       "pro evangelium pokoje“."],
      ["Který kus „Boží výzbroje“ teď nejvíc potřebuji?",
       "Kde mohu tento týden přemoci zlé dobrým?"])
