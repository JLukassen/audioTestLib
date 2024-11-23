#!/system/bin/sh
#
# Version: 2.8.7
#     by zyhk

MYDIR="${0%/*}"

# Check current directory and script status
if [ ! -d "$MYDIR" ]; then
    echo "Error: Unable to retrieve current directory!" >&2
    exit 1
elif [ -e "$MYDIR/disable" ]; then
    echo "Error: This script is disabled!" >&2
    exit 0
fi

# Default values
policyMode="auto"
resetMode="false"
DRC_enabled="false"
USB_module="usb"
BT_module="bluetooth"
forceBluetoothQti="false"

# Help message
print_help() {
    echo "Usage: ${0##*/} [--reset] [--drc] [--bypass-offload|--bypass-offload-safer|--offload|--offload-hifi-playback|--offload-direct]"
    echo "       [--legacy|--safe|--safest|--usb-only] [[44k|48k|88k|96k|176k|192k|353k|384k|706k|768k] [16|24|32|float]]"
    echo ""
    echo "Note: ${0##*/} requires unlocking USB audio class driver's limitation (up to 96kHz lock or 384kHz Qcomm offload lock)"
    echo "      for sample rates greater than specified."
    exit 0
}

# Parse arguments
parse_arguments() {
    case "$1" in
        "-o" | "--offload" ) policyMode="offload";;
        "-oh" | "--offload-hifi-playback" ) policyMode="offload-hifi-playback";;
        "-od" | "--offload-direct" ) policyMode="offload-direct";;
        "-b" | "--bypass-offload" ) policyMode="bypass";;
        "-bs" | "--bypass-offload-safer" ) policyMode="bypass-safer";;
        "-l" | "--legacy" ) policyMode="legacy";;
        "-s" | "--safe" ) policyMode="safe";;
        "-ss" | "--safest" ) policyMode="safest";;
        "-u" | "--usb-only" ) policyMode="usb";;
        "-fu" | "--force-usbv2" ) USB_module="usbv2";;
        "-fq" | "--force-bluetooth-qti" ) forceBluetoothQti="true";;
        "-a" | "--auto" ) policyMode="auto";;
        "-d" | "--drc" ) DRC_enabled="true";;
        "-r" | "--reset" ) resetMode="true";;
        "-h" | "--help" | -* ) print_help;;
        * ) echo "Error: Invalid argument '$1'!" >&2; exit 1;;
    esac
}

# Main script execution
main() {
    # Reset
    if "$resetMode"; then
        [ -e "$MYDIR/.config" ] && rm -f "$MYDIR/.config"
        removeGenFile "/data/local/tmp/audio_conf_generated.xml"
        reloadAudioServers "all"
        exit 0
    fi

    # Set parameters
    sRate="44100"
    bDepth="32"

    case $# in
        1 ) sRate="$1";;
        2 ) sRate="$1"; bDepth="$2";;
        * ) echo "Error: Too many arguments ($#)!" >&2; exit 1;;
    esac

    # Normalize sample rate
    case "$sRate" in
        "44k" | "44.1k" ) sRate="44100";;
        "48k" ) sRate="48000";;
        "88k" | "88.2k" ) sRate="88200";;
        "96k" ) sRate="96000";;
        "176k" | "176.4k" ) sRate="176400";;
        "192k" ) sRate="192000";;
        "352k" | "353k" | "352.8k" ) sRate="352800";;
        "384k" ) sRate="384000";;
        "705k" | "706k" | "705.6k" ) sRate="705600";;
        "768k" ) sRate="768000";;
        [1-9][0-9]* )
            if [ "$sRate" -lt 44100 ] || [ "$sRate" -gt 768000 ]; then
                echo "Error: Unsupported sample rate ($sRate)!" >&2
                exit 1
            fi
            ;;
        * ) echo "Error: Unsupported sample rate format ($sRate)!" >&2; exit 1;;
    esac

    # Normalize bit depth
    case "$bDepth" in
        16 ) aFormat="AUDIO_FORMAT_PCM_16_BIT";;
        24 ) aFormat="AUDIO_FORMAT_PCM_24_BIT_PACKED";;
        32 ) aFormat="AUDIO_FORMAT_PCM_32_BIT";;
        "float" ) aFormat="AUDIO_FORMAT_PCM_FLOAT";;
        * ) echo "Error: Unknown bit depth specified ($bDepth)!" >&2; exit 1;;
    esac

    # Overlay audio policy configuration
    if [ ! -r "$MYDIR/.config" ]; then
        makeConfigFile "$MYDIR/.config"
    fi

    [ -r "$MYDIR/.config" ] && . "$MYDIR/.config"

    overlayTarget="${PolicyFile:-/vendor/etc/audio_policy_configuration.xml}"

    if [ "$policyMode" = "auto" -a -n "$BluetoothHal" ]; then
        policyMode="$BluetoothHal"
    fi

    # Adjust Bluetooth module based on policy mode
    case "$policyMode" in
        "legacy" | "safe" | "safest" ) BT_module="a2dp";;
        * )
            if [ "$(getprop ro.board.platform)" = "pineapple" -a -r "/vendor/lib64/hw/audio.bluetooth_qti.default.so" ]; then
                BT_module="bluetooth_qti"
            else
                BT_module="bluetooth"
            fi
            ;;
    esac

    # Force Bluetooth HAL to "bluetooth_qti"
    if "$forceBluetoothQti"; then
        BT_module="bluetooth_qti"
        if [ ! -r "/vendor/lib64/hw/audio.bluetooth_qti.default.so" ] && [ ! -r "/vendor/lib/hw/audio.bluetooth_qti.default.so" ]; then
            echo "Warning: No 'bluetooth_qti' audio HAL module detected on this device!" >&2
        fi
    fi

    # Determine if sysbta is capable
    SysbtaCapable="$(getprop persist.bluetooth.system_audio_hal.enabled)"

    if [ "$SysbtaCapable" = "1" ] && [ "$(getprop init.svc.system.bt-audio-hal)" != "stopped" ]; then
        if [ "$policyMode" = "offload" -o "$policyMode" = "offload-direct" ]; then
            echo "Warning: 'sysbta' (System Wide Bluetooth HAL) service detected running" >&2
            if [ "$SysbtaCapable" = "1" ]; then
                echo "Info: 'sysbta' forcibly rewrites Bluetooth audio to its own for '$policyMode' mode" >&2
            else
                echo "Info: Use 'extras/change-bluetooth-hal.sh' to switch Bluetooth audio HAL to 'offload'" >&2
            fi
        fi
    fi

    # Hardware offloading limitations
    if [ "$policyMode" = "offload" -o "$policyMode" = "offload-hifi-playback" -o "$policyMode" = "offload-direct" ]; then
        case "$(getprop ro.board.platform)" in
            mt* | exynos* | gs10? )
                [ $sRate -gt 96000 ] && echo "Warning: Hardware offloading limit exceeded for sample rate ($sRate)" >&2;;
            gs* | zuma )
                [ $sRate -gt 192000 ] && echo "Warning: Hardware offloading limit exceeded for sample rate ($sRate)" >&2;;
            * )
                [ $sRate -gt 384000 ] && echo "Warning: Hardware offloading limit exceeded for sample rate ($sRate)" >&2;;
        esac
    fi
}

# Execute script
parse_arguments "$@"
main
