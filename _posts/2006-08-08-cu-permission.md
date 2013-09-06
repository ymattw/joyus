---
layout: post
title: ubuntu：用 cu 命令连接串口
category:
tags: []
---
{% include JB/setup %}

<p>
连接串口软件很多，但我倾向于用简单的命令行工具，不爱用 minicom。cu  命令属
于 uucp 软件包，可用来连接串口，替代 solaris 上更常用的工具 tip。查看 man page
，用法很简单：<code>cu -l /dev/ttyS0 -s 9600</code>。其中串口设备文件可用命令
<code>dmesg | grep ttyS</code> 来找。
</p>



<p>
为了方便别人远程过来使用，我把上面的命令写到一个脚本文件 /usr/local/bin/tip
并加上执行权限，然后增加一个普通用户 tip 并把登录 shell 指定为
/usr/local/bin/tip，远程用户可以 ssh -l tip myhost 直接连到我的串口，但是我遇
到一个奇怪现象，总是报权限不够，甚至在本机使用超级用户也不行：
</p>



<pre>

# <b>cu -l /dev/ttyS0 -s 9600</b>
cu: open (/dev/ttyS0): Permission denied
cu: /dev/ttyS0: Line in use

</pre>



<p>
但用自己的普通用户却没问题。查看了 /dev/ttyS0 的属性，是
</p>


<pre>

crw-rw---- 1 root dialout 4, 64 2006-08-08 17:38 /dev/ttyS0

</pre>


<p>
安装系统时建立的普通用户已经在 dialout 组了，现在把 tip 用户属组改为 dialout 就好了。当然直接 chmod 666 /dev/ttyS0 也行。
</p>

