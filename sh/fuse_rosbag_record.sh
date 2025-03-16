TIMESTAMP=$(date +%H:%M:%S)
dir=$(date +%Y%m%d)

logdir=/home/user/cgz_workspace/dag/$dir
if [ ! -d "$logdir" ];then
mkdir -p $logdir
fi

source /home/user/colcon_ws/init_vehicle.sh

ros2 bag record \
--max-bag-size 1048576 \
/sensor/radar0_object \
/sensor/corr_imu \
/sensor/gps \
/sensor/ins_pose \
/sensor/raw_imu \
/perception/detection/obstacle_array_result \
/sensor/front_lidar_points \
-o $logdir/fuse_$TIMESTAMP