#!/bin/bash

set -e

if [ $# -ne 3 ]; then
    echo "Usage: $0 <path> <file_pattern> <content_pattern>"
    exit 1
fi

work_path=$1
file_pattern=$2
content_pattern=$3

if [ ! -e $work_path ]; then
    echo "Error: $work_path does not exist"
    exit 1
fi

if [ ! -d $work_path ]; then
    echo "Error: $work_path is not a directory"
    exit 1
fi

find_ret=$(find $work_path -name "${file_pattern}" -type f -exec grep -l "${content_pattern}" {} \;)
echo "$find_ret"
