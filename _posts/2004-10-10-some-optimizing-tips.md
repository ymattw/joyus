---
layout: post
title: Some optimizing tips
category:
tags: []
---
{% include JB/setup %}

1. unrolling loops
2. reducing if-statements<br>
e.g. if (var &lt; v) cnt++;<br>
can be replaced by:<br>
cnt = cnt + (var &lt; v);
3. use &amp; and | instead of &amp;&amp; and ||<br>
e.g. if (a == 7 &amp;&amp; b == 4)<br>
cause a branch because condion can only be tested when the first one is true (ANSI C)<br>
if ((a == 7) &amp; (b == 4))<br>
Now both conditions can be evaluted in parallel.<br>
4. use marcos bring less overhead than function inline
