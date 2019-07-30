function Get-AllLoggedOnUser {
    [CmdletBinding()]
    param (
    )
    begin {
        $Profilelist = @()
        try {
            if(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"){
                Write-Verbose -Message "found profilelist key: HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
            }
        }
        catch {
            throw "Not able to find registry path for the profilelist"
        }
        $Profiles = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
        Write-Verbose -Message "collecting all profiles"
    }
    process {
        Write-Verbose -Message "translate SID to readable username"
        foreach($Profile in $Profiles){
            $objSID = New-Object System.Security.Principal.SecurityIdentifier($($Profile.Name| split-path -leaf)) 
            $objUser = $objSID.Translate( [System.Security.Principal.NTAccount]) 
            $ProfileObject = New-Object System.Object
            $ProfileObject | Add-Member -MemberType NoteProperty -Name "SID" -Value $objSID.Value
            $ProfileObject | Add-Member -MemberType NoteProperty -Name "Username" -Value $objUser.Value
            $Profilelist+= $ProfileObject
        }
    }
    end {
        return $Profilelist
    }
}
Get-AllLoggedOnUser -Verbose