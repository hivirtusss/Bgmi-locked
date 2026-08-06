#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/universal_banking.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"
apply_all_props "$MODDIR"

if [ "$URH_FILE_HIDE" = "1" ] && [ ! -f "$MODDIR/state/hide_applied" ]; then
  hide_emulator_files_safe "$MODDIR"
  echo "1" > "$MODDIR/state/hide_applied"
fi

if [ ! -f "$MODDIR/state/detection_status" ]; then
  mkdir -p "$MODDIR/state"
  echo "FAIL" > "$MODDIR/state/detection_status"
fi

if ! grep -q "Detection Fail" "$MODDIR/module.prop" 2>/dev/null; then
  if [ "$(cat $MODDIR/state/detection_status 2>/dev/null)" != "FIXED" ]; then
    sed -i 's/^description=.*/description=❌ Detection Fail | v4 ALL Apps Phone Disguise No Crash | Action 🎯 @Hivirtus ❤️/' "$MODDIR/module.prop" 2>/dev/null
  fi
fi

safe_log "boot-completed props applied"
