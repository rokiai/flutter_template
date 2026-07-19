#!/usr/bin/env python3
"""Fail if any package in pubspec.lock had a major version bump vs a baseline lock.

Usage:
  python3 tool/check_no_major_bump.py pubspec.lock.before pubspec.lock
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


def parse_lock(path: Path) -> dict[str, str]:
    packages: dict[str, str] = {}
    current: str | None = None
    for line in path.read_text().splitlines():
        m = re.match(r"^  ([a-zA-Z0-9_]+):$", line)
        if m:
            current = m.group(1)
            continue
        if current and line.startswith('    version: "'):
            packages[current] = line.split('"')[1]
            current = None
    return packages


def major(version: str) -> int:
    # Strip pre-release / build: 3.2.6-dev.1 -> 3
    core = re.split(r"[-+]", version, maxsplit=1)[0]
    return int(core.split(".")[0])


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: check_no_major_bump.py <before.lock> <after.lock>", file=sys.stderr)
        return 2

    before = parse_lock(Path(sys.argv[1]))
    after = parse_lock(Path(sys.argv[2]))

    majors: list[str] = []
    for name, new_ver in sorted(after.items()):
        old_ver = before.get(name)
        if old_ver is None:
            continue
        if major(new_ver) > major(old_ver):
            majors.append(f"  - {name}: {old_ver} -> {new_ver}")

    if majors:
        print("Refusing dependency update: major version bumps detected:")
        print("\n".join(majors))
        print(
            "\nDaily job only allows minor/patch upgrades within existing "
            "pubspec constraints (no `pub upgrade --major-versions`)."
        )
        return 1

    print("OK: no major version bumps in pubspec.lock.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
