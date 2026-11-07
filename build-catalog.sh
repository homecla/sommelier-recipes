#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 homecla
# Validates every recipe in recipes/ and regenerates catalog.json.
#   ./build-catalog.sh          validate and write catalog.json
#   ./build-catalog.sh --check  validate only (used for pull requests)
set -euo pipefail
cd "$(dirname "$0")"
SOMMELIER="${SOMMELIER:-tools/sommelier}"
CHECK=0; [ "${1:-}" = --check ] && CHECK=1

sha256() { if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi; }

fail=0; rows=""
for f in recipes/*.preset; do
  [ -f "$f" ] || continue
  # trailing newline required (the fingerprint must not change after installation)
  [ -z "$(tail -c1 "$f")" ] || { [ $CHECK = 1 ] && { echo "$f: manca l'a capo finale" >&2; fail=1; continue; }; echo >> "$f"; }
  if ! json=$(bash "$SOMMELIER" preset validate "$f" --json); then fail=1; continue; fi
  order=$(printf '%s' "$json" | sed -n 's/.*"order":\([0-9]*\).*/\1/p')
  entry="${json%\}},\"file\":\"$f\",\"sha256\":\"$(sha256 "$f")\",\"size\":$(wc -c < "$f" | tr -d ' ')}"
  rows+="$(printf '%05d\t%s\t%s' "${order:-50}" "$(basename "$f")" "$entry")"$'\n'
  echo "ok  $f"
done
[ $fail = 0 ] || { echo "Alcune ricette non sono valide." >&2; exit 1; }
[ $CHECK = 1 ] && exit 0

{
  printf '{\n  "name": "Sommelier recipes",\n  "format": 1,\n  "recipes": [\n'
  printf '%s' "$rows" | sort | cut -f3 | sed '$!s/$/,/' | sed 's/^/    /'
  printf '  ]\n}\n'
} > catalog.json.tmp
# rewrite the file only when its content changes
if cmp -s catalog.json.tmp catalog.json 2>/dev/null; then rm catalog.json.tmp; echo "catalog.json invariato"
else mv catalog.json.tmp catalog.json; echo "catalog.json aggiornato"; fi
