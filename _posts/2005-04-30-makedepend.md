---
layout: post
title: makedepend
category:
tags: []
---
{% include JB/setup %}

    depend:
    	makedepend -Y -- $(CFLAGS) -- $(SOURCES)

用 -Y 避免搜索 /usr/include，这样不会产生类似 _foo.c: /usr/include/stdio.h_
这样浪费编译时间的规则，但同时也会报成堆的找不到头文件的错误。如果重定向stderr
，又担心漏掉有用的信息，唉，难办啊，大概只有改它的源码了。其实在 openssl 里面也
有这问题，它是自己编写的工具，不处理 /usr/include，但那个 domd 不太完善，试了一
下有些情况会把 Makefile 弄成 0 字节文件 :(
