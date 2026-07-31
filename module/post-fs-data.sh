#!/system/bin/sh
# Boot stage: props ONLY (FreeRecharge-style — fastest, zero bootloop risk)
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"

ACTIVE=$(apply_all_props "$MODDIR" 2>/dev/null | tail -n1)

# File hide ONLY if explicitly enabled AND not deferred to late boot
if [ "$URH_FILE_HIDE" = "1" ] && [ "$URH_LATE_ONLY" != "1" ]; then
  safe_run hide_emulator_files_safe "$MODDIR"
fi

safe_log "post-fs-data OK profile=${ACTIVE:-pixel9proxl}"
