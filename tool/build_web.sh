#!/usr/bin/env bash
# Sestaví webovou verzi (PWA) do build/web.
#
#   tool/build_web.sh [--base-href /Bible/]
#
# Kroky: zkompiluje drift worker, stáhne sqlite3.wasm odpovídající verzi
# balíčku sqlite3, spustí `flutter build web` bez CDN (vše přibalené → offline)
# a vygeneruje service worker se seznamem všech souborů.
# Předpoklad: assets/db/bible.db už existuje (tool/build_bible_db.py).
set -euo pipefail
cd "$(dirname "$0")/.."

BASE_HREF="/"
if [[ "${1:-}" == "--base-href" ]]; then BASE_HREF="$2"; fi

if [[ ! -f assets/db/bible.db ]]; then
  echo "Chybí assets/db/bible.db – spusť nejdřív tool/build_bible_db.py" >&2
  exit 1
fi

flutter pub get

# Verze balíčku sqlite3 z pubspec.lock → odpovídající sqlite3.wasm.
SQLITE_VERSION=$(python3 - <<'PY'
import re
lock = open('pubspec.lock', encoding='utf-8').read()
m = re.search(r'\n  sqlite3:\n(?:    .*\n)*?    version: "([^"]+)"', lock)
print(m.group(1))
PY
)

flutter build web --release --no-web-resources-cdn --base-href "$BASE_HREF"

dart compile js -O4 -o build/web/drift_worker.js tool/drift_worker.dart
rm -f build/web/drift_worker.js.deps build/web/drift_worker.js.map

curl -sSfL -o build/web/sqlite3.wasm \
  "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-${SQLITE_VERSION}/sqlite3.wasm"

# Studijní balíček (stahuje se v aplikaci na požádání, ne při instalaci).
mkdir -p build/web/data
if ls build/study/study-*.db.gz >/dev/null 2>&1; then
  cp build/study/study-*.db.gz build/web/data/
fi

# Zastaralý service worker Flutteru nepoužíváme (máme vlastní sw.js).
rm -f build/web/flutter_service_worker.js

# Service worker: předem uložit vše, co aplikace potřebuje offline.
# Vynechané: varianty rendereru pro Chrome / Wasm build (Safari používá
# canvaskit/canvaskit.wasm) a licence (NOTICES). Pokud je prohlížeč přesto
# vyžádá, sw.js je uloží při prvním použití.
python3 - <<'PY'
import fnmatch, hashlib, json
from pathlib import Path
web = Path('build/web')
skip = ['sw.js', '.*', '*.map', '*.symbols', 'assets/NOTICES', 'data/*',
        'canvaskit/chromium/*', 'canvaskit/webparagraph/*',
        'canvaskit/skwasm*', 'canvaskit/wimp*']
files, h = [], hashlib.sha256()
for p in sorted(web.rglob('*')):
    rel = p.relative_to(web).as_posix()
    if p.is_dir() or any(fnmatch.fnmatch(rel, pat) for pat in skip):
        continue
    files.append(rel)
    h.update(rel.encode()); h.update(p.read_bytes())
precache = ['./'] + files
sw = Path('tool/web/sw.template.js').read_text(encoding='utf-8')
sw = sw.replace('__VERSION__', h.hexdigest()[:12]).replace('__PRECACHE__', json.dumps(precache, indent=2))
(web / 'sw.js').write_text(sw, encoding='utf-8')
size = sum((web / f).stat().st_size for f in files) / 1_048_576
print(f'Service worker: {len(files)} souborů, {size:.1f} MB do mezipaměti')
PY

# GitHub Pages: nevynechávat soubory začínající podtržítkem.
touch build/web/.nojekyll
echo "Hotovo: build/web"
