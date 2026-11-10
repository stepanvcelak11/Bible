"""Studijní kurzy (vlastní texty aplikace).

Kurz = několik lekcí. Lekce: výklad (odstavce), texty ke čtení
(odkaz v kanonickém číslování + popisek), zajímavosti, otázky
a jedna myšlenka „Pro život“.
"""

COURSES = []


def course(id, icon, color, title, subtitle, intro, lessons):
    COURSES.append(dict(id=id, icon=icon, color=color, title=title,
                        subtitle=subtitle, intro=intro, lessons=lessons))


def lesson(title, text, read, facts, questions, life):
    return dict(title=title, text=text, read=read, facts=facts,
                questions=questions, life=life)


# =============================================================================
course(
    "howto", "book", "B0813B", "Jak číst Bibli",
    "Šest kroků k tomu, aby Bible přestala být cizí knihou",
    "Bible je stará, rozsáhlá a místy těžká. Tento kurz nabízí jednoduché "
    "nástroje, jak se v ní vyznat: jak je uspořádaná, jak číst různé "
    "druhy textů, proč záleží na souvislostech a jak si z kapitoly "
    "odnést něco do života.",
    [
        lesson(
            "Knihovna, ne jedna kniha",
            ["Bible není jedna kniha, ale celá knihovna – 66 knih (v katolické "
             "a pravoslavné tradici i několik dalších), psaných zhruba 1500 "
             "let. Najdeme v ní příběhy, zákony, písně, přísloví, proroctví, "
             "životopisy Ježíše a dopisy.",
             "Starý zákon (39 knih) vznikal hlavně v hebrejštině a vypráví "
             "příběh Izraele od stvoření po návrat z vyhnanství. Židé ho dělí "
             "na Zákon (Tóru), Proroky a Spisy. Nový zákon (27 knih) je psán "
             "řecky: evangelia, Skutky, dopisy a Zjevení.",
             "Ježíš sám mluví o „Zákonu Mojžíšově, Prorocích a Žalmech“, "
             "které o něm svědčí. Přes všechnu rozmanitost vypráví Bible jeden "
             "velký příběh: stvoření – pád – vykoupení – nové stvoření."],
            [("L 24,44-45", "Zákon, Proroci a Žalmy"),
             ("2Tm 3,16-17", "Celé Písmo je vdechnuto Bohem"),
             ("J 20,31", "Proč bylo evangelium napsáno")],
            ["Slovo Bible pochází z řeckého ta biblia – „knížky“, množné "
             "číslo. Řecké byblos byl papyrus, pojmenovaný po fénickém "
             "přístavu Byblos, odkud se dovážel.",
             "Dělení na kapitoly zavedl na počátku 13. století Stephen "
             "Langton, pozdější arcibiskup v Canterbury. Verše v Novém zákoně očísloval "
             "tiskař Robert Estienne v roce 1551 – podle tradice prý během "
             "cesty na koni."],
            ["Kterou část Bible znám nejlépe a kterou skoro vůbec?",
             "Co by mi pomohlo vidět v Bibli jeden souvislý příběh?"],
            "Až budete příště číst kapitolu, zkuste si říct, do které části "
            "velkého příběhu patří."),
        lesson(
            "Různé druhy textů",
            ["Báseň se čte jinak než návod a dopis jinak než pohádka. Stejně "
             "tak Bible: žalm je modlitba a píseň, plná obrazů („Hospodin je "
             "má skála“) – nečteme ho jako geologický popis. Přísloví říkají, "
             "co obvykle platí, ne neporušitelný zákon.",
             "Vyprávění (Genesis, Samuelovy knihy, Skutky) často jen popisuje, "
             "co se stalo – ne všechno, co biblická postava udělá, je vzor. "
             "Proroci mluví ostrými obrazy do konkrétní doby. Dopisy "
             "odpovídají na skutečné problémy sborů.",
             "Zvláštním druhem je apokalyptika (Daniel, Zjevení): sny "
             "a vidění plné symbolů, čísel a zvířat. Nejsou to šifrované "
             "jízdní řády konce světa, ale obrazy, které utěšují "
             "pronásledované: Bůh má poslední slovo."],
            [("Ž 23,1-4", "Poezie – Hospodin jako pastýř"),
             ("Mk 4,33-34", "Ježíš mluvil v podobenstvích"),
             ("Zj 1,1-3", "Zjevení – kniha vidění")],
            ["Asi třetina Starého zákona je psána jako poezie. Hebrejská "
             "poezie se nerýmuje – staví vedle sebe myšlenky (tzv. "
             "paralelismus): „Nebesa vypravují o Boží slávě, obloha hlásá "
             "dílo jeho rukou.“",
             "Kniha Jób je z větší části poezie s krátkým prozaickým "
             "úvodem a závěrem – jako drama v rámečku."],
            ["Jaký druh textu čtu nejraději?",
             "Stalo se mi, že jsem nějaký text pochopil špatně, protože "
             "jsem ho četl jako jiný druh?"],
            "Než začnete číst, zeptejte se: je to příběh, píseň, dopis, "
            "nebo proroctví?"),
        lesson(
            "Souvislosti rozhodují",
            ["Verš vytržený z kontextu se dá použít skoro k čemukoli. Známé "
             "„já znám myšlenky, které o vás mám… myšlenky pokoje“ "
             "(Jr 29,11) bylo napsáno vyhnancům v Babyloně, kterým Jeremjáš "
             "zároveň řekl, že tam zůstanou sedmdesát let. Je to slib věrnosti "
             "v dlouhé zkoušce, ne záruka rychlého úspěchu.",
             "Podobně „všechno mohu v tom, který mi dává sílu“ (Fp 4,13) "
             "neznamená, že vyhraju každý zápas. Pavel tu mluví o tom, že se "
             "naučil být spokojený v hladu i v hojnosti.",
             "Proto se vyplatí ptát: Kdo to píše? Komu? V jaké situaci? Co "
             "je před a za tímto veršem? Teprve pak se ptáme: co to znamená "
             "pro mě?"],
            [("Jr 29,4-7", "Dopis vyhnancům"),
             ("Jr 29,10-11", "Po sedmdesáti letech"),
             ("Fp 4,11-13", "Naučil jsem se být spokojený")],
            ["Rabíni říkali: „Text bez kontextu je záminka.“ Podobné "
             "rčení znají kazatelé po celém světě.",
             "V hebrejských a řeckých rukopisech nebyly kapitoly, verše, "
             "a často ani mezery mezi slovy."],
            ["Který oblíbený verš bych si měl přečíst v celé kapitole?",
             "Jak se mění význam, když vím, komu byl text napsán?"],
            "Když vás osloví verš, přečtěte si vždy i celý odstavec kolem."),
        lesson(
            "Starý a Nový zákon spolu",
            ["Pro první křesťany byl „Písmem“ Starý zákon – Nový ještě "
             "neexistoval. Ježíš i apoštolové z něj neustále citují. Nový "
             "zákon obsahuje stovky citátů a narážek na Starý.",
             "Augustin to vyjádřil slavnou větou: „Nový zákon je ve Starém "
             "skryt, Starý zákon je v Novém odhalen.“ Beránek u Pesachu, "
             "had na tyči, Jonáš v rybě, trpící služebník – to vše křesťané "
             "čtou jako předobrazy Krista.",
             "Zároveň má Starý zákon vlastní hodnotu: učí o Bohu Stvořiteli, "
             "o spravedlnosti, o modlitbě v žalmech, o moudrosti pro všední "
             "den. Kdo čte jen Nový zákon, zná jen druhou polovinu příběhu."],
            [("L 24,27", "Od Mojžíše a všech proroků"),
             ("Mt 5,17", "Nepřišel jsem zrušit, ale naplnit"),
             ("Žd 1,1-2", "Bůh mluvil mnohokrát a mnoha způsoby")],
            ["Nejčastěji citovanou starozákonní knihou v Novém zákoně jsou "
             "Žalmy, hned po nich Izajáš.",
             "Žalm 110,1 („Řekl Hospodin mému Pánu: Seď po mé pravici“) "
             "patří k nejcitovanějším veršům Starého zákona v Novém zákoně."],
            ["Kterou starozákonní knihu bych chtěl lépe poznat?",
             "Kde jsem ve Starém zákoně zahlédl Krista?"],
            "Až budete číst Nový zákon, všímejte si citátů ze Starého – "
            "a zkuste si je dohledat."),
        lesson(
            "Překlady a původní jazyky",
            ["Každý překlad je kompromis. Některé překlady se drží co "
             "nejblíže původnímu slovosledu a slovům (tzv. formální, např. "
             "Kralická), jiné se snaží předat smysl srozumitelnou dnešní "
             "češtinou (tzv. dynamické). Oba přístupy mají svou hodnotu.",
             "Hebrejština má málo slov a mnoho obrazů; řečtina Nového "
             "zákona je obecná řeč (koiné), kterou se mluvilo na tržištích. "
             "Bůh tedy nemluvil vznešeným jazykem filozofů, ale jazykem "
             "obyčejných lidí.",
             "Při studiu se vyplatí porovnávat překlady. Když se dva "
             "překlady liší, často to ukazuje na místo, kde je originál "
             "bohatší, než dokáže vyjádřit jedno české slovo."],
            [("Neh 8,8", "Četli a vysvětlovali smysl"),
             ("Sk 2,6-8", "Každý slyšel svou řečí")],
            ["Septuaginta – řecký překlad Starého zákona – vznikla "
             "v Alexandrii ve 3.–2. století př. Kr. Podle legendy na ní "
             "pracovalo 72 překladatelů (odtud název „sedmdesát“).",
             "Jazyk Kralické bible se stal vzorem spisovné češtiny. "
             "Obrozenci jako Josef Dobrovský z něj vycházeli při obnově "
             "jazyka."],
            ["Který překlad mi mluví nejvíc k srdci a proč?",
             "Kdy mi pomohlo porovnat dva překlady?"],
            "Vyberte si jeden verš a přečtěte ho v aplikaci ve dvou "
            "překladech vedle sebe."),
        lesson(
            "Jak studovat kapitolu",
            ["Osvědčená metoda má tři kroky. Pozorování: co text říká? "
             "Kdo, co, kde, kdy? Která slova se opakují? Výklad: co to "
             "znamenalo pro první čtenáře? Proč je to tu napsáno?",
             "Použití: co to znamená pro mě? Je tu příkaz k poslechnutí, "
             "slib, kterému můžu věřit, příklad k následování nebo varování? "
             "Jakub varuje před čtením, které zůstane jen u poslechu – jako "
             "když se člověk podívá do zrcadla a hned zapomene, jak vypadá.",
             "Lidé v Beroji „denně zkoumali Písma“, aby si ověřili, co "
             "slyšeli. Pomáhá tužka, sešit a otázky. A modlitba na začátku: "
             "„Otevři mé oči, ať spatřím divy tvého zákona“ (Ž 119,18)."],
            [("Ž 119,18", "Otevři mé oči"),
             ("Sk 17,11", "Denně zkoumali Písma"),
             ("Jk 1,22-25", "Čtenář jako člověk před zrcadlem")],
            ["Tato metoda (pozorování – výklad – použití) se v různých "
             "obměnách používá ve skupinkách po celém světě. Varianta "
             "SOAP znamená Scripture, Observation, Application, Prayer.",
             "Ž 1 popisuje člověka, který o Božím zákoně „přemýšlí dnem "
             "i nocí“. Hebrejské hagah znamená i „mumlat, polohlasně si "
             "opakovat“ – starověcí čtenáři četli nahlas."],
            ["Kterou ze tří otázek obvykle přeskakuji?",
             "Co mi pomůže, abych z přečteného něco opravdu udělal?"],
            "U dnešní kapitoly si zapište jedno pozorování, jeden "
            "výklad a jedno použití."),
    ])

# =============================================================================
course(
    "origin", "history", "8C6BA8", "Jak Bible vznikla",
    "Od vyprávění u ohně po knihu v mobilu",
    "Jak se z příběhů vyprávěných po generace staly svitky, jak se "
    "opisovaly, proč jsou v Bibli právě tyto knihy a jak se dostala "
    "do češtiny. Kurz o dobrodružné cestě textu, který čteme.",
    [
        lesson(
            "Od vyprávění k písmu",
            ["Mnoho biblických příběhů se nejprve vyprávělo – v rodinách, "
             "při svátcích, u ohně. Ve starověku měla ústní tradice velkou "
             "váhu; lidé se učili dlouhé texty nazpaměť. Bible ale také "
             "popisuje zapisování: Mojžíš „zapsal všechna Hospodinova slova“.",
             "Prorok Jeremjáš diktoval svá proroctví písaři Báruchovi. Když "
             "král svitek spálil, Jeremjáš nadiktoval nový – ještě rozšířený. "
             "Mnoho knih tak prošlo několika vrstvami sběru a úprav.",
             "Lukáš na začátku evangelia popisuje svou práci téměř jako "
             "historik: „pečlivě jsem prošel všechno od začátku“, opíral se "
             "o očité svědky a chtěl, aby čtenář poznal spolehlivost toho, "
             "čemu byl vyučen."],
            [("Ex 24,4", "Mojžíš zapsal Hospodinova slova"),
             ("Jr 36,4", "Báruch píše podle Jeremjášova diktátu"),
             ("L 1,1-4", "Lukáš pečlivě prozkoumal vše od začátku")],
            ["Nejstarší známý mimobiblický nápis se jménem „dům Davidův“ je "
             "stéla z Tel Danu (9. stol. př. Kr.), objevená v letech "
             "1993–1994.",
             "Pavel své dopisy obvykle diktoval písaři. Na konci někdy "
             "připsal pozdrav vlastní rukou (2Te 3,17) – a jeden písař, "
             "Tercius, se v dopise Římanům dokonce sám pozdravil (Ř 16,22)."],
            ["Jak se v mé rodině předávaly příběhy víry?",
             "Co mi říká, že Bůh použil k sepsání Bible lidi s jejich "
             "stylem a omezeními?"],
            "Vyprávějte někomu blízkému jeden příběh, ve kterém jste "
            "zažili Boží pomoc."),
        lesson(
            "Svitky, papyrus a kodex",
            ["Starověké knihy se psaly na svitky z papyru (z rostliny "
             "rostoucí u Nilu) nebo z pergamenu (upravené zvířecí kůže). "
             "Svitek Izajáše měřil přes sedm metrů. Hledat v něm konkrétní "
             "místo nebylo snadné.",
             "Křesťané velmi brzy přešli na kodex – sešité listy, předchůdce "
             "dnešní knihy. Kodex byl praktičtější, levnější a vešlo se do "
             "něj více textů. Možná proto se v něm dobře šířila evangelia "
             "a Pavlovy dopisy pohromadě.",
             "Pavel z vězení žádá Timoteje, aby mu přinesl „knihy, hlavně "
             "pergameny“. I apoštol na konci života toužil číst."],
            [("Jr 36,23", "Král pálí svitek"),
             ("2Tm 4,13", "Přines knihy, hlavně pergameny"),
             ("Zj 5,1", "Svitek popsaný zevnitř i zvenčí")],
            ["Slovo pergamen pochází od města Pergamon v Malé Asii, které "
             "proslulo výrobou psací kůže. Pergamon je jedním ze sedmi měst "
             "ve Zjevení.",
             "Nejstarší známý zlomek Nového zákona, papyrus P52 s několika "
             "verši z Janova evangelia (J 18), se datuje do 2. století – "
             "jen několik desetiletí po sepsání evangelia."],
            ["Jak by se změnilo moje čtení, kdybych Bibli měl jen jako "
             "svitek, který nemůžu mít doma?",
             "Proč podle mě první křesťané tolik stáli o to, aby texty "
             "měli po ruce?"],
            "Buďte vděční za Bibli, kterou můžete otevřít kdykoli – "
            "a otevřete ji dnes."),
        lesson(
            "Opisovači a jejich péče",
            ["Než vznikl knihtisk, každá Bible se opisovala ručně. "
             "Židovští písaři (soferim) měli přísná pravidla: počítali "
             "písmena, slova i verše, aby poznali chybu. Poškozený svitek "
             "se nevyhazoval, ale ukládal do zvláštní místnosti (geniza).",
             "Kolem 7.–10. století doplnili masoreti (od slova masora – "
             "„tradice“) do hebrejského textu samohlásky a přízvuky. "
             "Hebrejština se totiž psala jen souhláskami. Masoretský text je "
             "základem většiny dnešních překladů Starého zákona.",
             "U Nového zákona máme přes 5800 řeckých rukopisů a jejich "
             "zlomků – víc než u kteréhokoli jiného antického spisu. Opisy "
             "se drobně liší, ale porovnáním lze původní znění ve velké "
             "většině míst spolehlivě určit."],
            [("Ezd 7,6", "Ezdráš – zběhlý znalec zákona"),
             ("Mt 5,18", "Ani jediné písmenko nepomine")],
            ["Káhirská geniza, objevená koncem 19. století, obsahovala "
             "zhruba 300 000 listů starých textů – včetně biblických "
             "rukopisů.",
             "„Jota“ a „čárka“ z Mt 5,18 jsou nejmenší písmeno hebrejské "
             "abecedy (jod) a drobný ozdobný tah písmene."],
            ["Co mě oslovuje na péči, s jakou byla Bible opisována?",
             "Jak zacházím já s Božím slovem?"],
            "Opište si dnes jeden verš ručně – pomalu, jako starověký "
            "písař."),
        lesson(
            "Kumránské svitky",
            ["V roce 1947 hledal beduínský pastevec ztracenou kozu v "
             "jeskyních u Mrtvého moře. Hodil kámen do jeskyně, uslyšel "
             "rozbití hliněné nádoby – a objevil svitky, které se staly "
             "jedním z největších archeologických objevů 20. století.",
             "V jedenácti jeskyních u Kumránu se našly zbytky asi 900 "
             "svitků. Zhruba čtvrtina z nich jsou biblické texty – ze "
             "všech knih Starého zákona kromě Ester. Nejslavnější je "
             "téměř kompletní svitek Izajáše.",
             "Svitky jsou o tisíc let starší než dosud nejstarší úplné "
             "hebrejské rukopisy. Porovnání ukázalo, že text Izajáše se "
             "za tu dobu změnil jen velmi málo – většinou v pravopisu."],
            [("Iz 40,6-8", "Slovo našeho Boha zůstává navěky"),
             ("Iz 53,4-6", "Trpící služebník – ve svitku z Kumránu")],
            ["Velký svitek Izajáše je dnes vystaven v jeruzalémské Svatyni "
             "knihy, budově se střechou ve tvaru víka nádoby, ve které "
             "byly svitky ukryty.",
             "Svitky pravděpodobně patřily židovskému společenství, které "
             "žilo u Mrtvého moře a schovalo knihovnu před Římany kolem "
             "roku 68."],
            ["Co pro mě znamená, že Boží slovo „zůstává navěky“?",
             "Proč je pro víru důležité, že máme spolehlivý text?"],
            "Přečtěte si dnes Iz 40 – kapitolu, kterou četli i obyvatelé "
            "Kumránu."),
        lesson(
            "Proč právě tyto knihy",
            ["Seznam knih, které patří do Bible, se nazývá kánon – "
             "z řeckého slova pro „měřítko, pravítko“. Kánon nevznikl "
             "rozhodnutím jedné porady, ale postupně: církev rozpoznávala "
             "knihy, které se již v bohoslužbách četly a měly autoritu.",
             "U Nového zákona se zvažovalo: pochází kniha od apoštolů nebo "
             "jejich blízkých? Souhlasí s vírou církve? Čte se ve většině "
             "sborů? Biskup Athanasius v roce 367 uvedl seznam přesně 27 "
             "knih, které dnes máme.",
             "Katolická a pravoslavné církve navíc přijímají několik "
             "knih z řeckého Starého zákona (např. Tóbijáš, Moudrost, "
             "Makabejské). Protestanté je nazývají apokryfy nebo "
             "deuterokanonické knihy a čtou je spíše jako užitečnou "
             "literaturu."],
            [("Ko 4,16", "Ať se dopis čte i v Laodikeji"),
             ("2Pt 3,15-16", "Petr o Pavlových dopisech"),
             ("1Te 5,27", "Ať se tento dopis přečte všem")],
            ["Kralická bible ve svém prvním vydání obsahovala i apokryfy – "
             "s poznámkou, že nemají stejnou váhu jako ostatní knihy.",
             "Židovská Bible (Tanach) má 24 knih – obsahově stejných jako "
             "39 knih protestantského Starého zákona, jen jinak rozdělených "
             "(např. 12 malých proroků tvoří jednu knihu)."],
            ["Co mi říká, že dopisy se v prvních sborech předčítaly "
             "nahlas všem?",
             "Které knihy Bible jsem ještě nikdy nečetl?"],
            "Vyberte si knihu, kterou jste nikdy nečetli, a přečtěte si "
            "aspoň její úvod v aplikaci."),
        lesson(
            "Bible v češtině",
            ["Čeština patří mezi první jazyky, do kterých byla přeložena "
             "celá Bible. První úplný český překlad vznikl ve 14. století. "
             "Roku 1488 vyšla v Praze tištěná Bible – jedna z prvních "
             "tištěných Biblí v národním jazyce v Evropě.",
             "Jednota bratrská vydala v letech 1579–1594 šestidílnou "
             "Kralickou bibli, přeloženou z hebrejštiny a řečtiny, "
             "s podrobnými poznámkami. Její jazyk ovlivnil češtinu na "
             "staletí. Mnoho rčení – „znamení časů“, „nést svůj kříž“, "
             "„spadly mu šupiny z očí“ – pochází z Bible a Kralická "
             "upevnila jejich podobu.",
             "Ve 20. století vznikl ekumenický překlad (ČEP, 1979), na "
             "kterém spolupracovali katolíci i evangelíci. Dnes existuje "
             "několik moderních překladů – každý s jiným důrazem."],
            [("Ž 119,130", "Výklad tvých slov dává světlo"),
             ("Sk 2,11", "Slyšíme je mluvit našimi jazyky"),
             ("Zj 7,9", "Ze všech národů a jazyků")],
            ["Jan Hus se podle tradice podílel na úpravě staršího "
             "českého překladu a jako kazatel kladl "
             "důraz na to, aby lidé slyšeli Boží slovo v češtině.",
             "Kralická bible se tiskla v tajné tiskárně na tvrzi v Kralicích "
             "nad Oslavou; dnes je tam Památník Bible kralické."],
            ["Který český překlad mi je nejbližší?",
             "Za co jsem vděčný lidem, kteří Bibli překládali?"],
            "Přečtěte si oblíbený žalm v Kralické a pak v moderním "
            "překladu – a všimněte si krásy obou."),
    ])

# =============================================================================
course(
    "world", "explore", "3F7CAC", "Svět Bible",
    "Krajina, domy, jídlo a lidé biblické doby",
    "Bible vznikla ve světě bez elektřiny, aut a supermarketů. Když si "
    "představíme krajinu, domy, stůl a každodenní práci biblických lidí, "
    "mnoho textů najednou ožije – a dostane nový význam.",
    [
        lesson(
            "Země mezi pouští a mořem",
            ["Zaslíbená země je malá: od Danu na severu po Beer-šebu na "
             "jihu měří asi 240 kilometrů. Leží na úzkém pruhu mezi "
             "Středozemním mořem a pouští – na křižovatce cest mezi Egyptem "
             "a Mezopotámií. Proto tudy procházela vojska i obchodníci.",
             "Krajina je velmi rozmanitá: úrodné pobřeží, pohoří uprostřed "
             "(kde ležel Jeruzalém), hluboké údolí Jordánu a Mrtvé moře – "
             "nejnižší místo na souši, víc než 400 metrů pod hladinou moře.",
             "Na rozdíl od Egypta, který zavlažoval Nil, závisel Izrael na "
             "dešti. Deuteronomium to vidí jako duchovní lekci: země „pije "
             "vodu z nebeského deště“ a lid se musí spoléhat na Boha."],
            [("Dt 8,7-9", "Dobrá země potoků a pramenů"),
             ("Dt 11,10-12", "Země, která pije déšť z nebe"),
             ("Ž 125,2", "Jako hory obklopují Jeruzalém")],
            ["Galilejské jezero leží asi 200 metrů pod hladinou moře "
             "a měří zhruba 21 × 13 km. Bouře na něm vznikají náhle, když "
             "studený vzduch padá z okolních hor.",
             "Zaslíbená země je zhruba velká jako Morava se Slezskem – "
             "většina biblických událostí se tedy odehrála na prostoru, "
             "který lze přejet autem za pár hodin."],
            ["Jak mi znalost krajiny pomáhá rozumět biblickým příběhům?",
             "V čem se mám jako Izrael naučit „pít déšť z nebe“ – "
             "spoléhat na Boha?"],
            "Otevřete v aplikaci mapy a najděte Dan, Jeruzalém "
            "a Beer-šebu."),
        lesson(
            "Dům, lampa a střecha",
            ["Typický izraelský dům měl kamenné zdi, hliněnou podlahu "
             "a rovnou střechu z trámů, větví a udusané hlíny. V přízemí "
             "byl často i dobytek, rodina spala o patro výš. Na střeše se "
             "sušilo prádlo i obilí, spalo se tam v létě a modlilo.",
             "Proto mohli přátelé ochrnutého „prokopat“ střechu a spustit ho "
             "k Ježíši. Proto Petr šel v poledne na střechu modlit se "
             "a Rachab na ní ukryla zvědy pod lněné stonky.",
             "Dům osvětlovala malá hliněná olejová lampa. Postavit ji pod "
             "nádobu znamenalo ji zhasnout. Ježíšův obraz „vy jste světlo "
             "světa“ vyrůstá z takového jednoduchého domu s jedinou "
             "místností, kde jedna lampa svítí všem."],
            [("Mk 2,3-4", "Odkryli střechu"),
             ("Sk 10,9", "Petr se modlí na střeše"),
             ("Mt 5,14-16", "Lampa na podstavci")],
            ["Zákon přikazoval udělat na střeše zábradlí, aby nikdo "
             "nespadl (Dt 22,8) – starověký předpis bezpečnosti práce.",
             "Hliněných olejových lampiček z biblické doby našli archeologové "
             "tolik, že se dodnes prodávají turistům jako suvenýry."],
            ["Co znamená, že moje „lampa“ svítí všem v domě?",
             "Kdo je pro mě přítelem, který by kvůli mně „rozebral "
             "střechu“?"],
            "Udělejte dnes něco malého, co bude „svítit“ lidem ve vašem "
            "domově."),
        lesson(
            "Chléb, olivy a víno",
            ["Základem stravy byl chléb – tak samozřejmý, že „jíst chléb“ "
             "znamenalo prostě „jíst“. K tomu olivy a olivový olej, víno, "
             "fíky, datle, luštěniny, mléčné výrobky. Maso se jedlo hlavně "
             "o svátcích.",
             "Ke slavnostní hostině se neseděla na židlích, ale lehávalo se "
             "na lehátkách kolem nízkého stolu, opřeni o levý loket a nohama "
             "od stolu. Proto mohla žena v domě farizea přistoupit "
             "k Ježíšovým nohám zezadu – a proto mohl učedník „spočívat "
             "na Ježíšově hrudi“.",
             "Společné jídlo znamenalo přijetí a spojenectví. Když Ježíš "
             "jedl s celníky a hříšníky, nebyla to jen zdvořilost – "
             "veřejně ukazoval, že je přijímá. Proto to tolik pohoršovalo."],
            [("Dt 8,8", "Země pšenice, vína, fíků a oliv"),
             ("L 7,36-38", "Žena u Ježíšových nohou"),
             ("L 15,1-2", "Jí s hříšníky")],
            ["Olivovník může žít stovky let. Některé olivovníky v Getsemane "
             "patří k nejstarším na světě – podle výzkumů je jim přes 900 "
             "let.",
             "Getsemane znamená aramejsky „lis na olej“."],
            ["S kým jím a s kým bych mohl jíst, abych mu ukázal přijetí?",
             "Co pro mě znamená Ježíšova prosba o „chléb vezdejší“?"],
            "Pozvěte tento týden někoho na jídlo – a modlete se za něj "
            "u stolu."),
        lesson(
            "Pastýři a rolníci",
            ["Většina lidí v biblické době žila z půdy a stád. Pastýř vedl "
             "ovce za dne na pastvu a v noci je zavíral do ohrady z kamenů. "
             "Sám pak někdy ležel ve vchodu jako „dveře“. Ovce znaly hlas "
             "svého pastýře – pastýři se ovcí neženou, ale vedou je.",
             "Rolnický rok měl pevný rytmus: podzimní deště a setí, zimní "
             "růst, jarní žeň ječmene a pšenice, letní sklizeň ovoce, "
             "podzimní vinobraní. Svátky Izraele se řídily tímto "
             "zemědělským kalendářem.",
             "Na mlatě se obilí mlátilo a pak se vyhazovalo do větru: "
             "těžké zrno spadlo zpět, lehké plevy vítr odnesl. Jan Křtitel "
             "tento obraz použil pro Boží soud."],
            [("Ž 23,1-4", "Hospodin je můj pastýř"),
             ("J 10,3-4", "Ovce znají jeho hlas"),
             ("Mt 3,12", "Lopata v ruce a mlat")],
            ["Pastýři byli v Ježíšově době spíš na okraji společnosti – "
             "a přece jim jako prvním anděl ohlásil narození Spasitele.",
             "David byl pastýř, stejně jako Mojžíš, Abraham a Jákob. "
             "„Pastýř“ byl ve starověku běžný titul pro krále."],
            ["Poznávám hlas Dobrého pastýře mezi ostatními hlasy?",
             "Jaké období „rolnického roku“ teď prožívám – setí, čekání, "
             "nebo žeň?"],
            "Přečtěte si pomalu Žalm 23 a u každého verše si představte "
            "skutečného pastýře."),
        lesson(
            "Peníze, míry a čas",
            ["Biblické peníze se měnily podle doby. Ve Starém zákoně se "
             "platilo vážením stříbra (šekel = asi 11 g). V Ježíšově době "
             "kolovaly římské, řecké a místní mince. Denár byl denní mzda "
             "dělníka; talent byl obrovská částka – asi 6000 denárů, mzda "
             "za víc než 15 let práce.",
             "Délky se měřily lidským tělem: loket (asi 45 cm, od lokte po "
             "konec prstů), píď, dlaň. Cesta, kterou bylo dovoleno ujít "
             "v sobotu, měřila zhruba kilometr.",
             "Den se počítal od východu slunce: „třetí hodina“ je asi "
             "9 hodin ráno, „šestá“ poledne, „devátá“ 15 hodin. Noc se "
             "dělila na hlídky. Ježíš přišel po moři „ke čtvrté hlídce“ – "
             "mezi třetí hodinou ranní a svítáním."],
            [("Mt 20,1-2", "Denár za den práce"),
             ("Mk 12,41-44", "Dvě drobné mince vdovy"),
             ("J 11,9", "Což nemá den dvanáct hodin?")],
            ["Třicet stříbrných, za které Jidáš zradil Ježíše, byla podle "
             "Zákona cena otroka (Ex 21,32).",
             "Noemova archa měřila 300 × 50 × 30 loket – asi 135 × 22 × 13 "
             "metrů, poměry podobné moderním lodím."],
            ["Jak by vypadal můj život, kdybych počítal čas „hlídkami“ "
             "a ne minutami?",
             "Co mi říká Ježíšova pochvala vdovy, která dala nejméně?"],
            "Až budete číst o penězích nebo délkách, zkuste si je přepočítat "
            "na dnešní poměry."),
        lesson(
            "Pod vládou Říma",
            ["Ježíš se narodil v době císaře Augusta. Judsko bylo součástí "
             "římské říše; vládli tam místní králové jako Herodes Veliký "
             "a později římští místodržitelé jako Pontius Pilát. Římané "
             "vybírali daně přes nájemce – celníky, které lidé pohrdali "
             "jako kolaboranty.",
             "Židovská společnost byla rozdělená: farizeové kladli důraz "
             "na zákon v každodenním životě, saduceové byli kněžská "
             "aristokracie kolem chrámu, zéloti chtěli vyhnat Římany "
             "zbraní a esejci se stahovali do ústraní. Ježíš měl mezi "
             "učedníky celníka Matouše i zélótu Šimona.",
             "Římský mír (pax Romana), silnice a společná řečtina "
             "paradoxně pomohly šíření evangelia. Pavel mohl cestovat "
             "po celém Středomoří a jako římský občan se odvolat "
             "k císaři."],
            [("L 2,1-5", "Augustův soupis lidu"),
             ("L 3,1-2", "Patnáctý rok Tiberia"),
             ("Mt 22,17-21", "Dejte císaři, co je císařovo")],
            ["V roce 1961 byl v Caesareji nalezen kámen s nápisem jména "
             "Pontius Pilatus – první archeologický doklad o jeho existenci "
             "mimo písemné prameny.",
             "Římské silnice byly tak dobré, že se po některých jezdí "
             "dodnes. Celkem měřila síť přes 80 000 km."],
            ["Co mi říká, že Ježíš spojil celníka i zélótu v jednom "
             "společenství?",
             "Jak Bůh může použít i nespravedlivé politické poměry?"],
            "Modlete se dnes za lidi, kteří mají politickou moc – i za ty, "
            "se kterými nesouhlasíte."),
    ])

# =============================================================================
course(
    "feasts", "calendar", "B0603A", "Svátky Izraele",
    "Kalendář, který vypráví příběh spásy",
    "Izraelský rok byl prošitý svátky. Každý připomínal Boží jednání "
    "v dějinách a zároveň ukazoval dopředu. Ježíš je slavil – a mnohé "
    "z nich naplnil. Kurz vás provede svátky od sabatu po Chanuku.",
    [
        lesson(
            "Sabat – svátek každý týden",
            ["Sabat (šabat – „ustání, odpočinek“) začíná v pátek při západu "
             "slunce a končí v sobotu večer. Bůh sám „odpočinul“ sedmý den "
             "a přikázal odpočinek všem: dětem, otrokům, cizincům i zvířatům.",
             "Deuteronomium dává k sabatu důvod: „Pamatuj, že jsi byl "
             "otrokem v Egyptě.“ Otroci nemají volno. Sabat je tedy týdenní "
             "oslava svobody a připomínka, že hodnota člověka není v jeho "
             "výkonu.",
             "Ježíš se s farizeji přel o to, co se v sabat smí. Uzdravoval "
             "a prohlásil: „Sabat byl učiněn pro člověka, ne člověk pro "
             "sabat.“ Křesťané slaví neděli jako den vzkříšení, ale myšlenka "
             "pravidelného odpočinku s Bohem zůstává."],
            [("Gn 2,2-3", "Bůh odpočinul a požehnal sedmý den"),
             ("Dt 5,12-15", "Pamatuj, že jsi byl otrokem"),
             ("Mk 2,27-28", "Sabat je pro člověka")],
            ["Židovské rodiny začínají sabat zapálením dvou svíček "
             "a požehnáním chleba (chaly) a vína.",
             "Židovský myslitel Achad ha-Am napsal: „Víc než Izrael "
             "zachovával sabat, sabat zachoval Izrael.“"],
            ["Mám v týdnu den, kdy opravdu odpočívám?",
             "Co by se změnilo, kdybych odpočinek bral jako dar, ne jako "
             "ztrátu času?"],
            "Naplánujte si tento týden několik hodin skutečného odpočinku "
            "s Bohem a blízkými."),
        lesson(
            "Pesach – noc vysvobození",
            ["Pesach (Velikonoce) připomíná noc, kdy Bůh vyvedl Izrael "
             "z Egypta. Krev beránka na veřejích chránila domy a anděl "
             "smrti je „přešel“ (pasach – „přejít, ušetřit“). Lid jedl "
             "nekvašené chleby, protože neměl čas nechat těsto vykynout.",
             "Při svátečním jídle (sederu) se dodnes vypráví příběh exodu. "
             "Nejmladší dítě se ptá: „Čím se tato noc liší od všech ostatních "
             "nocí?“ Hořké byliny připomínají hořkost otroctví, slaná voda "
             "slzy.",
             "Ježíš zemřel o Pesachu. Při poslední večeři vzal chléb "
             "a kalich a dal jim nový význam. Pavel píše: „Kristus, náš "
             "velikonoční beránek, byl obětován.“ Proto Velikonoce slaví "
             "Židé i křesťané – každý s jiným důrazem."],
            [("Ex 12,13-14", "Krev bude znamením"),
             ("L 22,14-20", "Toužil jsem jíst s vámi tohoto beránka"),
             ("1K 5,7-8", "Kristus, náš velikonoční beránek")],
            ["Před Pesachem se z domu odstraňuje všechen kvas – dodnes "
             "se dělá velký úklid. Pavel to použil jako obraz: „Vyčistěte "
             "starý kvas.“",
             "České slovo Velikonoce znamená „velké noci“."],
            ["Z čeho mě Bůh „vyvedl“ – a jak si to připomínám?",
             "Co mi říká, že Ježíš zemřel právě o Pesachu?"],
            "O příštích Velikonocích si přečtěte Ex 12 a L 22 vedle sebe."),
        lesson(
            "Letnice – sklizeň a Duch",
            ["Padesát dní po Pesachu slavil Izrael Šavuot – svátek týdnů. "
             "Byl to svátek žní, kdy se do chrámu přinášely první chleby "
             "z nové pšenice. Později se s ním spojila i připomínka "
             "darování Zákona na Sinaji.",
             "Právě o tomto svátku, kdy byl Jeruzalém plný poutníků "
             "z mnoha zemí, sestoupil na učedníky Duch svatý. Petr kázal "
             "a uvěřilo asi tři tisíce lidí – první „žeň“ církve.",
             "Řecký název Pentékosté znamená „padesátý“. Česky říkáme "
             "Letnice, protože připadají na začátek léta."],
            [("Lv 23,15-17", "Sedm týdnů a nová obětní dávka"),
             ("Sk 2,1-4", "Seslání Ducha svatého"),
             ("Sk 2,41", "Přidalo se asi tři tisíce lidí")],
            ["O svátku Šavuot se v synagogách čte kniha Rút – její příběh "
             "se odehrává při žních.",
             "Na Sinaji podle Ex 32,28 zahynulo asi tři tisíce lidí; "
             "o Letnicích bylo asi tři tisíce zachráněno. Mnozí vykladači "
             "v tom vidí záměrný kontrast."],
            ["Kde v mém životě potřebuji „vanutí“ Ducha?",
             "Jakou „první úrodu“ mohu dnes nabídnout Bohu?"],
            "Modlete se dnes jednoduše: „Přijď, Duchu svatý.“"),
        lesson(
            "Den smíření",
            ["Jom kipur je nejsvatější den židovského roku – den půstu, "
             "pokání a odpuštění. Jen v tento den vstupoval velekněz do "
             "velesvatyně za oponu a kropil krví slitovnici na truhle "
             "smlouvy.",
             "Dva kozli vyjadřovali dvě stránky odpuštění: jeden byl "
             "obětován (cena hříchu), druhý vyhnán do pouště s hříchy lidu "
             "(hřích je odnesen „daleko“). Žalm říká: „Jak daleko je východ "
             "od západu, tak daleko od nás odstranil naše nevěrnosti.“",
             "List Židům vykládá, že Kristus jako velekněz vešel „jednou "
             "provždy“ do nebeské svatyně s vlastní krví. Den smíření "
             "ukazuje dopředu na kříž."],
            [("Lv 16,29-30", "Budete očištěni od všech hříchů"),
             ("Ž 103,12", "Jak daleko je východ od západu"),
             ("Žd 9,11-12", "Kristus vešel jednou provždy")],
            ["Na Jom kipur se v synagogách čte kniha Jonáš – příběh "
             "o Božím milosrdenství i vůči nepřátelům.",
             "Micheáš slibuje, že Bůh „uvrhne do hlubin moře všechny naše "
             "hříchy“ (Mi 7,19). Z tohoto verše vznikl zvyk tašlich – "
             "o novém roce (Roš ha-šana) se vyhazují drobky do tekoucí "
             "vody."],
            ["Věřím, že moje hříchy jsou opravdu „daleko“?",
             "Je něco, z čeho potřebuji vyznat a přijmout odpuštění?"],
            "Napište si na papír, co vás tíží, vyznejte to Bohu a papír "
            "roztrhejte."),
        lesson(
            "Stánky – Bůh s námi na cestě",
            ["Na podzim, po sklizni, bydlel Izrael týden ve stáncích z větví. "
             "Připomínal si tak čtyřicet let na poušti, kdy neměl domy, "
             "ale Bůh se o něj staral. Byl to nejradostnější svátek roku.",
             "Při slavnosti se v chrámu každý den lila voda z rybníka Siloe "
             "na oltář a modlilo se za déšť. Právě „posledního, velikého dne "
             "svátku“ Ježíš zvolal: „Žízní-li kdo, ať přijde ke mně a pije.“",
             "Jan píše, že Slovo „stanulo“ mezi námi – doslova „postavilo "
             "stan“. A Zjevení končí vizí: „Hle, stan Boží s lidmi.“ Svátek "
             "stánků je předzvěstí Boha, který bydlí se svým lidem."],
            [("Lv 23,42-43", "Budete bydlet ve stáncích"),
             ("J 7,37-38", "Žízní-li kdo, ať přijde ke mně"),
             ("Zj 21,3", "Stan Boží s lidmi")],
            ["Střechou stánku (suka) musí být vidět hvězdy – připomínka, "
             "že bezpečí nedává střecha, ale Bůh.",
             "Zachariáš předpovídá, že jednou budou svátek stánků slavit "
             "všechny národy (Za 14,16)."],
            ["Kde v životě mám „dočasné bydlení“ a potřebuji důvěřovat?",
             "Po čem žízním a co mi nabízí Ježíš?"],
            "Večer se podívejte na hvězdy a poděkujte za Boží péči na "
            "vaší cestě."),
        lesson(
            "Purim a Chanuka",
            ["Purim slaví záchranu Židů v Perské říši, jak ji popisuje kniha "
             "Ester. Je to veselý svátek: čte se kniha Ester a při každém "
             "vyslovení jména zlého Hamana se dělá hluk. Lidé si posílají "
             "dárky a dávají almužny chudým.",
             "Chanuka (posvěcení) připomíná znovuzasvěcení chrámu v roce "
             "164 př. Kr. po vítězství Makabejských nad syrským králem, "
             "který chrám znesvětil. Podle tradice malé množství oleje "
             "vydrželo hořet osm dní – proto se zapaluje osmiramenný "
             "svícen.",
             "Ježíš byl v chrámu o svátku posvěcení (J 10,22) – je to "
             "jediná zmínka o Chanuce v Bibli. Právě tehdy řekl: „Já "
             "a Otec jsme jedno.“"],
            [("Est 9,20-22", "Dny hodování a radosti"),
             ("Est 4,14", "Pro tuto chvíli"),
             ("J 10,22-23", "Svátek posvěcení v zimě")],
            ["Slovo purim znamená „losy“ – Haman losem určil den, kdy měli "
             "být Židé vyhubeni (Est 3,7).",
             "Chanukový svícen (chanukija) má devět ramen: osm pro dny "
             "svátku a jedno, „služebník“, od kterého se ostatní zapalují."],
            ["Kdy jsem zažil záchranu „na poslední chvíli“?",
             "Kde jsem já postaven „pro tuto chvíli“?"],
            "Udělejte dnes radost někomu, kdo to potřebuje – jako "
            "o Purimu."),
    ])

# =============================================================================
course(
    "parables", "lamp", "2E8B57", "Ježíšova podobenství",
    "Krátké příběhy s dlouhým dosahem",
    "Podobenství jsou nejznámější Ježíšovy příběhy. Vypadají jednoduše, "
    "ale skrývají překvapení, která tehdejší posluchače šokovala. Kurz "
    "provede šesti nejslavnějšími – s ohledem na to, jak zněla v Ježíšově "
    "době.",
    [
        lesson(
            "Proč Ježíš mluvil v příbězích",
            ["Ježíš mohl učit poučkami, ale vyprávěl o semenech, ovcích, "
             "penězích a hostinách. Příběh se snáz zapamatuje, vtáhne "
             "posluchače dovnitř a nutí ho přemýšlet: kde jsem v tom já?",
             "Podobenství zároveň dělí posluchače. Kdo chce rozumět, "
             "ptá se dál – jako učedníci, kteří přišli za Ježíšem "
             "s otázkou. Kdo nechce, slyší jen zajímavou historku. "
             "„Kdo má uši, slyš.“",
             "Při čtení pomáhají tři otázky: Komu to Ježíš vypráví? Co je "
             "na příběhu překvapivé? Kde je v něm Bůh a kde jsem já?"],
            [("Mt 13,10-13", "Proč k nim mluvíš v podobenstvích?"),
             ("Mt 13,34-35", "Otevřu ústa k podobenstvím"),
             ("Mk 4,33-34", "Učedníkům všechno vykládal")],
            ["Rabíni Ježíšovy doby také vyprávěli podobenství (mešalim), "
             "často o králi a jeho synech. Ježíšova podobenství jsou ale "
             "výjimečně živá a plná překvapivých zvratů.",
             "Mt 13,35 cituje Žalm 78,2 – Matouš vidí Ježíšovo vyprávění "
             "jako naplnění Písma."],
            ["Které podobenství znám nejlépe?",
             "Ptám se Ježíše na to, čemu nerozumím?"],
            "Vyberte si jedno podobenství a vyprávějte ho vlastními slovy "
            "někomu dalšímu."),
        lesson(
            "Rozsévač a čtyři půdy",
            ["Palestinský rolník rozséval rukou a teprve potom oral. Semena "
             "tedy padala všude: na vyšlapanou cestu přes pole, na tenkou "
             "vrstvu hlíny nad skálou, mezi kořeny trní i na dobrou půdu. "
             "Posluchači tu scénu dobře znali.",
             "Ježíš sám vykládá: semeno je Boží slovo, půdy jsou různá "
             "srdce. Někdo slovo vůbec nepřijme, jiný ho přijme s nadšením, "
             "ale bez kořenů, třetímu ho udusí starosti a bohatství.",
             "Překvapení je na konci: dobrá půda nese třicet, šedesát "
             "i stonásobek. Na tehdejší poměry, kdy desetinásobek byl dobrá "
             "úroda, je to obrovské číslo. Navzdory všem ztrátám Boží slovo "
             "nakonec přinese nečekanou úrodu."],
            [("Mk 4,3-9", "Vyšel rozsévač rozsívat"),
             ("Mk 4,14-20", "Ježíšův výklad")],
            ["Zrno pšenice vydá jeden klas s asi 30–40 zrny; jedna rostlina "
             "ovšem může vytvořit více klasů.",
             "Podobenství o rozsévači je jedno z mála, které Ježíš "
             "vykládá podrobně sám."],
            ["Jaká „půda“ jsem dnes já?",
             "Které „trní“ ve mně dusí Boží slovo?"],
            "Než začnete číst Bibli, modlete se: „Pane, udělej ze mě "
            "dobrou půdu.“"),
        lesson(
            "Ztracené a nalezené",
            ["Lukáš 15 začíná scénou: celníci a hříšníci přicházejí "
             "k Ježíši a farizeové reptají: „Tento přijímá hříšníky a jí "
             "s nimi.“ Ježíš odpovídá třemi příběhy o ztracené ovci, minci "
             "a synovi.",
             "Mladší syn žádá dědictví za otcova života – jako by řekl: "
             "„Kéž bys byl mrtvý.“ Když se vrací, otec běží naproti. "
             "V tehdejší kultuře vážený muž neběhal; musel si vykasat "
             "roucho. Otec na sebe bere ostudu, aby syna ochránil před "
             "posměchem vesnice.",
             "Příběh nekončí oslavou, ale starším bratrem, který odmítá "
             "vstoupit. Otec vyjde i za ním. Konec zůstává otevřený – "
             "farizeové, kteří poslouchali, měli sami rozhodnout, zda "
             "vejdou na hostinu."],
            [("L 15,1-2", "Jí s hříšníky"),
             ("L 15,8-10", "Ztracená mince"),
             ("L 15,20-24", "Otec běží vstříc"),
             ("L 15,28-32", "Starší bratr venku")],
            ["Ztracená mince byla nejspíš drachma – asi denní mzda. "
             "Mohla patřit k ženinu věnu, zavěšenému na čelence.",
             "Rembrandtův obraz Návrat ztraceného syna (asi 1668) "
             "zobrazuje otcovy ruce rozdílně – jednu mužskou a jednu "
             "jemnější, ženskou."],
            ["Jsem dnes spíš mladší, nebo starší syn?",
             "Je někdo, komu bych měl „vyběhnout naproti“?"],
            "Přečtěte si celé L 15 nahlas a všímejte si slova „radost“."),
        lesson(
            "Milosrdný Samaritán",
            ["Zákoník se ptá: „Kdo je můj bližní?“ Chce vědět, kde končí "
             "jeho povinnost. Ježíš vypráví o muži přepadeném na cestě "
             "z Jeruzaléma do Jericha – pusté, prudce klesající cestě, kde "
             "se přepadávalo.",
             "Kněz i levita jdou kolem. Možná se báli rituální nečistoty "
             "z dotyku mrtvého, možná se báli lupičů. Třetí je Samaritán – "
             "člen národa, kterým Židé pohrdali (a naopak). Ošetří zraněného "
             "olejem a vínem, posadí ho na své zvíře a zaplatí za něj "
             "hostinského.",
             "Na konci Ježíš otázku obrací: ne „kdo je můj bližní?“, ale "
             "„kdo se zachoval jako bližní?“ Zákoník nedokáže vyslovit slovo "
             "„Samaritán“ a řekne jen: „Ten, kdo mu prokázal milosrdenství.“ "
             "„Jdi a jednej stejně.“"],
            [("L 10,25-29", "Kdo je můj bližní?"),
             ("L 10,30-37", "Jdi a jednej stejně")],
            ["Dva denáry, které Samaritán dal hostinskému, stačily asi na "
             "dva týdny ubytování.",
             "Olej a víno byly běžné léky: víno dezinfikovalo, olej "
             "zklidňoval rány."],
            ["Kolem koho „procházím po druhé straně cesty“?",
             "Kdo je pro mě „Samaritán“, od koho bych nečekal dobro?"],
            "Udělejte dnes konkrétní čin milosrdenství pro někoho, kdo "
            "vám ho nemůže vrátit."),
        lesson(
            "Svěřené hřivny",
            ["Pán odchází na cestu a svěří služebníkům majetek: jednomu pět "
             "talentů, druhému dva, třetímu jeden – „každému podle jeho "
             "schopností“. Talent byla obrovská částka, mzda za mnoho let "
             "práce. I jeden talent byl ohromná důvěra.",
             "Dva služebníci s penězi pracují a zdvojnásobí je. Třetí ho "
             "zakope ze strachu – měl o pánovi představu přísného, "
             "tvrdého muže. Jeho problém není malý dar, ale strach, který "
             "ho ochromil.",
             "Pochvala zní pro oba úspěšné stejně: „Správně, dobrý a věrný "
             "služebníku… vejdi do radosti svého pána.“ Nejde o výkon, ale "
             "o věrnost s tím, co jsme dostali."],
            [("Mt 25,14-18", "Pět, dva a jeden talent"),
             ("Mt 25,19-23", "Vejdi do radosti svého pána"),
             ("Mt 25,24-30", "Bál jsem se, a tak jsem ho zakopal")],
            ["Právě z tohoto podobenství vzniklo české i anglické slovo "
             "„talent“ ve smyslu „nadání“.",
             "Zakopat peníze bylo v té době považováno za nejbezpečnější "
             "způsob úschovy – služebník tedy nejednal hloupě, ale "
             "bez odvahy a důvěry."],
            ["Jaký „talent“ mi Bůh svěřil?",
             "Kde mě strach drží od toho, abych dar použil?"],
            "Použijte tento týden jeden svůj dar ve prospěch druhých."),
        lesson(
            "Pozvání na hostinu",
            ["Na velké hostiny se ve starověku zvalo dvakrát: nejprve "
             "pozvánka, a když bylo vše připraveno, služebník šel hosty "
             "zavolat. Odmítnout v poslední chvíli byla těžká urážka.",
             "V Ježíšově podobenství se pozvaní vymlouvají: koupil jsem pole, "
             "koupil jsem voly, oženil jsem se. Hospodář se rozhněvá – "
             "a pozve chudé, zmrzačené, slepé a chromé, a nakonec i lidi "
             "z cest a ohrad za městem.",
             "Ježíš tak popisuje Boží království: Bůh zve všechny, a právě ti, "
             "kdo by nečekali pozvání, přicházejí. Zároveň radí: až pořádáš "
             "hostinu, pozvi ty, kdo ti to nemohou oplatit."],
            [("L 14,12-14", "Pozvi chudé a chromé"),
             ("L 14,16-20", "Výmluvy pozvaných"),
             ("L 14,21-23", "Jdi na cesty a k plotům")],
            ["Podobné podobenství v Mt 22 obsahuje i detail svatebního "
             "roucha – hosté možná dostávali sváteční oblečení od "
             "hostitele.",
             "Obraz hostiny se táhne celou Biblí – od Izajášovy hostiny pro "
             "všechny národy (Iz 25,6) po svatební hostinu Beránkovu "
             "(Zj 19,9)."],
            ["Jaké výmluvy používám, když mě Bůh zve?",
             "Koho bych mohl pozvat, kdo mi to nemůže oplatit?"],
            "Přijměte dnes Boží pozvání: najděte si chvíli jen pro něj."),
    ])

# =============================================================================
course(
    "prophets", "flame", "8C4A6B", "Proroci – Boží hlas v krizi",
    "Lidé, kteří mluvili, když ostatní mlčeli",
    "Proroci nebyli hlavně věštci budoucnosti, ale Boží mluvčí do své "
    "doby. Napomínali krále, zastávali se chudých a ve tmě vyhlašovali "
    "naději. Kurz představuje šest prorockých osobností.",
    [
        lesson(
            "Kdo byl prorok",
            ["Hebrejské navi znamená „povolaný“ nebo „ten, kdo ohlašuje“. "
             "Prorok mluvil jménem Boha – „Tak praví Hospodin“. Většina "
             "proroctví se netýká vzdálené budoucnosti, ale přítomnosti: "
             "hříchu, nespravedlnosti, modlářství, a Božího volání k návratu.",
             "Proroci byli různí: Amos byl pastýř a pěstitel fíků, Izajáš "
             "měl přístup ke královskému dvoru, Jeremjáš byl kněz, Ezechiel "
             "žil ve vyhnanství. Mnozí se svému povolání bránili – "
             "Mojžíš, Jeremjáš i Jonáš.",
             "Prorok platil vysokou cenu: Jeremjáš skončil v cisterně, "
             "Elijáš utíkal před Jezábel. Ježíš řekl, že Jeruzalém "
             "„zabíjí proroky“. Pravdu, kterou nikdo nechce slyšet, je "
             "těžké vyslovit."],
            [("Dt 18,18", "Vzbudím jim proroka"),
             ("Am 3,7-8", "Lev zařval – kdo by se nebál?"),
             ("Jr 1,4-10", "Jsem jen chlapec")],
            ["Prorocké knihy se dělí na „velké“ (Izajáš, Jeremjáš, "
             "Ezechiel, Daniel) a „malé“ (dvanáct kratších). Rozdíl je "
             "v délce, ne v důležitosti.",
             "Proroci často jednali symbolicky: Jeremjáš nosil jho na krku, "
             "Ezechiel ležel 390 dní na boku, Ozeáš si vzal nevěrnou ženu."],
            ["Kdo dnes plní roli „proroka“ – říká nepříjemnou pravdu?",
             "Bráním se něčemu, k čemu mě Bůh volá?"],
            "Až budete číst proroka, zeptejte se: jaký hřích nebo jakou "
            "bolest jeho doby řeší?"),
        lesson(
            "Elijáš – oheň a tichý hlas",
            ["Elijáš (jméno znamená „Můj Bůh je Hospodin“) působil "
             "v 9. století př. Kr. za krále Achaba a jeho ženy Jezábel, "
             "která prosazovala uctívání Baala, boha bouře a deště. Elijáš "
             "ohlásil sucho – Baal tedy nemohl dát déšť.",
             "Na hoře Karmel vyzval 450 Baalových proroků k souboji: "
             "který Bůh odpoví ohněm? Baal mlčel, Hospodin odpověděl. Lid "
             "volal: „Hospodin je Bůh!“",
             "Hned potom Elijáš utíká před Jezábel do pouště a chce zemřít. "
             "Bůh ho nekárá – dá mu najíst a spát. Na Chorebu pak k němu "
             "nepromluví ve větru, zemětřesení ani ohni, ale v „hlasu "
             "tichého vánku“."],
            [("1Kr 18,21", "Jak dlouho budete kulhat na obě strany?"),
             ("1Kr 18,36-39", "Oheň z nebe"),
             ("1Kr 19,4-8", "Anděl ho nechá spát a najíst se"),
             ("1Kr 19,11-13", "Hlas tichého vánku")],
            ["Elijáš nezemřel – byl vzat do nebe v ohnivém voze. Proto "
             "Židé dodnes při Pesachu nechávají pro Elijáše prázdný pohár "
             "a otevírají mu dveře.",
             "Při proměnění na hoře se Ježíš ukazuje s Mojžíšem "
             "a Elijášem – zástupci Zákona a Proroků."],
            ["Kde „kulhám na obě strany“?",
             "Dopřávám si odpočinek, když jsem po velkém nasazení "
             "vyčerpaný?"],
            "Najděte si dnes deset minut ticha a jen poslouchejte."),
        lesson(
            "Amos – spravedlnost jako proud",
            ["Amos byl pastýř z Tekóje v Judsku, ale Bůh ho poslal do "
             "severního Izraele v době hospodářského rozkvětu (8. stol. "
             "př. Kr.). Bohatí bydleli v domech z tesaného kamene a s "
             "postelemi zdobenými slonovinou – a prodávali chudé „za pár "
             "sandálů“.",
             "Lidé přitom chodili pilně na bohoslužby. Amos přináší šokující "
             "Boží slovo: „Nenávidím vaše svátky… Ať se valí právo jako "
             "voda a spravedlnost jako stálý potok.“",
             "Amos ukazuje, že víra a spravedlnost patří k sobě. Bůh se "
             "nedá uctívat v chrámu a přehlížet na tržišti."],
            [("Am 5,21-24", "Ať se valí právo jako voda"),
             ("Am 8,4-6", "Šidí váhami a kupují chudé"),
             ("Am 7,14-15", "Nejsem prorok, jsem pastýř")],
            ["Martin Luther King citoval Am 5,24 v projevu „I Have "
             "a Dream“ (1963): „…dokud se právo nebude valit jako voda "
             "a spravedlnost jako mocný proud.“",
             "V Samaří archeologové našli stovky vyřezávaných destiček ze "
             "slonoviny z doby proroka Amose."],
            ["Ladí moje bohoslužba s tím, jak jednám v práci a s penězi?",
             "Kde v mém okolí potřebuje „téct“ spravedlnost?"],
            "Zkontrolujte, zda ve vašem nakupování nebo práci není "
            "nějaká drobná nepoctivost."),
        lesson(
            "Izajáš – svatý Bůh a trpící služebník",
            ["Izajáš byl povolán roku, kdy zemřel král Uzijáš (asi 740 "
             "př. Kr.). V chrámu viděl Hospodina na trůnu a serafy volající "
             "„Svatý, svatý, svatý“. Uvědomil si svou nečistotu – a byl "
             "očištěn žhavým uhlíkem. Pak zaznělo: „Koho pošlu?“ – "
             "„Zde jsem, pošli mne.“",
             "Kniha Izajáš je jako malá Bible: 66 kapitol, první část plná "
             "soudu, druhá (od kap. 40) plná útěchy: „Potěšujte, potěšujte "
             "můj lid.“ Mluví o dítěti, které se narodí, o výhonku "
             "z Jišajova pařezu a o pokoji, kdy vlk bude bydlet s beránkem.",
             "Nejhlubší jsou písně o trpícím Hospodinově služebníku. "
             "Iz 53 popisuje toho, kdo „byl proboden pro naše nevěrnosti“. "
             "Křesťané od počátku v tomto textu viděli Ježíše."],
            [("Iz 6,1-8", "Zde jsem, pošli mne"),
             ("Iz 40,1-2", "Potěšujte můj lid"),
             ("Iz 53,4-6", "Nesl naše nemoci")],
            ["Izajáš je v Novém zákoně citován jménem více než "
             "dvacetkrát. Etiopský dvořan četl Iz 53, když ho potkal "
             "Filip (Sk 8,32).",
             "V Izajášovi je i slavný obraz míru: „Překovají své meče na "
             "radlice“ (Iz 2,4) – slova jsou vytesána na zdi naproti sídlu "
             "OSN v New Yorku."],
            ["Jak reaguji, když zaslechnu Boží „Koho pošlu?“",
             "Který verš z Izajáše mě nejvíc utěšuje?"],
            "Přečtěte si pomalu Iz 53 a myslete přitom na kříž."),
        lesson(
            "Jeremjáš – plačící prorok",
            ["Jeremjáš byl povolán jako mladík a působil přes 40 let, až do "
             "pádu Jeruzaléma v roce 586 př. Kr. Měl nevděčný úkol: "
             "ohlašovat porážku národu, který tomu nechtěl věřit. Byl "
             "bit, vězněn, spuštěn do bahnité cisterny.",
             "Jeremjáš otevřeně mluví o své bolesti – proklíná den svého "
             "narození a stěžuje si Bohu, že ho „přemluvil“. Je to nejosobnější "
             "z proroků. Jeho kniha ukazuje, že poslušnost Bohu neznamená "
             "bezbolestný život.",
             "Uprostřed katastrofy přichází nejsilnější naděje: Bůh uzavře "
             "„novou smlouvu“ a vepíše zákon do srdcí. A Jeremjáš "
             "z vězení koupí pole – znamení, že se do země jednou vrátí "
             "život. Ježíš při poslední večeři mluví o „nové smlouvě"
             "“."],
            [("Jr 1,6-8", "Neříkej: Jsem jen chlapec"),
             ("Jr 18,1-6", "Hrnčíř a hlína"),
             ("Jr 31,31-34", "Nová smlouva"),
             ("Jr 32,15", "Ještě se budou kupovat domy a pole")],
            ["V Jeruzalémě byly nalezeny pečetní otisky (buly) se jmény "
             "Jehuchala a Gedaljáše – úředníků, kteří podle Jr 38,1 "
             "žádali Jeremjášovu smrt.",
             "Jeremjáš se nesměl oženit (Jr 16,2) – i jeho osamělý život "
             "byl znamením pro národ."],
            ["Smím Bohu říct svou bolest tak upřímně jako Jeremjáš?",
             "V čem mohu „koupit pole“ – udělat čin naděje uprostřed "
             "nejistoty?"],
            "Udělejte dnes jeden malý čin naděje – zasaďte, napište, "
            "pozvěte."),
        lesson(
            "Jonáš – prorok, který utíkal",
            ["Ninive bylo hlavní město Asýrie, nejkrutější velmoci své doby. "
             "Bůh posílá Jonáše, aby tam kázal. Jonáš nasedne na loď "
             "opačným směrem – do Taršíše, na konec známého světa.",
             "Po bouři a pobytu v rybě Jonáš nakonec jde a ohlásí zkázu. "
             "A Ninive se k překvapení všech obrátí – od krále po dobytek. "
             "Bůh se slituje. Jonáš je rozzlobený: věděl, že Bůh je "
             "„milostivý a slitovný“, a nechtěl, aby se to týkalo nepřátel.",
             "Kniha končí otázkou bez odpovědi: „Neměl bych já litovat "
             "Ninive, ve kterém je přes sto dvacet tisíc lidí?“ Otázka "
             "zůstává viset i nad čtenářem – komu nepřeji Boží milost?"],
            [("Jon 1,1-3", "Jonáš utíká do Taršíše"),
             ("Jon 2,3", "Z hlubin jsem volal"),
             ("Jon 3,10", "Bůh viděl, že se odvrátili"),
             ("Jon 4,10-11", "Neměl bych litovat Ninive?")],
            ["Bible neříká „velryba“, ale „veliká ryba“. Představa "
             "velryby je pozdější.",
             "Ježíš mluví o „znamení proroka Jonáše“: jako byl Jonáš tři "
             "dny v rybě, bude Syn člověka tři dny v nitru země "
             "(Mt 12,40)."],
            ["Kdo je pro mě „Ninive“ – lidé, kterým nepřeji Boží "
             "milost?",
             "Kam utíkám, když se mi nechce dělat, co Bůh chce?"],
            "Modlete se dnes za člověka nebo skupinu, kterou máte nejméně "
            "rádi."),
    ])

# =============================================================================
course(
    "paul", "compass", "4E9A8A", "Pavel a první církev",
    "Od pronásledovatele k apoštolovi národů",
    "Pavel napsal skoro polovinu knih Nového zákona a přenesl evangelium "
    "do Evropy. Kurz sleduje jeho život – obrácení, cesty, dopisy "
    "a poslední roky – a ukazuje, jak žila první církev.",
    [
        lesson(
            "Saul z Tarsu",
            ["Pavel se narodil v Tarsu, univerzitním městě v dnešním "
             "Turecku, v židovské rodině, která měla římské občanství. "
             "Měl dvě jména: hebrejské Saul (po prvním izraelském králi, "
             "také z kmene Benjamín) a římské Paulus.",
             "Vyrůstal v Jeruzalémě a studoval u slavného rabína Gamaliela. "
             "Byl horlivý farizeus – podle vlastních slov „bezúhonný“ "
             "v dodržování zákona. Mluvil hebrejsky (aramejsky) i řecky "
             "a znal řeckou literaturu.",
             "Jeho horlivost ho vedla k pronásledování křesťanů. Stál u "
             "kamenování Štěpána a hlídal oděvy těch, kdo kameny házeli. "
             "Křesťanství považoval za nebezpečný blud."],
            [("Sk 7,58", "Mladík jménem Saul"),
             ("Sk 22,3", "U nohou Gamalielových"),
             ("Fp 3,4-6", "Hebrej z Hebrejů, farizeus")],
            ["Pavel si vydělával jako výrobce stanů (Sk 18,3) – řemeslo "
             "z kůže nebo tkaniny z kozí srsti, které se v Tarsu "
             "proslavilo.",
             "Jméno Paulus znamená latinsky „malý“."],
            ["Je ve mně horlivost, která by mohla jít špatným směrem?",
             "Koho bych odepsal, a přitom ho Bůh může proměnit?"],
            "Modlete se dnes za někoho, kdo je víře nepřátelský."),
        lesson(
            "Cesta do Damašku",
            ["Saul jel do Damašku zatknout křesťany. Na cestě ho oslnilo "
             "světlo z nebe a uslyšel hlas: „Saule, Saule, proč mě "
             "pronásleduješ?“ – „Kdo jsi, Pane?“ – „Já jsem Ježíš, "
             "kterého ty pronásleduješ.“",
             "Ježíš se ztotožňuje se svými učedníky: kdo pronásleduje "
             "církev, pronásleduje jeho. Saul tři dny nevidí, nejí ani nepije. "
             "Pak k němu Bůh pošle Ananiáše – obyčejného věřícího, který se "
             "bál. Ananiáš ho osloví „bratře Saule“.",
             "Pavel později vzpomíná, že ho Bůh „vybral už v lůně matky“. "
             "Nejdřív odešel do Arábie a teprve po třech letech se setkal "
             "s Petrem. Jeho proměna nebyla jen okamžik, ale dlouhá cesta."],
            [("Sk 9,3-6", "Saule, proč mě pronásleduješ?"),
             ("Sk 9,10-18", "Ananiáš: Bratře Saule"),
             ("Ga 1,15-18", "Arábie a po třech letech Jeruzalém")],
            ["Výraz „spadly mu šupiny z očí“ (Sk 9,18) se stal českým "
             "rčením pro náhlé pochopení.",
             "Ulice Přímá v Damašku (Sk 9,11) existuje dodnes – je to "
             "hlavní ulice starého města."],
            ["Kdy mi „spadly šupiny z očí“ v něčem duchovním?",
             "Mohu být pro někoho „Ananiášem“ – i když se bojím?"],
            "Napište nebo zavolejte někomu, kdo začíná ve víře, a povzbuďte "
            "ho."),
        lesson(
            "Na cestách",
            ["Kniha Skutků popisuje tři velké Pavlovy misijní cesty a "
             "plavbu do Říma – dohromady snad přes 15 000 kilometrů pěšky "
             "a lodí. Pavel obvykle začínal v synagoze, a když ho odmítli, "
             "obrátil se k pohanům.",
             "Na druhé cestě ho Duch svatý dvakrát zastavil, až ve snu "
             "uviděl Makedonce: „Přejdi a pomoz nám.“ Tak se evangelium "
             "dostalo do Evropy – prvním evropským křesťanem byla "
             "obchodnice Lýdie ve Filipech.",
             "V Athénách Pavel mluvil k filosofům na Areopagu. Navázal na "
             "oltář „Neznámému Bohu“ a citoval řecké básníky. Ukázal, jak "
             "mluvit o víře lidem, kteří neznají Bibli."],
            [("Sk 13,2-3", "Oddělte mi Barnabáše a Saula"),
             ("Sk 16,9-10", "Přejdi do Makedonie"),
             ("Sk 17,22-28", "Neznámému Bohu"),
             ("2K 11,24-27", "Pětkrát bit, třikrát ztroskotal")],
            ["Věta „v něm žijeme, pohybujeme se a jsme“ (Sk 17,28) je "
             "pravděpodobně citát řeckého básníka Epimenida.",
             "V Korintu byl nalezen nápis o Erastovi, městském úředníkovi; "
             "Erastus, „městský pokladník“, posílá pozdrav v Ř 16,23."],
            ["Kde mě Bůh „zastavil“ a pak otevřel jiné dveře?",
             "Jak mohu mluvit o víře lidem, kteří Bibli neznají?"],
            "Podívejte se v aplikaci na mapu Pavlových cest a sledujte "
            "trasu."),
        lesson(
            "Jak číst Pavlovy dopisy",
            ["Pavlovy dopisy nejsou teologické učebnice, ale skutečná "
             "korespondence. Odpovídají na otázky a problémy konkrétních "
             "sborů: spory, falešné učení, otázky o vzkříšení, o jídle, "
             "o manželství. Číst je je trochu jako slyšet jednu stranu "
             "telefonního hovoru.",
             "Dopisy mají ustálenou stavbu: pozdrav (odesílatel, adresát, "
             "„milost a pokoj“), díkůvzdání, hlavní část – obvykle nejdřív "
             "výklad víry, potom praktické důsledky – a pozdravy na konec.",
             "Pomáhá ptát se: jaký problém Pavel řeší? Co Korinťané nebo "
             "Galaťané asi napsali nebo udělali? Teprve pak se ptáme, co "
             "z toho platí pro nás."],
            [("Ř 1,1-7", "Pozdrav dopisu Římanům"),
             ("Fp 1,3-6", "Díkůvzdání za Filipské"),
             ("2Pt 3,15-16", "Některé věci jsou těžko pochopitelné")],
            ["Pavlovy dopisy jsou v Bibli seřazeny zhruba podle délky – "
             "od nejdelšího (Římanům) po nejkratší (Filemonovi).",
             "List Filemonovi je soukromý dopis o uprchlém otrokovi "
             "Onésimovi. Jeho jméno znamená „Užitečný“ – a Pavel si s tím "
             "jménem hraje (Fm 11)."],
            ["Který Pavlův dopis bych si chtěl přečíst celý najednou?",
             "Jaký „dopis“ by Pavel napsal mému společenství?"],
            "Přečtěte si celý list Filemonovi – zabere jen pár minut."),
        lesson(
            "Korint – církev s problémy",
            ["Korint byl bohaté přístavní město s pověstí nemravnosti. "
             "Pavel tam strávil rok a půl a založil sbor z různých lidí – "
             "Židů i pohanů, otroků i bohatých.",
             "Sbor měl hodně problémů: rozdělení podle oblíbených kazatelů, "
             "soudní spory mezi bratry, nemravnost, zmatek při bohoslužbách, "
             "pohrdání chudými při Večeři Páně, pochybnosti o vzkříšení. "
             "Pavel na to vše odpovídá trpělivě i ostře.",
             "A právě do tohoto problémového sboru napsal nejkrásnější "
             "text o lásce: „Láska je trpělivá, laskavá, nezávidí…“ "
             "První Korintským ukazuje, že církev byla vždy společenstvím "
             "nedokonalých lidí, které Bůh proměňuje."],
            [("Sk 18,1-4", "Pavel u Akvily a Priscilly"),
             ("1K 1,10-13", "Já jsem Pavlův, já Apollův"),
             ("1K 13,4-7", "Láska je trpělivá")],
            ["Korint měl dva přístavy a přes šíji mezi nimi se lodě táhly "
             "po kamenné dráze diolkos. Dnešní Korintský průplav byl "
             "dokončen v roce 1893.",
             "Korint pořádal Isthmické hry, druhé nejslavnější po "
             "olympijských. Pavel proto v 1K 9,24-27 mluví o běžcích "
             "a věnci."],
            ["Co mi říká, že i první církve měly tolik problémů?",
             "Kterou vlastnost lásky z 1K 13 nejvíc potřebuji?"],
            "Přečtěte si 1K 13,4-7 a místo „láska“ dosaďte své jméno. "
            "Kde to nesedí?"),
        lesson(
            "Řím a dobrý boj",
            ["Pavel byl zatčen v Jeruzalémě a jako římský občan se "
             "odvolal k císaři. Cesta do Říma skončila ztroskotáním na "
             "Maltě. V Římě pak dva roky žil v pronajatém domě pod stráží "
             "a „bez překážek“ kázal každému, kdo přišel.",
             "Z vězení psal dopisy plné radosti a naděje: Filipským, "
             "Efezským, Koloským a Filemonovi. „Mně je život Kristus "
             "a smrt zisk.“",
             "Podle tradice zemřel v Římě za císaře Nerona kolem roku 64–67 "
             "– jako římský občan stětím mečem. Jeho poslední dopis "
             "končí slovy vítěze: „Dobrý boj jsem bojoval, běh jsem "
             "dokonal, víru zachoval.“"],
            [("Sk 27,23-25", "Anděl v bouři: Neboj se"),
             ("Sk 28,30-31", "Kázal bez překážek"),
             ("Fp 1,21-24", "Život je Kristus"),
             ("2Tm 4,6-8", "Dobrý boj jsem bojoval")],
            ["Na Maltě je dodnes záliv svatého Pavla, kde podle tradice "
             "ztroskotal; Pavla tam uštkla zmije a on zůstal bez úhony "
             "(Sk 28,3-5).",
             "Bazilika sv. Pavla za hradbami v Římě stojí podle tradice nad "
             "jeho hrobem."],
            ["Jak bych chtěl, aby zněla poslední věta mého života?",
             "Kde mohu i v omezení (nemoc, „vězení“) sloužit druhým?"],
            "Přečtěte si celý list Filipským – dopis radosti z vězení."),
    ])
