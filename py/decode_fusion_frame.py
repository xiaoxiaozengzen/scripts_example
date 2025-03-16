import os
import sys
import argparse
from mcap.reader import make_reader
from mcap_ros2.reader import read_ros2_messages
from mcap_ros2.decoder import DecoderFactory
import json
from tqdm import tqdm

parser = argparse.ArgumentParser()
parser.add_argument("bag", help="ros bag addr")
parser.add_argument("-o", "--output", help='output dir')
parser.add_argument("-t", "--topic", default="/fusion_frame", help="topic name")
parser.add_argument("-n", "--number", default=-1, type=int, help="number of frames to decode")
args = parser.parse_args()


with open(args.bag, 'rb') as f:
    reader = make_reader(f, decoder_factories=[DecoderFactory()])
    s = reader.get_summary()
    for channel_id, channel in s.channels.items():
        if channel.topic == args.topic:
            break
    total = s.statistics.channel_message_counts[channel_id]
 
    os.system(f"mkdir -p {args.output}")
    for _, _, _, msg in tqdm(reader.iter_decoded_messages(topics=args.topic), total=total):
        j = json.loads(msg.data)
        with open(os.path.join(args.output, f"Fusion_frame_{j['frame_id']}.json"), "w") as fout:
            json.dump(j, fout)

