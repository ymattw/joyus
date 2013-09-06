---
layout: post
title: 小心你的 Email 暴露在 news server 上
category:
tags: []
---
{% include JB/setup %}

<p>
我从不在 public 的网络上以带 @ 的形式写自己的邮件地址，我的地址也不是词典里的单词，但最近天天都收到垃圾邮件，这很奇怪， google 了一下，居然真的在一个新闻组的 archieve 网站 news.hping.org 上发现了自己的地址，再仔细一看，是曾经在 google 讨论组里面发的帖子，但是在那里明明是需要验证码才能看到真实地址的呀？追根溯源下去，原来那个 comp.lang.python 是公开的 news 服务器，google 讨论组只不过是一个该服务器的一个接口而已，有很多网站都从该新闻服务器镜像，包括 yahoo，只有 news.hping.org 是没有对 Email 地址做处理的。我不甘心自己的邮箱就这样天天进垃圾，在网站找到 news.hping.org 的维护者，给他发了邮件。想不到临下班的时候收到回复，承认是他忽略了这个问题，现在已经作了处理，真够爽快的！
</p>


<p>
循着他的签名档看到他的资料让我大吃一惊，原来<a href="http://www.invece.org/">此人</a>竟是大名鼎鼎的 hping 的作者，意大利人，绝对是典型的黑客长相:-)
</p>

<p style="text-align: center"><img src="http://www.invece.org/antirez3s.jpg" />
</p>


<p>
他的技术背景也让人只能望其项背，早知道是这样的大牛，我怕是不敢给他发邮件了:-P

</p>

