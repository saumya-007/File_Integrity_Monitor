Write-Host "What would you like to do?"
Write-Host "1) Collect new baseline?"
Write-Host "2) Begin monitoring files with saved BaseLine?"

$response = Read-Host -Prompt "please enter '1' or '2'"

Function Calculate-Hash-Value($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-ifExist (){
    if (Test-Path -Path .\baseline.txt){
        #Delete the existing baseline file
        Remove-Item -Path .\baseline.txt
    }
}

#calculating the hash from target file and storing it in baseline.txt
if ($response -eq "1"){
    #delete baseline if it already exist
    Erase-Baseline-ifExist

    #collect all files in the target folder
    $files = Get-ChildItem -Path .\Files

    #for each file, calculating the hash, and writing to baseline.txt
    foreach ($item in $files) {
        $hash = Calculate-Hash-Value $item.FullName
        "$($hash.path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }

}

#start monitoring files with saved baseline
elseif ($response -eq "2"){
    
    #creating an empty dictionary
    $fileHashDictionary = @{}
    
    #Loading file|hash from baseline to store in new  dictionary created
    $PathsAndHashes = Get-Content -Path .\baseline.txt
    foreach ($item in $PathsAndHashes){
        $fileHashDictionary.add($item.Split("|")[0],$item.Split("|")[1])
    }

    #continuously monitoring the files in the folder to look for change
    while($true){
        Start-Sleep -Seconds 1
        
         #collect all files in the target folder
        $files = Get-ChildItem -Path .\Files

        #for each file, calculate the hash, and write to baseline.txt
        foreach ($item in $files) {
                $hash = Calculate-Hash-Value $item.FullName
                if ($fileHashDictionary[$hash.Path] -eq $null){
                    #A file has been added
                    Write-Host "New File has been added : $($hash.Path) " -ForegroundColor Cyan
                }else{
                    #A file has been altered
                    if ($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                        #no change
                    }else{
                        Write-Host "File has been changed : $($hash.Path)" -ForegroundColor Yellow

                    }
                }
            }
        foreach ($key in $fileHashDictionary.Keys){
            $fileExist = Test-Path -Path $key
                if (-Not $fileExist){
                    #A File has been deleted
                    Write-Host "A File has been deleted : $($key)" -ForegroundColor Red
                }
            }
        }
}