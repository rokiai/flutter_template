#!/usr/bin/env bash
set -euo pipefail

flavor="${1:-dev}"
root="$(cd "$(dirname "$0")/.." && pwd)"
src="$root/.env.$flavor"
dst="$root/.env"

if [[ ! -f "$src" ]]; then
  echo "Missing $src — copy from .env.example first." >&2
  exit 1
fi

cp "$src" "$dst"
echo "Copied .env.$flavor → .env"
echo "Run: dart run build_runner build   # if Env fields changed"
