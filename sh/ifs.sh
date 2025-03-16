#!/bin/bash

set -e

source ./ifs_inter.sh

# 示例文本行
text="John,Doe,30,USA"

# 设置IFS为逗号
IFS=","

# 将文本行分割成字段
read -r firstname lastname age country <<< "$text"

# 输出字段值
echo "First Name: $firstname"
echo "Last Name: $lastname"
echo "Age: $age"
echo "Country: $country"