---
layout: post
title: 控诉 vpsempire 讹我 6.95 美元
category:
tags: []
---
{% include JB/setup %}

<p>
现在来说说我为什么又换 VPS 了，你想象不到我在 <a href="http:/www.vpsempire.com">vpsempire</a> 遇到什么了。因为时区差异具体时间懒得整理了，就按先后顺序说一下好了。
</p>



<ol>

    <li>
<p>
6 月 20 号我在 vpsempire 购买了 VPS-01，搭起来之后才发现<a href="http://joyus.org/blog/2008/06/vpsempire.html">丢包严重</a>，当然我的家用网络并没有什么问题，上其他网站都好好的。
</p>
</li>
        
    <li>
<p>
于是发 ticket 反映情况，幻想他们能解决。等了两天没见回复，通过 online chat，他们答复这个是我自己的问题，没有其他客户反映同样问题。
</p>
</li>
        
    <li>
<p>
实在是无法忍受 ssh 终端敲一个字母要等两三秒，见解决无望，在大约第 7 天的时候我通过 ticket 系统申请退款，遭到拒绝，理由是 1) 连接问题是我自己的问题；2) 购买之前我咨询过并拿到测试 IP 进行了测试。
<center><a title="点击看大图" href="/image/2008/vpsempire-refuse-to-refund.jpg"><img src="/image/2008/vpsempire-refuse-to-refund.jpg" width="320"></a></center>
    
</p>

    
<p>
关于理由 2 他说的是事实，但是当我付完钱拿到的 IP 根本不是他说的地址段。
<center><a title="点击看大图" href="/image/2008/chat-with-vpsempire.jpg"><img src="/image/2008/chat-with-vpsempire.jpg" width="320"></a></center>
</p>

    
<p>
请看，他说的 IP 是 75.127.71.x，事实是我拿到的 IP 是 208.53.169.227（我把子域名 vpsempire.joyus.org 指向了这个 IP 以防自己忘记）。
</p>
</li>

    <li>
<p>
我在 ticket 里陈述了这个问题，再次要求退款，这次他们没再理会。
</p>
</li>

    <li>
<p>
我到 WHT <a href="http://www.webhostingtalk.com/showpost.php?p=5181180&postcount=21">在他们的广告下跟了个帖</a>说他们的 14 day money back 是扯谎，根本没有保障。
</p>
</li>

    <li>
<p>
邪恶嘴脸露出来了... 第二天打开邮箱一看，我的帐户被停了，并且拒绝退款说我有“unlawful”行为。
<center><a title="点击看大图" href="/image/2008/vpsempire-terminate-my-account.jpg"><img src="/image/2008/vpsempire-terminate-my-account.jpg" width="320"></a></center>
</p>
</li>

<li>
<p>
其客服在 WHT <a href="http://www.webhostingtalk.com/showpost.php?p=5182464&postcount=23">跟帖</a>，说丢包是因为我疯狂使用流量，在 3 天内用掉了 210gb，并且取消了我的帐户，因为我存放了 illegal warez（恶意软件），并且不退款。最搞笑的是居然说“We have offered you a refund and you declined it twice.”
</p>
</li>

<li>
<p>
我继续<a href="http://www.webhostingtalk.com/showpost.php?p=5183291&postcount=24">跟帖</a>，贴出了我保留的邮件和 ticket 记录，并且在后面付上了截图证明了丢包情况以及我的带宽根本不可能在 3 天用掉 270gb（这可是要 800KB/s 以上的带宽才行啊）。
<center><a title="点击看大图" href="/image/2008/bw2vpsempire.jpg"><img src="/image/2008/bw2vpsempire.jpg" width="320"></a></center>
</p>
</li>

<li>
<p>
客服再次跟帖，这次说我占用了太多的 CPU 和内存资源，“不幸的是”他们没有保留 MRTG 流量图，并且给我加了条罪状，还带了数字，“Found 4 Counts of Warez (Hosted) and 2 NULLED softwares”。我专门查了下，nulled software 就是 crack 软件。其实除了 wordpress 和 unixbench-wht，其他软件的都是 apt-get install 安装的，绝对不会有什么恶意软件，连 mp3、电子书都没放过一个。运行 unixbench-wht 的时候可能有 10 来分钟 CPU 负载较高，但是跟帖中有人说他也运行过这个，没有收到哪怕是一条警告。
</p>
</li>


</ol>



<p>
欲加之罪，何患无辞啊。从前我是个遵纪守法的好网民，现在我的罪状有：
</p>


<ul>

    <li>unlawful activity</li>
    <li>存放 illegal warez</li>
    <li>疯狂使用带宽，used 210gb in 3 days</li>
    <li>疯狂占用 CPU 和内存资源</li>
    <li>使用 NULLED softwares</li>

</ul>



<p>
幸好我是用 paypal 付的款，幸好只付了一个月。本文中第 2 张图还未在 WHT 张贴，如果客服敢继续血口喷人，我会奉陪到底。有必要的话会翻成英文在各大网站主机论坛张贴。
</p>

