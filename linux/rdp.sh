#!/bin/bash

    #PATH=`which rdesktop`
    USER="-u USER_NAME_HERE "
    PASS=" -p - "
    DOMAIN=" -d DOMAIN_HERE"
    GEOMETRY=" -g 1600x830 " #DESKTOP GEOMETRY
    ADDRESS=$1
    PATH=`which rdesktop`
    #Cheking if rdekstop is installed.
    if [[ -z $PATH ]]; then
        echo "rdesktop not installed!"
        exit -1
    fi

    `$PATH $USER $PASS $DOMAIN $GEOMETRY $ADDRESS`













