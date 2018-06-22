######################################################################  VARIABLE  SECTION   ####################################################################################

    $server_cons_update="C:\ServerUpdate\REPORTS"
    $server_cons_archive="\\server\c$\Arhiv"
    $server_cons_xml="\\server\xml$"
    $temporary = "C:\ConsConverter\Temp"
    $cons_server = "\\server\usr_inet"
    $ConnectionString = "connection_string_should_be_here"
    $query ="INSERT INTO usr_inbox(usr_source, file_name, source) VALUES (?, ?, 'inet_dir')"
    $ErrorActionPreference = "Stop"
    $ErrCantOpenConnection = "Не могу открыть подключение к БД."
    $Err7zNotInstalled = "Не устанвлен 7z"
    $EventSrc = "Script"
    $MsgExecutionStarted = "Конвертация консов запущена."
    $MsgExecutionEnded = "Конвертация консов завершена."

####################################################################### END  VARIABLE  SECTION   ################################################################################


########################################################################  FUNCTIONS  SECTION   ##################################################################################

    #Проверяем, есть ли права админа. 
    function Check-IsAdmin { 
	(
	    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
	}
	
	

    # Функция создает в EventLog'е Application источник $EvebtSrc, если его нет
    # и пишет $data  в лог. ФУНКЦИЯ РАБОТАЕТ НАЧИНАЯ С POWERSHELL 3.0
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

    #Функция возвращает дескриптор подключения 
    function Connect-ToDb(){
        
        $connection = New-Object System.Data.Odbc.OdbcConnection
        $connection.connectionstring=$ConnectionString 
        $connection.Open() 
        return $connection
    }
        

#Данная функция
    function Push-ToDb($file, $DbConnection){
      
        if ( -Not ( $DbConnection.State -eq  [System.Data.ConnectionState]::Open) ){ # Если не открылось 
        
              $DbConnection=Connect-ToDb # пробуем еще раз
              
              if ( -Not ( $DbConnection.State -eq  [System.Data.ConnectionState]::Open) ){ # Если не открылось снова, видимо не судьба и надо
              
                  #Write-Log ( $ErrCantOpenConnection ) #написать у лог
                  
                  Remove-Item $file  # зачистить свидетелей
                  
                  exit -2 #и выйти
              
              }
        } 
		
				
        $fileContentEncoded = [System.Convert]::ToBase64String((get-content $file -encoding byte)) #Кодирует содержимое файла в base64
        $FileName =  [System.IO.Path]::GetFileName($file) #Получает имя файла
        $OdbCommand = new-object System.Data.Odbc.OdbcCommand($query,$DbConnection)     #Инициализирует экземпляр класса, представляющий собой комманду к БД
        $OdbCommand.Parameters.AddWithValue("@usr_source", $fileContentEncoded); #Подставляет нужные значения в комманду
        $OdbCommand.Parameters.AddWithValue("@file_name",  $FileName);#Подставляет нужные значения в комманду #
        $OdbCommand.ExecuteNonQuery() #Выполняет команду
       
    }


########################################################################    END FUNCTIONS  SECTION  ##################################################################################


#############################################################################  EXECUTION  SECTION   ##################################################################################

    if (!(Check-IsAdmin)){ #Если скрипт запщуен без прав администратора выбрасываем исключение
	    throw "Administrator rights required to run this script"
 	}

    $DateTime = Get-Date
   # Write-Log ($MsgExecutionStarted + $DateTime)
    $7zIsInstalled=Check-7zInstalled  # если 7z не установлен
    if (!$7zIsInstalled )
    {
        Write-Log ($Err7zNotInstalled)
        exit
    }
     Set-Alias SevenZip $7zIsInstalled
     
     $DbConnection=Connect-ToDb  #подключаемся к базе
	# Write-Host $DbConnection
     
     $Archives=get-childitem $server_cons_update | where {$_.extension -eq ".zip"} | % { $_.FullName }
        foreach ($archive in $Archives) {
            SevenZip e "$archive" "-o$temporary" "*.usr" -y    #разархивируем файл во временную директорию 
            
            $usr_file=get-childitem $temporary | where {$_.extension -eq ".usr"} | ForEach-Object -Process {$_.FullName} #получаем полный путь к файлу
            
            if ($usr_file -eq $null){ #если вдруг по какой-то причине файлов в папке нет запускаем cледующий шаг цикла
		        continue
			}
			
            foreach ($file in $usr_file){ # на случай если по какй-то причине файлов несклько
                
                Push-ToDb $file $DbConnection    #пушим файл в БД
                Remove-Item $file   #удаляем временный файл
            
            }
            
            Copy-Item $archive $server_cons_archive #копируем в отработку
            
            Remove-Item $archive     #удаляем архив чтобы в случае проблем  с соединением оставался не архив а лишь разархивированный файл который будет закинут при следующем проходе скрипта
            
        }
        
        $DbConnection.Close() # Закрываем соединение
    $DateTime = Get-Date    
  # Write-Log ($MsgExecutionEnded + $DateTime)

###########################################################################  END EXECUTION  SECTION   #####################################################################################
