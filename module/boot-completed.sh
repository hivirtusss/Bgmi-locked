#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"

if [ ! -f "$MODDIR/state/detection_status" ]; then
  mkdir -p "$MODDIR/state"
  echo "FAIL" > "$MODDIR/state/detection_status"
fi

if ! grep -q "Detection Fail" "$MODDIR/module.prop" 2>/dev/null; then
  if [ "$(cat $MODDIR/state/detection_status 2>/dev/null)" != "FIXED" ]; then
    sed -i 's/^description=.*/description=❌ Detection Fail | Press Action Button 🎯 Root Hide Fix Emu By @Hivirtus ❤️/' "$MODDIR/module.prop" 2>/dev/null
  fi
fi

safe_log "Virtus Fix boot-completed — tap Action if Detection Fail"
