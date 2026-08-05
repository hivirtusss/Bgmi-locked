#!/system/bin/sh

ui_print "╔════════════════════════════════════════╗"
ui_print "   Virtus Fix & Emulator Hide Premium   "
ui_print "        Developed By @Hivirtus          "
ui_print "╚════════════════════════════════════════╝"
ui_print ""
ui_print "❌ Detection Fail (default)"
ui_print "🎯 Press ACTION button to fix"
ui_print "Root Hide + Emu Hide + UPI Bypass"
ui_print ""
ui_print "Profiles: pixel7/7pro/8pro/9/9a/9proxl"
ui_print "Bootloop-safe | Smooth emulator boot"
ui_print ""

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/boot-completed.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/common/apply.sh" 0 0 0755
set_perm "$MODPATH/common/safe_boot.sh" 0 0 0755
set_perm "$MODPATH/profile.conf" 0 0 0644

touch "$MODPATH/skip_mount"
mkdir -p "$MODPATH/hide" "$MODPATH/state" "$MODPATH/icon"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600
set_perm_recursive "$MODPATH/icon" 0 0 0755 0644

# Reset detection status on fresh install
echo "FAIL" > "$MODPATH/state/detection_status"
sed -i 's/^description=.*/description=❌ Detection Fail | Press Action Button 🎯 Root Hide Fix Emu By @Hivirtus ❤️/' "$MODPATH/module.prop" 2>/dev/null

if [ -f "$NVBASE/modules/$MODID/profile.conf" ]; then
  cp -f "$NVBASE/modules/$MODID/profile.conf" "$MODPATH/profile.conf"
fi

if [ -f "$NVBASE/modules/$MODID/state/detection_status" ]; then
  cp -f "$NVBASE/modules/$MODID/state/detection_status" "$MODPATH/state/detection_status"
fi
