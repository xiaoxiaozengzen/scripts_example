import numpy as np
import cv2 as cv
import os
import sys
import time

file_path = os.path.dirname(sys.argv[1])
files = sorted(os.listdir(file_path))

if __name__ == '__main__':
    # 图片数量
    images=len(files)
    #读取一张图片
    img = cv.imread(file_path+"/"+files[0])
    #获取当前图片的信息
    imgInfo = img.shape
    size = (imgInfo[1],imgInfo[0])
    print(size)

    fps = 10   #保存视频的FPS，可以适当调整
    fourcc = cv.VideoWriter_fourcc(*"mp4v")

    #完成写入对象的创建，第一个参数是合成之后的视频的名称，第二个参数是可以使用的编码器，第三个参数是帧率即每秒钟展示多少张图片，第四个参数是图片大小信息
    videowrite = cv.VideoWriter('video.mp4', fourcc, fps, size)
    # videowrite = cv.VideoWriter('video_2.mp4', -1, fps, size)
    for i in range(1,images):
        #print(i)
        fileName = file_path+"/"+files[i]
        print(files[i])
        img = cv.imread(fileName)
        #写入参数，参数是图片编码之前的数据
        videowrite.write(img)
    print('end!')
    videowrite.release()