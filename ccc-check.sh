#!/bin/bash

# Usage: ccc-check [command] [problem]
# e.g. ccc-check "python 2012-s2.py" 2012/s2

curdir="$(dirname "$(test -L "$0" && readlink "$0" || echo "$0")")"
num_cases=0
correct_cases=0
RED='\e[0;31m'
GREEN='\e[0;32m'
CLEAR='\e[0m'
for infile in $(find $curdir/$2.*.in); do
    let num_cases+=1
    outfile=${infile%%.in}.out
    casenum=${infile%%.in}
    casenum=${casenum##*/}
    echo -n "### $casenum: "
    
    timeout 10 $1 < $infile | tee /tmp/ccc-check | diff - $outfile > /dev/null

    ret=$?

    if [ $ret -eq 124 ]; then
        echo -e "${RED}timed out.${CLEAR}"
        echo "test case copied to $(basename $infile)"
        cp $infile ./$(basename $infile)
    elif [ $ret -ne 0 ]; then
        echo -e "${RED}failed.${CLEAR}"
        echo "test case copied to $(basename $infile)"
        cp $infile ./$(basename $infile)
        #cat $infile
        echo "expected output:"
        cat $outfile
        echo "actual output:"
        cat /tmp/ccc-check
    else
        echo -e "${GREEN}correct!${CLEAR}"
        let correct_cases+=1
    fi
done
echo "cases correct: $correct_cases/$num_cases"
