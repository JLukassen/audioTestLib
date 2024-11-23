#!/system/bin/sh

MODDIR=${0%/*}
su -c "/system/bin/sh ${MODDIR}/extras/jitter-reducer.sh --thermal --battery --effect --doze --io kyber boost --vm --governor --camera --status"
