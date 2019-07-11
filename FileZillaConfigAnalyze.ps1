
#tested for FileZilla Version 3
#

#collect the software installed
$Softwareinstalled = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$FilezillaXMLPath = ""
#check if the software is installed and the version is 3.X
if($Softwareinstalled.Displayname -like "Filezilla*" -and $Softwareinstalled.Displayversion -like "3.*"){
    #Default Path of Sitemanager 
    $FilezillaXMLPath = "$($env:APPDATA)\FileZilla\sitemanager.xml"
    if(test-path -Path $FilezillaXMLPath -ErrorAction SilentlyContinue){
        Write-Output "Filezilla Sitemanager.xml configuration file is stored in the default location"
    }else{
        Write-Warning -Message "Filezilla Sitemanager.xml configuration file is not stored in the default location"
        Write-Output "Check where the file is stored"
        
        $FilezillaDefaultsXMLPath = "$($Env:Programfiles)\FileZilla FTP Client\docs\fzdefaults.xml"
        if(Test-Path -Path $FilezillaDefaultsXMLPath){
            [xml] $FilezillaDefaultsXML = Get-Content -Path $FilezillaDefaultsXMLPath
            $FilezillaXMLPath = $FilezillaDefaultsXML.FileZilla3.Settings.Setting | Where-Object{$_.name -like "Config *"} | Select-Object -ExpandProperty "#text"
            if(-not (Test-Path $FilezillaXMLPath -ErrorAction SilentlyContinuef)){
                Write-Error -Message "The config file location attribute in the Filezilla defaults xml file (fzdefaults.xml) could not be found" -Category InvalidOperation -ErrorId "3"
                break
            }else{
                Write-Output "Found the config file location in the attribute in the Filezilla defaults xml file (fzdefaults.xml)"
            }
        }else{
            Write-Error -Message "not able to locate the Filezilla defaults xml file (fzdefaults.xml) on the system " -Category InvalidOperation -ErrorId "2"
            break
        }
    }
}else{
    Write-Error -Message "Filezilla is not running on this Machine or it is not Version 3.X" -Category InvalidOperation -ErrorId "1"
    break
}

[xml] $filezillaConfig = Get-Content -Path $FilezillaXMLPath
$StoredftpServers = @()
$run = 0
foreach($x in $filezillaConfig.FileZilla3.servers.server){
    $StoredftpServer = New-Object psobject
    $StoredftpServer | Add-Member -MemberType NoteProperty -Name "Name" -Value $X.Name
    $StoredftpServer | Add-Member -MemberType NoteProperty -Name "Host" -Value $X.Host
    $StoredftpServer | Add-Member -MemberType NoteProperty -Name "Port" -Value $X.Port
    $StoredftpServer | Add-Member -MemberType NoteProperty -Name "Username" -Value $X.User
    $StoredftpServer | Add-Member -MemberType NoteProperty -Name "Password" -Value $([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($((((Get-Content -Path $FilezillaXMLPath | Where-Object{$_ -like "*<pass*"} )[$run] -split ">")[1] -split "<")[0]))))
    $StoredftpServers += $StoredftpServer
    $run +=1
}
$StoredftpServers

