#!/system/bin/sh
# Shared apply logic — bootloop-safe (FreeRecharge props + universal UPI hide)

if [ -x /data/adb/ksu/bin/resetprop ]; then
  RESETPROP=/data/adb/ksu/bin/resetprop
elif [ -x /data/adb/magisk/magisk ]; then
  RESETPROP="/data/adb/magisk/magisk resetprop"
else
  RESETPROP=resetprop
fi

reset_ro() {
  $RESETPROP -n "$1" "$2" 2>/dev/null || $RESETPROP "$1" "$2" 2>/dev/null || true
}

delete_prop() {
  $RESETPROP --delete "$1" 2>/dev/null || true
}

# Exact FreeRecharge reference logic — props only, proven safe on emulators
apply_freecharge_core() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud null
  reset_ro ro.build.characteristics nosdcard
  reset_ro ro.boot.mode normal
  reset_ro ro.hardware pixel
  reset_ro ro.boot.hardware pixel
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user
}

# Extra UPI/root props — all failures ignored, never abort boot
apply_universal_upi_hide() {
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro ro.allow.mock.location 0
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
  reset_ro ro.magisk.version ""
  reset_ro ro.magisk.versioncode 0

  # Native bridge — optional, can cause issues on some x86 setups; skip if fails
  reset_ro ro.dalvik.vm.native.bridge 0
  reset_ro ro.enable.native.bridge.exec 0
  reset_ro persist.sys.nativebridge 0

  delete_prop ro.boot.qemu.avd_name
  delete_prop init.svc.qemu-props
  delete_prop init.svc.goldfish-logcat
  delete_prop init.svc.goldfish-setup
}

apply_device_profile() {
  codename="$1"
  model="$2"
  fingerprint="$3"

  reset_ro ro.product.device "$codename"
  reset_ro ro.vendor.product.device "$codename"
  reset_ro ro.product.name "$codename"
  reset_ro ro.product.model "$model"
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.build.product "$codename"
  reset_ro ro.product.board "$codename"
  reset_ro ro.build.fingerprint "$fingerprint"
  reset_ro ro.bootimage.build.fingerprint "$fingerprint"
  reset_ro ro.vendor.build.fingerprint "$fingerprint"
  reset_ro ro.system.build.fingerprint "$fingerprint"
  reset_ro ro.odm.build.fingerprint "$fingerprint"
  reset_ro ro.build.flavor "${codename}-user"
}

load_selected_profile() {
  moddir="$1"
  conf="$moddir/profile.conf"
  profile=""

  if [ -n "$URH_PROFILE" ]; then
    profile="$URH_PROFILE"
  elif [ -f "$conf" ]; then
    profile=$(grep -E '^profile=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  fi

  [ -z "$profile" ] && profile=pixel9proxl

  case "$profile" in
    pixel7|panther)
      apply_device_profile panther "Pixel 7" \
        "google/panther/panther:14/AP2A.240805.005/12025142:user/release-keys"
      echo "pixel7"
      ;;
    pixel7pro|cheetah)
      apply_device_profile cheetah "Pixel 7 Pro" \
        "google/cheetah/cheetah:14/AP2A.240805.005/12025142:user/release-keys"
      echo "pixel7pro"
      ;;
    pixel8pro|husky)
      apply_device_profile husky "Pixel 8 Pro" \
        "google/husky/husky:14/AP2A.240905.003/12345678:user/release-keys"
      echo "pixel8pro"
      ;;
    pixel9|tokay)
      apply_device_profile tokay "Pixel 9" \
        "google/tokay/tokay:15/AP3A.241005.015/1234567:user/release-keys"
      echo "pixel9"
      ;;
    pixel9a|akita)
      apply_device_profile akita "Pixel 9a" \
        "google/akita/akita:15/AP3A.241005.015/1234567:user/release-keys"
      echo "pixel9a"
      ;;
    pixel9proxl|pantah|*)
      apply_device_profile pantah "Pixel 9 Pro XL" \
        "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
      echo "pixel9proxl"
      ;;
  esac
}

# SAFE file hide — NEVER touch /system or /vendor (bootloop risk on emulators)
# Only emulator-specific dev/socket paths (same as safe industry practice)
bind_hide_file_safe() {
  moddir="$1"
  target="$2"

  [ -e "$target" ] || return 0
  case "$target" in
    /system/*|/vendor/*|/product/*|/system_ext/*)
      return 0
      ;;
  esac

  hide="$moddir/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")" 2>/dev/null || return 0
  : > "$hide" 2>/dev/null || return 0
  chmod 000 "$hide" 2>/dev/null || true
  mount | grep -Fq " $target " && return 0
  mount -o bind "$hide" "$target" 2>/dev/null || true
}

hide_emulator_files_safe() {
  moddir="$1"
  for path in \
    /dev/qemu_pipe \
    /dev/goldfish_pipe \
    /dev/goldfish_sync \
    /dev/socket/qemud \
    /dev/socket/genyd \
    /dev/socket/baseband_genyd \
    /sys/qemu_trace; do
    bind_hide_file_safe "$moddir" "$path"
  done

  # Non-system su symlinks only — never bind /system/bin/su
  for path in /su /sbin/su /cache/su /data/local/su /data/local/bin/su /data/local/xbin/su; do
    bind_hide_file_safe "$moddir" "$path"
  done
}

apply_all_props() {
  moddir="$1"
  apply_freecharge_core
  apply_universal_upi_hide
  load_selected_profile "$moddir"
}