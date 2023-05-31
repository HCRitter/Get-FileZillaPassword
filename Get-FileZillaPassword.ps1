function Get-FileZillaPassword {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $SiteManagerLocation = $(@("$($env:APPDATA)\FileZilla\sitemanager.xml","$($Env:Programfiles)\FileZilla FTP Client\docs\fzdefaults.xml").ForEach({
            if(Test-Path -Path $PSItem){
                $PSItem
            }
        }))
        if($null -eq $SiteManagerLocation){
            Write-Host "Could not find any Sitemanager.xml"
            return
        }
    }
    
    process {
        foreach($SiteManagerLocationElement in $SiteManagerLocation){
            [xml]$XMLConfig = Get-Content -Path $SiteManagerLocationElement
            if([string]::IsNullOrEmpty($XMLConfig.SelectNodes("//FileZilla3"))){
                Write-Host "Configuration file: '$SiteManagerLocationElement' does not contain FileZilla3 node"
                continue
            }
            $XMLConfig.SelectNodes("//Server").ForEach({
                [PSCustomObject]@{
                    Name = $PSItem.Name
                    Host = $PSItem.Host
                    Port = $PSItem.Port
                    Protocol = $PSItem.Protocol
                    Account = $PSItem.Account
                    User = $PSItem.User
                    Password = $([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($PSItem.Pass.'#text')))
                    LogonType = $(
                        switch ($PSItem.LogonType) {
                            0 { "anonymous"}
                            1 { "User/Password" }
                            2 { "AskForPassword"}
                            3 { "Interactive"}
                            4 { "Account"}
                            Default {$null}
                        }
                    )
                }
            })

        }
    }
    end {
        
    }
}
