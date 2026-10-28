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

from content import (church_year, harmony, intros_deep, intros_nt, intros_ot,  # noqa: E402
                     notes, people, quiz, situations, story, tables, threads,
                     topics)

ABBR = ("Gn Ex Lv Nu Dt Joz Sd Rt 1S 2S 1Kr 2Kr 1Pa 2Pa Ezd Neh Est Jb Ž Př "
        "Kaz Pís Iz Jr Pl Ez Da Oz Jl Am Abd Jon Mi Na Abk Sf Ag Za Mal Mt Mk "
        "L J Sk Ř 1K 2K Ga Ef Fp Ko 1Te 2Te 1Tm 2Tm Tt Fm Žd Jk 1Pt 2Pt 1J 2J "
        "3J Ju Zj").split()
BOOK = {a: i + 1 for i, a in enumerate(ABBR)}
_REF = re.compile(
    r"^(\S+)\s+(\d+)(?:,(\d+)(?:-(?:(\d+),)?(\d+))?)?$")


def ref(s: str) -> list[int]:
    m = _REF.match(s.strip())
    if not m or m.group(1) not in BOOK:
        raise ValueError(f"Neplatný odkaz: {s!r}")
    b, c = BOOK[m.group(1)], int(m.group(2))
    v = int(m.group(3) or 0)
    end = int(m.group(5) or v)
    if m.group(4):  # přes více kapitol: „5,1-7,29“
        return [b, c, v, end, int(m.group(4))]
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


def build_topics() -> dict:
    return {
        "categories": [{"id": c, "name": n} for c, n in topics.CATEGORIES],
        "topics": [
            {**{k: v for k, v in t.items() if k != "refs"},
             "refs": [ref(r) for r, _ in t["refs"]],
             "labels": [label for _, label in t["refs"]]}
            for t in topics.T
        ],
    }


def build_quiz() -> dict:
    return {
        "categories": [{"id": c, "name": n} for c, n in quiz.CATEGORIES],
        "questions": [{**{k: v for k, v in x.items() if k != "ref"},
                       "ref": ref(x["ref"])} for x in quiz.Q],
    }


def build_church_year() -> dict:
    def item(i, color, name, text_, refs):
        return {"id": i, "color": color, "name": name, "text": text_,
                "refs": [ref(r) for r in refs]}

    return {"seasons": [item(*s) for s in church_year.SEASONS],
            "feasts": [item(*f) for f in church_year.FEASTS]}


def build_threads() -> dict:
    return {"threads": [
        {"id": i, "color": color, "icon": icon, "title": title,
         "intro": intro,
         "stations": [{"ref": ref(r), "title": t, "text": x}
                      for r, t, x in stations]}
        for i, color, icon, title, intro, stations in threads.THREADS
    ]}


def build_story() -> dict:
    return {"eras": [
        {"id": i, "title": title, "period": period, "summary": summary,
         "books": [BOOK[b] for b in books],
         "branches": [{"label": label, "books": [BOOK[b] for b in bs]}
                      for label, bs in branches],
         "key": [{"ref": ref(r), "label": label} for r, label in key]}
        for i, title, period, summary, books, branches, key in story.ERAS
    ]}


def build_people() -> dict:
    return {"people": [
        {**{k: v for k, v in p.items() if k not in ("key", "story", "books")},
         "books": [BOOK[b] for b in p["books"]],
         "key": ref(p["key"]),
         "story": [ref(r) for r in p["story"]]}
        for p in people.P
    ]}


GOSPELS = ["Mt", "Mk", "L", "J"]


def build_tables() -> dict:
    def cell(header: str, c: str):
        if "@" not in c:
            return c
        if not c.startswith("@"):  # „Jonáš@Jon 1“
            text_, r = c.split("@")
            return {"t": text_, "r": ref(r)}
        label = c[1:].replace("-", "–")
        book = label.split(" ")[0]
        if header == book:  # sloupec „Mt“ → jen „13,3–9“
            label = label[len(book) + 1:]
        return {"t": label, "r": ref(c[1:])}

    return {"tables": [
        {**{k: v for k, v in t.items() if k != "rows"},
         "rows": [[cell(t["columns"][i], c) for i, c in enumerate(row)]
                  for row in t["rows"]]}
        for t in tables.T
    ]}


def build_notes() -> dict:
    return {"notes": [
        {"id": f"n{i + 1}", "ref": ref(n["ref"]), "title": n["title"],
         "explanation": n["explanation"], "bridge": n["bridge"],
         "application": n["application"]}
        for i, n in enumerate(notes.N)
    ]}


def build_harmony() -> dict:
    return {"periods": [
        {"name": name, "events": [
            {"title": e[0],
             "refs": [ref(f"{g} {r}") if r else None
                      for g, r in zip(GOSPELS, e[1:])]}
            for e in events]}
        for name, events in harmony.PERIODS
    ]}


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
        bg, conn, how = intros_deep.DEEP[book_id]
        intro.update({"background": bg, "connection": conn,
                      "howToRead": how})
        if e.get("timeline_note"):
            intro["timelineNote"] = e["timeline_note"]
    return data


def main() -> None:
    out = ROOT / "assets" / "content"
    data = {"situations.json": build_situations(),
            "book_intros.json": build_intros(out),
            "people.json": build_people(),
            "harmony.json": build_harmony(),
            "notes.json": build_notes(),
            "tables.json": build_tables(),
            "topics.json": build_topics(),
            "quiz.json": build_quiz(),
            "church_year.json": build_church_year(),
            "threads.json": build_threads(),
            "story.json": build_story()}
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

        what = sys.argv[sys.argv.index("--check") + 2] \
            if len(sys.argv) > sys.argv.index("--check") + 2 else "situations"
        if what == "situations":
            for s in data["situations.json"]["situations"]:
                print(f"\n## {s['title']}")
                for r in s["refs"]:
                    print(f"  {ABBR[r[0]-1]} {r[1]},{r[2]}: {text(*r)[:140]}")
        if what == "church":
            d = data["church_year.json"]
            for s in d["seasons"] + d["feasts"]:
                print(f"\n## {s['name']}")
                for r in s["refs"]:
                    print(f"  {ABBR[r[0]-1]} {r[1]},{r[2]}-{r[3]}: "
                          f"{text(*r)[:230]}")
        if what == "threads":
            for t in data["threads.json"]["threads"]:
                print(f"\n## {t['title']}")
                for st in t["stations"]:
                    r = st["ref"]
                    print(f"  {ABBR[r[0]-1]} {r[1]},{r[2]}-{r[3]} "
                          f"[{st['title']}]: {text(*r)[:200]}")
        if what == "story":
            for e in data["story.json"]["eras"]:
                print(f"\n## {e['title']}")
                for k in e["key"]:
                    r = k["ref"]
                    print(f"  {ABBR[r[0]-1]} {r[1]} [{k['label']}]: "
                          f"{text(r[0], r[1], 1, 3)[:150]}")
        if what == "quiz":
            for x in data["quiz.json"]["questions"]:
                r = x["ref"]
                print(f"{x['question']} → {x['answers'][0]}\n   "
                      f"{ABBR[r[0]-1]} {r[1]},{r[2]}: "
                      f"{text(r[0], r[1], r[2], r[2])[:150]}")
        if what == "topics":
            for t in data["topics.json"]["topics"]:
                print(f"\n## {t['title']}")
                for r, label in zip(t["refs"], t["labels"]):
                    print(f"  {ABBR[r[0]-1]} {r[1]},{r[2]} [{label}]: "
                          f"{text(r[0], r[1], r[2], r[2])[:110]}")
        if what == "harmony":
            for per in data["harmony.json"]["periods"]:
                print(f"\n## {per['name']}")
                for e in per["events"]:
                    print(f"  {e['title']}")
                    for r in e["refs"]:
                        if r:
                            first = text(r[0], r[1], r[2], r[2])
                            last = text(r[0], r[4] if len(r) > 4 else r[1],
                                        r[3], r[3])
                            print(f"     {ABBR[r[0]-1]} {r[1]},{r[2]}: "
                                  f"{first[:55]} … {last[-45:]}")
        if what == "notes":
            for n in data["notes.json"]["notes"]:
                r = n["ref"]
                print(f"{ABBR[r[0]-1]} {r[1]},{r[2]}-{r[3]} {n['title']}: "
                      f"{text(r[0], r[1], r[2], r[2])[:60]} … "
                      f"{text(r[0], r[1], r[3], r[3])[-50:]}")
        if what == "tables":
            for t in data["tables.json"]["tables"]:
                print(f"\n## {t['title']}")
                for row in t["rows"]:
                    for c in row:
                        if isinstance(c, dict):
                            r = c["r"]
                            v = r[2] or 1
                            print(f"   {row[0] if isinstance(row[0], str) else ''}"
                                  f" | {ABBR[r[0]-1]} {r[1]},{r[2]}: "
                                  f"{text(r[0], r[1], v, v)[:70]}")
        if what == "people":
            for p in data["people.json"]["people"]:
                r = p["key"]
                print(f"\n## {p['name']}: {ABBR[r[0]-1]} {r[1]},{r[2]}: "
                      f"{text(*r)[:150]}")
                for r in p["story"]:
                    t = text(r[0], r[1], r[2] or 1, r[3] or 1)
                    print(f"   {ABBR[r[0]-1]} {r[1]},{r[2]}: {t[:70]}")
        return
    for name, d in data.items():
        (out / name).write_text(
            json.dumps(d, ensure_ascii=False, indent=1) + "\n",
            encoding="utf-8")
        print(f"assets/content/{name}")


if __name__ == "__main__":
    main()
