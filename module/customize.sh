#!/system/bin/sh

ui_print "*************************************"
ui_print " Universal Root Hide - ALL UPI Apps"
ui_print " FreeRecharge logic + multi Pixel"
ui_print "*************************************"
ui_print " Profiles: pixel7 pixel7pro pixel8pro"
ui_print "           pixel9 pixel9a pixel9proxl"
ui_print " Edit profile.conf after install"
ui_print " Default: pixel9proxl (FreeCharge)"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/common/apply.sh" 0 0 0755
set_perm "$MODPATH/profile.conf" 0 0 0644

mkdir -p "$MODPATH/hide"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600

# Keep user profile across updates if already configured
if [ -f "$NVBASE/modules/$MODID/profile.conf" ]; then
  cp -f "$NVBASE/modules/$MODID/profile.conf" "$MODPATH/profile.conf"
fi
