#!/bin/bash
# Generate a self-signed cert suitable for lighttpd

[ -n "$1" ] || {
	echo "Usage: $0 domain-name"
	echo "Example: $0 example.org"
	exit 1
}

domain="$1"

# generate private key (public key is built in)
openssl genrsa -out $domain.key 1024 || exit 1

# generate certificate signature request, redirect input from here document
# C/ST/L/O/OU/CN
# Country / STate / Location / Organization / Organization Unit / Common Name
openssl req -new -key $domain.key -out $domain.csr << REQ_EOF || exit 1
US
California
Menlo Park
Earn Money Corporation
R&D Center
$domain
.
.
.
REQ_EOF

# generate self signed certificate
openssl x509 -req -days 3650 -in $domain.csr -extfile /etc/ssl/openssl.cnf \
	-extensions v3_ca -signkey $domain.key -out $domain.crt || exit 1

# print out the certificate
openssl x509 -in $domain.crt -noout -text || exit 1

cat $domain.key $domain.crt > $domain.pem

rm -f $domain.key $domain.csr $domain.crt
echo "ssl.pemfile = \"`pwd`/$domain.pem\""

