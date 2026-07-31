#!/system/bin/sh
# KernelSU module installer customization

ui_print "- Emulator Root & Detection Fix"
ui_print "- Target: KernelSU emulators (x86/x86_64/arm64)"
ui_print "- After install: reboot, then configure app profiles in KernelSU Manager"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755

mkdir -p "$MODPATH/hide"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600
