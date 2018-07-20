#!/bin/bash
DEFAULT_SQUID_LOG=/var/log/squid/access*
SQUID_LOG=$1

if [ -z $SQUID_LOG]; then
    SQUID_LOG=$DEFAULT_SQUID_LOG
fi

grep -Ri denie $SQUID_LOG | sed -n -e 's/^.*http*:\/\///p' | sed  -e 's/www\.//p' | cut -d '/' -f 1 | sort | uniq -c  | sort -nr | column -t -s' '
