#!/system/bin/sh

if [ "$KSU" = "true" ]; then
  POWERED_BY="KernelSU"
elif [ -n "$APATCH" ]; then
  POWERED_BY="APatch"
elif [ -n "$MAGISK_VER" ]; then
  POWERED_BY="Magisk"
else
  POWERED_BY="KernelSU"
fi

INSTALL_PATH="$MODPATH"
[ -z "$INSTALL_PATH" ] && INSTALL_PATH="$NVBASE/modules/$MODID"
[ -z "$INSTALL_PATH" ] && INSTALL_PATH="/data/adb/modules/$MODID"

module_size_kb() {
  bytes=0
  if [ -n "$ZIPPATH" ] && [ -f "$ZIPPATH" ]; then
    bytes=$(wc -c < "$ZIPPATH" 2>/dev/null | tr -d ' ')
  fi
  [ -z "$bytes" ] && bytes=0
  awk "BEGIN {printf \"%.2f\", $bytes/1024}"
}

SIZE_KB=$(module_size_kb)

ui_print "- Module size: ${SIZE_KB} kB"
ui_print "- Installing to $INSTALL_PATH"
ui_print "- Running module installer"
ui_print ""

ui_print "*******************************"
ui_print " VirtusFix Premium Root Hide V3 🔝"
ui_print " by @Hivirtus"
ui_print " Powered by $POWERED_BY"
ui_print "*******************************"
ui_print ""

TS=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
[ -z "$TS" ] && TS="boot"

ui_print "$TS [VIRTUS_INIT] Start"
ui_print "$TS [SET_TARGET] Writing profile.conf"
ui_print "$TS [SET_EMU_HIDE] Configuring emulator bypass"
ui_print "$TS [SET_ROOT_HIDE] Configuring root shield"
ui_print "$TS [VIRTUS_INIT] Finish"
ui_print ""

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/boot-completed.sh" 0 0 0755
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm "$MODPATH/common/apply.sh" 0 0 0755
set_perm "$MODPATH/common/safe_boot.sh" 0 0 0755
set_perm "$MODPATH/profile.conf" 0 0 0644

touch "$MODPATH/skip_mount"
mkdir -p "$MODPATH/hide" "$MODPATH/state" "$MODPATH/icon"
set_perm_recursive "$MODPATH/hide" 0 0 0700 0600
set_perm_recursive "$MODPATH/icon" 0 0 0755 0644

echo "WAIT" > "$MODPATH/state/detection_status"
grep -v '^description=' "$MODPATH/module.prop" > "$MODPATH/state/prop.tmp" 2>/dev/null
echo 'description=❌ Tap Action 🎯 then Hide Root in KernelSU @Hivirtus ❤️' >> "$MODPATH/state/prop.tmp"
cat "$MODPATH/state/prop.tmp" > "$MODPATH/module.prop"
rm -f "$MODPATH/state/prop.tmp"

if [ -f "$NVBASE/modules/$MODID/profile.conf" ]; then
  cp -f "$NVBASE/modules/$MODID/profile.conf" "$MODPATH/profile.conf"
fi

ui_print "Done Install ✅"
ui_print "Reboot device to activate"
ui_print "Then Press Action Button 🎯"
ui_print ""
ui_print "⚠️ KernelSU → BharatPe/Freo"
ui_print "   → Hide Root ON (required!)"
ui_print ""
ui_print "Developed By @Hivirtus"
ui_print "Redirecting to Telegram @clamflat..."

(
  sleep 1
  am start -a android.intent.action.VIEW -d "tg://resolve?domain=clamflat" >/dev/null 2>&1 \
    || am start -a android.intent.action.VIEW -d "https://t.me/clamflat" >/dev/null 2>&1
) &
