#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"

# Short settle — long sleep was freezing emulators
sleep 1

apply_all_props "$MODDIR"

if [ "$URH_FILE_HIDE" = "1" ] && [ ! -f "$MODDIR/state/hide_applied" ]; then
  hide_emulator_files_safe "$MODDIR"
  echo "1" > "$MODDIR/state/hide_applied"
fi

safe_log "service OK"
