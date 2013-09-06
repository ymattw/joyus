---
layout: post
title: 循序渐进替换 libcrypto.a
category:
tags: []
---
{% include JB/setup %}

<p>
将编译过的 openssl-0.9.7e/apps/*.o 打包成 libappobjs.a，将 libcrypto.a 和 libappobjs.a 放入自己的目录，libssl 就用最新安装到 /usr/lib/ 中的库就行了，新改和新增的源文件编译成 .o 之后添加或者替换到 libcrypto.a 中去，链结就很简单了：
</p>



<pre>

CRYPTO_OBJS = ../crypto/x509v3/ipextn.o ../crypto/x509v3/v3_lib.o               ../crypto/x509v3/v3_prn.o

lib/libcrypto.a : $(CRYPTO_OBJS)
&#9;ar r lib/libcrypto.a $^

openssl : lib/libcrypto.a lib/libappobjs.a
&#9;$(CC) -o $@ lib/libappobjs.a lib/libcrypto.a -lssl -ldl

</pre>

