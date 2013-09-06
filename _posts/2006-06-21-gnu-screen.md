---
layout: post
title: GNU screen实在是太帅了！
category:
tags: []
---
{% include JB/setup %}

<p>
在单位电脑上用 screen 启动要长时间运行的程序，回到家 VPN 登到机器上后，screen -d -r 恢复，哈哈，终端就切换到我这里来了，看看日志，没啥问题，再 detach 让它接着运行，明天去公司再切换回去看，虚拟的终端太棒了。简单记一下基本用法：
</p>



<p>
<a class="aimg" title="GNU Screen" href="/image/2006/gnu-screen.jpg">
<img class="left" src="/image/2006/gnu-screen.jpg" align="left" height="240"></a>$ <strong>screen -t “ssh-host1″ ssh host1</strong> 参数 -t 指定一个 title，便于标示多个窗口时
</p>


<p>
<strong>C-a :</strong> 打开命令输入，类似 VIM 的冒号模式
</p>


<p>
在冒号提示符后面可以启动新任务：<strong>screen ssh -t “host2″ console.sh host2</strong>
</p>


<p>
<strong>C-a c</strong> 直接开个新 shell
</p>


<p>
$ <strong>vim somefile</strong> 在新 shell 中启动新任务，这样任务都在一个会话（session）中
</p>



<p>
<strong>C-a C-d</strong> 断开（detach）当前会话，进程仍在后台执行，即使退出最外面的 shell，只要不断网不关机，session 都会在那
</p>


<p>
other-term $ <strong>screen -ls</strong> 列出所有的 session，这个例子中只有一个
</p>


<p>
other-term $ <strong>screen -r</strong> 恢复这个 session
</p>


<p>
other-term $ <strong>screen -d -r</strong> 如果其他终端 attach 到了这个 session，先断开它，再从本终端恢复
</p>



<p>
<strong>C-a S</strong> 开个新窗口，注意是大写 S，小写 s 是发送 C-S，终端会停止滚屏的哦（C-a C-q 恢复）
</p>


<p>
<strong>C-a TAB</strong> 切换到新窗口
</p>


<p>
<strong>C-a 1</strong> 在当前窗口中打开编号为 1 的任务
</p>


<p>
<strong>C-a C-n</strong> 下一个任务
</p>


<p>
<strong>C-a C-p</strong> 上一个任务
</p>



<p>
<strong>C-a C-a</strong> 循环切换任务
</p>


<p>
<strong>C-a ?</strong> 列出帮助信息，记住这个就不怕了
</p>


<p>
所有命令默认都是 C-a 开始，在 bash 中本来这个键本来是跳到行首的，没了这个功能可不太爽，定制的方法是在 ~/.screenrc 中指定，例如指定为后引号 `：
</p>


<pre>
escape ``
</pre>


<p>
这样所有命令都变为 ` 开始，要输入 ` 本身，则要按它两次。
</p>


<p>
再如始终显示状态条，包括窗口 ID 号和名字等信息
</p>


<pre>
hardstatus string '%-Lw%{= BW}%50&gt;%n%f* %t%{-}%+Lw%&lt;'
</pre>



<p>
screen 主页：<a href="http://www.gnu.org/software/screen">http://www.gnu.org/software/screen/</a>
</p>


<p>
<a href="http://www.gnu.org/software/screen"> </a>一个不错的介绍：<a href="http://www.gnu.org/software/screen"></a><a href="http://gentoo-wiki.com/TIP_Using_screen">http://gentoo-wiki.com/TIP_Using_screen</a>

</p>

