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
