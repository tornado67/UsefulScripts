#converting .mts video to .mp4


    $path = "C:\Users\envy\Desktop\video\" 
    $file_names = Get-ChildItem "C:\Users\envy\Desktop\video\*.MTS" -Name

    Set-Alias  -Name ffmpeg -Value "C:\Program Files (x86)\ffmpeg\bin\ffmpeg.exe"

 
    $i=1;
    foreach ($file_name in $file_names){
        $i++
        Write-Progress -Activity "Convering your fucking video..." -PercentComplete (($i/$file_names.Count)*100)  -Status "Please wait."
        $res_file_name= $file_name -replace "MTS","mp4"
        ffmpeg   -i "$path\$file_name" "D:\video\$res_file_name" -f mp4 -acodec aac -preset slow -hide_banner
    
    }
