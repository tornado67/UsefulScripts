#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit -1
fi

RES_DIR="/home/$USER/wa/decoded"
mkdir -p $RES_DIR
find "$1" -name "*.opus" -type f -execdir opusdec "{}" "$RES_DIR/{}.wav" \;

