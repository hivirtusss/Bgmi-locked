#!/system/bin/sh
# Late boot cleanup for stubborn props and emulator files.
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

# Re-apply critical props after late init.
reset_ro ro.kernel.qemu 0
reset_ro ro.boot.qemu 0
reset_ro ro.debuggable 0
reset_ro ro.secure 1
reset_ro ro.build.type user
reset_ro ro.build.tags release-keys

bind_hide_file() {
  target="$1"
  [ -e "$target" ] || return 0
  hide="$MODDIR/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")"
  [ -f "$hide" ] || : > "$hide"
  chmod 000 "$hide"
  mount | grep -Fq " $target " || mount -o bind "$hide" "$target" 2>/dev/null
}

bind_hide_file /dev/qemu_pipe
bind_hide_file /dev/goldfish_pipe
bind_hide_file /dev/socket/qemud

# Best-effort: hide obvious su paths if present (non-systemless fallback).
for su_path in /su /sbin/su; do
  [ -e "$su_path" ] || continue
  hide="$MODDIR/hide/$(echo "$su_path" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")"
  [ -f "$hide" ] || : > "$hide"
  mount | grep -Fq " $su_path " || mount -o bind "$hide" "$su_path" 2>/dev/null
done
