import sqlite3
import sys
import numpy as np
import cv2
from mcap.reader import make_reader
from mcap_ros2.reader import read_ros2_messages
from mcap_ros2.decoder import DecoderFactory
from mcap_ros2.writer import Writer as Ros2Writer
from rosidl_runtime_py.utilities import get_message
from rclpy.serialization import deserialize_message
import os
import cv2
from IPython import embed
import argparse
from tqdm import tqdm

parser = argparse.ArgumentParser()
parser.add_argument("bag", help="ros bag addr")
parser.add_argument("-o", "--output", default="", help='output bag')
parser.add_argument("-t", "--topic", default="/sensor/cam_front_120/compressed", help="topic name")
parser.add_argument("-n", "--number", default=-1, type=int, help="number of frames to decode")
args = parser.parse_args()

if args.output == "":
    args.output = f"{args.bag[:-5]}_rewrite"

if __name__ == '__main__':
    print(args.bag)

    with open(args.bag, 'rb') as f:
        reader = make_reader(f, decoder_factories=[DecoderFactory()])
        s = reader.get_summary()
        for channel_id, channel in s.channels.items():
            if channel.topic == args.topic:
                break

        total = s.statistics.channel_message_counts[channel_id]
        if args.number != -1 and args.number < total:
            total = args.number

        i = 0
        name = args.output
        os.makedirs(name, exist_ok=True)
        for schema, channel, message, msg in tqdm(reader.iter_decoded_messages(topics=args.topic), total=total):
            i = i + 1
            timestamp = str(i)
            print("data.size {}, encoding {}, id {}, name {}".format(len(schema.data), schema.encoding, schema.id, schema.name))
            print("channel_id: {}, data.size {}, log_time {}, publish_time {}, sequence {}".format(message.channel_id, len(message.data), message.log_time, message.publish_time, message.sequence))
            print("id {}, message_encoding {}, schema_id {}, topic {}".format(channel.id, channel.message_encoding, channel.schema_id, channel.topic))
            # print("metadata {}".format(channel.metadata))
            print("msg.header.stamp.sec {}, format {}, data.size {}".format(msg.header.stamp.sec, msg.format, len(msg.data)))
            # dst = os.path.join(name, "{}.jpg".format(timestamp))
            # with open(dst, 'wb') as f:
            #     f.write(msg.data)
