---
layout: post
title: ubuntu：用 cu 命令连接串口
category: tech
tags: []
---
{% include JB/setup %}

连接串口软件很多，但我倾向于用简单的命令行工具，不爱用 minicom。cu  命令属于
uucp 软件包，可用来连接串口，替代 solaris 上更常用的工具 tip。查看 man page，用
法很简单：`cu -l /dev/ttyS0 -s 9600`。其中串口设备文件可用命令
`dmesg | grep ttyS` 来找。

为了方便别人远程过来使用，我把上面的命令写到一个脚本文件 /usr/local/bin/tip并加
上执行权限，然后增加一个普通用户 tip 并把登录 shell 指定为/usr/local/bin/tip，
远程用户可以 ssh -l tip myhost 直接连到我的串口，但是我遇到一个奇怪现象，总是报
权限不够，甚至在本机使用超级用户也不行：

    # cu -l /dev/ttyS0 -s 9600
    cu: open (/dev/ttyS0): Permission denied
    cu: /dev/ttyS0: Line in use

但用自己的普通用户却没问题。查看了 /dev/ttyS0 的属性，是

    crw-rw---- 1 root dialout 4, 64 2006-08-08 17:38 /dev/ttyS0

安装系统时建立的普通用户已经在 dialout 组了，现在把 tip 用户属组改为 dialout 就
好了。当然直接 chmod 666 /dev/ttyS0 也行。
