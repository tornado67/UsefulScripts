#!/bin/bash

    #PATH=`which rdesktop`
    USER="-u a.ruzhitski "
    PASS=" -p - "
    DOMAIN=" -d IGC"
    GEOMETRY=" -g 1600x830 "
    ADDRESS=$1
    PATH=`which rdesktop`
    if [[ -z $PATH ]]; then
        echo "rdesktop not installed!"
        exit -1
    fi

    `$PATH $USER $PASS $DOMAIN $GEOMETRY $ADDRESS`













