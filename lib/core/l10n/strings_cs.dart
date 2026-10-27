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
