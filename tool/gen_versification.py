"""Vygeneruje lib/domain/services/versification_data.dart.

Převodní tabulka mezi anglickým číslováním veršů (KJV – používá ho Bible
kralická) a hebrejským číslováním (používají ho ČEP, B21, ČSP).
Zdroj: STEPBible TAHOT (CC BY 4.0) – u každého slova uvádí obě čísla.
Rozdíly v Novém zákoně (jen několik veršů) jsou doplněny ručně a ověřeny
porovnáním textů BKR a ČSP.

Použití: python3 tool/gen_versification.py  (potřebuje data/study_sources,
viz tool/build_study_db.py --fetch)
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import build_study_db as b  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "lib/domain/services/versification_data.dart"

# (kniha, eng kap., eng verš, heb kap., heb verš) – NZ, ověřeno ručně.
NT_E2H = [
    (44, 19, 41, 19, 40),  # Sk 19:40–41 → 19:40
    (47, 13, 13, 13, 12),  # 2K 13:12–13 → 13:12
    (47, 13, 14, 13, 13),
]
NT_H2E = [
    (47, 13, 13, 13, 14),
    (64, 1, 15, 1, 14),    # 3J 15 je v KJV součástí v. 14
    (66, 12, 18, 13, 1),   # Zj 12:18 je v KJV začátek 13:1
]


def runs(pairs):
    """Seřazené dvojice (book, c1, v1, c2, v2) → úseky s délkou."""
    out = []
    for p in sorted(pairs):
        if out:
            bk, c1, v1, c2, v2, n = out[-1]
            if (p[0], p[1], p[3]) == (bk, c1, c2) and p[2] == v1 + n and p[4] == v2 + n:
                out[-1][5] += 1
                continue
        out.append([*p, 1])
    return out


def main():
    e2h, h2e = {}, {}
    for i in range(1, 5):
        for line in (b.SRC / f"TAHOT{i}.txt").open(encoding="utf-8"):
            m = b._REF.match(line)
            if not m or not m.group(4):
                continue
            book = b.STEP_TO_ID[m.group(1)]
            eng = (int(m.group(2)), int(m.group(3)))
            heb = (int(m.group(4)), int(m.group(5)))
            if eng == heb:
                continue
            e2h.setdefault((book, *eng), heb)
            h2e.setdefault((book, *heb), eng)
    # Verše „0“ (nadpisy žalmů v KJV) jsou v BKR součástí verše 1.
    h2e = {k: (c, max(v, 1)) for k, (c, v) in h2e.items()}
    e2h = {k: h for k, h in e2h.items() if k[2] > 0}
    for bk, c1, v1, c2, v2 in NT_E2H:
        e2h[(bk, c1, v1)] = (c2, v2)
    for bk, c1, v1, c2, v2 in NT_H2E:
        h2e[(bk, c1, v1)] = (c2, v2)
    # Nadpis žalmu (heb. v. 1) i první verš míří na BKR v. 1 → neidentické
    # páry, které by se vrátily samy na sebe, vynechat.
    e2h = {k: v for k, v in e2h.items() if (k[1], k[2]) != v}
    h2e = {k: v for k, v in h2e.items() if (k[1], k[2]) != v}

    def emit(name, table):
        rs = runs([(*k, *v) for k, v in table.items()])
        items = [" ".join(map(str, r)) for r in rs]
        lines = [";".join(items[i:i + 8]) for i in range(0, len(items), 8)]
        body = "\n".join(f"    '{line};'" for line in lines)
        return f"const {name} =\n{body};\n"

    OUT.write_text(
        "// GENEROVÁNO skriptem tool/gen_versification.py – needitovat ručně.\n"
        "// Zdroj: STEPBible TAHOT (CC BY 4.0), www.stepbible.org.\n"
        "//\n"
        "// Úseky oddělené „;“, každý šest čísel: kniha, kapitola, verš (zdroj), kapitola,\n"
        "// verš (cíl), délka úseku.\n\n"
        "/// Anglické (KJV, BKR) → hebrejské (ČEP, B21, ČSP) číslování.\n"
        + emit("engToHebRuns", e2h)
        + "\n/// Hebrejské → anglické číslování.\n"
        + emit("hebToEngRuns", h2e),
        encoding="utf-8",
    )
    print(f"{OUT.relative_to(ROOT)}: {len(e2h)} + {len(h2e)} veršů")


if __name__ == "__main__":
    main()
