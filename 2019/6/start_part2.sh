#!/bin/bash
set -e

inputfile=$1

echo Reading "$inputfile"

input=$(cat "$inputfile")

total=0

declare -A orbits


for entry in $input
do
    orbit=(${entry//)/ })
    orbits[${orbit[1]}]=${orbit[0]}
done

you="YOU"
san="SAN"

santotal=0
youtotal=0

while [ $san != "COM" ]
do
    youtotal=0
    san=${orbits[$san]}
    you="YOU"
    while [ $you != "COM" ]
    do
        you=${orbits[$you]}
        if [ $you == $san ]
        then
            break
        fi
        youtotal=$(($youtotal + 1))
    done
    if [ $you == $san ]
    then
        break
    fi
    santotal=$(($santotal + 1))
done

total=$(($youtotal + $santotal))

echo "$total steps are required"