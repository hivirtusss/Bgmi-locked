#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"

read_config "$MODDIR/profile.conf"

# Wait until system fully up — never block early boot
(
  sleep 25
  . "$MODDIR/common/universal_banking.sh"
  . "$MODDIR/common/apply.sh"
  read_config "$MODDIR/profile.conf"
  apply_boot_safe "$MODDIR"
  safe_log "service boot-safe apply OK"
) &

safe_log "service deferred (boot-safe)"
