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
  static const searchHint = 'Hledat slovo nebo frázi…';
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
