#!/bin/bash

new_session(){
    tmux new -d -s $1 -n $2
    tmux send -t "$1:$2" "$3" C-m
}

new_window(){
    tmux new-window -d -n $2
    tmux send -t "$1:$2" "$3" C-m
}

tmux kill-session -t 'fuse_visual'
new_session 'fuse_visual' 'radar_visual' 'start_radar_visual'
new_window 'fuse_visual' 'detec_visual' 'cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 run py_obstacle_visualization_nodes py_obstacle_detection_visualization_node_exe'
new_window 'fuse_visual' 'fusing_visual' 'cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 run py_obstacle_visualization_nodes py_obstacle_fusing_visualization_node_exe'
new_window 'fuse_visual' 'lidar_visual' 'cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 run py_tf_nodes py_static_frame_publisher_node_exe'
new_window 'fuse_visual' 'map_visual' 'cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 launch map_visualize map_visualize_offline_test.launch.py'
#tmux new-window -d -n 'lidar_visual'
#tmux split-window -t "fuse_visual:lidar_visual"
#tmux select-pane -t 1
#tmux send -t "fuse_visual:lidar_visual" "cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 run py_tf_nodes py_static_frame_publisher_node_exe" C-m
#tmux select-pane -t 0
#tmux send -t "fuse_visual:lidar_visual" "cd /home/user/colcon_ws; source ./init_vehicle.sh; ros2 run py_tf_nodes py_tf_nodes_exe" C-m


tmux kill-session -t 'fuse_record'
new_session 'fuse_record' 'bag_record' 'cd /home/user/colcon_ws'

tmux kill-session -t 'fuse_rviz'
new_session 'fuse_rviz' 'visual' 'cd /home/user/colcon_ws; source ./init_vehicle.sh; rviz2'

tmux at -t fuse_record
