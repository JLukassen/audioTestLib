#!/system/bin/sh

# Default period in microseconds
period_us=2250
resetFlag=0

# Display usage instructions
usage() {
    cat <<EOF
Usage: ${0##*/} [--help] [--status] [--reset] [period_usec]
  period_usec: Transfer period in microseconds (default: 2250 usec, valid range: 125-50000 usec)
EOF
}

# Detect available resetprop command
which_resetprop_command() {
    if command -v resetprop >/dev/null 2>&1; then
        echo "resetprop"
    elif command -v resetprop_phh >/dev/null 2>&1; then
        echo "resetprop_phh"
    else
        echo "Error: No resetprop command found!" >&2
        return 1
    fi
}

# Restart audioserver
reloadAudioserver() {
    for _ in $(seq 1 3); do
        if [ "$(getprop sys.boot_completed)" = "1" ] && [ -n "$(getprop init.svc.audioserver)" ]; then
            break
        fi
        sleep 0.9
    done

    if [ -n "$(getprop init.svc.audioserver)" ]; then
        setprop ctl.restart audioserver
        sleep 0.2
        if [ "$(getprop init.svc.audioserver)" != "running" ]; then
            pid="$(getprop init.svc_debug_pid.audioserver)"
            [ -n "$pid" ] && kill -HUP "$pid" >/dev/null 2>&1
            for _ in $(seq 1 10); do
                sleep 0.2
                [ "$(getprop init.svc.audioserver)" = "running" ] && return 0
            done
            echo "Error: audioserver reload failed!" >&2
            return 1
        fi
    else
        echo "Error: audioserver not found!" >&2
        return 1
    fi
}

# Display current audio driver status
print_status() {
    if [ -n "$1" ]; then
        echo "USB driver's transfer property:"
        echo "  Period = $1 usec"
    fi
}

audio_driver_status() {
    local val
    val="$(getprop vendor.audio.usb.perio || getprop ro.audio.usb.period_us)"
    if [ -n "$val" ]; then
        print_status "$val"
    elif [ $resetFlag -eq 0 ]; then
        echo "Warning: Root permission is required for accurate status." >&2
        print_status "5000(?)"
    else
        print_status "5000(?)"
    fi
}

# Argument parsing
while [ $# -gt 0 ]; do
    case "$1" in
        --status|-s) audio_driver_status; exit 0 ;;
        --reset|-r) resetFlag=1; shift ;;
        --help|-h|*) usage; exit 0 ;;
        *) break ;;
    esac
done

# Validate and set the period
if [ $# -ge 1 ]; then
    if [[ "$1" =~ ^[1-9][0-9]*$ ]] && [ "$1" -ge 125 ] && [ "$1" -le 50000 ]; then
        period_us=$(( $1 / 125 * 125 ))
    else
        echo "Error: Invalid period ($1). Valid range: 125-50000 usec." >&2
        usage
        exit 1
    fi
fi

# Apply resetprop changes
resetprop_command=$(which_resetprop_command)
if [ $? -eq 0 ] && [ -n "$resetprop_command" ]; then
    if [ $resetFlag -gt 0 ]; then
        for prop in ro.audio.usb.period_us vendor.audio.usb.perio \
            vendor.audio.usb.out.period_us vendor.audio.usb.out.period_count \
            vendor.audio_hal.period_multiplier; do
            $resetprop_command --delete "$prop" >/dev/null 2>&1
        done
    else
        $resetprop_command ro.audio.usb.period_us "$period_us" >/dev/null 2>&1
        $resetprop_command vendor.audio.usb.perio "$period_us" >/dev/null 2>&1
    fi
fi

# Restart audioserver if necessary
reloadAudioserver || exit 1

# Print final status
audio_driver_status
exit 0
