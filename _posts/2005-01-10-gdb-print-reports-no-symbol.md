---
layout: post
title: gdb print 时报上下文没有该符号
category:
tags: []
---
{% include JB/setup %}

    (gdb) print foo
    No symbol "foo" in current context.

但实际上函数中的确有这个变量。原因是使用了优化，int或指针之类的变量被放到寄存器
里了，或是没有用的变量优化后不在目标代码中。去掉优 化就好了。

gdb手册里也提到了另一种办法：编译时指定用不同的格式存调试信息：

    > To solve such problems, either recompile without optimizations, or use a
    > different debug info format, if the compiler supports several such
    > formats.  For example, GCC, the GNU C/C++ compiler usually supports the
    > `-gstabs' option. `-gstabs' produces debug info in a format that is
    > superior to formats such as COFF. You may be able to use DWARF2
    > (`-gdwarf-2'), which is also an effective form for debug info. See
    > section `Options for Debugging Your Program or GNU CC' in Using GNU CC,
    > for more information.

但是我试了一下 -gstabs，发现gdb进去后报找不到源码，不爽，懒得每次指定源码查找路
径了，去掉-O3了事。
