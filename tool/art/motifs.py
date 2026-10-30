"""Další motivy a zkratky pro skládání scén (vlastní kresby aplikace)."""
import math

from kit import (Stroke, bez, circle, ellipse, flames, ground, person, smooth,
                 rotate, poly)

G = 130.0  # čára země


# --- zkratky postav -----------------------------------------------------------

def J(x, f=1, arms="down", pose="stand", g=G, h=58.0, **kw):
    """Ježíš."""
    return person(x, g, h, f, pose, arms, beard=True, **kw)


def man(x, f=1, arms="down", pose="stand", g=G, h=54.0, beard=True, **kw):
    return person(x, g, h, f, pose, arms, beard=beard, **kw)


def youth(x, f=1, arms="down", pose="stand", g=G, h=50.0, **kw):
    return person(x, g, h, f, pose, arms, **kw)


def woman(x, f=1, arms="down", pose="stand", g=G, h=50.0, veil=True, **kw):
    return person(x, g, h, f, pose, arms, veil=veil, hair=not veil, **kw)


def kid(x, f=0, arms="down", pose="stand", g=G, h=32.0, **kw):
    return person(x, g, h, f, pose, arms, child=True, **kw)


def angel(x, f=0, arms="raise", g=G, h=58.0, pose="stand", **kw):
    return person(x, g, h, f, pose, arms, wings=True, **kw)


def king(x, f=1, arms="down", pose="stand", g=G, h=56.0, **kw):
    return person(x, g, h, f, pose, arms, beard=True, crown=True, **kw)


def gr(x0=0.0, x1=240.0, g=G, seed=0):
    return ground(x0, x1, g, seed)


# --- zvířata a předměty navíc -------------------------------------------------

def deer(x, g, s=1.0, face=1):
    f = face
    top = g - 16 * s
    out = [smooth([(x - f * 9 * s, top + 3 * s), (x, top + 1.5 * s), (x + f * 7 * s, top + 1 * s)], 3),
           smooth([(x - f * 9 * s, top + 3 * s), (x - f * 9 * s, top + 7 * s),
                   (x + f * 6 * s, top + 7.5 * s), (x + f * 7.5 * s, top + 3 * s)], 3),
           smooth([(x + f * 7 * s, top + 1 * s), (x + f * 9 * s, top - 6 * s),
                   (x + f * 13 * s, top - 5 * s), (x + f * 12 * s, top - 3.5 * s),
                   (x + f * 9.5 * s, top - 3 * s), (x + f * 7.5 * s, top + 3 * s)], 3)]
    hx, hy = x + f * 9.5 * s, top - 6.5 * s
    out.append(smooth([(hx, hy), (hx - f * 1 * s, hy - 6 * s), (hx - f * 4 * s, hy - 9 * s)], 3))
    out.append([(hx - f * 0.6 * s, hy - 4 * s), (hx + f * 2.5 * s, hy - 7 * s)])
    out.append([(hx - f * 2 * s, hy - 7 * s), (hx - f * 1 * s, hy - 10 * s)])
    for lx in (-8, -6, 4.5, 6.5):
        out.append([(x + f * lx * s, top + 7 * s), (x + f * (lx + 0.6) * s, g)])
    out.append([(x - f * 9 * s, top + 3 * s), (x - f * 11 * s, top + 1.5 * s)])
    return out


def goat(x, g, s=1.0, face=1, horns=True):
    f = face
    top = g - 12 * s
    out = [smooth([(x - f * 8 * s, top + 2 * s), (x + f * 5 * s, top + 1 * s)], 2),
           smooth([(x - f * 8 * s, top + 2 * s), (x - f * 8 * s, top + 6 * s),
                   (x + f * 5 * s, top + 6.5 * s), (x + f * 6 * s, top + 2 * s)], 3),
           smooth([(x + f * 5 * s, top + 1 * s), (x + f * 8 * s, top - 4 * s),
                   (x + f * 11 * s, top - 1 * s), (x + f * 9 * s, top + 1 * s),
                   (x + f * 6 * s, top + 3 * s)], 3),
           [(x + f * 10 * s, top + 0.5 * s), (x + f * 10 * s, top + 3 * s)]]
    if horns:
        out.append(smooth([(x + f * 8 * s, top - 4 * s), (x + f * 6 * s, top - 9 * s),
                           (x + f * 3 * s, top - 7 * s)], 3))
    for lx in (-7, -5, 3.5, 5.5):
        out.append([(x + f * lx * s, top + 6.5 * s), (x + f * lx * s, g)])
    out.append([(x - f * 8 * s, top + 2 * s), (x - f * 10 * s, top)])
    return out


def dog(x, g, s=1.0, face=1, wolf=False):
    """Pes (ocas nahoru) nebo vlk (huňatý ocas dolů, delší čenich)."""
    f = face
    top = g - 13 * s
    sn = 7 if wolf else 5
    out = [smooth([(x - f * 9 * s, top + 3 * s), (x + f * 5 * s, top + 2 * s)], 2),
           smooth([(x - f * 9 * s, top + 3 * s), (x - f * 9 * s, top + 7 * s),
                   (x + f * 6 * s, top + 7 * s), (x + f * 6 * s, top + 3 * s)], 3),
           # hlava s čenichem a špičatým uchem
           smooth([(x + f * 5 * s, top + 2 * s), (x + f * 7 * s, top - 3 * s),
                   (x + f * (7 + sn) * s, top - 1 * s), (x + f * (6 + sn) * s, top + 1 * s),
                   (x + f * 7 * s, top + 2 * s)], 3),
           [(x + f * 7 * s, top - 3 * s), (x + f * 8 * s, top - 8 * s), (x + f * 10 * s, top - 3.5 * s)],
           circle(x + f * 9 * s, top - 1.5 * s, 0.6 * s)[0]]
    for lx in (-8, -6, 3.5, 5.5):
        out.append([(x + f * lx * s, top + 7 * s), (x + f * lx * s, g)])
    if wolf:
        out.append(smooth([(x - f * 9 * s, top + 3 * s), (x - f * 14 * s, top + 6 * s),
                           (x - f * 15 * s, top + 10 * s)], 3))
        out.append(smooth([(x - f * 9.5 * s, top + 5 * s), (x - f * 13 * s, top + 9 * s),
                           (x - f * 15 * s, top + 10 * s)], 3))
    else:
        out.append(smooth([(x - f * 9 * s, top + 3 * s), (x - f * 12 * s, top - 1 * s),
                           (x - f * 11 * s, top - 5 * s)], 3))
    return out


def stump(x, g, w=14.0, shoot=True):
    """Pařez (s výhonkem)."""
    out = [[(x - w / 2 - 2, g), (x - w / 2, g - 3), (x - w / 2, g - 12)],
           [(x + w / 2 + 2, g), (x + w / 2, g - 3), (x + w / 2, g - 12)],
           ellipse(x, g - 12, w / 2, 2.2), ellipse(x, g - 12, w / 4, 1.1)]
    if shoot:
        out.append(smooth([(x + 2, g - 13), (x + 4, g - 20), (x + 3, g - 26)], 3))
        out.append(ellipse(x + 7, g - 22, 3.5, 1.6, rot=-25))
        out.append(ellipse(x - 0.5, g - 25, 3.2, 1.5, rot=30))
    return out


def ram(x, g, s=1.0, face=1):
    from kit import sheep
    out = sheep(x, g, s, face)
    hx, hy = x + face * 10.5 * s, g - 12.5 * s
    out.append(ellipse(hx - face * 1.5 * s, hy - 1 * s, 2.6 * s, 2.6 * s, 0, 300))
    return out


def eagle(x, y, s=1.0, face=1):
    f = face
    return [smooth([(x - 20 * s, y - 6 * s), (x - 12 * s, y - 9 * s), (x - 5 * s, y - 4 * s),
                    (x, y)], 4),
            smooth([(x, y), (x + 5 * s, y - 4 * s), (x + 12 * s, y - 9 * s),
                    (x + 20 * s, y - 6 * s)], 4),
            [(x - 20 * s, y - 6 * s), (x - 17 * s, y - 3 * s), (x - 15 * s, y - 4.5 * s),
             (x - 12 * s, y - 2 * s), (x - 9 * s, y - 2.5 * s), (x - 4 * s, y + 1 * s)],
            [(x + 20 * s, y - 6 * s), (x + 17 * s, y - 3 * s), (x + 15 * s, y - 4.5 * s),
             (x + 12 * s, y - 2 * s), (x + 9 * s, y - 2.5 * s), (x + 4 * s, y + 1 * s)],
            circle(x + f * 1 * s, y - 2 * s, 1.8 * s)[0],
            [(x + f * 2.6 * s, y - 2.4 * s), (x + f * 4 * s, y - 1.2 * s)],
            [(x - 2 * s, y + 1 * s), (x, y + 5 * s), (x + 2 * s, y + 1 * s)]]


def hen(x, g, s=1.0, face=1):
    f = face
    out = [smooth([(x + f * 7 * s, g - 12 * s), (x + f * 4 * s, g - 9 * s), (x - f * 2 * s, g - 10 * s),
                   (x - f * 9 * s, g - 13 * s), (x - f * 8 * s, g - 4 * s), (x, g - 2 * s),
                   (x + f * 6 * s, g - 5 * s), (x + f * 7 * s, g - 12 * s)], 4),
           circle(x + f * 7 * s, g - 14 * s, 2.5 * s)[0],
           [(x + f * 9.3 * s, g - 14 * s), (x + f * 11 * s, g - 13.2 * s), (x + f * 9.3 * s, g - 12.8 * s)],
           [(x - f * 1 * s, g - 2 * s), (x - f * 1 * s, g)], [(x + f * 2 * s, g - 2 * s), (x + f * 2 * s, g)]]
    return out


def chick(x, g, s=1.0):
    return [circle(x, g - 2.5 * s, 2.5 * s)[0], circle(x + 2.3 * s, g - 5.5 * s, 1.5 * s)[0]]


def ant(x, y, s=1.0):
    return [circle(x - 3 * s, y, 1.4 * s)[0], circle(x, y, 1.1 * s)[0], circle(x + 3 * s, y - 0.5 * s, 1.6 * s)[0],
            [(x - 1, y), (x - 2.5 * s, y + 3 * s)], [(x, y), (x, y + 3 * s)], [(x + 1, y), (x + 2.5 * s, y + 3 * s)],
            [(x + 4 * s, y - 1.5 * s), (x + 6 * s, y - 4 * s)]]


def locust(x, y, s=1.0):
    return [smooth([(x - 7 * s, y), (x, y - 1.5 * s), (x + 5 * s, y)], 3),
            smooth([(x - 7 * s, y), (x, y + 1.5 * s), (x + 5 * s, y)], 3),
            [(x - 1 * s, y - 1 * s), (x - 6 * s, y - 4 * s)],
            [(x + 2 * s, y + 1 * s), (x + 4 * s, y - 3 * s), (x + 7 * s, y + 3 * s)],
            [(x + 5 * s, y - 0.5 * s), (x + 8 * s, y - 4 * s)]]


def chariot(x, g, s=1.0, face=1, fire=False):
    f = face
    out = [circle(x, g - 8 * s, 8 * s)[0], [(x - 7 * s, g - 8 * s), (x + 7 * s, g - 8 * s)],
           [(x, g - 15 * s), (x, g - 1 * s)],
           [(x - f * 8 * s, g - 10 * s), (x - f * 10 * s, g - 24 * s)],
           [(x - f * 9 * s, g - 20 * s), (x + f * 9 * s, g - 18 * s), (x + f * 12 * s, g - 10 * s),
            (x - f * 8 * s, g - 10 * s)],
           [(x + f * 12 * s, g - 12 * s), (x + f * 26 * s, g - 14 * s)]]
    if fire:
        out += flames(x - f * 2 * s, g - 20 * s, 14 * s) + flames(x + f * 8 * s, g - 18 * s, 9 * s)
    return out


def horse(x, g, s=1.0, face=1, gallop=False):
    from kit import donkey
    out = donkey(x, g, s, face, horse=True)
    if gallop:
        out = rotate(out, -8 * face, x, g)
    return out


def bones(x0, x1, g, n=6):
    out = []
    for i in range(n):
        x = x0 + (x1 - x0) * (i + 0.5) / n
        a = (i * 37) % 60 - 30
        bone = [[(x - 5, g - 2), (x + 5, g - 2)],
                circle(x - 6, g - 3, 1.3)[0], circle(x - 6, g - 1, 1.3)[0],
                circle(x + 6, g - 3, 1.3)[0], circle(x + 6, g - 1, 1.3)[0]]
        out += rotate(bone, a, x, g - 2)
    for i in range(2):
        x = x0 + (x1 - x0) * (0.3 + i * 0.4)
        out.append(ellipse(x, g - 4, 4, 3.6))
        out.append(circle(x - 1.5, g - 4.5, 0.8)[0])
    return out


def furnace(x, g, w=60.0, h=44.0):
    out = [[(x - w / 2, g), (x - w / 2, g - h), (x - w * 0.2, g - h - 8), (x + w * 0.2, g - h - 8),
            (x + w / 2, g - h), (x + w / 2, g)],
           [(x - w * 0.35, g)] + ellipse(x, g - h * 0.45, w * 0.35, h * 0.4, 180, 360, 12) + [(x + w * 0.35, g)]]
    for k in range(3):
        out.append([(x - w / 2, g - h * (k + 1) / 4), (x - w * 0.36, g - h * (k + 1) / 4)])
        out.append([(x + w * 0.36, g - h * (k + 1) / 4), (x + w / 2, g - h * (k + 1) / 4)])
    return out


def anchor(x, y, s=1.0):
    return [circle(x, y - 14 * s, 2.5 * s)[0], [(x, y - 11.5 * s), (x, y + 8 * s)],
            [(x - 5 * s, y - 8 * s), (x + 5 * s, y - 8 * s)],
            bez((x - 9 * s, y + 3 * s), (x - 7 * s, y + 9 * s), (x, y + 8 * s), 5)
            + bez((x, y + 8 * s), (x + 7 * s, y + 9 * s), (x + 9 * s, y + 3 * s), 5)[1:],
            [(x - 9 * s, y + 3 * s), (x - 10 * s, y + 6 * s)], [(x + 9 * s, y + 3 * s), (x + 10 * s, y + 6 * s)]]


def shield(x, y, s=1.0):
    return [smooth([(x - 7 * s, y - 9 * s), (x - 7 * s, y + 2 * s), (x, y + 10 * s)], 3)
            + smooth([(x, y + 10 * s), (x + 7 * s, y + 2 * s), (x + 7 * s, y - 9 * s)], 3)[1:]
            + [(x - 7 * s, y - 9 * s)],
            [(x, y - 7 * s), (x, y + 6 * s)], [(x - 4 * s, y - 3 * s), (x + 4 * s, y - 3 * s)]]


def helmet(x, y, s=1.0):
    return [ellipse(x, y, 6 * s, 6 * s, 180, 360, 10) + [(x + 6 * s, y + 4 * s), (x + 3 * s, y + 4 * s),
                                                          (x + 3 * s, y + 1 * s), (x - 3 * s, y + 1 * s),
                                                          (x - 3 * s, y + 4 * s), (x - 6 * s, y + 4 * s),
                                                          (x - 6 * s, y)],
            smooth([(x, y - 6 * s), (x - 2 * s, y - 10 * s), (x - 6 * s, y - 11 * s)], 3)]


def sling(x, y, s=1.0):
    return [smooth([(x, y), (x + 4 * s, y - 6 * s), (x + 8 * s, y - 10 * s)], 3),
            ellipse(x + 9 * s, y - 11 * s, 2 * s, 1.2 * s, rot=-45)]


def potter(x, g, h=50.0):
    """Hrnčíř u kruhu s nádobou."""
    out = person(x - 14, g, h, 1, "sit", [(55, 80), (45, 70)], beard=True)
    out += [[(x + 2, g - 13), (x + 22, g - 13)], [(x + 12, g - 13), (x + 12, g)],
            ellipse(x + 12, g - 2, 9, 2)]
    out.append(smooth([(x + 8, g - 13), (x + 6, g - 19), (x + 9, g - 25), (x + 10, g - 27)], 3))
    out.append(smooth([(x + 16, g - 13), (x + 18, g - 19), (x + 15, g - 25), (x + 14, g - 27)], 3))
    out.append(ellipse(x + 12, g - 27, 2.2, 0.8))
    return out


def pillar(x, g, h=50.0, w=8.0):
    return [[(x - w / 2, g), (x - w / 2, g - h)], [(x + w / 2, g), (x + w / 2, g - h)],
            [(x - w / 2 - 2, g - h), (x + w / 2 + 2, g - h)], [(x - w / 2 - 2, g - h - 3), (x + w / 2 + 2, g - h - 3)],
            [(x - w / 2 - 2, g), (x + w / 2 + 2, g)]]


def torch(x, y, s=1.0):
    return [[(x, y), (x + 1 * s, y + 14 * s)]] + flames(x, y, 7 * s)


def horn(x, y, s=1.0, face=1):
    f = face
    return [smooth([(x, y), (x + f * 6 * s, y - 2 * s), (x + f * 12 * s, y - 6 * s),
                    (x + f * 14 * s, y - 12 * s)], 3),
            smooth([(x, y + 2 * s), (x + f * 7 * s, y + 0.5 * s), (x + f * 14 * s, y - 4 * s),
                    (x + f * 17 * s, y - 11 * s)], 3),
            [(x + f * 14 * s, y - 12 * s), (x + f * 17 * s, y - 11 * s)]]


def hourglass(x, y, s=1.0):
    return [[(x - 6 * s, y - 10 * s), (x + 6 * s, y - 10 * s)], [(x - 6 * s, y + 10 * s), (x + 6 * s, y + 10 * s)],
            smooth([(x - 5 * s, y - 10 * s), (x - 4 * s, y - 4 * s), (x - 0.8 * s, y), (x - 4 * s, y + 4 * s),
                    (x - 5 * s, y + 10 * s)], 3),
            smooth([(x + 5 * s, y - 10 * s), (x + 4 * s, y - 4 * s), (x + 0.8 * s, y), (x + 4 * s, y + 4 * s),
                    (x + 5 * s, y + 10 * s)], 3),
            [(x - 3 * s, y + 9 * s), (x, y + 6 * s), (x + 3 * s, y + 9 * s)]]


def mirror(x, y, s=1.0):
    return [ellipse(x, y, 6 * s, 8 * s), [(x, y + 8 * s), (x, y + 16 * s)],
            [(x - 2 * s, y - 3 * s), (x + 1 * s, y - 6 * s)]]


def pearl(x, y, r=4.0):
    return [circle(x, y, r)[0], ellipse(x - r * 0.35, y - r * 0.35, r * 0.25, r * 0.15, rot=-40)]


def wheel(x, y, r=14.0, spokes=8):
    out = [circle(x, y, r)[0], circle(x, y, r * 0.2)[0]]
    for i in range(spokes):
        a = math.radians(i * 360 / spokes)
        out.append([(x + math.cos(a) * r * 0.2, y + math.sin(a) * r * 0.2),
                    (x + math.cos(a) * r, y + math.sin(a) * r)])
    return out


def rope(x0, y0, x1, y1):
    out = []
    n = int(math.hypot(x1 - x0, y1 - y0) / 4)
    for i in range(n):
        t0, t1 = i / n, (i + 1) / n
        out.append([(x0 + (x1 - x0) * t0 - 1, y0 + (y1 - y0) * t0 + 1),
                    (x0 + (x1 - x0) * t1 + 1, y0 + (y1 - y0) * t1 - 1)])
    return out


def window(x, y, w=12.0, h=12.0):
    return [poly((x - w / 2, y - h / 2), (x + w / 2, y - h / 2), (x + w / 2, y + h / 2),
                 (x - w / 2, y + h / 2), closed=True)[0], [(x, y - h / 2), (x, y + h / 2)]]


def reeds(x0, x1, g, n=6):
    out = []
    for i in range(n):
        x = x0 + (x1 - x0) * i / max(1, n - 1)
        h = 18 + (i % 3) * 5
        out.append(bez((x, g), (x + 1, g - h * 0.6), (x + (i % 2) * 3 - 1, g - h), 4))
        out.append(ellipse(x + (i % 2) * 3 - 1, g - h - 2, 1.2, 3))
    return out


def plough(x, g, face=1):
    f = face
    return [[(x, g - 2), (x + f * 14, g - 2), (x + f * 18, g + 1)], [(x + f * 4, g - 2), (x - f * 4, g - 14)],
            [(x - f * 4, g - 14), (x - f * 8, g - 13)], [(x + f * 12, g - 2), (x + f * 26, g - 10)]]


def sickle(x, y, s=1.0):
    return [ellipse(x + 4 * s, y - 4 * s, 6 * s, 6 * s, 140, 330), [(x, y), (x - 3 * s, y + 6 * s)]]


def scales(x, y, s=1.0):
    return [[(x, y), (x, y + 22 * s)], [(x - 6 * s, y + 22 * s), (x + 6 * s, y + 22 * s)],
            [(x - 12 * s, y + 3 * s), (x + 12 * s, y + 1 * s)],
            [(x - 12 * s, y + 3 * s), (x - 15 * s, y + 11 * s), (x - 9 * s, y + 11 * s), (x - 12 * s, y + 3 * s)],
            [(x + 12 * s, y + 1 * s), (x + 9 * s, y + 9 * s), (x + 15 * s, y + 9 * s), (x + 12 * s, y + 1 * s)],
            bez((x - 15 * s, y + 11 * s), (x - 12 * s, y + 13 * s), (x - 9 * s, y + 11 * s), 4),
            bez((x + 9 * s, y + 9 * s), (x + 12 * s, y + 11 * s), (x + 15 * s, y + 9 * s), 4)]


def plumb(x, y0, y1):
    return [[(x, y0), (x, y1)], [(x - 2, y1), (x, y1 + 6), (x + 2, y1), (x - 2, y1)]]


def lily(x, g, h=16.0):
    return [bez((x, g), (x + 1, g - h * 0.6), (x, g - h), 4),
            smooth([(x, g - h), (x - 4, g - h - 4), (x - 5, g - h - 9)], 2),
            smooth([(x, g - h), (x, g - h - 6), (x, g - h - 10)], 2),
            smooth([(x, g - h), (x + 4, g - h - 4), (x + 5, g - h - 9)], 2),
            smooth([(x, g - h * 0.4), (x - 5, g - h * 0.6), (x - 7, g - h * 0.5)], 2)]


def flowers(x0, x1, g, n=5):
    out = []
    for i in range(n):
        x = x0 + (x1 - x0) * (i + 0.5) / n
        h = 7 + (i % 3) * 3
        out.append([(x, g), (x, g - h)])
        for a in range(0, 360, 72):
            r = math.radians(a)
            out.append(circle(x + math.cos(r) * 1.8, g - h + math.sin(r) * 1.8, 1.2)[0])
    return out


def path(x0, y0, x1, y1, w0=14.0, w1=2.0):
    """Cesta ubíhající do dálky (k bodu x1, y1)."""
    bend = (x1 - x0) * 0.35
    out = []
    for side in (-1, 1):
        a = (x0 + side * w0 / 2, y0)
        b = (x1 + side * w1 / 2, y1)
        c = ((a[0] + b[0]) / 2 - bend, (a[1] + b[1]) / 2)
        out.append(bez(a, c, b, 10))
    return out


def fleece(x, g, w=18.0):
    return [smooth([(x - w / 2, g), (x - w * 0.4, g - 4), (x - w * 0.1, g - 5), (x + w * 0.2, g - 4.5),
                    (x + w / 2, g)], 3),
            [(x - w * 0.3, g - 2), (x - w * 0.2, g - 3)], [(x, g - 2.5), (x + w * 0.1, g - 3.5)],
            [(x + w * 0.25, g - 2), (x + w * 0.32, g - 3)]]


def dragon(x, y, s=1.0):
    return [smooth([(x - 30 * s, y + 8 * s), (x - 20 * s, y), (x - 8 * s, y + 6 * s), (x + 4 * s, y - 2 * s),
                    (x + 10 * s, y - 14 * s), (x + 18 * s, y - 16 * s)], 4),
            smooth([(x - 30 * s, y + 8 * s), (x - 20 * s, y + 5 * s), (x - 8 * s, y + 11 * s),
                    (x + 6 * s, y + 4 * s), (x + 14 * s, y - 10 * s), (x + 20 * s, y - 12 * s)], 4),
            [(x + 18 * s, y - 16 * s), (x + 24 * s, y - 14 * s), (x + 20 * s, y - 12 * s)],
            [(x - 6 * s, y + 3 * s), (x - 10 * s, y - 10 * s), (x - 2 * s, y - 6 * s), (x + 1 * s, y - 16 * s),
             (x + 4 * s, y - 3 * s)]]


def grapes(x, y, s=1.0):
    out = []
    rows = ((0, 4), (1, 3), (2, 2), (3, 1))
    for r, n in rows:
        for i in range(n):
            out.append(circle(x + (i - (n - 1) / 2) * 3.2 * s, y + r * 2.9 * s, 1.6 * s)[0])
    out.append([(x, y - 2 * s), (x, y - 5 * s)])
    out.append(smooth([(x, y - 4 * s), (x + 4 * s, y - 7 * s), (x + 7 * s, y - 4 * s), (x, y - 4 * s)], 2))
    return out
