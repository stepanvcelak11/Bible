"""Sestaví obsahová data aplikace z tool/content/*.py do assets/content/.

  python3 tool/build_content.py            # zapíše JSON
  python3 tool/build_content.py --check X  # vypíše text odkazů pro kontrolu
                                           # (X = JSON překladu ve formátu
                                           # scrollmapper s hebrejským
                                           # číslováním, např. ČSP)

Odkazy se zapisují česky („Ž 34,19“, „Fp 4,6-7“, „Gn 12“) a ukládají jako
[kniha, kapitola, verš, konec] v kanonickém (hebrejském) číslování.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tool"))

from content import intros_nt, intros_ot, situations  # noqa: E402

ABBR = ("Gn Ex Lv Nu Dt Joz Sd Rt 1S 2S 1Kr 2Kr 1Pa 2Pa Ezd Neh Est Jb Ž Př "
        "Kaz Pís Iz Jr Pl Ez Da Oz Jl Am Abd Jon Mi Na Abk Sf Ag Za Mal Mt Mk "
        "L J Sk Ř 1K 2K Ga Ef Fp Ko 1Te 2Te 1Tm 2Tm Tt Fm Žd Jk 1Pt 2Pt 1J 2J "
        "3J Ju Zj").split()
BOOK = {a: i + 1 for i, a in enumerate(ABBR)}
_REF = re.compile(r"^(\S+)\s+(\d+)(?:,(\d+)(?:-(\d+))?)?$")


def ref(s: str) -> list[int]:
    m = _REF.match(s.strip())
    if not m or m.group(1) not in BOOK:
        raise ValueError(f"Neplatný odkaz: {s!r}")
    b, c = BOOK[m.group(1)], int(m.group(2))
    v = int(m.group(3) or 0)
    end = int(m.group(4) or v)
    return [b, c, v, end]


def build_situations() -> dict:
    return {
        "groups": [{"id": g, "name": n} for g, n in situations.GROUPS],
        "situations": [
            {"id": i, "group": g, "icon": icon, "title": t, "intro": intro,
             "refs": [ref(r) for r in refs]}
            for i, g, icon, t, intro, refs in situations.SITUATIONS
        ],
    }


def build_intros(out: Path) -> dict:
    """Doplní k existujícím úvodům (book_intros.json) rozšířené údaje."""
    data = json.loads((out / "book_intros.json").read_text(encoding="utf-8"))
    ext = {**intros_ot.OT, **intros_nt.NT}
    missing = [b for b in range(1, 67) if b not in ext]
    if missing:
        raise SystemExit(f"Chybí rozšíření úvodů pro knihy {missing}")
    for book_id, e in ext.items():
        intro = data["books"][str(book_id)]
        intro.update({
            "purpose": e["purpose"],
            "recipients": e["recipients"],
            "setting": e["setting"],
            "people": e["people"],
            "places": e["places"],
            "features": e["features"],
            "themes": [{"title": t, "text": x} for t, x in e["themes"]],
            "timeline": [{"date": d, "event": x} for d, x in e["timeline"]],
        })
        if e.get("timeline_note"):
            intro["timelineNote"] = e["timeline_note"]
    return data


def main() -> None:
    out = ROOT / "assets" / "content"
    data = {"situations.json": build_situations(),
            "book_intros.json": build_intros(out)}
    if "--check" in sys.argv:
        src = json.load(open(sys.argv[sys.argv.index("--check") + 1]))
        books = src["books"]

        def text(b, c, v, e):
            try:
                vs = books[b - 1]["chapters"][c - 1]["verses"]
            except IndexError:
                return "!!! KAPITOLA NEEXISTUJE"
            got = [x["text"] for x in vs if v <= x["verse"] <= e]
            return " ".join(got) if got else "!!! VERŠ NEEXISTUJE"

        for s in data["situations.json"]["situations"]:
            print(f"\n## {s['title']}")
            for r in s["refs"]:
                print(f"  {ABBR[r[0]-1]} {r[1]},{r[2]}: {text(*r)[:140]}")
        return
    for name, d in data.items():
        (out / name).write_text(
            json.dumps(d, ensure_ascii=False, indent=1) + "\n",
            encoding="utf-8")
        print(f"assets/content/{name}")


if __name__ == "__main__":
    main()
