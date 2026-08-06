#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh" 2>/dev/null
MODDIR=$(resolve_moddir "$0" 2>/dev/null)
[ -z "$MODDIR" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
. "$MODDIR/common/apply.sh" 2>/dev/null

virtus_restore_props "$MODDIR" 2>/dev/null
rm -f "$MODDIR/state/original.props" 2>/dev/null
rm -f "$MODDIR/state/detection_status" 2>/dev/null
