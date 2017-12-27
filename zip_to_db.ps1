######################################################################  VARIABLE  SECTION   ####################################################################################

    $server_cons_update="C:\ServerUpdate\REPORTS"
    $server_cons_archive="\\server\c$\Arhiv"
    $server_cons_xml="\\server\xml$"
    $temporary = "C:\Temp"
    $cons_server = "\\cons-server\usr_inet"
    $ConnectionString = "connections_string_here"
    $query ="INSERT INTO usr_inbox(usr_source, file_name, source) VALUES (?, ?, 'inet_dir')"
    $ErrorActionPreference = "Stop"
    $ErrCantOpenConnection = "Не могу открыть подключение к БД."
    $Err7zNotInstalled = "Не устанвлен 7z"
    $EventSrc = "Script"
    $MsgExecutionStarted = "Конвертация консов запущена."
    $MsgExecutionEnded = "Конвертация консов завершена."

####################################################################### END  VARIABLE  SECTION   ################################################################################


########################################################################  FUNCTIONS  SECTION   ##################################################################################
    # Функция создает в EventLog'е Application источник $EventSrc, если его нет
    # и пишет $data  в лог.
    function Write-Log {
    
        Param ($data)
        
        if ( -Not [System.Diagnostics.Eventlog]::SourceExists($EventSrc) ) {
        
            New-EventLog -LogName "Application" -Source $EventSrc 
        }

        Write-EventLog -LogName Application -Source $EventSrc -EnTryType Information -EventId 1 -Message $data
    }
       
       # Проверяет  наличие 7z на компьютере,  в лсучае успеха возвращает путь 
       # к исполняемому файлу.
    function Check-7zInstalled(){

        $computername=$env:computername

        $UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 

        $reg=[microsoft.win32.regisTrykey]::OpenRemoteBaseKey('LocalMachine',$env:computername) 

        $regkey=$reg.OpenSubKey($UninstallKey) 

        $subkeys=$regkey.GetSubKeyNames() 

        foreach($key in $subkeys){

            $thisKey=$UninstallKey+"\\"+$key 

            $thisSubKey=$reg.OpenSubKey($thisKey)   

            if ($thisSubKey.GetValue("DisplayName") -eq "7-Zip 16.04 (x64)" ) {
            
                return $thisSubKey.GetValue("InstallLocation")+  "7z.exe"
            }
        }
        return $null
    }

    #Функция возвращает дескриптор открытого подключения если удалось его открыть, иначе выход
    function Connect-ToDb(){
        
        $connection = New-Object System.Data.Odbc.OdbcConnection
        
        $connection.connectionstring=$ConnectionString 
        
        $connection.Open() 
        
        return $connection
    }
        

#Данная функция
    function Push-ToDb($file, $DbConnection){
        
        if ( -Not ( $DbConnection.State -eq  [System.Data.ConnectionState]::Open) ){ # Если не открылось 
        
              $DbConnection.Open() # пробуем еще раз
              
              if ( -Not ( $DbConnection.State -eq  [System.Data.ConnectionState]::Open) ){ # Если не открылось снова, видимо не судьба и надо
              
                  Write-Log ( $ErrCantOpenConnection ) #написать у лог
                  
                  Remove-Item $file  #и зачистить свидетелей
                  
                  exit #выйти
              
              }
        } 
        $fileContentEncoded = [System.Convert]::ToBase64String((get-content $file -encoding byte)) #Кодирует содержимое файла в base64
        
        $FileName =  [System.IO.Path]::GetFileName($File) #Получает имя файла
        
        $OdbCommand = new-object System.Data.Odbc.OdbcCommand($query,$DbConnection)     #Инициализирует экземпляр класса, представляющий собой комманду к БД
        
        $OdbCommand.Parameters.AddWithValue("@usr_source", $fileContentEncoded); #Подставляет нужные значения в комманду
        
        $OdbCommand.Parameters.AddWithValue("@file_name",  $FileName);#Подставляет нужные значения в комманду #
        
        $OdbCommand.ExecuteNonQuery() #Выполняет команду
       
    }


########################################################################    END FUNCTIONS  SECTION  ##################################################################################


#############################################################################  EXECUTION  SECTION   ##################################################################################

    $DateTime = Get-Date
    
    Write-Log ($MsgExecutionStarted + $DateTime)
    
    $7zIsInstalled=Check-7zInstalled  # если 7z не установлен
    
    if (!$7zIsInstalled )
    {
        Write-Log ($Err7zNotInstalled)
        exit
    }
     Set-Alias SevenZip $7zIsInstalled
     
     $DbConnection=Connect-ToDb  #подключаемся к базе
     
     $Archives=get-childitem $server_cons_update | where {$_.extension -eq ".zip"} | % { $_.FullName }
     
        foreach ($archive in $Archives) {
            SevenZip e "$archive" "-o$temporary" "*.usr" -y    #разархивируем файл во временную директорию 
            
            $usr_file=get-childitem $temporary | where {$_.extension -eq ".usr"} | ForEach-Object -Process {$_.FullName} #получаем полный путь к файлу
            
            foreach ($file in $usr_file){ # на случай если по какй т причине файлов несклько
                
                Push-ToDb($file,$DbConnection)    #пушим файл в БД
                
                Remove-Item $file   #удаляем временный файл
            
            }
            
            Copy-Item $archive $server_cons_archive #копируем в отработку
            
            Remove-Item $archive     #удаляем архив чтобы в случае проблем  с соединением оставался не архив а лишь разархивированный файл который будет закинут при следующем проходе скрипта
            
        }
        
        $DbConnection.Close() # Закрываем соединение
        
    $DateTime = Get-Date    
    
    Write-Log ($MsgExecutionEnded + $DateTime)

###########################################################################  END EXECUTION  SECTION   #####################################################################################
