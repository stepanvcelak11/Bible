#!/usr/bin/env python3
"""Vygeneruje ikony aplikace (web/iOS plocha) – teplá hnědá s křížem.

Použití: python3 tool/make_icons.py   (vyžaduje Pillow)
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
BG = (107, 91, 69)        # #6B5B45 – stejná barva jako seed motivu
FG = (247, 241, 230)      # teplá „papírová“ bílá


def icon(size: int, safe: float) -> Image.Image:
    """`safe` = podíl plochy pro motiv (maskovatelné ikony mají okraj)."""
    scale = 4  # kreslíme větší a zmenšíme → hladké hrany
    s = size * scale
    img = Image.new("RGB", (s, s), BG)
    d = ImageDraw.Draw(img)
    h = s * safe * 0.62          # výška kříže
    w = h * 0.62                 # šířka ramen
    t = h * 0.13                 # tloušťka
    cx, top = s / 2, (s - h) / 2
    r = t / 2
    d.rounded_rectangle([cx - t / 2, top, cx + t / 2, top + h], r, fill=FG)
    y = top + h * 0.28
    d.rounded_rectangle([cx - w / 2, y - t / 2, cx + w / 2, y + t / 2], r, fill=FG)
    return img.resize((size, size), Image.LANCZOS)


def main() -> None:
    web = ROOT / "web"
    icon(192, 1.0).save(web / "icons" / "Icon-192.png")
    icon(512, 1.0).save(web / "icons" / "Icon-512.png")
    icon(192, 0.8).save(web / "icons" / "Icon-maskable-192.png")
    icon(512, 0.8).save(web / "icons" / "Icon-maskable-512.png")
    icon(180, 1.0).save(web / "icons" / "apple-touch-icon.png")
    icon(32, 1.0).save(web / "favicon.png")


if __name__ == "__main__":
    main()
