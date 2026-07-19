#!/usr/bin/env bash
# Regenerate Drift web worker (sqlite3.wasm is downloaded separately).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

WORKER="$(dart pub cache path 2>/dev/null || true)"
# Resolve drift package path via package_config
DRIFT_WORKER="$(python3 - <<'PY'
import json
from pathlib import Path
cfg = json.loads(Path(".dart_tool/package_config.json").read_text())
for p in cfg["packages"]:
  if p["name"] == "drift":
    root = Path(p["rootUri"].replace("file://", ""))
    if not root.is_absolute():
      root = Path(".dart_tool") / root
    print(root / "web" / "drift_worker.dart")
    break
PY
)"

dart compile js -O2 -o web/drift_worker.js \
  --packages=.dart_tool/package_config.json \
  "$DRIFT_WORKER"
rm -f web/drift_worker.js.map web/drift_worker.js.deps
echo "Wrote web/drift_worker.js"
