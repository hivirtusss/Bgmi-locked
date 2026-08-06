#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

if [ ! -f "$MODDIR/state/detection_status" ]; then
  mkdir -p "$MODDIR/state"
  update_module_status "$MODDIR" "FAIL" "❌ Tap Action 🎯 then Hide Root in KernelSU @Hivirtus ❤️"
fi

safe_log "boot-completed"
