---
layout: post
title: 用 google 解决问题若干
category:
tags: []
---
{% include JB/setup %}

<p>
从 Solaris 切换到 Ubuntu 6.06，安装很顺利，内网机器多得很，随便找台先备份，然后整个硬盘抹掉重装。在一个全是 Solaris 的网络中使用 Linux，比在一个全是 Windows 的网络中使用 Linux 自然要容易得多，但我还是遇到了一些问题。
</p>



<p>
<b>1. NIS</b>
</p>



<p>
这个自然是首当其冲的。<code>apt-get install portmap nis</code>，顺手把 openssh-server 也装上，然后就是修改 /etc/nsswitch.conf，让 files 优先于 nis，然后把本机登陆的普通用户 uid 和 gid 改成自己 nis 账号一样的，这样在本机和网络上访问文件就畅通无阻了，哈。这是最近才悟出的，以前早该这么改的，用本机账号登陆自然比 nis 账号快。
</p>



<p>
<b>2. automount 的问题</b>
</p>



<p>
公司的 NIS 网络上，任何一台 Solaris 主机上访问 /net/host 时就自动在 /net 下建立 host 子目录并将主机host 上的共享目录 mount 上，非常方便，Ubuntu 上可以有同样的功能。<code>apt-get install nfs-common autofs</code>，只装 autofs 时并不会自动安装 nfs-common （没有建立依赖关系），但实际上 /etc/init.d/autofs 脚本依赖 nfs-common 包的 showmount 命令，这是读那个脚本才发现的。装上这两个包之后，修改 /etc/auto.master，把 <code>#/net /etc/auto.net</code> 这行的注释去掉，然后 <code>/etc/init.d/autofs restart</code> 就 OK 了。
</p>



<p>
<b>3. mount --bind 的问题</b>
</p>



<p>
Linux 支持把一个目录树 mount 到另一个目录树，命令是 mount --bind /src/tree /dest/tree，这个早就知道，但今天想让它启动就 mount 上，需要写到 /etc/fstab，看了 man page，没有提，按自己的想像试了一下还是不行，最后还是 google 搞定，写法是：<code>/src/tree /dest/tree none bind</code>
</p>



<p>
<b>4. tip 命令</b>
</p>



<p>
Solaris 上链接串口的命令是 tip，Linux 上对应的 <a href="http://www.idevelopment.info/data/Unix/Solaris/SOLARIS_UsingSerialConsoles.shtml">可以用 minicom 和 uucp</a>，后者是标配，<code>cu -l /dev/ttyS0 -s 9600</code> 就行了。
</p>



<p>
<b>5. NFS 共享</b>
</p>



<p>
要装 nfs-kernel-server，然后在 /etc/exports，最简单的例子：加入 <code>/sharedir *(rw,async)</code>，然后运行 exportfs -rv 共享。
</p>



<p>
<b>6. Solaris 上访问 Linux 的 NFS 共享目录</b>
</p>



<p>
这里遇到的问题就大了，从 Solaris 上访问 /net/ubuntu 发现目录能自动 mount 上，并且权限显示是 drwxr-xr-x root root，但 cd 到那个目录就提示 Permission Denied，手动来 mount -F nfs ubuntu:/share /mnt 出错提示为 Not Owner，郁闷。又是一通 google，找到 <a href="http://www.filibeto.org/pipermail/solaris-users/2005-March/001258.html">这个讨论帖子</a>，原因是 Linux 的 NFSv4 支持还没有成熟，只能在 Solaris 上修改 /etc/default/nfs，把 <code>NFS_CLIENT_VERSMAX</code> 设置为 3 来凑合用 :-(
</p>



<p>
<b>Update on Mar 26, 2007: </b><ins>解决方案有了，rpc.nfsd 和 rpc.mountd 都有一个参数 -N 4 可以指定不启用 NFS 版本 4，只要修改 /etc/init.d/nfs-kernel-server，在语句 <code>exec $PREFIX/sbin/rpc.nfsd --</code> 以及 <code>exec $PREFIX/sbin/rpc.mountd --</code> 后面都加上 <code>-N 4 </code>这个参数，然后执行 <code>/etc/init.d/nfs-kernel-server restart</code> 重启 NFS 服务就可以了。</ins>
</p>



<p>
<b>7. Ubuntu 的中文字体问题</b>
</p>



<p>
默认的楷体很丑，用一个命令 <code>/usr/bin/fontconfig-voodoo -fs zh_CN</code> 生成一个 fontselecter 配置文件就美了。
</p>



<p>
<b>8. XP 登陆屏幕显示一大坨未读邮件</b>
</p>



<p>
晚上回家开机发现 XP 登陆屏幕显示一百多未读邮件，莫名其妙，真不知道这个从哪来的，有说是 hotmail 邮件，但我根本就没用 hotmail，我的 MSN 是 gmail.com 的，查了一下后台进程没有异常的，后来搜到 <a href="http://support.microsoft.com/?kbid=304148">MS 自己的文章</a> 给了个解决办法：将 <code>HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail</code> 这个键的权限设为对 system 账号只读，即对 system 用户清除完全控制的权限。
</p>



<p>
<b>总结：</b>这些问题基本上全是看 man page 和 google 搞定的，甚至觉得 google 比看手册更快，尤其大概知道怎么回事但不知道细节的问题，没有装 stardict 的时候还用 <code>define:</code> 查了不少单词用法，呵呵。前几天看到一帖子，问什么命令能快速显示 ASC 表，想对照几个值，后来一家伙说 google 最快，看到的时候马上觉得这是最佳答案，我已经太思维定势了。要活用 google，嗯。
</p>

