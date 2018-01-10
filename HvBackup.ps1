$hvbackup="C:\Windows\System32\hvbackup\HVBackup.exe"
	 $BackupPath="F:\backup"
	 $OutputFormat = "{0}_{2:yyyy_MM_dd_HH}.zip"
	  #поскольку в powershell 2.0 нет модуля для работы с HV, 
	  function Get-VmNames(){ 
	     #получаем списко виртуалок методом  wmi запроса.
	    return $vms=Get-WMIObject -Class Msvm_ComputerSystem -Namespace "root\virtualization" | where-object{$_.caption -ne "Компьютерная система для размещения"} | ForEach-Object -Process {$_.ElementName}
		
	  }
	   
	 function Backup-VM ($name){
		Set-Alias hvbackup $hvbackup 
		hvbackup -l "$name" -o "$BackupPath" --outputformat "$OutputFormat"
	  }
	 # зачистка старых бекапов. (Старый - сделанный при предыдущем проходе)
	 
         function Rotate-Backups {
	      
	     $BackupFileNames = Get-ChildItem $BackupPath -Name "*.zip" #получаем список бекапов
		 foreach ($BackupFileName in $BackupFileNames)
		 {
			$BackupFullPath = "$BackupPath\$BackupFileName"
			foreach ($Backup in $BackupFullPath){
				$BackupCreationTime=(Get-ChildItem $Backup).CreationTime.Date 
				 if(-Not($BackupCreationTime -eq (get-date).Date )){    #если бекап сделан не сегодня
					Write-Host "Removing $backup"
					Remove $backup    #удалим его
		 		}
		 	}
		 
	 	 }
		 
	 }
	 
	 foreach ($vm in Get-VmNames ){
	    Backup-VM $vm
	
     }
     
     Rotate-Backups
