#!/bin/bash

set -e

SCRIPT_NAME=$(basename "${0}")
script_path=$(cd $(dirname $0);pwd)
root_path=$(dirname $script_path)

echo "script_path: $script_path"
echo "root_path: $root_path"
echo "SCRIPT_NAME: $SCRIPT_NAME"

VAR_SET="set"
set -- VAR_UNSET
set -- VAR_OTHER

echo "VAR_SET: $VAR_SET"
echo "VAR_SET: ${VAR_SET+1}"
echo "VAR_UNSET: $VAR_UNSET"
echo "VAR_UNSET: ${VAR_UNSET+1}"

# 若没有上述的set设置的变量行为，则输出为执行脚本时后边的命令行参数
# set var，这种形式实际上是将变量var作为位置参数传递给脚本，而不是设置变量
echo "\$@: $@"

# 检查 ccache 命令是否存在
if command -v ros2 >/dev/null; then
    echo "ros2 is installed"
    ret=$(command -v ros2)
    echo "ret: $ret"
else
    echo "ros2 is not installed"
fi