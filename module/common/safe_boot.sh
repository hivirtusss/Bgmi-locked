#!/system/bin/sh
# Boot-safe helpers

VIRTUS_MODULE_ID=virtus_fix_emulator_hide

resolve_moddir() {
  _script="$1"
  _base=${_script%/*}
  if [ -n "$_base" ] && [ "$_base" != "$_script" ] && [ -f "$_base/module.prop" ]; then
    echo "$_base"
    return 0
  fi
  for _p in "/data/adb/modules/$VIRTUS_MODULE_ID" "/data/adb/modules_update/$VIRTUS_MODULE_ID"; do
    [ -f "$_p/module.prop" ] && echo "$_p" && return 0
  done
  echo "/data/adb/modules/$VIRTUS_MODULE_ID"
}

safe_log() {
  log -t virtus_fix -p i "$1" 2>/dev/null || true
}

read_config() {
  :
}
