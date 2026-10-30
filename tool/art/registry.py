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
