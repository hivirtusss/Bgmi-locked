#!/system/bin/sh
# Boot-safe wrapper — never block or crash boot

VIRTUS_MODULE_ID=virtus_fix_emulator_hide

resolve_moddir() {
  _script="$1"
  _base=${_script%/*}

  if [ -n "$_base" ] && [ "$_base" != "$_script" ] && [ -f "$_base/module.prop" ]; then
    echo "$_base"
    return 0
  fi

  for _p in \
    "/data/adb/modules/$VIRTUS_MODULE_ID" \
    "/data/adb/modules_update/$VIRTUS_MODULE_ID"; do
    if [ -f "$_p/module.prop" ]; then
      echo "$_p"
      return 0
    fi
  done

  if [ -n "$_base" ] && [ "$_base" != "$_script" ]; then
    echo "$_base"
  else
    echo "/data/adb/modules/$VIRTUS_MODULE_ID"
  fi
}

safe_log() {
  /system/bin/log -t virtus_fix -p i "$1" 2>/dev/null || true
}

# Defer heavy work — post-fs-data must return instantly (prevents emulator bootloop)
safe_run() {
  (
    sleep 12
    set +e
    umask 022
    "$@"
  ) &
}

read_config() {
  conf="$1"
  profile=""
  file_hide=0
  late_only=1

  [ -f "$conf" ] || return 0

  profile=$(grep -E '^profile=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  fh=$(grep -E '^file_hide=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  lo=$(grep -E '^late_file_hide=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')

  [ "$fh" = "1" ] && file_hide=1
  [ "$lo" = "0" ] && late_only=0

  export URH_PROFILE="$profile"
  export URH_FILE_HIDE="$file_hide"
  export URH_LATE_ONLY="$late_only"
}
