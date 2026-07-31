#!/system/bin/sh

ui_print "*************************************"
ui_print " Universal Root Hide v3.1 SAFE"
ui_print " Bootloop-safe | Smooth emulator"
ui_print "*************************************"
ui_print "- Props only at early boot (safe)"
ui_print "- File hide runs AFTER boot (late)"
ui_print "- NO /system bind mounts"
ui_print "- Profiles: pixel7/7pro/8pro/9/9a/9proxl"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/boot-completed.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/common/apply.sh" 0 0 0755
set_perm "$MODPATH/common/safe_boot.sh" 0 0 0755
set_perm "$MODPATH/profile.conf" 0 0 0644

# Tell KernelSU: do NOT mount any system/ overlay from this module
touch "$MODPATH/skip_mount"

mkdir -p "$MODPATH/hide"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600

if [ -f "$NVBASE/modules/$MODID/profile.conf" ]; then
  cp -f "$NVBASE/modules/$MODID/profile.conf" "$MODPATH/profile.conf"
fi
