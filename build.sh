#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT/module"
OUT_DIR="$ROOT/dist"
ZIP_NAME="VirtusFix-EmulatorHide-KernelSU.zip"

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR"/VirtusFix*.zip "$OUT_DIR"/UniversalRootHide*.zip

(
  cd "$MODULE_DIR"
  zip -r9 "$OUT_DIR/$ZIP_NAME" . \
    -x "*.DS_Store" \
    -x "hide/*" \
    -x "boot.log" \
    -x "state/detection_status"
)

echo "Built: $OUT_DIR/$ZIP_NAME"
unzip -l "$OUT_DIR/$ZIP_NAME"
