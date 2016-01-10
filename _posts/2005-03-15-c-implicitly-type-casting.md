---
layout: post
title: 不易觉察的类型提升
category: tech
tags: [C]
---
{% include JB/setup %}

    (v4range->max[i] | ~mask) != v4range->max[i]

`max[i]` 和 `mask` 都是 `unsigned char`，mask 为 0xff 取反时发生了类型提升，变
成了一个负的 int 型整数，bitor 之后两边作为 int 来比较，条件判断意外的为真了。
将 `~mask` 前面再加上个 `(unsigned char)` 强制转换才行。要记牢。

    mask &= ~(1 << j);

这里中间其实也发生了类型提升，只不过最后又截断为 unsigned char 了。
