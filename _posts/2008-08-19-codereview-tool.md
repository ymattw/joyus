---
layout: post
title: 玩玩开源
category:
tags: []
---
{% include JB/setup %}

<p>
将以前写的一个<a href="http://code.google.com/p/coderev"> Code Review 小工具</a>放到 Google Code 上了。放上去一是玩玩开源，体验一下 Google Code 的功能，二是发挥它的“萤火之光”。东西是很简单，但是前同事离职创业的时候把这个东东拷回家了（偶然在他的电脑上看到 :-），让我觉得这个小玩意还是有点用的。
</p>



<p>
类似的工具很多，但要么不通用，例如 Sun 有个 <a
href="http://blogs.sun.com/wfiveash/entry/wx_and_you_your_friend">wx
webrev</a> 全套工具很好用，可惜只支持内部的代码管理工具，要不就是太大，例如 <a
href="http://www.review-board.org/">Review Borad</a>，太庞大了。而我这个刚刚好，简单说一下就是提供一个工具可以比较两个文件或者目录，生成各种格式 diff 的静态 html 页面，另有有一个 wrapper 脚本可以在当前 svn 工作目录从还未提交的修改生成代码复查的 web 页面，比原始的 diff -r 或者 svn diff 好读得多，反正用在我们自己项目里面非常方便。
</p>



<p>
增加其他版本控制工具的支持也不难，但是我们现在用 svn，所以我就先不给自己找
麻烦了。其他就看主页 <a href="http://code.google.com/p/coderev">coderev</a> 吧。
</p>



<p>
<b>(Update on Aug 23, 2008)</b> 将版本控制相关的命令抽象了一下，定义了一些 entry point，SVN 和 CVS 的操作放到单独的 lib 里面实现，很像驱动程序了，呵呵。这个设计我自个很满意，写好了之后加个 CVS 支持只花了几分钟，等用到 git 的时候相信也能很快实现。
</p>

