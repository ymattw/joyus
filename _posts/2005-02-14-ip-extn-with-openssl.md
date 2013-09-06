---
layout: post
title: 终于把IP地址扩展的编解码弄出来了
category:
tags: []
---
{% include JB/setup %}

<p>
   经过一番折腾，总算把IP地址扩展的编解码弄出来了。OpenSSL的ASN.1库确实强大，任意新类型，要实现编解码的步骤是：
</p>


<ol>
<li>写一个头文件按照其 ASN.1 定义写出数据结构的定义</li>
<li>头文件中用一下它的 DECLARE_ASN1_FUNCTIONS 宏声明原型</li>
<li>写一个实现文件，用 ASN1_SEQUENCE、ASN1_CHOICE 等定义好结构的模板，都是与其 ASN.1 定义一一对应的。这里面还没有搞得太清 楚，得读一下头文件并参照一些例子</li>
<li>实现文件中用宏 IMPLEMENT_ASN1_FUNCTIONS 实现 new、free、d2i 和 i2d 的功能</li>
</ol>



<p>
然后便可以使用对应的i2d和d2i函数进行编解码了。
</p>



<p>
注意DECLARE_ASN1_FUNCTIONS和IMPLEMENT_ASN1_FUNCTIONS是对应的，还有一个 DECLARE_ASN1_FUNCTIONS_const和IMPLEMENT_ASN1_FUNCTIONS_const是对应的，区别是后者声明的 d2i和i2d里面有适宜的const修饰，这当然更合理。然而这里有个不大不小的问题：DECLARE_ASN1_FUNCTIONS_const漏掉 了d2i和i2d的声明，-Wall编译时就看看出来警告没有函数原型。或许可以mail给openssl开发人员。
</p>



<pre>
DECLARE_ASN1_FUNCTIONS
    new, free
    d2i, i2d

IMPLEMENT_ASN1_FUNCTIONS
    encode: d2i, i2d
    alloc: new, free

DECLARE_ASN1_FUNCTIONS_const
    new, free
    /* 就是这里，少了一句 DECLARE_ASN1_ENCODE_FUNCTIONS_const */

IMPLEMENT_ASN1_FUNCTIONS_const
    const encode: d2i, i2d
    alloc: new, free
</pre>
