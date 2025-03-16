#!/bin/bash

set -e

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # 没有颜色（重置）

gpu_type_3090="2204"
gpu_type_4090="2684"

echo "------------------------- checking GPU type -------------------------"
arch=$(uname -m)
if [[ $arch == "x86_64" ]]; then
    echo -e "${GREEN}current machine is x86_64${NC}"
else
    echo -e "${RED}current machine is not x86_64, please check the machine type${NC}"
    exit 1    
fi

gpu_info=($(lspci | grep -i vga))
if [[ ${#gpu_info[@]} -eq 0 ]]; then
    echo -e "${RED}No GPU detected, please check the GPU${NC}"
    exit 1
fi

gpu_type=${gpu_info[7]}
if [[ $gpu_type == $gpu_type_3090 ]]; then
    echo -e "${GREEN}GPU type is RTX 3090${NC}"
elif [[ $gpu_type == $gpu_type_4090 ]]; then
    echo -e "${GREEN}GPU type is RTX 4090${NC}"
else
    echo -e "${RED}GPU type is not RTX 3090 or RTX 4090, please check the GPU type${NC}"
    exit 1
fi

echo ""
echo "------------------------- checking conan -------------------------"
conan_conf="${HOME}/.conan/conan.conf"
if [[ ! -e "${conan_conf}" ]]; then
    echo -e "${RED}conan is not installed, please install conan first${NC}"
    exit 1
fi
conan_save_path=$(conan config get storage.path)
if [[ ! -e "${conan_save_path}" ]]; then
    echo -e "${RED}conan save path is not exist, please check the conan config${NC}"
    exit 1
else
    echo -e "${GREEN}conan save path: ${conan_save_path}${NC}"
fi
conan_server_ok=$(conan search cudatoolkit -r=mcd)
if [[ $? -ne 0 ]]; then
    echo -e "${RED}conan server is not ok, please check the conan server and vpn ${NC}"
    exit 1
fi

echo ""
echo "------------------------- conan install cuda -------------------------"
if [[ $gpu_type == $gpu_type_3090 ]]; then
    conan install cudatoolkit/11.7.1@ -r=mcd
elif [[ $gpu_type == $gpu_type_4090 ]]; then
    conan install cudatoolkit/12.1.1@ -r=mcd
fi  

echo "------------------------- conan install cudnn -------------------------"
if [[ $gpu_type == $gpu_type_3090 ]]; then
    conan install cudnn/8.8.1@ -r=mcd
elif [[ $gpu_type == $gpu_type_4090 ]]; then
    conan install cudnn/8.8.1@ -r=mcd
fi

echo "------------------------- conan install tensorrt -------------------------"
if [[ $gpu_type == $gpu_type_3090 ]]; then
    conan install tensorrt/8.5.3.1@ -r=mcd
elif [[ $gpu_type == $gpu_type_4090 ]]; then
    conan install tensorrt/10.0.1.6@ -r=mcd
fi

echo ""
echo "------------------------- checking previous install -------------------------"
env_path=${PATH}
ld_path=${LD_LIBRARY_PATH}

cuda_bin=false
tensorrt_bin=false
cuda_lib=false
tensorrt_lib=false
cudnn_lib=false

if [[ $env_path == *cudatoolkit* ]]; then
    cuda_bin=true
fi
if [[ $env_path == *tensorrt* ]]; then
    tensorrt_bin=true
fi
if [[ $ld_path == *cudatoolkit* ]]; then
    cuda_lib=true
fi
if [[ $ld_path == *tensorrt* ]]; then
    tensorrt_lib=true
fi
if [[ $ld_path == *cudnn* ]]; then
    cudnn_lib=true
fi


echo ""
echo "------------------------- configure environment variables -------------------------"
if [[ $gpu_type == $gpu_type_3090 ]]; then
    if [[ $cuda_bin == true ]]; then
        echo -e "${RED}cuda bin path is already in PATH, please check the PATH${NC}"
    else
        echo "export PATH=${conan_save_path}/cudatoolkit/11.7.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/bin:$PATH" >> ~/.zshrc
    fi

    if [[ $tensorrt_bin == true ]]; then
        echo -e "${RED}tensorrt bin path is already in PATH, please check the PATH${NC}"
    else
        echo "export PATH=${conan_save_path}/tensorrt/8.5.3.1/_/_/package/07ac5c3af8ef18c90f847e0b34214c29b248ae61/bin:$PATH" >> ~/.zshrc
    fi
    
    if [[ $cuda_lib == true ]]; then
        echo -e "${RED}cuda lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else
        echo "export LD_LIBRARY_PATH=${conan_save_path}/cudatoolkit/11.7.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/lib64:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi

    if [[ $tensorrt_lib == true ]]; then
        echo -e "${RED}tensorrt lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else
        echo "export LD_LIBRARY_PATH=${conan_save_path}/tensorrt/8.5.3.1/_/_/package/07ac5c3af8ef18c90f847e0b34214c29b248ae61/lib:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi

    if [[ $cudnn_lib == true ]]; then
        echo -e "${RED}cudnn lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else
        echo "export LD_LIBRARY_PATH=${conan_save_path}/cudnn/8.8.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/lib64:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi  
elif [[ $gpu_type == $gpu_type_4090 ]]; then
    if [[ $cuda_bin == true ]]; then
        echo -e "${RED}cuda bin path is already in PATH, please check the PATH${NC}"
    else
        echo "export PATH=${conan_save_path}/cudatoolkit/12.1.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/bin:$PATH" >> ~/.zshrc
    fi

    if [[ $tensorrt_bin == true ]]; then
        echo -e "${RED}tensorrt bin path is already in PATH, please check the PATH${NC}"
    else
        echo "export PATH=${conan_save_path}/tensorrt/10.0.1.6/_/_/package/0a1a865b77b0e57e6e8e2dc29ddb0b74020d4850/bin:$PATH" >> ~/.zshrc
    fi

    if [[ $cuda_lib == true ]]; then
        echo -e "${RED}cuda lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else
        echo "export LD_LIBRARY_PATH=${conan_save_path}/cudatoolkit/12.1.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/lib64:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi

    if [[ $tensorrt_lib == true ]]; then
        echo -e "${RED}tensorrt lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else
        echo "export LD_LIBRARY_PATH=${conan_save_path}/tensorrt/10.0.1.6/_/_/package/0a1a865b77b0e57e6e8e2dc29ddb0b74020d4850/lib:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi

    if [[ $cudnn_lib == true ]]; then
        echo -e "${RED}cudnn lib path is already in LD_LIBRARY_PATH, please check the LD_LIBRARY_PATH${NC}"
    else   
        echo "export LD_LIBRARY_PATH=${conan_save_path}/cudnn/8.8.1/_/_/package/7c101a7841330ab9f365e48de9cdde29deae78c1/lib64:$LD_LIBRARY_PATH" >> ~/.zshrc
    fi      
fi