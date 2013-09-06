---
layout: post
title: Ubuntu 上自动 mount NIS 用户的主目录
category:
tags: []
---
{% include JB/setup %}

<p>
Ubuntu 6.06 LTS，在 NIS 网络中不能自动 mount 主目录实在不方便，今天读了一下 automount(8)，/etc/init.d/autofs 和 /etc/auto.net 终于把它弄出来了。关键是用 program 这种形式来运行 automount，对应 的 program 程序要根据输入的 key 输出它的 mount option，mount point 和 mount entry，在 auto home 的情形下 key 当然应该用用户名。
</p>



<p>
步骤如下:
</p>



<p>
先建立一个脚本 /etc/auto.home：
</p>



<pre>

#!/bin/bash

[ -z "$1" ] &amp;&amp; exit 1

user=$1
options="-fstype=nfs,hard,intr,nodev,nosuid,nonstrict,async"

info=$(ypcat -k auto.home | grep -w ^$user) || exit 1
# username [options] nfsdir
set -- $info

if [ -n "$3" ]; then
        options="$options,$2"
        nfsdir="$3"
else
        nfsdir="$2"
fi

echo $options / $nfsdir

</pre>



<p>
加上执行权限 <code>chmod +x /etc/auto.home</code>，很重要！
</p>



<p>
/etc/auto.home user123 测试一下，输出应该类似这样才对：<br>
-fstype=nfs,hard,intr,nodev,nosuid,nonstrict,async / home1.prc:/global/export/home1/user123
</p>



<p>
然后执行 <code>automount --timeout=30 /home program /etc/auto.home</code>，
ls /home/user123 试一下，应该能列出目录，表示工作正常。
</p>



<p>
杀掉刚才这个进程，在 /etc/auto.mater 中加入一行
</p>


<pre>

/home   /etc/auto.home

</pre>


<p>
然后 <code>/etc/init.d/autofs restart</code> 就 OK 了。
</p>



<p>
<b>Update on Mar 16, 2007</b>：现在知道了有直接支持这个 NIS 映射自动加载的设置，man auto.master 就有了。只需要先执行 <code>ypcat -k auto.master</code> 得到映射表，如 /home 对应 auto.home，再在 /etc/auto.master 里加上一行 <code>/home yp:auto.home</code> 即可实现 /home 目录的自动加载。另外，上面这个脚本也不是没有用，它是通用办法，可以自己控制自动加载的行为。
</p>

