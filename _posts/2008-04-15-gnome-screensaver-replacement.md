---
layout: post
title: gnome-screensaver replacement
category: tech
tags: [linux]
---
{% include JB/setup %}

My favorite screensaver is "nose man" from
[xlockmore](http://www.tux.org/~bagleyd/xlockmore.html), but gnome screensaver
seems no way to use it.  I don't want to spend time to hack gnome-screensaver's
configuration, instead, I found this alternative screen lock program -
xautolock.  Xautolock can lock the screen use any lock program, so it's
possible to invoke xlockmore's binary "xlock" with whatever mode you like.

Xautolock also has a cool feature, it can lock the screen when the
mouse is over a screen corner with a customized delay.

To install:

    $ sudo apt-get install xlockmore xautolock

Here are the arguments to call xautolock, logged here to prevent read
the long man page again.

    # replace gnome-screensaver, lock screen if idle for 5 minutes, or
    # mouse over a corner for 3 seconds
    #
    msg="All money go my home :-)"
    /usr/bin/xautolock \
        -corners ++++ -cornerdelay 3 -cornerredelay 30 \
        -time 5 -locker "/usr/bin/xlock -mode nose -message '$msg'" &

Since it's an X11 program, it could be started only after a user logged in
to X.  To start it automatically for gnome X manager, use session manager
tool to add an entry is a handy way, "System" -&gt; "Preference" -&gt;
"Sessions".

Also, you can create a shortcut point to command `xautolock -locknow` to lock
the screen immediately.

Goodbye, gnome-screensaver.

    $ killall gnome-screensaver
    $ sudo apt-get remove gnome-screensaver
