#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <mcap_file_name>"
    exit 1
fi

if ! command -v mcap &> /dev/null; then
    echo "mcap command not found. Please install mcap."
    exit 1
fi

mcap_file_name=$1

if [ ! -f "$mcap_file_name" ]; then
    echo "File $mcap_file_name not found!"
    exit 1
fi

# 获取文件信息
file_path=$(realpath "$mcap_file_name")
file_name=$(basename "$mcap_file_name")
file_dir=$(dirname "$file_path")
file_extension="${file_name##*.}"
file_name_no_ext="${file_name%.*}"

if [ "$file_extension" != "mcap" ]; then
    echo "File $mcap_file_name is not a .mcap file!"
    exit 1
fi

if [ -f "$file_dir/${file_name_no_ext}_filtered.mcap" ]; then
    echo "File $file_dir/${file_name_no_ext}_filtered.mcap already exists!"
    exit 1
fi

mcap filter ${mcap_file_name} -o ${file_name_no_ext}_filtered.mcap \
-y /perception/detection/obstacle_array_result \
-y /sensor/radar_front_middle \
-y /sensor/radar_front_right \
-y /sensor/radar_front_left \
-y /sensor/radar_rear_right \
-y /sensor/radar_rear_left \
-y /localization/localization_estimate \
-y /sensor/vehicle_report_common \
-y /perception/aeb_lidar_obstacle_array \
-y /perception/aeb_dynamic_obs_array