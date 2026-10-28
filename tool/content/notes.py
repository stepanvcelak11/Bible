"""Aplikační poznámky (vlastní text aplikace).

Každá poznámka: místo, nadpis, výklad (co text znamená ve svých
souvislostech), spojovací most (obecná pravda platná i dnes) a aplikace
(jak ji uplatnit v životě). Výklad se drží toho, na čem se shodují
křesťané různých tradic; sporné otázky jen naznačuje.
"""

N = []


def note(ref, title, explanation, bridge, application):
    N.append(dict(ref=ref, title=title, explanation=explanation,
                  bridge=bridge, application=application))


# --- Evangelium podle Marka -------------------------------------------------
note("Mk 1,1-8", "Připravte cestu",
     "Marek začíná bez příběhu o narození – rovnou Janem Křtitelem, který "
     "podle proroků připravuje cestu Pánu. Lidé vyznávali hříchy a dávali "
     "se pokřtít v Jordánu na znamení obrácení.",
     "Setkání s Ježíšem začíná upřímností: přiznat, kde jsme sešli z cesty.",
     "Je v mém životě něco, co „zatarasilo cestu“ Bohu? Pokání není "
     "jednorázový pocit, ale změna směru – můžu dnes udělat jeden "
     "konkrétní krok.")
note("Mk 1,14-20", "Pojďte za mnou",
     "Ježíš ohlašuje, že Boží království je blízko, a volá rybáře Šimona, "
     "Ondřeje, Jakuba a Jana. Ti nechávají sítě i otce a jdou za ním.",
     "Ježíš povolává obyčejné lidi uprostřed jejich práce a dává jim nový "
     "smysl.",
     "Následovat Ježíše nemusí znamenat změnit povolání, ale vždy znamená "
     "změnit priority. Co by pro mě dnes znamenalo „nechat sítě“?")
note("Mk 1,35-39", "Modlitba v ranním tichu",
     "Po náročném dni plném uzdravování Ježíš brzy ráno odchází na pusté "
     "místo a modlí se. Když ho učedníci najdou, nevrací se k úspěchu, "
     "ale jde kázat dál.",
     "I Ježíš potřeboval čas o samotě s Otcem; z modlitby čerpal směr.",
     "Najdu si dnes chvíli ticha s Bohem – i krátkou? Modlitba pomáhá "
     "rozlišit, co je důležité, a ne jen naléhavé.")
note("Mk 2,1-12", "Přátelé, kteří prorazili střechu",
     "Čtyři muži přinesou ochrnutého, a když se nedostanou dovnitř, "
     "rozeberou střechu. Ježíš nejprve odpouští hříchy a pak muže uzdraví "
     "– ukazuje, že má Boží pravomoc.",
     "Víra se někdy projevuje vytrvalostí a péčí o druhé. Ježíš řeší "
     "nejhlubší potřebu člověka – vztah s Bohem.",
     "Za koho mohu dnes „nést nosítka“ – modlitbou, návštěvou, praktickou "
     "pomocí? A dovolím Ježíši, aby se dotkl i mé nejhlubší potřeby?")
note("Mk 2,13-17", "Lékař pro nemocné",
     "Ježíš povolá celníka Leviho a jí s celníky a hříšníky. Zbožní "
     "kritici se pohoršují; Ježíš odpovídá, že lékaře potřebují nemocní.",
     "Ježíš nepřišel pro ty, kdo si myslí, že jsou v pořádku, ale pro ty, "
     "kdo vědí, že potřebují pomoc.",
     "S kým se stýkám? Je moje společenství otevřené lidem, kteří „nezapadají“? "
     "A dokážu si přiznat, že i já potřebuji lékaře?")
note("Mk 3,1-6", "Sobota pro člověka",
     "Ježíš v synagoze uzdraví muže s odumřelou rukou, i když je sobota. "
     "Farizeové sledují, zda poruší pravidla; Ježíš se ptá, zda je v sobotu "
     "dovoleno činit dobro.",
     "Boží přikázání slouží životu a lásce; když se pravidla stanou "
     "důležitější než člověk, minuli jsme jejich smysl.",
     "Neslouží někdy moje zásady k tomu, abych druhé soudil, místo abych jim "
     "pomohl? Kde mohu dnes udělat dobro, i když to „není zvykem“?")
note("Mk 4,1-20", "Půda srdce",
     "Podobenství o rozsévači popisuje čtyři druhy půdy: cestu, skálu, "
     "trní a dobrou zem. Ježíš sám vysvětluje, že jde o různé způsoby, "
     "jak lidé přijímají Boží slovo.",
     "Slovo je stejné; rozdíl je v tom, jak ho přijímáme a co mu "
     "dovolíme v nás udusit.",
     "Co je dnes mým „trním“ – starosti, peníze, spěch? Jak mohu připravit "
     "půdu, aby Boží slovo mohlo přinést ovoce?")
note("Mk 4,35-41", "Bouře na jezeře",
     "Učedníci, zkušení rybáři, mají strach o život, zatímco Ježíš spí. "
     "Probudí ho výčitkou; Ježíš utiší vítr i vlny a ptá se na jejich víru.",
     "Ježíšova přítomnost neznamená, že bouře nepřijdou, ale že v nich "
     "nejsme sami.",
     "Jaká bouře je teď v mém životě? Mohu ji Ježíši svěřit – i s otázkou "
     "„Nezáleží ti na tom?“. On ji slyší.")
note("Mk 5,21-43", "Dvě dcery",
     "Jairos prosí za umírající dceru; cestou se Ježíše dotkne žena, "
     "která dvanáct let krvácí. Ježíš se zastaví, uzdraví ji a nazve ji "
     "„dcero“. Pak vzkřísí Jairovu dceru.",
     "Pro Ježíše není nikdo „vyrušením“. Má čas pro vlivného představeného "
     "i pro nečistou a opomíjenou ženu.",
     "Komu bych dnes mohl věnovat pozornost, i když spěchám? A kde mám "
     "slyšet Ježíšovo „Neboj se, jen věř“?")
note("Mk 6,30-44", "Co máte?",
     "Unavení učedníci chtějí zástup propustit. Ježíš říká: „Dejte vy jim "
     "jíst“ a ptá se, kolik mají chlebů. Z pěti chlebů a dvou ryb nasytí "
     "tisíce.",
     "Bůh nečeká, až budeme mít dost; chce to málo, co máme, aby ho "
     "požehnal a rozmnožil.",
     "Co mám v rukou – čas, schopnosti, peníze – a nabízím to Bohu? "
     "Nepodceňuji to, protože se to zdá málo?")
note("Mk 7,1-23", "Čisté srdce",
     "Farizeové kritizují učedníky, že si před jídlem rituálně neumývají "
     "ruce. Ježíš učí, že člověka neznečišťuje to, co do něj vchází, ale "
     "to, co vychází ze srdce.",
     "Bůh hledí na srdce, ne jen na vnější zbožnost a tradice.",
     "Nestarám se víc o to, jak vypadám před lidmi, než o to, co je ve "
     "mně? Které myšlenky či postoje potřebuji předložit Bohu?")
note("Mk 8,27-38", "Za koho mě pokládáte?",
     "U Cesareje Filipovy Petr vyzná, že Ježíš je Mesiáš. Ježíš pak "
     "poprvé mluví o svém utrpení a vyzývá: kdo chce jít za ním, ať zapře "
     "sám sebe a vezme svůj kříž.",
     "Vyznat Ježíše znamená přijmout i jeho cestu – cestu služby a "
     "sebeobětování, ne jen úspěchu.",
     "Kdo je pro mě Ježíš – učitel, vzor, nebo Pán? Co pro mě dnes "
     "znamená „zapřít sám sebe“ v konkrétním vztahu nebo rozhodnutí?")
note("Mk 9,14-29", "Věřím, pomoz mé nevíře",
     "Otec nemocného chlapce prosí: „Můžeš-li něco…“ Ježíš odpovídá, že "
     "všechno je možné tomu, kdo věří. Otec volá: „Věřím, pomáhej mé "
     "nevíře!“",
     "Víra a pochybnosti mohou žít vedle sebe. Ježíš přijímá i slabou, "
     "upřímnou víru.",
     "Nemusím předstírat silnou víru. Mohu Bohu přinést své pochybnosti "
     "a prosit, aby moje víra rostla.")
note("Mk 9,33-37", "Kdo je největší",
     "Učedníci se cestou hádají, kdo z nich je největší. Ježíš postaví "
     "doprostřed dítě: kdo chce být první, ať je služebníkem všech.",
     "V Božím království se velikost měří službou, ne postavením.",
     "Kde toužím po uznání? Jak mohu dnes sloužit někomu, kdo mi to "
     "nemůže oplatit?")
note("Mk 10,13-16", "Jako dítě",
     "Učedníci odhánějí rodiče s dětmi; Ježíš se rozhorlí a děti žehná. "
     "Kdo nepřijme Boží království jako dítě, nevejde do něj.",
     "Do Božího království se vstupuje s důvěrou a otevřenýma rukama, ne "
     "se zásluhami.",
     "Dokážu přijímat od Boha jako dítě – s důvěrou a bez snahy si vše "
     "zasloužit? A mají u mě místo děti a „malí“?")
note("Mk 10,17-31", "Jedno ti chybí",
     "Bohatý muž dodržuje přikázání, ale když ho Ježíš vyzve, aby rozdal "
     "majetek a šel za ním, odchází smutný. Ježíš s ním soucítí – "
     "„zahleděl se na něho s láskou“.",
     "Cokoli, co držíme pevněji než Boha, se může stát překážkou.",
     "Co by mi Ježíš řekl, že „mi chybí“? Je něco, bez čeho si život "
     "neumím představit víc než bez Boha?")
note("Mk 10,35-45", "Přišel sloužit",
     "Jakub a Jan chtějí čestná místa. Ježíš vysvětluje, že on sám "
     "nepřišel, aby si dal sloužit, ale aby sloužil a dal svůj život jako "
     "výkupné za mnohé.",
     "Ježíšova služba je vzorem i základem: jeho oběť nám otevírá cestu "
     "k Bohu.",
     "V jakých situacích čekám, že mi budou druzí sloužit? Kde mohu "
     "„sloužit první“ – v rodině, v práci, ve sboru?")
note("Mk 10,46-52", "Co chceš, abych pro tebe udělal?",
     "Slepý Bartimaios křičí, i když ho okřikují. Ježíš se zastaví a ptá "
     "se, co chce. Bartimaios prohlédne a jde za ním.",
     "Ježíš chce, abychom své potřeby vyslovili; jeho zájem je osobní.",
     "Co bych odpověděl, kdyby se mě Ježíš dnes zeptal, co chci? Nebojím "
     "se ho prosit konkrétně?")
note("Mk 11,1-11", "Král na oslátku",
     "Ježíš vjíždí do Jeruzaléma na oslátku, jak předpověděl Zacharjáš. "
     "Zástupy volají „Hosanna“ – očekávají politického osvoboditele.",
     "Ježíš je král, ale jinak, než lidé čekají: pokorný, přinášející "
     "pokoj, ne násilí.",
     "Neočekávám od Ježíše hlavně splnění vlastních představ? Jsem "
     "připraven ho přijmout jako krále i tehdy, když jedná jinak?")
note("Mk 12,28-34", "Největší přikázání",
     "Učitel zákona se ptá na nejdůležitější přikázání. Ježíš spojuje "
     "lásku k Bohu (Dt 6,4–5) s láskou k bližnímu (Lv 19,18).",
     "Celá víra stojí na lásce – k Bohu celým srdcem a k bližnímu jako "
     "k sobě.",
     "Kterou z obou lásek dnes zanedbávám? Jeden konkrétní krok lásky "
     "k Bohu a jeden k bližnímu.")
note("Mk 12,41-44", "Vdovin dar",
     "Ježíš pozoruje dárce u chrámové pokladnice. Chudá vdova dá dvě "
     "drobné mince – vše, co měla. Ježíš říká, že dala víc než všichni.",
     "Bůh neměří dar velikostí, ale srdcem a obětí.",
     "Dávám Bohu a druhým z přebytku, nebo s důvěrou? Co pro mě znamená "
     "štědrost v mé situaci?")
note("Mk 14,32-42", "Getsemane",
     "Ježíš prožívá hlubokou úzkost a modlí se: „Abba, Otče… ne co já "
     "chci, ale co ty.“ Učedníci zatím spí.",
     "Ježíš zná lidský strach a bolest. Poslušnost Bohu neznamená "
     "nic necítit, ale svěřit se mu.",
     "Mohu Bohu upřímně říct, co cítím, a přesto se mu odevzdat? A jak "
     "mohu „bdít“ s druhými v jejich těžkých chvílích?")
note("Mk 14,66-72", "Petrovo selhání",
     "Petr, který sliboval věrnost až do smrti, třikrát zapře, že Ježíše "
     "zná. Když zakokrhá kohout, rozpláče se.",
     "I horliví učedníci selhávají. Ježíš Petra později obnoví (J 21) – "
     "selhání nemusí být konec.",
     "Kde jsem selhal? Lítost mě může vést zpět k Ježíši, ne do "
     "beznaděje.")
note("Mk 15,33-39", "Opravdu Boží Syn",
     "Ježíš umírá s výkřikem „Bože můj, proč jsi mě opustil?“ (Ž 22). "
     "Chrámová opona se roztrhne a římský setník vyzná: „Tento člověk byl "
     "opravdu Boží Syn.“",
     "Ve chvíli největší slabosti se zjevuje, kdo Ježíš je. Cesta k Bohu "
     "je otevřena.",
     "Co pro mě znamená, že Ježíš šel až do smrti? Mohu se s ním modlit "
     "i slovy opuštěnosti – i on je znal.")
note("Mk 16,1-8", "Prázdný hrob",
     "Ženy jdou pomazat tělo, ale hrob je prázdný. Anděl ohlašuje: "
     "„Vstal, není zde.“ Ženy utíkají se strachem.",
     "Vzkříšení je Boží odpověď na smrt – a začátek nové naděje.",
     "Kde v mém životě vládne „pohřební nálada“? Velikonoční zpráva "
     "zve k naději i tam, kde je strach.")

# --- List Filipským -----------------------------------------------------------
note("Fp 1,3-11", "Vděčnost za druhé",
     "Pavel děkuje za Filipské a modlí se, aby jejich láska rostla "
     "v poznání. Je přesvědčen, že Bůh své dílo v nich dokončí.",
     "Bůh nedokončuje svou práci napůl; vděčnost za druhé posiluje "
     "společenství.",
     "Za koho mohu dnes Bohu poděkovat? Mohu mu to i říct – povzbudí ho to.")
note("Fp 1,12-21", "Vězení, které posloužilo evangeliu",
     "Pavel píše z vězení, a přesto se raduje, protože se evangelium šíří. "
     "„Život je pro mne Kristus a smrt zisk.“",
     "Bůh dokáže použít i těžké okolnosti; radost nezávisí na pohodlí.",
     "Jak by se moje těžká situace mohla stát příležitostí? Co je středem "
     "mého života?")
note("Fp 2,1-11", "Smýšlení Kristovo",
     "Pavel vyzývá k jednotě a pokoře a cituje píseň o Kristu, který se "
     "ponížil až k smrti na kříži, a proto ho Bůh vyvýšil.",
     "Pokora není podceňování sebe, ale ochota dát přednost druhým, jako "
     "to udělal Kristus.",
     "Ve kterém vztahu bych mohl „pokládat druhé za přednější“? Jedna "
     "konkrétní služba dnes.")
note("Fp 2,12-18", "Bez reptání",
     "Filipští mají „uskutečňovat svou spásu“ – žít ji v praxi – s vědomím, "
     "že to Bůh v nich působí. Mají svítit jako hvězdy, bez reptání.",
     "Bůh dává chuť i sílu; my spolupracujeme.",
     "Kde často reptám? Zkusit dnes místo stížnosti poděkovat nebo pomoci.")
note("Fp 3,7-14", "Běžet k cíli",
     "Pavel považuje všechny své zásluhy za ztrátu ve srovnání s poznáním "
     "Krista. Zapomíná na to, co je za ním, a běží k cíli.",
     "Minulé úspěchy ani selhání nás nemusejí držet; cílem je Kristus.",
     "Co mě drží zpátky – vina, nebo pýcha na úspěchy? Jaký je můj další "
     "krok „k cíli“?")
note("Fp 4,4-7", "Pokoj místo úzkosti",
     "„Radujte se v Pánu vždycky… O nic nebuďte ustaraní.“ Místo starostí "
     "modlitba s díkůvzdáním – a Boží pokoj bude střežit srdce.",
     "Úzkost lze proměnit v modlitbu; vděčnost otevírá prostor pro pokoj.",
     "Napsat si tři starosti a ke každé jednu prosbu a jedno poděkování.")
note("Fp 4,8-9", "Na co myslím",
     "Pavel vyzývá myslet na to, co je pravdivé, čestné, spravedlivé, "
     "čisté, milé a chvályhodné.",
     "Myšlenky formují život; mysl můžeme cíleně „krmit“ dobrým.",
     "Čím plním mysl – zprávami, sítěmi, pomluvami? Jedna změna dnes.")
note("Fp 4,10-13", "Tajemství spokojenosti",
     "Pavel se naučil být spokojen v nedostatku i v hojnosti. „Všechno "
     "mohu v Kristu, který mi dává sílu.“",
     "Verš 13 nemluví o úspěchu ve všem, ale o síle snést každou situaci.",
     "Kde jsem nespokojený? Jak by vypadalo „být spokojen“ s Kristovou "
     "pomocí právě tam?")

# --- List Jakubův -------------------------------------------------------------
note("Jk 1,2-8", "Radost ve zkouškách",
     "Jakub vyzývá považovat zkoušky za radost, protože vedou "
     "k vytrvalosti. Kdo potřebuje moudrost, ať o ni prosí Boha.",
     "Zkoušky nejsou samy o sobě dobré, ale Bůh je může použít k růstu.",
     "Co se mohu v současné zkoušce naučit? Poprosit o moudrost – konkrétně.")
note("Jk 1,19-27", "Nejen slyšet, ale jednat",
     "Být rychlý k naslouchání a pomalý k hněvu. Kdo slovo jen slyší, je "
     "jako ten, kdo se podívá do zrcadla a zapomene, jak vypadá.",
     "Pravá zbožnost se ukazuje v péči o slabé a v čistotě života.",
     "Co jsem v Bibli naposledy četl – a co z toho udělám?")
note("Jk 2,1-13", "Bez nadržování",
     "Jakub kárá sbory, které dávají přednost bohatým před chudými. "
     "Láska k bližnímu je „královský zákon“.",
     "Bůh nehledí na postavení; nesmíme ani my.",
     "Jak jednám s lidmi, kteří mi nemohou být užiteční? Pozdravit dnes "
     "a vyslechnout někoho přehlíženého.")
note("Jk 2,14-26", "Víra a skutky",
     "Víra bez skutků je mrtvá. Jakub nepopírá spásu z milosti (srv. Ef "
     "2,8–10), ale ukazuje, že živá víra se projeví v jednání.",
     "Skutky nejsou cenou za spásu, ale ovocem opravdové víry.",
     "Kde by se moje víra mohla dnes stát viditelnou – praktickou pomocí?")
note("Jk 3,1-12", "Síla jazyka",
     "Jazyk je malý úd, ale jako jiskra dokáže zapálit les. Týmiž ústy "
     "dobrořečíme Bohu i proklínáme lidi.",
     "Slova mají moc budovat i ničit.",
     "Dnes si všímat svých slov; jednu kritiku nahradit povzbuzením.")
note("Jk 4,13-17", "Dá-li Pán",
     "Jakub varuje před plánováním, které počítá jen s vlastní silou. "
     "Život je jako pára; máme říkat: „Bude-li Pán chtít…“",
     "Plánovat je dobré, ale s pokorou a vědomím Boží svrchovanosti.",
     "Předložit Bohu své plány na tento týden.")
note("Jk 5,13-18", "Modlitba víry",
     "Trpí někdo? Ať se modlí. Je nemocný? Ať zavolá starší sboru. "
     "Vyznávejte si hříchy a modlete se jeden za druhého.",
     "Modlitba je pro každou situaci a nemá být osamělá.",
     "Komu mohu svěřit svou prosbu – a za koho se dnes modlit?")

# --- Rút ----------------------------------------------------------------------
note("Rt 1,6-18", "Kam ty půjdeš, půjdu i já",
     "Noemi po smrti manžela a synů posílá snachy domů. Orpa odejde, Rút "
     "však zůstává: „Tvůj lid je můj lid a tvůj Bůh je můj Bůh.“",
     "Věrnost a láska se ukazují v těžkých chvílích.",
     "Kdo potřebuje moji věrnost právě teď, kdy je to nepohodlné?")
note("Rt 2,1-12", "Paběrkování a laskavost",
     "Rút sbírá klasy na poli Bóaze, který jí laskavě vyjde vstříc. "
     "Zákon dovoloval chudým paběrkovat (Lv 19,9–10).",
     "Bůh pečuje o chudé i skrze laskavost lidí.",
     "Jak mohu „nechat klasy na okraji pole“ pro někoho v nouzi?")
note("Rt 4,13-17", "Boží příběh v obyčejném životě",
     "Bóaz si bere Rút; jejich syn Óbed je dědem krále Davida. "
     "Z příběhu cizinky se stává součást dějin spásy.",
     "Bůh tká svůj plán i z obyčejných rozhodnutí a věrnosti.",
     "Věřím, že i moje obyčejné dny mají v Božím příběhu smysl?")

# --- Jonáš --------------------------------------------------------------------
note("Jon 1,1-16", "Útěk před Bohem",
     "Jonáš má jít do Ninive, ale utíká opačným směrem. V bouři se přizná "
     "a nechá se hodit do moře; Bůh pošle rybu.",
     "Před Bohem se nedá utéct – ale jeho jednání i tehdy nese milost.",
     "Před čím utíkám? Co by znamenalo udělat krok správným směrem?")
note("Jon 2,1-11", "Modlitba z hlubin",
     "Jonáš se v rybě modlí žalmem díků. „Spása je od Hospodina.“",
     "I v nejhlubším bodě je možné volat k Bohu.",
     "Zkusit vlastními slovy napsat modlitbu z „hlubin“ své situace.")
note("Jon 3,1-10", "Druhá šance",
     "Bůh promlouvá k Jonášovi podruhé. Ninive se po jeho kázání kaje "
     "a Bůh od trestu upouští.",
     "Bůh dává druhé šance – prorokovi i nepřátelům.",
     "Komu bych měl dát druhou šanci? A přijímám tu svou?")
note("Jon 4,1-11", "Proč se zlobíš?",
     "Jonáš se zlobí, že Bůh odpustil. Bůh mu skrze skočec ukazuje svůj "
     "soucit s Ninive – „nemám mít soucit s tak velkým městem?“",
     "Boží milosrdenství je větší než naše předsudky a hněv.",
     "Komu nepřeju Boží milost? Modlit se dnes za někoho, koho nemám rád.")

# --- Další známá místa -------------------------------------------------------
note("Gn 1,26-31", "K Božímu obrazu",
     "Člověk je stvořen k Božímu obrazu, muž i žena, s úkolem pečovat "
     "o stvoření. Bůh vidí vše „velmi dobré“.",
     "Každý člověk má jedinečnou hodnotu – nezávisle na výkonu či původu.",
     "Jak jednám s lidmi, které nemám rád? Nesou Boží obraz. A jak pečuji "
     "o svět, který mi byl svěřen?")
note("Gn 3,1-13", "Kde jsi?",
     "Had zpochybní Boží slovo, člověk neuposlechne, schová se a svaluje "
     "vinu. Bůh přesto přichází s otázkou „Kde jsi?“",
     "Hřích začíná nedůvěrou v Boží dobrotu a vede ke skrývání; Bůh "
     "hledá člověka.",
     "Před čím se skrývám? Odpovědět dnes Bohu upřímně na otázku „Kde jsi?“")
note("Gn 22,1-14", "Hospodin opatří",
     "Abraham je ochoten obětovat Izáka; Bůh ho zastaví a opatří berana. "
     "Abraham nazve místo „Hospodin opatří“.",
     "Bůh zkouší víru, ale nežádá lidské oběti – sám opatřuje. Křesťané "
     "zde vidí předobraz Kristovy oběti.",
     "Co je mým „Izákem“ – něco, co držím pevněji než Boha? Důvěřuji, "
     "že Bůh opatří?")
note("Ž 1,1-6", "Strom u vody",
     "Blažený je ten, kdo rozjímá o Hospodinově zákoně – je jako strom "
     "zasazený u vody, který nese ovoce.",
     "Pravidelné čtení Božího slova dává životu kořeny a stabilitu.",
     "Kdy a kde si najdu pravidelný čas na Bibli? Stačí začít malým "
     "krokem.")
note("Ž 23,1-6", "Hospodin je můj pastýř",
     "David popisuje Boha jako pastýře, který vede, občerstvuje a provází "
     "i údolím stínu smrti; jako hostitele, který prostírá stůl.",
     "Bůh se stará o každou fázi života – odpočinek, vedení, nebezpečí "
     "i budoucnost.",
     "Ve kterém verši se dnes nacházím – na zelené pastvě, nebo v údolí? "
     "Přečíst si žalm pomalu jako modlitbu.")
note("Ž 51,3-14", "Stvoř mi čisté srdce",
     "David po hříchu s Batšebou prosí o milost, vyznává vinu a prosí "
     "o nové srdce a obnovu radosti ze spásy.",
     "Upřímné pokání neomlouvá, ale spoléhá na Boží milosrdenství.",
     "Použít tento žalm jako vlastní modlitbu, když selžu.")
note("Ž 139,1-18", "Znáš mě",
     "Bůh zná každou myšlenku i cestu; nelze se před ním skrýt. Utvořil "
     "člověka už v lůně matky.",
     "Být úplně poznán a přesto milován – to je základ jistoty.",
     "Poděkovat Bohu za to, jak mě stvořil – i za to, co na sobě nemám rád.")
note("Mt 5,1-12", "Blahoslavenství",
     "Ježíš blahoslaví chudé duchem, plačící, tiché, hladové po "
     "spravedlnosti, milosrdné, čisté, pokojné a pronásledované.",
     "Boží království obrací hodnoty světa: šťastní jsou ti, kdo jsou "
     "otevření Bohu a druhým.",
     "Které blahoslavenství mě dnes nejvíc oslovuje – a proč?")
note("Mt 5,13-16", "Sůl a světlo",
     "Učedníci jsou solí země a světlem světa; jejich dobré skutky mají "
     "vést lidi k oslavě Otce.",
     "Víra není soukromá – má být vidět a chutnat ve světě.",
     "Kde mohu dnes „svítit“ – v práci, škole, sousedství?")
note("Mt 6,25-34", "Nestarejte se",
     "Ježíš ukazuje na ptáky a lilie: Otec o ně pečuje, tím spíš o nás. "
     "Hledejte nejprve Boží království.",
     "Starost nic nezmění; důvěra mění priority.",
     "Co je pro mě „nejprve“? Svěřit Bohu jednu konkrétní starost.")
note("Mt 7,1-5", "Tříska a trám",
     "Nesuďte… Proč vidíš třísku v oku bratra, a trám ve svém nevidíš?",
     "Nejdřív sebezkoumání, pak pomoc druhým – s pokorou.",
     "Koho dnes rychle soudím? Co by mi Bůh ukázal na mně?")
note("Mt 7,24-27", "Dům na skále",
     "Kdo slyší Ježíšova slova a plní je, je jako muž, který postavil "
     "dům na skále; bouře ho nevyvrátí.",
     "Rozhodující není jen slyšet, ale jednat.",
     "Na čem stavím svůj život? Jedno Ježíšovo slovo, které dnes udělám.")
note("J 3,1-17", "Znovu se narodit",
     "Nikodém přichází v noci. Ježíš mluví o novém narození z Ducha "
     "a o Boží lásce: „Tak Bůh miloval svět…“",
     "Nový život je Boží dar, který přijímáme vírou.",
     "Přijal jsem Boží lásku osobně? Komu bych mohl J 3,16 vysvětlit "
     "vlastními slovy?")
note("1K 13,1-13", "Píseň o lásce",
     "Pavel píše korintskému sboru plnému darů, ale i sporů: bez lásky "
     "nejsou dary nic. Láska je trpělivá, laskavá, nezávidí…",
     "Láska je měřítkem všeho duchovního.",
     "Dosadit své jméno místo slova „láska“ (v. 4–7) – kde to nesedí?")


# --- Genesis: Josef ------------------------------------------------------------
note("Gn 37,1-11", "Oblíbený syn a závist bratrů",
     "Jákob dává najevo, že Josefa miluje víc než ostatní syny, a daruje mu "
     "zvláštní suknici. Josef navíc bratrům vypráví sny, v nichž se mu "
     "klanějí. Bratři ho začnou nenávidět.",
     "Nadržování v rodině a nerozvážná pýcha živí závist, která může "
     "přerůst v něco mnohem horšího.",
     "Je v mé rodině nebo práci někdo, komu nevědomky nadržuji – nebo "
     "naopak někdo, komu závidím? Závist je lepší pojmenovat před Bohem "
     "dřív, než začne řídit moje jednání.")
note("Gn 39,1-23", "Věrnost, když se nikdo nedívá",
     "Josef je prodán do Egypta, ale Hospodin je s ním a Potífar mu svěří "
     "celý dům. Když ho Potífarova žena svádí, odmítá: „Jak bych mohl "
     "spáchat tak velké zlo a zhřešit proti Bohu?“ Je křivě obviněn a "
     "skončí ve vězení – a i tam je Hospodin s ním.",
     "Bezúhonnost se rozhoduje v soukromí. Bůh je s námi i tehdy, když "
     "nám věrnost přinese nespravedlnost.",
     "Kde mám dnes pokušení, o kterém by nikdo nevěděl? Josef pokušení "
     "neanalyzoval – utekl. Pomáhá předem vědět, kde jsou mé hranice.")
note("Gn 45,1-15", "Odpuštění, které obejme",
     "Josef, nyní druhý muž Egypta, se dá bratrům poznat. Místo pomsty "
     "pláče a říká: „Netrapte se… k zachování života mě Bůh poslal před "
     "vámi.“ Objímá je a líbá.",
     "Odpuštění je možné, když v příběhu vidíme Boží ruku větší než "
     "křivdu, která se nám stala.",
     "Komu potřebuji odpustit? Odpuštění neznamená tvrdit, že se nic "
     "nestalo, ale rozhodnout se nesplácet zlo zlem a nechat soud Bohu.")
note("Gn 50,15-21", "Bůh to obrátil k dobrému",
     "Po Jákobově smrti se bratři bojí Josefovy pomsty. Josef odpovídá: "
     "„Zamýšleli jste proti mně zlo, ale Bůh to zamýšlel k dobrému.“",
     "Bůh dokáže použít i zlé úmysly lidí k naplnění svých dobrých cílů "
     "(srv. Ř 8,28).",
     "Které těžké období mého života vidím dnes jinak? Do toho, co ještě "
     "nechápu, můžu vložit stejnou důvěru.")

# --- Evangelium podle Jana ------------------------------------------------------
note("J 1,1-18", "Slovo se stalo tělem",
     "Jan začíná „na počátku“ jako Genesis: Slovo bylo u Boha a bylo Bůh, "
     "skrze něj vše vzniklo. Toto Slovo se stalo člověkem – Ježíšem – a "
     "„přebývalo mezi námi“ (doslova „postavilo stan“). Kdo ho přijmou, "
     "stávají se Božími dětmi.",
     "Bůh není vzdálený; v Ježíši přišel až k nám a ukázal, jaký je.",
     "Když přemýšlím, jaký je Bůh, dívám se na Ježíše? Přijmout ho "
     "znamená důvěřovat mu – a to dává novou identitu: jsem Boží dítě.")
note("J 2,1-11", "Víno na svatbě v Káni",
     "Na svatbě dojde víno – pro hostitele velká ostuda. Marie řekne "
     "služebníkům: „Udělejte, cokoli vám řekne.“ Ježíš promění vodu v "
     "kamenných nádobách na nejlepší víno. Je to první „znamení“.",
     "Ježíš se zajímá i o obyčejné lidské radosti a starosti; jeho dary "
     "jsou štědré.",
     "Kde mi „došlo víno“ – síla, radost, nápady? Mariina rada platí: "
     "udělat, co Ježíš řekne, i když se to zdá obyčejné (nosit vodu).")
note("J 4,1-26", "Živá voda u studny",
     "Ježíš prosí Samařanku o vodu – Žid mluví se Samařankou, muž se ženou "
     "s pošramocenou pověstí. Nabízí jí „živou vodu“, která uhasí žízeň "
     "navždy, a odhaluje jí, že je Mesiáš.",
     "Lidská duše má žízeň, kterou nic jiného nenasytí. Ježíš překračuje "
     "bariéry, aby ji uhasil.",
     "Čím se snažím uhasit vnitřní žízeň? A koho přehlížím kvůli jeho "
     "původu nebo minulosti, ačkoli Ježíš by s ním mluvil?")
note("J 5,1-15", "Chceš být zdráv?",
     "U rybníka Bethesda leží muž nemocný 38 let. Ježíš se ho ptá: „Chceš "
     "být zdráv?“ Muž se vymlouvá, že nemá nikoho, kdo by mu pomohl. Ježíš "
     "ho uzdraví slovem: „Vstaň, vezmi své lůžko a choď.“",
     "Ježíš oslovuje i dlouholetou beznaděj a přináší změnu, kterou "
     "bychom sami nezvládli.",
     "Zvykl jsem si na něco, co mě ochromuje? Ježíšova otázka je osobní – "
     "můžu mu upřímně odpovědět a dovolit mu, aby věci změnil.")
note("J 6,35-40", "Chléb života",
     "Po nasycení zástupů Ježíš říká: „Já jsem chléb života. Kdo přichází "
     "ke mně, nebude nikdy hladovět.“ Zástupy chtěly další jídlo; Ježíš "
     "nabízí sám sebe.",
     "Ježíš není jen dárce věcí, které potřebujeme – on sám je tím, co "
     "potřebujeme nejvíc.",
     "Hledám u Ježíše hlavně řešení problémů, nebo jeho samotného? "
     "„Každodenní chléb“ vztahu s ním je modlitba a jeho slovo.")
note("J 9,1-12", "Kdo zhřešil?",
     "Učedníci se ptají, čí hřích způsobil, že se muž narodil slepý. Ježíš "
     "odpovídá: ani on, ani rodiče – „ale aby se na něm zjevily skutky "
     "Boží“, a uzdraví ho.",
     "Utrpení není vždy trestem za konkrétní hřích. Ježíš místo hledání "
     "viníka jedná.",
     "Hledám u druhých (nebo u sebe) viníka všeho zlého? Lepší otázka "
     "než „proč“ bývá „co tu chce Bůh udělat a jak můžu pomoct?“")
note("J 10,1-18", "Dobrý pastýř",
     "Ježíš je „dveře“ k ovcím i „dobrý pastýř“, který zná své ovce jménem "
     "a ony znají jeho hlas. Na rozdíl od najatého pomocníka neuteče – "
     "položí za ovce život.",
     "Ježíš vede osobně, zná nás a jeho péče jde až k obětování sebe.",
     "Jak se učím rozpoznávat jeho hlas mezi ostatními hlasy? Čas v "
     "Písmu a modlitbě je jako poslouchat pastýře, dokud ho nepoznám.")
note("J 11,17-44", "Já jsem vzkříšení a život",
     "Lazar je čtyři dny v hrobě. Marta říká: „Pane, kdybys tu byl…“ "
     "Ježíš odpovídá: „Já jsem vzkříšení a život.“ U hrobu pláče – a pak "
     "Lazara zavolá ven.",
     "Ježíš sdílí náš zármutek, a přitom má moc nad smrtí.",
     "Smím před Ježíšem plakat i se ptát „proč jsi nepřišel dřív?“. "
     "A zároveň slyšet jeho otázku: „Věříš tomu?“")
note("J 13,1-17", "Umývání nohou",
     "Při poslední večeři Ježíš vstane, opáše se ručníkem a umývá "
     "učedníkům nohy – práce otroka. Petr se brání. Ježíš říká: „Dal jsem "
     "vám příklad.“",
     "Ve vedení podle Ježíše je velikost ve službě.",
     "Komu můžu tento týden „umýt nohy“ – udělat nenápadnou, nepopulární "
     "službu? A umím si nechat posloužit, jako se to musel naučit Petr?")
note("J 14,1-14", "Cesta, pravda a život",
     "Učedníci jsou zneklidnění, že Ježíš odchází. Ježíš je ujišťuje, že "
     "jim připravuje místo. Na Tomášovu otázku odpovídá: „Já jsem ta cesta, "
     "pravda i život; nikdo nepřichází k Otci než skrze mne.“",
     "Ježíš není jen ukazatel cesty – je sám cestou k Bohu. Kdo vidí jeho, "
     "vidí Otce.",
     "Co mi „nedá spát“? Ježíš říká: „Ať se vaše srdce nechvěje.“ Důvěra "
     "v něj neodstraní všechny otázky, ale dává pevný bod.")
note("J 15,1-17", "Zůstaňte ve mně",
     "Ježíš je vinný kmen, učedníci ratolesti. Ovoce nevzniká snahou "
     "ratolesti, ale tím, že zůstává na kmeni. Ovoce je hlavně láska: "
     "„Milujte se navzájem, jako jsem já miloval vás.“",
     "Plodný život je výsledek spojení s Kristem, ne vlastního vypětí.",
     "Co pro mě znamená „zůstávat“ v Ježíši – v běžném dni? Možná začít "
     "den krátkou modlitbou a během dne se k němu vracet.")
note("J 17,20-26", "Ježíšova modlitba za nás",
     "Ježíš se modlí nejen za učedníky, ale i za ty, kdo uvěří skrze "
     "jejich slovo – tedy i za nás. Prosí, „aby všichni byli jedno“, aby "
     "svět poznal Boží lásku.",
     "Jednota křesťanů je svědectvím pro svět; Ježíš se za ni modlil.",
     "Jak přispívám k jednotě – ve sboru, mezi církvemi, v rodině? "
     "Ježíš se za mě modlil; můžu se modlit za ty, s nimiž si nerozumím.")
note("J 20,24-29", "Tomášovy pochybnosti",
     "Tomáš nebyl s ostatními, když se jim ukázal vzkříšený Ježíš, a "
     "nevěří. O týden později Ježíš přijde a nabídne mu své rány. Tomáš "
     "vyzná: „Můj Pán a můj Bůh!“",
     "Ježíš se nepohoršuje nad upřímnými pochybnostmi; vychází jim vstříc.",
     "S jakými otázkami zápasím? Můžu je přinést Ježíši i do společenství "
     "věřících – Tomáš zůstal s ostatními a tam Ježíše potkal.")
note("J 21,15-19", "Miluješ mě?",
     "Petr Ježíše třikrát zapřel. Vzkříšený Ježíš se ho u jezera třikrát "
     "ptá: „Miluješ mě?“ a třikrát mu svěřuje: „Pas mé ovce.“",
     "Ježíš obnovuje ty, kdo selhali, a dává jim nové poslání.",
     "Selhání nemusí být konec mého příběhu s Bohem. Na jakou Ježíšovu "
     "otázku dnes potřebuji odpovědět?")

# --- List Římanům ---------------------------------------------------------------
note("Ř 1,16-17", "Nestydím se za evangelium",
     "Pavel píše do Říma, centra moci: evangelium je Boží moc ke spasení "
     "pro každého, kdo věří. Odhaluje se v něm Boží spravedlnost – "
     "„spravedlivý z víry bude žít“ (Abk 2,4).",
     "Evangelium není jen myšlenka, ale Boží moc, která mění lidi.",
     "Kde se za víru stydím? Nemusím být kazatel – stačí se nebát říct, "
     "proč věřím, když se mě někdo zeptá.")
note("Ř 3,21-26", "Spravedlnost darem",
     "Všichni zhřešili a nedosahují Boží slávy. Ale Bůh nás ospravedlňuje "
     "zdarma, svou milostí, skrze vykoupení v Kristu Ježíši. Kristova "
     "smrt ukazuje, že Bůh je spravedlivý a zároveň ospravedlňuje.",
     "Před Bohem nemáme na co ukázat; dostáváme všechno jako dar.",
     "Snažím se Bohu „zasloužit“ jeho přijetí? Milost znamená, že můžu "
     "přestat počítat body a z vděčnosti začít jednat.")
note("Ř 5,1-11", "Pokoj s Bohem",
     "Ospravedlněni z víry máme pokoj s Bohem. Proto se můžeme chlubit "
     "i v souženích, protože vedou k vytrvalosti, osvědčenosti a naději. "
     "Bůh prokázal lásku tím, že Kristus zemřel za nás, když jsme ještě "
     "byli hříšníci.",
     "Boží láska nezačala ve chvíli, kdy jsme se polepšili. Proto ani "
     "těžkosti nejsou důkazem, že nás Bůh opustil.",
     "Jakou těžkost dnes prožívám? Můžu ji dát do Pavlova řetězu: "
     "soužení – vytrvalost – osvědčenost – naděje.")
note("Ř 6,1-14", "Mrtví hříchu, živí Bohu",
     "Znamená milost, že můžeme dál hřešit? Pavel odpovídá: rozhodně ne. "
     "Při křtu jsme byli spojeni s Kristovou smrtí i vzkříšením. Starý "
     "člověk byl ukřižován; máme se pokládat za mrtvé hříchu a živé Bohu.",
     "Milost není povolení hřešit, ale moc žít nový život.",
     "Ve které oblasti se mi nechce věřit, že „to už nemusí vládnout“? "
     "Můžu dnes vědomě „dát své údy“ do služby Bohu – ruce, jazyk, čas.")
note("Ř 7,14-25", "Vnitřní boj",
     "„Nedělám dobro, které chci, ale zlo, které nechci.“ Pavel popisuje "
     "rozpolcenost člověka, který zná Boží zákon, ale nemá sílu ho "
     "naplnit. Končí výkřikem: „Kdo mě vysvobodí?“ a díkůvzdáním za "
     "Ježíše Krista.",
     "Boj s hříchem znají i zralí věřící; vysvobození nepřichází z vlastní "
     "síly, ale skrze Krista.",
     "Nejsem v boji divný ani sám. Místo zoufalství nebo rezignace můžu "
     "dělat totéž co Pavel: nazvat věci pravdivě a obrátit se ke Kristu.")
note("Ř 8,1-17", "Žádné odsouzení",
     "„Nyní tedy není žádného odsouzení pro ty, kdo jsou v Kristu Ježíši.“ "
     "Duch svatý v nás dává život a sílu. Nejsme otroci ve strachu, ale "
     "děti, které volají „Abba, Otče“.",
     "Křesťanský život nestojí na výkonu ze strachu, ale na vztahu "
     "s Otcem skrze Ducha.",
     "Slyším v sobě častěji hlas odsouzení, nebo hlas Otce? Můžu si dnes "
     "nahlas přečíst Ř 8,1 a 8,15.")
note("Ř 8,28-39", "Nic nás neodloučí",
     "Bůh působí všechno k dobrému těm, kdo ho milují. Pavel vypočítává "
     "soužení, hlad, nebezpečí, meč – a končí jistotou, že nic, ani smrt "
     "ani život, nás nemůže odloučit od Boží lásky v Kristu.",
     "Boží láska je pevnější než všechno, co nás může potkat.",
     "Čeho se nejvíc bojím? Můžu to „dosadit“ do Pavlova výčtu: ani "
     "tohle mě neodloučí od Boží lásky.")
note("Ř 12,1-2", "Živá oběť",
     "Na základě Božího milosrdenství máme vydat svá těla jako živou "
     "oběť – to je naše pravá bohoslužba. Nepřizpůsobovat se tomuto "
     "věku, ale proměňovat se obnovou mysli.",
     "Bohoslužba není jen neděle; je to celý život dávaný Bohu.",
     "Co formuje moje myšlení nejvíc – zprávy, sociální sítě, nebo Boží "
     "slovo? Jaký jeden zvyk by pomohl „obnově mysli“?")
note("Ř 12,9-21", "Láska bez přetvářky",
     "Pavel dává praktický portrét lásky: bratrská náklonnost, "
     "pohostinnost, radost s radujícími a pláč s plačícími, žít v pokoji "
     "se všemi. Nesplácet zlo zlem, ale přemáhat zlo dobrem.",
     "Láska je konkrétní jednání, i vůči nepřátelům.",
     "Komu můžu dnes udělat dobro, i když si ho „nezaslouží“? Kdo "
     "potřebuje, abych se s ním radoval, nebo s ním plakal?")
note("Ř 14,1-13", "Nesuďte se navzájem",
     "V římském sboru se lidé přeli o jídlo a sváteční dny. Pavel říká: "
     "kdo jí, ať nepohrdá tím, kdo nejí, a kdo nejí, ať nesoudí toho, kdo "
     "jí. Každý bude skládat účet Bohu.",
     "V otázkách, které nejsou jádrem víry, platí svoboda svědomí a "
     "ohleduplnost.",
     "O jakých „vedlejších“ věcech se s druhými křesťany přu? Můžu svůj "
     "názor podržet a přitom druhého přijmout jako bratra či sestru.")

# --- List Galatským -------------------------------------------------------------
note("Ga 5,16-26", "Ovoce Ducha",
     "Pavel staví proti sobě „skutky těla“ (nemravnost, nepřátelství, "
     "svárlivost, závist…) a „ovoce Ducha“: lásku, radost, pokoj, "
     "trpělivost, laskavost, dobrotu, věrnost, tichost a sebeovládání.",
     "Křesťanský charakter roste jako ovoce – postupně, z života v Duchu, "
     "ne jen snahou o pravidla.",
     "Která část ovoce Ducha mi dnes chybí nejvíc? Můžu za ni prosit a "
     "hledat, kde ji dnes mohu konkrétně projevit.")
note("Ga 6,1-10", "Neste břemena jedni druhých",
     "Když někdo upadne, mají ho ti duchovní napravovat v duchu tichosti. "
     "„Neste břemena jedni druhých.“ Co člověk zaseje, to také sklidí; "
     "nepolevujme v konání dobra.",
     "Společenství víry je místo, kde si navzájem pomáháme nést těžkosti.",
     "Čí břemeno můžu tento týden pomoci nést? A komu dovolím, aby "
     "pomohl nést to moje?")

# --- List Efezským --------------------------------------------------------------
note("Ef 2,1-10", "Milostí jste spaseni",
     "Byli jsme „mrtví ve vinách“, ale Bůh bohatý v milosrdenství nás "
     "obživil s Kristem. Spasení je z milosti skrze víru, ne ze skutků. "
     "Jsme Boží dílo, stvořeni k dobrým skutkům, které Bůh připravil.",
     "Dobré skutky nejsou cenou za spasení, ale jeho ovocem.",
     "Jsem „Boží dílo“ (doslova umělecké dílo). Které dobré skutky mi "
     "Bůh dnes možná připravil do cesty?")
note("Ef 3,14-21", "Šíře a hloubka Kristovy lásky",
     "Pavel klečí a modlí se, aby věřící byli posíleni Duchem, Kristus "
     "přebýval v jejich srdcích a aby poznali šíři, délku, výšku i hloubku "
     "Kristovy lásky, která převyšuje poznání.",
     "Boží láska je větší, než dokážeme pochopit; poznáváme ji celý život.",
     "Můžu se touto modlitbou modlit za sebe i za konkrétní lidi – "
     "dosadit jejich jména.")
note("Ef 4,1-16", "Jedno tělo, mnoho darů",
     "Pavel vyzývá k pokoře, tichosti a trpělivosti, aby se zachovala "
     "jednota Ducha. Kristus dal církvi různé služebníky, aby vystrojili "
     "všechny k službě a tělo rostlo v lásce.",
     "Každý křesťan má dar a místo v Kristově těle; jednota není "
     "jednotvárnost.",
     "Jaký dar mi Bůh dal a jak ho používám pro druhé? Kde mohu svou "
     "trpělivostí chránit jednotu?")
note("Ef 4,25-32", "Nový člověk v praxi",
     "Odložte lež a mluvte pravdu. Hněvejte se, ale nehřešte – ať nad "
     "vaším hněvem nezapadá slunce. Kdo kradl, ať pracuje. Ať z úst "
     "nevychází špatné slovo, ale to, co buduje. Buďte k sobě laskaví a "
     "odpouštějte si.",
     "Víra se ukazuje ve slovech, v práci, v zacházení s hněvem a "
     "v odpouštění.",
     "Nezapadlo mi slunce nad nějakým hněvem? Které moje slovo dnes může "
     "druhého budovat?")
note("Ef 5,15-21", "Moudře využívat čas",
     "Pavel vybízí žít moudře, „vykupovat čas“, protože dny jsou zlé. "
     "Místo opojení vínem být naplněn Duchem – zpívat, děkovat Bohu za "
     "všechno a podřizovat se jedni druhým v úctě ke Kristu.",
     "Čas je dar, se kterým máme hospodařit; Duch svatý dává život "
     "plný vděčnosti.",
     "Kam mi utíká nejvíc času? Za co můžu dnes Bohu poděkovat – i za "
     "něco malého?")
note("Ef 6,10-18", "Boží výzbroj",
     "Pavel, sám ve vězení pod dozorem římského vojáka, popisuje duchovní "
     "výzbroj: opasek pravdy, pancíř spravedlnosti, obuv pohotovosti pro "
     "evangelium pokoje, štít víry, přilbu spasení a meč Ducha – Boží "
     "slovo. Vše provází modlitba.",
     "Křesťanský život je i duchovní zápas; Bůh nám dává vše, co "
     "potřebujeme, abychom obstáli.",
     "Která část výzbroje mi chybí? Můžu se ráno „obléct“ – projít si "
     "jednotlivé části v modlitbě.")
