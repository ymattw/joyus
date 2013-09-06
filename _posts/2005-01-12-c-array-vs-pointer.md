---
layout: post
title: C 中一个经典错误·数组与指针的区别
category: tech
tags: []
---
{% include JB/setup %}

extn.c

    char s[] = "Hello world.";

main.c

    extern char *s;   /* XXX */

    int main()
    {
        s[0] = 'A';
        return 0;
    }

Now run the program get core dumped.

    $ gcc -c main.c extn.c
    $ gcc -o main main.o extn.o
    $ ./main
    Segmentation fault (core dumped)

这是 C 中容易犯的一个经典错误。正确的应该是在 main.c 中声明 s 为
`extern char s[];`

把修改前后的 main.c 分别 gcc -S 编译成汇编，一比较就清楚了：

    $ diff main.s.old main.s
    12,13c12
    <       movb    $65, s

可见：错误版本中 s 声明为指针后，执行时先要取到 s 这个符号本身的地址，从该地
址处取出 s 代表的地址放到 eax 中，然后往这个地址存 'A'，但是，s 在 extn.o 中作
为数组存放在 .text 段中，这个符号的地址就是 extn.o 中那个数组的地址，该处存放
的东西是 "Hello world."，取一个指针出来就是四个字节'H', 'e', 'l', 'l'代表的
long，在 little-endian 平台上它是 0x6c6c6548，再往这个地址存字符 'A'，就 core
dump 了。而在正确版本中，已经知道它是数组了，就只会往 s 这个符号本身的地址处存
放了。这便是数组与指针的区别。

总结：访问指针时，先要找到指针变量本身的地址，从该地址处再取到存放的指针值，然
后再对指针指向的对象进行访问，是间接访问。访问数组则是先找数组变量 符号代表的
地址，对这个地址指向的对象进行访问，是直接访问。
