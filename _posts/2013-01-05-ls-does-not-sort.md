---
layout: post
title: ls 不按字符串顺序排序？
category:
tags: []
---
{% include JB/setup %}

在 VPS（系统为 Ubuntu 11.04）ls 总感觉列出的内容很乱，仔细一看原来是列出的内容没有正常排序：

    ~/ws/home $ ls -1
    404.md
    blog
    CNAME
    _config.yml
    css
    image
    _includes
    index.html
    js
    _layouts
    _posts
    pub
    README.md
    robots.txt
    _site

ASC 码表里大写字母是在小写字母前面的，`CNAME` 应该排在 `blog` 前面，还有那些下划线开头的没有挨着明显不对。

尝试用 sort，居然得到一样的结果，难道 sort 也出问题了？这可是天天用的命令啊。。

    ~/ws/home $ ls | sort
    404.md
    blog
    CNAME
    _config.yml
    css
    image
    _includes
    index.html
    js
    _layouts
    _posts
    pub
    README.md
    robots.txt
    _site

不信邪，换一个 RHEL 5.4 发现又是正常的。一时间没有头绪，感觉自己像一个白痴正在被愚弄。。

仔细研读了一会 ls 和 sort 的 man page，终于发现线索，在 sort(1) 中有这么一段：

> ***  WARNING  *** The locale specified by the environment affects sort order.
> Set LC_ALL=C to get the traditional sort order that uses native byte values.

我系统的 locale 是 en_US.utf8，接下去 google 一番终于在万能的 StackOverflow 找到了权威解答：

[Sort does not sort in normal order!](http://www.gnu.org/software/coreutils/faq/#Sort-does-not-sort-in-normal-order_0021)

问题知道了，修正我的 `.bashrc` 解决问题：

    export LC_COLLATE=C

ls 的输出终于正常了：

    ~/ws/home $ ls -1
    404.md
    CNAME
    README.md
    _config.yml
    _includes/
    _layouts/
    _posts/
    _site/
    blog/
    css/
    image/
    index.html
    js/
    pub/
    robots.txt
