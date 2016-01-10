---
layout: post
title: 给 vimpress 增加 slug 支持，以及一点改进
tags: [opensource]
---
{% include JB/setup %}

如果能发布成功，证明我对 [vimpress](http://friggeri.net/blog/2007/07/13/vimpress)
的修改是 OK 的。

修改有两条：

<ul>
  <li>增加对 post slug 的支持</li>
  <li>BlogList 可带参数指定取最近几篇，缺省则只列出最近 10 篇，给 0 才取所有的</li>
</ul>

patch 在这里 [vimpress-0.9-slug-and-listcount.patch](/pub/vimpress-0.9-slug-and-listcount.patch)。
xmlrpc好像没有关于 trackback 的规范，要不就是 python 的 xmlrpclib 不支持，反正
我在post 字典里面没有看到这个字段。

其实改进的地方还有很多，感觉离作者自定的“0.9”还差得远呢。
