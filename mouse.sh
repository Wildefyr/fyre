#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# toggle mouse device

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [enable|disable|toggle]
EOF

    test $# -eq 0 || exit $1
}

fnmatch() {
    case "$2" in
        $1) return 0 ;;
        *)  printf '%s\n' "Please enter a valid window id." >&2; exit 1 ;;
    esac
}

getMouseDevice() {
    device="$(xinput | grep -i "mouse\|trackpad" | awk '{printf "%s\n",$9}' | \
        cut -d= -f 2)"

    test ! -z "$device" && {
        printf '%s\n' "$device"
    } || {
        printf '%s\n' "N/A"
    }
}

getMouseStatus() {
    device=$(getMouseDevice)
    status=$(xinput list-props $device | awk '/Device Enabled/ {printf "%s\n", $NF}')

    printf '%s\n' "$status"
}

moveMouseEnabled() {
    wid=$1
    fnmatch "0x*" "$wid"

    # move mouse to the middle of the given window id
    wmp -a $(($(wattr x $wid) + ($(wattr w $wid) / 2))) \
           $(($(wattr y $wid) + ($(wattr h $wid) / 2)))
}

# move mouse to bottom-right corner of the screen
# TODO: find way of fully hiding the mouse completely
moveMouseDisabled() {
    wmp $SW $SH
}

enableMouse() {
    device="$(getMouseDevice)"
    xinput --set-prop --type=int "$device" "Device Enabled" 1
    moveMouseEnabled "$PFW"
}

disableMouse() {
    device="$(getMouseDevice)"
    moveMouseDisabled
    xinput --set-prop --type=int "$device" "Device Enabled" 0
}

toggleMouse() {
    device="$(getMouseDevice)"

    test "$device" = "N/A" && {
        moveMouseDisabled
        return 1
    }

    status="$(getMouseStatus)"
    test "$status" -eq 1 && status=0 || status=1
    test "$status" -eq 1 && moveMouseEnabled $PFW || moveMouseDisabled
    xinput --set-prop --type=int "$device" "Device Enabled" "$status"
}

main() {
    . fyrerc.sh

    case $1 in
        e|enable)  enableMouse  ;;
        d|disable) disableMouse ;;
        t|toggle)  toggleMouse  ;;
        *)         usage 0      ;;
    esac
}

test -z "$ARGS" || main $ARGS
