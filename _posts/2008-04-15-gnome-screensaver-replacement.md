---
layout: post
title: gnome-screensaver replacement
category:
tags: []
---
{% include JB/setup %}

<p>
My favorite screensaver is "nose man" from <a
href="http://www.tux.org/~bagleyd/xlockmore.html">xlockmore</a>, but
gnome screensaver seems no way to use it.  I don't want to spend time
to hack gnome-screensaver's configuration, instead, I found this
alternative screen lock program - xautolock.  Xautolock can lock the
screen use any lock program, so it's possible to invoke xlockmore's
binary "xlock" with whatever mode you like.
</p>



<p>
Xautolock also has a cool feature, it can lock the screen when the
mouse is over a screen corner with a customized delay.
</p>



<p>
To install:
</p>



<p>
<code>$ sudo apt-get install xlockmore xautolock</code>
</p>



<p>
Here are the arguments to call xautolock, logged here to prevent read
the long man page again.
</p>



<pre>

# replace gnome-screensaver, lock screen if idle for 5 minutes, or
# mouse over a corner for 3 seconds
#
msg="All money go my home :-)"
/usr/bin/xautolock \
    -corners ++++ -cornerdelay 3 -cornerredelay 30 \
    -time 5 -locker "/usr/bin/xlock -mode nose -message '$msg'" &amp;

</pre>



<p>
<del>Put this to <code>/etc/rc.local</code> (for ubuntu), it will be
executed by <code>/etc/rc2.d/S99rc.local</code> on boot up.</del>
Since it's an X11 program, it could be started only after a user logged in
to X.  To start it automatically for gnome X manager, use session manager
tool to add an entry is a handy way, "System" -&gt; "Preference" -&gt;
"Sessions".
</p>



<p>
Also, you can create a shortcut point to command <code>xautolock
-locknow</code> to lock the screen immediately.
</p>



<p>
Goodbye, gnome-screensaver.
</p>



<pre>

$ killall gnome-screensaver
$ sudo apt-get remove gnome-screensaver

</pre>

