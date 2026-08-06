#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"

read_config "$MODDIR/profile.conf"
rm -f "$MODDIR/state/hide_applied" 2>/dev/null

if [ -x /data/adb/ksu/bin/resetprop ]; then
  RP=/data/adb/ksu/bin/resetprop
elif [ -x /data/adb/magisk/magisk ]; then
  RP="/data/adb/magisk/magisk resetprop"
else
  RP=resetprop
fi

$RP -n ro.kernel.qemu 0 2>/dev/null
$RP -n ro.boot.qemu 0 2>/dev/null
$RP -n ro.debuggable 0 2>/dev/null
$RP -n ro.secure 1 2>/dev/null

virtus_deferred_apply() {
  _md="$1"
  . "$_md/common/upi_banking.sh"
  . "$_md/common/universal_banking.sh"
  . "$_md/common/apply.sh"
  read_config "$_md/profile.conf"
  apply_all_props "$_md"
  safe_log "deferred full apply OK"
}

safe_run virtus_deferred_apply "$MODDIR"

safe_log "post-fs-data boot-safe start"
