#!/usr/bin/env python3
"""
Sestaví STUDIJNÍ BALÍČEK (study.db) z otevřených dat:

  * původní text – hebrejský SZ (TAHOT) a řecký NZ (TAGNT), slovo po slově
    s transliterací, anglickým překladem slova, Strongovým číslem a
    morfologií (STEPBible.org, CC BY 4.0),
  * slovník – TBESH/TBESG (STEPBible.org, CC BY 4.0) + české významy
    nejčastějších slov (tool/study/glosses_*.py),
  * křížové odkazy – OpenBible.info (CC BY) přes scrollmapper/bible_databases,
  * biblická místa – OpenBible.info Bible-Geocoding-Data (CC BY 4.0) + české
    názvy a tematické mapy (tool/study/places_cs.py),
  * podklad mapy – Natural Earth (volné dílo) → assets/map/basemap.json.

Výstup:
  build/study/study-<verze>.db        – stahuje se v aplikaci na požádání
  assets/db/study_manifest.json       – název souboru, velikost, verze
  assets/map/basemap.json             – obrysy pevniny, jezer a řek

Použití:
  python3 tool/build_study_db.py --fetch
"""

from __future__ import annotations

import argparse
import gzip
import hashlib
import html
import json
import re
import sqlite3
import sys
import urllib.parse
import urllib.request
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tool"))

from study.glosses_grk import GRK  # noqa: E402
from study.glosses_heb import HEB  # noqa: E402
from study.places_cs import PLACES_CS, ROUTES  # noqa: E402

SRC = ROOT / "data" / "study_sources"
OUT_DIR = ROOT / "build" / "study"
MANIFEST = ROOT / "assets" / "db" / "study_manifest.json"
BASEMAP = ROOT / "assets" / "map" / "basemap.json"
PLACES_ASSET = ROOT / "assets" / "map" / "places.json"

STEP = "https://raw.githubusercontent.com/STEPBible/STEPBible-Data/master/"
SOURCES = {
    "TAHOT1.txt": STEP + "Translators Amalgamated OT+NT/TAHOT Gen-Deu - Translators Amalgamated Hebrew OT - STEPBible.org CC BY.txt",
    "TAHOT2.txt": STEP + "Translators Amalgamated OT+NT/TAHOT Jos-Est - Translators Amalgamated Hebrew OT - STEPBible.org CC BY.txt",
    "TAHOT3.txt": STEP + "Translators Amalgamated OT+NT/TAHOT Job-Sng - Translators Amalgamated Hebrew OT - STEPBible.org CC BY.txt",
    "TAHOT4.txt": STEP + "Translators Amalgamated OT+NT/TAHOT Isa-Mal - Translators Amalgamated Hebrew OT - STEPBible.org CC BY.txt",
    "TAGNT1.txt": STEP + "Translators Amalgamated OT+NT/TAGNT Mat-Jhn - Translators Amalgamated Greek NT - STEPBible.org CC-BY.txt",
    "TAGNT2.txt": STEP + "Translators Amalgamated OT+NT/TAGNT Act-Rev - Translators Amalgamated Greek NT - STEPBible.org CC-BY.txt",
    "TBESH.txt": STEP + "Lexicons/TBESH - Translators Brief lexicon of Extended Strongs for Hebrew - STEPBible.org CC BY.txt",
    "TBESG.txt": STEP + "Lexicons/TBESG - Translators Brief lexicon of Extended Strongs for Greek - STEPBible.org CC BY.txt",
    "ancient.jsonl": "https://raw.githubusercontent.com/openbibleinfo/Bible-Geocoding-Data/main/data/ancient.jsonl",
    **{
        f"xr_{i}.db": f"https://raw.githubusercontent.com/scrollmapper/bible_databases/master/formats/sqlite/extras/cross_references_{i}.db"
        for i in range(7)
    },
    "ne_land.geojson": "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_land.geojson",
    "ne_lakes.geojson": "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_lakes.geojson",
    "ne_rivers.geojson": "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_rivers_lake_centerlines.geojson",
}

# Zkratky knih STEPBible → id 1–66.
STEP_BOOKS = (
    "Gen Exo Lev Num Deu Jos Jdg Rut 1Sa 2Sa 1Ki 2Ki 1Ch 2Ch Ezr Neh Est Job "
    "Psa Pro Ecc Sng Isa Jer Lam Ezk Dan Hos Jol Amo Oba Jon Mic Nam Hab Zep "
    "Hag Zec Mal Mat Mrk Luk Jhn Act Rom 1Co 2Co Gal Eph Php Col 1Th 2Th 1Ti "
    "2Ti Tit Phm Heb Jas 1Pe 2Pe 1Jn 2Jn 3Jn Jud Rev"
).split()
STEP_TO_ID = {b: i + 1 for i, b in enumerate(STEP_BOOKS)}

OSIS = (
    "Gen Exod Lev Num Deut Josh Judg Ruth 1Sam 2Sam 1Kgs 2Kgs 1Chr 2Chr Ezra "
    "Neh Esth Job Ps Prov Eccl Song Isa Jer Lam Ezek Dan Hos Joel Amos Obad "
    "Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom 1Cor "
    "2Cor Gal Eph Phil Col 1Thess 2Thess 1Tim 2Tim Titus Phlm Heb Jas 1Pet "
    "2Pet 1John 2John 3John Jude Rev"
).split()
OSIS_TO_ID = {b: i + 1 for i, b in enumerate(OSIS)}

EN_BOOKS = [
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua",
    "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings",
    "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job",
    "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah",
    "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
    "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai",
    "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts",
    "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians",
    "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians",
    "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James",
    "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation",
]
EN_TO_ID = {b.lower(): i + 1 for i, b in enumerate(EN_BOOKS)}
EN_TO_ID.update({"psalm": 19, "song of songs": 22, "revelation of john": 66})

# Okno mapy (zeměpisná délka/šířka): od Itálie po Persii, od Etiopie po Černé moře.
BBOX = (8.0, 12.0, 62.0, 46.0)

FIELD = "\x1f"  # oddělovač polí slova
WORD = "\x1e"   # oddělovač slov ve verši

SCHEMA = """
CREATE TABLE meta ("key" TEXT PRIMARY KEY, value TEXT NOT NULL);
-- Slova původního textu jednoho verše (OT v hebrejském číslování).
-- data = slova oddělená \\x1e, pole \\x1f: originál, transliterace,
-- anglický překlad slova, Strongovo číslo, morfologie.
-- id = book * 1000000 + chapter * 1000 + verse (rowid → kompaktní uložení).
CREATE TABLE words (id INTEGER PRIMARY KEY, data TEXT NOT NULL);
-- Převod anglického (KJV) číslování na hebrejské tam, kde se liší.
CREATE TABLE vmap (
  book INTEGER NOT NULL, eng_chapter INTEGER NOT NULL, eng_verse INTEGER NOT NULL,
  heb_chapter INTEGER NOT NULL, heb_verse INTEGER NOT NULL
);
CREATE INDEX vmap_eng ON vmap (book, eng_chapter, eng_verse);
CREATE INDEX vmap_heb ON vmap (book, heb_chapter, heb_verse);
CREATE TABLE lexicon (
  strong TEXT PRIMARY KEY, lemma TEXT NOT NULL, translit TEXT NOT NULL,
  gloss_cs TEXT, gloss_en TEXT NOT NULL, definition TEXT NOT NULL,
  morph TEXT, occurrences INTEGER NOT NULL DEFAULT 0
) WITHOUT ROWID;
-- Výskyty slova (pro „kde všude se slovo vyskytuje“): odkazy seřazené
-- kanonicky, každý jako base36 čísla book*1000000 + chapter*1000 + verse,
-- oddělené čárkou.
CREATE TABLE occurrences (strong TEXT PRIMARY KEY, refs TEXT NOT NULL);
-- Křížové odkazy (anglické číslování), seřazené podle hlasů OpenBible.
CREATE TABLE xrefs (
  book INTEGER NOT NULL, chapter INTEGER NOT NULL, verse INTEGER NOT NULL,
  to_book INTEGER NOT NULL, to_chapter INTEGER NOT NULL,
  to_verse INTEGER NOT NULL, to_verse_end INTEGER NOT NULL,
  votes INTEGER NOT NULL,
  PRIMARY KEY (book, chapter, verse, to_book, to_chapter, to_verse)
) WITHOUT ROWID;
CREATE TABLE places (
  id TEXT PRIMARY KEY, name_cs TEXT NOT NULL, name_en TEXT NOT NULL,
  type TEXT, lon REAL NOT NULL, lat REAL NOT NULL, verses INTEGER NOT NULL
) WITHOUT ROWID;
CREATE TABLE place_verses (
  place_id TEXT NOT NULL, book INTEGER NOT NULL, chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL
);
CREATE INDEX place_verses_ref ON place_verses (book, chapter);
CREATE TABLE routes (
  id TEXT PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL,
  color TEXT NOT NULL, stops TEXT NOT NULL
) WITHOUT ROWID;
"""


def log(msg: str) -> None:
    print(msg, flush=True)


def fetch(force: bool) -> None:
    SRC.mkdir(parents=True, exist_ok=True)
    for name, url in SOURCES.items():
        target = SRC / name
        if target.exists() and not force:
            continue
        log(f"  ↓ {name}")
        parts = urllib.parse.urlsplit(url)
        quoted = urllib.parse.urlunsplit(
            parts._replace(path=urllib.parse.quote(parts.path)))
        with urllib.request.urlopen(quoted, timeout=300) as r:
            target.write_bytes(r.read())


# --- Původní text -----------------------------------------------------------
_REF = re.compile(r"^([1-3]?[A-Z][a-z]{1,2})\.(\d+)\.(\d+)(?:\((\d+)\.(\d+)\))?#\d+=(\S+)")
_CANTILLATION = re.compile("[\u0591-\u05AF\u05BD\u05C0\u05C3]")
_BRACES = re.compile(r"\{([HG]\d{4})([A-Za-z]?)\}")

# Výskyty podrobných čísel STEPBible (H1004B, G2424G…) – podle nich se
# ve slovníku vybere ta podvarianta hesla, která se v textu opravdu
# vyskytuje (ne první v seznamu, což bývá vlastní jméno nebo vzácný význam).
EXT_COUNTS: Counter = Counter()


def _clean_translit(t: str) -> str:
    return t.replace("/", "").replace(".", "").replace("\\", "").lower()


def parse_tahot() -> tuple[dict, list, Counter, dict]:
    """→ (verše {(b,c,v heb): [slova]}, vmap, četnost, výskyty)."""
    verses: dict[tuple[int, int, int], list[str]] = defaultdict(list)
    vmap: set[tuple[int, int, int, int, int]] = set()
    counts: Counter = Counter()
    occ: dict[str, set] = defaultdict(set)
    for i in range(1, 5):
        for line in (SRC / f"TAHOT{i}.txt").open(encoding="utf-8"):
            m = _REF.match(line)
            if not m:
                continue
            book = STEP_TO_ID[m.group(1)]
            eng = (int(m.group(2)), int(m.group(3)))
            heb = (int(m.group(4)), int(m.group(5))) if m.group(4) else eng
            kind = m.group(6)
            if not kind.startswith(("L", "Q")):
                continue  # ketiv, varianty
            c = line.rstrip("\n").split("\t")
            if len(c) < 6:
                continue
            strong_m = _BRACES.search(c[4])
            strong = strong_m.group(1) if strong_m else ""
            if strong_m:
                EXT_COUNTS[strong + strong_m.group(2).upper()] += 1
            # Bez kantilačních znamének (U+0591–U+05AF) – samohlásky zůstávají.
            word = _CANTILLATION.sub("", c[1].replace("/", "").replace("\\", ""))
            english = re.sub(r"\s+", " ", c[3].replace("/", " ")).strip()
            verses[(book, *heb)].append(FIELD.join(
                [word, _clean_translit(c[2]), english, strong, c[5]]))
            if eng != heb:
                vmap.add((book, *eng, *heb))
            if strong:
                counts[strong] += 1
                occ[strong].add((book, *heb))
    return verses, sorted(vmap), counts, occ


def parse_tagnt() -> tuple[dict, Counter, dict]:
    verses: dict[tuple[int, int, int], list[str]] = defaultdict(list)
    counts: Counter = Counter()
    occ: dict[str, set] = defaultdict(set)
    for i in (1, 2):
        for line in (SRC / f"TAGNT{i}.txt").open(encoding="utf-8"):
            m = _REF.match(line)
            if not m or "N" not in m.group(6):
                continue  # jen slova textu Nestle-Aland
            book = STEP_TO_ID[m.group(1)]
            ref = (book, int(m.group(2)), int(m.group(3)))
            c = line.rstrip("\n").split("\t")
            if len(c) < 5:
                continue
            gm = re.match(r"^(.*?)\s*\((.*)\)\s*$", c[1])
            word, translit = (gm.group(1), gm.group(2)) if gm else (c[1], "")
            strong, _, morph = c[3].partition("=")
            EXT_COUNTS[strong.upper()] += 1
            strong = strong[:5]
            verses[ref].append(FIELD.join(
                [word, translit.lower(), c[2].strip(), strong, morph]))
            counts[strong] += 1
            occ[strong].add(ref)
    return verses, counts, occ


# --- Slovník -----------------------------------------------------------------
_TAG = re.compile(r"<[^>]+>")


def _plain(definition: str) -> str:
    text = re.sub(r"<br\s*/?>|<BR\s*/?>", "\n", definition)
    text = _TAG.sub("", text)
    text = html.unescape(text).replace("__", "")
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n\s*\n+", "\n", text).strip()
    return text[:700] + ("…" if len(text) > 700 else "")


def parse_lexicon(counts: Counter) -> list[tuple]:
    """Jedno heslo na Strongovo číslo. STEPBible má pod jedním číslem více
    podvariant (H1004A „místo“, H1004B „dům“…); vybere se ta s nejvíce
    výskyty v textu – výskyty „významů“ (H1004O = a Meaning of H1004B) se
    připočtou k hlavnímu heslu."""
    rows: dict[str, tuple] = {}
    for name, cs in (("TBESH.txt", HEB), ("TBESG.txt", GRK)):
        entries: dict[str, dict[str, list]] = defaultdict(dict)
        score: Counter = Counter()
        for line in (SRC / name).open(encoding="utf-8"):
            c = line.rstrip("\n").split("\t")
            if len(c) < 8 or not re.match(r"^[HG]\d{4}[A-Za-z]?$", c[0]):
                continue
            base = c[0][:5]
            if not counts.get(base):
                continue  # jen slova, která se v textu skutečně vyskytují
            ext = c[1].split()[0].upper() if c[1].strip() else c[0].upper()
            target = c[2].strip().upper()
            main = target if target[:5] == base else None
            if main:
                score[main] += EXT_COUNTS.get(ext, 0)
            if ext == target or not entries[base]:
                entries[base].setdefault(ext, c)
        for base, cands in entries.items():
            best = max(cands, key=lambda e: (score.get(e, 0), e == list(cands)[0]))
            c = cands[best]
            gloss_en = c[6].split(":")[0].strip()
            rows[base] = (base, c[3], _clean_translit(c[4]), cs.get(base),
                          gloss_en, _plain(c[7]), c[5], counts.get(base, 0))
    return list(rows.values())


# --- Křížové odkazy ----------------------------------------------------------
def parse_xrefs(per_verse: int = 10, min_votes: int = 5) -> list[tuple]:
    best: dict[tuple[int, int, int], dict] = defaultdict(dict)
    for i in range(7):
        conn = sqlite3.connect(SRC / f"xr_{i}.db")
        for fb, fc, fv, tb, tc, tvs, tve, votes in conn.execute(
            "SELECT from_book, from_chapter, from_verse, to_book, to_chapter,"
            " to_verse_start, to_verse_end, votes FROM cross_references"):
            if votes is None or votes < min_votes:
                continue
            f = EN_TO_ID.get(fb.lower())
            t = EN_TO_ID.get(tb.lower())
            if not f or not t:
                continue
            key = (t, tc, tvs, max(tve or tvs, tvs))
            cur = best[(f, fc, fv)]
            cur[key] = max(cur.get(key, 0), votes)
        conn.close()
    rows = []
    for src, targets in best.items():
        top = sorted(targets.items(), key=lambda kv: -kv[1])[:per_verse]
        rows.extend((*src, *t, v) for t, v in top)
    return rows


# --- Místa -------------------------------------------------------------------
def parse_places(vmap: list) -> tuple[list, list, dict]:
    """Odkazy OpenBible jsou v anglickém číslování (ESV) – převedou se na
    hebrejské, které aplikace používá jako kanonické."""
    e2h: dict = {}
    for book, ec, ev, hc, hv in vmap:
        if ev > 0:
            e2h.setdefault((book, ec, ev), (hc, hv))
    places, verses, by_friendly = [], [], {}
    for line in (SRC / "ancient.jsonl").open(encoding="utf-8"):
        d = json.loads(line)
        ids = d.get("identifications") or []
        res = ids[0].get("resolutions") if ids else None
        if not res or not res[0].get("lonlat"):
            continue
        lon, lat = map(float, res[0]["lonlat"].split(","))
        friendly = d["friendly_id"]
        name_en = re.sub(r"\s+\d+$", "", friendly)
        vs = []
        for v in d.get("verses") or []:
            parts = v["osis"].split(".")
            b = OSIS_TO_ID.get(parts[0])
            if b and len(parts) == 3:
                c, v = int(parts[1]), int(parts[2])
                c, v = e2h.get((b, c, v), (c, v))
                vs.append((d["id"], b, c, v))
        places.append((d["id"], PLACES_CS.get(friendly, name_en), name_en,
                       res[0].get("type"), round(lon, 4), round(lat, 4), len(vs)))
        verses.extend(vs)
        by_friendly[friendly] = (d["id"], lon, lat)
    return places, verses, by_friendly


def build_routes(by_friendly: dict) -> list[tuple]:
    out = []
    for rid, name, desc, color, stops in ROUTES:
        pts = []
        for f in stops:
            if f in by_friendly:
                pid, lon, lat = by_friendly[f]
                label = PLACES_CS.get(f, re.sub(r"\s+\d+$", "", f))
                pts.append({"id": pid, "name": label,
                            "lon": round(lon, 4), "lat": round(lat, 4)})
            else:
                log(f"    ! trasa {rid}: místo {f} nenalezeno")
        out.append((rid, name, desc, color, json.dumps(pts, ensure_ascii=False)))
    return out


# --- Podklad mapy ------------------------------------------------------------
def _simplify(points: list, tol: float) -> list:
    """Douglas–Peucker. Uzavřený obrys (první = poslední bod) se dělí na dvě
    poloviny – jinak by úsečka mezi koncovými body měla nulovou délku."""
    if len(points) < 3:
        return points
    if points[0] == points[-1] and len(points) > 4:
        mid = len(points) // 2
        return _simplify(points[: mid + 1], tol)[:-1] + _simplify(points[mid:], tol)
    (x1, y1), (x2, y2) = points[0], points[-1]
    dx, dy = x2 - x1, y2 - y1
    norm = (dx * dx + dy * dy) ** 0.5 or 1e-12
    idx, dmax = 0, 0.0
    for i in range(1, len(points) - 1):
        x, y = points[i]
        d = abs(dy * x - dx * y + x2 * y1 - y2 * x1) / norm
        if d > dmax:
            idx, dmax = i, d
    if dmax <= tol:
        return [points[0], points[-1]]
    return _simplify(points[: idx + 1], tol)[:-1] + _simplify(points[idx:], tol)


def _clip_ok(line: list) -> bool:
    x0, y0, x1, y1 = BBOX
    return any(x0 - 4 <= x <= x1 + 4 and y0 - 4 <= y <= y1 + 4 for x, y in line)


def _lines(geom: dict) -> list:
    t, c = geom["type"], geom["coordinates"]
    if t == "Polygon":
        return c
    if t == "MultiPolygon":
        return [ring for poly in c for ring in poly]
    if t == "LineString":
        return [c]
    if t == "MultiLineString":
        return c
    return []


def build_basemap() -> dict:
    out = {"bbox": BBOX, "land": [], "lakes": [], "rivers": []}
    for key, name, tol, minlen in (
        ("land", "ne_land.geojson", 0.03, 4),
        ("lakes", "ne_lakes.geojson", 0.01, 4),
        ("rivers", "ne_rivers.geojson", 0.01, 2),
    ):
        data = json.loads((SRC / name).read_text(encoding="utf-8"))
        for feat in data["features"]:
            props = feat.get("properties") or {}
            # Jen větší řeky a jezera (scalerank ≤ 7), ale Jordán vždy.
            rank = props.get("scalerank", 0) or 0
            nm = (props.get("name") or "")
            if key != "land" and rank > 7 and nm not in ("Jordan", "Sea of Galilee"):
                continue
            for line in _lines(feat["geometry"]):
                if not _clip_ok(line):
                    continue
                simple = _simplify([(round(x, 3), round(y, 3)) for x, y in line], tol)
                if len(simple) >= minlen:
                    out[key].append([v for pt in simple for v in (round(pt[0], 2), round(pt[1], 2))])
    return out


def b36(n: int) -> str:
    digits = "0123456789abcdefghijklmnopqrstuvwxyz"
    out = ""
    while n:
        n, r = divmod(n, 36)
        out = digits[r] + out
    return out or "0"


# --- Sestavení ---------------------------------------------------------------
def build() -> None:
    log("Sestavuji studijní balíček …")
    hverses, vmap, hcounts, hocc = parse_tahot()
    log(f"  ✓ hebrejský text: {len(hverses):,} veršů")
    gverses, gcounts, gocc = parse_tagnt()
    log(f"  ✓ řecký text: {len(gverses):,} veršů")
    lexicon = parse_lexicon(hcounts + gcounts)
    cs = sum(1 for r in lexicon if r[3])
    log(f"  ✓ slovník: {len(lexicon):,} hesel ({cs} s českým významem)")
    xrefs = parse_xrefs()
    log(f"  ✓ křížové odkazy: {len(xrefs):,}")
    places, place_verses, by_friendly = parse_places(vmap)
    log(f"  ✓ místa: {len(places):,} ({sum(1 for p in places if p[1] != p[2])} s českým názvem)")
    routes = build_routes(by_friendly)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    tmp = OUT_DIR / "study.tmp.db"
    tmp.unlink(missing_ok=True)
    conn = sqlite3.connect(tmp)
    conn.execute("PRAGMA journal_mode = OFF")
    conn.executescript(SCHEMA)
    conn.executemany("INSERT INTO words VALUES (?, ?)",
                     ((b * 1000000 + c * 1000 + v, WORD.join(w))
                      for (b, c, v), w in sorted({**hverses, **gverses}.items())))
    conn.executemany("INSERT INTO vmap VALUES (?, ?, ?, ?, ?)", vmap)
    conn.executemany("INSERT INTO lexicon VALUES (?, ?, ?, ?, ?, ?, ?, ?)", lexicon)
    occ_rows = (
        (strong, ",".join(b36(b * 1000000 + c * 1000 + v) for b, c, v in sorted(refs)))
        for occ in (hocc, gocc) for strong, refs in occ.items()
    )
    conn.executemany("INSERT OR IGNORE INTO occurrences VALUES (?, ?)", occ_rows)
    conn.executemany("INSERT INTO xrefs VALUES (?, ?, ?, ?, ?, ?, ?, ?)", xrefs)
    conn.executemany("INSERT INTO places VALUES (?, ?, ?, ?, ?, ?, ?)", places)
    conn.executemany("INSERT INTO place_verses VALUES (?, ?, ?, ?)", place_verses)
    conn.executemany("INSERT INTO routes VALUES (?, ?, ?, ?, ?)", routes)
    conn.commit()
    conn.execute("VACUUM")
    conn.close()

    digest = hashlib.sha256(tmp.read_bytes()).hexdigest()[:12]
    final = OUT_DIR / f"study-{digest}.db"
    for old in OUT_DIR.glob("study-*.db*"):
        old.unlink()
    tmp.replace(final)
    size = final.stat().st_size
    # Ke stažení komprimovaně (aplikace rozbalí sama, i na webu).
    gz = final.with_suffix(".db.gz")
    with final.open("rb") as src, gzip.open(gz, "wb", compresslevel=9) as dst:
        dst.write(src.read())
    MANIFEST.parent.mkdir(parents=True, exist_ok=True)
    MANIFEST.write_text(json.dumps({
        "file": gz.name, "version": digest, "size": size,
        "download_size": gz.stat().st_size,
        "credits": "STEPBible.org (CC BY 4.0), OpenBible.info (CC BY 4.0), Natural Earth",
    }, indent=2) + "\n", encoding="utf-8")

    BASEMAP.parent.mkdir(parents=True, exist_ok=True)
    BASEMAP.write_text(json.dumps(build_basemap(), separators=(",", ":")), encoding="utf-8")

    # Místa a trasy přibalené přímo v aplikaci – mapy fungují i bez balíčku.
    refs_by_place: dict[str, list[str]] = defaultdict(list)
    for pid, b, c, v in sorted(place_verses, key=lambda r: (r[1], r[2], r[3])):
        refs_by_place[pid].append(b36(b * 1000000 + c * 1000 + v))
    PLACES_ASSET.write_text(json.dumps({
        "credits": "OpenBible.info Bible Geocoding Data (CC BY 4.0)",
        "places": [[p[0], p[1], p[2], p[3] or "", p[4], p[5], ",".join(refs_by_place[p[0]])]
                   for p in places if p[6] > 0],
        "routes": [{"id": r[0], "name": r[1], "description": r[2], "color": r[3],
                    "stops": json.loads(r[4])} for r in routes],
    }, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    log(f"Hotovo: {gz.relative_to(ROOT)} ({size / 1_048_576:.1f} MB,"
        f" ke stažení {gz.stat().st_size / 1_048_576:.1f} MB),"
        f" mapa {BASEMAP.stat().st_size / 1024:.0f} kB,"
        f" místa {PLACES_ASSET.stat().st_size / 1024:.0f} kB")


def main() -> int:
    ap = argparse.ArgumentParser(description="Sestaví studijní balíček.")
    ap.add_argument("--fetch", action="store_true", help="stáhnout chybějící zdroje")
    args = ap.parse_args()
    if args.fetch:
        fetch(force=False)
    build()
    return 0


if __name__ == "__main__":
    sys.exit(main())
