---
layout: post
title: SSH via Proxy
tags: [ssh, proxy]
---

公司只能通过 http proxy 上网，Solaris 里面自带的 ssh-http-proxy-connect 命令不
管用，想到 dreamhost 提供的 shell 中摆弄几下总也不成功。今天 google 到一个东西
可以说是最好的解决办法：goto-san-connect 1.96。

源码：<a href="http://zippo.taiyo.co.jp/%7Egotoh/ssh/connect.c">http://zippo.taiyo.co.jp/~gotoh/ssh/connect.c</a>

编译方法源码里就有。

用于 openssh 时在 ~/.ssh/config 里用 ProxyCommand 命令，例如：

    Host joyus
        User me
        Hostname joyus.org
        ProxyCommand connect -4 -H proxyserver:port %h %p

更多信息：

Using OpenSSH through a SOCKS compatible PROXY on your LAN
<a href="http://zippo.taiyo.co.jp/%7Egotoh/ssh/openssh-socks.html">http://zippo.taiyo.co.jp/~gotoh/ssh/openssh-socks.html</a>

Detailed usage
<a href="http://zippo.taiyo.co.jp/%7Egotoh/ssh/connect.html">http://zippo.taiyo.co.jp/~gotoh/ssh/connect.html</a>
