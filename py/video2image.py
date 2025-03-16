import sys
import cv2
import numpy as np
import argparse
from mcap.reader import make_reader
from mcap_ros2.reader import read_ros2_messages
from mcap_ros2.decoder import DecoderFactory
from mcap_ros2.writer import Writer as Ros2Writer
from sensor_msgs.msg import CompressedImage
from tqdm import tqdm
import h264decoder

parser = argparse.ArgumentParser()
parser.add_argument("bag", help="ros bag addr")
parser.add_argument("-o", "--output", default="", help='output bag')
parser.add_argument("-t", "--topic", default="/sensor/cam_front_120/h264", help="topic name")
parser.add_argument("-n", "--number", default=-1, type=int, help="number of frames to decode")
args = parser.parse_args()

if args.output == "":
    args.output = f"{args.bag[:-5]}_rewrite.mcap"
def run():
    decoder = h264decoder.H264Decoder()

    with open(args.bag, 'rb') as f, open(args.output, "wb") as fout:
        writer = Ros2Writer(output=fout)

        image_schema = writer.register_msgdef("sensor_msgs/CompressedImage",
"""\
std_msgs/Header header
string format
uint8[] data
================================================================================
MSG: std_msgs/Header
builtin_interfaces/Time stamp
string frame_id
""")

        reader = make_reader(f, decoder_factories=[DecoderFactory()])
        s = reader.get_summary()
        for channel_id, channel in s.channels.items():
            if channel.topic == args.topic:
                break
        total = s.statistics.channel_message_counts[channel_id]
        if args.number != -1 and args.number < total:
            total = args.number

        i = 0
        for schema, channel, message, msg in tqdm(reader.iter_decoded_messages(topics=args.topic), total=total):
            framedatas = decoder.decode(msg.data)
            assert len(framedatas) <= 1, len(framedatas)
            if len(framedatas) == 0:
                continue
            framedata = framedatas[0]
            img = np.frombuffer(framedata.data, dtype='uint8').reshape((2160,3840,3))
            img = img[:,:,::-1]  # rgb to bgr
            encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 85]
            c = np.array(cv2.imencode('.jpg', img, encode_param)[1]).tobytes()
            writer.write_message(
                topic="/sensor/cam_front_120/compressed",
                schema=image_schema,
                message={
                    "header": {
                        "stamp": {
                            "sec": msg.timestamp.sec,
                            "nanosec":  msg.timestamp.nanosec,
                        },
                        "frame_id": "",
                    },
                    "format": "jpeg",
                    "data": c,
                },
                log_time=message.log_time,
                publish_time=message.publish_time,
                sequence=message.sequence,
            )
            i += 1
            if i >= args.number and args.number != -1:
                break
        writer.finish()

if __name__ == "__main__":
    run()
