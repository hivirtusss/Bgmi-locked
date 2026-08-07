#!/system/bin/sh
# VirtusFix v8.2 — FreeRecharge core + real fingerprint (BharatPe/Jio/FreeCharge no crash)

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

load_profile() {
  moddir="$1"
  profile=""
  [ -f "$moddir/profile.conf" ] && \
    profile=$(grep -E '^profile=' "$moddir/profile.conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  case "$profile" in
    pixel7|panther)
      CODENAME=panther
      MODEL="Pixel 7"
      ;;
    pixel9|tokay)
      CODENAME=tokay
      MODEL="Pixel 9"
      ;;
    pixel9proxl|komodo|pantah)
      CODENAME=komodo
      MODEL="Pixel 9 Pro XL"
      ;;
    pixel9a|tegu|*)
      CODENAME=tegu
      MODEL="Pixel 9a"
      ;;
  esac
}

sync_profile_from_device() {
  cur_dev=$(getprop ro.product.device)
  case "$cur_dev" in
    tegu)
      CODENAME=tegu
      MODEL="Pixel 9a"
      ;;
    tokay)
      CODENAME=tokay
      MODEL="Pixel 9"
      ;;
    panther)
      CODENAME=panther
      MODEL="Pixel 7"
      ;;
    komodo)
      CODENAME=komodo
      MODEL="Pixel 9 Pro XL"
      ;;
  esac
}

virtus_qemu_core() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud null
  reset_ro ro.build.characteristics nosdcard
  reset_ro ro.boot.mode normal
  reset_ro ro.hardware pixel
  reset_ro ro.boot.hardware pixel
}

# Pixel AVD — qemu hide only, real device + fingerprint untouched (no crash)
virtus_apply_pixel_safe() {
  virtus_qemu_core
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user
  echo "safe:$CODENAME"
}

# Generic emulator — full FreeRecharge spoof but REAL fingerprint from device
virtus_apply_full_safe() {
  moddir="$1"
  real_fp=$(getprop ro.build.fingerprint)
  [ -z "$real_fp" ] && real_fp="google/$CODENAME/$CODENAME:16/BP31.250610.009/12345678:user/release-keys"

  virtus_qemu_core
  reset_ro ro.product.device "$CODENAME"
  reset_ro ro.vendor.product.device "$CODENAME"
  reset_ro ro.product.model "$MODEL"
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.build.fingerprint "$real_fp"
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user
  echo "full:$CODENAME"
}

virtus_apply_all() {
  moddir="$1"
  load_profile "$moddir"
  sync_profile_from_device
  cur_dev=$(getprop ro.product.device)

  case "$cur_dev" in
    tegu|tokay|panther|komodo)
      virtus_apply_pixel_safe
      ;;
    *)
      if [ "$cur_dev" = "$CODENAME" ]; then
        virtus_apply_pixel_safe
      else
        virtus_apply_full_safe "$moddir"
      fi
      ;;
  esac
}

virtus_restore_props() {
  :
}

update_module_status() {
  moddir="$1"
  status="$2"
  desc="$3"
  mp="$moddir/module.prop"
  tmp="$moddir/state/prop.new"

  mkdir -p "$moddir/state"
  echo "$status" > "$moddir/state/detection_status"

  [ ! -f "$mp" ] && return 1

  : > "$tmp"
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      description=*) printf '%s\n' "description=$desc" >> "$tmp" ;;
      *) printf '%s\n' "$line" >> "$tmp" ;;
    esac
  done < "$mp"

  cp -f "$tmp" "$mp" 2>/dev/null || cat "$tmp" > "$mp" 2>/dev/null
  rm -f "$tmp"
  chmod 644 "$mp" 2>/dev/null

  for inst in \
    "/data/adb/modules/virtus_fix_emulator_hide/module.prop" \
    "/data/adb/modules_update/virtus_fix_emulator_hide/module.prop"
  do
    cp -f "$mp" "$inst" 2>/dev/null
    chmod 644 "$inst" 2>/dev/null
  done

  sync 2>/dev/null || true
  return 0
}

read_boot_config() {
  moddir="$1"
  BOOT_APPLY=1
  [ -f "$moddir/profile.conf" ] || return 0
  ba=$(grep -E '^boot_apply=' "$moddir/profile.conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  [ "$ba" = "0" ] && BOOT_APPLY=0
}

apply_all_props() {
  virtus_apply_all "$1"
}

apply_boot_safe() {
  virtus_apply_all "$1"
}

hide_emulator_files_safe() {
  :
}
