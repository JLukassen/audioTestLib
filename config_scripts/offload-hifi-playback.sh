#!/system/bin/sh

MODDIR=${0%/*/*/*}
su --mount-master -c "/system/bin/sh ${MODDIR}/SP/scripts/USB_SampleRate_Changer.sh --offload-hifi-playback 192k 32"
