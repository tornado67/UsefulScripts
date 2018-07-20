#!/bin/bash
SQUID_LOG=/var/log/squid/access.log

grep -i denie $SQUID_LOG | sed -n -e 's/^.*http*:\/\///p' | sed  -e 's/www\.//p' | cut -d '/' -f 1 | sort | uniq -c  | sort -nr
