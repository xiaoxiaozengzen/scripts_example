#!/bin/bash

set -e

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # 没有颜色（重置）

# 检查LD_LIBRARY_PATH
ld_path_value=${LD_LIBRARY_PATH}

IFS=':' read -ra ld_path_array <<< "$ld_path_value"

cuda_path=""
cudnn_path=""
tensorrt_path=""

cuda_version=""
cudnn_version=""
tensorrt_version=""

for ld_path in "${ld_path_array[@]}"; do
    if [[ $ld_path == *cuda* ]]; then
        cuda_path=$ld_path
        break
    fi
done

for ld_path in "${ld_path_array[@]}"; do
    if [[ $ld_path == *cudnn* ]]; then
        cudnn_path=$ld_path
        break
    fi
done

for ld_path in "${ld_path_array[@]}"; do
    if [[ $ld_path == *tensorrt* ]]; then
        tensorrt_path=$ld_path
        break
    fi
done


# 检查Cuda版本
if [ -z "$cuda_path" ]; then
    echo -e "${RED}There is no Cuda found in LD_LIBRARY_PATH${NC}"
else
    cd $cuda_path
    cudart_file=($(ls | grep libcudart.so))
    for file in "${cudart_file[@]}"; do
        if [ ! -L "${file}" ];then
            cuda_version=${file:13:4}
            break
        fi
    done

    if [ -z "$cuda_version" ]; then
        echo -e "${RED}There is no Cuda version found in ${cuda_path} ${NC}"
    else
        echo -e "${GREEN}Cuda Version: ${cuda_version}${NC}"
    fi
fi

# 检查Cudnn版本
if [ -z "$cudnn_path" ]; then
    echo -e "${RED}There is no Cudnn found in LD_LIBRARY_PATH${NC}"
else
    cd $cudnn_path
    cudnn_file=($(ls | grep libcudnn.so))
    for file in "${cudnn_file[@]}"; do
        if [ ! -L "${file}" ];then
            cudnn_version=${file:12:5}
            break
        fi
    done

    if [ -z "$cudnn_version" ]; then
        echo -e "${RED}There is no cudnn version found in ${cudnn_path} ${NC}"
    else
        echo -e "${GREEN}Cudnn Version: ${cudnn_version}${NC}"
    fi

fi

if [ -z "$tensorrt_path" ]; then
    echo -e "${RED}There is no TensorRT found in LD_LIBRARY_PATH${NC}"
else
    cd $tensorrt_path
    tensorrt_file=($(ls | grep libnvinfer.so))
    for file in "${tensorrt_file[@]}"; do
        if [ ! -L "${file}" ];then
            tensorrt_version=${file:14:5}
            break
        fi
    done

    if [ -z "$tensorrt_version" ]; then
        echo -e "${RED}There is no TensorRT version found in ${tensorrt_path} ${NC}"
    else
        echo -e "${GREEN}TensorRT Version: ${tensorrt_version}${NC}"
    fi
fi