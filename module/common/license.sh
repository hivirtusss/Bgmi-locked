#!/system/bin/sh
# Virtus License + OTP verification — admin approves via GitHub approved.json

LICENSE_CONF=""
LICENSE_URL=""
CACHE_FILE=""
CACHE_DAYS=7

init_license_paths() {
  moddir="$1"
  LICENSE_CONF="$moddir/license.conf"
  CACHE_FILE="$moddir/state/license_ok"
  LICENSE_URL="https://raw.githubusercontent.com/hivirtusss/Bgmi-locked/cursor/emulator-root-fix-module-4843/licenses/approved.json"

  if [ -f "$LICENSE_CONF" ]; then
    custom_url=$(grep -E '^license_url=' "$LICENSE_CONF" 2>/dev/null | head -1 | cut -d= -f2- | tr -d ' "\r')
    [ -n "$custom_url" ] && LICENSE_URL="$custom_url"
  fi
}

read_license_input() {
  tg_id=""
  otp=""
  username=""

  [ ! -f "$LICENSE_CONF" ] && return 1

  tg_id=$(grep -E '^tg_id=' "$LICENSE_CONF" 2>/dev/null | head -1 | cut -d= -f2- | tr -d ' "\r')
  otp=$(grep -E '^otp=' "$LICENSE_CONF" 2>/dev/null | head -1 | cut -d= -f2- | tr -d ' "\r')
  username=$(grep -E '^username=' "$LICENSE_CONF" 2>/dev/null | head -1 | cut -d= -f2- | tr -d ' "\r')

  [ -n "$tg_id" ] || return 1
  return 0
}

cache_valid() {
  [ -f "$CACHE_FILE" ] || return 1
  now=$(date +%s 2>/dev/null)
  exp=$(grep '^expires=' "$CACHE_FILE" 2>/dev/null | cut -d= -f2)
  [ -n "$now" ] && [ -n "$exp" ] && [ "$now" -lt "$exp" ] && return 0
  return 1
}

write_cache() {
  moddir="$1"
  mkdir -p "$moddir/state"
  now=$(date +%s 2>/dev/null)
  [ -z "$now" ] && now=0
  exp=$((now + CACHE_DAYS * 86400))
  {
    echo "tg_id=$2"
    echo "verified=1"
    echo "expires=$exp"
    echo "verified_at=$now"
  } > "$CACHE_FILE"
}

clear_cache() {
  rm -f "$CACHE_FILE" 2>/dev/null
}

fetch_approved_json() {
  tmp="$1"
  rm -f "$tmp" 2>/dev/null

  if [ -x /data/adb/ksu/bin/curl ]; then
    /data/adb/ksu/bin/curl -fsSL "$LICENSE_URL" -o "$tmp" 2>/dev/null && return 0
  fi
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$LICENSE_URL" -o "$tmp" 2>/dev/null && return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$tmp" "$LICENSE_URL" 2>/dev/null && return 0
  fi
  return 1
}

verify_against_server() {
  tg_id="$1"
  otp="$2"
  json="$3"

  [ -f "$json" ] || return 1

  grep -q "\"tg_id\"[[:space:]]*:[[:space:]]*\"$tg_id\"" "$json" || \
    grep -q "\"tg_id\"[[:space:]]*:[[:space:]]*$tg_id" "$json" || return 1

  if grep -A6 "\"tg_id\"[[:space:]]*:[[:space:]]*\"$tg_id\"" "$json" | grep -q '"status"[[:space:]]*:[[:space:]]*"approved"'; then
    return 0
  fi
  if grep -A6 "\"tg_id\"[[:space:]]*:[[:space:]]*'$tg_id'" "$json" | grep -q '"status"[[:space:]]*:[[:space:]]*"approved"'; then
    return 0
  fi

  [ -z "$otp" ] && return 1

  if grep -A6 "\"tg_id\"[[:space:]]*:[[:space:]]*\"$tg_id\"" "$json" | grep -q "\"otp\"[[:space:]]*:[[:space:]]*\"$otp\""; then
    return 0
  fi
  if grep -A6 "\"tg_id\"[[:space:]]*:[[:space:]]*$tg_id" "$json" | grep -q "\"otp\"[[:space:]]*:[[:space:]]*\"$otp\""; then
    return 0
  fi

  return 1
}

is_licensed() {
  moddir="$1"
  init_license_paths "$moddir"

  if cache_valid; then
    return 0
  fi

  read_license_input || return 1

  tmp="$moddir/state/approved_fetch.json"
  fetch_approved_json "$tmp" || return 1

  if verify_against_server "$tg_id" "$otp"; then
    write_cache "$moddir" "$tg_id"
    rm -f "$tmp"
    return 0
  fi

  rm -f "$tmp"
  return 1
}

verify_and_report() {
  moddir="$1"
  init_license_paths "$moddir"

  if is_licensed "$moddir"; then
    echo "LICENSED"
    return 0
  fi

  echo "UNLICENSED"
  return 1
}
