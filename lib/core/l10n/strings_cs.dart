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
  static const cancelSelection = 'Zrušit výběr';
  static const notePlaceholder = 'Vaše myšlenky k tomuto místu…';
  static const save = 'Uložit';
  static const delete = 'Smazat';
  static const deleted = 'Smazáno';
  static const undo = 'Zpět';
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
  static const timeline = 'Časová osa';
  static const timelineHint = 'Od Abrahama po Zjevení';
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
