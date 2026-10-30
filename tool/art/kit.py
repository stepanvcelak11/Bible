"""Kreslicí sada pro jednoduché čárové ilustrace (vlastní kresby aplikace).

Každý motiv vrací seznam tahů; tah = seznam bodů (x, y). Souřadnice jsou
v plátně W × H, osa y míří dolů. Scéna tahy na konci „rozechvěje“, aby
působily jako kresba rukou, a převede je na kompaktní SVG cesty.

Postavy: `person(x, g, h, face, pose, arms, ...)`, kde g je čára země,
h výška postavy ve stoje, face = -1 vlevo, 0 zepředu, 1 vpravo.
"""
import math
import random

W, H = 240, 150

Pt = tuple[float, float]
Stroke = list[Pt]


# --- základní tvary -----------------------------------------------------------

def line(*pts: Pt) -> list[Stroke]:
    return [list(pts)]


def bez(p0: Pt, c: Pt, p1: Pt, n: int = 10) -> Stroke:
    """Kvadratická křivka jako lomená čára."""
    out = []
    for i in range(n + 1):
        t = i / n
        a, b = (1 - t) ** 2, 2 * (1 - t) * t
        out.append((a * p0[0] + b * c[0] + t * t * p1[0],
                    a * p0[1] + b * c[1] + t * t * p1[1]))
    return out


def curve(*pts: Pt) -> list[Stroke]:
    """Hladká křivka přes body (Catmull-Rom)."""
    return [smooth(list(pts))]


def smooth(pts: list[Pt], n: int = 6) -> Stroke:
    if len(pts) < 3:
        return pts
    out = [pts[0]]
    p = [pts[0]] + pts + [pts[-1]]
    for i in range(1, len(p) - 2):
        p0, p1, p2, p3 = p[i - 1], p[i], p[i + 1], p[i + 2]
        for j in range(1, n + 1):
            t = j / n
            t2, t3 = t * t, t * t * t
            out.append(tuple(
                0.5 * (2 * p1[k] + (-p0[k] + p2[k]) * t
                       + (2 * p0[k] - 5 * p1[k] + 4 * p2[k] - p3[k]) * t2
                       + (-p0[k] + 3 * p1[k] - 3 * p2[k] + p3[k]) * t3)
                for k in (0, 1)))
    return out


def ellipse(cx, cy, rx, ry, a0=0.0, a1=360.0, n=None, rot=0.0) -> Stroke:
    n = n or max(8, int(abs(a1 - a0) / 15))
    out = []
    cr, sr = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    for i in range(n + 1):
        a = math.radians(a0 + (a1 - a0) * i / n)
        x, y = rx * math.cos(a), ry * math.sin(a)
        out.append((cx + x * cr - y * sr, cy + x * sr + y * cr))
    return out


def circle(cx, cy, r, a0=0.0, a1=360.0) -> list[Stroke]:
    return [ellipse(cx, cy, r, r, a0, a1)]


def poly(*pts: Pt, closed=False) -> list[Stroke]:
    p = list(pts)
    return [p + [p[0]] if closed else p]


def move(strokes: list[Stroke], dx=0.0, dy=0.0) -> list[Stroke]:
    return [[(x + dx, y + dy) for x, y in s] for s in strokes]


def flip(strokes: list[Stroke], cx: float) -> list[Stroke]:
    return [[(2 * cx - x, y) for x, y in s] for s in strokes]


def scale(strokes: list[Stroke], k: float, ox: float, oy: float):
    return [[(ox + (x - ox) * k, oy + (y - oy) * k) for x, y in s]
            for s in strokes]


def rotate(strokes: list[Stroke], deg: float, ox: float, oy: float):
    c, s_ = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return [[(ox + (x - ox) * c - (y - oy) * s_,
              oy + (x - ox) * s_ + (y - oy) * c) for x, y in s]
            for s in strokes]


def _dir(a: float, d: float) -> Pt:
    """Směr pro úhel ve stupních: 0 = dolů, 90 = dopředu (d), 180 = nahoru."""
    r = math.radians(a)
    return (math.sin(r) * d, math.cos(r))


# --- postavy ------------------------------------------------------------------

ARMS = {
    "down": [(16, -6), (16, -6)],
    "hang": [(3, 0), (3, 0)],
    "pray": [(30, 140), (20, 130)],          # sepjaté ruce před sebou
    "raise": [(155, 170), (150, 165)],       # obě ruce vzhůru
    "open": [(60, 40), (60, 40)],            # rozpřažené dolů
    "wide": [(95, 100), (95, 100)],          # rozpřažené vodorovně
    "point": [(80, 95), (10, 5)],            # ukazuje dopředu
    "bless": [(120, 160), (10, 5)],          # jedna ruka zvednutá
    "hold": [(25, 95), (25, 95)],            # drží něco před sebou
    "give": [(55, 85), (15, 10)],            # podává
    "cry": [(25, 160), (25, 160)],           # ruce u obličeje
    "carry": [(150, 200), (150, 200)],       # nese na hlavě/ramenou
    "back": [(-20, -10), (-20, -10)],
    "reach": [(110, 120), (100, 110)],       # natahuje se dopředu
}


def person(x, g, h=56.0, face=0, pose="stand", arms="down", beard=False,
           veil=False, hair=False, crown=False, staff=None, wings=False,
           child=False, belt=False, bald=False) -> list[Stroke]:
    """Postava v říze. Vrací tahy."""
    f = face if face else 1
    r = h * 0.085
    out: list[Stroke] = []
    side_w = h * (0.11 if face else 0.13)
    hem_w = h * (0.15 if face else 0.17)

    if pose == "lie":
        return _lying(x, g, h, face or 1, beard, veil)
    if pose == "bow":
        return _bowing(x, g, h, f, beard, veil, hair)

    if pose == "kneel":
        top = g - h * 0.74
    elif pose == "sit":
        top = g - h * 0.78
    else:
        top = g - h
    hc = (x + (f * r * 0.15 if face else 0), top + r)
    neck = top + 2 * r + h * 0.01
    sy = neck + h * 0.045
    # hlava
    out.append(ellipse(hc[0], hc[1], r * 0.92, r))
    if face and not child:
        # nos – malý zoubek na straně pohledu
        nx = hc[0] + f * r * 0.92
        out.append([(nx - f * 0.3, hc[1] - r * 0.15),
                    (nx + f * r * 0.28, hc[1] + r * 0.2),
                    (nx - f * 0.2, hc[1] + r * 0.32)])
    if beard:
        bx = hc[0] + f * r * 0.35 if face else hc[0]
        out.append(bez((bx - r * 0.85, hc[1] + r * 0.2),
                       (bx, hc[1] + r * 2.1), (bx + r * 0.85, hc[1] + r * 0.2)))
    if veil:
        out.append(bez((hc[0] - f * r * 1.4, sy + h * 0.06),
                       (hc[0] - f * r * 1.6, top - r * 0.9),
                       (hc[0] + f * r * 0.6, top - r * 0.1)))
        out.append(bez((hc[0] - f * r * 1.0, sy + h * 0.03),
                       (hc[0] - f * r * 0.6, hc[1] + r * 0.3),
                       (hc[0] - f * r * 1.15, hc[1] - r * 0.3)))
    if hair:
        out.append(bez((hc[0] - f * r * 0.7, hc[1] - r * 0.7),
                       (hc[0] - f * r * 1.7, hc[1] + r * 1.0),
                       (hc[0] - f * r * 1.2, sy + h * 0.08)))
    if crown:
        cy = top - r * 0.15
        out.append([(hc[0] - r * 0.7, cy + r * 0.3), (hc[0] - r * 0.75, cy - r * 0.6),
                    (hc[0] - r * 0.35, cy - r * 0.1), (hc[0], cy - r * 0.8),
                    (hc[0] + r * 0.35, cy - r * 0.1), (hc[0] + r * 0.75, cy - r * 0.6),
                    (hc[0] + r * 0.7, cy + r * 0.3)])
    if bald:
        pass

    sl = (x - side_w, sy)
    sr = (x + side_w, sy)
    if pose == "stand" or pose == "walk":
        hem = g - h * 0.035
        lx, rx = x - hem_w, x + hem_w
        if pose == "walk":
            lx -= f * h * 0.03
            rx += f * h * 0.05
            lx, rx = (lx, rx) if f > 0 else (lx, rx)
        out.append(bez((x - side_w * 0.35, neck), (sl[0] - 1, sl[1] - 1),
                       (sl[0], sl[1] + h * 0.04), 5)
                   + bez((sl[0], sl[1] + h * 0.04),
                         (lx + h * 0.01, (sy + hem) / 2), (lx, hem), 8)[1:])
        out.append(bez((x + side_w * 0.35, neck), (sr[0] + 1, sr[1] - 1),
                       (sr[0], sr[1] + h * 0.04), 5)
                   + bez((sr[0], sr[1] + h * 0.04),
                         (rx - h * 0.01, (sy + hem) / 2), (rx, hem), 8)[1:])
        out.append(bez((lx, hem), ((lx + rx) / 2, hem + h * 0.02), (rx, hem), 8))
        # nohy
        if pose == "walk":
            out.append([(x - f * h * 0.08, hem), (x - f * h * 0.12, g),
                        (x - f * h * 0.06, g)])
            out.append([(x + f * h * 0.08, hem), (x + f * h * 0.1, g),
                        (x + f * h * 0.16, g)])
        elif face:
            out.append([(x - h * 0.05, hem + 1), (x - h * 0.05, g),
                        (x - h * 0.05 + f * h * 0.06, g)])
            out.append([(x + h * 0.04, hem + 1), (x + h * 0.04, g),
                        (x + h * 0.04 + f * h * 0.06, g)])
        else:
            out.append([(x - h * 0.05, hem + 1), (x - h * 0.06, g),
                        (x - h * 0.11, g)])
            out.append([(x + h * 0.05, hem + 1), (x + h * 0.06, g),
                        (x + h * 0.11, g)])
        # záhyb říze
        out.append(bez((x + f * h * 0.02, sy + h * 0.25),
                       (x + f * h * 0.05, sy + h * 0.45), (x + f * h * 0.03, hem - 2), 6))
        if belt:
            by = sy + h * 0.24
            out.append([(x - side_w * 1.05, by), (x + side_w * 1.05, by + 0.5)])
    elif pose == "kneel":
        hip = g - h * 0.26
        knee = (x + f * h * 0.2, g)
        heel = (x - f * h * 0.17, g)
        back = sl if f > 0 else sr
        front = sr if f > 0 else sl
        out.append(bez((x - f * side_w * 0.35, neck), (back[0] - f, back[1] - 1),
                       back, 4) + bez(back, (x - f * h * 0.17, hip), heel, 8)[1:])
        out.append(bez((x + f * side_w * 0.35, neck), (front[0] + f, front[1] - 1),
                       front, 4) + bez(front, (x + f * h * 0.1, hip - h * 0.05),
                                        (x + f * h * 0.08, hip), 6)[1:]
                   + bez((x + f * h * 0.08, hip), (knee[0] + f * 2, hip + 1),
                         knee, 6)[1:])
        out.append(bez(heel, ((heel[0] + knee[0]) / 2, g + 1), knee, 6))
        out.append([(heel[0], g - 1), (heel[0] - f * h * 0.08, g)])
    elif pose == "sit":
        seat = g - h * 0.27
        hip_b = (x - f * h * 0.1, seat)
        knee = (x + f * h * 0.2, seat - h * 0.02)
        foot = (x + f * h * 0.21, g)
        back = sl if f > 0 else sr
        front = sr if f > 0 else sl
        out.append(bez((x - f * side_w * 0.35, neck), (back[0] - f, back[1] - 1),
                       back, 4) + bez(back, (hip_b[0] - f, (sy + seat) / 2),
                                       hip_b, 6)[1:])
        out.append(bez((x + f * side_w * 0.35, neck), (front[0] + f, front[1] - 1),
                       front, 4) + bez(front, (x + f * h * 0.06, seat - h * 0.12),
                                        (x + f * h * 0.03, seat - h * 0.08), 4)[1:]
                   + bez((x + f * h * 0.03, seat - h * 0.08),
                         (x + f * h * 0.12, seat - h * 0.09), knee, 4)[1:]
                   + bez(knee, (knee[0] + f * 1.5, (seat + g) / 2),
                         (foot[0], g - h * 0.04), 5)[1:])
        out.append(bez(hip_b, ((hip_b[0] + knee[0]) / 2, seat + h * 0.02),
                       (knee[0] - f * h * 0.02, seat + h * 0.03), 5)
                   + bez((knee[0] - f * h * 0.02, seat + h * 0.03),
                         (knee[0] - f * h * 0.04, (seat + g) / 2),
                         (foot[0] - f * h * 0.07, g - h * 0.04), 4)[1:])
        out.append([(foot[0] - f * h * 0.06, g - h * 0.04), (foot[0] - f * h * 0.05, g),
                    (foot[0] + f * h * 0.04, g)])
    # paže
    ua, fa = h * 0.2, h * 0.19
    if child:
        ua, fa = h * 0.17, h * 0.16
    spec = ARMS[arms] if isinstance(arms, str) else arms
    for i, (a1, a2) in enumerate(spec):
        if face:
            d = f
            sx = x + f * side_w * (0.75 if i == 0 else -0.55)
        else:
            d = -1 if i == 0 else 1
            sx = x + d * side_w * 0.92
        s = (sx, sy + h * 0.02)
        e1 = _dir(a1, d)
        el = (s[0] + e1[0] * ua, s[1] + e1[1] * ua)
        e2 = _dir(a2, d)
        hd = (el[0] + e2[0] * fa, el[1] + e2[1] * fa)
        out.append(smooth([s, (s[0] * 0.5 + el[0] * 0.5 + e1[1] * d * 0.6,
                               s[1] * 0.5 + el[1] * 0.5), el, hd], 3))
        out.append(ellipse(hd[0], hd[1], h * 0.018, h * 0.022))
        if staff is not None and i == staff:
            out.append([(hd[0], hd[1] - h * 0.45), (hd[0], g)])
            out.append(bez((hd[0], hd[1] - h * 0.45),
                           (hd[0] + d * h * 0.1, hd[1] - h * 0.55),
                           (hd[0] + d * h * 0.07, hd[1] - h * 0.4), 5))
    if wings:
        for d in (-1, 1):
            wx = x + d * side_w * 0.6
            out.append(smooth([(wx, sy + 2), (wx + d * h * 0.28, sy - h * 0.22),
                               (wx + d * h * 0.42, sy - h * 0.12),
                               (wx + d * h * 0.3, sy + h * 0.12),
                               (wx + d * h * 0.12, sy + h * 0.3)], 4))
            out.append(bez((wx + d * h * 0.12, sy + h * 0.05),
                           (wx + d * h * 0.25, sy - h * 0.05),
                           (wx + d * h * 0.33, sy - h * 0.08), 4))
    return out


def _lying(x, g, h, f, beard, veil) -> list[Stroke]:
    r = h * 0.085
    out = [ellipse(x, g - r * 1.1, r, r * 0.92)]
    if beard:
        out.append(bez((x + f * r * 0.2, g - r * 0.1), (x + f * r * 1.4, g),
                       (x + f * r * 0.9, g - r * 1.6)))
    x0 = x + f * r * 1.3
    x1 = x + f * h * 0.95
    top = g - h * 0.17
    out.append(smooth([(x0, g - r * 1.9), (x0 + f * h * 0.2, top),
                       (x0 + f * h * 0.5, top + h * 0.03),
                       (x1 - f * h * 0.08, g - h * 0.08), (x1, g - h * 0.05)], 4))
    out.append(bez((x0, g), ((x0 + x1) / 2, g + 1), (x1, g), 6))
    out.append([(x1, g - h * 0.07), (x1 + f * h * 0.04, g - h * 0.1),
                (x1 + f * h * 0.05, g)])
    out.append(bez((x0 + f * h * 0.2, top + h * 0.03), (x0 + f * h * 0.3, g - 3),
                   (x0 + f * h * 0.42, g - h * 0.05), 5))
    return out


def _bowing(x, g, h, f, beard, veil, hair) -> list[Stroke]:
    r = h * 0.085
    head = (x + f * h * 0.3, g - r * 1.1)
    out = [ellipse(head[0], head[1], r * 0.92, r)]
    if veil or hair:
        out.append(bez((head[0] - f * r, head[1] - r * 0.4),
                       (head[0] - f * r * 1.4, head[1] - r * 1.5),
                       (head[0] - f * r * 2.4, head[1] - r * 1.2)))
    hip = (x - f * h * 0.16, g - h * 0.22)
    out.append(smooth([(x - f * h * 0.24, g), hip, (x, g - h * 0.33),
                       (head[0] - f * r * 1.6, head[1] - r * 1.4)], 5))
    out.append(bez((x - f * h * 0.24, g), (x, g + 1), (x + f * h * 0.06, g), 5))
    out.append(bez((x + f * h * 0.02, g - h * 0.12), (x + f * h * 0.15, g - h * 0.05),
                   (head[0] + f * r * 0.8, g - 0.5), 5))
    out.append([(x - f * h * 0.24, g - 1), (x - f * h * 0.32, g)])
    return out


def crowd(x0, x1, g, h=40.0, n=None, seed=1, faces=None) -> list[Stroke]:
    """Zástup: hlavy a ramena v několika řadách."""
    rnd = random.Random(seed)
    n = n or max(3, int((x1 - x0) / (h * 0.28)))
    out = []
    for row in range(2):
        hh = h * (0.9 if row == 0 else 1.0)
        yy = g - (h * 0.12 if row == 0 else 0)
        m = n - row
        for i in range(m):
            x = x0 + (x1 - x0) * (i + 0.5 + row * 0.5 - 0.25) / n
            x += rnd.uniform(-2, 2)
            top = yy - hh + rnd.uniform(-2, 2)
            r = hh * 0.085
            out.append(ellipse(x, top + r, r * 0.92, r))
            sw = hh * 0.13
            neck = top + 2 * r + 1
            out.append(bez((x - sw * 1.2, neck + hh * 0.25),
                           (x - sw * 1.1, neck), (x, neck), 4)
                       + bez((x, neck), (x + sw * 1.1, neck),
                             (x + sw * 1.2, neck + hh * 0.25), 4)[1:])
    return out


# --- zvířata ------------------------------------------------------------------

def sheep(x, g, s=1.0, face=1) -> list[Stroke]:
    f = face
    out = []
    bx, by, rx, ry = x, g - 9 * s, 9 * s, 5.5 * s
    pts = []
    for i in range(10):
        a = math.radians(i * 36 + 10)
        cx, cy = bx + rx * math.cos(a), by + ry * math.sin(a)
        pts += ellipse(cx, cy, 2.6 * s, 2.4 * s, i * 36 - 60 + 10,
                       i * 36 + 120 + 10, 6)
    out.append(pts[:-6] if f > 0 else pts)
    hx = bx + f * 10.5 * s
    out.append(ellipse(hx, by - 3.5 * s, 2.6 * s, 3.3 * s, rot=f * 30))
    out.append([(hx - f * 1.5 * s, by - 6 * s), (hx - f * 4.5 * s, by - 5 * s)])
    for lx in (-5, -2.5, 3, 5.5):
        out.append([(bx + lx * s, by + 4.5 * s), (bx + lx * s, g)])
    return out


def donkey(x, g, s=1.0, face=1, horse=False) -> list[Stroke]:
    f = face
    out = []
    top = g - 15 * s
    out.append(smooth([(x - f * 11 * s, top + 4 * s), (x - f * 4 * s, top),
                       (x + f * 6 * s, top + 0.5 * s), (x + f * 9 * s, top - 1 * s)], 4))
    out.append(smooth([(x - f * 11 * s, top + 4 * s), (x - f * 11.5 * s, top + 8 * s),
                       (x - f * 8 * s, top + 9 * s), (x + f * 7 * s, top + 9 * s),
                       (x + f * 9 * s, top + 4 * s)], 4))
    # krk a hlava
    out.append(smooth([(x + f * 9 * s, top - 1 * s), (x + f * 12 * s, top - 8 * s),
                       (x + f * 18 * s, top - 4 * s), (x + f * 17 * s, top - 2 * s),
                       (x + f * 12 * s, top - 3 * s), (x + f * 9 * s, top + 4 * s)], 4))
    if horse:
        out.append([(x + f * 12 * s, top - 8 * s), (x + f * 11 * s, top - 11 * s),
                    (x + f * 13.5 * s, top - 8.5 * s)])
        out.append(bez((x + f * 11 * s, top - 7 * s), (x + f * 7 * s, top - 4 * s),
                       (x + f * 9 * s, top - 0.5 * s), 4))
    else:
        out.append([(x + f * 11.5 * s, top - 7.5 * s), (x + f * 8.5 * s, top - 13 * s),
                    (x + f * 12.5 * s, top - 8.5 * s)])
        out.append([(x + f * 12.5 * s, top - 7.5 * s), (x + f * 12 * s, top - 13.5 * s),
                    (x + f * 13.8 * s, top - 7.8 * s)])
    for lx in (-9, -6.5, 5, 7.5):
        out.append([(x + f * lx * s, top + 9 * s), (x + f * lx * s, g)])
    out.append(bez((x - f * 11.5 * s, top + 4 * s), (x - f * 14 * s, top + 8 * s),
                   (x - f * 13 * s, top + 12 * s), 4))
    return out


def camel(x, g, s=1.0, face=1) -> list[Stroke]:
    f = face
    top = g - 20 * s
    out = [smooth([(x - f * 12 * s, top + 6 * s), (x - f * 6 * s, top - 3 * s),
                   (x + f * 0 * s, top + 3 * s), (x + f * 5 * s, top - 1 * s),
                   (x + f * 10 * s, top + 4 * s), (x + f * 15 * s, top - 6 * s),
                   (x + f * 19 * s, top - 6 * s)], 4),
           smooth([(x - f * 12 * s, top + 6 * s), (x - f * 10 * s, top + 11 * s),
                   (x + f * 8 * s, top + 11 * s), (x + f * 11 * s, top + 7 * s),
                   (x + f * 15 * s, top - 3 * s), (x + f * 19 * s, top - 4 * s)], 4)]
    for lx in (-9, -6, 5, 8):
        out.append([(x + f * lx * s, top + 11 * s), (x + f * (lx + 0.5) * s, g)])
    return out


def lion(x, g, s=1.0, face=1) -> list[Stroke]:
    f = face
    top = g - 14 * s
    out = [smooth([(x - f * 11 * s, top + 3 * s), (x + f * 4 * s, top + 1 * s)], 2),
           smooth([(x - f * 11 * s, top + 3 * s), (x - f * 11 * s, top + 8 * s),
                   (x + f * 6 * s, top + 8 * s)], 3)]
    hx, hy = x + f * 9 * s, top + 1 * s
    mane = []
    for i in range(12):
        a = i * 30
        mane += ellipse(hx + 6 * s * math.cos(math.radians(a)),
                        hy + 6 * s * math.sin(math.radians(a)), 2.2 * s, 2.2 * s,
                        a - 70, a + 110, 5)
    out.append(mane)
    out.append(ellipse(hx + f * 0.5 * s, hy + 0.5 * s, 3.4 * s, 3.6 * s))
    for lx in (-9, -6, 3, 6):
        out.append([(x + f * lx * s, top + 8 * s), (x + f * lx * s, g)])
    out.append(smooth([(x - f * 11 * s, top + 3 * s), (x - f * 16 * s, top + 2 * s),
                       (x - f * 17 * s, top - 3 * s)], 3))
    out.append(circle(x - f * 17 * s, top - 4 * s, 1.2 * s)[0])
    return out


def ox(x, g, s=1.0, face=1) -> list[Stroke]:
    out = donkey(x, g, s * 1.1, face, horse=True)[:2]
    f = face
    top = g - 16.5 * s
    out.append(smooth([(x + f * 9.9 * s, top - 1 * s), (x + f * 13 * s, top - 4 * s),
                       (x + f * 18 * s, top + 1 * s), (x + f * 16 * s, top + 4 * s),
                       (x + f * 12 * s, top + 3 * s), (x + f * 9.9 * s, top + 4.5 * s)], 4))
    out.append(bez((x + f * 12 * s, top - 4 * s), (x + f * 10 * s, top - 9 * s),
                   (x + f * 14 * s, top - 9 * s), 4))
    for lx in (-9, -6.5, 5, 7.5):
        out.append([(x + f * lx * s * 1.1, g - 6.6 * s), (x + f * lx * s * 1.1, g)])
    return out


def fish(x, y, s=1.0, face=1) -> list[Stroke]:
    f = face
    return [smooth([(x + f * 8 * s, y), (x, y - 3.5 * s), (x - f * 7 * s, y + 1 * s),
                    (x - f * 10 * s, y + 3 * s)], 4),
            smooth([(x + f * 8 * s, y), (x, y + 3.5 * s), (x - f * 7 * s, y - 1 * s),
                    (x - f * 10 * s, y - 3 * s)], 4),
            circle(x + f * 4.5 * s, y - 0.5 * s, 0.6 * s)[0]]


def bird(x, y, s=1.0, face=1, dove=False) -> list[Stroke]:
    """Letící pták (u holubice s tělem a hlavou)."""
    f = face
    if not dove:
        return [bez((x - 5 * s, y - 1.5 * s), (x - 2 * s, y - 3 * s), (x, y), 4)
                + bez((x, y), (x + 2 * s, y - 3 * s), (x + 5 * s, y - 1.5 * s), 4)[1:]]
    return [smooth([(x - f * 9 * s, y - 1 * s), (x - f * 3 * s, y + 2.5 * s),
                    (x + f * 4 * s, y + 2 * s), (x + f * 7 * s, y - 1 * s)], 3),
            smooth([(x - f * 9 * s, y - 1 * s), (x - f * 3 * s, y - 0.5 * s),
                    (x + f * 4 * s, y - 1.5 * s), (x + f * 7 * s, y - 1 * s)], 3),
            circle(x + f * 7.5 * s, y - 2.2 * s, 1.5 * s)[0],
            [(x + f * 9 * s, y - 2.2 * s), (x + f * 10.5 * s, y - 1.8 * s)],
            smooth([(x - f * 2 * s, y - 1 * s), (x - f * 6 * s, y - 6 * s),
                    (x - f * 9 * s, y - 12 * s), (x - f * 1 * s, y - 7 * s),
                    (x + f * 2 * s, y - 1.5 * s)], 3),
            smooth([(x + f * 0 * s, y - 1.5 * s), (x + f * 1 * s, y - 8 * s),
                    (x + f * 4 * s, y - 12 * s), (x + f * 4 * s, y - 5 * s),
                    (x + f * 3 * s, y - 1.5 * s)], 3)]


def snake(x, y, s=1.0, face=1) -> list[Stroke]:
    f = face
    return [smooth([(x - f * 14 * s, y + 2 * s), (x - f * 9 * s, y - 2 * s),
                    (x - f * 4 * s, y + 2 * s), (x + f * 1 * s, y - 2 * s),
                    (x + f * 4 * s, y - 7 * s), (x + f * 2 * s, y - 11 * s),
                    (x + f * 5 * s, y - 13 * s)], 4),
            ellipse(x + f * 6.5 * s, y - 13 * s, 2.2 * s, 1.5 * s),
            [(x + f * 8.5 * s, y - 13 * s), (x + f * 11 * s, y - 13 * s),
             (x + f * 12.5 * s, y - 14.5 * s)],
            [(x + f * 11 * s, y - 13 * s), (x + f * 12.5 * s, y - 12 * s)]]


# --- příroda a předměty -------------------------------------------------------

def ground(x0, x1, g, seed=0) -> list[Stroke]:
    rnd = random.Random(seed)
    out, x = [], x0
    while x < x1:
        w = rnd.uniform(18, 40)
        out.append([(x, g + rnd.uniform(-0.5, 0.5)),
                    (min(x + w, x1), g + rnd.uniform(-0.5, 0.5))])
        x += w + rnd.uniform(3, 8)
    return out


def tufts(x0, x1, g, n=4, seed=0) -> list[Stroke]:
    rnd = random.Random(seed)
    out = []
    for _ in range(n):
        x = rnd.uniform(x0, x1)
        out.append([(x - 2, g - 3), (x, g)])
        out.append([(x + 1.5, g - 4), (x + 0.5, g)])
    return out


def tree(x, g, h=50.0, kind="round") -> list[Stroke]:
    out = [[(x - 1.5, g), (x - 1, g - h * 0.45)], [(x + 1.5, g), (x + 1, g - h * 0.45)]]
    if kind == "palm":
        out = [smooth([(x - 1.5, g), (x - 2, g - h * 0.5), (x + 1, g - h)], 4),
               smooth([(x + 1.5, g), (x + 1, g - h * 0.5), (x + 3, g - h)], 4)]
        top = (x + 2, g - h)
        for a, l in ((-160, 0.4), (-130, 0.45), (-50, 0.45), (-20, 0.4), (-95, 0.3)):
            ex = top[0] + math.cos(math.radians(a)) * h * l
            ey = top[1] + math.sin(math.radians(a)) * h * l * 0.6 + h * 0.15
            out.append(bez(top, ((top[0] + ex) / 2, top[1] - h * 0.12), (ex, ey), 6))
        return out
    cy = g - h * 0.68
    rx, ry = h * 0.32, h * 0.3
    pts = []
    for i in range(9):
        a = i * 40
        pts += ellipse(x + rx * math.cos(math.radians(a)),
                       cy + ry * math.sin(math.radians(a)), h * 0.12, h * 0.11,
                       a - 80, a + 100, 5)
    out.append(pts)
    out.append([(x, g - h * 0.45), (x - h * 0.1, g - h * 0.58)])
    return out


def bush(x, g, w=20.0, fire=False) -> list[Stroke]:
    out = []
    pts = []
    for i in range(6):
        cx = x - w / 2 + w * (i + 0.5) / 6
        pts += ellipse(cx, g - w * 0.3 - (i % 2) * w * 0.12, w * 0.12, w * 0.2, 180, 360, 6)
    out.append(pts)
    out.append([(x - w / 2, g), (x + w / 2, g)])
    if fire:
        out += flames(x, g - w * 0.55, w * 0.8)
    return out


def flames(x, y, w=20.0) -> list[Stroke]:
    out = []
    for i, k in enumerate((-0.35, 0, 0.35)):
        hh = w * (1.0 if k == 0 else 0.7)
        cx = x + k * w
        out.append(smooth([(cx - w * 0.15, y), (cx - w * 0.12, y - hh * 0.5),
                           (cx + w * 0.02, y - hh * 0.75), (cx - w * 0.02, y - hh)], 3)
                   + smooth([(cx - w * 0.02, y - hh), (cx + w * 0.14, y - hh * 0.5),
                             (cx + w * 0.15, y)], 3)[1:])
    return out


def mountain(x, g, w=80.0, h=40.0, snow=False) -> list[Stroke]:
    p = smooth([(x - w / 2, g), (x - w * 0.2, g - h * 0.65), (x - w * 0.05, g - h),
                (x + w * 0.08, g - h * 0.85), (x + w * 0.25, g - h * 0.55),
                (x + w / 2, g)], 4)
    out = [p, bez((x - w * 0.05, g - h), (x - w * 0.02, g - h * 0.6),
                  (x - w * 0.12, g - h * 0.3), 5)]
    return out


def hills(x0, x1, g, h=12.0) -> list[Stroke]:
    w = x1 - x0
    return [smooth([(x0, g), (x0 + w * 0.25, g - h), (x0 + w * 0.55, g - h * 0.4),
                    (x0 + w * 0.8, g - h * 0.9), (x1, g - h * 0.2)], 5)]


def waves(x0, x1, y, n=None, amp=2.0) -> list[Stroke]:
    n = n or int((x1 - x0) / 10)
    out = []
    pts = []
    for i in range(n * 2 + 1):
        pts.append((x0 + (x1 - x0) * i / (n * 2), y + (amp if i % 2 else -amp)))
    out.append(smooth(pts, 3))
    return out


def sea(x0, x1, y, rows=3, gap=7.0) -> list[Stroke]:
    out = []
    for r in range(rows):
        off = (r % 2) * 5
        out += waves(x0 + off, x1 - 5 + off, y + r * gap, amp=1.6 - r * 0.3)
    return out


def boat(x, y, w=60.0, sail=False, mast=True) -> list[Stroke]:
    out = [smooth([(x - w / 2 - 4, y - w * 0.16), (x - w * 0.4, y),
                   (x + w * 0.4, y), (x + w / 2 + 4, y - w * 0.16)], 4),
           [(x - w / 2 - 4, y - w * 0.16), (x + w / 2 + 4, y - w * 0.16)],
           bez((x - w * 0.45, y - w * 0.08), (x, y - w * 0.04), (x + w * 0.45, y - w * 0.08), 6)]
    if mast:
        out.append([(x, y - w * 0.16), (x, y - w * 0.9)])
        if sail:
            out.append(smooth([(x, y - w * 0.85), (x + w * 0.3, y - w * 0.55),
                               (x + w * 0.36, y - w * 0.25)], 4))
            out.append([(x, y - w * 0.25), (x + w * 0.36, y - w * 0.25)])
    return out


def sun(x, y, r=8.0, rays=True) -> list[Stroke]:
    out = circle(x, y, r)
    if rays:
        for i in range(10):
            a = math.radians(i * 36)
            out.append([(x + math.cos(a) * (r + 2.5), y + math.sin(a) * (r + 2.5)),
                        (x + math.cos(a) * (r + 6), y + math.sin(a) * (r + 6))])
    return out


def moon(x, y, r=7.0) -> list[Stroke]:
    """Srpek měsíce."""
    outer = ellipse(x, y, r, r, 70, 290, 14)
    inner = ellipse(x + r * 0.45, y, r * 0.8, r * 0.82, 245, 115, 10)
    return [outer + inner[1:]]


def star(x, y, r=4.0, points=5) -> list[Stroke]:
    pts = []
    for i in range(points * 2 + 1):
        a = math.radians(-90 + i * 180 / points)
        rr = r if i % 2 == 0 else r * 0.45
        pts.append((x + math.cos(a) * rr, y + math.sin(a) * rr))
    return [pts]


def sparkle(x, y, r=3.0) -> list[Stroke]:
    return [[(x - r, y), (x + r, y)], [(x, y - r), (x, y + r)]]


def stars(points, r=2.5) -> list[Stroke]:
    out = []
    for i, (x, y) in enumerate(points):
        out += sparkle(x, y, r * (0.7 + (i % 3) * 0.2))
    return out


def rays(x, y, r0=6.0, r1=30.0, a0=40.0, a1=140.0, n=7) -> list[Stroke]:
    out = []
    for i in range(n):
        a = math.radians(a0 + (a1 - a0) * i / (n - 1))
        out.append([(x + math.cos(a) * r0, y + math.sin(a) * r0),
                    (x + math.cos(a) * r1, y + math.sin(a) * r1)])
    return out


def cloud(x, y, w=30.0) -> list[Stroke]:
    pts = []
    for i, (dx, dy, r) in enumerate(((-0.35, 0.05, 0.18), (-0.15, -0.12, 0.22),
                                      (0.12, -0.15, 0.25), (0.35, 0.02, 0.18))):
        pts += ellipse(x + dx * w, y + dy * w, r * w, r * w * 0.85, 160, 360 + 20, 7)
    out = [pts, bez((x - w * 0.5, y + w * 0.1), (x, y + w * 0.14), (x + w * 0.5, y + w * 0.1), 6)]
    return out


def rain(x0, x1, y0, y1, n=8, seed=0) -> list[Stroke]:
    rnd = random.Random(seed)
    out = []
    for _ in range(n):
        x = rnd.uniform(x0, x1)
        y = rnd.uniform(y0, y1 - 6)
        out.append([(x, y), (x - 1.5, y + 6)])
    return out


def rainbow(x, g, r=60.0) -> list[Stroke]:
    return [ellipse(x, g, r - i * 4, (r - i * 4) * 0.8, 180, 360, 24) for i in range(3)]


def house(x, g, w=30.0, h=22.0, door=True, flat=True) -> list[Stroke]:
    out = [[(x - w / 2, g), (x - w / 2, g - h), (x + w / 2, g - h), (x + w / 2, g)]]
    if flat:
        out.append([(x - w / 2 - 2, g - h), (x + w / 2 + 2, g - h - 0.5)])
    else:
        out.append([(x - w / 2 - 3, g - h + 1), (x, g - h - w * 0.4), (x + w / 2 + 3, g - h + 1)])
    if door:
        out.append([(x - w * 0.1, g), (x - w * 0.1, g - h * 0.5),
                    (x + w * 0.12, g - h * 0.5), (x + w * 0.12, g)])
    out.append([(x + w * 0.25, g - h * 0.7), (x + w * 0.38, g - h * 0.7),
                (x + w * 0.38, g - h * 0.55), (x + w * 0.25, g - h * 0.55),
                (x + w * 0.25, g - h * 0.7)])
    return out


def city(x0, x1, g, h=30.0, seed=3, gate=True) -> list[Stroke]:
    """Hradby s věžemi a domy za nimi."""
    rnd = random.Random(seed)
    w = x1 - x0
    out = []
    wall = h * 0.5
    # domy za hradbou
    x = x0 + 4
    while x < x1 - 10:
        bw = rnd.uniform(8, 14)
        bh = rnd.uniform(wall + 4, h)
        out.append([(x, g - wall), (x, g - bh), (x + bw, g - bh), (x + bw, g - wall)])
        if rnd.random() < 0.3:
            out.append(ellipse(x + bw / 2, g - bh, bw / 2, bw / 2.4, 180, 360, 8))
        x += bw + rnd.uniform(-2, 3)
    # hradba s cimbuřím
    pts = [(x0, g), (x0, g - wall - 6)]
    tw = 10
    pts += [(x0 + tw, g - wall - 6), (x0 + tw, g - wall)]
    xx = x0 + tw
    while xx < x1 - tw - 6:
        pts += [(xx + 3, g - wall), (xx + 3, g - wall - 2.5), (xx + 6, g - wall - 2.5),
                (xx + 6, g - wall)]
        xx += 6
    pts += [(x1 - tw, g - wall), (x1 - tw, g - wall - 6), (x1, g - wall - 6), (x1, g)]
    out.append(pts)
    if gate:
        gx = (x0 + x1) / 2
        out.append([(gx - 5, g)] + ellipse(gx, g - wall * 0.55, 5, 4, 180, 360, 8)
                   + [(gx + 5, g)])
    return out


def tent(x, g, w=34.0, h=20.0) -> list[Stroke]:
    return [[(x - w / 2, g), (x - w * 0.15, g - h), (x + w * 0.25, g - h * 0.95), (x + w / 2, g)],
            [(x - w * 0.15, g - h), (x - w * 0.05, g)],
            [(x - w * 0.15, g - h), (x + w * 0.08, g)],
            [(x - w / 2 - 5, g), (x - w * 0.3, g - h * 0.55)]]


def well(x, g, w=18.0) -> list[Stroke]:
    return [ellipse(x, g - 10, w / 2, 2.5),
            [(x - w / 2, g - 10), (x - w / 2, g)], [(x + w / 2, g - 10), (x + w / 2, g)],
            bez((x - w / 2, g), (x, g + 2.5), (x + w / 2, g), 6),
            [(x - w * 0.15, g - 6), (x - w * 0.1, g - 1)]]


def table(x, g, w=60.0, h=14.0) -> list[Stroke]:
    return [[(x - w / 2, g - h), (x + w / 2, g - h)],
            [(x - w / 2 + 3, g - h), (x - w / 2 + 4, g)],
            [(x + w / 2 - 3, g - h), (x + w / 2 - 4, g)]]


def bread(x, y, w=8.0) -> list[Stroke]:
    return [ellipse(x, y - w * 0.25, w / 2, w * 0.28, 180, 360, 8) + [(x + w / 2, y), (x - w / 2, y)],
            [(x - w * 0.15, y - w * 0.4), (x - w * 0.05, y - w * 0.25)],
            [(x + w * 0.12, y - w * 0.42), (x + w * 0.2, y - w * 0.27)]]


def cup(x, y, s=1.0) -> list[Stroke]:
    return [ellipse(x, y - 9 * s, 4 * s, 1.2 * s),
            bez((x - 4 * s, y - 9 * s), (x - 3.5 * s, y - 4 * s), (x, y - 4 * s), 4)
            + bez((x, y - 4 * s), (x + 3.5 * s, y - 4 * s), (x + 4 * s, y - 9 * s), 4)[1:],
            [(x, y - 4 * s), (x, y - 1 * s)], [(x - 2.5 * s, y), (x + 2.5 * s, y)]]


def jar(x, g, s=1.0) -> list[Stroke]:
    return [smooth([(x - 2 * s, g - 16 * s), (x - 2.5 * s, g - 13 * s), (x - 6 * s, g - 9 * s),
                    (x - 4 * s, g - 1 * s), (x, g)], 3)
            + smooth([(x, g), (x + 4 * s, g - 1 * s), (x + 6 * s, g - 9 * s),
                      (x + 2.5 * s, g - 13 * s), (x + 2 * s, g - 16 * s)], 3)[1:],
            ellipse(x, g - 16 * s, 2.6 * s, 0.9 * s)]


def lamp(x, y, s=1.0, lit=True) -> list[Stroke]:
    out = [smooth([(x - 6 * s, y - 2 * s), (x - 3 * s, y), (x + 4 * s, y),
                   (x + 7 * s, y - 2.5 * s)], 3),
           smooth([(x - 6 * s, y - 2 * s), (x - 1 * s, y - 4 * s), (x + 4 * s, y - 3 * s),
                   (x + 7 * s, y - 2.5 * s)], 3)]
    if lit:
        out += [smooth([(x + 6.5 * s, y - 3 * s), (x + 6 * s, y - 6 * s), (x + 7.5 * s, y - 9 * s),
                        (x + 8 * s, y - 5 * s), (x + 7 * s, y - 3 * s)], 3)]
    return out


def scroll(x, y, w=26.0, h=14.0, text=True) -> list[Stroke]:
    out = [ellipse(x - w / 2, y, 2.5, h / 2), ellipse(x + w / 2, y, 2.5, h / 2),
           [(x - w / 2, y - h / 2), (x + w / 2, y - h / 2)],
           [(x - w / 2, y + h / 2), (x + w / 2, y + h / 2)]]
    if text:
        for i in range(3):
            yy = y - h / 2 + h * (i + 1) / 4
            out.append([(x - w / 2 + 5, yy), (x + w / 2 - 5 - (i == 2) * 6, yy)])
    return out


def book(x, y, w=22.0, h=14.0) -> list[Stroke]:
    return [[(x, y + h / 2), (x, y - h / 2)],
            bez((x, y - h / 2), (x - w * 0.25, y - h / 2 - 2), (x - w / 2, y - h / 2), 4)
            + [(x - w / 2, y + h / 2)]
            + bez((x - w / 2, y + h / 2), (x - w * 0.25, y + h / 2 - 2), (x, y + h / 2), 4)[1:],
            bez((x, y - h / 2), (x + w * 0.25, y - h / 2 - 2), (x + w / 2, y - h / 2), 4)
            + [(x + w / 2, y + h / 2)]
            + bez((x + w / 2, y + h / 2), (x + w * 0.25, y + h / 2 - 2), (x, y + h / 2), 4)[1:],
            [(x - w * 0.38, y - h * 0.15), (x - w * 0.1, y - h * 0.2)],
            [(x + w * 0.1, y - h * 0.2), (x + w * 0.38, y - h * 0.15)],
            [(x - w * 0.38, y + h * 0.1), (x - w * 0.1, y + h * 0.05)],
            [(x + w * 0.1, y + h * 0.05), (x + w * 0.38, y + h * 0.1)]]


def tablets(x, g, h=26.0) -> list[Stroke]:
    w = h * 0.42
    out = []
    for dx in (-w * 0.52, w * 0.52):
        cx = x + dx
        out.append([(cx - w / 2, g)] + ellipse(cx, g - h + w / 2, w / 2, w / 2, 180, 360, 8)
                   + [(cx + w / 2, g)])
        for i in range(4):
            yy = g - h + w * 0.7 + i * h * 0.14
            out.append([(cx - w * 0.3, yy), (cx + w * 0.3, yy)])
    return out


def cross(x, g, h=60.0, w=None) -> list[Stroke]:
    w = w or h * 0.5
    return [[(x - 1.5, g), (x - 1.5, g - h)], [(x + 1.5, g), (x + 1.5, g - h)],
            [(x - w / 2, g - h * 0.72), (x + w / 2, g - h * 0.72)],
            [(x - w / 2, g - h * 0.72 + 3), (x + w / 2, g - h * 0.72 + 3)]]


def tomb(x, g, w=50.0, h=34.0, stone="closed") -> list[Stroke]:
    """Skalní hrob s otvorem; stone = closed / rolled / none."""
    out = [smooth([(x - w / 2, g), (x - w * 0.45, g - h * 0.7), (x - w * 0.15, g - h),
                   (x + w * 0.3, g - h * 0.9), (x + w / 2, g - h * 0.4), (x + w * 0.55, g)], 4)]
    ox, oy, r = x - w * 0.05, g - h * 0.32, h * 0.3
    out.append([(ox - r, g)] + ellipse(ox, g - r * 0.4, r, r, 180, 360, 12) + [(ox + r, g)])
    if stone == "closed":
        out.append(circle(ox + 1, g - r * 1.05, r * 1.1)[0])
    elif stone == "rolled":
        out.append(circle(ox + r * 2.3, g - r * 1.0, r * 1.0)[0])
    return out


def altar(x, g, w=22.0, h=14.0, fire=False, smoke=False) -> list[Stroke]:
    out = []
    rows = 3
    for r in range(rows):
        y0 = g - h * r / rows
        y1 = g - h * (r + 1) / rows
        out.append([(x - w / 2, y0), (x - w / 2, y1), (x + w / 2, y1), (x + w / 2, y0)])
        for k in range(2):
            xx = x - w / 2 + w * (k + 0.5 + (r % 2) * 0.5) / 2
            if xx < x + w / 2 - 1:
                out.append([(xx, y0), (xx, y1)])
    if fire:
        out += flames(x, g - h, w * 0.7)
    if smoke:
        out.append(smooth([(x, g - h - 4), (x - 4, g - h - 14), (x + 3, g - h - 24),
                           (x - 2, g - h - 36)], 4))
    return out


def ark(x, y, w=90.0) -> list[Stroke]:
    """Noemova archa."""
    h = w * 0.22
    return [smooth([(x - w / 2, y - h), (x - w * 0.42, y), (x + w * 0.42, y),
                    (x + w / 2, y - h)], 4),
            [(x - w / 2, y - h), (x + w / 2, y - h)],
            [(x - w * 0.3, y - h), (x - w * 0.3, y - h * 1.9), (x + w * 0.3, y - h * 1.9),
             (x + w * 0.3, y - h)],
            [(x - w * 0.34, y - h * 1.85), (x, y - h * 2.6), (x + w * 0.34, y - h * 1.85)],
            [(x - w * 0.08, y - h * 1.0), (x - w * 0.08, y - h * 1.5), (x + w * 0.04, y - h * 1.5),
             (x + w * 0.04, y - h * 1.0)],
            bez((x - w * 0.44, y - h * 0.5), (x, y - h * 0.4), (x + w * 0.44, y - h * 0.5), 8)]


def ark_cov(x, g, w=34.0) -> list[Stroke]:
    """Truhla smlouvy s tyčemi a cheruby."""
    h = w * 0.4
    out = [[(x - w / 2, g - 3), (x - w / 2, g - h), (x + w / 2, g - h), (x + w / 2, g - 3),
            (x - w / 2, g - 3)],
           [(x - w / 2 - 8, g - h * 0.45), (x + w / 2 + 8, g - h * 0.45)],
           [(x - w / 2 - 1, g - h - 1.5), (x + w / 2 + 1, g - h - 1.5)]]
    for d in (-1, 1):
        cx = x + d * w * 0.3
        out.append(smooth([(cx, g - h - 2), (cx - d * w * 0.05, g - h - 8),
                           (cx + d * w * 0.15, g - h - 13), (cx + d * w * 0.05, g - h - 5)], 3))
        out.append(circle(cx - d * 1, g - h - 9, 2)[0])
    out += [[(x - w / 2 + 2, g - 3), (x - w / 2 + 2, g)], [(x + w / 2 - 2, g - 3), (x + w / 2 - 2, g)]]
    return out


def throne(x, g, h=34.0, face=1) -> list[Stroke]:
    f = face
    return [[(x - f * 8, g), (x - f * 8, g - h), (x - f * 5, g - h - 4), (x - f * 4, g - h * 0.45)],
            [(x - f * 8, g - h * 0.42), (x + f * 9, g - h * 0.42), (x + f * 9, g)],
            [(x - f * 6, g - h * 0.42), (x - f * 6, g)]]


def seat(x, g, w=14.0, h=12.0) -> list[Stroke]:
    return [smooth([(x - w / 2, g), (x - w / 2 + 1, g - h), (x + w / 2 - 1, g - h - 1),
                    (x + w / 2, g)], 3)]


def rock(x, g, w=16.0, h=10.0) -> list[Stroke]:
    return [smooth([(x - w / 2, g), (x - w * 0.45, g - h * 0.7), (x - w * 0.1, g - h),
                    (x + w * 0.35, g - h * 0.8), (x + w / 2, g)], 4)]


def stones(x, g, n=3) -> list[Stroke]:
    out = []
    for i in range(n):
        out += rock(x + i * 7 - n * 3.5, g, 6, 4 + (i % 2) * 2)
    return out


def ladder(x0, y0, x1, y1, w=10.0, rungs=8) -> list[Stroke]:
    dx, dy = x1 - x0, y1 - y0
    ln = math.hypot(dx, dy)
    nx, ny = -dy / ln * w / 2, dx / ln * w / 2
    out = [[(x0 + nx, y0 + ny), (x1 + nx, y1 + ny)], [(x0 - nx, y0 - ny), (x1 - nx, y1 - ny)]]
    for i in range(1, rungs):
        t = i / rungs
        cx, cy = x0 + dx * t, y0 + dy * t
        out.append([(cx + nx, cy + ny), (cx - nx, cy - ny)])
    return out


def sword(x, y, l=26.0, angle=0.0) -> list[Stroke]:
    s = [[(x, y), (x, y - l)], [(x - 4, y - l * 0.18), (x + 4, y - l * 0.18)],
         [(x, y), (x, y + l * 0.15)]]
    return rotate(s, angle, x, y)


def spear(x, y, l=50.0, angle=0.0) -> list[Stroke]:
    s = [[(x, y), (x, y - l)], [(x - 2, y - l + 4), (x, y - l - 4), (x + 2, y - l + 4),
                                 (x, y - l)]]
    return rotate(s, angle, x, y)


def harp(x, g, h=24.0) -> list[Stroke]:
    out = [smooth([(x - h * 0.2, g), (x - h * 0.3, g - h * 0.6), (x - h * 0.1, g - h),
                   (x + h * 0.25, g - h * 0.9)], 4),
           [(x - h * 0.2, g), (x + h * 0.3, g - h * 0.1), (x + h * 0.25, g - h * 0.9)]]
    for i in range(1, 5):
        t = i / 5
        out.append([(x - h * 0.25 + h * 0.08 * t, g - h * (0.15 + 0.7 * t)),
                    (x + h * 0.3 - h * 0.05 * t, g - h * (0.1 + 0.75 * t))])
    return out


def trumpet(x, y, l=20.0, angle=-20.0, face=1) -> list[Stroke]:
    f = face
    s = [[(x, y - 0.8), (x + f * l, y - 1.2)], [(x, y + 0.8), (x + f * l, y + 1.2)],
         bez((x + f * l, y - 1.2), (x + f * (l + 2), y - 4.5), (x + f * (l + 3), y - 5), 3)
         + [(x + f * (l + 3), y + 5)]
         + bez((x + f * (l + 3), y + 5), (x + f * (l + 2), y + 4.5), (x + f * l, y + 1.2), 3)[1:]]
    return rotate(s, angle * f, x, y)


def basket(x, g, w=14.0, h=9.0, items=None) -> list[Stroke]:
    out = [[(x - w / 2, g - h), (x - w * 0.4, g), (x + w * 0.4, g), (x + w / 2, g - h)],
           ellipse(x, g - h, w / 2, 1.6),
           [(x - w * 0.45, g - h * 0.5), (x + w * 0.45, g - h * 0.5)]]
    if items == "bread":
        out += bread(x - 2.5, g - h - 0.5, 6) + bread(x + 3, g - h - 1, 6)
    if items == "fish":
        out += fish(x, g - h - 2, 0.5)
    return out


def wheat(x, g, h=24.0, lean=0.0) -> list[Stroke]:
    out = [bez((x, g), (x + lean * 0.3, g - h * 0.6), (x + lean, g - h), 5)]
    tx, ty = x + lean, g - h
    for i in range(4):
        yy = ty + i * 3
        out.append([(tx + lean * 0.05 * i, yy), (tx - 2.5, yy - 2.5)])
        out.append([(tx + lean * 0.05 * i, yy), (tx + 2.5, yy - 2.5)])
    return out


def field(x0, x1, g, n=7) -> list[Stroke]:
    out = []
    for i in range(n):
        x = x0 + (x1 - x0) * (i + 0.5) / n
        out += wheat(x, g, 20 + (i % 3) * 3, lean=(i % 2) * 2 - 1)
    return out


def vine(x0, y, x1, grapes=3) -> list[Stroke]:
    out = [smooth([(x0, y), ((x0 + x1) / 2, y - 4), (x1, y + 2)], 6)]
    for i in range(grapes):
        gx = x0 + (x1 - x0) * (i + 0.5) / grapes
        gy = y + 2
        for dx, dy in ((0, 2), (-2, 2), (2, 2), (-1, 4.5), (1, 4.5), (0, 7)):
            out.append(circle(gx + dx, gy + dy, 1.3)[0])
        out.append(smooth([(gx + 4, gy - 3), (gx + 9, gy - 6), (gx + 8, gy - 1), (gx + 4, gy - 3)], 2))
    return out


def plant(x, g, h=14.0) -> list[Stroke]:
    return [bez((x, g), (x - 1, g - h * 0.5), (x, g - h), 4),
            smooth([(x, g - h * 0.6), (x - h * 0.35, g - h * 0.85), (x - h * 0.45, g - h * 0.6),
                    (x, g - h * 0.6)], 2),
            smooth([(x, g - h * 0.75), (x + h * 0.35, g - h), (x + h * 0.45, g - h * 0.75),
                    (x, g - h * 0.75)], 2)]


def heart(x, y, s=6.0) -> list[Stroke]:
    return [smooth([(x, y + s), (x - s, y - s * 0.1), (x - s * 0.6, y - s * 0.8),
                    (x, y - s * 0.35), (x + s * 0.6, y - s * 0.8), (x + s, y - s * 0.1),
                    (x, y + s)], 4)]


def temple(x, g, w=70.0, h=40.0) -> list[Stroke]:
    out = [[(x - w / 2, g), (x - w / 2, g - h * 0.7), (x + w / 2, g - h * 0.7), (x + w / 2, g)],
           [(x - w / 2 - 4, g - h * 0.7), (x - w / 2 - 4, g - h * 0.78), (x + w / 2 + 4, g - h * 0.78),
            (x + w / 2 + 4, g - h * 0.7)],
           [(x - w * 0.22, g - h * 0.78), (x - w * 0.22, g - h), (x + w * 0.22, g - h),
            (x + w * 0.22, g - h * 0.78)]]
    for k in (-0.3, -0.15, 0.15, 0.3):
        out.append([(x + k * w, g), (x + k * w, g - h * 0.7)])
    out.append([(x - w * 0.06, g)] + ellipse(x, g - h * 0.35, w * 0.06, w * 0.06, 180, 360, 6)
               + [(x + w * 0.06, g)])
    out.append([(x - w / 2 - 8, g), (x + w / 2 + 8, g)])
    out.append([(x - w / 2 - 4, g - 2.5), (x + w / 2 + 4, g - 2.5)])
    return out


def tower(x, g, w=22.0, h=70.0) -> list[Stroke]:
    """Babylonská věž – stupňovitá."""
    out = []
    levels = 5
    for i in range(levels):
        ww = w * (1 - i * 0.16)
        y0 = g - h * i / levels
        y1 = g - h * (i + 1) / levels
        out.append([(x - ww / 2, y0), (x - ww / 2, y1), (x + ww / 2, y1), (x + ww / 2, y0)])
        out.append([(x - ww * 0.1, y0), (x - ww * 0.1, y0 - (y0 - y1) * 0.5),
                    (x + ww * 0.1, y0 - (y0 - y1) * 0.5), (x + ww * 0.1, y0)])
    out.append([(x - w * 0.3, g - h - 2), (x - w * 0.3, g - h - 9)])
    return out


def wall(x0, x1, g, h=14.0, rows=3, broken=False) -> list[Stroke]:
    out = [[(x0, g), (x0, g - h)], [(x1, g), (x1, g - h)]]
    for r in range(rows + 1):
        y = g - h * r / rows
        if broken and r == rows:
            out.append([(x0, y), ((x0 + x1) * 0.45, y), ((x0 + x1) * 0.5, y + h * 0.4),
                        ((x0 + x1) * 0.58, y + h * 0.2), (x1, y)])
        else:
            out.append([(x0, y), (x1, y)])
        if r < rows:
            k = 0
            xx = x0 + (6 if r % 2 else 3)
            while xx < x1 - 2:
                out.append([(xx, y), (xx, y - h / rows)])
                xx += 9
                k += 1
    return out


def gate(x, g, w=30.0, h=34.0) -> list[Stroke]:
    return [[(x - w / 2, g), (x - w / 2, g - h), (x + w / 2, g - h), (x + w / 2, g)],
            [(x - w * 0.3, g)] + ellipse(x, g - h * 0.45, w * 0.3, w * 0.35, 180, 360, 10)
            + [(x + w * 0.3, g)],
            [(x - w / 2 - 3, g - h), (x + w / 2 + 3, g - h)]]


def crown(x, y, w=14.0) -> list[Stroke]:
    h = w * 0.6
    return [[(x - w / 2, y), (x - w / 2, y - h), (x - w / 4, y - h * 0.45), (x, y - h * 1.1),
             (x + w / 4, y - h * 0.45), (x + w / 2, y - h), (x + w / 2, y), (x - w / 2, y)]]


def thorns(x, y, r=8.0) -> list[Stroke]:
    out = [ellipse(x, y, r, r * 0.4)]
    for i in range(8):
        a = math.radians(i * 45 + 10)
        px, py = x + math.cos(a) * r, y + math.sin(a) * r * 0.4
        out.append([(px, py), (px + math.cos(a + 0.7) * 3, py + math.sin(a + 0.7) * 2 - 1)])
    return out


def chain(x0, y0, x1, y1, n=5) -> list[Stroke]:
    out = []
    for i in range(n):
        t = (i + 0.5) / n
        cx, cy = x0 + (x1 - x0) * t, y0 + (y1 - y0) * t
        ang = math.degrees(math.atan2(y1 - y0, x1 - x0))
        out.append(ellipse(cx, cy, 2.6, 1.5, rot=ang + (90 if i % 2 else 0)))
    return out


def door(x, g, w=16.0, h=28.0) -> list[Stroke]:
    return [[(x - w / 2, g), (x - w / 2, g - h), (x + w / 2, g - h), (x + w / 2, g)],
            circle(x + w * 0.3, g - h * 0.48, 1)[0]]


def lampstand(x, g, h=30.0) -> list[Stroke]:
    out = [[(x, g), (x, g - h)], [(x - 6, g), (x + 6, g)]]
    for k in (1, 2, 3):
        out.append(bez((x, g - h * 0.35), (x - k * 4, g - h * 0.3), (x - k * 4, g - h), 5))
        out.append(bez((x, g - h * 0.35), (x + k * 4, g - h * 0.3), (x + k * 4, g - h), 5))
    for k in (-3, -2, -1, 0, 1, 2, 3):
        out += flames(x + k * 4, g - h - 1, 3)[1:2]
    return out


def bed(x, g, w=40.0) -> list[Stroke]:
    return [[(x - w / 2, g - 6), (x + w / 2, g - 6)], [(x - w / 2, g - 6), (x - w / 2, g)],
            [(x + w / 2, g - 6), (x + w / 2, g)], [(x - w / 2, g - 6), (x - w / 2, g - 10)]]


def manger(x, g, w=26.0) -> list[Stroke]:
    return [[(x - w / 2, g - 12), (x - w * 0.35, g - 4), (x + w * 0.35, g - 4), (x + w / 2, g - 12)],
            [(x - w * 0.3, g - 4), (x - w * 0.42, g)], [(x + w * 0.3, g - 4), (x + w * 0.42, g)],
            [(x - w * 0.3, g - 4), (x + w * 0.42, g)], [(x + w * 0.3, g - 4), (x - w * 0.42, g)]]


def staff_line(x, y0, y1) -> list[Stroke]:
    return [[(x, y0), (x, y1)]]


def coins(x, y, n=4) -> list[Stroke]:
    out = []
    for i in range(n):
        out.append(ellipse(x + i * 3.5 - n * 1.6, y - (i % 2) * 1.5, 2.2, 1.0))
    return out


def eye(x, y, w=14.0) -> list[Stroke]:
    return [bez((x - w / 2, y), (x, y - w * 0.45), (x + w / 2, y), 6),
            bez((x - w / 2, y), (x, y + w * 0.45), (x + w / 2, y), 6),
            circle(x, y, w * 0.16)[0]]


def hand(x, y, s=1.0, up=True) -> list[Stroke]:
    """Otevřená dlaň (prsty nahoru, nebo dolů, když up=False)."""
    out = []
    base = y - 1 * s
    for fx, h in ((-3.3, 7), (-1.1, 9), (1.1, 8.5), (3.3, 6.5)):
        cx = x + fx * s
        out.append([(cx - 1 * s, base)] + ellipse(cx, base - h * s, 1 * s, 1.1 * s, 180, 360, 6)
                   + [(cx + 1 * s, base)])
    out.append(smooth([(x - 4.3 * s, base), (x - 4.6 * s, y + 4 * s), (x - 3.4 * s, y + 9 * s)], 3))
    out.append(smooth([(x + 4.3 * s, base), (x + 5 * s, y + 1 * s), (x + 8 * s, y - 3 * s),
                       (x + 8.6 * s, y - 1.5 * s), (x + 5.5 * s, y + 4 * s), (x + 3.6 * s, y + 9 * s)], 3))
    out.append([(x - 4.5 * s, y + 9 * s), (x + 4.5 * s, y + 9 * s)])
    out.append([(x - 4.2 * s, y + 12 * s), (x + 4.2 * s, y + 12 * s)])
    if not up:
        out = [[(px, 2 * y - py) for px, py in st] for st in out]
    return out


def nets(x, y, w=24.0, h=12.0) -> list[Stroke]:
    out = [bez((x - w / 2, y), (x, y + h * 1.4), (x + w / 2, y), 8)]
    for i in range(1, 4):
        xx = x - w / 2 + w * i / 4
        out.append([(xx, y), (x - w / 2 + w * i / 4 * 0.9 + w * 0.05, y + h * 0.8)])
    out.append(bez((x - w * 0.4, y + h * 0.35), (x, y + h * 0.7), (x + w * 0.4, y + h * 0.35), 6))
    return out


def fig_tree(x, g, h=46.0, withered=False) -> list[Stroke]:
    if not withered:
        return tree(x, g, h)
    return [[(x - 1.5, g), (x - 1, g - h * 0.5)], [(x + 1.5, g), (x + 1, g - h * 0.5)],
            bez((x, g - h * 0.5), (x - h * 0.2, g - h * 0.7), (x - h * 0.3, g - h * 0.95), 5),
            bez((x, g - h * 0.5), (x + h * 0.15, g - h * 0.75), (x + h * 0.28, g - h * 0.9), 5),
            bez((x, g - h * 0.55), (x + h * 0.02, g - h * 0.8), (x - h * 0.03, g - h), 5),
            [(x - h * 0.15, g - h * 0.75), (x - h * 0.05, g - h * 0.82)]]


def gallows(x, g, h=50.0) -> list[Stroke]:
    return [[(x, g), (x, g - h), (x + h * 0.4, g - h)], [(x, g - h * 0.8), (x + h * 0.15, g - h)]]


# --- scéna --------------------------------------------------------------------

class Scene:
    def __init__(self, seed: int):
        self.strokes: list[Stroke] = []
        self.seed = seed

    def add(self, *groups: list[Stroke]) -> "Scene":
        for g in groups:
            if g and isinstance(g[0], tuple):
                self.strokes.append(g)  # jeden tah
            else:
                self.strokes.extend(g)
        return self

    def render(self, jitter: float = 0.55, k: float = 2.0, pad: float = 3.0):
        """Rozechvěné tahy oříznuté na obsah: (šířka, výška, SVG cesta).

        Souřadnice jsou × k a celá čísla; cesta = „M x y l dx dy …“."""
        rnd = random.Random(self.seed)
        strokes = []
        for s in self.strokes:
            pts = _resample(s, 3.5)
            if len(pts) < 2:
                continue
            ph, amp = rnd.uniform(0, 6.28), jitter * rnd.uniform(0.6, 1.2)
            freq = rnd.uniform(0.08, 0.16)
            ln = 0.0
            out = []
            for i, (x, y) in enumerate(pts):
                if i:
                    ln += math.hypot(x - pts[i - 1][0], y - pts[i - 1][1])
                d = amp * math.sin(ph + ln * freq)
                d2 = amp * 0.7 * math.cos(ph * 1.7 + ln * freq * 1.3)
                out.append((x + d, y + d2))
            strokes.append(out)
        xs = [p[0] for s in strokes for p in s]
        ys = [p[1] for s in strokes for p in s]
        x0, y0 = min(xs) - pad, min(ys) - pad
        w, h = max(xs) + pad - x0, max(ys) + pad - y0
        parts = []
        for s in strokes:
            q = [(round((x - x0) * k), round((y - y0) * k)) for x, y in s]
            ded = [q[0]]
            for p in q[1:]:
                if p != ded[-1]:
                    ded.append(p)
            if len(ded) >= 2:
                parts.append(_encode(ded))
        return round(w * k), round(h * k), " ".join(parts)


def _resample(s: Stroke, step: float) -> Stroke:
    out = [s[0]]
    for a, b in zip(s, s[1:]):
        d = math.hypot(b[0] - a[0], b[1] - a[1])
        n = max(1, int(d / step))
        for i in range(1, n + 1):
            t = i / n
            out.append((a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t))
    # zjednodušit: vynechat body na téměř rovné čáře
    if len(out) > 2:
        keep = [out[0]]
        for i in range(1, len(out) - 1):
            p, q, r = keep[-1], out[i], out[i + 1]
            cross_ = abs((q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0]))
            if cross_ > 0.9 or math.hypot(q[0] - p[0], q[1] - p[1]) > 9:
                keep.append(q)
        keep.append(out[-1])
        out = keep
    return out


def _encode(pts: list[tuple[int, int]]) -> str:
    """M x y + relativní body „l dx dy …“ (krátké)."""
    s = f"M{pts[0][0]} {pts[0][1]}l"
    prev = pts[0]
    vals = []
    for p in pts[1:]:
        vals.append(f"{p[0] - prev[0]} {p[1] - prev[1]}")
        prev = p
    return s + " ".join(vals)
