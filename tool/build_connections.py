"""Souhrn křížových odkazů pro vizualizaci „Souvislosti v Bibli“.

  python3 tool/build_connections.py <složka s cross_references_*.db>

Zdroj: OpenBible.info Cross References (CC BY 4.0) ve formátu scrollmapper
(https://github.com/scrollmapper/bible_databases). Odkazy zůstávají
v anglickém číslování (stejném jako BKR); aplikace je převádí.

Výstup assets/content/connections.json:
  verses   – počty veršů v kapitolách (66 seznamů, anglické číslování)
  arcs     – [kapitola A, kapitola B, váha]: nejsilnější spojení kapitol
             (globální index kapitoly 0–1188), slabší dřív
  pairs    – [kniha A, kniha B, váha]: spojení knih (A < B)
  examples – "A-B": nejsilnější dvojice veršů
             [kniha, kap., verš, kniha, kap., verš, konec]
"""
import json
import sqlite3
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tool"))

from build_study_db import EN_TO_ID  # noqa: E402

ARCS = 3500
EXAMPLES = 4
MIN_VOTES = 3


def main() -> None:
    src = Path(sys.argv[1])
    db = sqlite3.connect(ROOT / "assets" / "db" / "bible.db")
    verses = [[] for _ in range(66)]
    for b, c, n in db.execute(
            "SELECT book_id, chapter, verse_count FROM chapters "
            "WHERE translation_id = 'BKR' ORDER BY book_id, chapter"):
        verses[b - 1].append(n)
    offset, start = 0, []
    for b in range(66):
        start.append(offset)
        offset += len(verses[b])
    assert offset == 1189, offset

    # (z, do) → hlasy; duplicity mezi soubory se slučují maximem.
    links: dict[tuple, int] = {}
    for f in sorted(src.glob("cross_references_*.db")):
        conn = sqlite3.connect(f)
        for fb, fc, fv, tb, tc, tvs, tve, votes in conn.execute(
                "SELECT from_book, from_chapter, from_verse, to_book, "
                "to_chapter, to_verse_start, to_verse_end, votes "
                "FROM cross_references WHERE votes >= ?", (MIN_VOTES,)):
            a, b = EN_TO_ID.get(fb.lower()), EN_TO_ID.get(tb.lower())
            if not a or not b:
                continue
            if fc > len(verses[a - 1]) or tc > len(verses[b - 1]):
                continue
            key = (a, fc, fv, b, tc, tvs, max(tve or tvs, tvs))
            links[key] = max(links.get(key, 0), votes)
        conn.close()
    print(f"odkazů: {len(links):,}")

    chapter_w: dict[tuple, int] = defaultdict(int)
    book_w: dict[tuple, int] = defaultdict(int)
    best: dict[tuple, dict] = defaultdict(dict)
    for (a, fc, fv, b, tc, tvs, tve), votes in links.items():
        ca, cb = start[a - 1] + fc - 1, start[b - 1] + tc - 1
        if ca != cb:
            chapter_w[(min(ca, cb), max(ca, cb))] += votes
        if a != b:
            pair = (min(a, b), max(a, b))
            book_w[pair] += votes
            # Oba směry jedné dvojice veršů se počítají jednou.
            ex = (a, fc, fv, b, tc, tvs, tve) if a < b \
                else (b, tc, tvs, a, fc, fv, fv)
            ident = (ex[0], ex[1], ex[2], ex[3], ex[4], ex[5])
            if votes > best[pair].get(ident, (0,))[0]:
                best[pair][ident] = (votes, list(ex))

    arcs = sorted(chapter_w.items(), key=lambda kv: -kv[1])[:ARCS]
    arcs.sort(key=lambda kv: kv[1])
    pairs = sorted(book_w.items(), key=lambda kv: -kv[1])

    def diverse(cands: list) -> list:
        """Nejsilnější dvojice, ale každý verš nejvýš jednou."""
        used, out = set(), []
        for _, ex in sorted(cands, key=lambda x: -x[0]):
            src, dst = tuple(ex[:3]), tuple(ex[3:6])
            if src in used or dst in used:
                continue
            used |= {src, dst}
            out.append(ex)
            if len(out) == EXAMPLES:
                break
        return out

    examples = {f"{a}-{b}": diverse(list(best[(a, b)].values()))
                for (a, b), _ in pairs}
    out = {
        "verses": verses,
        "arcs": [[a, b, w] for (a, b), w in arcs],
        "pairs": [[a, b, w] for (a, b), w in pairs],
        "examples": examples,
    }
    path = ROOT / "assets" / "content" / "connections.json"
    path.write_text(json.dumps(out, separators=(",", ":")) + "\n")
    print(f"{path.relative_to(ROOT)}: {path.stat().st_size / 1024:.0f} kB, "
          f"oblouků {len(arcs)}, dvojic knih {len(pairs)}")


if __name__ == "__main__":
    main()
