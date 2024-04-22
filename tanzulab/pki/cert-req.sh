#!/bin/bash

export CERTNAME=root-ca
export FQDN=tanzu.playpen
export IP='supervisor1.tanzu.playpen'

openssl req -new -sha256 -nodes -days 1095 -out $CERTNAME.csr -newkey rsa:2048 -keyout $CERTNAME.key -config <( 
cat <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[ dn ]
C = In
L = lab
CN = $FQDN
[ req_ext ]
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = $FQDN
IP.1 = $IP
EOF
)

# At Windows CA Powershell window

# Identifiy template
# get-catemplate

# Import requests
# certreq -submit -attrib "CertificateTemplate:WebServer"


