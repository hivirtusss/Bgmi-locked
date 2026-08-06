#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/universal_banking.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"

rm -f "$MODDIR/state/hide_applied" 2>/dev/null

ACTIVE=$(apply_all_props "$MODDIR" 2>/dev/null | tail -n1)

if [ "$URH_FILE_HIDE" = "1" ] && [ "$URH_LATE_ONLY" != "1" ]; then
  safe_run hide_emulator_files_safe "$MODDIR"
fi

safe_log "post-fs-data OK profile=${ACTIVE:-pixel6a}"
