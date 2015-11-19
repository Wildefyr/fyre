#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# personal tiling script, optimised for vertical terminal usage

usage() {
    printf '%s\n' "usage: $(basename $0)"
    exit 1
}

horizontalTile() {
    Y=$TGAP
    COLS=$windowsToTile
    W=$(((SW - COLS*IGAP - 2*BW)/COLS))
    echo $COLS
    echo $SW
    echo $W
    H=$SH

    for c in $(seq $COLS); do
        wtp $X $Y $W $H $(head -n $c $WLFILE | tail -1)
        X=$((X + W + IGAP))
    done
}

mainTile() {
    Y=$TGAP
    COLS=$maxHorizontalWindows
    W=$(((SW - COLS*IGAP - 2*BW)/COLS))
    H=$SH

    COLSTEMP=$((COLS - 1))
    cat $WLFILE | head -n $COLSTEMP > $WLFILETEMP

    for c in $(seq $COLSTEMP); do
        wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
        X=$((X + W + IGAP))
    done

    cat $WLFILE | tail -n $((windowsToTile - COLSTEMP)) > $WLFILETEMP

    ROWS=$(cat $WLFILETEMP | wc -l)
    H=$(((SH - (ROWS - 1)*VGAP)/ROWS))
    if [ $COLS -eq 3 ]; then
        W=$((W + maxHorizontalWindows - 1))
        echo $W
    fi

    for c in $(seq $ROWS); do
        if [ $c -ne 1 ]; then
            if [ $((c % 2)) -eq 1 ]; then
                H=$((H + 1))
            fi
        fi
        wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
        Y=$((Y + H + VGAP))
    done
}

mpvTile() {
    if [ $mpvWindowsToTile -eq 1 ]; then

        mpvWid=$(cat $MPVFILE)
        mpvW=$(resolution.sh $mpvWid | cut -d\  -f 1)
        mpvH=$(resolution.sh $mpvWid | cut -d\  -f 2)

        if [ $(wattr h $mpvWid) -ne $mpvH ]; then
            wtp $(wattr xy $mpvWid) $mpvW $mpvH $mpvWid
        fi

        if [ $mpvW -lt 640 ]; then
            mpvW=640
            wtp $(wattr xy $mpvWid) $mpvW $mpvH $mpvWid
        fi

        if [ $mpvH -ge 360 ] && [ $mpvH -lt 720 ]; then
            if [ $windowsToTile -eq 0 ]; then
                position.sh md $mpvWid
            elif [ $windowsToTile -eq 1 ]; then
                Y=$TGAP
                W=$mpvW
                H=$((SH - VGAP - mpvH))
                wtp $X $Y $W $H $(cat $WLFILE | head -n 1)

                position.sh bl $mpvWid
            elif [ $windowsToTile -gt 1 ] && [ $windowsToTile -lt 4 ]; then
                Y=$TGAP
                W=$mpvW
                H=$((SH - VGAP - mpvH))
                wtp $X $Y $W $H $(cat $WLFILE | head -n 1)

                cat $WLFILE | sed '1d' > $WLFILETEMP
                COLS=$(cat $WLFILETEMP | wc -l)

                AW=$((SW - mpvW))
                X=$((X + IGAP + mpvW))
                W=$(((AW - COLS*IGAP - 2*BW)/COLS))
                H=$SH

                for c in $(seq $COLS); do
                    wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
                    X=$((X + W + IGAP))
                done

                position.sh bl $mpvWid
            elif [ $windowsToTile -gt 3 ]; then
                Y=$TGAP
                W=$mpvW
                H=$((SH - VGAP - mpvH))
                wtp $X $Y $W $H $(cat $WLFILE | head -n 1)

                cat $WLFILE | sed '1d' > $WLFILETEMP
                COLS=2

                AW=$((SW - mpvW))
                X=$((X + IGAP + mpvW))
                W=$(((AW - COLS*IGAP - 2*BW)/COLS))
                H=$SH

                for c in $(seq $COLS); do
                    wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
                    X=$((X + W + IGAP))
                done

                cat $WLFILETEMP | sed '1d' > $WLFILE
                ROWS=$(cat $WLFILE | wc -l)
                X=$((X - W - IGAP))
                H=$(((SH - (ROWS - 1)*VGAP)/ROWS))

                for c in $(seq $ROWS); do
                    if [ $c -ne 1 ]; then
                        if [ $((c % 2)) -eq 1 ]; then
                            H=$((H + 1))
                        fi
                    fi
                    wtp $X $Y $W $H $(head -n $c $WLFILE | tail -1)
                    Y=$((Y + H + VGAP))
                done

                position.sh bl $mpvWid
            fi
        elif [ $mpvH -ge 720 ]; then
            if [ $windowsToTile -eq 0 ]; then
                position.sh md $mpvWid
            elif [ $windowsToTile -eq 1 ]; then
                Y=$TGAP
                X=$((X + IGAP + mpvW))
                W=$((SW - mpvW - 2*BW))
                H=$SH

                wtp $X $Y $W $H $(cat $WLFILE | head -n 1)

                position.sh tl $mpvWid
                position.sh ext $mpvWid
            elif [ $windowsToTile -gt 1 ] && [ $windowsToTile -lt 4 ]; then
                cat $WLFILE | sed '$ d' > $WLFILETEMP
                COLS=$(cat $WLFILETEMP | wc -l)

                Y=$TGAP
                AW=$mpvW
                W=$(((AW - COLS*IGAP)/COLS))
                H=$((SH - VGAP - mpvH))

                for c in $(seq $COLS); do
                    wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
                    X=$((X + W + IGAP))
                done

                X=$((X + IGAP - BW))
                W=$((SW - mpvW - 2*BW))
                H=$SH
                wtp $X $Y $W $H $(cat $WLFILE | tail -n 1)

                position.sh bl $mpvWid
            elif [ $windowsToTile -gt 3 ]; then
                cat $WLFILE | sed '2q' > $WLFILETEMP
                COLS=$(cat $WLFILETEMP | wc -l)

                Y=$TGAP
                AW=$mpvW
                W=$(((AW - COLS*IGAP)/COLS))
                H=$((SH - VGAP - mpvH))

                for c in $(seq $COLS); do
                    wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
                    X=$((X + W + IGAP))
                done

                cat $WLFILE | sed '1,2d' > $WLFILETEMP
                ROWS=$(cat $WLFILETEMP | wc -l)
                X=$((X + IGAP - BW))
                W=$((SW - mpvW - 2*BW))
                H=$(((SH - (ROWS - 1)*VGAP)/ROWS))

                for c in $(seq $ROWS); do
                    if [ $c -ne 1 ]; then
                        if [ $((c % 2)) -eq 1 ]; then
                            H=$((H + 1))
                        fi
                    fi
                    wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
                    Y=$((Y + H + VGAP))
                done

                position.sh bl $mpvWid
            fi
        fi
    else
        mpvW=1280
        mpvH=720
    fi

}

. ~/.config/fyre/fyrerc
. detection.sh

# calculate usable screen size (root minus border gaps)
SW=$((SW - 2*XGAP))
SH=$((SH - TGAP - BGAP))

if [ -e $WLFILE ] || [ -e $MPVFILE ]; then
    windowsToTile=$(cat $WLFILE | wc -l)
else
    windowsToTile=0
fi

if [ -e $MPVFILE ]; then
    mpvWindowsToTile=$(cat $MPVFILE | wc -l)
    mpvTile
else
    if [ $windowsToTile -eq 0 ]; then
        exit 1
    elif [ $windowsToTile -le $maxHorizontalWindows ]; then
        horizontalTile
    else
        mainTile
    fi
fi
