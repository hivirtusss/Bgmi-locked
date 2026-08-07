#!/system/bin/sh
# VirtusFix v8 — emulator detection hide ONLY (no universal root hide)

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

backup_original_props() {
  moddir="$1"
  bak="$moddir/state/original.props"
  [ -f "$bak" ] && return 0
  mkdir -p "$moddir/state"
  {
    echo "ro.kernel.qemu=$(getprop ro.kernel.qemu)"
    echo "ro.boot.qemu=$(getprop ro.boot.qemu)"
    echo "ro.hardware=$(getprop ro.hardware)"
    echo "ro.boot.hardware=$(getprop ro.boot.hardware)"
  } > "$bak" 2>/dev/null
}

# Emulator detection hide — fingerprint/device change NAHI (no crash)
virtus_apply_emulator_hide() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.kernel.android.qemud null
  reset_ro ro.boot.mode normal
  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.boot.qemu.virt_model
  delete_prop ro.kernel.su
  delete_prop init.svc.qemu-props
  delete_prop init.svc.goldfish-logcat
  delete_prop init.svc.goldfish-setup
  echo "emu-hide"
}

virtus_apply_all() {
  moddir="$1"
  backup_original_props "$moddir"
  virtus_apply_emulator_hide
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
