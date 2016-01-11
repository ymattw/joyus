---
layout: post
title: 用 Expect 防发呆原来这么简单
tags: [expect]
---
{% include setup %}

因为使用 http 代理上水木，发呆一分钟就会导致断线，防发呆的需求非常迫切。google
了一通总算找到了用 expect 来做这个的方法（expect 自己的文档也太少了）。非常简单
，在 interact 命令里面用 timeout：

    #!/usr/bin/env expect
    # script name: sshsmth

    set timeout 60
    spawn ssh smth
    interact {
            timeout 30 { send " " }
    }

再用一个 shell 脚本在 X Window 里面用 gnome 终端来启动 ssh 过程，先新建配置文件
叫 smth，在里面指定字体和终端颜色等，--geometry 参数可以设置窗口大小：

    #!/bin/sh
    gnome-terminal --window-with-profile=smth --command sshsmth \
            --geometry=80x50 &

Perfect!
