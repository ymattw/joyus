---
layout: post
title: ssh over http?
category:
tags: []
---
{% include JB/setup %}

<p>
公司查封了端口 22，除了 80 和 443 也只有少数端口开放，ssh 登陆远程主机成了奢侈的愿望。依靠代理是不能想的，free vpn 也没戏，tor？开放的 tor 服务器早就被掐了。当然远程管理有很多 web 程序，但我的最终目的是要用 ssh -D 做 socks proxy。
</p>



<p>
为此我想了一个途径，就是 web 服务器上放一个 cgi，通过 HTTP POST 发送 ssh 数据包，大体上思路是这样：
</p>

                          

<pre>

               SSH                HTTP POST             SSH
  ssh client &lt;=====&gt; http agent &lt;===========&gt; web cgi &lt;=====&gt; sshd

</pre>



<p>
其中 http agent 就是一个转换程序，listen 在 localhost 某个端口，接收 ssh client 的请求，再包成 HTTP POST 请求发送出去，接收应答发回给 ssh client，这个很简单，用 python 也就几十行就完工了。另一端一开始也不了解，边看资料边做，做着做着问题来了，cgi 是请求 - 响应工作模式，响应完了就结束了，就算 web 服务支持pipelining，也不能和 sshd 保持连接。
</p>



<p>
然后我要想了个土办法，web cgi 不直接和 sshd 打交道，实际上它也不能和其他进程打交道，鉴于 cgi 的生命周期特征，可以用原始的办法，那就是用文件和其他进程通信。cgi 把接收到的请求写到一个 input 文件，另外起一个 pickup 进程，和sshd 保持连接，轮询那个 input 文件，转发到 sshd，再把 sshd 应答写到 output 文件，cgi 从ouput 中取应答作为 http response 发回给 http agent。
</p>



<p>
想不到的土，但是总算完成了一个 proof of concept，用 python 做这种东西相当的方便，当然其中也有些地方很费脑筋了，比如这模型只是一个半双工的模式，要模拟成全双工的，http agent 还得用超时机制主动请求。
</p>



<p>
要做成一个真正可用的工具，至少还得解决这些问题：
</p>


<ul>

    <li>文件要加 lock 机制，php 里面不知道有没有这功能</li>
    <li>减少资源的占用，cgi 每次都要打开两个文件进行读写，有没有办法不用文件来通信？</li>
    <li>性能。半双工模式有很多等待，如何在资源和性能之间平衡？</li>

</ul>



<p>
PS: 在 dreamhost 运行了一下下，马上被当作 DoS 了，大概是 pickup 进程 I/O 请求太多，给合租伙伴制造了麻烦，真是对不住。
</p>



<p>
PS again: 如果真要在跟我一样的苛刻环境下远程 ssh，用 <a href="http://webssh.org/">http://webssh.org</a> 吧，不过程序是装在别人主机上，谁知道是不是安全。
</p>

