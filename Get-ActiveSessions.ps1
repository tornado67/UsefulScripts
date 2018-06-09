#Скрипт выводит пользователей которые сейчас залогинены на заданных машинах
Invoke-Command -ComputerName R68TS03,R31NATS01,R461CTS02 -ScriptBlock {
        Write-Host; 
        (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name; #выводим на какой машине мы сейчас.
        Write-Host;  
        query user /server:$SERVER  #получаем списко пользователей.
    
    }
