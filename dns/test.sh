#!/bin/sh

nsupdate  -L 8 <<EOF
server api.dynu.com
zone test.tanzu.rocks
key hmac-sha512:test.tanzu.rocks WQA0ADYAYQBZAGYAMwBmAGUAVQBlADYAVQBYADcANQA0ADUAZAA0AGUANABXADQANgBWAFQANAA0AGQANQA0AA==
update delete test.tanzu.rocks A
update add test.tanzu.rocks 86400 A 72.125.119.22
show
send
answer
EOF
 
#key hmac-sha256:test3.home.tanzu.rocks lcDOsNNZRCiDLyqL6cSHGZRrShYLbXsekojl9ILKxDW09OKOckO+lMzE3Jd62HyxT55yM5D4NugF28sruYwjTg==

