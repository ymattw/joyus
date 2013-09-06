---
layout: post
title: openssl ca -extfile 参数
category:
tags: []
---
{% include JB/setup %}

<p>
可以指定读取扩展的文件名和段名：
</p>



<pre>

-extfile filename
-extfile filename -extensions section

</pre>



<p>
 如果不带 -extensions section 就取 [ default ] 段。
</p>



<p>
下面是包含典型的 CA 证书扩展和普通证书扩展对应的 ext 文件格式：
</p>



<pre>

[ ca ]

# Extensions for a typical CA

# PKIX recommendation.

subjectKeyIdentifier=hash

authorityKeyIdentifier=keyid:always,issuer:always

basicConstraints = CA:true

# total blocks: 2
# block 0:
#     addressFamily: IPv4, unicast
#     ipAddreessChoice: NULL (inherit from issuer)
# block 1:
#     addressFamily: IPv6
#     ipAddreessChoice: NULL (inherit from issuer)
sbqp-ipAddrBlock = critical,DER:30:11:30:07:04:03:00:01:01:05:...

[ user ]

basicConstraints = CA:FALSE

nsComment = "OpenSSL Generated Certificate"

subjectKeyIdentifier = hash

authorityKeyIdentifier = keyid,issuer:always
# 拿新写的 ipextn-gen 生成
sbqp-ipAddrBlock = critical,DER:30:49:30:1A:04:03:00:01:01:30:...

</pre>



<p>
一个完整的用法例子：
</p>



<pre>

$ openssl ca -config democa.conf -days 7300 -notext &#92;
        -keyfile private/subca.key -cert subca.pem  &#92;
        -extfile ipextn.ext -extensions user        &#92;
        -out ipextn.pem -infiles ipextn.req

</pre>

