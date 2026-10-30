"""Seznam ilustrací: (odkaz v kanonickém číslování, popisek, kresba)."""
ART: list = []


def art(ref: str, caption: str):
    def deco(fn):
        ART.append((ref, caption, fn))
        return fn
    return deco


def A(ref: str, caption: str, fn):
    """Zkrácený zápis: A("Gn 5,24", "popisek", lambda: [motivy…])."""
    ART.append((ref, caption, fn))


def K(ref: str, caption: str, fn):
    """Jako A(), ale odkaz je v číslování Bible kralické (anglickém) –
    převede se na kanonické (hebrejské), např. Ž 23,4 → Ž 23,4, Ž 4,8 → Ž 4,9."""
    import sys
    from pathlib import Path
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
    from build_content import ABBR, ref as parse
    from vers import to_heb
    b, c, v = to_heb(*parse(ref)[:3])
    ART.append((f"{ABBR[b - 1]} {c},{v}", caption, fn))
