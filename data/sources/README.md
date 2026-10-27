# Zdrojové texty překladů

Sem patří zdrojové soubory, ze kterých `tool/build_bible_db.py` sestaví
`assets/db/bible.db`. Obsah složky (kromě tohoto souboru) se do gitu
neukládá.

Každý překlad je popsán v `tool/translations.json` (`id`, `name`,
`abbreviation`, `format`, `source`, volitelně `url`, `year`, `license`).

## Podporované formáty

### `scrollmapper` (JSON)
Formát z [scrollmapper/bible_databases](https://github.com/scrollmapper/bible_databases):

```json
{"translation": "…", "books": [
  {"name": "Genesis", "chapters": [
    {"chapter": 1, "verses": [{"verse": 1, "text": "Na počátku…"}]}
  ]}
]}
```

### `zefania` (XML)
Rozšířený formát mnoha českých Biblí:

```xml
<XMLBIBLE>
  <BIBLEBOOK bnumber="1">
    <CHAPTER cnumber="1">
      <VERS vnumber="1">Na počátku…</VERS>
```

Poznámky `<NOTE>` se vynechají, text ostatních vnořených značek se zachová.

### `flat` (JSON)
Nejjednodušší vlastní formát – kniha jako číslo 1–66 nebo OSIS kód:

```json
{"verses": [
  {"book": "Gen", "chapter": 1, "verse": 1, "text": "Na počátku…"},
  {"book": 43, "chapter": 3, "verse": 16, "text": "…"}
]}
```
