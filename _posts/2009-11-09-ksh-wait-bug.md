---
layout: post
title: A ksh bug on "wait"
tags: [ksh]
---

WTF?

    $ cat kshbug
    { return 0; } &
    evil=$(/bin/true)   # XXX: works fine without this line
    wait $!
    echo $?

    $ ksh kshbug
    127

    $ ksh --version
    version         sh (AT&T Labs Research) 1993-12-28 r

The correct return code should be 0.  Without the line of "eval=$(bin/true)"
everything works fine.  The problem happens only when

1. Execute a **function** or a **clause** in background, and
2. A subshell is invoked between the background execution and the "wait", and
3. An **external** command is executed in the subshell

I googled for a while, there's no ksh bug report so far, workaround could be
use output text for return code check instead.  Note there's a similar
[report for ksh on solaris](http://bugs.opensolaris.org/view_bug.do;jsessionid=8fdaa6bf6882fac8e944c8288f?bug_id=4452579)
but it's not the identical issue.

Pdksh (public domain ksh) doesn't have the problem. (See [another
bug](/2009/03/ksh93-bug.html)).

Couldn't figure out where to report this bug so gave up.

**Update:** this issue doesn't happen on Ubuntu ksh version `sh (AT&T
Research) 93s+ 2008-01-31`.
