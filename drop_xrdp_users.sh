#!/bin/bash

    CIFS_FOLDERS=`mount | grep cifs | cut -d " " -f 1` # получаем cifs тома
    
    pgrep -f "\.xsession$"  | xargs kill  # вылавливаем процессы которые занимают файл .xsession и безжалостно убиваем

    for cifs_folder in  $CIFS_FOLDERS; do # перебираем шары 
    
        mount -f -o remount,rw  $cifs_folder #и принудительно перемонтируем

    done
