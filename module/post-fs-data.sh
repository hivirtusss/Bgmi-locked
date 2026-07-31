#!/system/bin/sh
# Early boot fixes for emulator + root detection on KernelSU.
MODDIR=${0%/*}

LOGTAG="emulator_root_fix"
log_i() { /system/bin/log -t "$LOGTAG" -p i "$1" 2>/dev/null || true; }

if [ -x /data/adb/ksu/bin/resetprop ]; then
  RESETPROP=/data/adb/ksu/bin/resetprop
elif [ -x /data/adb/magisk/magisk ]; then
  RESETPROP="/data/adb/magisk/magisk resetprop"
else
  RESETPROP=resetprop
fi

reset_ro() {
  $RESETPROP -n "$1" "$2" 2>/dev/null || $RESETPROP "$1" "$2" 2>/dev/null
}

delete_prop() {
  $RESETPROP --delete "$1" 2>/dev/null
}

apply_props() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.kernel.android.qemud 0
  reset_ro ro.boot.qemu 0
  reset_ro ro.hardware cheetah
  reset_ro ro.boot.hardware cheetah
  reset_ro ro.product.model "Pixel 7 Pro"
  reset_ro ro.product.device cheetah
  reset_ro ro.product.name cheetah
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.build.type user
  reset_ro ro.build.tags release-keys
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro ro.boot.verifiedbootstate green
  reset_ro ro.boot.flash.locked 1
  reset_ro ro.boot.vbmeta.device_state locked
  reset_ro ro.boot.veritymode enforcing
  reset_ro ro.crypto.state encrypted

  delete_prop ro.boot.qemu.avd_name
  delete_prop init.svc.qemud
  delete_prop init.svc.qemu-props
  delete_prop init.svc.goldfish-logcat
  delete_prop init.svc.goldfish-setup
}

bind_hide_file() {
  target="$1"
  [ -e "$target" ] || return 0
  hide="$MODDIR/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")"
  : > "$hide"
  chmod 000 "$hide"
  mount -o bind "$hide" "$target" 2>/dev/null && log "hidden $target"
}

apply_props

# Hide common emulator pipes/sockets checked at runtime.
bind_hide_file /dev/qemu_pipe
bind_hide_file /dev/goldfish_pipe
bind_hide_file /dev/goldfish_sync
bind_hide_file /dev/socket/qemud
bind_hide_file /dev/socket/genyd
bind_hide_file /dev/socket/baseband_genyd
bind_hide_file /sys/qemu_trace

log "post-fs-data applied"
