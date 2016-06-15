---
layout: post
title: Get full access to docker host from inside a privileged container
tags: [docker]
---

You can get full access to docker host from inside a container if it's running
in privileged mode (`docker run --privileged`).

The trick is when a container is running in privileged mode the host's `/dev`
filesystem will be also mounted inside the container.  You just need to figure
out the right device of the host's root filesystem and mount it inside
container then get full access to the host's root filesystem.

You do not need to guess the device file, just look into the output from
command `mount`, the device is the same as where the `/etc/hosts` is mounted
from.

```
# mount | grep /etc/hosts
/dev/dm-0 on /etc/hosts type ext4 (rw,relatime,errors=remount-ro,data=ordered)

# mkdir /tmp/root

# mount /dev/dm-0 /tmp/root
```

Now the docker host's root filesystem is mounted on `/tmp/root`, you can
read and write any files of docker host as root user, and do anything you want,
for example, chroot inside and add an account, or add your ssh public key to
`/root/.ssh/authorized_key` to get remote access to the host.

```
# chroot /tmp/root /bin/bash
```

So be careful with `--privileged` option, you usually do not need this, refer
to [Runtime privilege and Linux
capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)
for how to do fine grain control over the capabilities with `--cap-add` and
`--cap-drop` options instead.
