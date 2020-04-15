#!/bin/bash
set -e

inputfile=$1

echo Reading "$inputfile"

input=$(cat "$inputfile")

total=0
oldtotal=-1

declare -A values

while (( total != oldtotal)) 
do
    oldtotal=$total
    total=0
    for entry in $input
    do
        orbit=(${entry//)/ })
        [[ ! -v values[${orbit[0]}] ]] && values[${orbit[0]}]=0
        values[${orbit[1]}]=$((${values[${orbit[0]}]} + 1))
        total=$(($total+${values[${orbit[1]}]}))
    done
done

echo "There are $total orbits in the map"
