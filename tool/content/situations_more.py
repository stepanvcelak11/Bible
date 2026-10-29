"""Rozšířené zamyšlení k veršům pro tuto chvíli (vlastní texty aplikace).

id situace: (odstavce zamyšlení, praktické kroky, krátká modlitba)
"""

MORE = {
    "joy": (
        ["Radost v Bibli není povinný úsměv, ale odpověď na dobro, které "
         "nám někdo daroval. Proto se v žalmech radost tak často mění "
         "v díky: kdo se raduje, zjišťuje, že dobré věci nevyrobil sám.",
         "Radost také roste, když se sdílí. Pastýři po Ježíšově narození "
         "běží vyprávět, co viděli, a otec ztraceného syna pořádá hostinu. "
         "Radost, kterou si člověk nechá jen pro sebe, rychle vyprchá.",
         "A je dobré si ji pamatovat. Ve dnech, kdy radost chybí, se "
         "Izraelité vraceli ke vzpomínkám na to, co Bůh udělal. Dnešní "
         "radost může být zítřejší oporou."],
        ["Řekněte Bohu konkrétně, z čeho máte radost.",
         "Podělte se o dobrou zprávu s někým blízkým.",
         "Zapište si dnešní radost, ať se k ní můžete vrátit."],
        "Děkuji ti, Bože, za tuto radost. Ať z ní nezapomenu tebe, "
        "dárce všeho dobrého, a ať se jí umím rozdělit s druhými."),
    "fear": (
        ["Jedna z nejčastějších vět, které Bůh v Bibli lidem říká, je "
         "„Neboj se“. "
         "Říká ji Abrahamovi, Mojžíšovi, Marii i učedníkům v bouři. Nikdy "
         "to není výčitka, že se bojí – je to slib, že nejsou sami.",
         "Bible strach neodstraňuje kouzlem. Žalmista píše: „Když mám "
         "strach, doufám v tebe.“ Strach a důvěra mohou být v srdci "
         "zároveň. Důvěra neznamená, že se nic nestane, ale že ani to "
         "nejhorší nás nevytrhne z Božích rukou.",
         "Pomáhá strach pojmenovat. Dokud je mlhavý, roste. Když ho řekneme "
         "Bohu nahlas, zmenší se na skutečnou velikost."],
        ["Pojmenujte nahlas, čeho přesně se bojíte.",
         "Vyberte si jeden verš a opakujte si ho, když strach přijde.",
         "Řekněte o svém strachu někomu, komu věříte."],
        "Pane, bojím se. Ty víš čeho. Drž mě za ruku a dej mi odvahu "
        "udělat další krok, i když strach hned nezmizí."),
    "anxiety": (
        ["Starosti se točí kolem věcí, které nemáme pod kontrolou – "
         "budoucnosti, zdraví, lidí kolem nás. Ježíš neříká, že na nich "
         "nezáleží. Říká, že máme Otce, který o nich ví dřív než my.",
         "Pavel radí něco velmi praktického: s každou starostí přijít "
         "k Bohu v modlitbě a zároveň děkovat. Vděčnost obrací pozornost "
         "od toho, co chybí, k tomu, co Bůh už dal. Slibuje pak pokoj, "
         "který převyšuje rozum – ne vždy hned vyřešený problém.",
         "Ježíš také učí žít po dnech: „Každý den má dost svého trápení.“ "
         "Zítřek nese Bůh. Dnes stačí dnešní krok."],
        ["Napište si starosti na papír a každou předejte Bohu v modlitbě.",
         "Ke každé starosti připište jednu věc, za kterou můžete děkovat.",
         "Rozhodněte se pro jeden malý krok, který můžete udělat dnes."],
        "Otče, svěřuji ti všechno, co mě tíží. Vezmi to, co neunesu, "
        "a dej mi pokoj, abych zvládl dnešek."),
    "sadness": (
        ["Bible nikde neříká, že věřící člověk nemá být smutný. Třetina "
         "žalmů jsou nářky. Jeremjáš pláče nad městem, Ježíš pláče u hrobu "
         "přítele. Smutek tedy smí být vysloven – i před Bohem.",
         "Žalmisté dělají zvláštní věc: mluví se svou duší. „Proč se "
         "trápíš, má duše? Doufej v Boha.“ Neutíkají od smutku, ale "
         "připomínají si uprostřed něj, kdo je Bůh.",
         "Bůh je podle Písma blízko lidem se zlomeným srdcem. Nemusíme "
         "smutek přemoct, abychom k němu mohli přijít. Smíme přijít "
         "takoví, jací jsme."],
        ["Vyslovte Bohu svůj smutek vlastními slovy, nebo slovy žalmu.",
         "Dovolte si plakat a nespěchat.",
         "Dejte vědět někomu blízkému, jak vám je."],
        "Bože, je mi smutno. Ty jsi blízko zlomeným srdcím – buď blízko "
        "i mně a pomalu mi vracej naději."),
    "lonely": (
        ["Samota bolí, protože jsme stvořeni pro vztahy. Už na začátku "
         "Bible zazní: „Není dobré, aby člověk byl sám.“ Touha po "
         "blízkosti tedy není slabost, ale součást našeho lidství.",
         "Mnoho biblických postav prožilo osamění: Eliáš pod jalovcem, "
         "David na útěku, Ježíš v Getsemane, když učedníci spali. Bůh "
         "jim samotu nevyčítá. Přichází k nim – s jídlem, slovem, "
         "s andělem, se svou přítomností.",
         "Boží blízkost nenahrazuje lidi, ale dává sílu udělat krok "
         "k nim. Často je osamělý i někdo vedle nás."],
        ["Řekněte Bohu, že se cítíte sami – on to slyší rád.",
         "Ozvěte se dnes jednomu člověku, i krátkou zprávou.",
         "Zkuste najít společenství, kde se můžete pravidelně potkávat."],
        "Pane, cítím se sám. Děkuji, že ty mě neopouštíš. Pošli mi "
        "do cesty lidi a dej mi odvahu otevřít se jim."),
    "anger": (
        ["Hněv v Bibli najdeme u lidí i u Boha. Bůh se hněvá na "
         "nespravedlnost a Ježíš převrací stoly v chrámu. Hněv může být "
         "znamením, že nám na něčem záleží.",
         "Nebezpečný je hněv, který necháme růst. Pavel píše: „Hněvejte "
         "se, ale nehřešte. Slunce ať nezapadá nad vaším hněvem.“ Hněv, "
         "který přenocuje, se snadno změní v hořkost.",
         "Jakub radí být rychlý k naslouchání a pomalý k mluvení. Než "
         "zareagujeme, můžeme hněv přinést Bohu a nechat ho, aby nám "
         "ukázal, co je pod ním – zranění, strach nebo pocit křivdy."],
        ["Než promluvíte, nadechněte se a počkejte.",
         "Řekněte Bohu upřímně, proč se zlobíte.",
         "Pokud to jde, vyřešte spor ještě dnes."],
        "Bože, zlobím se. Ukaž mi, co je pod mým hněvem, a pomoz mi "
        "jednat tak, abych nikomu neublížil."),
    "guilt": (
        ["Bible je plná lidí, kteří selhali: Mojžíš zabil člověka, David "
         "zhřešil s Batšebou, Petr zapřel Ježíše. Bůh je přesto nezavrhl. "
         "Jejich příběhy pokračují.",
         "Rozdíl je mezi vinou, která vede k Bohu, a vinou, která od něj "
         "odhání. Jidáš i Petr selhali – Petr se ale vrátil a slyšel "
         "otázku „Miluješ mě?“. Odpuštění začíná upřímným přiznáním.",
         "Bůh slibuje, že kdo vyznává své hříchy, tomu odpustí. Odpuštění "
         "není výsledek našeho trápení, ale dar. A kde je to možné, "
         "patří k němu i snaha napravit, co jsme pokazili."],
        ["Pojmenujte před Bohem konkrétně, v čem jste selhali.",
         "Přijměte jeho odpuštění – a přestaňte se trestat.",
         "Pokud jste někomu ublížili, zvažte, jak to napravit."],
        "Pane, selhal jsem. Odpusť mi a očisti mě. Děkuji, že u tebe "
        "není konec, ale nový začátek."),
    "worthless": (
        ["Svět měří hodnotu výkonem, vzhledem a uznáním. Bible začíná "
         "jinde: člověk je stvořen k Božímu obrazu. Hodnotu jsme dostali "
         "dřív, než jsme cokoli dokázali.",
         "Bůh v Izajášovi říká: „Jsi v mých očích drahý a vzácný a já tě "
         "miluji.“ A Jan žasne: „Hleďte, jakou lásku nám Otec dal, že "
         "smíme být nazváni Božími dětmi.“ Tohle se nedá ztratit "
         "neúspěchem.",
         "Pocity bezcennosti často přicházejí ze slov, která nám kdysi "
         "někdo řekl. Boží slovo o nás je ale pravdivější než kterýkoli "
         "lidský soud – i než ten náš vlastní."],
        ["Přečtěte si nahlas Ž 139,13-14 a dosaďte své jméno.",
         "Všimněte si, kdo nebo co vám říká, že nejste dost.",
         "Udělejte dnes něco dobrého pro sebe jako pro Boží dítě."],
        "Otče, učím se věřit, že jsem pro tebe vzácný. Ať se nedívám na "
        "sebe očima druhých, ale tvýma."),
    "tired": (
        ["Vyčerpání zná i Bible. Eliáš si po velkém vítězství lehne pod "
         "keř a chce zemřít. Bůh mu nedá kázání – dá mu jídlo, spánek "
         "a znovu jídlo. Teprve potom s ním mluví.",
         "Odpočinek je Boží nápad. Sám Bůh sedmý den odpočíval a Ježíš "
         "zve: „Pojďte ke mně všichni, kdo jste unavení.“ Kdo odpočívá, "
         "přiznává, že svět nestojí na něm.",
         "Prorok slibuje, že ti, kdo doufají v Hospodina, nabírají novou "
         "sílu. Síla nemusí pocházet jen z nás – můžeme ji přijímat."],
        ["Dopřejte si dnes skutečný odpočinek bez výčitek.",
         "Zvažte, co můžete odložit nebo komu svěřit.",
         "Najděte si chvíli ticha s Bohem, i jen pět minut."],
        "Pane, jsem unavený. Dej mi odpočinutí, které dáváš, a novou "
        "sílu na to, co je opravdu potřeba."),
    "doubt": (
        ["Pochybnosti nejsou opakem víry. Tomáš chtěl vidět rány, Jan "
         "Křtitel se z vězení ptal, zda je Ježíš opravdu ten pravý, "
         "a žalmisté se ptají „Proč?“ a „Dokdy?“. Bůh se jim neposmívá.",
         "Ježíš Tomášovi neřekne „styď se“, ale ukáže mu své ruce. Otec "
         "nemocného chlapce volá: „Věřím, pomoz mé nevěře!“ – a Ježíš "
         "jeho syna uzdraví. Malá víra stačí, když ji neseme k Ježíši.",
         "Otázky můžeme pokládat nahlas: Bohu, Písmu i lidem, kteří "
         "věří déle. Poctivé hledání k víře často vede hlouběji."],
        ["Napište si otázku, která vás nejvíc trápí.",
         "Řekněte ji Bohu upřímně jako Tomáš nebo žalmista.",
         "Promluvte si o ní s někým zralým ve víře."],
        "Pane, věřím – pomoz mé nevěře. Ukaž se mi tak, jak jsi se "
        "ukázal Tomášovi, a veď mě k pravdě."),
    "decision": (
        ["Bible většinou nedává hotový návod pro každou volbu. Dává ale "
         "moudrost a Boží blízkost. Jakub píše: „Má-li kdo nedostatek "
         "moudrosti, ať prosí Boha.“ A Bůh dává štědře.",
         "Moudré rozhodnutí obvykle roste z několika zdrojů: z modlitby, "
         "z Písma, z rad zkušených lidí a z poctivého pohledu na vlastní "
         "motivy. Přísloví říkají, že plány se daří, když je hodně "
         "rádců.",
         "Někdy nevíme, kam vede celá cesta, ale víme, jaký je další krok. "
         "Boží slovo je svícen pro nohy – svítí na krok, ne na celou "
         "mapu."],
        ["Proste Boha o moudrost konkrétně pro tuto volbu.",
         "Sepište si možnosti a u každé, co je dobré a co ne.",
         "Poraďte se s jedním moudrým člověkem."],
        "Bože, nevím, co dělat. Dej mi moudrost, pokoj v srdci a odvahu "
        "udělat další správný krok."),
    "courage": (
        ["Bůh často posílá lidi do úkolů, na které si nepřipadají: "
         "Mojžíš se vymlouvá, že neumí mluvit, Gedeón, že je nejmenší, "
         "Jeremjáš, že je moc mladý. Pokaždé slyší: „Já budu s tebou.“",
         "Jozue před vstupem do země slyší třikrát: „Buď rozhodný "
         "a statečný.“ Odvaha tu není vlastnost hrdinů, ale rozhodnutí "
         "spolehnout se na Boží slib.",
         "Těžký úkol se dá rozdělit na kroky. Nehemjáš postavil hradby "
         "tak, že každý stavěl kousek naproti svému domu."],
        ["Rozdělte úkol na menší kroky a začněte prvním.",
         "Požádejte o modlitbu nebo pomoc někoho blízkého.",
         "Připomeňte si, kdy vám Bůh pomohl dřív."],
        "Pane, čeká mě něco těžkého. Buď se mnou jako s Jozuem a dej mi "
        "sílu, moudrost a klid."),
    "illness": (
        ["Bible bere nemoc vážně. Ježíš se nemocných dotýká, uzdravuje "
         "je a ptá se jich, co potřebují. Nemocní v evangeliích nejsou "
         "na okraji, ale ve středu jeho pozornosti.",
         "Můžeme prosit o uzdravení – Jakub vyzývá k modlitbě za "
         "nemocné. Zároveň Pavel zažil, že jeho „osten“ nezmizel, "
         "a slyšel: „Stačí ti má milost.“ Bůh je blízko v uzdravení "
         "i v nesení nemoci.",
         "Pečovat o tělo, chodit k lékaři a přijímat pomoc druhých není "
         "projev malé víry. Bůh často jedná i skrze lidi a léky."],
        ["Proste o uzdravení i o sílu na každý den.",
         "Dovolte druhým, aby vám pomohli a modlili se za vás.",
         "Řekněte Bohu i to, čeho se v nemoci bojíte."],
        "Pane Ježíši, ty jsi uzdravoval nemocné. Dotkni se mě, dej mi "
        "sílu a pokoj a buď se mnou v každé chvíli."),
    "grief": (
        ["Smutek nad ztrátou je cena lásky. Ježíš u hrobu Lazara pláče, "
         "i když ví, že ho za chvíli vzkřísí. Slzy tedy nejsou nedostatek "
         "víry.",
         "Pavel píše, abychom se nermoutili jako ti, kdo nemají naději. "
         "Neříká „nermuťte se“ – říká, že smutek věřících má jiný "
         "horizont. Kristus vstal a smrt nemá poslední slovo.",
         "Truchlení má svůj čas a nedá se uspěchat. Bůh slibuje, že "
         "jednou setře každou slzu. Do té doby smí naše slzy padat "
         "před ním."],
        ["Dejte si čas truchlit a nesrovnávejte se s druhými.",
         "Vzpomínejte na zesnulého a děkujte za něj Bohu.",
         "Přijměte blízkost lidí, kteří chtějí být s vámi."],
        "Bože, chybí mi. Děkuji za čas, který jsme spolu měli. Utěš mě "
        "a dej mi naději, že smrt nemá poslední slovo."),
    "hurt": (
        ["Bible nezlehčuje zranění, která nám způsobí druzí. Josefa "
         "prodali vlastní bratři, Davida pronásledoval král, kterému "
         "věrně sloužil. Bolest smí být vyslovena.",
         "Ježíš učí odpouštět – ne proto, že by zlo nevadilo, ale proto, "
         "že soud patří Bohu. Odpuštění znamená vzdát se práva na pomstu. "
         "Neznamená to předstírat, že se nic nestalo, ani zůstávat "
         "v nebezpečí.",
         "Odpuštění bývá proces. Často se začíná modlitbou za toho, kdo "
         "nám ublížil – i když na to zatím nemáme sílu."],
        ["Řekněte Bohu upřímně, co vás bolí.",
         "Rozhodněte se nechat soud na Bohu, i když cit ještě nestačí.",
         "Pokud vám někdo ubližuje dál, vyhledejte pomoc a chraňte se."],
        "Pane, bolí mě, co se stalo. Uzdrav mé srdce a dej mi sílu "
        "odpustit. Spravedlnost nechávám na tobě."),
    "injustice": (
        ["Křivda je jedna z nejtěžších zkušeností. Žalmisté i proroci se "
         "ptají: „Proč se daří bezbožným?“ Bible tu otázku neumlčuje – "
         "dává jí místo v modlitbě.",
         "Bůh je v Písmu ten, kdo vidí utiskované. Hagar ho nazve „Bůh, "
         "který mě vidí“. Ámos volá, ať se valí právo jako voda. Bůh "
         "spravedlnost nejen slibuje, ale jednou ji zjedná úplně.",
         "Mezitím smíme hájit pravdu pokojně a moudře, jako Pavel před "
         "soudy. A smíme se zastat i druhých, kterým se děje křivda."],
        ["Vyslovte Bohu svou křivdu bez přikrášlení.",
         "Zvažte, co můžete pokojně a pravdivě udělat.",
         "Nenechte hořkost, aby převzala vaše srdce."],
        "Bože spravedlnosti, ty vidíš, co se mi děje. Zastaň se mě a dej mi "
        "trpělivost, moudrost a čisté srdce."),
    "money": (
        ["Peníze jsou v Bibli častým tématem – Ježíš o nich mluví "
         "víc než o mnoha jiných věcech. Ne proto, že by byly špatné, "
         "ale protože snadno zaberou místo, které patří Bohu.",
         "Ježíš ukazuje na ptáky a lilie: Otec ví, co potřebujete. "
         "Pavel se naučil být spokojený v dostatku i nedostatku. "
         "Spokojenost není lhostejnost, ale důvěra.",
         "Bible zároveň radí moudře hospodařit: plánovat, nezadlužovat "
         "se zbytečně, pracovat poctivě a dělit se. I malý dar dělá "
         "srdce svobodnějším."],
        ["Předložte Bohu konkrétní potřeby, o kterých víte.",
         "Udělejte si jednoduchý přehled příjmů a výdajů.",
         "Požádejte o radu nebo pomoc, pokud je situace vážná."],
        "Otče, ty znáš mé potřeby. Dej mi moudrost v hospodaření, "
        "spokojené srdce a důvěru, že se postaráš."),
    "work": (
        ["Práce není trest. Ještě před pádem dostal člověk úkol pečovat "
         "o zahradu. Práce je účast na Božím díle ve světě.",
         "Pavel píše: „Všechno, co děláte, dělejte z celého srdce jako "
         "pro Pána, a ne pro lidi.“ I obyčejná práce tak dostává smysl – "
         "nejde jen o výplatu nebo uznání.",
         "Bible chrání i před tím, aby se práce stala modlou. Sobota "
         "připomíná, že nejsme stroje. Hodnota člověka nestojí na "
         "výkonu."],
        ["Svěřte Bohu dnešní práci na začátku dne.",
         "Udělejte jednu věc pořádně, i když ji nikdo neuvidí.",
         "Najděte si čas na odpočinek a nepracujte bez konce."],
        "Pane, žehnej mé práci. Ať ji dělám poctivě a s radostí, jako "
        "pro tebe, a ať v ní můžu sloužit druhým."),
    "love": (
        ["Bible mluví o lásce jako o rozhodnutí a službě. Pavlova píseň "
         "o lásce neříká, co láska cítí, ale co dělá: je trpělivá, "
         "laskavá, nezávidí, nehledá svůj prospěch.",
         "Manželství je v Písmu smlouva věrnosti – obraz Boží věrnosti "
         "k jeho lidu. Muž a žena se mají milovat tak, jako Kristus "
         "miloval církev: obětavě.",
         "Láska potřebuje péči. Odpuštění, čas spolu, dobrá slova "
         "a modlitba jeden za druhého jsou jako voda pro zahradu."],
        ["Udělejte dnes pro blízkého člověka konkrétní laskavost.",
         "Řekněte mu, za co jste vděční.",
         "Pokud mezi vámi něco stojí, udělejte první krok ke smíření."],
        "Bože lásky, nauč mě milovat trpělivě a věrně. Žehnej našemu "
        "vztahu a pomoz nám odpouštět si."),
    "family": (
        ["Rodina je v Bibli místem, kde se víra předává. „Tato slova "
         "budeš vštěpovat svým synům a budeš o nich mluvit doma i na "
         "cestě.“ Víra se učí víc příkladem než přednáškou.",
         "Biblické rodiny nebyly dokonalé – Jákob měl oblíbence, David "
         "nezvládal syny. Bůh přesto skrze tyto rodiny jedná. Naše "
         "rodina také nemusí být dokonalá, aby v ní působil.",
         "Pavel vyzývá rodiče, aby děti nepopouzeli, ale vychovávali "
         "v Boží kázni. Děti mají ctít rodiče. Vzájemný respekt je "
         "základem domova."],
        ["Pomodlete se dnes za každého člena rodiny jménem.",
         "Najděte chvíli, kdy budete spolu bez obrazovek.",
         "Řekněte dětem nebo rodičům něco povzbudivého."],
        "Otče, svěřuji ti svou rodinu. Buď uprostřed našeho domova, "
        "dej nám trpělivost, lásku a víru."),
    "temptation": (
        ["Pokušení samo není hřích. I Ježíš byl pokoušen, a přesto "
         "nezhřešil. Pocítit tah ke zlému neznamená, že jsme selhali.",
         "Ježíš na poušti odpovídal pokušiteli slovy Písma. Josef před "
         "Potífarovou ženou prostě utekl. Někdy je nejmoudřejší pokušení "
         "nevyjednávat, ale odejít.",
         "Pavel slibuje, že Bůh nedopustí pokušení nad naše síly a dá "
         "i cestu ven. Pomáhá vědět, kdy a kde jsme nejslabší, a předem "
         "se připravit."],
        ["Pojmenujte, co vás pokouší a kdy to přichází.",
         "Odejděte ze situace, pokud to jde.",
         "Svěřte se někomu, kdo vás podrží."],
        "Pane, neuveď mě v pokušení, ale vysvoboď mě od zlého. Ukaž mi "
        "cestu ven a dej mi sílu ji zvolit."),
    "waiting": (
        ["Bible je plná čekání. Abraham čekal na syna pětadvacet let, "
         "Izrael čekal staletí na Mesiáše, Simeon čekal v chrámu celý "
         "život. Čekání je běžná součást života s Bohem.",
         "Čekat neznamená nedělat nic. Žalmy mluví o čekání na "
         "Hospodina jako o aktivní důvěře: „Buď silný, ať se tvé srdce "
         "vzmuží, a skládej naději v Hospodina.“",
         "V čekání často roste to, co by jinak nevyrostlo: trpělivost, "
         "víra a schopnost vidět Boha v malých věcech."],
        ["Řekněte Bohu, na co čekáte a jak je to pro vás těžké.",
         "Hledejte, co můžete dělat dobře v době čekání.",
         "Zapisujte si drobné znaky Boží péče."],
        "Bože, čekám a je to těžké. Dej mi trpělivost a důvěru, že "
        "tvůj čas je dobrý."),
    "sleep": (
        ["Noc zvětšuje starosti. David zažil mnoho nebezpečných nocí, "
         "a přece v žalmu píše: „V pokoji uléhám a hned usínám, protože ty sám, "
         "Hospodine, mi dáváš bydlet v bezpečí.“",
         "Spánek je projev důvěry. Kdo usíná, přiznává, že svět nestojí "
         "na něm. Žalm říká, že Bůh dává svým milým i ve spánku – a že "
         "ten, kdo ochraňuje Izrael, nespí ani nedříme.",
         "Pomáhá na konci dne den „odevzdat“: poděkovat za dobré, "
         "svěřit nedokončené a odpustit to, co bolí."],
        ["Projděte s Bohem uplynulý den a poděkujte za tři věci.",
         "Svěřte mu nedokončené věci na zítřek.",
         "Odložte telefon a opakujte si pomalu krátký verš."],
        "Pane, svěřuji ti tuto noc. Ty nespíš, a tak můžu spát já. "
        "Dej mi klid a odpočinutí."),
    "success": (
        ["Úspěch je dar a zároveň zkouška. Mojžíš varuje Izrael: až "
         "budeš mít plné domy, nezapomeň na Hospodina. Dostatek umí "
         "srdce uspat.",
         "Bible vede k vděčnosti: „Co máš, co bys nedostal?“ Šalomoun "
         "dostal moudrost i bohatství, když prosil o to první. "
         "Úspěch je nejbezpečnější v rukou pokorného člověka.",
         "Úspěch je i příležitost žehnat druhým – sdílet, pomoci, "
         "povzbudit. Požehnání se v Bibli nikdy nemá zastavit u nás."],
        ["Poděkujte Bohu konkrétně za to, co se daří.",
         "Poděkujte i lidem, kteří vám pomohli.",
         "Zvažte, jak můžete svým úspěchem požehnat někomu dalšímu."],
        "Děkuji ti, Bože, za to, co se daří. Chraň mě před pýchou a "
        "ukaž mi, jak z toho, co mám, žehnat druhým."),
    "peace": (
        ["Biblické slovo šalom znamená víc než klid. Znamená celistvost "
         "– to, že je všechno na svém místě: vztah s Bohem, s lidmi "
         "i se sebou.",
         "Ježíš říká: „Pokoj vám dávám, ne jako dává svět.“ Svět dává "
         "pokoj, když se okolnosti zklidní. Ježíšův pokoj zůstává "
         "i uprostřed bouře – učedníci ho viděli spát v lodi.",
         "Pokoj se dá pěstovat: modlitbou, vděčností, odpuštěním "
         "a tichem, ve kterém necháme Boha mluvit."],
        ["Najděte si dnes pět minut ticha bez rozptýlení.",
         "Svěřte Bohu, co vás vnitřně rozrušuje.",
         "Udělejte krok ke smíření tam, kde chybí pokoj s druhými."],
        "Pane Ježíši, dej mi svůj pokoj, který nezávisí na okolnostech. "
        "Utiš bouři v mém srdci."),
    "hope": (
        ["Biblická naděje není optimismus, že všechno dobře dopadne. Je "
         "to důvěra, že Bůh je věrný a že Kristovo vzkříšení otevřelo "
         "budoucnost, kterou smrt nezavře.",
         "Jeremjáš psal vyhnancům v Babylóně: „Mám s vámi plány pokoje, "
         "ne zla, abych vám dal budoucnost a naději.“ Psal to lidem, "
         "kteří přišli o všechno.",
         "Naděje roste ze vzpomínek na Boží věrnost a z pohledu dopředu "
         "– k novému nebi a nové zemi, kde Bůh setře každou slzu."],
        ["Vzpomeňte si na chvíli, kdy vás Bůh podržel.",
         "Přečtěte si Ř 8,38-39 nebo Zj 21,1-5 pomalu nahlas.",
         "Sdílejte svou naději s někým, kdo ji potřebuje."],
        "Bože naděje, naplň mě radostí a pokojem ve víře. Ať naděje "
        "roste i tam, kde ji teď nevidím."),
    "gratitude": (
        ["Vděčnost je v Bibli postoj, ne jen pocit. Žalmy opakují "
         "„Chvalte Hospodina, neboť je dobrý“ – i v těžkých časech. "
         "Děkování připomíná, kdo je Bůh.",
         "Z deseti uzdravených malomocných se vrátil poděkovat jediný. "
         "Ježíš si toho všiml. Děkovat znamená zastavit se a vrátit se "
         "k dárci.",
         "Pavel píše: „Ve všem děkujte.“ Ne za všechno, ale ve všem. "
         "I v těžké situaci se dá najít něco, za co poděkovat."],
        ["Zapište si pět věcí, za které jste dnes vděční.",
         "Poděkujte nahlas Bohu i jednomu člověku.",
         "Zkuste týden končit den díkůvzdáním."],
        "Děkuji ti, Bože, za všechno dobré, co mi dáváš – za to, "
        "čeho si všímám, i za to, co přehlížím."),
    "prayer": (
        ["Modlitba je rozhovor s Bohem, ne výkon. Učedníci prosili: "
         "„Pane, nauč nás modlit se,“ a Ježíš jim dal krátkou modlitbu "
         "Otče náš. Stačí pár upřímných slov.",
         "Pavel přiznává, že ani on neví, jak se modlit, ale Duch se "
         "za nás přimlouvá vzdechy, které nelze vyslovit. I ticho "
         "a povzdech mohou být modlitbou.",
         "Pomáhá jednoduchý rytmus: poděkovat, říct, co nás trápí, "
         "prosit za druhé a chvíli naslouchat. Žalmy mohou posloužit "
         "jako slova, když vlastní chybějí."],
        ["Pomodlete se pomalu Otče náš a u každé věty se zastavte.",
         "Zkuste mluvit s Bohem vlastními slovy jednu minutu.",
         "Vyberte si žalm a modlete se ho jako svou modlitbu."],
        "Pane, nauč mě modlit se. Děkuji, že mi nasloucháš, i když "
        "nevím, co říct."),
    "newstart": (
        ["Bible je kniha nových začátků. Noe po potopě, Izrael po "
         "zajetí, Petr po zapření, Pavel po pronásledování církve. Bůh "
         "neodepisuje lidi, kteří se k němu obrátí.",
         "Kniha Pláč říká, že Boží milosrdenství je nové každé "
         "ráno. Nový začátek není jednorázová událost, ale možnost "
         "každého dne.",
         "Pavel píše: „Kdo je v Kristu, je nové stvoření.“ Nový začátek "
         "není jen předsevzetí, ale Boží dílo v nás."],
        ["Řekněte Bohu, co chcete nechat za sebou.",
         "Vyberte si jeden konkrétní krok, kterým začnete.",
         "Najděte si někoho, kdo vás na nové cestě povzbudí."],
        "Pane, chci začít znovu. Odpusť mi, co bylo, a veď mě dál. "
        "Děkuji, že tvé milosrdenství je nové každé ráno."),
    "knowgod": (
        ["Bůh se v Bibli dává poznat postupně: jako Stvořitel, jako "
         "ten, kdo vyvádí z otroctví, jako milosrdný a milostivý. Nejvíc "
         "ho ale ukazuje Ježíš: „Kdo vidí mne, vidí Otce.“",
         "Poznat Boha neznamená jen o něm něco vědět. Je to vztah – "
         "jako poznat přítele. Roste časem, rozhovorem a společnou "
         "cestou.",
         "Dobré je začít evangeliem, třeba podle Marka nebo Jana, "
         "a sledovat, jak Ježíš jedná s lidmi. Tak vypadá Bůh."],
        ["Začněte číst evangelium podle Marka, jednu kapitolu denně.",
         "Po každém čtení se zeptejte: co jsem se dozvěděl o Bohu?",
         "Řekněte Bohu, že ho chcete poznat."],
        "Bože, chci tě poznat. Ukaž se mi skrze Ježíše a jeho slova "
        "a veď mě blíž k sobě."),
    "meaning": (
        ["Kazatel v Bibli zkoušel najít smysl v práci, bohatství, "
         "zábavě i moudrosti – a všechno mu připadalo jako honba za "
         "větrem. Jeho závěr: bát se Boha a zachovávat jeho přikázání.",
         "Ježíš shrnul smysl života do dvou přikázání: milovat Boha "
         "celým srdcem a bližního jako sebe. Smysl tedy není věc, ale "
         "vztah.",
         "Pavel píše, že jsme Boží dílo, stvořené k dobrým skutkům, "
         "které Bůh připravil. Každý den nabízí malé příležitosti, jak "
         "tento smysl žít."],
        ["Zeptejte se: koho mohu dnes milovat konkrétním skutkem?",
         "Přemýšlejte, jaké dary vám Bůh dal pro druhé.",
         "Svěřte Bohu svou otázku po smyslu."],
        "Bože, dej mému životu smysl. Nauč mě milovat tebe i lidi "
        "kolem mě a ukaž mi, k čemu mě voláš."),
}
