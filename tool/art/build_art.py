"""Sestaví ilustrace do assets/content/illustrations.json.

  python3 tool/art/build_art.py            # zapíše JSON a vypíše mezery
  python3 tool/art/build_art.py --gaps     # jen vypíše kapitoly bez kreseb

Kresby jsou vlastní čárové ilustrace skládané z motivů v kit.py a motifs.py.
Pravidlo pokrytí: ilustrace v každé kapitole (v kanonickém i BKR číslování).
"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(ROOT / "tool"))

import kit  # noqa: E402
import registry  # noqa: E402
from build_content import ABBR, CHAPTERS, ref  # noqa: E402

MODULES = ["scenes_law", "scenes_history", "scenes_prophets", "scenes_gospels",
           "scenes_letters"]
MODULES += [p.stem for p in sorted(HERE.glob("more_*.py"))]


def load():
    for m in MODULES:
        __import__(m)
    return registry.ART


def gaps(items) -> list[str]:
    have = {(r[0], r[1]) for r in items}
    return [f"{ABBR[b - 1]} {c}" for b, n in enumerate(CHAPTERS, start=1)
            for c in range(1, n + 1) if (b, c) not in have]


def gaps_bkr(items) -> list[str]:
    """Kapitoly bez ilustrace v číslování BKR (Jóel 3 kapitoly, Malachiáš 4…)."""
    import vers
    have = {vers.to_bkr(*r[:3])[:2] for r in items}
    counts = list(CHAPTERS)
    counts[28], counts[38] = 3, 4
    return [f"BKR {ABBR[b - 1]} {c}" for b, n in enumerate(counts, start=1)
            for c in range(1, n + 1) if (b, c) not in have]


def main() -> None:
    art = load()
    refs = []
    seen = set()
    for r, cap, _ in art:
        x = ref(r)
        if x[1] > CHAPTERS[x[0] - 1]:
            raise SystemExit(f"Kapitola neexistuje: {r}")
        if (x[0], x[1], x[2]) in seen:
            raise SystemExit(f"Dvě ilustrace u jednoho verše: {r}")
        seen.add((x[0], x[1], x[2]))
        refs.append(x)
    missing = gaps(refs) + gaps_bkr(refs)
    print(f"{len(art)} ilustrací, mezery: {len(missing)}")
    if "--gaps" in sys.argv:
        print(" ".join(missing))
        return
    items = []
    for i, (r, cap, fn) in enumerate(art):
        s = kit.Scene(i + 1)
        s.add(*fn())
        w, h, d = s.render()
        x = ref(r)
        items.append({"r": x[:3], "t": cap, "w": w, "h": h, "d": d})
    items.sort(key=lambda it: it["r"])
    out = ROOT / "assets" / "content" / "illustrations.json"
    out.write_text(json.dumps({"items": items}, ensure_ascii=False,
                              separators=(",", ":")))
    print(f"{out.name}: {out.stat().st_size // 1024} kB")
    if missing:
        print("Mezery:", " ".join(missing))


if __name__ == "__main__":
    main()
