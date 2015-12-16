#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# use slop to get xywh position for urxvt

. ~/.config/fyre/fyrerc

eval $(slop -t 0 -b $BW '215,215,215,0.9')
urxvtc -name 'slop'
wtp $X $Y $W $H $(wid.sh "slop" | tail -1)