#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"

read_config "$MODDIR/profile.conf"

virtus_deferred_apply() {
  _md="$1"
  . "$_md/common/upi_banking.sh"
  . "$_md/common/universal_banking.sh"
  . "$_md/common/apply.sh"
  read_config "$_md/profile.conf"
  apply_all_props "$_md"
  safe_log "service full apply OK"
}

(
  sleep 30
  virtus_deferred_apply "$MODDIR"
) &

(
  sleep 75
  virtus_deferred_apply "$MODDIR"
) &

safe_log "service scheduled 30s+75s"
