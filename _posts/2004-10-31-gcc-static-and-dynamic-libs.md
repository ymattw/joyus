---
layout: post
title: gcc 生成静态库和动态库的方法
category:
tags: []
---
{% include JB/setup %}

总是想不起来，这次自己整理一下。

hello.c

    #include <stdio.h>

    extern void hello()
    {
        printf("hello world.\n");
    }

tool.c

    #include <stdio.h>

    extern void tool()
    {
        printf("i am tool().\n");
    }

还需要一个头文件声明导出的函数：

test.h

    extern void hello();
    extern void tool();

### 生成静态库的方法

    $ gcc -c hello.c
    $ gcc -c tool.c
    $ ar rc libtest.a hello.o tool.o

用 ranlib libtest.a 可生成索引, 用 nm libtest.a
来看里面的目标文件和导出函数（带 T 标记）。

### 生成动态库的方法

    $ gcc -c hello.c
    $ gcc -c tool.c
    $ gcc -o libtest.so -shared -fPIC hello.o tool.o

`-fPIC` 表示编译为位置独立的代码，不用此选项的话编译后的代码是位置相关的所以动
态载入时是通过代码拷贝的方式来满足不同进程需要，而不能达到真正代码段共享的目的
。可用nm libtest.so 来看里面导出的函数（带 T 标记）。

用动态库的好处是：更新了动态库之后链结它的程序不用重新编译。

### 用法

假设有个 main() 在 main.c 中：

    /* main.c */
    #include "test.h"

    int main()
    {
        hello();
        tool();
        return 0;
    }

静态库:

    $ gcc -c main.o
    $ gcc -o main main.o libtest.a
    $ ./main

动态库：

    $ gcc -o main main.o -L. -ltest
    $ LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./main
    $ LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ldd main

可以看到 main 程序所链结的动态库。把 libtest.so 放到 /etc/ld.so.conf 中列出的目
录下就可以不用先指定环境变量，注意先 ldconfig 刷新系统动态库的缓存

TODO: 还有一种 ld -rpath dir 这样的方法可避免设定环境变量
