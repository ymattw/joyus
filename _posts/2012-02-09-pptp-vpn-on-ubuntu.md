---
layout: post
title: Ubuntu 11.04 上搭建 pptp vpn
category:
tags: []
---
{% include JB/setup %}

刚迁移到新 VPS 上（提供商 [PhotonVPS](http://photonvps.com/)），系统是 Ubuntu
11.04，用 pptpd 搭了个翻墙用的 vpn，过程记录一下备忘。

Step 1. 装包 apt-get install pptpd

Step 2. 配置 /etc/pptpd.conf，假定最多分配到 .15

    option /etc/ppp/pptpd-options
    localip 192.168.128.1
    remoteip 192.168.128.2-15

Step 3. 配置 /etc/ppp/pptpd-options，这里用的 DNS 是[OpenDNS](http://www.opendns.com)

    name pptpd
    refuse-pap
    refuse-chap
    refuse-mschap
    require-mschap-v2
    require-mppe-128
    proxyarp
    lock
    nobsdcomp
    novj
    novjccomp
    nologfd
    ms-dns 208.67.222.222
    ms-dns 208.67.220.220
    logfile /var/log/pptpd.log
    nodefaultroute

Step 4. 配置 /etc/ppp/chap-secrets（chap 这个词是英式英语，相当于 pal、buddy）
，其中 server 这一列要和 /etc/ppp/pptpd-options 里的 name 一致。每用户一行

    # Secrets for authentication using CHAP
    # client     server  secret     IP addresses
    user1        pptpd   secret1    *

Step 5. 允许 ip 转发

    sysctl -w net.ipv4.ip_forward=1
    # 或：echo 1 > /proc/sys/net/ipv4/ip_forward 并放入系统启动脚本

Step 6. iptables 配置 nat 规则，并放入系统启动脚本 /etc/rc.local

    /sbin/iptables -t nat -A POSTROUTING -s 192.168.128.0/20 -o eth0 -j MASQUERADE

Step 7. 重启 pptpd

    /etc/init.d/pptpd restart

调试看 /var/log/pptpd.log。
