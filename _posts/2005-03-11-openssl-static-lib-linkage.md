---
layout: post
title: openssl 静态库连接顺序
tags: [gcc, openssl]
---
{% include setup %}

在 apps/ 目录下连接 openssl ：

    gcc -o openssl  {object files in apps/}  ../libssl.a ../libcrypto.a -ldl

libssl 一定要在 libcrypto 前面，自己连接改过的代码时，无意中把 libssl 放到
libcrypto 后面去了，结果竟然报一堆错误，折腾好久才发现这个连接顺序有玄机。而且
三部分的顺序还都不能改变，玄机是什么呢？为什么顺序变了就不行？明天找人问问。
