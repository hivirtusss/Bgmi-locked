#!/system/bin/sh
# VirtusFix v7.1 — light/auto/full apply modes

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
      FP="google/panther/panther:16/BP31.250610.009/12025142:user/release-keys"
      ;;
    pixel9|tokay)
      CODENAME=tokay
      MODEL="Pixel 9"
      FP="google/tokay/tokay:16/BP31.250610.009/12345678:user/release-keys"
      ;;
    pixel9a|tegu)
      CODENAME=tegu
      MODEL="Pixel 9a"
      FP="google/tegu/tegu:16/BP31.250610.009/12345678:user/release-keys"
      ;;
    pixel9proxl|komodo|pantah)
      CODENAME=komodo
      MODEL="Pixel 9 Pro XL"
      FP="google/komodo/komodo:16/BP31.250610.009/12345678:user/release-keys"
      ;;
    *)
      CODENAME=tokay
      MODEL="Pixel 9"
      FP="google/tokay/tokay:16/BP31.250610.009/12345678:user/release-keys"
      ;;
  esac
}

read_apply_mode() {
  moddir="$1"
  APPLY_MODE=auto
  [ -f "$moddir/profile.conf" ] || return 0
  m=$(grep -E '^mode=' "$moddir/profile.conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  case "$m" in
    light|full|auto) APPLY_MODE="$m" ;;
  esac
}

backup_original_props() {
  moddir="$1"
  bak="$moddir/state/original.props"
  [ -f "$bak" ] && return 0
  mkdir -p "$moddir/state"
  {
    echo "ro.kernel.qemu=$(getprop ro.kernel.qemu)"
    echo "ro.boot.qemu=$(getprop ro.boot.qemu)"
    echo "ro.product.device=$(getprop ro.product.device)"
    echo "ro.product.model=$(getprop ro.product.model)"
    echo "ro.build.fingerprint=$(getprop ro.build.fingerprint)"
    echo "ro.hardware=$(getprop ro.hardware)"
    echo "ro.debuggable=$(getprop ro.debuggable)"
  } > "$bak" 2>/dev/null
}

# Safe for Pixel/Google Play AVD — hides emulator only, keeps real fingerprint
virtus_apply_light() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud null
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.boot.qemu.virt_model
  delete_prop ro.kernel.su
  echo "light"
}

# Full spoof for generic/x86 emulators only
virtus_apply_full() {
  moddir="$1"
  real_fp=$(getprop ro.build.fingerprint)
  real_dev=$(getprop ro.product.device)
  use_fp="$FP"
  if [ -n "$real_fp" ] && [ "$real_dev" = "$CODENAME" ]; then
    use_fp="$real_fp"
  fi

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
  reset_ro ro.build.fingerprint "$use_fp"
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user
  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  echo "full:$CODENAME"
}

virtus_apply_all() {
  moddir="$1"
  load_profile "$moddir"
  read_apply_mode "$moddir"
  backup_original_props "$moddir"

  cur_dev=$(getprop ro.product.device)
  pick="$APPLY_MODE"
  if [ "$pick" = "auto" ]; then
    if [ "$cur_dev" = "$CODENAME" ] || [ "$cur_dev" = "sdk_gphone64_arm64" ] || [ "$cur_dev" = "emu64a" ]; then
      pick=light
    else
      pick=full
    fi
  fi

  case "$pick" in
    light) virtus_apply_light ;;
    *) virtus_apply_full "$moddir" ;;
  esac
}

virtus_restore_props() {
  moddir="$1"
  bak="$moddir/state/original.props"
  if [ ! -f "$bak" ]; then
    echo "no-backup"
    return 1
  fi
  while IFS= read -r line || [ -n "$line" ]; do
    key=${line%%=*}
    val=${line#*=}
    [ -z "$key" ] && continue
    [ "$key" = "$line" ] && continue
    reset_ro "$key" "$val"
  done < "$bak"
  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  echo "restored"
  return 0
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
  BOOT_APPLY=0
  [ -f "$moddir/profile.conf" ] || return 0
  ba=$(grep -E '^boot_apply=' "$moddir/profile.conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  [ "$ba" = "1" ] && BOOT_APPLY=1
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
