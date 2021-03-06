#!/bin/bash
# OpusDecode
# Just a simple script that decodes WhatsApp's .opus files to .wav format
# It requires opus-tools to be installed.
# Tested under debian stretch.



if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit -1
fi

RES_DIR="/home/$USER/wa/decoded"
mkdir -p $RES_DIR
find "$1" -name "*.opus" -type f -execdir opusdec "{}" "$RES_DIR/{}.wav" \;

