#!/bin/bash

fun_pre="WMASE3WITHMCS1_CREATE_AHEAD_MSG"
left_bracket="("
right_bracket=")"

fun="WMASE3WITHMCS1_CREATE_AHEAD_MSG_"
suffix="(ah_parse->CreateParser<MCS1AheadRadarParse>()->recv_signals_parse_, msg);"


for((i=0;i<30;i++))
do
# typeset -u hex
# hex=`printf "%x, " $(($i+16#510))`
dec=`printf "%02d" $(($i))`
output=$fun$dec$suffix
echo $output
done
