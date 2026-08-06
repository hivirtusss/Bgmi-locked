#!/system/bin/sh
# VirtusFix v6 — proven FreeRecharge core + minimal universal (no crash props)

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

load_profile() {
  moddir="$1"
  profile=""
  if [ -f "$moddir/profile.conf" ]; then
    profile=$(grep -E '^profile=' "$moddir/profile.conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  fi
  case "$profile" in
    pixel6a|bluejay)
      CODENAME=bluejay
      MODEL="Pixel 6a"
      FP="google/bluejay/bluejay:14/AP2A.240805.005/12345678:user/release-keys"
      ;;
    pixel7|panther)
      CODENAME=panther
      MODEL="Pixel 7"
      FP="google/panther/panther:14/AP2A.240805.005/12025142:user/release-keys"
      ;;
    pixel9proxl|pantah|*)
      CODENAME=pantah
      MODEL="Pixel 9 Pro XL"
      FP="google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys"
      ;;
  esac
}

# Main apply — same as working FreeRecharge drive zip + safe extras only
virtus_apply_all() {
  moddir="$1"
  load_profile "$moddir"

  # === FreeRecharge exact (proven working) ===
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud null
  reset_ro ro.build.characteristics nosdcard
  reset_ro ro.boot.mode normal
  reset_ro ro.hardware pixel
  reset_ro ro.boot.hardware pixel
  reset_ro ro.product.device "$CODENAME"
  reset_ro ro.vendor.product.device "$CODENAME"
  reset_ro ro.product.model "$MODEL"
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.build.fingerprint "$FP"
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user

  # === Minimal universal (all UPI apps, boot-safe) ===
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro service.adb.root 0
  reset_ro ro.boot.verifiedbootstate green
  reset_ro ro.boot.flash.locked 1
  reset_ro ro.boot.vbmeta.device_state locked
  reset_ro ro.dalvik.vm.native.bridge 0
  reset_ro ro.magisk.version ""
  reset_ro ro.magisk.versioncode 0

  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.kernel.su

  echo "$CODENAME"
}

update_module_status() {
  moddir="$1"
  status="$2"
  desc="$3"
  mp="$moddir/module.prop"
  tmp="$moddir/state/prop.tmp"

  mkdir -p "$moddir/state"
  echo "$status" > "$moddir/state/detection_status"

  if [ -f "$mp" ]; then
    grep -v '^description=' "$mp" > "$tmp" 2>/dev/null || cat "$mp" > "$tmp"
    echo "description=$desc" >> "$tmp"
    cat "$tmp" > "$mp"
    rm -f "$tmp"
    cp -f "$mp" "/data/adb/modules/virtus_fix_emulator_hide/module.prop" 2>/dev/null
  fi
}

apply_all_props() {
  virtus_apply_all "$1"
}

apply_boot_safe() {
  virtus_apply_all "$1"
}

hide_emulator_files_safe() {
  : # disabled v6 — bind mounts were causing app crashes
}
