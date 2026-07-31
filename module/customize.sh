#!/system/bin/sh

ui_print "*******************************"
ui_print " Universal Root & Emulator Hide"
ui_print " ALL apps | ALL emulators"
ui_print " Pixel 9 Pro XL spoof"
ui_print "*******************************"
ui_print "- FreeCharge logic -> universal"
ui_print "- BharatPe Paytm PhonePe UPI etc."
ui_print "- Reboot after install"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755

mkdir -p "$MODPATH/hide"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600
