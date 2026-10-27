# Bible – soukromá offline čtečka

Minimalistická čtečka Bible v češtině pro osobní použití. Žádné reklamy, účty
ani síť – vše (texty překladů i poznámky) je uloženo lokálně v SQLite.

- **Flutter** + **Riverpod 3** (bez generování kódu)
- **Drift** nad `sqlite3` (přibalená SQLite s FTS5 na Androidu i iOS)
- Clean Architecture: `domain` ← `data` ← `features`

Podrobnosti: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) · plán vývoje:
[docs/ROADMAP.md](docs/ROADMAP.md)

## Rychlý start

```bash
# 1) Sestavit offline databázi překladů (stáhne zdroje, ~4 s)
python3 tool/build_bible_db.py --fetch

# 2) Spustit aplikaci
flutter pub get
flutter run
```

Krok 1 vytvoří `assets/db/bible.db` (~14 MB, BKR + ČSP) a
`assets/db/bible_manifest.json`. Oba soubory i stažené zdroje v
`data/sources/` jsou v `.gitignore` – některé překlady podléhají autorskému
právu. Bez kroku 1 aplikace zobrazí hlášku „Chybí data Bible“.

## Překlady

| Kód | Překlad | Zdroj | Licence |
|-----|---------|-------|---------|
| BKR | Bible kralická (1613) | stahuje se automaticky | volné dílo |
| ČSP | Český studijní překlad | stahuje se automaticky | © NF Křesťanská dobročinnost, nekomerční/osobní použití |
| ČEP, B21, SNC | – | vlastní licencovaný soubor | © vydavatelé |

ČEP, B21 a SNC nejsou volně ke stažení. Máte-li vlastní soubor (Zefania XML
nebo JSON), vložte ho do `data/sources/`, v `tool/translations.json` nastavte
`"enabled": true` a sestavte databázi znovu. Formáty popisuje
[data/sources/README.md](data/sources/README.md).

## Vývoj

```bash
dart run build_runner build   # po změně schémat Driftu
flutter analyze
flutter test
```
