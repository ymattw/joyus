---
layout: post
title: openssl 里的 stack API 的问题
category:
tags: []
---
{% include JB/setup %}

sk_dup() 复制完发现释放了原来的 stack 之后新的 stack 中 data[] 指向的数据变成了
垃圾。查了好久发现它的 sk_dup() 根本不复制 data[] 里面的指针指向的内存（因为根
本不知道该分配多少），只是 memcpy 一下了事：

openssl-0.9.7e/crypto/stack/stack.c

    103 memcpy(ret-&gt;data,sk-&gt;data,sizeof(char *)*sk-&gt;num);

自己修改了一下，写了一个 sk_dup_fn() 函数，要带两个函数指针作参数，一个用于复制
data[i] 中指针指向的内存，另一个用于失败时释放，把上面这条memcpy 改成：

        for (i = 0; i &lt; sk-&gt;num; i++) {
            ret-&gt;data[i] = (*dup_fn)(sk-&gt;data[i]);
            /* avoid null pointer */
            if (NULL == ret-&gt;data[i]) goto err;
        }

        ...

    err:
        if (ret != NULL) sk_pop_free(ret, free_fn);

(嗯，接触 openssl 之后也用上了 goto，哪个说 goto 影响可读性的，我看 openssl 里
面用的都挺好，不用的话又难写又难读 :-)

函数原型：
    STACK *sk_dup_fn(const STACK *sk, char* (*dup_fn)(const char *),
                    void (*free_fn)(void *));

注意，sk_free() 也不是随便用的，它不会释放 data[] 里面指针指向的内存，要用
sk_pop_free() 带一个附加的函数指针做参数。
