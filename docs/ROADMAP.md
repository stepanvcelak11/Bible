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

## Krok 2 – Čtečka a Focus Mode
- `ReaderSettings` (velikost písma, řádkování, okraje, písmo) uložené v preferencích.
- Motivy: světlý, tmavý, teplá sépie; plynulý přechod motivů.
- Typografie: serifové písmo přibalené v assets (offline), čísla veršů
  horním indexem, odstavcový / veršový režim.
- Focus Mode: `CustomScrollView` + sliver app bar, ovládání se skryje při
  posunu dolů a objeví při posunu nahoru / klepnutí.
- Horizontální swipe mezi kapitolami (`PageView` s předběžným načtením
  sousedních kapitol přes `keepAlive` cache providerů).
- Ukládání viditelného verše při posouvání (debounce) a obnova pozice.

## Krok 3 – Navigace a hledání
- Výběr knihy/kapitoly: dvě sekce Starý / Nový zákon, mřížka zkratek,
  rychlá mřížka kapitol, animovaný přechod.
- Obrazovka „Hledat“: FTS5 dotaz s debounce, výběr překladů, filtr
  zákonů/knih, zvýraznění shod, stránkování výsledků.
- Skok na verš z výsledku (scroll + krátké zvýraznění).

## Krok 4 – Interakce s verši a osobní deník
- Klepnutí / dlouhé podržení verše → bottom sheet: **Zvýraznit**,
  **Přidat záložku**, **Přidat poznámku**, **Kopírovat**, **Sdílet**.
- Výběr více veršů, kopírování s odkazem („J 3,16–17 BKR“).
- Vykreslení zvýraznění / ikon záložek a poznámek ve čtečce (streamy).
- Záložka „Záložky / Poznámky / Zvýraznění“ s filtrováním a vyhledáním.
- Sdílení přes systémový share sheet (`share_plus`) – jediná „síťová“ akce,
  kterou ale provádí uživatel.

## Krok 5 – Vyladění
- Export/import uživatelských dat (JSON soubor) – zálohování bez cloudu.
- Mapování odlišného číslování veršů mezi překlady (versifikační tabulky).
- Profilování (DevTools), velikost aplikace (komprese DB v assets?),
  ikona, splash screen, přístupnost (TalkBack/VoiceOver, velká písma).
