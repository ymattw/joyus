---
layout: post
title: mini openssl command line howto
category:
tags: []
---
{% include JB/setup %}

    0. install openssl

    tar xzvf openssl-0.9.7e.tar.gz
    cd openssl-0.9.7e
    ./config --prefix=$HOME
    make
    make test
    make install
    export PATH=$HOME/bin:$PATH

    1. prepare CA path structure

    cd ~/ssl
    mkdir FakeCA
    cd FakeCA
    mkdir certs
    mkdir newcerts
    mkdir crl
    mkdir private
    touch index.txt
    echo 01 &gt; serial
    vi ../openssl.cnf  # change demoCA, policy, filename of key and root cert
                            # note: you can use ./demoCA of course ...

    2. create key and root cert

    openssl genrsa -out private/ca.key -des3 2048
    openssl req -new -x509 -days 3650 -out ca.crt -key private/ca.key -notext

    3. sign sub ca cert

    cd ~/tmp
    openssl req -new -keyout ca2.key -out ca2.req -days 3650
    openssl ca -days 3650 -notext -extensions v3_ca -out ca2.crt -infiles ca2.req
    rm ca2.req

    4. use sub ca key to sign web server cert

    openssl req -new -keyout waking.key -out waking.req -days 3650
    openssl ca -days 3650 -notext -keyfile ca2.key -cert ca2.crt -out waking.crt
    -infiles waking.req
    rm waking.req
    #now waking.key and waking.crt can be use in apache

    other tips ============

    o test cert use s_server

    openssl s_server -accept 8443 -key my.key -cert my.crt -www
    use browser to access https://server:8443

    o test https web site use s_client (retrive remote cert)

    openssl s_client -connect host:port

    o revoke

    openssl ca -revoke newcerts/01.pem
    openssl ca -gencrl -out crl/fakeca.crl

    o password

    openssl passwd MySecret #generate crypt-style password, eg. used in cvs
    N8eFL9uEhdHQU
    openssl passwd MySecret -salt N8  #salt is the first 2 letter
    N8eFL9uEhdHQU
