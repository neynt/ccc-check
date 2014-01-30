#!/bin/bash
curdir=$(dirname $0)
curdir='/vault/code/ccc-check'
for infile in $(find $curdir/$2.*.in); do
    outfile=${infile%%.in}.out
    casenum=${infile%%.in}
    casenum=${casenum##*/}
    echo -n "### $casenum: "
    
    $1 < $infile | tee /tmp/ccc-check | diff - $outfile > /dev/null

    if [ $? -ne 0 ]; then
        echo "failed."
        echo "test case:"
        cat $infile
        echo "expected output:"
        cat $outfile
        echo "actual output:"
        cat /tmp/ccc-check
    else
        echo "correct!"
    fi
done
