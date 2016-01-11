---
layout: post
title: Solaris nfs exporting
tags: [solaris, nfs]
---
{% include setup %}

1. Prepare dir for sharing, (assume "ws" for group member, "tmp" for everyone):

    cd /export/home
    mkdir ws tmp
    chown matt:staff ws
    chown root:root tmp
    chmod 750 ws
    chmod 1777 tmp

2. Edit /etc/dfs/dfstab, append:

    share -F nfs -o rw -d "workspace" /export/home/ws
    share -F nfs -o rw -d "tmp" /export/home/tmp

3. Use command `shareall` and `unshareall` to share/unshare all resources
   mentioned in /etc/dfs/dfstab, use command `share` to show current sharing
   resources
