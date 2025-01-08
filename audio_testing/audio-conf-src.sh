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

dumpsys media.audio_policy | awk -v all_flag=$all_flag ' 
    all_flag == 1 ||
    /^ Config source: / ||
    /^- HW Module / ||
    /^  - name: / { 
        print $0
    }'
