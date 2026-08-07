#!/system/bin/sh
# VirtusFix v8.3 — FreeCharge/BharatPe/Jio emulator detection kill (Pixel 9a tegu)

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
    tegu) CODENAME=tegu; MODEL="Pixel 9a" ;;
    tokay) CODENAME=tokay; MODEL="Pixel 9" ;;
    panther) CODENAME=panther; MODEL="Pixel 7" ;;
    komodo) CODENAME=komodo; MODEL="Pixel 9 Pro XL" ;;
  esac
}

bind_hide_file_safe() {
  moddir="$1"
  target="$2"
  [ -e "$target" ] || return 0
  case "$target" in
    /system/*|/vendor/*|/product/*|/system_ext/*) return 0 ;;
  esac
  mount | grep -Fq " $target " && return 0
  hide="$moddir/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")" 2>/dev/null || return 0
  : > "$hide" 2>/dev/null || return 0
  chmod 000 "$hide" 2>/dev/null || true
  mount -o bind "$hide" "$target" 2>/dev/null || true
}

hide_emulator_files_safe() {
  moddir="$1"
  for path in \
    /dev/qemu_pipe \
    /dev/goldfish_pipe \
    /dev/goldfish_sync \
    /dev/goldfish_address_space \
    /dev/socket/qemud \
    /dev/socket/genyd \
    /dev/socket/baseband_genyd \
    /sys/qemu_trace \
    /sys/devices/virtual/misc/qemu_pipe \
    /sys/devices/virtual/misc/goldfish_pipe; do
    bind_hide_file_safe "$moddir" "$path"
  done
}

# FreeRecharge proven + real fingerprint (FreeCharge emulator popup fix)
virtus_apply_all() {
  moddir="$1"
  load_profile "$moddir"
  sync_profile_from_device

  real_fp=$(getprop ro.build.fingerprint)
  [ -z "$real_fp" ] && real_fp="google/$CODENAME/$CODENAME:16/BP31.250610.009/12345678:user/release-keys"

  # === FreeRecharge drive exact ===
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
  reset_ro ro.build.fingerprint "$real_fp"
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user

  # === Android isEmulator() kill ===
  reset_ro ro.product.name "$CODENAME"
  reset_ro ro.build.product "$CODENAME"
  reset_ro ro.test_harness 0
  reset_ro ro.monkey 0
  reset_ro ro.kernel.qemu.gles 0
  reset_ro ro.kernel.qemu.dalvik 0

  # === AVD name leak (FreeCharge checks this) ===
  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.boot.qemu.virt_model

  hide_emulator_files_safe "$moddir"
  echo "freecharge:$CODENAME"
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
