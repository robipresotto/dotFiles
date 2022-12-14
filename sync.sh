#!/bin/bash

set -e

declare -a filterFiles=".gitignore .git"
declare -a listFiles=`ls -a -d .[a-z]*`

for filter in ${filterFiles[@]}
do
    listFiles=("${listFiles[@]/$filter}")
done

for file in "${listFiles[@]}"
do
    cp -R $file ~/
done