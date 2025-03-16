#!/bin/bash

if [ $# -ne 1 ];then
    echo "usage: ./tmux_multi.sh <session_name>"
    exit 1
fi

session_name=$1

# 创建session
tmux kill-session -t ${session_name}
tmux new-session -d -s ${session_name} -n renji

# 创建三个window
tmux rename-window -t ${session_name}:0 'main'
tmux new-window -t ${session_name}:1 -n 'pane1'
tmux new-window -t ${session_name}:2 -n 'pane2'

# 选择窗口
tmux select-window -t ${session_name}:0

#================ 第一种分割窗口的方式=====================

# 先分割多个pane，然后调整布局
tmux split-window -v
tmux split-window -h
tmux split-window -v
tmux split-window -h
tmux split-window -v
tmux split-window -h
tmux split-window -v
tmux split-window -h
tmux split-window -h

# 调整窗口布局
# # 垂直等宽布局
# tmux select-layout even-vertical
# # 水平等宽布局
# tmux select-layout even-horizontal
# 平铺布局
tmux select-layout -t ${session_name} tiled
# # 全屏布局
# tmux select-layout fullscreen

# #================ 第二种分割窗口的方式=====================
# tmux split-window -h -p 67 -t ${session_name}
# tmux split-window -h -p 50 -t ${session_name}
# tmux split-window -v -p 67 -t ${session_name}
# tmux split-window -v -p 50 -t ${session_name}
# tmux select-pane -t ${session_name}:0.1
# tmux split-window -v -p 33 -t ${session_name}
# tmux select-pane -t ${session_name}:0.1
# tmux split-window -v -p 50 -t ${session_name}
# tmux select-pane -t ${session_name}:0.0
# tmux split-window -v -p 33 -t ${session_name}
# tmux select-pane -t ${session_name}:0.0
# tmux split-window -v -p 50 -t ${session_name}
# tmux select-layout -t ${session_name}:0 tiled # 所有窗格等宽排列

#====================== 执行命令 =================================
tmux select-pane -t $1:0.0
tmux send-keys -t $1:0.0 "cd ~ && ls" C-m

tmux select-pane -t $1:0.1
tmux send-keys -t $1:0.1 "ls" C-m

tmux select-pane -t $1:0.2
tmux send-keys -t $1:0.2 "ls -alh" C-m

# 修改pane的名字
# tmux select-pane -T test -t ${session_name}:0.0

tmux at -t ${session_name}