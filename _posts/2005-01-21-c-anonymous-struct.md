---
layout: post
title: C anonymous struct
category: tech
tags: [C]
---
{% include JB/setup %}

用 gdb 调试 OpenSSL 代码发现一个 `ASN1_VALUE` 类型的变量无法察看它的定义

    (gdb) pt ptmpval
    type = struct ASN1_VALUE_st {
        &lt;incomplete&gt;
    } *

察看源码只能找到下面这样一句：

    typedef struct ASN1_VALUE_st ASN1_VALUE;

却找不到 `ASN1_VALUE_st` 的定义，ctags 没用，上一次遇到这样的问题是宏名用 ## 拼
起来的，这一次，我也考虑了这种情况，用多种组合 grep，但仍是一无所获。

走投无路之下，想到，会不会本来就不存在这样的结构？察看了源码，用到这个类型的地
方都是用这种指针，对它内容的引用都是在别的类型之间转换的。

这样也可以？试验了一下：

    ~/tmp $ cat tmp.c
    typedef struct unknown_st UNKNOWN;

    int main()
    {
        UNKNOWN * u;
        int arr[10];

        u = (UNKNOWN *)arr;

        return 0;
    }
    ~/tmp $ gcc -Wall tmp.c
    ~/tmp $

编译没错，出乎意料，看来我对 C 的理解还是不够深。但也证明了我找不到
`ASN1_VALUE_st` 的定义是正常的，因为根本就不需要有一个实际的定义，程序中没有需
要知道它的具体形式的地方，都是把这种指针转来转去的操作。也就是说这个
`ASN1_VALUE_st` 是一种没有实际定义的结构，`ASN1_VALUE_st *` 就相当于 `void *`，
OpenSSL中这么写只是为了让指针有意义一点，到时候是要转换为已知的某种结构的指针的
。但是，可读性真的变好了吗？！不禁越发崇拜 OpenSSL 的作者了。
