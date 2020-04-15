#!/bin/bash

head -n 1 'input.txt' | tr , '\n' > 'cable1.txt'
sed '2q;d' 'input.txt' | tr , '\n' > 'cable2.txt'
./cobol/bin/cobc -x part2.cbl && LD_LIBRARY_PATH=$PWD/cobol/lib64/ ./part2
