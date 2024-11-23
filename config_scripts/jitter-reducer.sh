#!/system/bin/sh
#
# Version: 2.6.0
# Main configuration script by zyhk
# This script depends on a paired function library for functionality.

MYDIR="${0%/*}"

# Ensure the script isn't disabled
if [ ! -d "$MYDIR" ]; then
    echo "Cannot determine the current directory!" 1>&2
    exit 1
elif [ -e "$MYDIR/disable" ]; then
    echo "This script is currently disabled!" 1>&2
    exit 0
fi

# Load the paired function library
LIBRARY_PATH="$MYDIR/library.sh"
if [ ! -r "$LIBRARY_PATH" ]; then
    echo "Function library not found or unreadable: $LIBRARY_PATH" 1>&2
    exit 1
fi
# Source the library
. "$LIBRARY_PATH"

# Display usage instructions
function usage() {
    cat <<EOF
Usage: ${0##*/} [OPTIONS]
Options:
  --selinux | ++selinux       Enable or disable SELinux
  --thermal | ++thermal       Enable or disable thermal throttling
  --doze | ++doze             Enable or disable Doze mode
  --governor | ++governor     Enable or disable CPU governor optimization
  --camera | ++camera         Enable or disable the camera subsystem
  --logd | ++logd             Enable or disable logd
  --io [scheduler [tone]]     Set I/O scheduler and tone (light, medium, boost)
  --vm | ++vm                 Enable or disable virtual memory tuning
  --wifi | ++wifi             Enable or disable Wi-Fi tweaks
  --all | ++all               Enable or disable all optimizations
  --battery | ++battery       Enable or disable battery optimizations
  --effect | ++effect         Enable or disable visual effects
  --status                    Show current configuration status
  --help                      Display this help message

Notes:
- Use '--' for enabling options and '++' for disabling them.
- '--all' applies all optimizations except '--effect' and '--battery'.
- Scheduler defaults to '*', with optional tone modes: light, medium, boost.
- Wi-Fi tweaks are persistent across reboots; others are not.
EOF
}

# Parse arguments
selinuxFlag=0
thermalFlag=0
dozeFlag=0
governorFlag=0
cameraFlag=0
logdFlag=0
ioFlag=0
ioScheduler=""
toneMode="medium"
vmFlag=0
wifiFlag=0
batteryFlag=0
effectFlag=0
printStatus=0

if [ $# -eq 0 ]; then
    usage
    exit 0
else
    while [ $# -gt 0 ]; do
        case "$1" in
            "--all")
                selinuxFlag=1
                thermalFlag=1
                governorFlag=1
                cameraFlag=1
                logdFlag=1
                ioFlag=1
                vmFlag=1
                wifiFlag=1
                dozeFlag=1
                shift
                ;;
            "++all")
                selinuxFlag=-1
                thermalFlag=-1
                governorFlag=-1
                cameraFlag=-1
                logdFlag=-1
                ioFlag=-1
                vmFlag=-1
                wifiFlag=-1
                dozeFlag=-1
                shift
                ;;
            "--selinux")
                selinuxFlag=1
                shift
                ;;
            "++selinux")
                selinuxFlag=-1
                shift
                ;;
            "--thermal")
                thermalFlag=1
                shift
                ;;
            "++thermal")
                thermalFlag=-1
                shift
                ;;
            "--doze")
                dozeFlag=1
                shift
                ;;
            "++doze")
                dozeFlag=-1
                shift
                ;;
            "--governor")
                governorFlag=1
                shift
                ;;
            "++governor")
                governorFlag=-1
                shift
                ;;
            "--camera")
                cameraFlag=1
                shift
                ;;
            "++camera")
                cameraFlag=-1
                shift
                ;;
            "--logd")
                logdFlag=1
                shift
                ;;
            "++logd")
                logdFlag=-1
                shift
                ;;
            "--io")
                ioFlag=1
                shift
                if [ $# -gt 0 ] && [[ "$1" != -* ]]; then
                    ioScheduler="$1"
                    shift
                    if [ $# -gt 0 ] && [[ "$1" =~ ^(light|m-light|medium|boost|exp)$ ]]; then
                        toneMode="$1"
                        shift
                    fi
                fi
                ;;
            "--vm")
                vmFlag=1
                shift
                ;;
            "++vm")
                vmFlag=-1
                shift
                ;;
            "--wifi")
                wifiFlag=1
                shift
                ;;
            "++wifi")
                wifiFlag=-1
                shift
                ;;
            "--battery")
                batteryFlag=1
                shift
                ;;
            "++battery")
                batteryFlag=-1
                shift
                ;;
            "--effect")
                effectFlag=1
                shift
                ;;
            "++effect")
                effectFlag=-1
                shift
                ;;
            "--status")
                printStatus=1
                shift
                ;;
            "--help")
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" 1>&2
                usage
                exit 1
                ;;
        esac
    done
fi

# Execute selected options
[ "$selinuxFlag" -ne 0 ] && toggleSelinux "$selinuxFlag"
[ "$thermalFlag" -ne 0 ] && toggleThermal "$thermalFlag"
[ "$dozeFlag" -ne 0 ] && toggleDoze "$dozeFlag"
[ "$governorFlag" -ne 0 ] && toggleGovernor "$governorFlag"
[ "$cameraFlag" -ne 0 ] && toggleCamera "$cameraFlag"
[ "$logdFlag" -ne 0 ] && toggleLogd "$logdFlag"
[ "$ioFlag" -ne 0 ] && toggleIO "$ioScheduler" "$toneMode"
[ "$vmFlag" -ne 0 ] && toggleVM "$vmFlag"
[ "$wifiFlag" -ne 0 ] && toggleWifi "$wifiFlag"
[ "$batteryFlag" -ne 0 ] && toggleBattery "$batteryFlag"
[ "$effectFlag" -ne 0 ] && toggleEffect "$effectFlag"
[ "$printStatus" -eq 1 ] && printStatus

exit 0
