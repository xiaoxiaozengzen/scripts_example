#!/bin/bash

function set_canfd_channel()
{
        sudo ip link set can$1 down
        sudo ip link set can$1 type can bitrate 500000 sample-point 0.8 dbitrate 2000000 dsample-point 0.8 restart-ms 100 fd on
        sudo ip link set can$1 up
}


function set_can_channel()
{
        sudo ip link set can$1 down
        sudo ip link set can$1 type can bitrate 500000
        sudo ip link set can$1 up
}

echo "12345" | sudo -S modprobe can
echo "12345" | sudo -S modprobe can_raw
echo "12345" | sudo -S modprobe can_dev
echo "12345" | sudo -S insmod /home/user/cgz/zlg_usbcabfd/usbcanfd200_400u/usbcanfd.ko

can_channel_num=`ip addr | grep -E " can[0-9]*:" | wc -l`
for (( i=0; i<${can_channel_num}; i++ ));do
        can_class=`ls -la /sys/class/net/can${i}`
        if [[ ${can_class} =~ "mttcan" ]];then
                echo "set mttcan can channel: "
                set_canfd_channel ${i}
        elif [[ ${can_class} =~ "usb" ]];then
                echo "set usb can channel:"
                set_canfd_channel ${i}
        else
                echo "other can channel"
                set_canfd_channel ${i}
        fi
done
