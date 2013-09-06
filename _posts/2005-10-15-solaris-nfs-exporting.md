---
layout: post
title: Solaris nfs exporting
category:
tags: []
---
{% include JB/setup %}

1. Prepare dir for sharing, (assume "ws" for group member, "tmp" for everyone):


<pre>
cd /export/home
mkdir ws tmp
chown matt:staff ws
chown root:root tmp
chmod 750 ws
chmod 777 tmp
chmod +t tmp
</pre>

2. edit /etc/dfs/dfstab, append:


<pre>
share -F nfs -o rw -d "workspace" /export/home/ws
share -F nfs -o rw -d "tmp" /export/home/tmp
</pre>

3. use command <i>shareall</i> and <i>unshareall</i> to share/unshare all resources mentioned in /etc/dfs/dfstab, use command <i>share </i>to show current sharing resources
