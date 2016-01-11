---
layout: post
title: Macros in openssl source code
tags: [C, gcc]
---
{% include setup %}

你看到代码中某个地方用了一个Marco，想找它的原型，你发现ctags帮不上忙，grep -r
也一无所获，想得通怎么回事吗？

crypto/pem/pem.h

    #define PEM_STRING_X509_TRUSTED "TRUSTED CERTIFICATE"
    
    #define IMPLEMENT_PEM_rw(name, type, str, asn1)       \
        IMPLEMENT_PEM_read(name, type, str, asn1)         \
        IMPLEMENT_PEM_write(name, type, str, asn1)
    
    #define IMPLEMENT_PEM_read(name, type, str, asn1)     \
        IMPLEMENT_PEM_read_bio(name, type, str, asn1)     \
        IMPLEMENT_PEM_read_fp(name, type, str, asn1)
    
    #define IMPLEMENT_PEM_write(name, type, str, asn1)     
        IMPLEMENT_PEM_write_bio(name, type, str, asn1)    \
        IMPLEMENT_PEM_write_fp(name, type, str, asn1)
    
    #define IMPLEMENT_PEM_read_bio(name, type, str, asn1) \
        type *PEM_read_bio_##name(BIO *bp, type **x, pem_password_cb *cb, void *u) \
        { return((type *)PEM_ASN1_read_bio((char *(*)())d2i_##asn1, str,bp,        \
             (char **)x,cb,u)); }

openssl-0.9.7e/crypto/pem/pem\_xaux.c:68:

    IMPLEMENT_PEM_rw(X509_AUX, X509, PEM_STRING_X509_TRUSTED, X509_AUX)

Now this marco is expanded to 4 functions:

    X509 * PEM_read_bio_X509_AUX(BIO *bp, X509 **x, pem_password_cb *cb, void *u)
    {
        return (X509 *)PEM_ASN1_read_bio((char *(*)())d2i_X509_AUX,
                "TRUSTED CERTIFICATE", bp, (char **)x, cb, u);
    }

and `grep -r PEM_read_bio_X509_AUX` will get nothing :-(
