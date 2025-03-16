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
        print("topic_id= ", topic_id, " topic_name = ", topic_name)
        if topic_name == '/sensor/radar0_object':
            sql = "select * from messages where topic_id={}".format(topic_id)
            cursor = conn.execute(sql)
            # os.makedirs(name, exist_ok=True)
            for row in cursor:
                msg = deserialize_message(row[3], get_message(topic_type))
                print("msg_size = ", len(msg.objects))
                print("msg_buffer_size = ", len(row[3]))
