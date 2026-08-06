#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"

(
  sleep 45
  . "$MODDIR/common/apply.sh"
  virtus_apply_all "$MODDIR"
  safe_log "service re-apply OK"
) &
