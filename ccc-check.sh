#!/bin/bash
curdir=$(dirname $0)
curdir='/vault/code/ccc-check'
num_cases=0
correct_cases=0
for infile in $(find $curdir/$2.*.in); do
    let num_cases+=1
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
        let correct_cases+=1
    fi
done
echo "cases correct: $correct_cases/$num_cases"
