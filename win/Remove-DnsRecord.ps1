 Get-DnsServerResourceRecord -ZoneName <доменная зона> -ComputerName <адрес ДНС сервера>  -Name  "<имя устройства>" |
  Remove-DnsServerResourceRecord -Force -ComputerName <адрес ДНС сервера> -ZoneName <доменная зона>
