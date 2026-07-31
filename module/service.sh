#!/system/bin/sh
# Re-apply universal props after late boot (all apps, all emulators)
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

# Re-apply critical props (FreeRecharge + extended)
reset_ro ro.kernel.qemu 0
reset_ro ro.boot.qemu 0
reset_ro ro.hardware pixel
reset_ro ro.product.model "Pixel 9 Pro XL"
reset_ro ro.product.device pantah
reset_ro ro.build.type user
reset_ro ro.build.tags release-keys
reset_ro ro.debuggable 0
reset_ro ro.secure 1
reset_ro ro.dalvik.vm.native.bridge 0
reset_ro ro.boot.verifiedbootstate green
reset_ro ro.boot.flash.locked 1

bind_hide_file() {
  target="$1"
  [ -e "$target" ] || return 0
  hide="$MODDIR/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")"
  [ -f "$hide" ] || : > "$hide"
  chmod 000 "$hide"
  mount | grep -Fq " $target " || mount -o bind "$hide" "$target" 2>/dev/null
}

for path in \
  /dev/qemu_pipe \
  /dev/goldfish_pipe \
  /dev/socket/qemud \
  /su \
  /sbin/su \
  /system/bin/su \
  /system/xbin/su; do
  bind_hide_file "$path"
done
