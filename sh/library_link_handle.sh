#!/bin/bash

work_dir="/home/user/cgz_workspace/OculiiRadar/oculii_sdk/qt_visualizer/Qt/linux/lib"

cd $work_dir

i=0
file_name=()

real_file=`ls -alh $work_dir | awk '{print $9}' | grep ".so.5.15.2$"`
for file in $real_file
do
    echo $file
    file_name[$i]=${file%%.*}
    let i=i+1
done
echo "------.so.5.15.2"
echo $real_file

echo "-------.so file name"
echo ${file_name[*]}

for file in ${file_name[*]}
do
    if [ -f "${file}.so" ];then
        mv ${file}.so ${file}.so.back
        echo "change ${file}.so to ${file}.so.back"
    fi

    if [ -f "${file}.so.5" ];then
        mv ${file}.so.5 ${file}.so.5.back
        echo "change ${file}.so.5 to ${file}.so.5.back"
    fi

    if [ -f "${file}.so.5.15" ];then
        mv ${file}.so.5.15 ${file}.so.5.15.back
        echo "change ${file}.so.5.15 to ${file}.so.5.15.back"
    fi

    ln -s ${file}.so.5.15.2 ${file}.so.5.15
    ln -s ${file}.so.5.15 ${file}.so.5
    ln -s ${file}.so.5 ${file}.so
done