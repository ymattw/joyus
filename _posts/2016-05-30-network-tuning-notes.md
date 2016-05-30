---
layout: post
title: Network tuning notes
tags: [linux, kernel, networking]
---

Tune the kernel parameters

- [Shadowsocks advanced config](https://shadowsocks.org/en/config/advanced.html)
- [Post from vultr.com](https://www.vultr.com/docs/how-to-setup-tcp-optimization-on-linux)
- [Kernel document: ip-sysctl.txt](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)

_**Note**_! Kernel of linode VPS (ubuntu) does not support
`tcp_congestion_control` algorithm
[hybla](https://en.wikipedia.org/wiki/TCP_congestion_control#TCP_Hybla) (which
is good for high latency network environments) by default, you need to compile
yourself.

Tried google search how to build `tcp_hybla.ko` on linode manually, found lots
of posts related to that, but all Chinese posts look very similar, I believe
most of "authors" just copy and paste someone's original work without leaving
any credit, shame on you!! (And feeling sad about this hopeless country.)

Turned on "English posts only" and got a nice one (below).

- [Compile kernel module on Linode Debian
  VPS](http://blog.anthonywong.net/2015/01/07/compile-kernel-module-on-linode-debian-vps/)
