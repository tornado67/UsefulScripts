#!/bin/bash

# Extractig certain filds from a CSV file

OLDIFS=$IFS                                                                                                              
IFS=";"                                                                                                                  

while read ufps adm index object address type class functional abbr 
do
    if [ "$functional" = "Да"  ]; then                                                                                  
        too2=0                                                                                                          
    else                                                                                                                
        too2=1                                                                                                          
    fi                                                                                                                                                      
    printf "%s;%s;%s;%s;%s;%s;\n" "$index" "$object" "$ufps" "$adm" "$too2" "$abbr"                 

done < $1                                                                                                               
IFS=$OLDIFS 
