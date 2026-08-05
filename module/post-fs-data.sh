#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"
. "$MODDIR/common/license.sh"

read_config "$MODDIR/profile.conf"

if ! is_licensed "$MODDIR"; then
  safe_log "Virtus: license required — WebUI or @Hivirtus"
  exit 0
fi

ACTIVE=$(apply_all_props "$MODDIR" 2>/dev/null | tail -n1)

if [ "$URH_FILE_HIDE" = "1" ] && [ "$URH_LATE_ONLY" != "1" ]; then
  safe_run hide_emulator_files_safe "$MODDIR"
fi

safe_log "post-fs-data OK profile=${ACTIVE:-pixel9proxl} licensed=1"
