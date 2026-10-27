#!/usr/bin/env python3
"""
Sestaví offline obsahovou databázi Bible (assets/db/bible.db).

Postup:
  1. (volitelně --fetch) stáhne zdrojové soubory překladů z URL uvedených
     v tool/translations.json do data/sources/,
  2. vytvoří prázdnou SQLite databázi podle lib/data/bible/bible_schema.drift
     (stejné schéma, ze kterého Drift generuje Dart kód),
  3. naplní tabulky books / translations / chapters / verses,
  4. postaví fulltextový index FTS5, zoptimalizuje a zkomprimuje databázi,
  5. zapíše assets/db/bible_manifest.json s verzí obsahu – aplikace podle ní
     pozná, že má při startu nahradit starou kopii databáze novou.

Použití:
  python3 tool/build_bible_db.py --fetch      # stáhne chybějící zdroje a sestaví
  python3 tool/build_bible_db.py              # sestaví z již stažených zdrojů
  python3 tool/build_bible_db.py --only BKR   # jen vybrané překlady

Podporované formáty zdrojů (klíč "format" v translations.json):
  scrollmapper – JSON z github.com/scrollmapper/bible_databases
  zefania      – Zefania XML (<BIBLEBOOK bnumber><CHAPTER cnumber><VERS vnumber>)
  flat         – jednoduchý JSON: {"verses": [{"book": 1|"Gen", "chapter": 1,
                 "verse": 1, "text": "…"}, …]}
  osis         – OSIS XML (moduly CrossWire/SWORD); navíc nadpisy oddílů,
                 odstavce, poezie a poznámky překladatelů.

Skript používá jen standardní knihovnu Pythonu 3.9+.
"""

from __future__ import annotations

import argparse
import dataclasses
import html
import datetime as dt
import hashlib
import json
import re
import sqlite3
import sys
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Iterable, Iterator

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_FILE = ROOT / "lib" / "data" / "bible" / "bible_schema.drift"
CONFIG_FILE = ROOT / "tool" / "translations.json"
SOURCES_DIR = ROOT / "data" / "sources"
OUTPUT_DB = ROOT / "assets" / "db" / "bible.db"
OUTPUT_MANIFEST = ROOT / "assets" / "db" / "bible_manifest.json"
OUTPUT_CATALOG = ROOT / "assets" / "db" / "catalog.json"

# Musí odpovídat `schemaVersion` v lib/data/bible/bible_database.dart.
SCHEMA_VERSION = 2

# --------------------------------------------------------------------------
# Kánon: (OSIS, český název, česká zkratka dle ČEP, zákon, počet kapitol)
# Pořadí v seznamu = id knihy (1–66). Počet kapitol (dle ČEP) slouží jen ke
# kontrole úplnosti – skutečné počty podle překladu jsou v tabulce chapters.
# --------------------------------------------------------------------------
BOOKS: list[tuple[str, str, str, str, int]] = [
    ("Gen", "Genesis", "Gn", "OT", 50),
    ("Exod", "Exodus", "Ex", "OT", 40),
    ("Lev", "Leviticus", "Lv", "OT", 27),
    ("Num", "Numeri", "Nu", "OT", 36),
    ("Deut", "Deuteronomium", "Dt", "OT", 34),
    ("Josh", "Jozue", "Joz", "OT", 24),
    ("Judg", "Soudců", "Sd", "OT", 21),
    ("Ruth", "Rút", "Rt", "OT", 4),
    ("1Sam", "1. Samuelova", "1S", "OT", 31),
    ("2Sam", "2. Samuelova", "2S", "OT", 24),
    ("1Kgs", "1. Královská", "1Kr", "OT", 22),
    ("2Kgs", "2. Královská", "2Kr", "OT", 25),
    ("1Chr", "1. Paralipomenon", "1Pa", "OT", 29),
    ("2Chr", "2. Paralipomenon", "2Pa", "OT", 36),
    ("Ezra", "Ezdráš", "Ezd", "OT", 10),
    ("Neh", "Nehemjáš", "Neh", "OT", 13),
    ("Esth", "Ester", "Est", "OT", 10),
    ("Job", "Jób", "Jb", "OT", 42),
    ("Ps", "Žalmy", "Ž", "OT", 150),
    ("Prov", "Přísloví", "Př", "OT", 31),
    ("Eccl", "Kazatel", "Kaz", "OT", 12),
    ("Song", "Píseň písní", "Pís", "OT", 8),
    ("Isa", "Izajáš", "Iz", "OT", 66),
    ("Jer", "Jeremjáš", "Jr", "OT", 52),
    ("Lam", "Pláč", "Pl", "OT", 5),
    ("Ezek", "Ezechiel", "Ez", "OT", 48),
    ("Dan", "Daniel", "Da", "OT", 12),
    ("Hos", "Ozeáš", "Oz", "OT", 14),
    ("Joel", "Jóel", "Jl", "OT", 4),
    ("Amos", "Ámos", "Am", "OT", 9),
    ("Obad", "Abdijáš", "Abd", "OT", 1),
    ("Jonah", "Jonáš", "Jon", "OT", 4),
    ("Mic", "Micheáš", "Mi", "OT", 7),
    ("Nah", "Nahum", "Na", "OT", 3),
    ("Hab", "Abakuk", "Abk", "OT", 3),
    ("Zeph", "Sofonjáš", "Sf", "OT", 3),
    ("Hag", "Ageus", "Ag", "OT", 2),
    ("Zech", "Zacharjáš", "Za", "OT", 14),
    ("Mal", "Malachiáš", "Mal", "OT", 3),
    ("Matt", "Matouš", "Mt", "NT", 28),
    ("Mark", "Marek", "Mk", "NT", 16),
    ("Luke", "Lukáš", "L", "NT", 24),
    ("John", "Jan", "J", "NT", 21),
    ("Acts", "Skutky apoštolů", "Sk", "NT", 28),
    ("Rom", "Římanům", "Ř", "NT", 16),
    ("1Cor", "1. Korintským", "1K", "NT", 16),
    ("2Cor", "2. Korintským", "2K", "NT", 13),
    ("Gal", "Galatským", "Ga", "NT", 6),
    ("Eph", "Efezským", "Ef", "NT", 6),
    ("Phil", "Filipským", "Fp", "NT", 4),
    ("Col", "Koloským", "Ko", "NT", 4),
    ("1Thess", "1. Tesalonickým", "1Te", "NT", 5),
    ("2Thess", "2. Tesalonickým", "2Te", "NT", 3),
    ("1Tim", "1. Timoteovi", "1Tm", "NT", 6),
    ("2Tim", "2. Timoteovi", "2Tm", "NT", 4),
    ("Titus", "Titovi", "Tt", "NT", 3),
    ("Phlm", "Filemonovi", "Fm", "NT", 1),
    ("Heb", "Židům", "Žd", "NT", 13),
    ("Jas", "Jakubův", "Jk", "NT", 5),
    ("1Pet", "1. Petrův", "1Pt", "NT", 5),
    ("2Pet", "2. Petrův", "2Pt", "NT", 3),
    ("1John", "1. Janův", "1J", "NT", 5),
    ("2John", "2. Janův", "2J", "NT", 1),
    ("3John", "3. Janův", "3J", "NT", 1),
    ("Jude", "Judův", "Ju", "NT", 1),
    ("Rev", "Zjevení Janovo", "Zj", "NT", 22),
]

OSIS_TO_ID = {osis.lower(): i + 1 for i, (osis, *_rest) in enumerate(BOOKS)}

# Anglické názvy knih, jak je používá scrollmapper (a mnoho dalších zdrojů).
_EN_NAMES = [
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua",
    "Judges", "Ruth", "I Samuel", "II Samuel", "I Kings", "II Kings",
    "I Chronicles", "II Chronicles", "Ezra", "Nehemiah", "Esther", "Job",
    "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah",
    "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
    "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai",
    "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts",
    "Romans", "I Corinthians", "II Corinthians", "Galatians", "Ephesians",
    "Philippians", "Colossians", "I Thessalonians", "II Thessalonians",
    "I Timothy", "II Timothy", "Titus", "Philemon", "Hebrews", "James",
    "I Peter", "II Peter", "I John", "II John", "III John", "Jude",
    "Revelation of John",
]
EN_NAME_TO_ID = {name.lower(): i + 1 for i, name in enumerate(_EN_NAMES)}
EN_NAME_TO_ID["revelation"] = 66

# (book_id, chapter, verse, text)
VerseRow = tuple[int, int, int, str]


@dataclasses.dataclass
class Parsed:
    """Výsledek parseru. `verses` = (book, chapter, verse, text, paragraph,
    poetry); `headings` a `footnotes` = (book, chapter, verse, text)."""

    verses: list[tuple[int, int, int, str, bool, bool]]
    headings: list[tuple[int, int, int, str]]
    footnotes: list[tuple[int, int, int, str]]


# --------------------------------------------------------------------------
# Pomocné funkce
# --------------------------------------------------------------------------
def log(msg: str) -> None:
    print(msg, flush=True)


_WS = re.compile(r"\s+")


def clean_text(text: str) -> str:
    """Sjednotí bílé znaky (zachová zalomení řádků poezie `\n`)."""
    lines = (_WS.sub(" ", line).strip() for line in text.split("\n"))
    return "\n".join(line for line in lines if line)


def resolve_book_id(value: object) -> int:
    """Číslo (1–66), OSIS kód ('Gen') nebo anglický název ('I Samuel')."""
    if isinstance(value, int):
        if 1 <= value <= 66:
            return value
        raise ValueError(f"Neplatné číslo knihy: {value}")
    key = str(value).strip().lower()
    if key.isdigit():
        return resolve_book_id(int(key))
    if key in OSIS_TO_ID:
        return OSIS_TO_ID[key]
    if key in EN_NAME_TO_ID:
        return EN_NAME_TO_ID[key]
    raise ValueError(f"Neznámá kniha: {value!r}")


# --------------------------------------------------------------------------
# Parsery zdrojových formátů – každý vrací iterátor VerseRow
# --------------------------------------------------------------------------
def parse_scrollmapper(path: Path) -> Iterator[VerseRow]:
    data = json.loads(path.read_text(encoding="utf-8"))
    books = data["books"]
    for index, book in enumerate(books):
        try:
            book_id = resolve_book_id(book["name"])
        except ValueError:
            # Úplný kánon bez známých názvů → použij pořadí.
            if len(books) != 66:
                raise
            book_id = index + 1
        for chapter in book["chapters"]:
            for verse in chapter["verses"]:
                yield (book_id, int(chapter["chapter"]), int(verse["verse"]),
                       verse["text"])


def parse_zefania(path: Path) -> Iterator[VerseRow]:
    root = ET.parse(path).getroot()
    for book in root.iter("BIBLEBOOK"):
        book_id = resolve_book_id(int(book.attrib["bnumber"]))
        for chapter in book.iter("CHAPTER"):
            ch = int(chapter.attrib["cnumber"])
            for verse in chapter.iter("VERS"):
                # itertext() zahrne i text vnořených značek (STYLE, gr…),
                # ale vynechá poznámky pod čarou (NOTE).
                parts = [verse.text or ""]
                for child in verse:
                    if child.tag.upper() != "NOTE":
                        parts.append("".join(child.itertext()))
                    parts.append(child.tail or "")
                yield (book_id, ch, int(verse.attrib["vnumber"]), "".join(parts))


def parse_flat(path: Path) -> Iterator[VerseRow]:
    data = json.loads(path.read_text(encoding="utf-8"))
    for row in data["verses"]:
        yield (resolve_book_id(row["book"]), int(row["chapter"]),
               int(row["verse"]), row["text"])


_TOKEN = re.compile(r"<[^>]+>|[^<]+")
_TAG = re.compile(r"<\s*(/?)\s*([A-Za-z]+)([^>]*?)(/?)\s*>")
_ATTR = re.compile(r'([A-Za-z]+)="([^"]*)"')
_SKIP_TITLE_TYPES = {"main", "chapter", "runningHead", "acrostic"}


def parse_osis(path: Path) -> Parsed:
    """Proudové zpracování OSIS XML bez DOM (stejný algoritmus jako
    lib/data/translations/osis_parser.dart).

    Podporuje verše jako milníky (sID/eID) i jako kontejnery, nadpisy
    <title>, odstavce <p>, poezii <lg>/<l> a poznámky <note>.
    """
    text = path.read_text(encoding="utf-8")
    verses, headings, footnotes = [], [], []
    cur = None            # (book, chapter, verse) aktuálního verše
    buf: list[str] = []
    meta = (True, False)  # (paragraph, poetry) aktuálního verše
    para_pending = True
    lg_depth = 0
    note_depth, note_buf = 0, []
    title_depth, title_buf, title_skip = 0, [], False
    pending_titles: list[str] = []
    in_header = False

    def start(osis_id: str) -> None:
        nonlocal cur, buf, meta, para_pending, pending_titles
        ref = osis_id.split()[0].split(".")
        book = OSIS_TO_ID.get(ref[0].lower()) if len(ref) == 3 else None
        if book is None or not ref[1].isdigit() or not ref[2].isdigit():
            cur = None  # deuterokanonické knihy apod. přeskočíme
            return
        cur = (book, int(ref[1]), int(ref[2]))
        buf = []
        meta = (para_pending, lg_depth > 0)
        para_pending = False
        for t in pending_titles:
            headings.append((*cur, t))
        pending_titles = []

    def end() -> None:
        nonlocal cur
        if cur is not None:
            verses.append((*cur, "".join(buf), *meta))
        cur = None

    for m in _TOKEN.finditer(text):
        tok = m.group(0)
        if not tok.startswith("<"):
            if in_header:
                continue
            # Zalomení z formátování XML nejsou součástí textu – skutečné
            # konce řádků poezie přidávají až značky </l>, </p>.
            chunk = _WS.sub(" ", html.unescape(tok))
            if note_depth:
                note_buf.append(chunk)
            elif title_depth:
                title_buf.append(chunk)
            elif cur is not None:
                buf.append(chunk)
            continue
        t = _TAG.match(tok)
        if t is None or tok.startswith("<?") or tok.startswith("<!"):
            continue
        closing, name, rest, selfclosing = t.group(1), t.group(2), t.group(3), t.group(4)
        attrs = dict(_ATTR.findall(rest))
        if name == "header":
            in_header = not closing and not selfclosing
            continue
        if in_header:
            continue
        if name == "hi" and closing:
            # „<hi>adam</hi>zní“ – formátování XML spolklo mezeru za značkou.
            nxt = text[m.end():m.end() + 1]
            if nxt.isalnum():
                target = note_buf if note_depth else (title_buf if title_depth else buf)
                target.append(" ")
            continue
        if name == "note":
            if selfclosing:
                continue
            if not closing:
                note_depth += 1
                if note_depth == 1:
                    note_buf = []
            else:
                note_depth -= 1
                if note_depth == 0 and cur is not None:
                    note = clean_text("".join(note_buf).replace("\n", " "))
                    if note:
                        footnotes.append((*cur, note))
            continue
        if note_depth:
            continue
        if name == "title":
            if selfclosing:
                continue
            if not closing:
                title_depth += 1
                if title_depth == 1:
                    title_buf = []
                    title_skip = attrs.get("type") in _SKIP_TITLE_TYPES
            else:
                title_depth -= 1
                if title_depth == 0 and not title_skip:
                    title = clean_text("".join(title_buf).replace("\n", " "))
                    if title:
                        pending_titles.append(title)
            continue
        if title_depth:
            continue
        if name == "verse":
            if closing:
                end()
            elif "eID" in attrs:
                end()
            elif "osisID" in attrs:
                end()
                start(attrs["osisID"])
            continue
        if name in ("p", "lg"):
            if not closing and not selfclosing:
                if name == "lg":
                    lg_depth += 1
                para_pending = True
            elif closing:
                if name == "lg":
                    lg_depth = max(0, lg_depth - 1)
                para_pending = True
                if cur is not None:
                    buf.append("\n")
            continue
        if name == "l" and closing and cur is not None:
            buf.append("\n")
            continue
        if name in ("chapter", "div") and (closing or selfclosing):
            para_pending = True
        if name == "lb" and cur is not None:
            buf.append("\n")
    verses = [(b, c, v, fix_spacing(t), p, po) for b, c, v, t, p, po in verses]
    footnotes = [(b, c, v, fix_spacing(t)) for b, c, v, t in footnotes]
    # Zdroj bez skutečného členění na odstavce (např. ČEP) → verš po verši,
    # jinak by celá kapitola byla jediný odstavec.
    if sum(1 for v in verses if v[4]) < len(verses) * 0.10:
        verses = [(b, c, v, t, True, po) for b, c, v, t, _, po in verses]
    return Parsed(verses, headings, footnotes)


_SPACE_AFTER_OPEN = re.compile(r"([(\[„]) +")
_SPACE_BEFORE_CLOSE = re.compile(r" +([)\],.;:!?“])")


def fix_spacing(text: str) -> str:
    """Opraví mezery rozbité formátováním XML: „( země)“ → „(země)“."""
    text = _SPACE_AFTER_OPEN.sub(r"\1", text)
    return _SPACE_BEFORE_CLOSE.sub(r"\1", text)


PARSERS = {
    "osis": parse_osis,
    "scrollmapper": parse_scrollmapper,
    "zefania": parse_zefania,
    "flat": parse_flat,
}


# --------------------------------------------------------------------------
# Stažení zdrojů
# --------------------------------------------------------------------------
def fetch(entry: dict, force: bool) -> None:
    url = entry.get("url")
    target = SOURCES_DIR / entry["source"]
    if not url or (target.exists() and not force):
        return
    log(f"  ↓ stahuji {entry['id']} z {url}")
    tmp = target.with_suffix(target.suffix + ".part")
    with urllib.request.urlopen(url, timeout=120) as resp, open(tmp, "wb") as out:
        while chunk := resp.read(1 << 16):
            out.write(chunk)
    tmp.replace(target)


# --------------------------------------------------------------------------
# Sestavení databáze
# --------------------------------------------------------------------------
def create_schema(conn: sqlite3.Connection) -> None:
    conn.executescript(SCHEMA_FILE.read_text(encoding="utf-8"))
    conn.execute(f"PRAGMA user_version = {SCHEMA_VERSION}")


def insert_books(conn: sqlite3.Connection) -> None:
    conn.executemany(
        "INSERT INTO books (id, osis, name, abbreviation, testament)"
        " VALUES (?, ?, ?, ?, ?)",
        [(i + 1, *book[:4]) for i, book in enumerate(BOOKS)],
    )


def load_translation(entry: dict) -> Parsed:
    result = PARSERS[entry["format"]](SOURCES_DIR / entry["source"])
    if not isinstance(result, Parsed):
        # Jednoduché formáty: verše bez členění (každý verš = odstavec).
        result = Parsed([(b, c, v, t, True, False) for b, c, v, t in result], [], [])

    rows: dict[tuple[int, int, int], list] = {}
    for book_id, ch, vs, text, paragraph, poetry in result.verses:
        text = clean_text(text)
        if not text or vs < 1:
            continue  # prázdné verše (vynechané v překladu) neukládáme
        key = (book_id, ch, vs)
        if key in rows:
            # Duplicitní verš (vzácné chyby zdrojů) → spojíme text.
            rows[key][0] += " " + text
        else:
            rows[key] = [text, paragraph, poetry]
    # Kanonické pořadí = fyzické pořadí v souboru databáze.
    verses = [(*key, t, p, po) for key, (t, p, po) in sorted(rows.items())]
    return Parsed(verses, result.headings, result.footnotes)


def insert_translation(conn: sqlite3.Connection, entry: dict, order: int,
                       data: Parsed) -> None:
    tid = entry["id"]
    conn.execute(
        "INSERT INTO translations (id, name, abbreviation, language, year,"
        " license, description, sort_order, verse_count)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (tid, entry["name"], entry.get("abbreviation", tid),
         entry.get("language", "cs"), entry.get("year"), entry.get("license"),
         entry.get("description"), order, len(data.verses)),
    )
    conn.executemany(
        "INSERT INTO verses (translation_id, book_id, chapter, verse, text,"
        " paragraph, poetry) VALUES (?, ?, ?, ?, ?, ?, ?)",
        ((tid, b, c, v, t, int(p), int(po)) for b, c, v, t, p, po in data.verses),
    )
    for table, items in (("headings", data.headings), ("footnotes", data.footnotes)):
        counters: dict[tuple[int, int, int], int] = {}
        out = []
        for b, c, v, text in items:
            ordn = counters.get((b, c, v), 0)
            counters[(b, c, v)] = ordn + 1
            out.append((tid, b, c, v, ordn, text))
        conn.executemany(
            f"INSERT INTO {table} (translation_id, book_id, chapter, verse, ord, text)"
            " VALUES (?, ?, ?, ?, ?, ?)", out)
    conn.execute(
        "INSERT INTO chapters (translation_id, book_id, chapter, verse_count)"
        " SELECT translation_id, book_id, chapter, MAX(verse) FROM verses"
        " WHERE translation_id = ? GROUP BY book_id, chapter",
        (tid,),
    )


def validate(conn: sqlite3.Connection, tid: str) -> list[str]:
    """Vrátí seznam varování (chybějící knihy / odlišný počet kapitol).

    Odlišný počet kapitol nemusí být chyba – jde často jen o jiné číslování
    (např. BKR: Jóel 3 kap., Malachiáš 4 kap.).
    """
    warnings = []
    present = dict(conn.execute(
        "SELECT book_id, COUNT(*) FROM chapters WHERE translation_id = ?"
        " GROUP BY book_id", (tid,)))
    for i, (osis, name, _abbr, _t, expected) in enumerate(BOOKS, start=1):
        got = present.get(i, 0)
        if got == 0:
            warnings.append(f"chybí kniha {name}")
        elif got != expected:
            warnings.append(f"{name}: {got} kap. (ČEP má {expected}) – jiné číslování?")
    return warnings


def hash_inputs(entries: Iterable[dict]) -> str:
    h = hashlib.sha256()
    h.update(SCHEMA_FILE.read_bytes())
    h.update(Path(__file__).read_bytes())
    for entry in entries:
        h.update(json.dumps(entry, sort_keys=True).encode())
        h.update((SOURCES_DIR / entry["source"]).read_bytes())
    return h.hexdigest()[:16]


def build(entries: list[dict]) -> None:
    OUTPUT_DB.parent.mkdir(parents=True, exist_ok=True)
    tmp_db = OUTPUT_DB.with_suffix(".db.tmp")
    tmp_db.unlink(missing_ok=True)

    conn = sqlite3.connect(tmp_db)
    try:
        conn.execute("PRAGMA journal_mode = OFF")
        conn.execute("PRAGMA synchronous = OFF")
        create_schema(conn)
        insert_books(conn)

        for order, entry in enumerate(entries, start=1):
            data = load_translation(entry)
            insert_translation(conn, entry, order, data)
            log(f"  ✓ {entry['id']:4} {entry['name']}: {len(data.verses):,} veršů,"
                f" {len(data.headings):,} nadpisů, {len(data.footnotes):,} poznámek")
            for warning in validate(conn, entry["id"]):
                log(f"    ! {warning}")

        log("  … stavím fulltextový index")
        conn.execute("INSERT INTO verses_fts (verses_fts) VALUES ('rebuild')")
        conn.execute("INSERT INTO verses_fts (verses_fts) VALUES ('optimize')")

        version = hash_inputs(entries)
        built_at = dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds")
        conn.executemany("INSERT INTO meta (key, value) VALUES (?, ?)", [
            ("schema_version", str(SCHEMA_VERSION)),
            ("content_version", version),
            ("built_at", built_at),
        ])
        conn.commit()
        conn.execute("ANALYZE")
        conn.execute("VACUUM")
    finally:
        conn.close()

    tmp_db.replace(OUTPUT_DB)
    OUTPUT_MANIFEST.write_text(json.dumps({
        "schema_version": SCHEMA_VERSION,
        "content_version": version,
        "built_at": built_at,
        "translations": [e["id"] for e in entries],
    }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    size_mb = OUTPUT_DB.stat().st_size / 1_048_576
    log(f"Hotovo: {OUTPUT_DB.relative_to(ROOT)} ({size_mb:.1f} MB),"
        f" verze obsahu {version}")


def write_catalog(entries: list[dict]) -> None:
    """Katalog překladů ke stažení v aplikaci (zařízení si text stáhne samo
    přímo od distributora – ve veřejném buildu se chráněné texty nešíří)."""
    keys = ("id", "name", "abbreviation", "year", "license", "description",
            "format", "url", "size_mb")
    catalog = [
        {k: e[k] for k in keys if k in e} | {"available": not e.get("unavailable")}
        for e in entries if e.get("download") or e.get("unavailable")
    ]
    OUTPUT_CATALOG.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_CATALOG.write_text(json.dumps({"translations": catalog},
                                         ensure_ascii=False, indent=2) + "\n",
                              encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--fetch", action="store_true",
                        help="stáhnout chybějící zdroje z URL v translations.json")
    parser.add_argument("--force-fetch", action="store_true",
                        help="stáhnout zdroje znovu, i když už existují")
    parser.add_argument("--only", nargs="+", metavar="ID",
                        help="sestavit jen vybrané překlady (např. BKR CSP)")
    args = parser.parse_args()

    config = json.loads(CONFIG_FILE.read_text(encoding="utf-8"))
    write_catalog(config["translations"])
    entries = [e for e in config["translations"] if e.get("enabled", True)]
    if args.only:
        wanted = {x.upper() for x in args.only}
        entries = [e for e in entries if e["id"].upper() in wanted]

    SOURCES_DIR.mkdir(parents=True, exist_ok=True)
    if args.fetch or args.force_fetch:
        for entry in entries:
            fetch(entry, force=args.force_fetch)

    available = []
    for entry in entries:
        if (SOURCES_DIR / entry["source"]).exists():
            available.append(entry)
        else:
            log(f"  – přeskakuji {entry['id']}: chybí data/sources/{entry['source']}"
                + (" (spusť s --fetch)" if entry.get("url") else ""))

    if not available:
        log("Chyba: není k dispozici žádný překlad.")
        return 1

    log(f"Sestavuji {OUTPUT_DB.relative_to(ROOT)} …")
    build(available)
    return 0


if __name__ == "__main__":
    sys.exit(main())
