---
layout: post
title: 为 ubuntu 做了点微小的贡献
category:
tags: []
---
{% include JB/setup %}

周五下班前遇到一个怪问题，gnome-session 突然启动失败，日志文件里也看不出问题根
源。今天在家决心把它调试出来。过程很是费劲，首先要用 vpn 连到公司网络，然后
SecureCRT 登陆上公司机器，安装 x11vnc，还得一个 X Server 才能在公司机器上运行 X
程序，不想折腾 X-win32 或别的了，自己 VMware 里面也装了 ubuntu，启动 X 然后从里
面 ssh -X 过去就可以启用 X11 Forwarding了。光这些还不行，x11vnc 是启动不了，因
为用户还没有登陆，需要设置 gdm 自动登陆用户。运行 /usr/sbin/gdmsetup 可以设置自
动登陆，后来发现还可以直接修改 `/etc/gdm/gdm.conf-custom`，增加这样一段（后面注
释掉的三行是超时自动登陆的设置）：

    [daemon]
    AutomaticLoginEnable=true
    AutomaticLogin=username
    #TimedLoginEnable=true
    #TimedLoginDelay=10
    #TimedLogin=username

然后重启 gdm，不停用 w 命令观察，果然看到用户正在自动登陆，执行的命令是
/etc/gdm/Xsession，接下来应该就是失败了弹出对话框了，因为正常的应该是执行到
/usr/bin/gnome-session。打开 /etc/gdm/Xsession 看了看，太多没耐心看，在第一行
_#!/bin/sh_ 后面加 -x 参数，然后在第一条命令前加

    exec 1>/tmp/x.log 2>&1

再重启 gdm，看 /tmp/x.log，看到

    ++ '[' '!' -d /etc/X11/Xsession.d ']'
    +++ /bin/ls -F --color /etc/X11/Xsession.d
    ++ for F in '$(ls $1)'
    ++ expr '^[[0m^[[0m20xorg-common_process-args^[[0m' : '[[:alnum:]_-]\+$'
    ++ for F in '$(ls $1)'
    ++ expr '^[[0m30xorg-common_xresources^[[0m' : '[[:alnum:]_-]\+$'
    ...

哈哈，看到那些 `^[[0m` 控制字符我就明白了，问题在于 ls 被 alias 成了 '/bin/ls
-F --color' 了，颜色控制字符搞的鬼。想不到大牛也能犯这种低级错误啊 :)。再读了一
下，脚本会读取 /etc/profile 和 $HOME/.profile，如果它们中任一个设了那种 --color
的 alias，就会导致这个失败，我的情况正好是 /etc/profile 中设置了，很土吧？

Fix 就很简单了，把 ls 改成绝对路径 /bin/ls 就行了。

想到解决过程的麻烦，我决定到 bug 数据库里面去报一报，查了一下，果然有人遇到过，
并且报告了，但没有解决到点子上，于是心情很爽的添加 comments。

* [Bug #48876](https://launchpad.net/distros/ubuntu/+source/gnome-session/+bug/48876): gnome-session fails when "alias ls='ls --color'" in .profile
* [Bug #45951](https://launchpad.net/distros/ubuntu/+source/gnome-session/+bug/45951) (duplicate)
