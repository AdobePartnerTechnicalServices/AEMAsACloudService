#!/bin/bash

BRANCHNAME="livetrial"

git checkout -b badcode origin/badcode
git pull

for i in {1..35}; do
    BRANCHNUM=$i
    if ((${#BRANCHNUM} < 2)); then
        BRANCHNUM="0${BRANCHNUM}"
    fi
    echo $BRANCHNUM
    #Delete existing branches
    git branch -D ${BRANCHNAME}-$BRANCHNUM
    git push origin --delete ${BRANCHNAME}-$BRANCHNUM
    #Create new branches
    git branch ${BRANCHNAME}-$BRANCHNUM
    git push origin ${BRANCHNAME}-$BRANCHNUM
done