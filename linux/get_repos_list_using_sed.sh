#!/bin/bash

sed -n  '/http/p' /etc/yum.repos.d/*  | sed -E -e '/^#.*/d' -e 's/^baseurl=|metalink=|mirrorlist=//g'
