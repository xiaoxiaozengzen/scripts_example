#!/bin/bash

prefix="0x"

for((i=0;i<20;i++))
do
typeset -u hex
hex=`printf "%x, " $(($i+16#510))`
all_hex=$all_hex$prefix$hex
let i=i+1
done

echo $all_hex >> ./tmp.txt