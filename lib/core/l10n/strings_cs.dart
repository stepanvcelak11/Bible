/// Všechny texty uživatelského rozhraní – aplikace je pouze česky.
///
/// Řetězce jsou na jednom místě, aby bylo snadné je sjednotit (a případně
/// později převést na ARB/gen-l10n). V kódu UI se nepoužívají literály.
abstract final class S {
  static const appName = 'Bible';

  // Zákony a obecné pojmy
  static const oldTestament = 'Starý zákon';
  static const newTestament = 'Nový zákon';
  static const chapter = 'Kapitola';
  static const verse = 'Verš';
  static const bookmarks = 'Záložky';
  static const notes = 'Poznámky';
  static const highlights = 'Zvýraznění';
  static const search = 'Hledat';

  // Výběr překladu
  static const selectTranslation = 'Vybrat překlad';
  static const translation = 'Překlad';
  static const compareWith = 'Porovnat s překladem';
  static const compareTranslations = 'Porovnat dva překlady';
  static const compareOff = 'Vypnout porovnání';
  static const swapTranslations = 'Prohodit překlady';
  static const noOtherTranslation =
      'Pro porovnání je potřeba alespoň dva překlady.';

  // Navigace
  static const previousChapter = 'Předchozí kapitola';
  static const nextChapter = 'Další kapitola';
  static const chapterMissing =
      'Tato kapitola v překladu chybí (překlady se mohou lišit v číslování).';

  // Chyby a stavy
  static const loading = 'Načítám…';
  static const errorTitle = 'Něco se pokazilo';
  static const errorLoadChapter = 'Kapitolu se nepodařilo načíst.';
  static const retry = 'Zkusit znovu';
  static const dataMissingTitle = 'Chybí data Bible';
  static const dataMissingBody =
      'Aplikace neobsahuje databázi překladů. Sestavte ji příkazem\n\n'
      'python3 tool/build_bible_db.py --fetch\n\n'
      'a aplikaci znovu sestavte.';

  // Čtečka a výběr knih
  static const chooseBook = 'Vybrat knihu';
  static const menu = 'Nabídka';
  static const journal = 'Deník';
  static const settings = 'Nastavení';

  // Akce s verši
  static const highlight = 'Zvýraznit';
  static const removeHighlight = 'Odebrat zvýraznění';
  static const addBookmark = 'Přidat záložku';
  static const removeBookmark = 'Odebrat záložku';
  static const bookmark = 'Záložka';
  static const addNote = 'Přidat poznámku';
  static const editNote = 'Upravit poznámku';
  static const note = 'Poznámka';
  static const copy = 'Kopírovat';
  static const share = 'Sdílet';
  static const copied = 'Zkopírováno do schránky';
  static const tabTranslations = 'Překlady';
  static const translationsCompareHint =
      'Stáhněte si další překlady a uvidíte tu verš ve všech vedle sebe.';
  static const cancelSelection = 'Zrušit výběr';
  static const notePlaceholder = 'Vaše myšlenky k tomuto místu…';
  static const save = 'Uložit';
  static const delete = 'Smazat';
  static const deleted = 'Smazáno';
  static const undo = 'Zpět';
  static const close = 'Zavřít';
  static String chapterLength(int verses, int minutes) =>
      '$verses ${_plural(verses, 'verš', 'verše', 'veršů')} · ≈ $minutes min';
  static const chapterAlreadyRead = 'přečteno';
  static const deleteNoteQuestion = 'Smazat poznámku?';
  static const cancel = 'Zrušit';

  // Hledání
  static const searchHint = 'Slovo, frázi nebo odkaz (J 3,16)…';
  static const searchAll = 'Celá Bible';
  static const searchEmptyTitle = 'Hledání v Bibli';
  static const searchEmptyBody =
      'Diakritiku psát nemusíte – „laska“ najde i „láska“. '
      'Přesnou frázi dejte do uvozovek.';
  static const searchNoResults = 'Nic nenalezeno';
  static String searchResultCount(int n, {required bool limited}) =>
      limited ? 'Zobrazeno prvních $n výsledků' : _results(n);
  static String _results(int n) => switch (n) {
    1 => '1 výsledek',
    >= 2 && <= 4 => '$n výsledky',
    _ => '$n výsledků',
  };

  // Deník
  static const journalIntro =
      'Vaše záložky, poznámky, zvýraznění a modlitby. Vše zůstává jen v tomto '
      'zařízení; smazání = přejetí doleva.';
  static const journalEmptyBookmarks =
      'Zatím žádné záložky.\nPřidáte je klepnutím na verš.';
  static const journalEmptyNotes =
      'Zatím žádné poznámky.\nPřidáte je klepnutím na verš.';
  static const journalEmptyHighlights =
      'Zatím žádná zvýraznění.\nPřidáte je klepnutím na verš.';

  // Nastavení
  static const appearance = 'Vzhled';
  static const theme = 'Motiv';
  static const themeSystem = 'Systém';
  static const themeLight = 'Světlý';
  static const themeSepia = 'Sépie';
  static const themeDark = 'Tmavý';
  static const background = 'Pozadí';
  static const accentColor = 'Barva';
  static const accentGold = 'Zlatá';
  static const accentOlive = 'Olivová';
  static const accentOcean = 'Modrá';
  static const accentPlum = 'Švestková';
  static const accentTerracotta = 'Terakota';
  static const readAloud = 'Předčítání';
  static const shareVerse = 'Sdílet verš';
  static const shareAsImage = 'Obrázek';
  static const shareAsText = 'Text';
  static const cardNight = 'Večer';
  static const cardPaper = 'Papír';
  static const cardDawn = 'Svítání';
  static const readAloudUnavailable = 'Toto zařízení neumí předčítat text.';
  static const readAloudNoCzechVoice =
      'Nenašel jsem český hlas, text přečte jiný hlas. Na iPhonu ho přidáte '
      'v Nastavení → Zpřístupnění → Předčítaný obsah → Hlasy → Čeština.';
  static const pause = 'Pozastavit';
  static const resume = 'Pokračovat';
  static const stop = 'Zastavit';
  static const backgroundPlain = 'Jednobarevné';
  static const backgroundPaper = 'Papír';
  static const backgroundGlow = 'Záře';
  static const backgroundSky = 'Obloha';
  static const fontSize = 'Velikost písma';
  static const lineHeight = 'Řádkování';
  static const margins = 'Okraje';
  static const showVerseNumbers = 'Čísla veršů';
  static const dropCap = 'Ozdobná iniciála';
  static const dropCapHint =
      'Velké první písmeno kapitoly jako v tištěné Bibli';
  static const resetAppearance = 'Obnovit výchozí vzhled';
  static const previewText =
      'Na počátku bylo Slovo, a to Slovo bylo u Boha, a Bůh byl to Slovo.';
  static const backup = 'Záloha';
  static const backupInfo =
      'Poznámky, záložky a zvýraznění jsou uložené jen v tomto zařízení. '
      'Zálohu si uložte do Souborů nebo pošlete sami sobě.';
  static const exportBackup = 'Uložit zálohu';
  static const importBackup = 'Obnovit ze zálohy';
  static const backupInvalid = 'Soubor není platná záloha.';
  static String backupImported(int n) => 'Obnoveno položek: $n';
  static const about = 'O aplikaci';
  static const aboutBody =
      'Soukromá čtečka Bible. Bez reklam, účtů a sledování – vše zůstává '
      'v tomto zařízení a funguje bez internetu.';
  static const translations = 'Překlady';

  // Navigace aplikace
  static const tabToday = 'Dnes';
  static const tabBible = 'Bible';
  static const tabSearch = 'Hledat';
  static const tabMaps = 'Mapy';
  static const tabStudy = 'Studium';
  static const tabJournal = 'Deník';

  // Čtečka – rozšíření
  static const footnote = 'Poznámka překladu';
  static const bookIntro = 'Úvod ke knize';
  static String placesInChapter(int n) => switch (n) {
    1 => '1 místo na mapě',
    >= 2 && <= 4 => '$n místa na mapě',
    _ => '$n míst na mapě',
  };
  static const study = 'Studovat';
  static const paragraphMode = 'Text v odstavcích';
  static const paragraphModeHint =
      'Jako v tištěné Bibli (u překladů s členěním, např. B21).';

  // Úvod ke knize
  static const author = 'Autor';
  static const written = 'Doba';
  static const theme2 = 'Hlavní téma';
  static const outline = 'Obsah knihy';
  static const keyVerses = 'Klíčové verše';
  static const readBook = 'Číst knihu';

  // Studium verše
  static const original = 'Originál';
  static const crossRefs = 'Souvislosti';
  static const studyPackTitle = 'Studijní balíček';
  static const studyPackBody =
      'Původní hebrejský a řecký text slovo po slově, slovník s českými '
      'významy a 87 000 souvislostí mezi verši. Stáhne se jednou a pak '
      'funguje bez internetu.';
  static String studyPackDownload(String size) => 'Stáhnout ($size)';
  static const studyPackInstalled = 'Studijní balíček je stažený';
  static const studyPackRemove = 'Odstranit studijní balíček';
  static const studyPackCredits =
      'Původní text a slovník: STEPBible.org (CC BY 4.0). Souvislosti a '
      'místa: OpenBible.info (CC BY 4.0). Mapa: Natural Earth.';
  static const downloading = 'Stahuji…';
  static const processing = 'Zpracovávám…';
  static const saving = 'Ukládám…';
  static const noOriginal = 'K tomuto verši není původní text k dispozici.';
  static const noCrossRefs = 'K tomuto verši nejsou žádné souvislosti.';
  static const englishMeaning = 'Anglický výklad (STEPBible)';
  static const czechMeaning = 'Význam';
  static const grammar = 'Tvar';
  static const strongNumber = 'Strongovo číslo';
  static String occurrencesCount(int n) => 'Vyskytuje se $n×';
  static const showOccurrences = 'Kde všude se vyskytuje';
  static const originalHint =
      'Klepněte na slovo pro slovník. Pořadí slov je podle původního textu.';

  // Dnes
  static const goodMorning = 'Dobré ráno';
  static const goodDay = 'Dobrý den';
  static const goodEvening = 'Dobrý večer';
  static const verseOfDay = 'Verš dne';
  static const continueReading = 'Pokračovat ve čtení';
  static const streak = 'dní v řadě';
  static const thisWeek = 'kapitol tento týden';
  static const totalRead = 'přečteno celkem';
  static const readingPlan = 'Plán čtení';
  static const choosePlan = 'Vybrat plán čtení';
  static const planIntro =
      'Pravidelné čtení po malých dávkách. Pokrok se ukládá jen ve vašem zařízení.';
  static const startPlan = 'Začít';
  static const stopPlan = 'Ukončit plán';
  static String planDay(int day, int total) => 'Den $day z $total';
  static const planDone = 'Plán je dokončen. Skvělá práce!';
  static const markDone = 'Hotovo';
  static const recentlyRead = 'Nedávno čteno';
  static const explore = 'Objevovat';
  static const exploreMaps = 'Biblické mapy';
  static const exploreMapsHint = 'Místa a cesty';
  static const exploreIntros = 'Úvody ke knihám';
  static const exploreIntrosHint = 'Autor, doba, téma';
  static const exploreTranslations = 'Překlady';
  static const exploreTranslationsHint = 'B21, ČEP, ČSP…';
  static const situations = 'Verše do situací';
  static const studyTeaserTitle = 'Studium';
  static const myReading = 'Moje čtení';
  static const markReadEarlier = 'Co už mám přečtené';
  static String finishEstimate(String date, String pace) =>
      'Při současném tempu ($pace kapitoly denně za poslední měsíc) '
      'dočtete celou Bibli kolem $date.';
  static const longPressToMark =
      'Podržením kapitoly ji označíte jako přečtenou.';
  static const markReadEarlierShort = 'Označit přečtené';
  static const markReadHint =
      'Četli jste něco dřív mimo aplikaci? Klepněte na knihu a odškrtněte '
      'kapitoly, nebo použijte „Označit přečtené“.';
  static const markReadEarlierIntro =
      'Označte, co jste přečetli dříve mimo aplikaci. Započítá se to do '
      'přečtené Bible i do odznaků, ale ne do kalendáře a série dní.';
  static const byParts = 'Po oddílech';
  static const markPartDone = 'Označit';
  static String chaptersOf(int done, int all) => '$done z $all kapitol';
  static const confirm = 'Potvrdit';
  static const markSingleBooksHint =
      'Jednotlivé knihy a kapitoly označíte klepnutím na knihu v přehledu '
      '„Bible po knihách“.';
  static String markPartConfirm(String name) =>
      'Označit „$name“ jako přečtené?';
  static String chaptersDone(int done, int all) =>
      'Přečteno $done z $all kapitol';
  static const markWholeBook = 'Celá kniha';
  static const unmarkAll = 'Zrušit vše';
  static String unmarkBookConfirm(String name) =>
      'Zrušit záznamy o přečtení celé knihy $name? Smaže to i kapitoly '
      'přečtené v aplikaci.';
  static const tapChapterHint =
      'Klepnutím na kapitolu ji označíte jako přečtenou (nebo označení '
      'zrušíte).';
  static const whatsNew = 'Co je nového';
  static const whatsNewIntro = 'Velká aktualizace aplikace – přehled novinek.';
  static const letsGo = 'Začít';
  static const progress = 'Můj pokrok';
  static const progressHint = 'Kalendář čtení, odznaky, přečtené knihy';
  static const ofBible = 'Bible';
  static const longestStreak = 'nejdelší série';
  static const chaptersReadLabel = 'přečtených kapitol';
  static const daysRead = 'dní se čtením';
  static const readingCalendar = 'Kalendář čtení';
  static String badgesCount(int earned, int all) => 'Odznaky $earned/$all';
  static const bibleByBooks = 'Bible po knihách';
  static const less = 'méně';
  static const more = 'více';
  static const reflection = 'Zamyšlení nad kapitolou';
  static const reflectionHintShort =
      'Sedm kroků s otázkami právě k této kapitole';
  static String reflectionTitle(String book, int chapter) =>
      'Zamyšlení: $book $chapter';
  static const reflectionIntro =
      'Odpovězte na kterékoli otázky – stačí pár slov. Odpovědi se uloží '
      'jako poznámka do Deníku.';
  static const reflectionHint = 'Vaše odpověď…';
  static const reflectionSave = 'Uložit do Deníku';
  static const reflectionSaved = 'Zamyšlení uloženo do Deníku';
  static const reflectionAbout = 'O kapitole';
  static const reflectionNext = 'Další';
  static const reflectionBack = 'Zpět';
  static const reflectionSkip = 'Přeskočit';
  static const reflectionDone = 'Shrnutí';
  static const reflectionSaveShort = 'Uložit';
  static const reflectionPrevious = 'Navazuje na vaši odpověď';
  static const reflectionSummary = 'Vaše zamyšlení';
  static const reflectionEmpty =
      'Zatím jste nic nenapsali. Vraťte se k otázkám – stačí pár slov.';
  static const reflectionAddPrayer = 'Přidat poslední odpověď do modliteb';
  static String reflectionStep(int i, int n) => 'Krok $i z $n';
  static const stepNotice = 'Všímej si';
  static const stepObserve = 'Pozoruj';
  static const stepUnderstand = 'Pochop';
  static const stepGod = 'O Bohu';
  static const stepHuman = 'O člověku';
  static const stepLife = 'Pro můj život';
  static const stepPray = 'Krok a modlitba';
  static const customPlan = 'Vlastní plán';
  static const customPlanHint = 'Vyberte knihy a za kolik dní je přečtete';
  static const customPlanIntro =
      'Vyberte knihy, které chcete přečíst, a za kolik dní. Kapitoly se '
      'rovnoměrně rozdělí do jednotlivých dní.';
  static const quickChoice = 'Rychlý výběr';
  static const clearSelection = 'Zrušit výběr';
  static const planLength = 'Délka plánu';
  static String daysCount(int n) => n == 1
      ? '1 den'
      : n < 5
      ? '$n dny'
      : '$n dní';
  static const customPlanPick = 'Vyberte alespoň jednu knihu.';
  static String customPlanSummary(int books, int chapters, String perDay) =>
      'Knih: $books · kapitol: $chapters · asi $perDay kapitoly denně';
  static const presetNt = 'Nový zákon';
  static const presetGospels = 'Evangelia';
  static const presetPaul = 'Pavlovy listy';
  static const presetOt = 'Starý zákon';
  static const presetTorah = 'Pět knih Mojžíšových';
  static const presetWisdom = 'Mudroslovné knihy';
  static const presetProphets = 'Proroci';
  static const presetBible = 'Celá Bible';
  static const topics = 'Biblická témata';
  static const topicsHint = 'Milost, modlitba, odpuštění, církev…';
  static String topicsCount(int n) => '$n témat – shrnutí a klíčová místa';
  static const topicsIntro =
      'Co Bible říká o hlavních tématech víry a života: krátké shrnutí '
      'a klíčová místa, na která můžete klepnout a číst dál.';
  static const findTopic = 'Hledat téma';
  static const keyPassages = 'Klíčová místa';
  static const memory = 'Verše nazpaměť';
  static String _plural(int n, String one, String few, String many) =>
      n == 1 ? one : (n >= 2 && n <= 4 ? few : many);
  static const quiz = 'Biblický kvíz';
  static const quizHint = 'Otestujte se – po každé otázce verš';
  static const quizIntro =
      'Deset otázek z celé Bible. Po každé odpovědi uvidíte místo, kde se '
      'odpověď najde – kvíz je tak i rychlé opakování.';
  static const quizAll = 'Celá Bible';
  static const forToday = 'Na dnešek';
  static String planBehind(int n) =>
      'Pozadu o $n ${_plural(n, 'den', 'dny', 'dní')} – nevadí, pokračujte';
  static String planAhead(int n) =>
      'Napřed o $n ${_plural(n, 'den', 'dny', 'dní')}';
  static const planOnTrack = 'Přesně podle plánu';
  static const quizOfDay = 'Otázka dne';
  static const journalSearch = 'Hledat v deníku';
  static const journalSearchHint = 'Kniha, odkaz nebo text poznámky…';
  static const journalNoMatch = 'Nic neodpovídá hledání.';
  static const journalAllColors = 'Vše';
  static const connections = 'Souvislosti v Bibli';
  static const connectionsHint =
      'Velký příběh, červené nitě a mapa odkazů – jak spolu části Bible '
      'souvisejí';
  static const connectionsWhole = 'Bible jako celek';
  static const tabStory = 'Příběh';
  static const tabTree = 'Strom';
  static const treeHint =
      'Přibližujte prsty: z celé Bible se větví zákony, období, knihy '
      'a nakonec postavy a události. Klepněte na uzel.';
  static const treeWhole = 'Celá Bible';
  static const treeEraDetail = 'Podrobnosti';
  static const treeRead = 'Číst';
  static const treePerson = 'Medailon';
  static const tabThreads = 'Nitě';
  static const tabArcs = 'Odkazy';
  static const storyIntro =
      'Knihy Bible nejsou seřazené podle času. Tady je vidíte v pořadí '
      'příběhu – od stvoření po nové stvoření. Klepněte na období.';
  static const storyKey = 'Klíčové kapitoly';
  static const storyBooks = 'Knihy o tomto období';
  static const storyNoBooks =
      'Z této doby nemáme žádnou knihu Bible – příběh pokračuje '
      'v evangeliích.';
  static const threadsIntro =
      'Motivy, které se táhnou celou Biblí. Každá nit vede od prvního '
      'náznaku ke splnění – a u každého místa je vysvětleno, proč na '
      'předchozí navazuje.';
  static String threadSpan(int stations, int books) =>
      '$stations ${_plural(stations, 'zastavení', 'zastavení', 'zastavení')}'
      ' · $books ${_plural(books, 'kniha', 'knihy', 'knih')}';
  static const arcsIntro =
      'Každý oblouk spojuje dvě kapitoly, které na sebe odkazují nebo se '
      'navzájem vysvětlují. Dole jsou všechny kapitoly Bible od Genesis po '
      'Zjevení. Klepněte do grafu nebo vyberte knihu.';
  static const arcsTop = 'Nejsilněji propojené knihy';
  static String arcsPartners(String book) => '$book se nejvíc pojí s';
  static const arcsExamples = 'Příklady spojení';
  static const arcsCredit =
      'Křížové odkazy: OpenBible.info (CC BY 4.0), shrnuto po kapitolách.';
  static const arcsChooseBook = 'Vybrat knihu';
  static const bookConnections = 'Souvislosti knihy';
  static const oldTestamentShort = 'Starý zákon';
  static const newTestamentShort = 'Nový zákon';
  static const churchYear = 'Církevní rok';
  static const churchYearHint = 'Doby a svátky s čteními';
  static String churchYearSpan(int a) => 'Církevní rok $a/${(a + 1) % 100}';
  static const churchSeasonReadings = 'Čtení pro tuto dobu';
  static const churchUpcoming = 'Další svátky';
  static const churchSeasonPlan = 'Plán čtení pro tuto dobu';
  static String planStarted(String name) => 'Plán „$name“ je na stránce Dnes';
  static const churchToday = 'Dnes';
  static const churchTomorrow = 'Zítra';
  static String churchInDays(int n) =>
      'za $n ${_plural(n, 'den', 'dny', 'dní')}';
  static String churchDayOf(int day, int total) => '$day. den z $total';
  static const churchYearAbout =
      'Církevní rok začíná první nedělí adventní. Data pohyblivých svátků '
      'se odvíjejí od Velikonoc. Jednotlivé církve slaví některé dny '
      'odlišně – kalendář tu slouží jako průvodce čtením.';
  static const quizMore = 'Další otázky';
  static String memoryDue(int n) =>
      '$n ${_plural(n, 'verš', 'verše', 'veršů')} k opakování';
  static String prayersDue(int n) =>
      '$n ${_plural(n, 'prosba', 'prosby', 'proseb')} v seznamu';
  static const quizChoose = 'Vyberte oblast';
  static String quizQuestions(int n) =>
      '$n ${_plural(n, 'otázka', 'otázky', 'otázek')}';
  static String quizBest(int score, int total) => 'nejlépe $score/$total';
  static String quizProgress(int i, int n) => 'Otázka $i z $n';
  static const quizNext = 'Další otázka';
  static const quizShowResult = 'Výsledek';
  static const quizCorrect = 'Správně!';
  static String quizWrong(String correct) => 'Správně je: $correct';
  static const quizAgain = 'Hrát znovu';
  static const quizDone = 'Hotovo';
  static const quizNewBest = 'Nový osobní rekord!';
  static const quizReview = 'K zopakování';
  static String quizResultTitle(int score, int total) =>
      switch (score / total) {
        >= 0.9 => 'Výborně!',
        >= 0.7 => 'Velmi dobře!',
        >= 0.5 => 'Dobrá práce',
        _ => 'Pokračujte ve čtení',
      };
  static String quizResultBody(int score, int total) =>
      'Správně $score z $total. ${score == total ? 'Bez jediné chyby!' : 'Odpovědi najdete níže i s místem v Bibli.'}';
  static const prayers = 'Modlitby';
  static const prayerList = 'Modlitební seznam';
  static const prayerIntro =
      'Zapisujte si, za co se modlíte. Až přijde odpověď, označte modlitbu '
      'jako vyslyšenou – časem uvidíte, kolikrát Bůh jednal.';
  static const prayerHint = 'Za co se modlíte a co Bůh vyslyšel';
  static String prayerSummary(int active, int answered) =>
      '$active ${_plural(active, 'modlitba', 'modlitby', 'modliteb')} · '
      '$answered ${_plural(answered, 'vyslyšená', 'vyslyšené', 'vyslyšených')}';
  static const prayerAdd = 'Nová modlitba';
  static const prayerEdit = 'Upravit modlitbu';
  static const prayerTextHint = 'Za co se chcete modlit?';
  static const prayerTime = 'Čas modlitby';
  static const prayerActive = 'Modlím se';
  static const prayerAnsweredSection = 'Vyslyšené';
  static const prayerAnswered = 'Vyslyšeno';
  static const prayerAnswerHint = 'Jak Bůh odpověděl? (nepovinné)';
  static const prayerPrayed = 'Pomodleno';
  static String prayerPrayedTimes(int n) => 'pomodleno $n×';
  static String prayerAddedOn(String date) => 'přidáno $date';
  static String prayerAnsweredOn(String date) => 'vyslyšeno $date';
  static const prayerSave = 'Uložit';
  static const prayerDelete = 'Smazat';
  static const prayerSuggestions = 'Za co se modlit';
  static const prayerIdeas = [
    'Za rodinu',
    'Za přátele',
    'Za zdraví',
    'Za práci a školu',
    'Za církev',
    'Za ty, kdo Boha neznají',
    'Za moudrost v rozhodování',
    'Poděkování za…',
  ];
  static String prayerStep(int i, int n) => '$i / $n';
  static const prayerNext = 'Pomodleno, další';
  static const prayerFinish = 'Amen';
  static const prayerDoneTitle = 'Amen';
  static const prayerDoneBody = 'Svěřili jste Bohu všechno, co máte na srdci.';
  static const prayerEmptyActive =
      'Žádné modlitby. Přidejte první prosbu nebo poděkování.';
  static const memoryShort = 'Učit se';
  static const memoryHint = 'Naučte se verše krok za krokem';
  static const memoryIntro =
      'Verš se při procvičování krok za krokem skrývá – nejdřív pár slov, '
      'pak polovina, pak zbudou jen první písmena. Verše přidáte v Bibli: '
      'klepněte na verš a zvolte „Učit se“.';
  static const memoryEmpty =
      'Zatím se neučíte žádný verš. Otevřete Bibli, klepněte na verš '
      'a zvolte „Učit se“.';
  static const openBible = 'Otevřít Bibli';
  static String memoryProgress(int learned, int all) =>
      'Naučeno $learned z $all';
  static const memorySwipeHint = 'Verš odeberete přejetím doleva.';
  static String memoryStep(int step, int all) => 'Krok $step z $all';
  static const memoryStepHint = [
    'celý text',
    'skrytá některá slova',
    'skrytá polovina',
    'jen první písmena',
    'zpaměti',
  ];
  static const memoryTapHint = 'Klepnutím na skryté slovo ho odkryjete.';
  static const memoryShow = 'Ukázat celý text';
  static const memoryHide = 'Znovu skrýt';
  static const memoryEasier = 'Ještě ne';
  static const memoryKnow = 'Umím';
  static const memorySuggested = 'Doporučené verše';
  static String memoryReviewAll(int n) => 'Opakovat vše ($n)';
  static const memoryReview = 'Opakování';
  static const memoryRecall = 'Zkuste si verš říct zpaměti.';
  static const memoryReveal = 'Ukázat text';
  static String memoryReviewDone(int known, int all) =>
      'Hotovo! Umíte $known z $all.';
  static const memoryLearned = 'Výborně! Verš je naučený.';
  static const memoryAdded = 'Přidáno k učení nazpaměť';
  static const memoryAlready = 'Tento verš už se učíte';
  static const open = 'Otevřít';
  static const byStory = 'Podle příběhu';
  static const alphabetical = 'Abecedně';
  static const eraPatriarchs = 'Praotcové (Genesis)';
  static const eraExodus = 'Mojžíš a cesta pouští';
  static const eraJudges = 'Dobytí země a soudci';
  static const eraKingdom = 'Království';
  static const eraExile = 'Exil a návrat';
  static const eraProphets = 'Proroci a mudrci';
  static const eraGospels = 'Ježíšův život';
  static const eraChurch = 'První církev';
  static const guide = 'Průvodce aplikací';
  static const guideHint = 'Co kde najdete a jak se aplikace ovládá';
  static const guideIntro =
      'Aplikace má dole pět záložek. Tady je stručně, co v každé najdete.';
  static const guideOpen = 'Otevřít';
  static const recentlyReadShort = 'Nedávno čtené';
  static const studyTeaserHint =
      'Medailony postav, aplikační poznámky, tabulky, harmonie evangelií, '
      'časová osa a mapy – vše najdete v záložce Studium dole.';
  static const studyHubIntro =
      'Všechny studijní materiály na jednom místě. Hledat můžete postavy, '
      'situace, knihy, tabulky i poznámky.';
  static const studySearchHint = 'Hledat: David, strach, svátky, Marek…';
  static const studyForLife = 'Pro život';
  static const historicalBackground = 'Historické pozadí';
  static const christConnection = 'Souvislost s Ježíšem a Novým zákonem';
  static const howToRead = 'Jak knihu číst';
  static const readerTabs = 'Čtecí karty';
  static const readerTabsHint =
      'Otevřete si víc míst v Bibli najednou – třeba Jana a Matouše – '
      'a přepínejte mezi nimi jedním klepnutím v liště nahoře. Každá '
      'karta si pamatuje, kde jste skončili, i svůj překlad.';
  static const tabOtherPlace = 'Jiné místo v Bibli';
  static const tabOtherPlaceHint = 'Vyberete knihu a kapitolu';
  static const tabOtherTranslation = 'Stejné místo v jiném překladu';
  static const tabOtherTranslationHint =
      'Přepínáním karet pak porovnáte překlady verš po verši';
  static const moreTranslations = 'Stáhnout další překlady';
  static String tabTranslation(String name) => 'Překlad karty: $name';
  static const newTab = 'Nová karta';
  static const closeTab = 'Zavřít kartu';
  static const fromStudy = 'Ve studijních materiálech';
  static const studyPeopleStories = 'Lidé a příběhy';
  static const studyBooks = 'Knihy Bible';
  static const studyMore = 'Mapy, původní text a čtení';
  static const studyNoResults = 'Nic nenalezeno. Zkuste jiné slovo.';
  static const situationsCardHint =
      'Co právě prožíváte? Vyberte situaci a přečtěte si verše, které k ní '
      'mluví.';
  static String allSituationsCount(int n) => 'Všech $n situací';
  static String peopleCount(int n) => '$n medailonů – silné i slabé stránky';
  static String notesCount(int n) => '$n poznámek: výklad a použití v životě';
  static String tablesCount(int n) => '$n přehledů: králové, svátky, zázraky…';
  static const introsHint = 'Přehled, údaje, osnova, témata, pozadí';
  static const profile = 'Medailon';
  static const applicationNotes = 'Aplikační poznámky';
  static const applicationNote = 'Aplikační poznámka';
  static const applicationNotesHint = 'Výklad a použití v životě';
  static const applicationNotesIntro =
      'Poznámky ke známým oddílům. Každá má tři části: výklad textu, '
      'spojovací most k dnešku a konkrétní aplikaci.';
  static const noteExplanation = 'Výklad';
  static const noteExplanationHint = 'co text znamená ve svých souvislostech';
  static const noteBridge = 'Spojovací most';
  static const noteBridgeHint = 'obecná pravda platná i dnes';
  static const noteApplication = 'Aplikace';
  static const noteApplicationHint = 'jak ji uplatnit ve vlastním životě';
  static const tables = 'Tabulky a přehledy';
  static const tablesHint = 'Králové, svátky, podobenství, zázraky…';
  static const harmony = 'Harmonie evangelií';
  static const harmonyHint = 'Ježíšův život v pořadí';
  static const harmonyIntro =
      'Události Ježíšova života v přibližném časovém pořadí a místa, kde '
      'o nich píší jednotlivá evangelia. Evangelisté často řadí látku '
      'tematicky, proto je pořadí místy jen pravděpodobné.';
  static const people = 'Biblické postavy';
  static const peopleHint = 'Medailony postav: silné i slabé stránky';
  static const peopleIntro =
      'Medailony hlavních postav Bible – jejich silné stránky i selhání '
      'a co se z jejich života můžeme naučit.';
  static const findPerson = 'Hledat postavu';
  static const personWhere = 'Kde žil(a)';
  static const personOccupation = 'Povolání';
  static const personRelatives = 'Příbuzní';
  static const personRelated = 'Související postavy';
  static const personBooks = 'Vystupuje v knihách';
  static const strengths = 'Silné stránky a úspěchy';
  static const weaknesses = 'Slabiny a selhání';
  static const lessons = 'Ponaučení';
  static const keyVerse = 'Klíčový verš';
  static const personStory = 'Příběh v Bibli';
  static const readInBible = 'Číst v Bibli';
  static const profiles = 'Medailony postav';
  static const bookPlaces = 'Místa v knize';
  static const overview = 'Přehled';
  static const basicFacts = 'Základní údaje';
  static const purpose = 'Účel';
  static const recipients = 'Adresáti';
  static const setting = 'Prostředí';
  static const keyPeople = 'Hlavní postavy';
  static const keyPlaces = 'Důležitá místa';
  static const features = 'Zvláštnosti';
  static const bookTimeline = 'Časová osa';
  static const mainThemes = 'Hlavní témata';
  static const showBookMap = 'Místa knihy na mapě';
  static const situationsHint = 'Strach, radost, rozhodování…';
  static const situationsIntro =
      'Vyberte, co právě prožíváte. Verše se zobrazí ve zvoleném překladu; '
      'klepnutím otevřete celý text v souvislostech.';
  static const situationsToday = 'Verše pro tuto chvíli';
  static const allSituations = 'Všechny situace';
  static const all = 'Vše';
  static const timeline = 'Časová osa';
  static const worldHistory = 'Ve světě';
  static const timelineHint = 'Bible a světové dějiny';
  static const timelineIntro =
      'Hlavní události biblických dějin. Starší období mají jen přibližnou '
      'nebo tradiční dataci – odborníci se v nich liší.';
  static const datingDocumented = 'Doloženo i mimo Bibli';
  static const datingApproximate = 'Přibližné datum';
  static const datingTraditional = 'Tradiční datace';
  static const readingPlans = 'Plány čtení';
  static const readingPlansHint = 'Žalmy, evangelia, celá Bible';
  static const exploreStudy = 'Původní text';
  static const exploreStudyHint = 'Hebrejština a řečtina';

  // Mapy
  static const mapsTitle = 'Biblické mapy';
  static const thematicMaps = 'Tematické mapy';
  static const allPlaces = 'Všechna místa';
  static const findPlace = 'Najít místo…';
  static String mentions(int n) => switch (n) {
    1 => '1 zmínka',
    >= 2 && <= 4 => '$n zmínky',
    _ => '$n zmínek',
  };
  static const mapCredits =
      'Místa: OpenBible.info (CC BY 4.0) · Mapa: Natural Earth';
  static const chapterPlaces = 'Místa v kapitole';
  static const fitMap = 'Zobrazit vše';

  // Knihy
  static const findBook = 'Najít knihu…';
  static String chaptersRead(int read, int total) => '$read z $total přečteno';

  // Hledání – rozšíření
  static const recentSearches = 'Nedávná hledání';
  static const clear = 'Vymazat';
  static const goToReference = 'Přejít na';
  static const loadMore = 'Načíst další';
  static const allBooks = 'Všechny knihy';
  static String inBooks(int results, int books) =>
      '${_results(results)} v ${books == 1 ? '1 knize' : '$books knihách'}';

  // Překlady
  static const library = 'Překlady';
  static const installed = 'V zařízení';
  static const availableToDownload = 'Ke stažení';
  static const unavailable = 'Nedostupné';
  static const download = 'Stáhnout';
  static const remove = 'Odstranit';
  static const bundled = 'Součást aplikace';
  static String removeTranslationQuestion(String name) =>
      'Odstranit překlad $name ze zařízení?';
  static const importFile = 'Importovat vlastní soubor';
  static const importHint =
      'OSIS, Zefania XML nebo JSON – např. překlad, který máte legálně '
      'z jiného zdroje.';
  static const importName = 'Název překladu';
  static const importAbbreviation = 'Zkratka';
  static String imported(int n) => 'Importováno $n veršů';
  static const libraryInfo =
      'Překlady se stahují přímo od CrossWire Bible Society, která má od '
      'vydavatelů povolení k šíření. Jsou jen pro vaši osobní potřebu.';
  static const manageTranslations = 'Spravovat a stahovat překlady';
  static const downloadFailed = 'Stažení se nepodařilo';

  /// „Jan 3“
  static String chapterTitle(String bookName, int chapter) =>
      '$bookName $chapter';

  /// Česká plurálová pravidla: 1 verš, 2–4 verše, 5+ veršů.
  static String verseCount(int n) => switch (n) {
    1 => '1 verš',
    >= 2 && <= 4 => '$n verše',
    _ => '$n veršů',
  };
}
