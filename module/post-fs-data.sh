#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"
virtus_apply_all "$MODDIR"
safe_log "post-fs-data OK"
