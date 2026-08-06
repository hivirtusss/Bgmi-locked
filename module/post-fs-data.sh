#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"

read_config "$MODDIR/profile.conf"
rm -f "$MODDIR/state/hide_applied" 2>/dev/null

# Only minimal sync props — rest deferred to background
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

safe_run sh -c "
  . '$MODDIR/common/universal_banking.sh'
  . '$MODDIR/common/apply.sh'
  read_config '$MODDIR/profile.conf'
  apply_boot_safe '$MODDIR'
"

safe_log "post-fs-data deferred (boot-safe)"
