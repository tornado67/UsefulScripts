	 $hvbackup="C:\Windows\System32\hvbackup\HVBackup.exe"
	 $BackupPath="F:\backup"
	 $OutputFormat = "{0}_{2:yyyy_MM_dd_HH}.zip"
	  #поскольку в powershell 2.0 нет модуля для работы с HV, 
	  function Get-VmNames(){ 
	     #получаем списко виртуалок методом  wmi запроса.
	    return $vms=Get-WMIObject -Class Msvm_ComputerSystem -Namespace "root\virtualization" | where-object{$_.caption -ne "Компьютерная система для размещения"} 
	  }
	   
	  function Backup-VM ($name){
		Set-Alias hvbackup $hvbackup 
		hvbackup -l "$name" -o "$BackupPath" --outputformat "$OutputFormat"
	  }
	
	 foreach ($vm in Get-VmNames ){
	
		Backup-VM "$vm" 
	
     }
		
	
