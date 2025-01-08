#!/system/bin/sh

all_flag=0
if [ $# -gt 0 ]; then
    case "$1" in
        "-a" | "--all" )
            all_flag=1
            ;;
        "-h" | "--help" )
            echo "Usage: ${0##*/} [--all][--help]" 1>&2
            exit 0
            ;;
        * )
            echo "Invalid argument ($1)" 1>&2
            echo "Usage: ${0##*/} [--all][--help]" 1>&2
            exit 1
            ;;
    esac
fi

# Filter and process dumpsys output
dumpsys bluetooth_manager | sed -e '/^Bluetooth Status/,/^A2DP State:/d' -e '/^A2DP Sink State:/,$d' \
    | awk -v all_flag=$all_flag '
        BEGIN {
            RS=""
            FS="\n"
            print_flag = 1
            if (all_flag == 1) {
                print "A2DP State:"
            }
        }
        all_flag == 1 || (print_flag == 1 && /\n  Config: Rate/) {
            print
            if (all_flag == 0) {
                print_flag = 0
            }
        }'
