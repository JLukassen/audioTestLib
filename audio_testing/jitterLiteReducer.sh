#!/system/bin/sh

MODDIR=${0%/*}
su -c "/system/bin/sh ${MODDIR}/extras/jitter-reducer.sh --thermal --battery --doze --camera --status"
