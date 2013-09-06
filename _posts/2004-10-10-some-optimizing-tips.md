---
layout: post
title: Some optimizing tips
category: tech
tags: []
---
{% include JB/setup %}

* unrolling loops
* reducing if-statements, e.g. `if (var < v) cnt++;` can be replaced by:
  `cnt = cnt + (var < v);`
* use `&` and `|` instead of `&&` and `||`, e.g. `if (a == 7 && b == 4)`
  cause a branch because condion can only be tested when the first one is true
  (ANSI C), but in `if ((a == 7) & (b == 4))` both conditions can be evaluted
  in **parallel**
* use marcos bring less overhead than function inline
