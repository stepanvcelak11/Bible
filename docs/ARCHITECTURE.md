# Architektura

## Principy

1. **Local-first, 100% offline.** Žádný síťový kód v aplikaci. Texty Bible
   jsou předpřipravená SQLite databáze v assets; uživatelská data v druhé
   SQLite databázi.
2. **Dvě databáze.** `bible.db` (obsah, jen pro čtení, při aktualizaci se
   vymění celý soubor) a `user.db` (zvýraznění, záložky, poznámky; migruje
   se, nikdy nemaže). Aktualizace textů tak nemůže poškodit data uživatele.
3. **Pozice nezávislá na překladu.** Místo čtení i uživatelská data jsou
   adresována `VerseRef(bookId, chapter, verse)` bez `translation_id`.
   Přepnutí překladu proto okamžitě zachová místo a zvýraznění se ukazují ve
   všech překladech.
4. **60 fps.** Všechny dotazy běží v background isolate (Drift
   `createInBackground`), kapitola je jeden indexovaný rozsahový dotaz,
   statická data (překlady, knihy) se načtou jednou při startu a dál se
   čtou synchronně.

## Struktura projektu

```
lib/
├── main.dart                     # start: bootstrap → ProviderScope → BibleApp
├── bootstrap.dart                # instalace DB z assets, otevření DB, overrides
├── app.dart                      # MaterialApp (čeština), chybová obrazovka
├── core/
│   ├── l10n/strings_cs.dart      # VŠECHNY texty UI (česky)
│   ├── providers.dart            # kořenové DI providery
│   └── utils/fts_query.dart      # bezpečný převod vstupu na dotaz FTS5
├── domain/                       # čistý Dart, bez Flutteru a Driftu
│   ├── entities/                 # Translation, Book, VerseRef, Verse, Highlight…
│   ├── repositories/             # rozhraní BibleRepository, UserDataRepository
│   └── services/chapter_navigator.dart
├── data/
│   ├── bible/
│   │   ├── bible_schema.drift    # schéma obsahu (sdílené s Python skriptem)
│   │   ├── bible_database.dart   # Drift DB, read-only
│   │   └── bible_db_installer.dart
│   ├── user/user_database.dart   # Drift DB: highlights, bookmarks, notes
│   ├── preferences/app_preferences.dart
│   └── repositories/             # implementace rozhraní z domain/
└── features/
    ├── translations/             # výběr a porovnání překladů
    │   ├── application/translation_controller.dart
    │   └── presentation/translation_selector_sheet.dart
    └── reader/
        ├── application/          # pozice čtení, obsah kapitoly
        └── presentation/         # čtečka
tool/
├── build_bible_db.py             # sestavení assets/db/bible.db
└── translations.json             # seznam překladů a jejich zdrojů
data/sources/                     # zdrojové texty (mimo git)
assets/db/                        # vygenerovaná DB + manifest (mimo git)
```

Další funkce přibudou jako `features/<název>/{application,presentation}`
(`navigation`, `search`, `journal`, `settings`).

## Obsahová databáze (`bible.db`)

Schéma: [`lib/data/bible/bible_schema.drift`](../lib/data/bible/bible_schema.drift)
– jediný zdroj pravdy pro Drift i Python skript.

| Tabulka | Klíč | Obsah |
|---|---|---|
| `meta` | `key` | `content_version`, `schema_version`, `built_at` |
| `translations` | `id` (`BKR`) | název, zkratka, rok, licence, pořadí |
| `books` | `id` 1–66 | OSIS kód, český název a zkratka, zákon |
| `chapters` | (`translation_id`, `book_id`, `chapter`) | počet veršů; počty kapitol **podle překladu** |
| `verses` | `id` (rowid) + unikátní (`translation_id`, `book_id`, `chapter`, `verse`) | text verše |
| `verses_fts` | FTS5, external content nad `verses` | fulltext, `unicode61 remove_diacritics 2` |

- Verše se vkládají v kanonickém pořadí → verše kapitoly leží fyzicky vedle
  sebe; načtení kapitoly = `SEARCH verses USING INDEX verses_by_ref`.
- FTS5 s external content neukládá text podruhé (úspora ~5 MB/překlad).
- `remove_diacritics 2` sjednotí háčky a čárky v textu i dotazu
  („laska“ → „láska“, „zivot“ → „život“). Každé slovo dotazu se hledá jako
  předpona kvůli českému skloňování.
- Číslování se mezi překlady liší (BKR: Jóel 3 kap., ČSP: 4). Navigace proto
  bere počty kapitol z `chapters` pro aktivní překlad a porovnání zarovnává
  verše podle čísla (chybějící strana zůstane prázdná).

### Instalace a aktualizace

`tool/build_bible_db.py` zapíše vedle DB `bible_manifest.json` s
`content_version` (hash zdrojů + schématu). `BibleDbInstaller` při startu
porovná verzi s nainstalovanou; při změně atomicky (`.tmp` + `rename`)
zkopíruje novou DB do adresáře aplikace. Běžný start čte jen malý JSON.

## Uživatelská databáze (`user.db`)

| Tabulka | Sloupce | Poznámka |
|---|---|---|
| `highlights` | `book_id, chapter, verse, color, created_at` | unikátní verš; barva uložená jménem enumu |
| `bookmarks` | `book_id, chapter, verse, translation_id?, label?, created_at` | unikátní verš |
| `notes` | `book_id, chapter, verse_start, verse_end, body, created_at, updated_at` | rozsah veršů v kapitole |

Všechny tabulky mají index `(book_id, chapter)` – čtečka sleduje
(`watch…InChapter`) jen data aktuální kapitoly. Režim WAL.

## Stav (Riverpod)

| Provider | Typ | Účel |
|---|---|---|
| `translationsProvider`, `booksProvider` | `Provider` (override) | přednačtená statická data |
| `translationControllerProvider` | `Notifier<TranslationSelection>` | hlavní + porovnávaný překlad, ukládá se |
| `readingPositionProvider` | `Notifier<VerseRef>` | místo čtení, ukládá se |
| `chapterCountsProvider(id)` | `FutureProvider.family` | počty kapitol podle překladu |
| `chapterContentProvider` | `FutureProvider.autoDispose` | `SingleChapter` / `ParallelChapter` |

`chapterContentProvider` sleduje jen (kniha, kapitola) – posun mezi verši
nevyvolá nové načtení. Při změně Riverpod ponechá předchozí data, takže
čtečka neproblikne.
