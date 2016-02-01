#bin/sh
#
# wildefyr - 2016 (c) wtfpl
# wrapper to find any window that matches a string

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) [Search String]"
    test -z $1 || exit $1
}

nameAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(class $wid)"
    done
}

classAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(class $wid)"
    done
}

titleAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(wname $wid)"
    done
}

showAll() {
    nameAll
    classAll
    titleAll
}

main() {
    . fyrerc.sh

    case $1 in
        h|help) usage 0 ;;
    esac

    showAll | grep -i $1 | cut -d\  -f 1 | sort | uniq
}

test -z "$ARGS" || main $ARGS
