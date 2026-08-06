#!/system/bin/sh
# Boot-safe wrapper — never block or crash boot

safe_log() {
  /system/bin/log -t virtus_fix -p i "$1" 2>/dev/null || true
}

safe_run() {
  (
    sleep 1
    set +e
    umask 022
    "$@"
  ) &
}

read_config() {
  conf="$1"
  profile=""
  file_hide=1
  late_only=1

  [ -f "$conf" ] || return 0

  profile=$(grep -E '^profile=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  fh=$(grep -E '^file_hide=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  lo=$(grep -E '^late_file_hide=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')

  [ "$fh" = "0" ] && file_hide=0
  [ "$lo" = "0" ] && late_only=0

  export URH_PROFILE="$profile"
  export URH_FILE_HIDE="$file_hide"
  export URH_LATE_ONLY="$late_only"
}
