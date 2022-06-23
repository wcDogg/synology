#!/bin/bash

## Namecheap DDNS updater for Synology
## Brett Terpstra <https://brettterpstra.com>

PASSWORD="$2"
DOMAIN="$3"
IP="$4"

PARTS=$(echo $DOMAIN | awk 'BEGIN{FS="."} {print NF?NF-1:0}')
# If $DOMAIN has two parts (domain + tld), use wildcard for host
if [[ $PARTS == 1 ]]; then
    HOST='@'
    DOMAIN=$DOMAIN
# If $DOMAIN has a subdomain, separate for HOST and DOMAIN variables
elif [[ $PARTS == 2 ]]; then
    HOST=${DOMAIN%%.*}
    DOMAIN=${DOMAIN#*.}
fi

RES=$(curl -s "https://dynamicdns.park-your-domain.com/update?host=$HOST&domain=$DOMAIN&password=$PASSWORD&ip=$IP")
ERR=$(echo $RES | sed -n "s/.*<ErrCount>\(.*\)<\/ErrCount>.*/\1/p")

if [[ $ERR -gt 0 ]]; then
    echo "badauth"
else
    echo "good"
fi