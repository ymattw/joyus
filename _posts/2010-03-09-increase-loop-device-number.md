---
layout: post
title: 如何增加 kernel 最大允许使用的 loop device 个数
tags: [linux]
---
{% include setup %}

整理下笔记。kernel 默认编译是最大允许 8 个 loop 设备，见到 mount: could not
find any free loop device 错误时就该处理了，要么释放一些
mount，要么提高这个上限，方法是（以提高上限到 32 为例）

先修改 /etc/modprobe.conf （2.6 内核），增加

    options loop max_loop=32

然后 umount 所有的 loop 设备（用 mount 命令查看），再卸载 loop 模块

    rmmod loop

如果发现所有 loop 设备都 umount 了 rmmod 还是报 ERROR: Module loop is in
use，使用 losetup

    losetup -a                      # 查看 loop 设备使用情况
    losetup -d /dev/loop1           # detach 设备（example）

再重新加载 loop 模块检查是否生效

    modprobe loop
    dmesg | grep loop               # 应当能见到 loop: loaded (max 32 devices)

最后建立 loop 设备文件

    ls -d /dev/loop*
    for ((i=8; i<32; i++)); do
        mknod -m0660 /dev/loop$i b 7 $i
        chown root.disk /dev/loop$i
    done
