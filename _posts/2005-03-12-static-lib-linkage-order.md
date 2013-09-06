---
layout: post
title: 关于静态库的连接顺序
category:
tags: []
---
{% include JB/setup %}

解决了昨天的疑问，顺序的确是至关重要的。

假设 main.c 中有 main()，依次调用 test.c 中的 test() 和 quit.c 中的 quit()。将
他们都编译成 .o，再把 test.o 用 ar 打包成 libtest.a，把quit.o 打包成 libquit.a
，这里为了简单，只用一个目标文件做静态库，但已经足够能说明问题了。

    /* main.c */
    void test();
    void quit();
    int main() { test(); quit(); return 0; }

    /* test.c */
    void test() { }

    /* quit.c */
    void quit() { }

先编译：

    $ gcc -c main.c test.c quit.c

可以看到用目标文件的时候顺序是没有关系的，还有三种组合有兴趣自己试：

    $ gcc -o main test.o quit.o main.o
    $ gcc -o main quit.o test.o main.o
    $ gcc -o main main.o quit.o test.o

打包：

    $ ar rc libtest.a test.o
    $ ar rc libquit.a quit.o

main.o 在最前面则没有问题：

    $ gcc -o main main.o libtest.a libquit.a

其他情况就不行了：

    $ gcc -o main libtest.a main.o libquit.a
    main.o(.text+0x11): In function `main':
    : undefined reference to `test'
    collect2: ld returned 1 exit status

    $ gcc -o main libquit.a main.o libtest.a
    main.o(.text+0x16): In function `main':
    : undefined reference to `quit'
    collect2: ld returned 1 exit status

    $ gcc -o main libquit.a libtest.a main.o
    main.o(.text+0x11): In function `main':
    : undefined reference to `test'
    main.o(.text+0x16): In function `main':
    : undefined reference to `quit'
    collect2: ld returned 1 exit status

原因是 gcc 连接静态库比较奇怪（不知道为什么），已扫描过的符号表中没有谁引用过当
前库中的函数的话，就直接把该函数对应的信息丢掉了，就是说，当前处理的静态库扫 描
完了之后，后续的目标代码再来调用刚才库中的函数就找不到了。比如刚才第一种组合，
libtest.a 扫描过之后，因为前面没有引用 test() 的，就把 test() 符号信息丢弃，之
后连接到 main.o 就找不到 test()了；第二种组合类似；第三种组合 main.o 在最后，于
是前面库中的 test() 和 quit() 就都找不到了。

因此昨天连接 openssl 的问题便是 libssl 引用了 libcrypto 中的函数，反之则不是。
所以 libssl 一定要位于 libcrypto 前面。
