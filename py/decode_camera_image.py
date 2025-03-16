import sqlite3
import sys
import numpy as np
import cv2
from rosidl_runtime_py.utilities import get_message
from rclpy.serialization import deserialize_message
import os
import cv2
from IPython import embed

if __name__ == '__main__':
    name = os.path.dirname(sys.argv[1])
    print(name)
    conn = sqlite3.connect(sys.argv[2])
    sql = "select * from topics"
    all_topics_info = conn.execute(sql).fetchall()

    for x in all_topics_info:
        topic_id = x[0]
        topic_name = x[1]
        topic_type = x[2]
        if topic_name == '/sensor/cam_front_30/compressed':
            sql = "select * from messages where topic_id={}".format(topic_id)
            cursor = conn.execute(sql)
            # os.makedirs(name, exist_ok=True)
            for row in cursor:
                msg = deserialize_message(row[3], get_message(topic_type))
                timestamp = str(
                    msg.header.stamp.sec).zfill(10) + '.' + str(
                        msg.header.stamp.nanosec).zfill(9)
                dst = os.path.join(name, "{}.jpg".format(timestamp))
                with open(dst, 'wb') as f:
                    f.write(msg.data.tobytes())
        # if topic_type == 'sensor_msgs/msg/CompressedImage':
        #     sql = "select * from messages where topic_id={}".format(topic_id)
        #     cursor = conn.execute(sql)
        #     # os.makedirs(name, exist_ok=True)
        #     for row in cursor:
        #         msg = deserialize_message(row[3], get_message(topic_type))
        #         timestamp = str(
        #             msg.header.stamp.sec).zfill(10) + '.' + str(
        #                 msg.header.stamp.nanosec).zfill(9)
        #         dst = os.path.join(name, "{}.jpg".format(timestamp))
        #         with open(dst, 'wb') as f:
        #             f.write(msg.data.tobytes())
        # elif topic_type == 'sensor_msgs/msg/Image':
        #     sql = "select * from messages where topic_id={}".format(topic_id)
        #     cursor = conn.execute(sql)
        #     # os.makedirs(name, exist_ok=True)
        #     for row in cursor:
        #         msg = deserialize_message(row[3], get_message(topic_type))
        #         timestamp = str(
        #             msg.header.stamp.sec).zfill(10) + '.' + str(
        #                 msg.header.stamp.nanosec).zfill(9)
        #         dst = os.path.join(name, "{}.jpg".format(timestamp))
        #         cv2.imwrite(dst, np.frombuffer(msg.data.tobytes(), dtype='uint8').reshape(2160, 3840, 3))
        # elif topic_type == 'rslidar_msg/msg/RslidarScan':
        #     print(topic_name, topic_type)
        #     sql = "select * from messages where topic_id={}".format(topic_id)
        #     cursor = conn.execute(sql)
        #     for row in cursor:
        #         print(row[2]/1e9)
        #         break
