---
layout: post
title: How to setup a socks5 proxy over stunnel
tags: [socks, proxy, stunnel]
---

**Q: Why stunnel when you can install [shadowsocks](https://shadowsocks.org)?**

A: Our corporation has strict network ACL and only allows HTTP and HTTPS
traffic thru the firewall, shadowsocks does not meet the requirement.  Also
stunnel use SSL cert so it's more secure.

Before you start, you need a VPS, you can use AWS EC2 or similar, free for
1 year.

## Setup dante on server side (Ubuntu)

### Install

```bash
sudo apt-get update
sudo apt-get install -y dante-server
```

### Configure

Just copy the example [danted.conf](/pub/danted.conf) to `/etc/danted.conf`,
nothing to change except (possible) the line of `external:`.

```bash
curl -fsSL joyus.org/pub/danted.conf | sudo tee /etc/danted.conf
```

### Start danted

```
sudo service danted start
```

## Setup stunnel on server side (Ubuntu)

Ref: [tunnel-ssh-over-ssl](https://ubuntu-tutorials.com/2013/11/27/tunnel-ssh-over-ssl/).

### Install stunnel4 on Ubuntu

```bash
sudo apt-get install -y stunnel4
```

### Generate key, pem and config file

```bash
openssl genrsa 1024 > stunnel.key
openssl req -new -key stunnel.key -x509 -days 3650 -out stunnel.crt
cat stunnel.crt stunnel.key > stunnel.pem
sudo mv stunnel.pem /etc/stunnel/

sudo tee /etc/stunnel/stunnel.conf << EOF
pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
# debug = 7
# output = /tmp/stunnel.log

[dante]
accept = 443
connect = 127.0.0.1:1080
EOF
```

### Enable auto start

```bash
sudo sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4

# For chroot
sudo mkdir -p /var/lib/stunnel4/{tmp,etc/stunnel,var/run}
sudo chmod 1777 /var/lib/stunnel4/tmp

sudo service stunnel4 start

netstat -nltp | grep :443
```

## Setup stunnel on client side

### Install

On Ubuntu:

```
sudo apt-get install -y stunnel4
```

On Mac:

```
brew install stunnel
mkdir -p /usr/local/etc/stunnel
```

### Prepare the key, pem and config file

Copy & paste the same `stunnel.pem` from server.

- Put to `/etc/stunnel/stunnel.pem` on ubuntu, or
- Put to `/usr/local/etc/stunnel/stunnel.pem` on Mac
- Change your server IP in the example

```bash
if [[ $(uname -s)) == Darwin ]]; then
    PREFIX="/usr/local"
    SUDO=""
else
    PREFIX=""
    SUDO="sudo"
fi

$SUDO mkdir -p $PREFIX/var/run

$SUDO tee $PREFIX/etc/stunnel/stunnel.conf << EOF
client = yes
pid = $PREFIX/var/run/stunnel.pid
cert = $PREFIX/etc/stunnel/stunnel.pem
#debug = 7
#output = /tmp/stunnel.log

[dante]
accept = 127.0.0.1:1080
connect = my.server.ip:443
EOF
```

### Start stunnel[4]

- On ubuntu: `sudo service stunnel4 start`
- On Mac: `/usr/local/bin/stunnel`

## Use the proxy

Use `localhost:1080` as socks5 proxy, for Chrome browser, suggest to install
the `SwitchyOmega` extension.

To ssh over the proxy, put this (example) in your `~/.ssh/config`:

```
Host my.server
    Hostname my.server.ip
    Port 2200
    User ubuntu
    ProxyCommand /usr/bin/nc -X 5 -x localhost:1080 %h %p
```

To git clone/fetch/push over the proxy, use

```
HTTPS_PROXY=socks://localhost:1080 git clone ...
```
