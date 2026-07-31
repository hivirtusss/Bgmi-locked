#!/system/bin/sh
# Universal Root & Emulator Hide - post-fs-data
# Based on FreeRecharge Emulator Hide logic, expanded for ALL apps
MODDIR=${0%/*}

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

apply_universal_props() {
  # --- FreeRecharge module core logic (now universal) ---
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud ""
  reset_ro ro.build.characteristics nosdcard
  reset_ro ro.boot.mode normal
  reset_ro ro.hardware pixel
  reset_ro ro.boot.hardware pixel
  reset_ro ro.product.device pantah
  reset_ro ro.vendor.product.device pantah
  reset_ro ro.product.model "Pixel 9 Pro XL"
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.product.name pantah
  reset_ro ro.build.fingerprint "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user

  # --- Extended A-Z hide for UPI / banking / all APKs ---
  reset_ro ro.bootimage.build.fingerprint "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
  reset_ro ro.vendor.build.fingerprint "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
  reset_ro ro.system.build.fingerprint "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro ro.allow.mock.location 0
  reset_ro persist.sys.usb.config mtp
  reset_ro service.adb.root 0
  reset_ro ro.build.selinux 1
  reset_ro ro.boot.verifiedbootstate green
  reset_ro ro.boot.veritymode enforcing
  reset_ro ro.boot.flash.locked 1
  reset_ro ro.boot.vbmeta.device_state locked
  reset_ro ro.boot.warranty_bit 0
  reset_ro ro.warranty_bit 0
  reset_ro ro.is_ever_orange 0
  reset_ro ro.crypto.state encrypted
  reset_ro ro.dalvik.vm.native.bridge 0
  reset_ro ro.enable.native.bridge.exec 0
  reset_ro persist.sys.nativebridge 0
  reset_ro ro.magisk.version ""
  reset_ro ro.magisk.versioncode 0

  delete_prop ro.boot.qemu.avd_name
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
  mount -o bind "$hide" "$target" 2>/dev/null
}

apply_universal_props

# Emulator file paths checked by UPI/banking apps
bind_hide_file /dev/qemu_pipe
bind_hide_file /dev/goldfish_pipe
bind_hide_file /dev/goldfish_sync
bind_hide_file /dev/socket/qemud
bind_hide_file /dev/socket/genyd
bind_hide_file /dev/socket/baseband_genyd
bind_hide_file /sys/qemu_trace
bind_hide_file /system/lib/libc_malloc_debug_qemu.so
bind_hide_file /system/lib64/libc_malloc_debug_qemu.so
bind_hide_file /system/bin/qemu-props
bind_hide_file /init.goldfish.rc
bind_hide_file /init.ranchu.rc

# Common root binary paths
bind_hide_file /su
bind_hide_file /sbin/su
bind_hide_file /system/bin/su
bind_hide_file /system/xbin/su
bind_hide_file /vendor/bin/su
bind_hide_file /cache/su
bind_hide_file /data/local/su
bind_hide_file /data/local/bin/su
bind_hide_file /data/local/xbin/su

/system/bin/log -t universal_root_hide -p i "Universal hide loaded (all apps)" 2>/dev/null
