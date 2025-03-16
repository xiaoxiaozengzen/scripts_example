#!/usr/bin/expect

set zhanghao "1093177988"
set mima "123456"

spawn "./main"
expect "zhanghao: "
send "${zhanghao}\r"
expect "mima: "
send "${mima}\r"
expect eof