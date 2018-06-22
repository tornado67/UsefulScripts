[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 #Чтобы раблотал TLS
(New-Object System.Net.WebClient).DownloadFile("https_url","file_name");
