#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 new_session_name" >&2
    exit 1
fi

session_name=$1

if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Session '$session_name' already exists. "
    exit 1
fi

# 创建一个新的tmux会话，但不要attach到它
tmux new -d -s $session_name

# 在会话中分割窗口
tmux split-window -v -t "$1:0.0"
tmux split-window -v -t "$1:0.0"
tmux split-window -v -t "$1:0.0"
tmux split-window -v -t "$1:0.0"
tmux split-window -h -t "$1:0.0"
tmux split-window -h -t "$1:0.0"
tmux split-window -h -t "$1:0.0"
tmux split-window -h -t "$1:0.0"
tmux select-layout tiled


tmux send-keys -t $1:0.0 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.1 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.2 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.3 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.4 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.5 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.6 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.7 "ssh root@198.18.42.52" C-m
tmux send-keys -t $1:0.8 "ssh root@198.18.42.52" C-m


sleep 2

tmux send-keys -t $1:0.0 "cd /data/opt/run_sh; ./kill.sh" C-m
sleep 2


tmux send-keys -t $1:0.1 "cd /data/opt/run_sh; ./init.sh" C-m
tmux send-keys -t $1:0.2 "cd /data/opt/run_sh; ./run_someip.sh" C-m
tmux send-keys -t $1:0.3 "cd /data/opt/run_sh; ./run_tsynd.sh" C-m
sleep 1
tmux send-keys -t $1:0.4 "cd /data/opt/run_sh; ./run_Dataclosed.sh" C-m
sleep 1
tmux send-keys -t $1:0.5 "cd /data/opt/run_sh; ./run_APS.sh" C-m
tmux send-keys -t $1:0.6 "cd /data/opt/run_sh; ./run_BSW.sh" C-m
tmux send-keys -t $1:0.7 "cd /data/opt/run_sh; ./run_TSM.sh" C-m
tmux send-keys -t $1:0.8 "cd /data/opt/run_sh; ./run_mach_all.sh" C-m



# 附加到新tmux会话
tmux attach -t $session_name