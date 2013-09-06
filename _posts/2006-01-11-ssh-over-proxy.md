---
layout: post
title: 在只允许 proxy http 外出的环境中使用 ssh/telnet
category:
tags: []
---
{% include JB/setup %}

<p>
公司内部只能通过 http 代理进行外出访问，FTP 下载、Gaim 这种本身支持代理的东西虽然没有问题，但要想 ssh 或者 telnet 登陆外面的服务器就不好办了。Google 到了
<a href="http://directory.fsf.org/GNU/httptunnel.html">httptunnel</a>，可以建立 HTTP 隧道跑任何 TCP 应用，支持 proxy，它由客户端 htc 和服务端 hts 两个程序组成，安装很简单：
</p>



<pre>
wget http://ftp.gnu.org/gnu/httptunnel/httptunnel-3.3.tar.gz
tar xzvf ../tarball/httptunnel-3.3.tar.gz
cd httptunnel-3.3/
./configure
make
</pre>



<p>
这就得到了 hts 和 htc，可以 make install 装到 /usr/local/bin，或者直接把 hts htc 复制到要的位置就好了。
</p>



<p>
假设要从内网 10.1.1.1 登陆外面的 234.5.6.7，在两台机器上分别装好 httptunnel，10.1.1.1 上要运行 htc，234.5.6.7 上要运行 hts（最初只好在能登陆的环境中操作啦），代理服务器为 222.188.125.66:3128，原理如下：
</p>



<pre>

10.1.1.1                    222.188.125.66       234.5.6.7
.------------------------.  .-----------------.  .-----------------------.
| [ssh client]           |  |  [proxy :3128]  |  |                [sshd] |
|    |                   |  |      /          |  |                  ^    |
|    |                   |  |     /           |  |                  |    |
|    `----> [htc :2222] -+--+->--'      `-->--+--+-> [hts :4433] ---'    |
`------------------------'  `-----------------'  `-----------------------'

</pre>



<p>
在 234.5.6.7 上运行 hts：
</p>



<pre>
hts -F localhost:22 -S 4433
</pre>



<p>
在 10.1.1.1 上运行 htc 然后就可以 ssh 从本机穿过隧道：
</p>



<pre>
htc -S -F 2222 234.5.6.7:4433 -P 222.188.125.66:3128
ssh -v localhost -p 4433 -l username
</pre>



<p>
Cool!
</p>

