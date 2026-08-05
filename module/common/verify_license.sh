#!/system/bin/sh
MODDIR="${0%/*}/.."
. "$MODDIR/common/license.sh"

if is_licensed "$MODDIR"; then
  echo "LICENSED"
  echo "OK"
  exit 0
fi

echo "UNLICENSED"
echo "Contact @Hivirtus on Telegram for OTP approval"
exit 1
