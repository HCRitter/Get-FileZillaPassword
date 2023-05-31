# Get-FileZillaPassword
A PowerShell script for exporting the 'Server' nodes from the 'Sitemanager.xml' file.

Description:
------------

This script is designed to iterate through all 'Server' nodes in the Sitemanager.xml file for the current user on the client machine. It exports the properties of these nodes as 'pscustomobjects' and decrypts the stored passwords, which are encrypted in 'Base64'.

The script performs the lookup in the following paths:

- $($env:APPDATA)\FileZilla\sitemanager.xml
- $($Env:Programfiles)\FileZilla FTP Client\docs\fzdefaults.xml
  
It has been tested on the following operating systems:

- Windows 10
- Windows 11
- Windows Server 2012
- Windows Server 2008

The script is compatible with FileZilla version 3.X.
