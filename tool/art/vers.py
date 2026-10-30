"""Převod kanonického (hebrejského) číslování na číslování BKR (anglické).

Čte tabulky z lib/domain/services/versification_data.dart, aby build_art
mohl ověřit pokrytí kapitol i v číslování Bible kralické.
"""
import re
from pathlib import Path

_DATA = Path(__file__).resolve().parents[2] / "lib/domain/services/versification_data.dart"


def _runs(name: str) -> dict:
    src = _DATA.read_text()
    body = src.split(f"const {name} =")[1].split(";\n")[0]
    text = "".join(re.findall(r"'([^']*)'", body))
    out: dict = {}
    for item in text.split(";"):
        if item:
            n = list(map(int, item.split()))
            out.setdefault(n[0], []).append(n[1:])
    return out


_H2E = _runs("hebToEngRuns")


def to_bkr(b: int, c: int, v: int) -> tuple[int, int, int]:
    for r in _H2E.get(b, ()):
        if r[0] == c and r[1] <= v < r[1] + r[4]:
            return b, r[2], r[3] + v - r[1]
    return b, c, v


_E2H = _runs("engToHebRuns")


def to_heb(b: int, c: int, v: int) -> tuple[int, int, int]:
    """Číslování BKR (anglické) → kanonické (hebrejské)."""
    for r in _E2H.get(b, ()):
        if r[0] == c and r[1] <= v < r[1] + r[4]:
            return b, r[2], r[3] + v - r[1]
    return b, c, v
