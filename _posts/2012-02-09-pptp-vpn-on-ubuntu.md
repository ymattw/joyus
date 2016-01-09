---
layout: post
title: Setting up a PPTP VPN server on Ubuntu 11.04
category: tech
tags: [vpn]
---
{% include JB/setup %}

This was a note for setting up a PPTP VPN server on a VPS (Virtual Private
Server) hosted by [PhotonVPS](http://photonvps.com/) (unfortunately they do not
provide VPS service anymore), OS was Ubuntu 11.04, however these notes should
work for newer releases as well.

**Step 1**. Install pptpd package.

```bash
sudo apt-get update
sudo apt-get install pptpd
```

**Step 2**. Configure `/etc/pptpd.conf`, define the IP address range we want to
allocate, here I use .2-15, means allocate up to 14 IP addresses.

```bash
cat << "EOF" | sudo tee /etc/pptpd.conf
option /etc/ppp/pptpd-options
localip 192.168.128.1
remoteip 192.168.128.2-15
EOF
```

**Step 3**. Configure `/etc/ppp/pptpd-options`, here I am using Google provided
public DNS, you can also use [OpenDNS](http://www.opendns.com).

```bash
cat << "EOF" | sudo tee /etc/ppp/pptpd-options
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
ms-dns 8.8.8.8
ms-dns 8.8.4.4
logfile /var/log/pptpd.log
nodefaultroute
EOF
```

**Step 4**. Configure `/etc/ppp/chap-secrets` ("chap" is a British English
terminology, means "pal" or "buddy" in American English).  Here we must make
sure the column of `server` is as the same value of `name` in
`/etc/ppp/pptpd-options`.  One user per line and keep the file secret.

```bash
cat << "EOF" | sudo tee /etc/ppp/chap-secrets
# Secrets for authentication using CHAP
# client     server  secret     IP addresses
user1        pptpd   secret1    *
EOF

sudo chmod 600 /etc/ppp/chap-secrets
```

**Step 5**. Enable IP forwarding iptables rule

```bash
sudo sysctl -w net.ipv4.ip_forward=1
# Or：echo 1 > /proc/sys/net/ipv4/ip_forward and put into /etc/rc.local
```

**Step 6**. Configure a NAT iptables rule, and put into /etc/rc.local so that
to take effect on boot

```bash
sudo /sbin/iptables -t nat -A POSTROUTING -s 192.168.128.0/20 -o eth0 -j MASQUERADE
```

**Step 7**. Now restart pptpd

```bash
sudo /etc/init.d/pptpd restart
```

See `/var/log/pptpd.log` to troubleshoot.
