---
layout: post
title: Simplest way to monitor disk usage
tags: [cron, shell]
---

Are you using a complex system to monitor disk usage on your servers and
deliver you alarm when usage is high?

Here's my solution - just use cron job.  It checks every 30 minutes and send
you an email when disk usage is greater than 70%.

```
MAILTO=you@example.org
*/30 *  *  *  * root /bin/df -h / /var/opt/gitlab | awk 'int($5) > 70'
```

Leave your comments if you can beat me with a simpler solution? ;-)
