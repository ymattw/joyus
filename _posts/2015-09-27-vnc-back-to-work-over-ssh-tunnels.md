---
layout: post
title: VNC back to work over ssh tunnels
tags: [ssh, tunnel, vnc]
---

**Warning**: this post might not be accurate anymore, refer to your system
man pages and online document to fix by yourself.

How it works:

```
.------------------------------------.
| (1)    Workstation at office       |                        .------------.
|                                    | Remote port forwarding |            |
| vncserver :99 -localhost           |<-----------------------|            |
| ssh -fN -R 5999:localhost:5999 vps |                        |            |
'------------------------------------'                        |   VPS in   |
.------------------------------------.                        |   public   |
| (2)    Laptop at home              |                        |  Internet  |
|                                    | Local port forwarding  |            |
| ssh -fN -L 5999:localhost:5999 vps |----------------------->|            |
| vncviewer localhost:5999           |                        '------------'
'------------------------------------'
```

# Server side (Workstation at office)

Install vncserver

```bash
# CentOS
yum install -y tigervnc-server.x86_64 xterm
yum groupinstall -y 'X Window System'
# TODO: install window manager

# Ubuntu
apt-get install -y vncserver xterm
# TODO: install window manager
```

Configure vncserver

```bash
cat > ~/.vnc/xstartup << "EOF"
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/xterm &
exec /etc/X11/xinit/xinitrc
# FIXME
EOF
```

Start the server

```bash
# 1420x810 is the best for a 1440x900 display
vncserver :99 -localhost -geometry 1420x810
vncserver -list
```

Create the remote port forwarding tunnel

```
ssh -fN -R 5999:localhost:5999 vps
```

# Client side (Laptop at home)

Install vncviewer

```bash
wget http://www.tightvnc.com/download/2.7.2/tvnjviewer-2.7.2-bin.zip
unzip -d tvnjviewer-2.7.2 tvnjviewer-2.7.2-bin.zip
```

Start the local port forwarding tunnel

```
ssh -fN -L 5999:localhost:5999 server
```

Start vncviewer and connect to localhost:5999

```
cd tvnjviewer-2.7.2
java -jar tightvnc-jviewer.jar
```

# Security tips

When creating a ssh key pair for tunnel usage only, add `command="/bin/sleep
999d",no-pty` at the beginning of  the public key entry in
`~/.ssh/authorized_keys` on server side.
