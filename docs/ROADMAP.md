# Plán vývoje

Každý krok = jeden nebo několik samostatných commitů, po každém je aplikace
spustitelná a testy zelené.

## ✅ Krok 1 – Data a výběr překladu
- Struktura projektu (Clean Architecture), Riverpod, Drift, česká lokalizace.
- Schéma obsahové DB (překlady, knihy, kapitoly, verše, FTS5) sdílené s
  Python skriptem; skript pro sestavení offline DB (BKR + ČSP, formáty
  scrollmapper / Zefania / flat).
- Atomická instalace DB z assets s verzováním obsahu.
- Uživatelská DB (zvýraznění, záložky, poznámky) + repozitář.
- `TranslationController` (hlavní/porovnávaný překlad, prohození, ukládání),
  `ReadingPositionController` (pozice nezávislá na překladu, listování přes
  hranice knih, korekce při odlišném číslování).
- Základní čtečka a panel „Vybrat překlad“ pro ověření celé vrstvy.
- Testy: repozitáře, fulltext s diakritikou, přepínání překladů, instalátor.

## ✅ Krok 2 – Čtečka a Focus Mode
- Motivy světlý / sépie / tmavý / podle systému (plynulý přechod).
- Přibalené písmo Literata, nastavitelná velikost písma, řádkování, okraje,
  čísla veršů – s živým náhledem.
- Focus Mode: horní lišta se při čtení schová, při posunu nahoru vrátí.
- Vodorovné přejetí mezi kapitolami (PageView, sousední kapitoly se
  načítají dopředu).
- Ukládání verše nahoře na obrazovce a návrat na něj po spuštění.

## ✅ Krok 3 – Navigace a hledání
- Výběr knihy (Starý / Nový zákon) s rozbalovací mřížkou kapitol.
- Hledání: FTS5 bez diakritiky, filtr zákona a překladů, zvýrazněné
  shody, skok na verš s krátkým podbarvením.

## ✅ Krok 4 – Verše a osobní deník
- Klepnutí na verš = výběr (i více veršů), panel akcí: **Zvýraznit**
  (5 barev), **Záložka**, **Poznámka**, **Kopírovat**, **Sdílet**.
- Citace v české konvenci („Jan 3,16–18“).
- Ikony záložek a poznámek přímo v textu.
- Deník: Záložky / Poznámky / Zvýraznění, smazání přejetím s „Zpět“.

## ✅ Krok 5 – Záloha a web
- Export/import uživatelských dat (JSON) – sdílení do Souborů, obnova
  sloučením bez duplicit.
- Webová verze (PWA) na GitHub Pages, offline přes service worker.

## Další nápady
- Mapování odlišného číslování veršů mezi překlady (versifikační tabulky).
- Plány čtení, verš dne.
- Odstavcový režim textu.
